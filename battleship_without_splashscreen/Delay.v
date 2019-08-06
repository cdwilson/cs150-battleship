`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:28:06 10/20/2006 
// Design Name: 
// Module Name:    Delay 
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
module Delay(Clock, Reset, Data, DOut);
   parameter width = 1;
	 
	input Clock;
   input Reset;
	input[width-1:0] Data;
	
	output[width-1:0] DOut;
	
	reg [width-1:0] DOut;
	
	always@(posedge Clock) begin
		if(Reset)
			DOut <= {width{1'b0}};
		else
			DOut <= Data;
	
	end
	
endmodule
