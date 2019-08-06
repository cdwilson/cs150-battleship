//Charlie Lin
//EECS 150

//------------------------------------------
//ControlFSM
//Description: N64 module's main control module
//sends and receives signals to the Sender and Receiver blocks
//------------------------------------------

module ControlFSM(Clock, Reset, Rec_Reset, Rec_en, Send_en, Send_Ctrl, Rec_Status, Send_done, Timeout, OutValid, State);

	//////////////////////////////////////////
	//Inputs/Outputs
	//////////////////////////////////////////
	
	input Send_done, Timeout, OutValid;
	input Clock, Reset;
	
	output Rec_Reset, Rec_en, Send_en, Send_Ctrl, Rec_Status;
	
	output [2:0] State;
	
	//////////////////////////////////////////
	//Regs
	//////////////////////////////////////////
	reg[2:0] CurState, NextState;
	wire [15:0] Time;
	wire CountEn;
	wire CountReset;
	
	reg Rec_Reset, Rec_en, Send_en, Send_Ctrl, Rec_Status;
	
	//////////////////////////////////////////
	//Instantiations
	//////////////////////////////////////////	
	Counter			Timer(.Clock(Clock), .Reset(Reset | CountReset), .Set(1'b0), .Load(1'b0), .Enable(CountEn), .In(16'h0000), .Count(Time));
						defparam Timer.width = 16;
	
	parameter      STATE_Init =           	3'h0;
   parameter      STATE_Send_Re =        	3'h1;
   parameter      STATE_Rec =            	3'h2;
   parameter      STATE_Send_Get =       	3'h3;
   parameter      STATE_Wait =           	3'h4;
	parameter		STATE_Rec_Toss = 			3'h5;

	assign CountEn = ((CurState == STATE_Init) | (CurState == STATE_Wait) | (CurState == STATE_Rec_Toss));
	assign CountReset = Reset | ~CountEn;
	assign State = CurState;
	
	always@(posedge Clock) begin
		if(Reset)
			CurState <= STATE_Init;
		else
			CurState <= NextState;
			
	end
	
	always@( * ) begin
		NextState = CurState;
		Rec_Reset = 1'b0;
		Rec_en = 1'b0;
		Send_en = 1'b0;
		Send_Ctrl = 1'b0;
		Rec_Status = 1'b0;
		
		case(CurState)
			STATE_Init: begin
				if(Time >= 16'h0EC4)  //3780
					NextState = STATE_Send_Re;
					
				Rec_Reset = 1'b1;
			end
			
			STATE_Send_Re: begin
				if (Send_done)
					NextState = STATE_Rec_Toss;
				
				//Outputs
				Send_en = 1'b1;
				Send_Ctrl = 1'b1;
				Rec_Reset = 1'b1;
				
			end
			
			STATE_Rec_Toss: begin
				if(Time >= 16'h1518)  //5400
					NextState = STATE_Send_Get;
				
				//if(OutValid)
				//	NextState = STATE_Send_Get;
				//else if(Timeout)
				//	NextState = STATE_Send_Re;
				
				//Outputs
				//Rec_en = 1'b1;
				//this is the state where we toss out what we receive
			end
			
			STATE_Rec: begin
				if(OutValid)
					NextState = STATE_Wait;
				else if(Timeout)
					NextState = STATE_Send_Re;
				
				//Outputs
				Rec_en = 1'b1;
				Rec_Status = 1'b1;
			end
			
			STATE_Send_Get: begin
				if(Send_done)
					NextState = STATE_Rec;
				
				//Outputs
				Send_en = 1'b1;
				Send_Ctrl = 1'b0;
				Rec_Reset = 1'b1;
			end
			
			STATE_Wait: begin
				if(Time >= 16'h0036)    //108  //UPDATE->54 -> 162
					NextState = STATE_Send_Get;
					
				Rec_Reset = 1'b1;
			
			end
			
			
			default: begin
			end
		endcase
	end
	
endmodule
