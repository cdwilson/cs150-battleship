
module RadioArbit(Clock,
						Reset,
						SendReadyIn,
						RecReadyIn,
						TSrcAddrIn, 
						TDestAddrIn,
						TSrcAddrOut,
						TDestAddrOut,
						RecDataIn,
						SendOut, 
						RecOut,
						SendDataOut,
						TChannelOut,
						SendReadyOut, 
						RecReadyOut,
						GSrcAddrOut, 
						GDestAddrOut,
						GSrcAddrIn,
						GDestAddrIn,
						RecDataOut,
						SendIn, 
						RecIn,
						SendDataIn,
						GChannelIn);
						
	//-----------------------------------------------------------------
	// Input / Output
	//-----------------------------------------------------------------
	//System I/0
	input 				Clock;
	input 				Reset;
	
	//Interface to Radio
	input					SendReadyIn, RecReadyIn;
	input		[7:0]		TSrcAddrIn, TDestAddrIn;
	output	[7:0]		TSrcAddrOut, TDestAddrOut;
	input		[31:0]	RecDataIn;
	output				SendOut, RecOut;
	output	[31:0]	SendDataOut;
	output	[3:0]		TChannelOut;
	
	//Interface to Game Engine
	output				SendReadyOut, RecReadyOut;
	output	[7:0]		GSrcAddrOut, GDestAddrOut;
	input		[7:0]		GSrcAddrIn, GDestAddrIn;
	output	[31:0]	RecDataOut;
	input					SendIn, RecIn;
	input		[31:0]	SendDataIn;
	input		[3:0]		GChannelIn;
	
	//-----------------------------------------------------------------
	// Wires / Regs
	//-----------------------------------------------------------------
	
	//-----------------------------------------------------------------
	// Assigns
	//-----------------------------------------------------------------
	assign RecReadyOut = RecReadyIn;
	assign RecDataOut = RecDataIn;
	assign GSrcAddrOut = TSrcAddrIn;
	assign GDestAddrOut = TDestAddrIn;
	assign TChannelOut = GChannelIn;
	assign TSrcAddrOut = GSrcAddrIn;
	assign TDestAddrOut = GDestAddrIn;
	assign RecOut = RecIn;
	
	//replace with actual logic later
	//assign SendReadyOut = SendReadyIn;
	//assign SendOut = SendIn;
	//assign SendDataOut = SendDataIn;

	wire 	[31:0]	SendDataOut;
	wire	[1:0]		NumSent;
	wire	[19:0]	Time;
	
	Register		SendReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(SendIn), .In(SendDataIn), .Out(SendDataOut));
	Counter Timer(.Clock(Clock), .Reset(Reset | ~TimerEn), .Set(1'b0), .Load(1'b0), .Enable(TimerEn), .In(23'h0), .Count(Time));
				defparam Timer.width = 20;
	
	
	reg[2:0]			CurState;
	reg[2:0]			NextState;
	//reg[31:0]		SendDataOut;
	reg				SendOut;
	reg				SendReadyOut;
	reg				TimerEn;
	
	parameter		STATE_Init = 3'h0;
	parameter		STATE_Send1 = 3'h1;
	parameter		STATE_Send1Wait = 3'h2;
	parameter		STATE_Send2 = 3'h3;
	parameter		STATE_Send2Wait = 3'h4;
	parameter		STATE_Send3 = 3'h5;
	parameter		STATE_Send3Wait = 3'h6;
	
	always @(posedge Clock) begin
		if(Reset)
			CurState <= STATE_Init;
		else
			CurState <= NextState;
	end
	
	always @ ( * ) begin
		NextState = CurState;
		SendOut = 1'b0;
		SendReadyOut = 1'b0;
		TimerEn = 1'b0;
		
		case(CurState)
			STATE_Init: begin
				if(SendIn)
					NextState = STATE_Send1;
					
				SendReadyOut = SendReadyIn;
			end
			
			STATE_Send1: begin
				NextState = STATE_Send1Wait;
								
				SendOut = 1'b1;
			end
			
			//Sent 1st one, waiting to send 2nd
			STATE_Send1Wait: begin
				if(SendReadyIn & (Time==20'd675000))
					NextState = STATE_Send2;
				
				TimerEn = 1'b1;
			end
			
			STATE_Send2: begin
				NextState = STATE_Send2Wait;
				
				SendOut = 1'b1;
			end
			
			STATE_Send2Wait: begin
				if(SendReadyIn & (Time==20'd675000))
					NextState = STATE_Send3;
				TimerEn = 1'b1;
			end
			
			STATE_Send3: begin
				NextState = STATE_Send3Wait;
				
				SendOut = 1'b1;
			end
			
			STATE_Send3Wait: begin
				if(SendReadyIn & (Time==20'd675000))
					NextState = STATE_Init;
				TimerEn = 1'b1;
			end
		
		
		endcase
	end
	
endmodule
