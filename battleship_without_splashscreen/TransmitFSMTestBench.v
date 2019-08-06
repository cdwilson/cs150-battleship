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
// Create Date:   16:09:29 10/29/2006
// Design Name:   TransmitFSM
// Module Name:   U:/Checkpoint3/Checkpoint3/TransmitFSMTestBench.v
// Project Name:  Checkpoint3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TransmitFSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TransmitFSMTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg [31:0] DIn;
	reg [7:0] SO;
	reg SFD;
	reg [7:0] SrcAddr;
	reg [7:0] DstAddr;
	reg InRequest;
	reg CCA;

	// Outputs
	wire [7:0] Command;
	wire TransmitDone;
	wire [4:0] CurState;
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
	TransmitFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.DIn(DIn), 
		.SO(SO), 
		.SFD(SFD), 
		.SrcAddr(SrcAddr), 
		.DstAddr(DstAddr),
		.InRequest(InRequest),
		.InValid(InValid),
		.CCA(CCA),
		.Command(Command), 
		.TransmitDone(TransmitDone), 
		.CurState(CurState)
	);

	initial begin
		// Initialize Inputs
		DIn = 32'h12345678;
		Reset = 1'b1;
		SFD = 1'b0;
		SO = 8'h00;
		SrcAddr = 8'hAB;
		DstAddr = 8'hCD;
		InRequest = 1'b0;
		CCA = 1'b0;
       
		#(`Cycle*3);
		Reset = 1'b0;
		#(`Cycle*3);
		InRequest = 1'b1;
		#(`Cycle*19000);
		SFD = 1'b1;
		#(`Cycle);
		SFD = 1'b0;
		#(`Cycle);
		SFD = 1'b1;
		#(`Cycle);
		SFD = 1'b0;
		// Add stimulus here

	end
      
endmodule

