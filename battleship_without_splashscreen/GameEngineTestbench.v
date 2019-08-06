
//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
//`define HalfCycle	1.3935			// Half of the clock cycle time in nanoseconds
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

module GameEngineTestbench_v;

	// Inputs
	reg Clock;
	reg Reset;
	reg BoardReady;
	reg DipsSet;
	reg SoftReset;
	reg [29:0] N64ButtonStatusP1;
	reg SendReady;
	reg RecReady;
	reg [31:0] RecData;
	reg [3:0] Channel;
	reg CNS;
	reg [7:0] SrcAddr;
	reg [7:0] DestAddr;
	reg [7:0] SrcAddrIn;
	reg [7:0] DestAddrIn;
	reg RMyPosValid;
	reg [9:0] RMyPosData;
	reg RVsPosValid;
	reg [9:0] RVsPosData;

	// Outputs
	wire Send;
	wire [31:0] SendData;
	wire Rec;
	wire [3:0] ChannelCC;
	wire [7:0] SrcAddrCC;
	wire [7:0] DestAddrCC;
	wire [3:0] RMyPosRow;
	wire [3:0] RMyPosCol;
	wire WMyPosEnable;
	wire [9:0] WMyPosData;
	wire [3:0] WMyPosRow;
	wire [3:0] WMyPosCol;
	wire [3:0] RVsPosRow;
	wire [3:0] RVsPosCol;
	wire WVsPosEnable;
	wire [9:0] WVsPosData;
	wire [3:0] WVsPosRow;
	wire [3:0] WVsPosCol;
	wire [7:0] State;
	
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
	GameEngine uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.BoardReady(BoardReady), 
		.DipsSet(DipsSet), 
		.SoftReset(SoftReset), 
		.N64ButtonStatusP1(N64ButtonStatusP1), 
		.SendReady(SendReady), 
		.Send(Send), 
		.SendData(SendData), 
		.RecReady(RecReady), 
		.Rec(Rec), 
		.RecData(RecData), 
		.Channel(Channel), 
		.ChannelCC(ChannelCC), 
		.CNS(CNS), 
		.SrcAddr(SrcAddr), 
		.DestAddr(DestAddr), 
		.SrcAddrCC(SrcAddrCC), 
		.DestAddrCC(DestAddrCC), 
		.SrcAddrIn(SrcAddrIn), 
		.DestAddrIn(DestAddrIn), 
		.RMyPosValid(RMyPosValid), 
		.RMyPosData(RMyPosData), 
		.RMyPosRow(RMyPosRow), 
		.RMyPosCol(RMyPosCol), 
		.WMyPosEnable(WMyPosEnable), 
		.WMyPosData(WMyPosData), 
		.WMyPosRow(WMyPosRow), 
		.WMyPosCol(WMyPosCol), 
		.RVsPosValid(RVsPosValid), 
		.RVsPosData(RVsPosData), 
		.RVsPosRow(RVsPosRow), 
		.RVsPosCol(RVsPosCol), 
		.WVsPosEnable(WVsPosEnable), 
		.WVsPosData(WVsPosData), 
		.WVsPosRow(WVsPosRow), 
		.WVsPosCol(WVsPosCol), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		BoardReady = 0;
		DipsSet = 0;
		SoftReset = 0;
		N64ButtonStatusP1 = 0;
		SendReady = 0;
		RecReady = 0;
		RecData = 32'hf0000000;
		Channel = 0;
		CNS = 0;
		SrcAddr = 0;
		DestAddr = 0;
		SrcAddrIn = 0;
		DestAddrIn = 0;
		RMyPosValid = 0;
		RMyPosData = 0;
		RVsPosValid = 0;
		RVsPosData = 0;

		//Reset
		#(`Cycle);
		Reset = 1'b1;
		#(`Cycle);
		Reset = 1'b0;
		#(`Cycle);
		
		#(`Cycle * 20);
		
      #(`Cycle);
		RecReady = 1'b1;
		#(`Cycle);
		RecReady = 1'b0;
		#(`Cycle);

		#(`Cycle * 20);

	end
      
endmodule

