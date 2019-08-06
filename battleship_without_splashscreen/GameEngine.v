//notes: gameindex, kaindex need to be incremented
//changed teh value of the KA Data payloads CHANGE THIS BACK CHRIS!
module GameEngine(Clock, 
						Reset, 
						BoardReady, 
						DipsSet,
						SoftReset, 
						GReset,
						N64ButtonStatusP1, 
						SendReady, 
						Send, 
						SendData, 
						RecReady, 
						Rec, 
						RecData, 
						Channel, 
						ChannelCC,
						CNS, 
						SrcAddr, 
						DestAddr, 
						SrcAddrCC,
						DestAddrCC, 
						SrcAddrIn, 
						DestAddrIn, 
						RMyPosValid,
						RMyPosData,
						RMyPosRow,
						RMyPosCol,
						WMyPosEnable,
						WMyPosData,
						WMyPosRow,
						WMyPosCol,
						RVsPosValid,
						RVsPosData,
						RVsPosRow,
						RVsPosCol,
						WVsPosEnable,
						WVsPosData,
						WVsPosRow,
						WVsPosCol,
						InitDone,
						SetDone,
						MSG,
						Turn,
						TA,
						CursorX,
						CursorY,
						VsShipsSunk,
						State,
						Shot1,
						Shot2,
						Shot3,
						Win1,
						Win2,
						Win3,
						Loss1,
						Loss2,
						Loss3);

	//-----------------------------------------------------------------
	// Input / Output
	//-----------------------------------------------------------------
	//System I/0
	input 				Clock;
	input 				Reset;
	input 				BoardReady;
	input					DipsSet;
	input 				SoftReset;
	output				GReset;
	
	//N64Controller Input
	input 	[29:0]	N64ButtonStatusP1;
	input		[3:0]		CursorX, CursorY;
	
	//Wireless I/0
	input 				SendReady;
	output 				Send;
	output 	[31:0] 	SendData;
	input 				RecReady;
	output 				Rec;
	input 	[31:0] 	RecData;
	input		[3:0]		Channel;
	output 	[3:0] 	ChannelCC;
	input 				CNS;
	input 	[7:0] 	SrcAddr;
	input 	[7:0] 	DestAddr;
	output	[7:0]		SrcAddrCC;
	output 	[7:0] 	DestAddrCC;
	input 	[7:0] 	SrcAddrIn;
	input 	[7:0] 	DestAddrIn;
	
	output[3:0] Shot1;
	output[3:0] Shot2;
	output[3:0] Shot3;
	output[3:0] Loss1;
	output[3:0] Loss2;
	output[3:0] Loss3;
	output[3:0] Win1;
	output[3:0] Win2;
	output[3:0] Win3;

	//VideoRAM I/0
	input 				RMyPosValid;
	input 	[9:0] 	RMyPosData;
	output 	[3:0] 	RMyPosRow;
	output	[3:0]		RMyPosCol;
	output				WMyPosEnable;
	output	[9:0]		WMyPosData;
	output	[3:0]		WMyPosRow;
	output	[3:0]		WMyPosCol;
	input					RVsPosValid;
	input		[9:0]		RVsPosData;
	output	[3:0]		RVsPosRow;
	output 	[3:0]		RVsPosCol;
	output				WVsPosEnable;
	output	[9:0]		WVsPosData;
	output	[3:0]		WVsPosRow;
	output 	[3:0]		WVsPosCol;
	
	input					SetDone;
	output				InitDone;
	
	output	[2:0]		MSG;
	output				Turn; //1 is us, 0 is vs
	input					TA;
	output	[11:0]	VsShipsSunk;
	
	//Debugging
	output	[7:0]		State;
	
	//-----------------------------------------------------------------
	// Wires / Regs
	//-----------------------------------------------------------------
	wire					GReset;

	wire		[31:0]	RecData, SendData;
	wire					ValidAccept, ValidRequest;
	wire		[31:0] 	TempData, ValidRecData;
	wire		[22:0]	SendTimerCount;
	wire		[24:0]	TimeoutTimerCount;
	wire					SendTimerFired, SendTimerReset, Timeout, TimeoutTimerReset;
	wire 		[7:0]		DestAddrTemp;
	wire		[11:0]	KAIndex, GameIndex;
	wire					SSetDone, CSetDone;
	wire					Start;
	wire					GameOver;
	wire		[9:0]		StoreState;
	wire		[11:0]	VsShipsSunk;
	wire		[255:0]	MyShots;
	wire		[2:0]		Ship0, Ship1, Ship2, Ship3, Ship4, Ship5, Ship6, Ship7, Ship8, Ship9, Ship10, Ship11;
	wire		[11:0]	ShipSunkBus;
	wire		[3:0]		ShipIndex;
	wire					TA;
	wire					PlayerShipsSunk, OpponentsShipsSunk;
	wire		[3:0]		VsShipSunkIndex;
	wire[3:0] Shot1;
	wire[3:0] Shot2;
	wire[3:0] Shot3;
	wire[3:0] Loss1;
	wire[3:0] Loss2;
	wire[3:0] Loss3;
	wire[3:0] Win1;
	wire[3:0] Win2;
	wire[3:0] Win3;
	wire[2:0] MSG;
	wire[2:0] MSGFromRegister;
	
	
	reg		[7:0]		CurrentState, NextState;
	reg					regRecDataEn, regTempDataEn, regSendDataEn, regDestAddrEn;
	reg					regDefEn, Rec, Send, InitDone;
	reg					SendTimerEn, TimeoutTimerEn;
	reg		[31:0]	SendPacket;
	reg					KAIndexEn, GameIndexEn;
	reg					SSetDoneEn, CSetDoneEn;
	reg		[2:0] 	regMSG;
	reg					Turn;
	reg					winEn, lossEn, shotEn;
	reg					InternalReset;
	reg					WVsPosEnable, WMyPosEnable;
	reg		[9:0]		WVsPosData, WMyPosData;
	reg		[3:0]		WVsPosRow, WVsPosCol, RMyPosCol, RMyPosRow, WMyPosRow, WMyPosCol;
	reg					GameOverEn;
	reg					regStoreStateEn, regVsShipsSunkEn, regShotStateEn;
	reg					ShipRegEn;
	reg					ResetShotPlaced;
	reg					regMSGEn;

	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter GameRequest 						= 32'hF0000000;
	parameter GameAccept 						= 32'hB0000000;
	parameter KA_header 							= 4'h1;
	parameter KAAck_header 						= 4'h2;
	parameter CSetDone_header 					= 4'h3;
	parameter SSetDone_header 					= 4'h4;
	parameter Shot_header 						= 4'h5;
	parameter Miss_header 						= 4'h6;
	parameter Hit_header 						= 4'h7;
	parameter Sunk_header 						= 4'h8;
	
	parameter Hit									= 10'b0000100101;
	parameter Miss									= 10'b0000100100;	
	
	parameter MSG_Connecting					= 3'd0;
	parameter MSG_PlaceShips					= 3'd1;
	parameter MSG_ConnectionLost				= 3'd2;
	parameter MSG_YourShipSunk					= 3'd3;
	parameter MSG_VsShipSunk					= 3'd4;
	parameter MSG_YouWin							= 3'd5;
	parameter MSG_VsWin							= 3'd6;
	parameter MSG_Blank							= 3'd7;
	
	parameter STATE_WaitForInit 				= 8'd0;
	parameter STATE_WaitForDips 				= 8'd1;
	parameter STATE_Menu							= 8'd2;
	parameter STATE_SetDefaults 				= 8'd3;
	parameter STATE_ClientIdle 				= 8'd4;
	parameter STATE_DiscardData				= 8'd5;
	parameter STATE_ClientWaitForReady 		= 8'd6;
	parameter STATE_SetupRequest 				= 8'd7;
	parameter STATE_SendRequest 				= 8'd8;
	parameter STATE_WaitForAccept 			= 8'd9;
	parameter STATE_RecAccept 					= 8'd10;
	parameter STATE_CheckAccept 				= 8'd11;
	parameter STATE_StoreAccept 				= 8'd12;
	parameter STATE_ServerIdle 				= 8'd13;
	parameter STATE_RecRequest 				= 8'd14;
	parameter STATE_CheckRequest 				= 8'd15;
	parameter STATE_StoreRequest 				= 8'd16;
	parameter STATE_BeginSendAccept 			= 8'd17;
	parameter STATE_SetupAccept 				= 8'd18;
	parameter STATE_SendAccept 				= 8'd19;
	parameter STATE_InitDone 					= 8'd20;
	parameter STATE_PlaceShipsInit			= 8'd21;
	parameter STATE_CPS_Idle					= 8'd22;
	parameter STATE_CPS_DiscardData			= 8'd23;
	parameter STATE_CPS_WaitForReady			= 8'd24;
	parameter STATE_CPS_SetupCSetDone		= 8'd25;
	parameter STATE_CPS_SendCSetDone			= 8'd26;
	parameter STATE_CPS_SetupKA				= 8'd27;
	parameter STATE_CPS_SendKA					= 8'd28;
	parameter STATE_CPS_WaitForServer		= 8'd29;
	parameter STATE_ConnectionLost			= 8'd30;
	parameter STATE_InternalReset				= 8'd31;
	parameter STATE_CPS_Receive				= 8'd32;
	parameter STATE_CPS_Check					= 8'd33;
	parameter STATE_CPS_SetServerDone		= 8'd34;
	parameter STATE_SPS_Idle					= 8'd35;
	parameter STATE_SPS_Receive				= 8'd36;
	parameter STATE_SPS_Check 					= 8'd37;
	parameter STATE_SPS_StartSendKAAck		= 8'd38;
	parameter STATE_SPS_SetupKAAck			= 8'd39;	
	parameter STATE_SPS_SendKAAck				= 8'd40;		
	parameter STATE_SPS_StartSendSSetDone	= 8'd41;
	parameter STATE_SPS_SetupSSetDone 		= 8'd42;
	parameter STATE_SPS_SendSSetDone 		= 8'd43;
	parameter STATE_SPS_SetClientDone 		= 8'd44;
	parameter STATE_PS_Idle 					= 8'd45;
	parameter STATE_PS_DiscardData 			= 8'd46;
	parameter STATE_PS_WaitForReady 			= 8'd47;
	parameter STATE_PS_SetupShot 				= 8'd48;
	parameter STATE_PS_SendShot 				= 8'd49;
	parameter STATE_PS_SetupKA 				= 8'd50;
	parameter STATE_PS_SendKA 					= 8'd51;	
	parameter STATE_PS_WaitForShotResponse = 8'd52;
	parameter STATE_PS_WaitForKAResponse 	= 8'd53;
	parameter STATE_PS_ReceiveShotResponse = 8'd54;
	parameter STATE_PS_ReceiveKAAck 			= 8'd55;
	parameter STATE_PS_CheckShotResponse 	= 8'd56;
	parameter STATE_PS_CheckKAAck 			= 8'd57;
	parameter STATE_PS_StoreMiss 				= 8'd58;
	parameter STATE_PS_StoreHit 				= 8'd59;
	parameter STATE_PS_StoreSunk 				= 8'd60;
	parameter STATE_PS_StoreKAAck 			= 8'd61;
	parameter STATE_PS_WriteHitToVsRam 		= 8'd62;
	parameter STATE_PS_WriteMissToVsRam 	= 8'd63;
	parameter STATE_WS_Idle 					= 8'd64;
	parameter STATE_WS_Receive 				= 8'd65;
	parameter STATE_WS_Check 					= 8'd66;
	parameter STATE_WS_StartSendKAAck 		= 8'd67;
	parameter STATE_WS_SetupKAAck 			= 8'd68;
	parameter STATE_WS_SendKAAck 				= 8'd69;
	parameter STATE_WS_StoreShot 				= 8'd70;
	parameter STATE_WS_StoreState 			= 8'd71;
	parameter STATE_WS_CheckStatus 			= 8'd72;
	parameter STATE_WS_WriteHitToVRAM 		= 8'd73;
	parameter STATE_WS_CheckForSunk 			= 8'd74;
	parameter STATE_WS_WriteMissToVRAM 		= 8'd75;
	parameter STATE_WS_StartSendMiss 		= 8'd76;
	parameter STATE_WS_SetupMiss 				= 8'd77;
	parameter STATE_WS_SendMiss 				= 8'd78;
	parameter STATE_WS_StartSendHit 			= 8'd79;
	parameter STATE_WS_SetupHit 				= 8'd80;
	parameter STATE_WS_SendHit 				= 8'd81;
	parameter STATE_WS_StartSendSunk 		= 8'd82;
	parameter STATE_WS_SetupSunk 				= 8'd83;
	parameter STATE_WS_SendSunk 				= 8'd84;
	parameter STATE_Win		 					= 8'd85;
	parameter STATE_Lose							= 8'd86;
	parameter STATE_GameOver 					= 8'd87;
	parameter STATE_SPS_SetClientDone2     = 8'd88;
	
