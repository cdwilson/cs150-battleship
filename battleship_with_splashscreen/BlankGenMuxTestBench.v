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
// Create Date:   03:39:08 10/20/2006
// Design Name:   BlankGenMux
// Module Name:   U:/Checkpoint2/Checkpoint2/BlankGenMuxTestBench.v
// Project Name:  Checkpoint2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlankGenMux
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BlankGenMuxTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg VBlank;
	reg [1:0] HMux;
	reg [31:0] Data;
	reg EvenOdd;

	// Outputs
	wire [31:0] DOut;
	
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
	BlankGenMux uut (
		.Clock(Clock),
		.Reset(Reset),
		.VBlank(VBlank), 
		.HMux(HMux), 
		.Data(Data), 
		.DOut(DOut), 
		.EvenOdd(EvenOdd)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b1;
		VBlank = 1'b1;
		HMux = 2'b00;
		Data = 32'hF000000F;
		EvenOdd = 0;

		#(`Cycle*5);
		Reset = 1'b0;
		#(`Cycle);
		VBlank = 1'b0;
		Data = 32'h10101010;
		#(`Cycle*5);
		#(`Cycle*5);
		HMux = 2'b10;
		#(`Cycle*5);
		HMux = 2'b11;
		// Add stimulus here

	end
      
endmodule

