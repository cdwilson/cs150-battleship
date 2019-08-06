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
// Create Date:   02:03:22 10/20/2006
// Design Name:   DataClip
// Module Name:   U:/Checkpoint2/Checkpoint2/DataClipTestBench.v
// Project Name:  Checkpoint2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DataClip
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DataClipTestBench_v;

	// Inputs
	reg [31:0] Data;

	// Outputs
	wire [31:0] DOut;
	
	reg Clock;
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
	DataClip uut (
		.Data(Data), 
		.DOut(DOut)
	);

	initial begin
		Data = 32'h00000000;
		#(`Cycle*2);
		
		Data = 32'h286E28EF;
		#(`Cycle*2);
		Data = 32'h10801080;
		#(`Cycle*2);
		Data = 32'heb80eb80;
		#(`Cycle*2);
		Data = 32'h51ef515a;
		#(`Cycle*2);
		Data = 32'h90229036;
		#(`Cycle*2);
		Data = 32'h286e28ef;
		#(`Cycle*2);
		Data = 32'hd291d210;
		#(`Cycle*2);
		Data = 32'ha910a9a5;
		#(`Cycle*2);
		Data = 32'h6add6ac9;
		#(`Cycle*2);
		Data = 32'hFEFEFEFE;
		#(`Cycle*2);
        
		// Add stimulus here

	end
      
endmodule

