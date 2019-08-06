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
// Create Date:   18:31:23 10/29/2006
// Design Name:   ReceiveArbit
// Module Name:   U:/Checkpoint3/Checkpoint3/ReceiveArbTestBench.v
// Project Name:  Checkpoint3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ReceiveArbit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ReceiveArbTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg NewData;
	reg [7:0] DIn;

	// Outputs
	wire [119:0] DOut;
	
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
	ReceiveArbit uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.NewData(NewData), 
		.DIn(DIn), 
		.DOut(DOut)
	);

	initial begin
		Reset = 1'b1;
		NewData = 1'b0;
		DIn = 8'hAE;
		
		#(`Cycle*2);
		Reset = 1'b0;
		#(`Cycle);
		NewData = 1'b1;
		
        
		// Add stimulus here

	end
      
endmodule

