//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:12:14 10/19/2006
// Design Name:   VCount
// Module Name:   U:/Checkpoint2/Checkpoint2/VCountTestBench.v
// Project Name:  Checkpoint2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: VCount
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module HCountTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg HEn;

	// Outputs
	wire [8:0] HCount;
	
	//---------------------------------------------------------------
	//	Clock Source
	//		This section will generate a clock signal,
	//		turning it on and off according the HalfCycle
	//		time, in this case it will generate a 27MHz clock
	//		THIS COULD NEVER BE SYNTHESIZED
	//---------------------------------------------------------------
	initial Clock =		1'b1;		// We need to start at 1'b0, otherwise clock will always be 1'bx
	always #(`HalfCycle) Clock =	~Clock;	// Every half clock cycle, invert the clock
	//---------------------------------------------------------------

	// Instantiate the Unit Under Test (UUT)
	HCount uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.HEn(HEn), 
		.HCount(HCount)
	);

	initial begin
		Reset = 1'b1;
		HEn = 1'b0;

		#(`Cycle * 3);
		Reset = 1'b0;
      HEn = 1'b1;

		#(`Cycle * 1750);
		// Add stimulus here

	end
      
endmodule

