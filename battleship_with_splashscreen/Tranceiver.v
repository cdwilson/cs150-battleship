
module Tranceiver(In, Ready, Start,  				//
	                   Out, NewData, REn,			//output
							 Channel,						//channel
                      SrcAddr, DestAddr,			//addressing			    
						    FIFO, FIFOP,					//status indicators
							 SFD, CCA,						//
						    SClk, CS_, SI, SO,			//SPI interface
						    VReg_En, Rf_Reset_,			//init. signals
						    Clock, Reset, 
							 SrcAddrOut, DestAddrOut);	//

	//---------------------------------------------------------------
	//	Input / Output Declarations
	//---------------------------------------------------------------
	
	//Wireless Data Transmission
	input		[31:0]	In;
	output				Ready;
	input					Start;
	
	//Wireless Data Receipt
	output	[31:0]	Out;
	output	[7:0]		SrcAddrOut;
	output	[7:0]		DestAddrOut;
	output				NewData;
	input					REn;
	
	//SPI Interface to CC2420
	output				CS_;
	output				SClk;
	output				SI;
	input					SO;
	
	//Single Bit Control Signals
	output				VReg_En;
	output				Rf_Reset_;
	input					FIFO;
	input					FIFOP;
	input					SFD;
	input					CCA;
	
	//Other Communication Settings
	input		[3:0]		Channel;
	input		[7:0]		SrcAddr;
	input		[7:0]		DestAddr;
	
	//Standard Synchronous Module Inputs
	input					Clock;
	input					Reset;
	
	//---------------------------------------------------------------
	
	wire NewData;
	
	//Intermediate Wires
	wire VReg_En;
	wire Rf_Reset_;
	
	//SPI Wires
	wire CS_;
	wire SI;
	wire SClk;
	wire InRequest;
	wire SNewData;
	wire [7:0] SOut;   //SPI's Out
	
	//Wires from FSMs
	reg [7:0] Command;
	wire [7:0] InitCommand;
	wire [7:0] TXCommand;
	wire [7:0] ChCommand;
	wire [7:0] RXCommand;
	wire TXInValid;
	wire InitInValid;
	wire ChInValid;
	wire RXInValid;
	wire InitDone;
	wire TransmitDone;
	wire ReceiveDone;
	wire ChangeDone;
	wire Ready;
	reg InValid;

	//FSM Enables
	wire TXEn;
	wire RXEn;
	wire CHEn;
	
	wire [4:0] InitState;
	wire [4:0] TransmitState;
	wire [2:0] ControlState;
	
	//CHIPSCOPE
	//WANT
	//InValid, InitCommand, Command, SO, InitState, TransmitState, ControlState, CCA, InitDone, TransmitDone => 41 bits
	
	wire [31:0] TEMPDATA;
	wire [15:0] TXCounter;
	wire TempStart;
	wire TempEn;
	assign TempStart =  TXCounter == 16'd32767;
	
	RisingEdgeDetector RiseEdge(.Clock(Clock), .Reset(Reset), .In(TransmitDone), .Out(TempEn));
	
	Counter	Temp(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(TempEn), .In(32'h00000000), .Count(TEMPDATA));
				defparam Temp.width = 32;
				
	Counter	Temp2(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(InitDone & ~TXEn), .In(16'h0000), .Count(TXCounter));
				defparam Temp2.width = 16;
	
	
	/*MUXING COMMAND and INVALID*/
	always @(InitDone or TXEn or RXEn or CHEn)	begin
		Command = 8'h00;
		InValid = 1'b0;
		
		if(~InitDone) begin
			InValid = InitInValid;
			Command = InitCommand;
		end
		
		else if(TXEn)	begin
			InValid = TXInValid;
			Command = TXCommand;
		end
		
		else if(CHEn)	begin
			InValid = ChInValid;
			Command = ChCommand;
		end
		
		else if(RXEn) begin
			InValid = RXInValid;
			Command = RXCommand;
		end
	
	end
	
	//assign Command = ~InitDone ? InitCommand : TXCommand;
	//assign InValid = ~InitDone ? InitInValid : TXInValid;

	//wire 	[35:0]	ILAControl;
	//wire	[43:0]   ILA_Data;
	
	//assign ILA_Data = {ChangeDone, SFD, TXEn, InValid, InitCommand, Command, SOut, InitState, TransmitState, ControlState, CCA, InitDone, TransmitDone};
	
	//---------------------------------------------------------------
	//	ChipScope Instances
	//---------------------------------------------------------------
	//icon		IconInst(.control0(ILAControl));
	//ila		ILAInst(.control(ILAControl), .clk(Clock), .trig0(ILA_Data));
	
	
	InitFSM Initializer(	.Clock(Clock), 
								.Reset(Reset), 
								.InRequest(InRequest), 
								.VREG_EN(VReg_En), 
								.RF_RESET(Rf_Reset_), 
								.Command(InitCommand), 
								.SO(SOut), 
								.InValid(InitInValid), 
								.InitDone(InitDone), 
								.CurState(InitState));
	
	//RECEIVE WIRES
	wire BadData;
	wire [7:0] SrcOut;
	wire [7:0] DestOut;
	wire Full;
	wire WEn;
	wire EndSession;
	wire Discard;
	wire [4:0] RXState;
	
	ReceiveArbit ReceiveArbit(	.Clock(Clock),
										.Reset(Reset | ~RXEn), 
										.NewData(SNewData), 
										.DIn(SOut), 
										.SrcAddr(SrcAddr), 
										.DestAddr(DestAddr), 
										.BadData(BadData), 
										.SrcOut(SrcOut), 
										.DestOut(DestOut), 
										//.DOut(), 
										.State());
	
	ReceiveFSM Receiver(	.Clock(Clock), 
								.Reset(~RXEn),
								.SrcAddr(SrcAddr), 
								.DestAddr(DestAddr),
								.Rx_en(RXEn),
								.InRequest(InRequest),
								.BadData(BadData), 
								.Full(Full), 
								.FIFO(FIFO), 
								.FIFOP(FIFOP),
								.WEn(WEn), 
								.EndSession(EndSession), 
								.DiscardSession(Discard),
								.Command(RXCommand),
								.InValid(RXInValid),
								.Rx_done(ReceiveDone),
								.State(RXState));
	
	SpiFifo	SpiFifo(		.DataIn(SOut), 
								.WEn(WEn), 
								.REn(REn),
								.SrcAddrIn(SrcOut), 
								.DestAddrIn(DestOut),
								.EndSession(EndSession), 
								.DiscardSession(Discard),
								.DataOut(Out), 
								.SrcAddrOut(SrcAddrOut), 
								.DestAddrOut(DestAddrOut),
								.NewData(NewData), 
								.Full(Full),
								.Clock(Clock), 
								.Reset(Reset));
	
	SPI 		SPI(	.InValid(InValid), 
						.In(Command), 
						.InRequest(InRequest), 
						.Clock(Clock), 
						.Reset(Reset), 
						.SI(SI), 
						.SClk(SClk), 
						.CS_(CS_), 
						.SO(SO), 
						.NewData(SNewData), 
						.Out(SOut));

	TransmitFSM Transmitter(	.Clock(Clock), 
										.Reset(~TXEn), 
										.DIn(In),
										//.DIn(32'h00d1e1e0),
										.SO(SOut), 
										.SFD(SFD), 
										.SrcAddr(SrcAddr), 
										.DstAddr(DestAddr), 
										.InRequest(InRequest), 
										.InValid(TXInValid), 
										.CCA(CCA), 
										.Command(TXCommand), 
										.TransmitDone(TransmitDone), 
										.CurState(TransmitState));
	
	SPIControlFSM	ControlFSM(	.Clock(Clock), 
										.Reset(Reset), 
										.Start(Start), 
										//.Start(TempStart),
										.Channel(Channel), 
										.Init_done(InitDone), 
										.Tx_done(TransmitDone), 
										.Rx_done(ReceiveDone), 
										.ChannelChange_done(ChangeDone),
										.FIFO(FIFO), 
										.FIFOP(FIFOP), 
										.SFD(SFD), 
										.CCA(CCA),
										.Tx_en(TXEn), 
										.Rx_en(RXEn), 
										.Ch_en(CHEn),
										.Ready(Ready), 
										.State(ControlState));
	
	ChangeChannelFSM ChFSM(		.Clock(Clock), 
										.Reset(~CHEn), 
										.ChEn(CHEn), 
										.InRequest(InRequest), 
										.InValid(ChInValid), 
										.NewChannel(Channel), 
										.Command(ChCommand), 
										.ChangeDone(ChangeDone), 
										.CurState());

endmodule
