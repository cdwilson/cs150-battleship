`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:37 10/29/2006 
// Design Name: 
// Module Name:    ChangeChannelFSM 
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
module ChangeChannelFSM(Clock, Reset, ChEn, InRequest, InValid, NewChannel, Command, ChangeDone, CurState);
   input Clock;
   input Reset;
	input ChEn;
	input InRequest;
   input [3:0] NewChannel;
    
	output [7:0] Command;
	output [3:0] CurState;
	output ChangeDone;
	output InValid;
	
	wire [15:0] FSCommand;
	reg TimerEn;
	reg TimerRe;
	wire [12:0] Time;
	reg [7:0] Command;
	reg [3:0] CurState;
	reg [3:0] NextState;
	reg ChangeDone;
	reg InValid;
	
	assign FSCommand[15:10] = 6'b010000;
	assign FSCommand[9:0] = 10'd357 + 5*(NewChannel);
	
	
	Counter		Timer(.Clock(Clock), .Reset(TimerRe), .Set(1'b0), .Load(1'b0), .Enable(TimerEn), .In(13'h000), .Count(Time));
					defparam Timer.width = 13;
	
	parameter STATE_Init = 4'h0;
	parameter STATE_WaitFSCTRL = 4'h1;
	parameter STATE_FSCTRL1 = 4'h2;
	parameter STATE_FSCTRL2 = 4'h3;
	parameter STATE_FSCTRL3 = 4'h4;
	parameter STATE_SRFWait = 4'h5;
	parameter STATE_SRFOFF = 4'h6;
	parameter STATE_SRXWait = 4'h7;
	parameter STATE_SRXOn = 4'h8;
	parameter STATE_WaitSymbol = 4'h9;
	parameter STATE_ChngDone = 4'hA;
	
	always@(posedge Clock) begin
		if(Reset)
			CurState <= STATE_WaitFSCTRL;
		else
			CurState <= NextState;
	end
	
	
	always@( * )	begin
		NextState = CurState;
		ChangeDone = 1'b0;
		Command = 8'h00;
		InValid = 1'b0;
		TimerEn = 1'b0;
		TimerRe = 1'b1;
				
		case(CurState)
			//STATE_Init: begin
			//	if(ChEn)
			//		NextState = STATE_WaitFSCTRL;
			//	
			//end
			
			STATE_WaitFSCTRL: begin
				if(InRequest & ~Reset)
					NextState = STATE_FSCTRL1;
			end
			
			STATE_FSCTRL1: begin
				if(InRequest)
					NextState = STATE_FSCTRL2;
					
				//Output
				InValid = 1'b1;
				Command = 8'h18;
			end
			
			STATE_FSCTRL2: begin
				if(InRequest)
					NextState = STATE_FSCTRL3;
					
				//Output
				InValid = 1'b1;
				Command = FSCommand[15:8];
				
			end
			
			STATE_FSCTRL3: begin
				if(InRequest)
					NextState = STATE_SRFWait;
				
				//Output
				InValid = 1'b1;
				Command = FSCommand[7:0];
			end
			
			STATE_SRFWait: begin
				if(InRequest)
					NextState = STATE_SRFOFF;
					
			end
			
			STATE_SRFOFF: begin
				if(InRequest)
					NextState = STATE_SRXWait;
				
				//output
				InValid = 1'b1;
				Command = 8'h06;
			end

	
			STATE_SRXWait: begin
				if(InRequest)
					NextState = STATE_SRXOn;
			
			end
			
			STATE_SRXOn: begin
				if(InRequest)
					NextState = STATE_WaitSymbol;
					
				//Outputs
				InValid = 1'b1;
				Command = 8'h03;
			end
			
						
			STATE_WaitSymbol: begin
				
				if(Time >= 13'd5184)
					NextState = STATE_ChngDone;
			
				TimerEn = 1'b1;
				TimerRe = 1'b0;
			end
			
			STATE_ChngDone: begin
				//Output
				ChangeDone = 1'b1;
			end
		
			default: begin
			end
		endcase
	
	end

endmodule
