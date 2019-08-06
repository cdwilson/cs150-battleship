`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:23 10/10/2006 
// Design Name: 
// Module Name:    sender 
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
module Sender(Clock, Reset, Send_En, Code_Control, Dout, Send_Done);
    
	//---------------------------------------------------------------
	//	I/O
	//---------------------------------------------------------------
   input					Clock;
	input					Reset;
	input 				Send_En;
	input 				Code_Control;
	output  				Dout;
	output 				Send_Done;
	//---------------------------------------------------------------
	
	//output [5:0]		regcnt_out;
	
	//---------------------------------------------------------------
	// Parameters
	//---------------------------------------------------------------
	//parameter 	STATE_init =  8'b00000001,
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Intermediate Wires
	//---------------------------------------------------------------
	wire		[35:0]	cc_mux_out;
	wire					pd_out;
	wire					reg_en;
	wire					cnt_reset;
	wire		[4:0]		cnt_out;
	wire		[5:0]		regcnt_out;
	wire					regcnt_reset;
	wire					regcnt_en;
	wire					send_done_int;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Instantiate Submodules
	//---------------------------------------------------------------
	ShiftRegisterN64 			ShiftReg(.PIn(cc_mux_out), .DIn(1'b1), .SOut(Dout), .POut(), .Load(pd_out), .Enable(reg_en), .Clock(Clock), .Reset(Reset));
								defparam		ShiftReg.width = 36;
						
	Counter					MainCount(.Clock(Clock), .Reset(cnt_reset), .Set(1'b0), .Load(1'b0), .Enable(Send_En), .In(5'h00), .Count(cnt_out));
								defparam		MainCount.width = 5;
								
	Counter					RegCount(.Clock(Clock), .Reset(regcnt_reset), .Set(1'b0), .Load(1'b0), .Enable(regcnt_en), .In(6'h00), .Count(regcnt_out));
								defparam		RegCount.width = 6;
						
	RisingEdgeDetector	RiseDetector(.Clock(Clock), .Reset(Reset), .In(Send_En), .Out(pd_out));
	RisingEdgeDetector	SendDoneRiseDetector(.Clock(Clock), .Reset(Reset), .In(send_done_int), .Out(Send_Done));
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Logic
	//---------------------------------------------------------------
	//1
	assign cnt_reset 		= (Reset | pd_out | reg_en);
	//2
	assign regcnt_reset 	= (Reset | pd_out);
	//3
	assign send_done_int	= (regcnt_out == 6'h24); //36
	//4
	assign reg_en 			= (cnt_out == 5'h1B);   //27
	//5
	assign regcnt_en		= (reg_en & (regcnt_out < 6'h25));  //37
	//6
	assign cc_mux_out 	= Code_Control ? 36'b011101110111011101110111011101110111 : 36'b000100010001000100010001000101110111;
	//---------------------------------------------------------------

endmodule
