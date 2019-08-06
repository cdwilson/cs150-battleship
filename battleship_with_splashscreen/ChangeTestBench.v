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
// Create Date:   17:31:06 10/29/2006
// Design Name:   ChangeChannelFSM
// Module Name:   U:/Checkpoint3/Checkpoint3/ChangeTestBench.v
// Project Name:  Checkpoint3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ChangeChannelFSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ChangeTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg ChEn;
	reg InRequest;
	reg [4:0] NewChannel;

	// Outputs
	wire [7:0] Command;
	wire ChangeDone;
	wire [2:0] CurState;
	wire InValid;
	
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
	ChangeChannelFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.ChEn(ChEn), 
		.InRequest(InRequest),
		.InValid(InValid),
		.NewChannel(NewChannel), 
		.Command(Command), 
		.ChangeDone(ChangeDone), 
		.CurState(CurState)
	);

	initial begin
		// Initialize Inputs

		Reset = 1'b1;
		ChEn = 1'b0;
		InRequest = 1'b0;
		NewChannel = 4'hA;
		
		#(`Cycle*2);
		
		Reset = 1'b0;
		ChEn = 1'b1;
		
		#(`Cycle);
		InRequest = 1'b1;
		
		#(`Cycle*10);
		InRequest = 1'b0;

	end
      
endmodule

