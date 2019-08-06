//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:39 10/19/2006 
// Design Name: 
// Module Name:    VCount 
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
module VCount(Clock, Reset, VEn, VCount, HCount);
    //inputs
	 
	 input Clock;
    input Reset;
    input VEn;
	 input [10:0] HCount;
	 
	 //outputs
	 output [9:0] VCount;
	 
	 //wires
	 wire [9:0] VCount;
	 wire ResetOn;
	 
	 assign ResetOn = Reset | ((VCount == 10'd524) & (HCount == 11'd1439));
	 
	 //Instantiations
	 Counter Counter(.Clock(Clock), .Reset(ResetOn), .Set(1'b0), .Load(1'b0), .Enable(VEn), .In(10'h000), .Count(VCount));
		defparam Counter.width = 10;

endmodule
