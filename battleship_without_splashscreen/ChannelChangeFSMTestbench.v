//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
//`define HalfCycle	1.3935			// Half of the clock cycle time in nanoseconds
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
//-----------------------------------------------------------------------

module ChannelChangeFSMTestbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg [3:0] Channel;
	reg ChannelChange_done;

	// Outputs
	wire ChannelChange;
	wire State;

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
	ChannelChangeFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Channel(Channel), 
		.ChannelChange_done(ChannelChange_done), 
		.ChannelChange(ChannelChange), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b0;
		Channel = 4'b0000;
		ChannelChange_done = 0;

		// Wait 100 ns for global reset to finish
		
		//Reset
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
        
		//Unchanged -> Changed
		#(`Cycle * 4);
		Channel = 4'b1001;
		#(`Cycle * 4);

		//Changed -> Unchanged
		#(`Cycle);
		ChannelChange_done = 1'b1;
		#(`Cycle);
		ChannelChange_done = 1'b0;
		#(`Cycle);
	end
      
endmodule

