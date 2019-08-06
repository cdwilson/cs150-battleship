`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:17:13 10/19/2006
// Design Name:   HFSM
// Module Name:   U:/Checkpoint2/personal_code/chris/HFSMTestbench.v
// Project Name:  checkpoint2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: HFSM
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
`define HalfCycle	1.3935			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module HFSMTestbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg [10:0] HCount;
	reg I2CDone;
		
	// Outputs
	wire CntCtrl;
	wire [1:0] HMuxControl;
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
	HFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.HCount(HCount), 
		.I2CDone(I2CDone), 
		.HMuxControl(HMuxControl),
		.CntCtrl(CntCtrl),
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Reset = 0;
		HCount = 0;
		I2CDone = 0;

		// Wait 100 ns for global reset to finish
		#(`Cycle * 20);
		// Add stimulus here
		
		//Reset
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
		
		//Init -> EAV
		#(`Cycle);
		I2CDone = 1'b1;
		#(`Cycle);
		I2CDone = 1'b0;
		#(`Cycle);
		
		//EAV -> HorizontalBlanking
		#(`Cycle);
		HCount = 11'd1444;
		#(`Cycle);
		HCount = 11'd1448;
		#(`Cycle);
		
		//HorizontalBlanking -> SAV
		#(`Cycle);
		HCount = 11'd1680;
		#(`Cycle);
		HCount = 11'd1708;
		#(`Cycle);
		
		//SAV -> EarlyIn
		#(`Cycle);
		HCount = 11'd1715;
		
		//EarlyIn -> ActivePortion
		#(`Cycle);
		HCount = 11'd0;
		#(`Cycle);
		
		//ActivePortion -> EarlyEnd
		#(`Cycle);
		HCount = 11'd1420;
		#(`Cycle);
		HCount = 11'd1439;
		#(`Cycle);
		
		//EarlyEnd -> EAV
		HCount = 11'd1440;
		
		/*
		//Init -> EAV
		#(`Cycle);
		I2CDone = 1'b1;
		#(`Cycle);
		I2CDone = 1'b0;
		#(`Cycle);
		
		//EAV -> HorizontalBlanking
		#(`Cycle);
		HCount = 9'd361;
		#(`Cycle);
		HCount = 9'd362;
		#(`Cycle);
		
		//HorizontalBlanking -> SAV
		#(`Cycle);
		HCount = 9'd420;
		#(`Cycle);
		HCount = 9'd427;
		#(`Cycle);
		
		//SAV -> ActivePortion
		#(`Cycle);
		HCount = 9'd430;
		#(`Cycle);
		HCount = 9'd0;
		#(`Cycle);
		
		//ActivePortion -> EAV
		#(`Cycle);
		HCount = 9'd355;
		#(`Cycle);
		HCount = 9'd360;
		#(`Cycle);
		*/
	end
      
endmodule

