//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------


module EncoderControlTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;

	// Outputs
	wire EAV;
	wire SAV;
	wire HBlank;
	wire HActive;
	wire EvenOdd;
	wire VBlank;
	wire InRequest;
	wire [8:0] InRequestLine;
	wire [8:0] InRequestPair;
	wire [7:0] Lineout;
	wire [10:0] HCount;
	wire [9:0]	VCount;
	wire [5:0]  VBlankCount;

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
	EncoderControl uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.EAV(EAV), 
		.SAV(SAV), 
		.HBlank(HBlank), 
		.HActive(HActive), 
		.EvenOdd(EvenOdd), 
		.VBlank(VBlank), 
		.InRequest(InRequest), 
		.InRequestLine(InRequestLine), 
		.InRequestPair(InRequestPair),
		.HCount(HCount),
		.VCount(VCount),
		.Lineout(Lineout),
		.VBlankCount(VBlankCount)
	);

	initial begin
		// Initialize Inputs
		
		Reset = 1'b1;

		#(`Cycle*3);
		Reset = 1'b0;
      
		#(`Cycle*4000);
		// Add stimulus here

	end
      
endmodule

