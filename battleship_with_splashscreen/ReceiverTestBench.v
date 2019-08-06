////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:27:39 10/11/2006
// Design Name:   Receiver
// Module Name:   U:/Checkpoint1/Checkpoint1/ReceiverTestBench.v
// Project Name:  Checkpoint1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Receiver
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

module ReceiverTestBench_v;

	// Inputs
	reg Din;
	reg Clock;
	reg Rec_Reset;
	reg Rec_en;

	// Outputs
	wire [29:0] Dout;
	wire Timeout;
	wire OutValid;
	
	integer i;
	
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
	Receiver uut (
		.Din(Din), 
		.Clock(Clock), 
		.Rec_Reset(Rec_Reset), 
		.Rec_en(Rec_en), 
		.Dout(Dout), 
		.Timeout(Timeout), 
		.OutValid(OutValid)
	);

	initial begin
		Rec_Reset = 1'b1;
		Rec_en = 1'b0;
		Din = 0'b0;
		i = 0;
		#(`Cycle * 20);
		
		Rec_Reset = 0'b0;
		Rec_en = 1'b1;
		Din = 1'b1;
		
		#(`Cycle * 10);
		
		for(i = 0; i<10; i=i+1) begin
			Din = 1'b0;
			#(`Cycle * 27);
			Din = 1'b1;			//first data
			#(`Cycle*54);
			Din = 1'b1;			//first stop bit
			#(`Cycle*27);
		
			Din = 1'b0;
			#(`Cycle * 27);
			Din = 1'b0;
			#(`Cycle*54);
			Din = 1'b1;
			#(`Cycle*27);
		
			Din = 1'b0;
			#(`Cycle * 27);
			Din = 1'b1;
			#(`Cycle*54);
			Din = 1'b1;
			#(`Cycle*27);
		end
		
		Din = 1'b0;
		#(`Cycle * 27);
		Din = 1'b1;			//31st data
		#(`Cycle*54);
		Din = 1'b1;			//31st stop bit
		#(`Cycle*27);
		
		Din = 1'b0;
		#(`Cycle * 27);
		Din = 1'b0;
		#(`Cycle*54);
		Din = 1'b1;
		#(`Cycle*27);
			
		//Last Stop bit
		Din = 1'b0;
		#(`Cycle * 27);
		Din = 1'b1;
		#(`Cycle*54);
		Din = 1'b1;
		#(`Cycle*27);		
	end
      
endmodule

