////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:13:48 10/28/2006
// Design Name:   InitFSM
// Module Name:   U:/Checkpoint3/Checkpoint3/InitFSMTestBench.v
// Project Name:  Checkpoint3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InitFSM
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

module InitFSMTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg InRequest;
	reg [7:0] SO;

	// Outputs
	wire [4:0] CurState;
	wire VREG_EN;
	wire RF_RESET;
	wire [7:0] Command;
	wire InValid;
	wire InitDone;
	
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
	InitFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.InRequest(InRequest), 
		.VREG_EN(VREG_EN), 
		.RF_RESET(RF_RESET), 
		.Command(Command), 
		.SO(SO), 
		.InValid(InValid), 
		.InitDone(InitDone),
		.CurState(CurState)
	);

	initial begin
		Reset = 1'b1;
		InRequest = 1'b0;
		SO = 8'h00;
		#(`Cycle*3);
		Reset = 1'b0;
		#(`Cycle*54000);
		
		//Now pulsing RF_RESET
		
		#(`Cycle*6);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		
		#(`Cycle*3);
		InRequest = 1'b1;
		#(`Cycle*3);
		InRequest = 1'b0;
		//should be trying to check status bit
		SO = 8'h40;
		
		
		
		#(`Cycle*3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle*3);
		
		//MDM Wait
		
		InRequest = 1'b1;
		#(`Cycle*4)
		InRequest = 1'b0;
		#(`Cycle);
		//IOCFG
		InRequest = 1'b1;
		#(`Cycle*4);
		InRequest = 1'b0;
		#(`Cycle)
		//Change Channel
		InRequest = 1'b1;
		#(`Cycle*4);
		InRequest = 1'b0;
		//SRFOFF
		#(`Cycle);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		

	end
      
endmodule

