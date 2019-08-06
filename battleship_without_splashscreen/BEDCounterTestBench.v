//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------



////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:37:32 11/21/2006
// Design Name:   BEDCounter
// Module Name:   U:/battleship/BEDCounterTestBench.v
// Project Name:  battleship
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BEDCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BEDCounterTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg Enable;

	// Outputs
	wire [3:0] Dig1;
	wire [3:0] Dig2;
	wire [3:0] Dig3;
	
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
	BEDCounter uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Enable(Enable), 
		.Dig1(Dig1), 
		.Dig2(Dig2), 
		.Dig3(Dig3)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b1;
		Enable = 1'b0;

		#(`Cycle*5);
		Reset = 1'b0;
		#(`Cycle*5);
		Enable = 1'b1;
		#(`Cycle*200);
        
		// Add stimulus here

	end
      
endmodule

