//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:59:49 10/19/2006 
// Design Name: 
// Module Name:    InReqlineEven 
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
module InReqlineEven(Clock, Reset, Even_active, Out, HCount);
    
	//Inputs
	input Clock;
	input Reset;
   input Even_active;
	input [10:0] HCount;
    
	//Outputs
	output[8:0] Out;
	 
	//Wires
	wire [8:0] Out;

	//Instantiations
	//Instantiations
	Countby2 Count(.Clock(Clock), .Reset((Reset | (Out == 9'd486))), .Set(1'b0), .Load(1'b0), .Enable(Even_active), .In(9'h000), .Count(Out));

endmodule
