`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:06 10/28/2006 
// Design Name: 
// Module Name:    TransmitFSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TransmitFSM(Clock, Reset, DIn, SO, SFD, SrcAddr, DstAddr, InRequest, InValid, CCA, Command, TransmitDone, CurState);
   input Clock;
   input Reset;
   input [31:0] DIn;
   input [7:0] SO;
   input SFD;
	input [7:0] SrcAddr;
	input [7:0] DstAddr;
	input InRequest;
	input CCA;
	output InValid;
   output [7:0] Command;
   output TransmitDone;
	output [4:0] CurState;

	reg [7:0]	Command;
	reg [4:0]	CurState;
	reg [4:0]	NextState;
	reg StartWait;
	wire [15:0]	CCATime;
	reg TransmitDone;
	reg InValid;
	reg CCAHold;
	
	wire [15:0]	Waited;
	wire [15:0] CCAInitial;
	//wire [15:0] CCAIntermed;
	
	parameter STATE_WaitTrans = 5'h00;
	parameter STATE_TransAddr = 5'h01;
	parameter STATE_Trans6 = 5'h07;
	parameter STATE_Trans7 = 5'h08;
	parameter STATE_Trans8 = 5'h09;
	parameter STATE_Trans9 = 5'h0A;
	parameter STATE_Trans10 = 5'h0B;
	parameter STATE_Trans11 = 5'h0C;
	parameter STATE_Trans12 = 5'h0D;
	parameter STATE_Trans13 = 5'h0E;
	parameter STATE_Trans14 = 5'h0F;
	parameter STATE_CheckCCA = 5'h10;
	parameter STATE_CCAWait = 5'h11;
	parameter STATE_WaitSTXON = 5'h12;
	parameter STATE_STXON = 5'h13;
	parameter STATE_FinSTXON = 5'h14;
	parameter STATE_WaitSFD1 = 5'h15;
	parameter STATE_WaitSFD2 = 5'h16;
	parameter STATE_SRXON = 5'h17;
	parameter STATE_WaitSymbol = 5'h18;
	parameter STATE_TransDone = 5'h19;
	
	Counter			CCATimer(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(1'b1), .In(16'h0000), .Count(CCAInitial));
						defparam CCATimer.width = 16;
	Counter			CCAWaiting(.Clock(Clock), .Reset(Reset | ~StartWait), .Set(1'b0), .Load(1'b0), .Enable(StartWait), .In(16'h0000), .Count(Waited));
						defparam CCAWaiting.width = 16;
						
	Register			CCAHolder(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(CCAHold), .In({	CCAInitial[0],
																															CCAInitial[1],
																															CCAInitial[2],
																															CCAInitial[3],
																															CCAInitial[9],
																															CCAInitial[5],
																															CCAInitial[6],
																															CCAInitial[7],
																															CCAInitial[8],
																															CCAInitial[4],
																															CCAInitial[10],
																															CCAInitial[11],
																															CCAInitial[12],
																															CCAInitial[14],
																															CCAInitial[13],
																															CCAInitial[15]}
																													), .Out(CCATime));
						defparam CCAHolder.width = 16;
						
	always@(posedge Clock) begin
		if(Reset)
			CurState <= STATE_WaitTrans;
		else
			CurState <= NextState;
	end
	
	always@( * ) begin
	
		InValid = 1'b0;
		NextState = CurState;
		Command = 8'h00;
		TransmitDone = 1'b0;
		StartWait = 1'b0;
		CCAHold = 1'b0;
		//CCATime = 16'h0000;
		
		case(CurState)
			
			STATE_WaitTrans: begin
				if(InRequest & ~Reset & ~SFD)
					NextState = STATE_TransAddr;
			end
			
			STATE_TransAddr: begin
				if(InRequest)
					NextState = STATE_Trans6;
				
				//Outputs
				Command = 8'h3E;
				InValid = 1'b1;
			end

			STATE_Trans6: begin
				if(InRequest)
					NextState = STATE_Trans7;
				//Outputs
				InValid = 1'b1;
				Command = 8'h08;
			end
			
			STATE_Trans7: begin
				if(InRequest)
					NextState = STATE_Trans8;
			
				//Outputs
				InValid = 1'b1;
				Command = SrcAddr;
			end
			
			STATE_Trans8: begin
				if(InRequest)
					NextState = STATE_Trans9;
			
				//Outputs
				InValid = 1'b1;
				Command = DstAddr;
			end
			
			STATE_Trans9: begin
				if(InRequest)
					NextState = STATE_Trans10;
			
				//Outputs
				InValid = 1'b1;
				Command = DIn[31:24];
			end
			
			STATE_Trans10: begin
				if(InRequest)
					NextState = STATE_Trans11;
			
				//Outputs
				InValid = 1'b1;
				Command = DIn[23:16];			
			end
			
			STATE_Trans11: begin
				if(InRequest)
					NextState = STATE_Trans12;
				//Outputs
				InValid = 1'b1;
				Command = DIn[15:8];			
			end
			
			STATE_Trans12: begin
				if(InRequest)
					NextState = STATE_Trans13;
				
				//Outputs
				InValid = 1'b1;
				Command = DIn[7:0];			
			end
			
			STATE_Trans13: begin
				if(InRequest)
					NextState = STATE_Trans14;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;			
			end
			
			STATE_Trans14: begin
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_CheckCCA;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;			
			end
			
			STATE_CheckCCA: begin
				if(CCA)
					NextState = STATE_WaitSTXON;
				else begin
					NextState = STATE_CCAWait;
					
					//RANDOMIZING
					/*
					CCATime[15] = CCAInitial[0];
					CCATime[14] = CCAInitial[1];
					CCATime[13] = CCAInitial[2];
					CCATime[12] = CCAInitial[3];
					CCATime[11] = CCAInitial[9];
					CCATime[10] = CCAInitial[5];
					CCATime[9] = CCAInitial[6];
					CCATime[8] = CCAInitial[7];
					CCATime[7] = CCAInitial[8];
					CCATime[6] = CCAInitial[4];
					CCATime[5] = CCAInitial[10];
					CCATime[4] = CCAInitial[11];
					CCATime[3] = CCAInitial[12];
					CCATime[2] = CCAInitial[14];
					CCATime[1] = CCAInitial[13];
					CCATime[0] = CCAInitial[15];
					*/
					CCAHold = 1'b1;
				end
					
			end
			
			STATE_CCAWait: begin
				if(Waited == CCATime)
					NextState = STATE_WaitSTXON;
				
				//Outputs
				StartWait = 1'b1;
			end
			
			STATE_WaitSTXON: begin
				if(InRequest)
					NextState = STATE_STXON;
			end
			
			STATE_STXON: begin
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_FinSTXON;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h04;
			end
			
			STATE_FinSTXON: begin
				if(SFD)
					NextState = STATE_WaitSFD1;
			
			end
			
			STATE_WaitSFD1: begin
				if(~SFD)
					NextState = STATE_WaitSFD2;
			end
			
			STATE_WaitSFD2: begin
				if(InRequest & (Waited >= 16'd62))
					NextState = STATE_SRXON;
			
				StartWait = 1'b1;
			end
			
			/*
			STATE_WaitSFD2: begin
				if(InRequest)
					NextState = STATE_SRXON;

			end
			*/
			STATE_SRXON: begin
				if(InRequest)
					NextState = STATE_WaitSymbol;
					
				//InValid = 1'b1;
				//Command = 8'h03;
			end
			
			STATE_WaitSymbol: begin
				if(Waited >= 16'd5184)
					NextState = STATE_TransDone;
				
				//Outputs
				StartWait = 1'b1;
			end
			
			STATE_TransDone: begin
								
				TransmitDone = 1'b1;
			end
			
			default: begin
			end
			
		endcase
	
	end
	


endmodule
