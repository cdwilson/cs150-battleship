
//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
//`define HalfCycle	1.3935			// Half of the clock cycle time in nanoseconds
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module SPIControlFSMTestbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg Start;
	reg [3:0] Channel;
	reg Init_done;
	reg Tx_done;
	reg Rx_done;
	reg ChannelChange_done;
	reg FIFO;
	reg FIFOP;
	reg SFD;
	reg CCA;

	// Outputs
	wire Tx_en;
	wire Rx_en;
	wire Ch_en;
	wire Ready;
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
	SPIControlFSM uut (
		.Clock(Clock),
		.Reset(Reset),
		.Start(Start), 
		.Channel(Channel),
		.Init_done(Init_done), 
		.Tx_done(Tx_done), 
		.Rx_done(Rx_done), 
		.ChannelChange_done(ChannelChange_done),
		.FIFO(FIFO), 
		.FIFOP(FIFOP), 
		.SFD(SFD), 
		.CCA(CCA), 
		.Tx_en(Tx_en), 
		.Rx_en(Rx_en),
		.Ch_en(Ch_en),
		.Ready(Ready), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Reset = 1'b0;
		Start = 0;
		Channel = 4'b0000;
		Init_done = 0;
		Tx_done = 0;
		Rx_done = 0;
		ChannelChange_done = 1'b0;
		FIFO = 0;
		FIFOP = 0;
		SFD = 0;
		CCA = 0;

		//Reset
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
        
		//Init -> Ready
		#(`Cycle);
		Init_done = 1'b1;
		#(`Cycle);
		Init_done = 1'b0;
		#(`Cycle);
		
		//Ready -> Tx
		#(`Cycle);
		Start = 1'b1;
		#(`Cycle);
		Start = 1'b0;
		#(`Cycle);
		
		//Tx -> Ready
		#(`Cycle);
		Tx_done = 1'b1;
		#(`Cycle);
		Tx_done = 1'b0;
		#(`Cycle);
		
		//Ready -> Rx
		#(`Cycle);
		FIFO = 1'b1;
		#(`Cycle * 4);
		FIFOP = 1'b1;
		#(`Cycle);
		FIFOP = 1'b0;
		#(`Cycle);
		FIFO = 1'b0;
		#(`Cycle);
		
		//Change the Channel
		Channel = 4'b1001;
		
		//Rx -> Ready
		#(`Cycle);
		Rx_done = 1'b1;
		#(`Cycle);
		Rx_done = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 5);
		ChannelChange_done = 1'b1;
		#(`Cycle);
		ChannelChange_done = 1'b0;
		#(`Cycle);
		
	end
      
endmodule

