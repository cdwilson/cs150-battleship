
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:13:02 10/12/2006
// Design Name:   Sender
// Module Name:   U:/Checkpoint1/personal_code/chris/Sender_testbench.v
// Project Name:  checkpoint1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sender
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

module Sender_testbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg Send_En;
	reg Code_Control;

	// Outputs
	wire Dout;
	wire Send_Done;

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
	Sender uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Send_En(Send_En), 
		.Code_Control(Code_Control), 
		.Dout(Dout), 
		.Send_Done(Send_Done)
	);

	initial begin
		// Initialize Inputs
		Reset = 0;
		Send_En = 0;
		Code_Control = 0;

		// Wait 100 ns for global reset to finish
		
		//Reset the sender module
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
		//Set Send_En high for the duration of the test
		Send_En = 1'b1;
		//Let the entire 36 bits cycle out of the shift register twice
		#(`Cycle * 27 * 36 * 2);
		
         
		// Add stimulus here

	end
      
endmodule

