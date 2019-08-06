//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:25:20 10/19/2006 
// Design Name: 
// Module Name:    HCount 
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
module HCount(Clock, Reset, HEn, HCount);
    
	//Inputs
	input Clock;
   input Reset;
   input HEn;
    
	//Outputs
	output [10:0] HCount;
	
	//Wires
	//wire [10:0] CountOut;
	wire [10:0] HCount;
	wire LoadCount;
	wire ResetOn;
	
	assign ResetOn = Reset | (HCount == 11'd1715);
	//assign HCount = CountOut[10:2];
	
	//Instantiations
	RisingEdgeDetector	RiseEdge(.Clock(Clock), .Reset(Reset), .In(HEn), .Out(LoadCount));
	
	Counter Counter(.Clock(Clock), .Reset(ResetOn), .Set(1'b0), .Load(LoadCount), .Enable(HEn), .In(11'd1439), .Count(HCount));
		defparam Counter.width = 11;
	
endmodule
