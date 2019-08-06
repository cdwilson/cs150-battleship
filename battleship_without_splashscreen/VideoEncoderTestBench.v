//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518		// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:50:43 10/20/2006
// Design Name:   VideoEncoder
// Module Name:   U:/Checkpoint2/Checkpoint2/VideoEncoderTestBench.v
// Project Name:  Checkpoint2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: VideoEncoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module VideoEncoderTestBench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg [31:0] DIn;
	reg I2CDone;

	// Outputs
	wire [9:0] VE_P;
	wire VE_PAL_NTSC;
	wire VE_RESET_B_;
	wire VE_HSYNC_B_;
	wire VE_VSYNC_B_;
	wire VE_BLANK_B_;
	wire VE_SCRESET;
	wire VE_CLKIN;
	wire InRequest;
	wire [8:0] InRequestLine;
	wire [8:0] InRequestPair;
	wire [2:0] HState;
	wire [2:0] VState;

	// Bidirs
	wire VE_SCLK;
	wire VE_SDA;
	
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
	VideoEncoder uut (
		.VE_P(VE_P), 
		.VE_SCLK(VE_SCLK), 
		.VE_SDA(VE_SDA), 
		.VE_PAL_NTSC(VE_PAL_NTSC), 
		.VE_RESET_B_(VE_RESET_B_), 
		.VE_HSYNC_B_(VE_HSYNC_B_), 
		.VE_VSYNC_B_(VE_VSYNC_B_), 
		.VE_BLANK_B_(VE_BLANK_B_), 
		.VE_SCRESET(VE_SCRESET), 
		.VE_CLKIN(VE_CLKIN), 
		.Clock(Clock), 
		.Reset(Reset), 
		.DIn(DIn), 
		.InRequest(InRequest), 
		.InRequestLine(InRequestLine), 
		.InRequestPair(InRequestPair),
		.I2CDone(I2CDone),
		.HState(HState),
		.VState(VState)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b1;
		DIn = 32'hABCDEF98;
		I2CDone = 1'b0;
		#(`Cycle * 15);
		Reset = 1'b0;
		#(`Cycle*3);
		I2CDone = 1'b1;
		#(`Cycle * 3000);

        
		// Add stimulus here

	end
      
endmodule

