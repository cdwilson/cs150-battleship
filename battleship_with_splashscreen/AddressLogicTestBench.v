//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------


module AddressLogicTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg VBlank;
	reg CntCtrl;
	reg EvenOdd;
	reg[1:0]	HCtrl;
	reg Vtrigger;

	// Outputs
	wire InRequest;
	wire [8:0] InRequestLine;
	
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
	AddressLogic uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.VBlank(VBlank), 
		.CntCtrl(CntCtrl),
		.HCtrl(HCtrl),
		.EvenOdd(EvenOdd), 
		.InRequest(InRequest), 
		.InRequestLine(InRequestLine),
		.Vtrigger(Vtrigger)
	);

	initial begin
		// Initialize Inputs
		
		Reset = 1'b1;
		VBlank = 1'b1;
		CntCtrl = 1'b0;
		EvenOdd = 1'b0;
		HCtrl = 2'b01;
		Vtrigger = 1'b0;

		// Wait 100 ns for global reset to finish
		#(`Cycle*3);
		Reset = 1'b0;
		#(`Cycle*5);
		VBlank = 1'b0;
		#(`Cycle*10);
		VBlank = 1'b1;
		#(`Cycle*5);
		VBlank = 1'b0;
		#(`Cycle*2);
		HCtrl = 2'b00;
		CntCtrl = 1'b1;
		EvenOdd = 1'b1;
		#(`Cycle*10);

		Vtrigger = 1'b1;
		#(`Cycle);
		Vtrigger = 1'b0;
		#(`Cycle*8);
		EvenOdd = 1'b0;
		#(`Cycle);
		Vtrigger = 1'b1;
		#(`Cycle);
		Vtrigger = 1'b0;
		
		#(`Cycle*5);
		
        
		// Add stimulus here

	end
      
endmodule

