`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:38:12 10/27/2006 
// Design Name: 
// Module Name:    InitFSM 
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
module InitFSM(Clock, Reset, InRequest, VREG_EN, RF_RESET, Command, SO, InValid, InitDone, CurState);
   input Clock;
   input Reset;
   input InRequest;
	input [7:0] SO;
   output VREG_EN;
   output RF_RESET;
   output [7:0] Command;
	output InValid;
	output InitDone;
	output [4:0] CurState;

	reg [4:0] CurState;
	reg [4:0] NextState;
	reg RF_RESET;
	reg VREG_EN;
	reg [7:0] Command;
	reg TimeEn;
	reg InValid;
	reg InitDone;
	//wire  TimeEn;
	wire	[7:0]	SO;
	wire  [15:0] Time;
	
	
	Counter			Timer(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(TimeEn), .In(16'h0000), .Count(Time));
						defparam Timer.width = 16;
						
	//23 states
	parameter		STATE_AssVREG = 5'h00;
	parameter		STATE_PulseRe1 = 5'h01;
	parameter		STATE_PulseRe2 = 5'h02;
	parameter		STATE_PulseRe3 = 5'h03;
	parameter		STATE_WaitSXOSCON = 5'h04;
	parameter		STATE_SXOSCON = 5'h05;
	parameter		STATE_Check6High = 5'h06;
	parameter		STATE_SendNOOP = 5'h07;
	parameter		STATE_WaitMDM = 5'h08;
	parameter		STATE_MDM1 = 5'h09;
	parameter		STATE_MDM2 = 5'h0A;
	parameter		STATE_MDM3 = 5'h0B;
	parameter		STATE_WaitIOCFG = 5'h0C;
	parameter		STATE_IOCFG1 = 5'h0D;
	parameter		STATE_IOCFG2 = 5'h0E;
	parameter		STATE_IOCFG3 = 5'h0F;
	parameter		STATE_WaitChange = 5'h10;
	parameter		STATE_Change1 = 5'h11;
	parameter		STATE_Change2 = 5'h12;
	parameter		STATE_Change3 = 5'h13;
	parameter		STATE_WaitSRFOFF = 5'h14;
	parameter		STATE_SRFOFF = 5'h15;
	parameter		STATE_WaitSRXON = 5'h16;
	parameter		STATE_SRXON = 5'h17;
	parameter		STATE_DONE = 5'h18;
	parameter		STATE_WaitSymbol = 5'h19;
	parameter		STATE_WaitFlush = 5'h1A;
	parameter		STATE_Flush = 5'h1B;
	parameter		STATE_Flush2 = 5'h1C;
	
	always@(posedge Clock)	begin
		if(Reset)
			CurState <= STATE_AssVREG;
		else
			CurState <= NextState;
	end
	
	always@( * ) begin
		Command = 8'h00;
		RF_RESET = 1'b1;
		VREG_EN = 1'b1;
		TimeEn = 1'b0;
		InValid = 1'b0;
		InitDone = 1'b0;
		
		NextState = CurState;
		
		case(CurState)
			STATE_AssVREG: begin
				if(Time == 16'd54000)
					NextState = STATE_PulseRe1;
				
				//Outputs
				TimeEn = 1'b1;
			
			end
			
			STATE_PulseRe1: begin
				NextState = STATE_PulseRe2;
				
				//Outputs
				RF_RESET = 1'b0;
			end
			
			STATE_PulseRe2: begin
				NextState = STATE_PulseRe3;
				
				//Outputs
				RF_RESET = 1'b0;
			
			end
			
			STATE_PulseRe3: begin
				NextState = STATE_WaitSXOSCON;
				
				//Outputs
				RF_RESET = 1'b0;
			
			end
			
			STATE_WaitSXOSCON: begin
				if(InRequest)
					NextState = STATE_SXOSCON;
			
			end

			STATE_SXOSCON: begin
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_Check6High;
				
				//Outputs
				InValid = 1'b1;
				Command = 8'h01;
			end
			
			STATE_Check6High: begin
			
				if(SO[6])
					NextState = STATE_WaitMDM;
				else if(~SO[6] & InRequest)
					NextState = STATE_SendNOOP;
					
				//Outputs
				
			end
			
			STATE_SendNOOP: begin
			
				//if(~InRequest)
				if(InRequest)	
					NextState = STATE_Check6High;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_WaitMDM: begin
			
				if(InRequest)
					NextState = STATE_MDM1;
			
			end
			
			STATE_MDM1: begin
			
				if(InRequest)
					NextState = STATE_MDM2;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h11;
			
			end
			
			STATE_MDM2: begin
				if(InRequest)
					NextState = STATE_MDM3;
				//Outputs
				InValid = 1'b1;
				Command = 8'h02;
			end
			
			STATE_MDM3: begin
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_WaitIOCFG;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'hE2;
			end
			
			STATE_WaitIOCFG: begin
				if(InRequest)
					NextState = STATE_IOCFG1;
			
			end
			
			STATE_IOCFG1: begin
			
				if(InRequest)
					NextState = STATE_IOCFG2;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h1C;
			end
			
			STATE_IOCFG2: begin
			
				if(InRequest)
					NextState = STATE_IOCFG3;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_IOCFG3: begin
			
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_WaitChange;
				//Outputs
				InValid = 1'b1;
				Command = 8'h20;
			end
			
			STATE_WaitChange: begin
				
				if(InRequest)
					NextState = STATE_Change1;
					
				
			end
			
			STATE_Change1: begin
				
				if(InRequest)
					NextState = STATE_Change2;
					
				//Outputs
				Command = 8'h18;
				InValid = 1'b1;			
			end
			
			STATE_Change2: begin
				
				if(InRequest)
					NextState = STATE_Change3;
				
				//Outputs
				Command = 8'h41;				
				InValid = 1'b1;

			end
			
			STATE_Change3: begin
			
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_WaitSRFOFF;
					
				//Outputs
				Command = 8'h97;
				InValid = 1'b1;			
			end
			
			STATE_WaitSRFOFF: begin
				if(InRequest)
					NextState = STATE_SRFOFF;
			
			end
			
			STATE_SRFOFF: begin
				//if(~InRequest)
				if(InRequest)
					NextState = STATE_WaitSRXON;
				//Outputs
				Command = 8'h06;
				InValid = 1'b1;			
			end
			
			STATE_WaitSRXON: begin
				if(InRequest)
					NextState = STATE_SRXON;
			
			end
			
			STATE_SRXON: begin
				//if(~InRequest)
				if(InRequest) begin
					//NextState = STATE_DONE;
					NextState = STATE_WaitSymbol;
				end
				//Outputs
				InValid = 1'b1;
				Command = 8'h03;
			end
			
			STATE_WaitSymbol: begin
				if(Time >= 16'd5184)
					NextState = STATE_WaitFlush;
				
				TimeEn = 1'b1;
			end
			
			STATE_WaitFlush: begin
				if(InRequest)
					NextState = STATE_Flush;
			end
			
			STATE_Flush: begin
				if(InRequest) begin
					NextState = STATE_Flush2;
				end
				
				InValid = 1'b1;
				Command = 8'h08;
			end
			
			STATE_Flush2: begin
				if(InRequest) begin
					NextState = STATE_DONE;
				end
				
				InValid = 1'b1;
				Command = 8'h08;
			end
			
			STATE_DONE: begin
			
				InitDone = 1'b1;
			
			end
			
			default: begin
			end
			
	
		endcase
	end
	
	
endmodule
