//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module ControlFSMTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg Timeout;
	reg OutValid;
	reg Send_done;
	
	// Outputs
	wire Rec_en;
	wire Send_en;
	wire Send_Ctrl;
	wire Rec_Status;
	wire Rec_Reset;
	
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
	ControlFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Rec_Reset(Rec_Reset), 
		.Rec_en(Rec_en), 
		.Send_en(Send_en), 
		.Send_Ctrl(Send_Ctrl), 
		.Rec_Status(Rec_Status), 
		.Send_done(Send_done), 
		.Timeout(Timeout),
		.OutValid(OutValid)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b1;
		Send_done = 1'b0;
		Timeout = 1'b0;
		OutValid = 1'b0;

		#(`Cycle * 20);
		
		Reset = 1'b0;
		
		#(`Cycle * 4100);
		
		Send_done = 1'b1;
		
		#(`Cycle * 20);	
		//now in Rec_toss
		Send_done = 1'b0;
		Timeout = 1'b1;
		
		#(`Cycle * 20);
		//now in Send_Reset
		Send_done = 1'b1;
		Timeout = 1'b0;
		
		#(`Cycle * 20);
		//now in Rec_Toss
		Send_done = 1'b0;
		//OutValid = 1'b1;
		
		#(`Cycle * 5500);
		//now in Send_Get
		OutValid = 1'b0;
		Send_done = 1'b1;
		
		#(`Cycle * 20);
		//now in Rec
		Send_done = 1'b0;
		OutValid = 1'b1;
		
		#(`Cycle * 230);
		OutValid = 1'b0;
		

	end
      
endmodule

