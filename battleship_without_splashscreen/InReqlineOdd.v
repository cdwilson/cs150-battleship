//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:09 10/19/2006 
// Design Name: 
// Module Name:    InReqlinOdd 
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
module InReqlineOdd(Clock, Reset, Odd_active, Out, HCount);
	//Inputs
	input Clock;
	input Reset;
	input [10:0] HCount;
	
	input Odd_active;
	
	//Outputs
	output[8:0] Out;
	
	//Wire
	wire[8:0] Out;
	wire LoadEn;
	
	assign LoadEn = (Reset | (Out == 9'd489)); //& (HCount == 11'd1429);
	
	//Instantiations
	Countby2 Count(.Clock(Clock), .Reset(1'b0), .Set(1'b0), .Load(LoadEn), .Enable(Odd_active), .In(9'h001), .Count(Out));

endmodule
