
//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
//`define HalfCycle	1.3935			// Half of the clock cycle time in nanoseconds
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module ReceiveFSMTestbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg [7:0] SrcAddr;
	reg [7:0] DestAddr;
	reg Rx_en;
	reg InRequest;
	reg BadData;
	reg Full;
	reg FIFO;
	reg FIFOP;

	// Outputs
	wire WEn;
	wire EndSession;
	wire DiscardSession;
	wire [7:0] Command;
	wire InValid;
	wire Rx_done;
	wire [4:0] State;
	
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
	ReceiveFSM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.SrcAddr(SrcAddr), 
		.DestAddr(DestAddr), 
		.Rx_en(Rx_en), 
		.InRequest(InRequest), 
		.BadData(BadData), 
		.Full(Full), 
		.FIFO(FIFO), 
		.FIFOP(FIFOP), 
		.WEn(WEn), 
		.EndSession(EndSession), 
		.DiscardSession(DiscardSession), 
		.Command(Command), 
		.InValid(InValid), 
		.Rx_done(Rx_done), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Reset = 0;
		SrcAddr = 0;
		DestAddr = 0;
		Rx_en = 0;
		InRequest = 0;
		BadData = 0;
		Full = 0;
		FIFO = 0;
		FIFOP = 0;
		
		//Reset
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
		
		//Init -> End Session -> Init
		#(`Cycle);
		Rx_en = 1'b1;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		
		//Init -> Flush
		#(`Cycle);
		Rx_en = 1'b1;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		BadData = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		BadData = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 3);
		InRequest = 1'b1;
		#(`Cycle);
		InRequest = 1'b0;
		#(`Cycle);
		

	end
      
endmodule

