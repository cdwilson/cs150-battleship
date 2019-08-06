//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:49:58 10/20/2006 
// Design Name: 
// Module Name:    Shiftest 
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
module Shiftest(Clock, Reset, Load, DOut);
   input Clock;
   input Reset;
	input Load;
   output [7:0] DOut;

	wire[31:0] BLAH = 32'hF9ABCDEF;
	
	ShiftRegister ShiftRegister(.PIn(BLAH), .SIn(8'hFF), .POut(), 	.SOut(DOut), .Load(Load), .Enable(1'b1), .Clock(Clock), .Reset(Reset));
		defparam ShiftRegister.swidth = 8;
endmodule
