//Author: Chris Wilson cwilson@berkeley.edu
//Notes:

module ReceiveArbit(Clock, Reset, NewData, DIn, SrcAddr, DestAddr, BadData, SrcOut, DestOut, /*DOut, */State);

	//---------------------------------------------------------------
	//	Input / Output
	//----------------------------------------------------------start
   input Clock;
   input Reset;
   input NewData;
   input [7:0] DIn, SrcAddr, DestAddr;
	output BadData;
	output [7:0] SrcOut, DestOut;
   //output [119:0] DOut;
	output [4:0] State;
	//------------------------------------------------------------end
	
	//---------------------------------------------------------------
	//	Wires
	//----------------------------------------------------------start
	wire [7:0] Data_Status;
	wire [7:0] Data_Length;
	wire [7:0] Data_SrcAddr;
	wire [7:0] Data_DestAddr;
	wire [7:0] Data_Payload1;
	wire [7:0] Data_Payload2;
	wire [7:0] Data_Payload3;
	wire [7:0] Data_Payload4;
	wire [7:0] Data_CRC1;
	wire [7:0] Data_CRC2;
	wire [79:0] DOut;
	wire Bad_Length, Bad_Src, Bad_Dest, Bad_CRC, BadData;
	//------------------------------------------------------------end
	
	//---------------------------------------------------------------
	//	Regs
	//----------------------------------------------------------start
	reg		[4:0]		CurrentState, NextState;
	reg
		Status_en,
		Length_en,
		SrcAddr_en,
		DestAddr_en,
		Payload1_en,
		Payload2_en,
		Payload3_en,
		Payload4_en,
		CRC1_en,
		CRC2_en,
		BadData_en;
	//------------------------------------------------------------end
	
	//---------------------------------------------------------------
	//	Parameters
	//----------------------------------------------------------start
	parameter STATE_Init				= 5'd0;
	parameter STATE_Status_en 		= 5'd1;
	parameter STATE_Status 			= 5'd2;
	parameter STATE_Length_en 		= 5'd3;
	parameter STATE_Length 			= 5'd4;
	parameter STATE_SrcAddr_en 	= 5'd5;
	parameter STATE_SrcAddr 		= 5'd6;
	parameter STATE_DestAddr_en	= 5'd7;
	parameter STATE_DestAddr 		= 5'd8;
	parameter STATE_Payload1_en 	= 5'd9;
	parameter STATE_Payload1 		= 5'd10;
	parameter STATE_Payload2_en 	= 5'd11;
	parameter STATE_Payload2 		= 5'd12;
	parameter STATE_Payload3_en 	= 5'd13;
	parameter STATE_Payload3 		= 5'd14;
	parameter STATE_Payload4_en 	= 5'd15;
	parameter STATE_Payload4 		= 5'd16;
	parameter STATE_CRC1_en 		= 5'd17;
	parameter STATE_CRC1 			= 5'd18;
	parameter STATE_CRC2_en 		= 5'd19;
	parameter STATE_CRC2 			= 5'd20;
	parameter STATE_CheckData 		= 5'd21;
	//------------------------------------------------------------end	
	
	//---------------------------------------------------------------
	//	FSM
	//----------------------------------------------------------start
	//for chipscope debugging
	assign State = CurrentState;
	
	always @ ( posedge Clock ) begin
		if (Reset)
			CurrentState <= STATE_Init;
		else
			CurrentState <= NextState;
	end
	
	always @ ( * ) begin
		NextState = CurrentState;
		
		Status_en = 1'b0;
		Length_en = 1'b0;
		SrcAddr_en = 1'b0;
		DestAddr_en = 1'b0;
		Payload1_en = 1'b0;
		Payload2_en = 1'b0;
		Payload3_en = 1'b0;
		Payload4_en = 1'b0;
		CRC1_en = 1'b0;
		CRC2_en = 1'b0;
		BadData_en = 1'b0;
		
		case(CurrentState)
			STATE_Init: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Status_en;
				//Outputs
			end
			
			STATE_Status_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_Length_en;
				else
					NextState = STATE_Status;
				//Outputs
				Status_en = 1'b1;
			end
			
			STATE_Status: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Length_en;
				//Outputs
			end
			
			STATE_Length_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_SrcAddr_en;
				else
					NextState = STATE_Length;
				//Outputs
				Length_en = 1'b1;
			end
			
			STATE_Length: begin
				//State Transition
				if (NewData) 
					NextState = STATE_SrcAddr_en;
				//Outputs
			end
			
			STATE_SrcAddr_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_DestAddr_en;
				else
					NextState = STATE_SrcAddr;
				//Outputs
				SrcAddr_en = 1'b1;
			end
			
			STATE_SrcAddr: begin
				//State Transition
				if (NewData) 
					NextState = STATE_DestAddr_en;
				//Outputs
			end
			
			STATE_DestAddr_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_Payload1_en;
				else
					NextState = STATE_DestAddr;
				//Outputs
				DestAddr_en = 1'b1;
			end
			
			STATE_DestAddr: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Payload1_en;
				//Outputs
			end
			
			STATE_Payload1_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_Payload2_en;
				else
					NextState = STATE_Payload1;
				//Outputs
				Payload1_en = 1'b1;
			end
			
			STATE_Payload1: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Payload2_en;
				//Outputs
			end
			
			STATE_Payload2_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_Payload3_en;
				else
					NextState = STATE_Payload2;
				//Outputs
				Payload2_en = 1'b1;
			end
			
			STATE_Payload2: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Payload3_en;
				//Outputs
			end
			
			STATE_Payload3_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_Payload4_en;
				else
					NextState = STATE_Payload3;
				//Outputs
				Payload3_en = 1'b1;
			end
			
			STATE_Payload3: begin
				//State Transition
				if (NewData) 
					NextState = STATE_Payload4_en;
				//Outputs
			end
			
			STATE_Payload4_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_CRC1_en;
				else
					NextState = STATE_Payload4;
				//Outputs
				Payload4_en = 1'b1;
			end
			
			STATE_Payload4: begin
				//State Transition
				if (NewData) 
					NextState = STATE_CRC1_en;
				//Outputs
			end
			
			STATE_CRC1_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_CRC2_en;
				else
					NextState = STATE_CRC1;
				//Outputs
				CRC1_en = 1'b1;
			end
			
			STATE_CRC1: begin
				//State Transition
				if (NewData) 
					NextState = STATE_CRC2_en;
				//Outputs
			end
			
			STATE_CRC2_en: begin
				//State Transition
				if (NewData)
					NextState = STATE_CheckData;
				else
					NextState = STATE_CRC2;
				//Outputs
				CRC2_en = 1'b1;
			end
			
			STATE_CRC2: begin
				//State Transition
					NextState = STATE_Init;
				//Outputs
				BadData_en = 1'b1;
			end
			
			default: begin
			end
		endcase
	end
	//------------------------------------------------------------end

	//---------------------------------------------------------------
	// Assign Statements
	//----------------------------------------------------------start
	assign BadData = (Bad_Length | Bad_Src | Bad_Dest | Bad_CRC) & BadData_en;
	assign SrcOut = Data_SrcAddr;
	assign DestOut = Data_DestAddr;
	
	assign Bad_Length = (Data_Length != 8'h08);
	//referring to received source or received destination
	//BAD DATA SRC
	assign Bad_Src = ((Data_DestAddr == 8'hff) | (DestAddr == 8'hff)) ? 1'b0 : (DestAddr != Data_SrcAddr);
	assign Bad_Dest = (Data_DestAddr == 8'hff) ? 1'b0 : (SrcAddr != Data_DestAddr);
	//if we have problems, check the crc index here!
	assign Bad_CRC = (Data_CRC2[6] != 1'b1);
	assign DOut = {Data_Status, Data_Length, Data_SrcAddr, Data_DestAddr, Data_Payload1, Data_Payload2,
						Data_Payload3, Data_Payload4, Data_CRC1, Data_CRC2};
	//------------------------------------------------------------end
	
	//---------------------------------------------------------------
	// Instantiations
	//----------------------------------------------------------start
	Register Data_Status_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Status_en), .In(DIn), .Out(Data_Status));
		defparam Data_Status_Reg.width = 8;
		
	Register Data_Length_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Length_en), .In(DIn), .Out(Data_Length));
		defparam Data_Length_Reg.width = 8;
		
	Register Data_SrcAddr_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(SrcAddr_en), .In(DIn), .Out(Data_SrcAddr));
		defparam Data_SrcAddr_Reg.width = 8;
		
	Register Data_DestAddr_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(DestAddr_en), .In(DIn), .Out(Data_DestAddr));
		defparam Data_DestAddr_Reg.width = 8;
		
	Register Data_Payload1_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Payload1_en), .In(DIn), .Out(Data_Payload1));
		defparam Data_Payload1_Reg.width = 8;
		
	Register Data_Payload2_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Payload2_en), .In(DIn), .Out(Data_Payload2));
		defparam Data_Payload2_Reg.width = 8;
		
	Register Data_Payload3_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Payload3_en), .In(DIn), .Out(Data_Payload3));
		defparam Data_Payload3_Reg.width = 8;
		
	Register Data_Payload4_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(Payload4_en), .In(DIn), .Out(Data_Payload4));
		defparam Data_Payload4_Reg.width = 8;	
	
	Register Data_CRC1_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(CRC1_en), .In(DIn), .Out(Data_CRC1));
		defparam Data_CRC1_Reg.width = 8;
		
	Register Data_CRC2_Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(CRC2_en), .In(DIn), .Out(Data_CRC2));
		defparam Data_CRC2_Reg.width = 8;
	//------------------------------------------------------------end	
endmodule