parameter STATE_SPS_StartSendSSetDone2 = 8'd89;
parameter STATE_SPS_SetupSSetDone2 = 8'd90;
parameter STATE_SPS_SendSSetDone2 = 8'd91;
	
	//-----------------------------------------------------------------
	// Assigns
	//-----------------------------------------------------------------
	//These assigns allow the channel and src to only be set from the dips.
	//To allow game engine to change these, remove the assigns, and set
	//the outputs internally
	assign ChannelCC = Channel;
	assign SrcAddrCC = SrcAddr;
	//assign DestAddrCC = DestAddr;
	assign GReset = Reset | SoftReset | InternalReset;
	assign State = CurrentState;
	assign ValidAccept = (RecData[31:28] == 4'hb);
	assign ValidRequest = (RecData[31:28] == 4'hf);
	//Chris! In these below, YOU MUST ADD CHECKS FOR THE KA INDEX! THIS DOES NOT CHECK ANY KA INDEX ON RECEIVE!
	assign ValidKA = (RecData[31:28] == 4'h1);
	assign ValidKAAck = (RecData[31:28] == 4'h2);
	assign ValidSSetDone = (RecData[31:28] == 4'h4);
	assign ValidCSetDone = (RecData[31:28] == 4'h3);
	assign ValidShot = (RecData[31:28] == 4'h5);
	assign ValidMiss = (RecData[31:28] == 4'h6);
	assign ValidHit = (RecData[31:28] == 4'h7);
	assign ValidSunk = (RecData[31:28] == 4'h8);
	//-----------------------------------------------------------------
	// Counters / Registers
	//-----------------------------------------------------------------
	BEDCounter	WinCount(.Clock(Clock), .Reset(Reset), .Enable(winEn), .Dig1(Win3), .Dig2(Win2), .Dig3(Win1));
	BEDCounter	LossCount(.Clock(Clock), .Reset(Reset), .Enable(lossEn), .Dig1(Loss3), .Dig2(Loss2), .Dig3(Loss1));
	BEDCounter	ShotCount(.Clock(Clock), .Reset(GReset), .Enable(shotEn), .Dig1(Shot3), .Dig2(Shot2), .Dig3(Shot1));	
					
	Counter		KAIndexCount(.Clock(Clock), .Reset(GReset), .Set(1'b0), .Load(1'd0), .Enable(KAIndexEn), .In(12'h00), .Count(KAIndex));
					defparam		KAIndexCount.width = 12;

	Counter		GameIndexCount(.Clock(Clock), .Reset(GReset), .Set(1'b0), .Load(1'd0), .Enable(GameIndexEn), .In(12'h00), .Count(GameIndex));
					defparam		GameIndexCount.width = 12;						

	assign SendTimerFired = (SendTimerCount == 23'd6500000);
	
	assign SendTimerReset = SendTimerFired | ~SendTimerEn | GReset; //chris! check that this is actually .25 sec
	
	//quarter second counter for sending keep alive packets
	Counter		SendTimer(.Clock(Clock), .Reset(SendTimerReset), .Set(1'b0), .Load(1'd0), .Enable(SendTimerEn), .In(23'd00), .Count(SendTimerCount));
					defparam		SendTimer.width = 23;
					
	//timer for client to signal timeout while waiting for accept packet from server
	assign Timeout = (TimeoutTimerCount == 25'd33554431);
	
	assign TimeoutTimerReset = Timeout | ~TimeoutTimerEn | GReset; //chris! need to put in correct timeout here and change the bit width correctly!!!
	
	Counter		TimeoutTimer(.Clock(Clock), .Reset(TimeoutTimerReset), .Set(1'b0), .Load(1'd0), .Enable(TimeoutTimerEn), .In(25'd00), .Count(TimeoutTimerCount));
					defparam		TimeoutTimer.width = 25;
					
					
					
	/*				
	assign MSGTimeout = (MSGTimer == 25'd33554431);
	
	assign MSGTimerReset = MSGTimeout | GReset; //chris! need to put in correct timeout here and change the bit width correctly!!!

	Counter		MSGTimerCounter(.Clock(Clock), .Reset(MSGTimerReset), .Set(1'b0), .Load(1'd0), .Enable(), .In(25'd00), .Count(MSGTimer));
					defparam		MSGTimerCounter.width = 25;
					
	Register		regMSG(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(MSGEn),
							.In(MSG), .Out(DisplayedMSG));
					defparam regMSG.width = 3;
					
	Register		regMSGEn(.Clock(Clock), .Reset(GReset | MSGTimeout),
							.Set(1'b0), .Enable(MSGTimerEn),
							.In(1'b1), .Out(MSGEn));
					defparam regMSGEn.width = 1;
	*/				
	Register		MessageRegister(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regMSGEn),
							.In(regMSG), .Out(MSGFromRegister));
					defparam MessageRegister.width = 3;
	
	assign MSG = (CurrentState > 8'd44) ? MSGFromRegister : regMSG;
					

	Register		regTempData(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regTempDataEn),
							.In(RecData), .Out(TempData));
					defparam regTempData.width = 32;
					
	Register		regRecData(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regRecDataEn),
							.In(TempData), .Out(ValidRecData));
					defparam regRecData.width = 32;
	
	Register		regSendData(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regSendDataEn),
							.In(SendPacket), .Out(SendData));
					defparam regSendData.width = 32;
	
	assign DestAddrTemp = regDestAddrEn ? SrcAddrIn : DestAddr;
	
	Register		regDestAddr(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regDefEn | regDestAddrEn),
							.In(DestAddrTemp), .Out(DestAddrCC));
					defparam regDestAddr.width = 8;
					
	Register		regCSetDone(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(CSetDoneEn | (CNS & SetDone)),
							.In(1'b1), .Out(CSetDone));
					defparam regCSetDone.width = 1;
					
	Register		regSSetDone(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(SSetDoneEn | (!CNS & SetDone)),
							.In(1'b1), .Out(SSetDone));
					defparam regSSetDone.width = 1;
					
	Register		regGameOver(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(GameOverEn | OpponentsShipsSunk | PlayerShipsSunk),
							.In(1'b1), .Out(GameOver));
					defparam regGameOver.width = 1;
	
	Register		regStoreState(.Clock(Clock), .Reset(GReset),
							.Set(1'b0), .Enable(regStoreStateEn),
							.In(RMyPosData), .Out(StoreState));
					defparam regStoreState.width = 10;
					
	assign ShipIndex = StoreState[9:6];
	
	assign VsShipSunkIndex = RecData[3:0] - TA;

	RisingEdgeDetector riseStart(.Clock(Clock), .Reset(GReset), .In(N64ButtonStatusP1[26]), .Out(Start));
	RisingEdgeDetector riseA(.Clock(Clock), .Reset(GReset), .In(N64ButtonStatusP1[29]), .Out(A));
	
	RegFile	regShotState(.Clock(Clock), .Reset(GReset), .WE(regShotStateEn), .WAddr((CursorX*16) + CursorY), .Out(MyShots));
	
	RegFile	regVsShipsSunk(.Clock(Clock), .Reset(GReset), .WE(regVsShipsSunkEn), .WAddr({4'b0, VsShipSunkIndex}), .Out(VsShipsSunk));
				defparam regVsShipsSunk.width = 12;
				
	assign OpponentsShipsSunk = (VsShipsSunk == 12'b111111111111);
	
	assign Ship0Sunk = (Ship0 == 3'h2);
	assign Ship1Sunk = (Ship1 == 3'h2);
	assign Ship2Sunk = (Ship2 == 3'h2);
	assign Ship3Sunk = (Ship3 == 3'h2);
	assign Ship4Sunk = (Ship4 == 3'h3);
	assign Ship5Sunk = (Ship5 == 3'h3);
	assign Ship6Sunk = (Ship6 == 3'h3);
	assign Ship7Sunk = (Ship7 == 3'h3);
	assign Ship8Sunk = (Ship8 == 3'h4);
	assign Ship9Sunk = (Ship9 == 3'h4);
	assign Ship10Sunk = (Ship10 == 3'h4);
	assign Ship11Sunk = (Ship11 == 3'h5);
	
	assign ShipSunkBus = {	Ship11Sunk,
									Ship10Sunk,
									Ship9Sunk,
									Ship8Sunk,
									Ship7Sunk,
									Ship6Sunk,
								
								Ship5Sunk,
									Ship4Sunk,
									Ship3Sunk,
									Ship2Sunk,
									Ship1Sunk,
									Ship0Sunk};
	
	ShipReg ShipReg(	.Clock(Clock),
							.Reset(GReset),
							.WE(ShipRegEn),
							.ShipIndex(ShipIndex),
							.Ship0(Ship0),
							.Ship1(Ship1),
							.Ship2(Ship2),
							.Ship3(Ship3),
							.Ship4(Ship4),
							.Ship5(Ship5),
							.Ship6(Ship6),
							.Ship7(Ship7),
							.Ship8(Ship8),
							.Ship9(Ship9),
							.Ship10(Ship10),
							.Ship11(Ship11));
	
	assign PlayerShipsSunk = Ship0Sunk & Ship1Sunk & Ship2Sunk & Ship3Sunk & Ship4Sunk & Ship5Sunk & Ship6Sunk & Ship7Sunk & Ship8Sunk & Ship9Sunk & Ship10Sunk & Ship11Sunk;
	
	Register regShotPlaced(.Clock(Clock), .Reset(GReset | ResetShotPlaced),
							.Set(1'b0), .Enable(A & ~MyShots[(CursorX*16) + CursorY]),
							.In(1'b1), .Out(ShotPlaced));
					defparam regShotPlaced.width = 1;

	//---------------------------------------------------------------
	//	FSM
	//---------------------------------------------------------------
	
	always @ ( posedge Clock ) begin
		if (GReset)
			CurrentState <= STATE_WaitForInit;
		else
			CurrentState <= NextState;
	end
	
	always @ ( * ) begin
		NextState = CurrentState;
		
		regRecDataEn = 1'b0; 
		regTempDataEn = 1'b0; 
		regSendDataEn = 1'b0;
		regDefEn = 1'b0; 
		regDestAddrEn = 1'b0;
		Rec = 1'b0; 
		Send = 1'b0; 
		InitDone = 1'b0;
		SendTimerEn = 1'b0; 
		TimeoutTimerEn = 1'b0;
		SendPacket = 32'h0;
		regMSG = 3'h7;
		regMSGEn = 1'b0;
		Turn = 1'b1;
		winEn = 1'b0;
		lossEn = 1'b0;
		shotEn = 1'b0;
		CSetDoneEn = 1'b0;
		SSetDoneEn = 1'b0;
		KAIndexEn = 1'b0;
		InternalReset = 1'b0;
		WVsPosEnable = 1'b0;
		WVsPosData = 10'b0;
		WVsPosRow = 4'b0;
		WVsPosCol = 4'b0;
		RMyPosRow = 4'b0;
		RMyPosCol = 4'b0;
		WMyPosEnable = 1'b0;
		WMyPosData = 10'b0;
		WMyPosRow = 4'b0;
		WMyPosCol = 4'b0;
		regStoreStateEn = 1'b0;
		ShipRegEn = 1'b0;
		regVsShipsSunkEn = 1'b0;
		regShotStateEn = 1'b0;
		ResetShotPlaced = 1'b0;
		
		case(CurrentState)

//START OF INITIALIZATION

			//State 0
			STATE_WaitForInit: begin
				//State Transition
				if (BoardReady) 
					NextState = STATE_WaitForDips;
				//Outputs
				regMSGEn = 1'b1;
				
			end
			
			//State 1
			STATE_WaitForDips: begin
				//State Transition
				if (DipsSet) 
					NextState = STATE_Menu;
				//Outputs
			end
			
			//State 3
			STATE_Menu: begin
				//State Transition
				if (Start) 
					NextState = STATE_SetDefaults;
				//Outputs
			end
			
			//State 2
			STATE_SetDefaults: begin
				//State Transition
				if (CNS) 
					NextState = STATE_ClientIdle;
				else 
					NextState = STATE_ServerIdle;
				//Outputs
				regDefEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 3
			STATE_ClientIdle: begin
				//State Transition
				if (RecReady)
					NextState = STATE_DiscardData;
				else if (SendTimerFired)
					NextState = STATE_ClientWaitForReady;
				//Outputs
				SendTimerEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 20
			STATE_DiscardData: begin
				//State Transition
				NextState = STATE_ClientIdle;
				//Outputs
				SendTimerEn = 1'b1;
				Rec = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 4
			STATE_ClientWaitForReady: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_SetupRequest;
				//Outputs
				regMSG = MSG_Connecting;
			end
			
			//State 5
			STATE_SetupRequest: begin
				//State Transition
				NextState = STATE_SendRequest;
				//Outputs
				SendPacket = GameRequest;
				regSendDataEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 6
			STATE_SendRequest: begin
				//State Transition
					NextState = STATE_WaitForAccept;
				//Outputs
				Send = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 7
			STATE_WaitForAccept: begin
				//State Transition
				if (RecReady) 
					NextState = STATE_RecAccept;
				else if (Timeout)
					NextState = STATE_ClientIdle;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 8
			STATE_RecAccept: begin
				//State Transition
					NextState = STATE_CheckAccept;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 9
			STATE_CheckAccept: begin
				//State Transition
				if (ValidAccept) 
					NextState = STATE_StoreAccept;
				else
					NextState = STATE_WaitForAccept;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
				regDestAddrEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 10
			STATE_StoreAccept: begin
				//State Transition
					NextState = STATE_InitDone;
				//Outputs
				regRecDataEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 11
			STATE_ServerIdle: begin
				//State Transition
				if (RecReady) 
					NextState = STATE_RecRequest;
				//Outputs
				regMSG = MSG_Connecting;
			end
			
			//State 12
			STATE_RecRequest: begin
				//State Transition
				NextState = STATE_CheckRequest;
				//Outputs
				Rec = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 13
			STATE_CheckRequest: begin
				//State Transition
				if (ValidRequest) 
					NextState = STATE_StoreRequest;
				else
					NextState = STATE_ServerIdle;
				//Outputs
				regTempDataEn = 1'b1;
				regDestAddrEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 14
			STATE_StoreRequest: begin
				//State Transition
				NextState = STATE_BeginSendAccept;
				//Outputs
				regRecDataEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 15
			STATE_BeginSendAccept: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_SetupAccept;
				//Outputs
				regMSG = MSG_Connecting;
			end

			//State 17
			STATE_SetupAccept: begin
				//State Transition
				NextState = STATE_SendAccept;
				//Outputs
				SendPacket = GameAccept;
				regSendDataEn = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 18
			STATE_SendAccept: begin
				//State Transition
				NextState = STATE_InitDone;
				//Outputs
				Send = 1'b1;
				regMSG = MSG_Connecting;
			end
			
			//State 19
			STATE_InitDone: begin
				//State Transition
					NextState = STATE_PlaceShipsInit;
				//Outputs
				InitDone = 1'b1;
				regMSG = MSG_Connecting;
			end
			
//END OF INITIALIZATION

//START OF SHIP SETTING
			
			//State 21
			STATE_PlaceShipsInit: begin
				//State Transition
				if (CNS) 
					NextState = STATE_CPS_WaitForReady; //skip the wait timer stage
				else
					NextState = STATE_SPS_Idle;
				//Outputs
				regMSG = MSG_PlaceShips;
			end
			
			//State 22
			STATE_CPS_Idle: begin
				//State Transition
				if (SendTimerFired) 
					NextState = STATE_CPS_WaitForReady;
				else if (RecReady)
					NextState = STATE_CPS_DiscardData;
				//Outputs
				SendTimerEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 23
			STATE_CPS_DiscardData: begin
				//State Transition
					NextState = STATE_CPS_Idle;
				//Outputs
				SendTimerEn = 1'b1;
				Rec = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 24
			STATE_CPS_WaitForReady: begin
				//State Transition
				if (CSetDone & SendReady) 
					NextState = STATE_CPS_SetupCSetDone;
				else if (!CSetDone & SendReady)
					NextState = STATE_CPS_SetupKA;
				//Outputs
				regMSG = MSG_PlaceShips;
			end
			
			//State 25
			STATE_CPS_SetupCSetDone: begin
				//State Transition
				NextState = STATE_CPS_SendCSetDone;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {CSetDone_header, KAIndex, 16'h0};
				regMSG = MSG_PlaceShips;
			end
			
			//State 26
			STATE_CPS_SendCSetDone: begin
				//State Transition 
				NextState = STATE_CPS_WaitForServer;
				//Outputs
				Send = 1'b1;
				KAIndexEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 27
			STATE_CPS_SetupKA: begin
				//State Transition
				NextState = STATE_CPS_SendKA;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {KA_header, KAIndex, 16'h0};
				regMSG = MSG_PlaceShips;
			end
			
			//State 28
			STATE_CPS_SendKA: begin
				//State Transition 
				NextState = STATE_CPS_WaitForServer;
				//Outputs
				Send = 1'b1;
				KAIndexEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 29
			STATE_CPS_WaitForServer: begin
				//State Transition
				if (Timeout)
					NextState = STATE_ConnectionLost;
				else if (RecReady) 
					NextState = STATE_CPS_Receive;
				//Outputs
				TimeoutTimerEn = 1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 30
			STATE_ConnectionLost: begin
				//State Transition
				if (Timeout)
					NextState = STATE_InternalReset;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_ConnectionLost;
			end
			
			//State 44
			STATE_InternalReset: begin
				//State Transition
					NextState = STATE_WaitForInit;
				//Outputs
				InternalReset = 1'b1;
				regMSG = MSG_ConnectionLost;
			end
			
			//State 31
			STATE_CPS_Receive: begin
				//State Transition
				NextState = STATE_CPS_Check;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 32
			STATE_CPS_Check: begin
				//State Transition
				if (ValidKAAck)
					NextState = STATE_CPS_Idle;
				else if (!CSetDone & ValidSSetDone)
					NextState = STATE_CPS_SetServerDone;
				else if (CSetDone & ValidSSetDone)
					NextState = STATE_PS_Idle;
				else
					NextState = STATE_CPS_WaitForServer;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
				regMSG = MSG_PlaceShips;
				ResetShotPlaced = 1'b1;
			end
			
			//State 33
			STATE_CPS_SetServerDone: begin
				//State Transition
					NextState = STATE_CPS_Idle;
				//Outputs
				SSetDoneEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 34
			STATE_SPS_Idle: begin
				//State Transition
				if (Timeout) 
					NextState = STATE_ConnectionLost;
				else if (RecReady)
					NextState = STATE_SPS_Receive;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 35
			STATE_SPS_Receive: begin
				//State Transition
				NextState = STATE_SPS_Check;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 36
			STATE_SPS_Check: begin
				//State Transition
				if (!SSetDone & ValidKA)
					NextState = STATE_SPS_StartSendKAAck;
				else if (SSetDone & ValidKA)
					NextState = STATE_SPS_StartSendSSetDone;
				else if (!SSetDone & ValidCSetDone)
					NextState = STATE_SPS_SetClientDone;
				else if (SSetDone & ValidCSetDone)
					NextState = STATE_SPS_SetClientDone2;
				else
					NextState = STATE_SPS_Idle;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 37
			STATE_SPS_StartSendKAAck: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_SPS_SetupKAAck;
				//Outputs
				regMSG = MSG_PlaceShips;
			end
			
			//State 38
			STATE_SPS_SetupKAAck: begin
				//State Transition
				NextState = STATE_SPS_SendKAAck;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {KAAck_header, KAIndex, 16'h0};
				regMSG = MSG_PlaceShips;
			end
			
			//State 39
			STATE_SPS_SendKAAck: begin
				//State Transition
				NextState = STATE_SPS_Idle;
				//Outputs
				Send = 1'b1;
				KAIndexEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 40
			STATE_SPS_StartSendSSetDone: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_SPS_SetupSSetDone;
				//Outputs
				regMSG = MSG_PlaceShips;
			end
			
			//State 41
			STATE_SPS_SetupSSetDone: begin
				//State Transition
				NextState = STATE_SPS_SendSSetDone;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {SSetDone_header, KAIndex, 16'h0};
				regMSG = MSG_PlaceShips;
			end
			
			//State 42
			STATE_SPS_SendSSetDone: begin
				//State Transition
				if (CSetDone)
				//	NextState = STATE_SPS_StartSendSSetDone2;
					NextState = STATE_WS_Idle;
				else
					NextState = STATE_SPS_Idle;
				//Outputs
				Send = 1'b1;
				KAIndexEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 43
			STATE_SPS_SetClientDone: begin
				//State Transition
					NextState = STATE_SPS_StartSendKAAck;
				//Outputs
				CSetDoneEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 43
			STATE_SPS_SetClientDone2: begin
				//State Transition
					NextState = STATE_SPS_StartSendSSetDone;
				//Outputs
				CSetDoneEn = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			//State 40
			STATE_SPS_StartSendSSetDone2: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_SPS_SetupSSetDone2;
				//Outputs
				regMSG = MSG_PlaceShips;
			end
			
			//State 41
			STATE_SPS_SetupSSetDone2: begin
				//State Transition
				NextState = STATE_SPS_SendSSetDone2;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {SSetDone_header, KAIndex, 16'h0};
				regMSG = MSG_PlaceShips;
			end
			
			//State 42
			STATE_SPS_SendSSetDone2: begin
				//State Transition
					NextState = STATE_WS_Idle;
				//Outputs
				Send = 1'b1;
				regMSG = MSG_PlaceShips;
			end
			
			
//END OF SHIP SETTING
			
//START OF GAME
			
			//State 
			STATE_PS_Idle: begin
				//State Transition
				if (PlayerShipsSunk)
					NextState = STATE_Lose;
				else if (OpponentsShipsSunk)
					NextState = STATE_Win;
				else if (SendTimerFired) 
					NextState = STATE_PS_WaitForReady;
				else if (RecReady)
					NextState = STATE_PS_DiscardData;
				//Outputs
				SendTimerEn = 1'b1;
			end
			
			//State 
			STATE_PS_DiscardData: begin
				//State Transition
				NextState = STATE_PS_Idle;
				//Outputs
				SendTimerEn = 1'b1;
				Rec = 1'b1;
			end
			
			//State 
			STATE_PS_WaitForReady: begin
				//State Transition
				if (ShotPlaced & SendReady) //shot placed should be held high until sendready, until it is set low again
					NextState = STATE_PS_SetupShot;
				else if (!ShotPlaced & SendReady)
					NextState = STATE_PS_SetupKA;
				//Outputs
			end
			
			//State 
			STATE_PS_SetupShot: begin
				//State Transition
				NextState = STATE_PS_SendShot;
				//Outputs
				ResetShotPlaced = 1'b1;
				regSendDataEn = 1'b1;
				SendPacket = {Shot_header, GameIndex, 8'h0, CursorY, CursorX};
				regShotStateEn = 1'b1;
				ResetShotPlaced = 1'b1;
				regMSGEn = 1'b1;
				regMSG = MSG_Blank;
			end
			
			//State 
			STATE_PS_SendShot: begin
				//State Transition 
				NextState = STATE_PS_WaitForShotResponse;
				//Outputs
				Send = 1'b1;
				shotEn = 1'b1;
			end
			
			//State 
			STATE_PS_SetupKA: begin
				//State Transition
				NextState = STATE_PS_SendKA;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {KA_header, GameIndex, 16'h0};
			end
			
			//State 
			STATE_PS_SendKA: begin
				//State Transition 
				NextState = STATE_PS_WaitForKAResponse;
				//Outputs
				Send = 1'b1;
			end
			
			//State 29
			STATE_PS_WaitForShotResponse: begin
				//State Transition
				if (Timeout)
					NextState = STATE_ConnectionLost;
				else if (RecReady) 
					NextState = STATE_PS_ReceiveShotResponse;
				//Outputs
				TimeoutTimerEn = 1;
			end
			
			//State 29
			STATE_PS_WaitForKAResponse: begin
				//State Transition
				if (Timeout)
					NextState = STATE_ConnectionLost;
				else if (RecReady) 
					NextState = STATE_PS_ReceiveKAAck;
				//Outputs
				TimeoutTimerEn = 1;
			end
			
			//State 31
			STATE_PS_ReceiveShotResponse: begin
				//State Transition
				NextState = STATE_PS_CheckShotResponse;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
			end
			
			//State 31
			STATE_PS_ReceiveKAAck: begin
				//State Transition
				NextState = STATE_PS_CheckKAAck;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
			end
			
			//State 32
			STATE_PS_CheckShotResponse: begin
				//State Transition
				if (ValidMiss)
					NextState = STATE_PS_StoreMiss;
				else if (ValidHit)
					NextState = STATE_PS_StoreHit;
				else if (ValidSunk)
					NextState = STATE_PS_StoreSunk;
				else
					NextState = STATE_ConnectionLost;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
			end
			
			//State 32
			STATE_PS_CheckKAAck: begin
				//State Transition
				if (ValidKAAck)
					NextState = STATE_PS_StoreKAAck;
				else
					NextState = STATE_ConnectionLost;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
			end
			
			//State 10
			STATE_PS_StoreMiss: begin
				//State Transition
					NextState = STATE_PS_WriteMissToVsRam;
				//Outputs
				regRecDataEn = 1'b1;
			end
			
			//State 10
			STATE_PS_StoreHit: begin
				//State Transition
					NextState = STATE_PS_WriteHitToVsRam;
				//Outputs
				regRecDataEn = 1'b1;
			end
			
			//State 10
			STATE_PS_StoreSunk: begin
				//State Transition
					NextState = STATE_PS_WriteHitToVsRam;
				//Outputs
				regRecDataEn = 1'b1;
				regVsShipsSunkEn = 1'b1;
				regMSGEn = 1'b1;
				regMSG = MSG_VsShipSunk;
			end
			
			//State 10
			STATE_PS_StoreKAAck: begin
				//State Transition
					NextState = STATE_PS_Idle;
				//Outputs
				regRecDataEn = 1'b1;
			end
			
			//State 10
			STATE_PS_WriteHitToVsRam: begin
				//State Transition
					NextState = STATE_WS_Idle;
				//Outputs
				WVsPosEnable = 1'b1;
				WVsPosData = Hit;
				WVsPosRow = CursorY;//chris! this needs to be the Row and Col of the shot I just made
				WVsPosCol = CursorX;//chris!this needs to be the Row and Col of the shot I just made
			end
			
			//State 10
			STATE_PS_WriteMissToVsRam: begin
				//State Transition
					NextState = STATE_WS_Idle;
				//Outputs
				WVsPosEnable = 1'b1;
				WVsPosData = Miss;
				WVsPosRow = CursorY;//chris!this needs to be the Row and Col of the shot I just made
				WVsPosCol = CursorX;//chris!this needs to be the Row and Col of the shot I just made
			end
			
			//State 34
			STATE_WS_Idle: begin
				//State Transition
				if (PlayerShipsSunk)
					NextState = STATE_Lose;
				else if (OpponentsShipsSunk)
					NextState = STATE_Win;
				else if (Timeout) 
					NextState = STATE_ConnectionLost;
				else if (RecReady)
					NextState = STATE_WS_Receive;
				//Outputs
				TimeoutTimerEn = 1'b1;
				Turn = 1'b0;
			end
			
			//State 35
			STATE_WS_Receive: begin
				//State Transition
				NextState = STATE_WS_Check;
				//Outputs
				Rec = 1'b1;
				TimeoutTimerEn = 1'b1;
				Turn = 1'b0;
			end
			
			//State 36
			STATE_WS_Check: begin
				//State Transition
				if (ValidKA)
					NextState = STATE_WS_StartSendKAAck;
				else if (ValidCSetDone)
					NextState = STATE_SPS_SetClientDone2;
				else if (ValidShot)
					NextState = STATE_WS_StoreShot;
				else
					NextState = STATE_WS_Idle;
				//Outputs
				TimeoutTimerEn = 1'b1;
				regTempDataEn = 1'b1;
				Turn = 1'b0;
			end
			
			//State 37
			STATE_WS_StartSendKAAck: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_WS_SetupKAAck;
				//Outputs
				Turn = 1'b0;
			end
			
			//State 38
			STATE_WS_SetupKAAck: begin
				//State Transition
				NextState = STATE_WS_SendKAAck;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {KAAck_header, GameIndex, 16'h0};
				Turn = 1'b0;
			end
			
			//State 39
			STATE_WS_SendKAAck: begin
				//State Transition
				NextState = STATE_WS_Idle;
				//Outputs
				Send = 1'b1;
				Turn = 1'b0;
			end
			
			//State 10
			STATE_WS_StoreShot: begin
				//State Transition
					NextState = STATE_WS_StoreState;
				//Outputs
				regRecDataEn = 1'b1;
				//Ask for the data
				RMyPosRow = TempData[7:4];
				RMyPosCol = TempData[3:0];
				Turn = 1'b0;
			end
			
			//State 10
			STATE_WS_StoreState: begin
				//State Transition
				NextState = STATE_WS_CheckStatus;
				//Outputs
				regStoreStateEn = 1'b1;
				//RMyPosData is ready to read, so store it in StoreState by setting regStoreStateEn
				RMyPosRow = ValidRecData[7:4]; 
				RMyPosCol = ValidRecData[3:0];
				Turn = 1'b0;
			end
			
			//State 10
			STATE_WS_CheckStatus: begin
				//State Transition
				if ((StoreState[5:1] == 5'b00000) | (StoreState[5:1] == 5'b10010))
					NextState = STATE_WS_WriteMissToVRAM;
				else 
					NextState = STATE_WS_WriteHitToVRAM;
				//Outputs
				Turn = 1'b0;
			end
			
			//State 10
			STATE_WS_WriteHitToVRAM: begin
				//State Transition
				NextState = STATE_WS_CheckForSunk;
				//Outputs
				WMyPosEnable = 1'b1;
				WMyPosData = {StoreState[9:1],1'b1};
				WMyPosRow = ValidRecData[7:4];
				WMyPosCol = ValidRecData[3:0];
				//RMyPosRow = ValidRecData[7:4]; 
				//RMyPosCol = ValidRecData[3:0];
				ShipRegEn = 1'b1;
				Turn = 1'b0;
			end	

			//State 10
			STATE_WS_CheckForSunk: begin
				//State Transition
				if (ShipSunkBus[ShipIndex] == 1'b1) //Chris! does this work?
					NextState = STATE_WS_StartSendSunk;
				else
					NextState = STATE_WS_StartSendHit;
				//Outputs
				Turn = 1'b0;
			end		
			
			//State 10
			STATE_WS_WriteMissToVRAM: begin
				//State Transition
				NextState = STATE_WS_StartSendMiss;
				//Outputs
				WMyPosEnable = 1'b1;
				WMyPosData = Miss;
				WMyPosRow = ValidRecData[7:4];
				WMyPosCol = ValidRecData[3:0];
				//RMyPosRow = ValidRecData[7:4]; 
				//RMyPosCol = ValidRecData[3:0];
				Turn = 1'b0;
			end
			
			//State 37
			STATE_WS_StartSendMiss: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_WS_SetupMiss;
				//Outputs
				Turn = 1'b0;
			end
			
			//State 38
			STATE_WS_SetupMiss: begin
				//State Transition
				NextState = STATE_WS_SendMiss;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {Miss_header, GameIndex, 16'h0};
				Turn = 1'b0;
			end
			
			//State 39
			STATE_WS_SendMiss: begin
				//State Transition
				NextState = STATE_PS_Idle;
				//Outputs
				Send = 1'b1;
				Turn = 1'b0;
				ResetShotPlaced = 1'b1;
			end
			
			//State 37
			STATE_WS_StartSendHit: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_WS_SetupHit;
				//Outputs
				Turn = 1'b0;
			end
			
			//State 38
			STATE_WS_SetupHit: begin
				//State Transition
				NextState = STATE_WS_SendHit;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {Hit_header, GameIndex, 16'h0};
				Turn = 1'b0;
			end
			
			//State 39
			STATE_WS_SendHit: begin
				//State Transition
				NextState = STATE_PS_Idle;
				//Outputs
				Send = 1'b1;
				Turn = 1'b0;
				ResetShotPlaced = 1'b1;
			end
			
			//State 37
			STATE_WS_StartSendSunk: begin
				//State Transition
				if (SendReady) 
					NextState = STATE_WS_SetupSunk;
				//Outputs
				Turn = 1'b0;
			end
			
			//State 38
			STATE_WS_SetupSunk: begin
				//State Transition
				NextState = STATE_WS_SendSunk;
				//Outputs
				regSendDataEn = 1'b1;
				SendPacket = {Sunk_header, GameIndex, 12'h0, ShipIndex + TA};
				Turn = 1'b0;
			end
			
			//State 39
			STATE_WS_SendSunk: begin
				//State Transition
				NextState = STATE_PS_Idle;
				//Outputs
				Send = 1'b1;
				Turn = 1'b0;
				ResetShotPlaced = 1'b1;
				regMSGEn = 1'b1;
				regMSG = MSG_YourShipSunk;
			end
			
			//State
			STATE_Win: begin
				//State Transition
				NextState = STATE_GameOver;
				//Outputs
				winEn = 1'b1;
				regMSGEn = 1'b1;
				regMSG = MSG_YouWin;
			end
			
			//State
			STATE_Lose: begin
				//State Transition
				NextState = STATE_GameOver;
				//Outputs
				lossEn = 1'b1;
				regMSGEn = 1'b1;
				regMSG = MSG_VsWin;
			end
			
			//State 39
			STATE_GameOver: begin
				//State Transition
				//Outputs
			end

			
			//State 
			//STATE_: begin
				//State Transition
			//	if () 
			//		NextState = STATE_SPS_;
			//	else
			//		NextState = STATE_SPS_;
				//Outputs
			//end
			
			//State
			//STATE_: begin
				//State Transition
			//	if () 
			//		NextState = STATE_;
				//Outputs
			//end
			
			default: begin
			end
		endcase
	end
				
endmodule
