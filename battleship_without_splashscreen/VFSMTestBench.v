//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module VFSMTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg I2Cdone;
	reg [9:0] Line;

	// Outputs
	wire BlankGen;
	wire Even_Odd;
	wire [2:0] State;

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
	VFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.I2Cdone(I2Cdone), 
		.Line(Line), 
		.BlankGen(BlankGen), 
		.Even_Odd(Even_Odd), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b1;
		I2Cdone = 1'b0;
		Line = 10'd0;
		
		#(`Cycle * 4);
		Reset = 1'b0;
		#(`Cycle);
		I2Cdone = 1'b1;
		#(`Cycle*3);
		Line = 10'd14;
		#(`Cycle*3);
		Line = 10'd258;
		#(`Cycle*3);
		Line = 10'd262;
		#(`Cycle*3);
		Line = 10'd277;
		#(`Cycle*3);
		Line = 10'd520;
		#(`Cycle*3);
		Line = 10'd0;
		#(`Cycle*3);

	end
      
endmodule

