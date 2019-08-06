////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:57:25 10/11/2006
// Design Name:   ShiftRegister
// Module Name:   U:/Checkpoint1/Checkpoint1/ShiftRegTestBench.v
// Project Name:  Checkpoint1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ShiftRegister
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module ShiftRegTestBench_v;

	// Inputs
	reg [31:0] PIn;
	reg DIn;
	reg Load;
	reg Enable;
	reg Clock;
	reg Reset;

	// Outputs
	wire [31:0] Out;

	//---------------------------------------------------------------
	//	Clock Source
	//		This section will generate a clock signal,
	//		turning it on and off according the HalfCycle
	//		time, in this case it will generate a 27MHz clock
	//		THIS COULD NEVER BE SYNTHESIZED
	//---------------------------------------------------------------
	initial Clock =		1'b0;		// We need to start at 1'b0, otherwise clock will always be 1'bx
	always #(`HalfCycle) Clock =	~Clock;	// Every half clock cycle, invert the clock
	//---------------------------------------------------------------


	// Instantiate the Unit Under Test (UUT)
	ShiftRegister uut (
		.PIn(PIn), 
		.DIn(DIn), 
		.Out(Out), 
		.Load(Load), 
		.Enable(Enable), 
		.Clock(Clock), 
		.Reset(Reset)
	);

	initial begin
		PIn = 32'h00000000;
		Reset = 1'b1;
		Enable = 1'b0;
		DIn = 1'b1;
		Load = 1'b0;
		
		#(`Cycle*20);
		Reset = 1'b0;
		#(`Cycle*2);
		Enable = 1'b1;
		//DIn = 1'b1;
		#(`Cycle*16);
		DIn = 1'b0;
		
		
		#(`Cycle*4);

	end
      
endmodule

