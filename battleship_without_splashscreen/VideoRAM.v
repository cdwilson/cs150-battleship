
//-----------------------------------------------------------------------
//	Section:	Includes
//-----------------------------------------------------------------------
`include "Const.v"
//-----------------------------------------------------------------------

module	VideoRAM(	//-----------------------------------------------
			//	System Inputs
			//-----------------------------------------------
			Clock,
			Reset,
			//-----------------------------------------------

			//-----------------------------------------------
			//	Video Data Host Interface
			//-----------------------------------------------
			Mode,
			Horiz,
			CursorX,
			CursorY,
			
			RMyPosData, 
			RMyPosRow, 
			RMyPosCol,
			RVsPosData, 
			RVsPosRow, 
			RVsPosCol,			
			
			DOut,
			OutRequest,
			OutRequestLine,
			OutRequestPair,
			Channel,
			Src,
			Dst,
			Turn,
			Wins,
			Losses,
			Shots,
			CNS,
			VsStatus,
			Msg,
			Shot1,
			Shot2,
			Shot3,
			Win1,
			Win2,
			Win3,
			Loss1,
			Loss2,
			Loss3
			//-----------------------------------------------
		);
	//---------------------------------------------------------------
	//	Parameters
	//		These could theoretically change if we changed
	//		the video format.  We don't expect you to plan
	//		for that.  You may assume these are CONSTANTS!
	//---------------------------------------------------------------
	parameter		totallines =		525,	// Total number of video lines
				activelines =		507,	// Number of active video lines
				f0topblank =		6,	// Number of blank lines at the top of Field0
				hblanksamples =		138,	// Number of blank samples per line
				activesamples =		720;	// Number of active samples per line
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Constants
	//---------------------------------------------------------------
	`ifdef MACROSAFE
	localparam		oddlines =		totallines >> 1,
				evenlines =		totallines - oddlines,
				evenactive =		activelines >> 1,
				oddactive =		activelines - evenactive,
				oddtopblank =		f0topblank,
				eventopblank =		f0topblank + 1,
				oddbottomblank =	oddlines - oddactive - oddtopblank,
				evenbottomblank =	evenlines - evenactive - eventopblank,
				hblankbytes =		(hblanksamples * 2) - 8,
				activebytes =		(activesamples * 2),
				vcbits =		`log2(oddactive),
				hcbits =		`log2(activebytes);
	`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//---------------------------------------------------------------
	input			Clock, Reset;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Data Host Interface
	//---------------------------------------------------------------
	output	[31:0]		DOut;
	input			OutRequest;
	input	[vcbits:0]	OutRequestLine;
	input	[hcbits-3:0]	OutRequestPair;
	
	//---------------------------------------------------------------
	//	Interface with Game State
	//---------------------------------------------------------------
	input [3:0]	Channel;		//just displaying a single hex digit
	input [7:0]	Src;			//just displaying two hex digits
	input	[7:0]	Dst;			//just displaying two hex digits
	input	Turn;					//displaying arrow
	input [6:0]	Wins;			//must convert into 3 digits
	input	[6:0]	Losses;		//must convert into 3 digits
	input	[7:0]	Shots;		//must convert into 3 digits
	input CNS;
	input [11:0] VsStatus;	//Status of Opponent's Ships
	
	input [2:0] Msg;
	input 		Horiz;
	input [3:0] Mode;
	input [3:0] CursorX;
	input [3:0] CursorY;
	
	input [9:0] RMyPosData; 
	input [9:0]	RVsPosData;
	
	input[3:0] Shot1;
	input[3:0] Shot2;
	input[3:0] Shot3;
	input[3:0] Loss1;
	input[3:0] Loss2;
	input[3:0] Loss3;
	input[3:0] Win1;
	input[3:0] Win2;
	input[3:0] Win3;
	
	output[3:0]	RMyPosRow;
	output[3:0] RMyPosCol;
	output[3:0]	RVsPosRow;
	output[3:0] RVsPosCol;
	
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg	[31:0]		DOutRaw;
	reg	Pipe, Pipe2;
	//---------------------------------------------------------------

	wire [1599:0] DStarImage;
	assign DStarImage = {
						40'b0000000000000000111110000000000000000000,
						40'b0000000000011111111111111100000000000000,
						40'b0000000000111111000001111110000000000000,
						40'b0000000001100000000000000011000000000000,
						40'b0000000111000000000000111111110000000000,
						40'b0000001100000000000001001001011000000000,
						40'b0000011000000000000010001000101100000000,
						40'b0000110000000000000100011100010110000000,
						40'b0000100000000000000100100010010010000000,
						40'b0001000000000000001001001001001001000000,
						40'b0011000000000000001111010101111001100000,
						40'b0010000000000000001001001001001000100000,
						40'b0100000000000000000100100010010000010000,
						40'b0100000000000000000100011100010000010000,
						40'b0100000000000000000010001000100000010000,
						40'b0100000000000000000001001001000000010000,
						40'b1100000000000000000000111110000000011000,
						40'b1000000000000000000000000000000000001000,
						40'b1111000000000000000000000000000001111000,
						40'b1000111111000000000000000001111110001000,
						40'b1111000000111111111111111110000001111000,
						40'b1100111111000000000000000001111110011000,
						40'b0100000000111111111111111110000000010000,
						40'b0100000000000000000000000000000000010000,
						40'b0100000000000000000000000000000000010000,
						40'b0100000000000000000000000000000000010000,
						40'b0010000000000000000000000000000000100000,
						40'b0011000000000000000000000000000001100000,
						40'b0001000000000000000000000000000001000000,
						40'b0000100000000000000000000000000010000000,
						40'b0000110000000000000000000000000110000000,
						40'b0000011000000000000000000000001100000000,
						40'b0000001100000000000000000000011000000000,
						40'b0000000111000000000000000001110000000000,
						40'b0000000001100000000000000011000000000000,
						40'b0000000000111111000001111110000000000000,
						40'b0000000000011111111111111100000000000000,
						40'b0000000000000000111110000000000000000000,
						40'b0000000000000000000000000000000000000000,
						40'b0000000000000000000000000000000000000000};

	/*
	wire[3:0] Shot1;
	wire[3:0] Shot2;
	wire[3:0] Shot3;
	wire[3:0] Loss1;
	wire[3:0] Loss2;
	wire[3:0] Loss3;
	wire[3:0] Win1;
	wire[3:0] Win2;
	wire[3:0] Win3;
	wire[3:0] Shot1wait;
	wire[3:0] Shot2wait;
	wire[3:0] Shot3wait;
	wire[3:0] Loss1wait;
	wire[3:0] Loss2wait;
	wire[3:0] Loss3wait;
	wire[3:0] Win1wait;
	wire[3:0] Win2wait;
	wire[3:0] Win3wait;
	*/
	
	always @ (posedge Clock) begin
		if(Reset)
			Pipe <= 1'b0;
		else if(OutRequest)
			Pipe <= 1'b1;
		else
			Pipe <= 1'b0;
	
		if(Pipe)
			Pipe2 <= 1'b1;
		else
			Pipe2 <= 1'b0;
	end
	
	wire [63:0] Cursor;
	
	wire [63:0] SDestroyer1h;
	wire [63:0] SDestroyer2h;
	wire [63:0] SDestroyer3h;
	wire [63:0] SDestroyer4h;
	wire [63:0] SDestroyer5h;
	
	wire [63:0] SDestroyer1v;
	wire [63:0] SDestroyer2v;
	wire [63:0] SDestroyer3v;
	wire [63:0] SDestroyer4v;
	wire [63:0] SDestroyer5v;
	
	wire [63:0] Tie1;
	wire [63:0] Tie2;
	wire [63:0] Tie3;
	
	wire [63:0] Tie1v;
	wire [63:0] Tie2v;
	wire [63:0] Tie3v;
	
	
	
	parameter LineStartBoards = 9'h024;
	parameter LineEndBoards = 9'h124;
	parameter PairStartBoard1 = 9'h014;
	parameter PairEndBoard1 = 9'h094;
	
	parameter PairStartBoard2 = 9'h0D0;
	parameter PairEndBoard2 = 9'h150;
	
	parameter LineStartShips1 = 9'h140+12;
	parameter LineEndShips1 = 9'h150+12;
	
	parameter LineStartShips2 = 9'h158+12;
	parameter LineEndShips2 = 9'h168+12;	
	
	wire [8:0] PairStartTie1;
	wire [8:0] PairEndTie1;
	wire [8:0] PairStartTie2;
	wire [8:0] PairEndTie2;
	wire [8:0] PairStartTie3;
	wire [8:0] PairEndTie3;
	
	assign PairEndTie1 = PairStartTie1 + 8;
	assign PairStartTie2 = PairEndTie1;
	assign PairEndTie2 = PairStartTie2 + 8;
	assign PairStartTie3 = PairEndTie2;
	assign PairEndTie3 = PairStartTie3 + 8;
	
	wire [8:0] PairStartStar1;
	wire [8:0] PairEndStar1;
	wire [8:0] PairStartStar2;
	wire [8:0] PairEndStar2;
	wire [8:0] PairStartStar3;
	wire [8:0] PairEndStar3;
	wire [8:0] PairStartStar4;
	wire [8:0] PairEndStar4;
	wire [8:0] PairStartStar5;
	wire [8:0] PairEndStar5;
	
	
	parameter LineStartDStar = 9'h140+12;
	parameter LineEndDStar = 9'h190+12;
	
	parameter LineStartVsShips = 9'h130;
	parameter PairStartSunk = 9'h0D0 + 48;
	parameter PairStartVsShips = 9'h0D0 + 24;
	
	
	assign PairEndStar1 = PairStartStar1 + 8;
	assign PairStartStar2 = PairEndStar1;
	assign PairEndStar2 = PairStartStar2 + 8;
	assign PairStartStar3 = PairEndStar2;
	assign PairEndStar3 = PairStartStar3 + 8;
	assign PairStartStar4 = PairEndStar3;
	assign PairEndStar4 = PairStartStar4 + 8;
	assign PairStartStar5 = PairEndStar4;
	assign PairEndStar5 = PairStartStar5 + 8;	
	
	wire [8:0] PairStartDStar;
	wire [8:0] PairEndDStar;
	
	wire [22:0] Time;
	wire [19:0] Time2;
	wire [18:0] Time3;
	
	Counter Timer(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(~Reset), .In(23'h0), .Count(Time));
				defparam Timer.width = 23;
				
	Counter Timer2(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(~Reset), .In(20'h0), .Count(Time2));
				defparam Timer2.width = 20;
				
	Counter Timer3(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(~Reset), .In(19'h0), .Count(Time3));
				defparam Timer3.width = 19;
	
	Counter DStartLocation(.Clock(Clock), .Reset(Reset | (PairStartDStar == (PairStartBoard2-40))), .Set(1'b0), .Load(1'b0), .Enable(Time == 23'd6750000), .In(9'h000), .Count(PairStartDStar));
				defparam DStartLocation.width = 9;
				
	Counter StarDLocation(.Clock(Clock), .Reset(Reset | (PairStartStar1 == (PairStartBoard2-40))), .Set(1'b0), .Load(1'b0), .Enable(Time2 == 20'd843750), .In(9'h000), .Count(PairStartStar1));
				defparam StarDLocation.width = 9;
				
	Counter TIELocation(.Clock(Clock), .Reset(Reset | (PairStartTie1 == (PairStartBoard2-24))), .Set(1'b0), .Load(1'b0), .Enable(Time3 == 19'd337500), .In(9'h000), .Count(PairStartTie1));
				defparam TIELocation.width = 9;
	
	//assign PairStartDStar = 9'h098;
	assign PairEndDStar = PairStartDStar + 9'd40;
	
	/*PARMETERS FOR GAME INFO*/
	
	parameter LineStartMsg = 9'h198;
	parameter PairStartMsg = 8'h0D0;
	parameter LineStartWireless = 9'h1B8;
	parameter PairStartWireless = 9'h014;
	parameter LineStartGameInfo = 8'h024;
	parameter PairStartGameInfo = 9'h0AC;
	parameter PairStartDst = 9'h0B4;
	parameter PairStartCNS = 9'h0B4 + 96;
	
	parameter LineStartWon = 9'h054;
	parameter LineStartLost = 9'h084;
	parameter LineStartShots = 9'h0B4;	
	
	ShipROM Cursor(.Data(10'b0000100010), .DotMatrix(Cursor));
	ShipROM TIE1(.Data(10'b0000000010), .DotMatrix(Tie1));
	ShipROM TIE2(.Data(10'b0000000100), .DotMatrix(Tie2));
	ShipROM TIE3(.Data(10'b0000000110), .DotMatrix(Tie3));
	ShipROM TIE1v(.Data(10'b0000001000), .DotMatrix(Tie1v));
	ShipROM TIE2v(.Data(10'b0000001010), .DotMatrix(Tie2v));
	ShipROM TIE3v(.Data(10'b0000001100), .DotMatrix(Tie3v));
	ShipROM Star1(.Data(10'b0000001110), .DotMatrix(SDestroyer1h));
	ShipROM Star2(.Data(10'b0000010000), .DotMatrix(SDestroyer2h));
	ShipROM Star3(.Data(10'b0000010010), .DotMatrix(SDestroyer3h));
	ShipROM Star4(.Data(10'b0000010100), .DotMatrix(SDestroyer4h));
	ShipROM Star5(.Data(10'b0000010110), .DotMatrix(SDestroyer5h));
	ShipROM Star1v(.Data(10'b0000011000), .DotMatrix(SDestroyer1v));
	ShipROM Star2v(.Data(10'b0000011010), .DotMatrix(SDestroyer2v));
	ShipROM Star3v(.Data(10'b0000011100), .DotMatrix(SDestroyer3v));
	ShipROM Star4v(.Data(10'b0000011110), .DotMatrix(SDestroyer4v));
	ShipROM Star5v(.Data(10'b0000100000), .DotMatrix(SDestroyer5v));
	
	wire	[8:0]	ShipHeadLine;
	wire	[8:0]	ShipHeadPair;
	wire 	[5:0] index;
	wire 	[5:0] index2;
	wire 	[5:0] index3;
	wire 	[5:0] index4;
	wire 	[5:0] index5;
	
	assign index = Horiz ? ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8    :    ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8;
	assign index2 = Horiz ? ((OutRequestPair-(ShipHeadPair+9'h008+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8   :   ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h010+9'h001))>>1)*8;
	assign index3 = Horiz ? ((OutRequestPair-(ShipHeadPair+9'h010+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8   :   ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h020+9'h001))>>1)*8;
	assign index4 = Horiz ? ((OutRequestPair-(ShipHeadPair+9'h018+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8   :   ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h030+9'h001))>>1)*8;
	assign index5 = Horiz ? ((OutRequestPair-(ShipHeadPair+9'h020+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h001))>>1)*8   :   ((OutRequestPair-(ShipHeadPair+9'h001)))%8 + ((OutRequestLine-(ShipHeadLine+9'h040+9'h001))>>1)*8;
	
	assign ShipHeadLine = CursorY*16 + 9'h024;
	assign ShipHeadPair = CursorX*8 + 9'h014;
	assign RMyPosRow = (OutRequestLine-(LineStartBoards+9'h001))>>4;
	assign RMyPosCol = (OutRequestPair-(PairStartBoard1+9'h001))>>3;
	assign RVsPosRow = (OutRequestLine-(LineStartBoards+9'h001))>>4;
	assign RVsPosCol = (OutRequestPair-(PairStartBoard2+9'h001))>>3;

	//wire [63:0] Charin;	
	//wire [63:0] Char;
	wire [63:0] Board1Datain;
	wire [63:0] Board2Datain;
	wire [63:0] Board1Data;
	wire [63:0] Board2Data;

	reg[31:0]	NewColor;
	reg[31:0]	NewColor2;
	reg [7:0] 	CharCode;
	//CharROM	CharRom(.DotMatrix(Charin), .CharCode(CharCode));
		
	/*UPDATING COLORS DEPENDING ON RAM DATA*/
	ShipROM B1(.Data(RMyPosData), .DotMatrix(Board1Datain));
	ShipROM B2(.Data(RVsPosData), .DotMatrix(Board2Datain));
	
	Register	B1Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(1'b1), .In(Board1Datain), .Out(Board1Data));
				defparam B1Reg.width = 64;
	Register	B2Reg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(1'b1), .In(Board2Datain), .Out(Board2Data));
				defparam B2Reg.width = 64;
				
	

	wire [31:0] Char;
	WriteBlock	BlockP(.Clock(Clock), .Reset(Reset), .ShiporChar(1'b0), .OutRequestPair(OutRequestPair), .OutRequestLine(OutRequestLine), .StartPair(StartCharPair), .StartLine(StartCharLine), .ShipCode(10'h000), .CharCode(CharCode), .DOut(Char));
	
	reg [8:0] StartCharLine;
	reg [8:0] StartCharPair;

	always @ (RMyPosData) begin
		NewColor = 32'h10801080;
		
		case(RMyPosData[5:1])
			5'b00000: begin
				NewColor = 32'h574b57ad;
				//NewColor = 32'h40914010;
			end
			
			5'b10001: begin
				NewColor = 32'h51ef515a;
			end
			
			default: begin
				if(RMyPosData[0])
					NewColor = 32'h51ef515a;
				else
					NewColor = 32'hA080A080;
			end
		endcase
	end
	
	always @ (RVsPosData) begin
		NewColor2 = 32'h10801080;
		
		case(RVsPosData[5:1])
			5'b00000: begin
				NewColor2 = 32'h574b57ad;
				//NewColor2 = 32'h40914010;
			end
			
			5'b10001: begin
				NewColor2 = 32'h51ef515a;
			end
			
			5'b10010: begin
				if(RVsPosData[0])
					NewColor2 = 32'h51ef515a;
				else
					NewColor2 = 32'heb80eb80;
			end
			
			default: begin
				NewColor2 = 32'hA080A080;
			end
		endcase
	end
	
	always @ ( * ) begin
		DOutRaw =	32'h10801080;
		CharCode = 8'h00;
		StartCharLine = 9'h000;
		StartCharPair = 9'h000;
		
		
		/*WRITING SOME GAME INFO*/
		/*Write Turn:*/
		if((LineStartGameInfo < OutRequestLine) & (OutRequestLine <= (LineStartGameInfo + 16))) begin
			StartCharLine = LineStartGameInfo;
			DOutRaw = Char;
			
			if((9'h09C < OutRequestPair) & (OutRequestPair <= 9'h0A4)) begin
				CharCode = "T";
				StartCharPair = 9'h09C;
			end
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = "u";
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = "r";
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = "n";
				StartCharPair = 9'h0B4;
			end
			
			if((9'h0BC < OutRequestPair) & (OutRequestPair <= 9'h0C4)) begin
				CharCode = ":";
				StartCharPair = 9'h0BC;
			end

		end

		/*Write Won:*/
		if((LineStartWon< OutRequestLine) & (OutRequestLine <= (LineStartWon + 16))) begin
			StartCharLine = LineStartWon;
			DOutRaw = Char;
			
			if((9'h09C < OutRequestPair) & (OutRequestPair <= 9'h0A4)) begin
				CharCode = "W";
				StartCharPair = 9'h09C;
			end
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = "o";
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = "n";
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = ":";
				StartCharPair = 9'h0B4;
			end
			
		end
		
		/*Write Lost:*/
		if((LineStartLost < OutRequestLine) & (OutRequestLine <= (LineStartLost + 16))) begin
			StartCharLine = LineStartLost;
			DOutRaw = Char;
			
			if((9'h09C < OutRequestPair) & (OutRequestPair <= 9'h0A4)) begin
				CharCode = "L";
				StartCharPair = 9'h09C;
			end
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = "o";
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = "s";
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = "t";
				StartCharPair = 9'h0B4;
			end
			
			if((9'h0BC < OutRequestPair) & (OutRequestPair <= 9'h0C4)) begin
				CharCode = ":";
				StartCharPair = 9'h0BC;
			end

		end
		
		/*Write Shots:*/
		if((LineStartShots < OutRequestLine) & (OutRequestLine <= (LineStartShots + 16))) begin
			StartCharLine = LineStartShots;
			DOutRaw = Char;
			
			if((9'h09C < OutRequestPair) & (OutRequestPair <= 9'h0A4)) begin
				CharCode = "S";
				StartCharPair = 9'h09C;
			end
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = "h";
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = "o";
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = "t";
				StartCharPair = 9'h0B4;
			end
			
			if((9'h0BC < OutRequestPair) & (OutRequestPair <= 9'h0C4)) begin
				CharCode = "s";
				StartCharPair = 9'h0BC;
			end
			
			if((9'h0C4 < OutRequestPair) & (OutRequestPair <= 9'h0CC)) begin
				CharCode = ":";
				StartCharPair = 9'h0C4;
			end
		end
		
		/*Make Arrow*/
		if((LineStartGameInfo+16 < OutRequestLine) & (OutRequestLine <= (LineStartGameInfo + 32))) begin
			StartCharLine = LineStartGameInfo+16;
			DOutRaw = Char;
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				if(Turn)
					CharCode = 8'hDF;
				else
					CharCode = 8'hEF;
				StartCharPair = 9'h0AC;
			end
		end
		
		/*Number Won*/
		if((LineStartWon+16 < OutRequestLine) & (OutRequestLine <= (LineStartWon + 32))) begin
			StartCharLine = LineStartWon+16;
			DOutRaw = Char;
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = Win1+ 8'h30;
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = Win2+ 8'h30;
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = Win3+ 8'h30;
				StartCharPair = 9'h0B4;
			end
		end
		
		/*Number Lost*/
		if((LineStartLost+16 < OutRequestLine) & (OutRequestLine <= (LineStartLost + 32))) begin
			StartCharLine = LineStartLost+16;
			DOutRaw = Char;
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = Loss1+ 8'h30;
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = Loss2+ 8'h30;
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = Loss3+ 8'h30;
				StartCharPair = 9'h0B4;
			end
		end
		
		/*Number Shots*/
		if((LineStartShots+16 < OutRequestLine) & (OutRequestLine <= (LineStartShots + 32))) begin
			StartCharLine = LineStartShots+16;
			DOutRaw = Char;
			
			if((9'h0A4 < OutRequestPair) & (OutRequestPair <= 9'h0AC)) begin
				CharCode = Shot1+ 8'h30;
				StartCharPair = 9'h0A4;
			end
			
			if((9'h0AC < OutRequestPair) & (OutRequestPair <= 9'h0B4)) begin
				CharCode = Shot2+ 8'h30;
				StartCharPair = 9'h0AC;
			end
			
			if((9'h0B4 < OutRequestPair) & (OutRequestPair <= 9'h0BC)) begin
				CharCode = Shot3+ 8'h30;
				StartCharPair = 9'h0B4;
			end
		end
		
		if((9'h010 < OutRequestLine) & (OutRequestLine <= 9'h020)) begin
			StartCharLine = 9'h010;
			DOutRaw = Char;
			
			/*Write Player*/
			if((9'h034 < OutRequestPair) & (OutRequestPair <= 9'h03C)) begin
				CharCode = "P";
				StartCharPair = 9'h034;

			end
			
			if((9'h03C < OutRequestPair) & (OutRequestPair <= 9'h044)) begin
				CharCode = "l";
				StartCharPair = 9'h03C;
			end
			
			if((9'h044 < OutRequestPair) & (OutRequestPair <= 9'h04C)) begin
				CharCode = "a";
				StartCharPair = 9'h044;
			end
			
			if((9'h04C < OutRequestPair) & (OutRequestPair <= 9'h054)) begin
				CharCode = "y";
				StartCharPair = 9'h04C;
			end
			
			if((9'h054 < OutRequestPair) & (OutRequestPair <= 9'h05C)) begin
				CharCode = "e";
				StartCharPair = 9'h054;
			end
			
			if((9'h05C < OutRequestPair) & (OutRequestPair <= 9'h064)) begin
				CharCode = "r";
				StartCharPair = 9'h05c;
			end
			
			/*Write Opponent*/
			
			//O
			
			if((9'h0F0 < OutRequestPair) & (OutRequestPair <= 9'h0F8)) begin
				CharCode = "O";
				StartCharPair = 9'h0F0;
			end
			
			//pp
			if((9'h0F8 < OutRequestPair) & (OutRequestPair <= 9'h108)) begin
				CharCode = "p";
				StartCharPair = 9'h0F8;
			end
			
			//o
			if((9'h108 < OutRequestPair) & (OutRequestPair <= 9'h110)) begin
				CharCode = "o";
				StartCharPair = 9'h108;
			end
			
			//n
			if((9'h110 < OutRequestPair) & (OutRequestPair <= 9'h118)) begin
				CharCode = "n";
				StartCharPair = 9'h110;
			end
			
			//e
			if((9'h118 < OutRequestPair) & (OutRequestPair <= 9'h120)) begin
				CharCode = "e";
				StartCharPair = 9'h118;
			end
			
			//n
			if((9'h120 < OutRequestPair) & (OutRequestPair <= 9'h128)) begin
				CharCode = "n";
				StartCharPair = 9'h120;
			end
			
			//t
			if((9'h128 < OutRequestPair) & (OutRequestPair <= 9'h130)) begin
				CharCode = "t";
				StartCharPair = 9'h128;
			end
			
			
		end
		
		
		/*Writing Wireless Info*/
		if((LineStartWireless < OutRequestLine) & (OutRequestLine <= (LineStartWireless+9'h010))) begin
			StartCharLine = LineStartWireless;
			DOutRaw = Char;
			//C
			if((9'h014 < OutRequestPair) & (OutRequestPair <= 9'h01C)) begin
				CharCode = "C";
				StartCharPair = 9'h014;
			end
			//h
			if((9'h01C < OutRequestPair) & (OutRequestPair <= 9'h024)) begin
				CharCode = "h";
				StartCharPair = 9'h01C;
			end
			//:
			if((9'h024 < OutRequestPair) & (OutRequestPair <= 9'h02C)) begin
				CharCode = ":";
				StartCharPair = 9'h024;
			end
			
			if((9'h02C < OutRequestPair) & (OutRequestPair <= 9'h034)) begin
				StartCharPair = 9'h02C;
				if((0 <= Channel) & (Channel <= 9)) begin
					CharCode = Channel + 8'h30;
				end
				else begin
					CharCode = Channel + 8'h57;
				end

			end
			
			//S
			if((9'h05C < OutRequestPair) & (OutRequestPair <= 9'h064)) begin
				CharCode = "S";
				StartCharPair = 9'h05c;
			end
			
			//r
			if((9'h064 < OutRequestPair) & (OutRequestPair <= 9'h06C)) begin
				CharCode = "r";
				StartCharPair = 9'h064;
			end
			
			//c
			if((9'h06C < OutRequestPair) & (OutRequestPair <= 9'h074)) begin
				CharCode = "c";
				StartCharPair = 9'h06C;
			end
			//:
			if((9'h074 < OutRequestPair) & (OutRequestPair <= 9'h07C)) begin
				CharCode = ":";
				StartCharPair = 9'h074;
			end
			
			//Src
			if((9'h07C < OutRequestPair) & (OutRequestPair <= 9'h084)) begin
				StartCharPair = 9'h07C;
				if((0 <= Src[7:4]) & (Src[7:4] <= 9)) begin
					CharCode = Src[7:4] + 8'h30;
				end
				else begin
					CharCode = Src[7:4] + 8'h57;
				end

			end
			
			if((9'h084 < OutRequestPair) & (OutRequestPair <= 9'h08C)) begin
				StartCharPair = 9'h08C;
				if((0 <= Src[3:0]) & (Src[3:0] <= 9)) begin
					CharCode = Src[3:0] + 8'h30;
				end
				else begin
					CharCode = Src[3:0] + 8'h57;
				end

			end
			
			//D
			if((PairStartDst < OutRequestPair) & (OutRequestPair <= PairStartDst+8)) begin
				CharCode = "D";
				StartCharPair = PairStartDst;
			end
			
			//s
			if(((PairStartDst+8) < OutRequestPair) & (OutRequestPair <= (PairStartDst+16))) begin
				CharCode = "s";
				StartCharPair = PairStartDst+8;
			end
			
			//t
			if(((PairStartDst+16) < OutRequestPair) & (OutRequestPair <= (PairStartDst+24))) begin
				CharCode = "t";
				StartCharPair = PairStartDst+16;
			end
			//:
			if(((PairStartDst+24) < OutRequestPair) & (OutRequestPair <= (PairStartDst+32))) begin
				CharCode = ":";
				StartCharPair = PairStartDst+24;
			end
			
			//Dst
			if(((PairStartDst+32) < OutRequestPair) & (OutRequestPair <= (PairStartDst+40))) begin
				StartCharPair = PairStartDst+32;
				if((0 <= Dst[7:4]) & (Dst[7:4] <= 9)) begin
					CharCode = Dst[7:4] + 8'h30;
				end
				else begin
					CharCode = Dst[7:4] + 8'h57;
				end

			end
			
			if((PairStartDst+40 < OutRequestPair) & (OutRequestPair <= PairStartDst+48)) begin
				StartCharPair = PairStartDst+40;
				if((0 <= Dst[3:0]) & (Dst[3:0] <= 9)) begin
					CharCode = Dst[3:0] + 8'h30;
				end
				else begin
					CharCode = Dst[3:0] + 8'h57;
				end

			end
			
			//CNS
			if((PairStartCNS < OutRequestPair) & (OutRequestPair <= PairStartCNS + 8)) begin
				StartCharPair = PairStartCNS;
				if(CNS)
					CharCode = "C";
				else
					CharCode = "S";		
			end
			
			if(((PairStartCNS+8) < OutRequestPair) & (OutRequestPair <= (PairStartCNS + 16))) begin
				StartCharPair = PairStartCNS+8;
				if(CNS)
					CharCode = "l";
				else
					CharCode = "e";		
			end
			
			if(((PairStartCNS+16) < OutRequestPair) & (OutRequestPair <= (PairStartCNS + 24))) begin
				StartCharPair = PairStartCNS+16;
				if(CNS)
					CharCode = "i";
				else
					CharCode = "r";		
			end
			
			if(((PairStartCNS+24) < OutRequestPair) & (OutRequestPair <= (PairStartCNS + 32))) begin
				StartCharPair = PairStartCNS+24;
				if(CNS)
					CharCode = "e";
				else
					CharCode = "v";		
			end
			
			if(((PairStartCNS+32) < OutRequestPair) & (OutRequestPair <= (PairStartCNS + 40))) begin
				StartCharPair = PairStartCNS+32;
				if(CNS)
					CharCode = "n";
				else
					CharCode = "e";		
			end
			
			if(((PairStartCNS+40) < OutRequestPair) & (OutRequestPair <= (PairStartCNS + 48))) begin
				StartCharPair = PairStartCNS+40;
				if(CNS)
					CharCode = "t";
				else
					CharCode = "r";		
			end
		
		end
		
		/*FOR TWO BOARDS*/
		if((LineStartBoards < OutRequestLine) &  (OutRequestLine <= LineEndBoards)) begin
					
			if((PairStartBoard1 < OutRequestPair) & (OutRequestPair <= PairEndBoard1)) begin
				
				/*Drawing Initial Board*/
				if(Board1Data[((OutRequestPair-(PairStartBoard1+9'h001)))%8 + ((OutRequestLine-(LineStartBoards+9'h001))>>1)*8])
					DOutRaw = NewColor;
				
				//2-length TIE
				if((Mode == 4'h1) | (Mode == 4'h2) | (Mode == 4'h3) | (Mode == 4'h4)) begin
					//if Horizontal
					if(Horiz) begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(Tie1[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+1))) begin
							if(Tie3[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
											
					end
					
					else begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(Tie1v[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
												
						if((RMyPosRow == (CursorY+1)) & (RMyPosCol == CursorX)) begin
							if(Tie3v[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
				end
				
					
				//3-length TIE
				else if((Mode == 4'h5) | (Mode == 4'h6) | (Mode == 4'h7) | (Mode == 4'h8)) begin
					//if Horizontal
					if(Horiz) begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(Tie1[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+1))) begin
							if(Tie2[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+2))) begin
							if(Tie3[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
											
					end
					
					else begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(Tie1v[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
												
						if((RMyPosRow == (CursorY+1)) & (RMyPosCol == CursorX)) begin
							if(Tie2v[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+2)) & (RMyPosCol == CursorX)) begin
							if(Tie3v[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
				end
				
				//4-length SDestroyer
				else if((Mode == 4'h9) | (Mode == 4'hA) | (Mode == 4'hB)) begin
					//if Horizontal
					if(Horiz) begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(SDestroyer1h[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+1))) begin
							if(SDestroyer3h[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+2))) begin
							if(SDestroyer4h[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+3))) begin
							if(SDestroyer5h[index4])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
					
					else begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(SDestroyer1v[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
												
						if((RMyPosRow == (CursorY+1)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer3v[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+2)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer4v[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+3)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer5v[index4])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
				end
				
				//if 5-length SDestroyer
				else if(Mode == 4'hC)	begin
					//if Horizontal
					if(Horiz) begin
							
						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(SDestroyer1h[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+1))) begin
							if(SDestroyer2h[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+2))) begin
							if(SDestroyer3h[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+3))) begin
							if(SDestroyer4h[index4])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == CursorY) & (RMyPosCol == (CursorX+4))) begin
							if(SDestroyer5h[index5])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
					
					else begin

						if((RMyPosRow == CursorY) & (RMyPosCol == CursorX)) begin
							if(SDestroyer1v[index])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						
						end
						
						if((RMyPosRow == (CursorY+1)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer2v[index2])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+2)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer3v[index3])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+3)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer4v[index4])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
						
						if((RMyPosRow == (CursorY+4)) & (RMyPosCol == CursorX)) begin
							if(SDestroyer5v[index5])
								DOutRaw = 32'hA080A080;
							else
								DOutRaw = 32'h10801080;
						end
					end
				end
				
				
			end
				
			if((PairStartBoard2 < OutRequestPair) & (OutRequestPair <= PairEndBoard2)) begin
				
				if(Board2Data[((OutRequestPair-(PairStartBoard2+9'h001)))%8 + ((OutRequestLine-(LineStartBoards+9'h001))>>1)*8])
						DOutRaw = NewColor2;
				
				if((RVsPosRow == CursorY) & (RVsPosCol == CursorX) & (Mode == 4'hD)) begin
					if(Cursor[((OutRequestPair-(PairStartBoard2+9'h001)))%8 + ((OutRequestLine-(LineStartBoards+9'h001))>>1)*8])
						DOutRaw = 32'h51ef515a;
				end
			end
			
			
			
		end
		
		/*DRAW DEATH STAR*/
		
		if((LineStartDStar < OutRequestLine) & (OutRequestLine <= LineEndDStar)) begin
			/*if(DStarImage[95])
				DOutRaw = 32'hA080A080;
			*/
			if((PairStartDStar < OutRequestPair) & (OutRequestPair <= PairEndDStar)) begin
				if(DStarImage[1599-((OutRequestPair-(PairStartDStar+9'h001)) + ((OutRequestLine-(LineStartDStar+9'h001))>>1)*40)])
					DOutRaw = 32'h80808080;
					
			end
		end
	
		
		/*Draw Ships*/
		if((LineStartShips1 < OutRequestLine) &  (OutRequestLine <= LineEndShips1)) begin
			//DOutRaw = 32'h10801080;
			
			if((PairStartTie1 < OutRequestPair) & (OutRequestPair <= PairEndTie1))
				if(Tie1[((OutRequestPair-(PairStartTie1+9'h001)))%8 + ((OutRequestLine-(LineStartShips1+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			
			if((PairStartTie2 < OutRequestPair) & (OutRequestPair <= PairEndTie2))
				if(Tie2[((OutRequestPair-(PairStartTie2+9'h001)))%8 + ((OutRequestLine-(LineStartShips1+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			
			if((PairStartTie3 < OutRequestPair) & (OutRequestPair <= PairEndTie3))
				if(Tie3[((OutRequestPair-(PairStartTie3+9'h001)))%8 + ((OutRequestLine-(LineStartShips1+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
		end
		
		if((LineStartShips2 < OutRequestLine) &  (OutRequestLine <= LineEndShips2)) begin
			//DOutRaw = 32'h10801080;
			
			if((PairStartStar1 < OutRequestPair) & (OutRequestPair <= PairEndStar1))
				if(SDestroyer1h[((OutRequestPair-(PairStartStar1+9'h001)))%8 + ((OutRequestLine-(LineStartShips2+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
					
			if((PairStartStar2 < OutRequestPair) & (OutRequestPair <= PairEndStar2))
				if(SDestroyer2h[((OutRequestPair-(PairStartStar2+9'h001)))%8 + ((OutRequestLine-(LineStartShips2+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
					
			if((PairStartStar3 < OutRequestPair) & (OutRequestPair <= PairEndStar3))
				if(SDestroyer3h[((OutRequestPair-(PairStartStar3+9'h001)))%8 + ((OutRequestLine-(LineStartShips2+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
					
			if((PairStartStar4 < OutRequestPair) & (OutRequestPair <= PairEndStar4))
				if(SDestroyer4h[((OutRequestPair-(PairStartStar4+9'h001)))%8 + ((OutRequestLine-(LineStartShips2+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
					
			if((PairStartStar5 < OutRequestPair) & (OutRequestPair <= PairEndStar5))
				if(SDestroyer5h[((OutRequestPair-(PairStartStar5+9'h001)))%8 + ((OutRequestLine-(LineStartShips2+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
		
		end
		
		//Sunk:
		if((LineStartVsShips < OutRequestLine) & (OutRequestLine <= LineStartVsShips+16) & (OutRequestPair>PairStartSunk)) begin
			StartCharLine = LineStartVsShips;
			DOutRaw = Char;
			
			if((PairStartSunk < OutRequestPair) & (OutRequestPair <= PairStartSunk+8)) begin
				CharCode = "S";
				StartCharPair = PairStartSunk;
			end
			
			if((PairStartSunk+8 < OutRequestPair) & (OutRequestPair <= PairStartSunk+16)) begin
				CharCode = "u";
				StartCharPair = PairStartSunk+8;
			end
			
			if((PairStartSunk+16 < OutRequestPair) & (OutRequestPair <= PairStartSunk+24)) begin
				CharCode = "n";
				StartCharPair = PairStartSunk+16;
			end
			
			if((PairStartSunk+24 < OutRequestPair) & (OutRequestPair <= PairStartSunk+32)) begin
				CharCode = "k";
				StartCharPair = PairStartSunk+24;
			end
			
			if((PairStartSunk+32 < OutRequestPair) & (OutRequestPair <= PairStartSunk+40)) begin
				CharCode = ":";
				StartCharPair = PairStartSunk+32;
			end

		end
		
		//Star Destroyer Big
		if((LineStartVsShips+16 < OutRequestLine) & (OutRequestLine <= LineStartVsShips+32) & (OutRequestPair>PairStartVsShips)) begin
			StartCharLine = LineStartVsShips+16;
			DOutRaw = Char;
			
			if((PairStartVsShips < OutRequestPair) & (OutRequestPair <= PairStartVsShips+8)) begin
				CharCode = VsStatus[11]+8'h30;
				StartCharPair = PairStartVsShips;
			end
			
			if((PairStartVsShips+8 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+16)) begin
				CharCode = 8'h2f;
				StartCharPair = PairStartVsShips+8;
			end
			
			if((PairStartVsShips+16 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+24)) begin
				CharCode = "1";
				StartCharPair = PairStartVsShips+16;
			end
			
			//Draw the Ship
			if((PairStartVsShips+32 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+40)) begin
				if(SDestroyer1h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+40 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+48)) begin
				if(SDestroyer2h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+48 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+56)) begin
				if(SDestroyer3h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+56 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+64)) begin
				if(SDestroyer4h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+64 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+72)) begin
				if(SDestroyer5h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end

		end
		
		//Star Destroyer Small
		if((LineStartVsShips+32 < OutRequestLine) & (OutRequestLine <= LineStartVsShips+48) & (OutRequestPair>PairStartVsShips)) begin
			StartCharLine = LineStartVsShips+32;
			DOutRaw = Char;
			
			if((PairStartVsShips < OutRequestPair) & (OutRequestPair <= PairStartVsShips+8)) begin
				CharCode = VsStatus[10]+VsStatus[9]+VsStatus[8]+8'h30;
				StartCharPair = PairStartVsShips;
			end
			
			if((PairStartVsShips+8 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+16)) begin
				CharCode = 8'h2f;
				StartCharPair = PairStartVsShips+8;
			end
			
			if((PairStartVsShips+16 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+24)) begin
				CharCode = "3";
				StartCharPair = PairStartVsShips+16;
			end
			
			//Draw the Ship
			if((PairStartVsShips+32 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+40)) begin
				if(SDestroyer1h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+40 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+48)) begin
				if(SDestroyer3h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+48 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+56)) begin
				if(SDestroyer4h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+56 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+64)) begin
				if(SDestroyer5h[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end

		end
		
		//TIE Big
		if((LineStartVsShips+48 < OutRequestLine) & (OutRequestLine <= LineStartVsShips+64) & (OutRequestPair>PairStartVsShips)) begin
			StartCharLine = LineStartVsShips+48;
			DOutRaw = Char;
			
			if((PairStartVsShips < OutRequestPair) & (OutRequestPair <= PairStartVsShips+8)) begin
				CharCode = VsStatus[7]+VsStatus[6]+VsStatus[5]+VsStatus[4]+8'h30;
				StartCharPair = PairStartVsShips;
			end
			
			if((PairStartVsShips+8 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+16)) begin
				CharCode = 8'h2f;
				StartCharPair = PairStartVsShips+8;
			end
			
			if((PairStartVsShips+16 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+24)) begin
				CharCode = "4";
				StartCharPair = PairStartVsShips+16;
			end
			
			//Draw the Ship
			if((PairStartVsShips+32 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+40)) begin
				if(Tie1[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+40 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+48)) begin
				if(Tie2[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+48 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+56)) begin
				if(Tie3[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			

		end
		
		//TIE Small
		if((LineStartVsShips+64 < OutRequestLine) & (OutRequestLine <= LineStartVsShips+80) & (OutRequestPair>PairStartVsShips)) begin
			StartCharLine = LineStartVsShips+64;
			DOutRaw = Char;
			
			if((PairStartVsShips < OutRequestPair) & (OutRequestPair <= PairStartVsShips+8)) begin
				CharCode = VsStatus[3]+VsStatus[2]+VsStatus[1]+VsStatus[0]+8'h30;
				StartCharPair = PairStartVsShips;
			end
			
			if((PairStartVsShips+8 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+16)) begin
				CharCode = 8'h2f;
				StartCharPair = PairStartVsShips+8;
			end
			
			if((PairStartVsShips+16 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+24)) begin
				CharCode = "4";
				StartCharPair = PairStartVsShips+16;
			end
			
			//Draw the Ship
			if((PairStartVsShips+32 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+40)) begin
				if(Tie1[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
			
			if((PairStartVsShips+40 < OutRequestPair) & (OutRequestPair <= PairStartVsShips+48)) begin
				if(Tie3[((OutRequestPair-(PairStartVsShips+24+9'h001)))%8 + ((OutRequestLine-(LineStartVsShips+16+9'h001))>>1)*8])
					DOutRaw = 32'hA080A080;
			end
		end
		
		if((LineStartMsg < OutRequestLine) & (OutRequestLine <= LineStartMsg+16) & (OutRequestPair > PairStartMsg)) begin
			StartCharLine = LineStartMsg;
			DOutRaw = Char;
			CharCode = 8'h00;
			
			//Char1, Msg0
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg;
				CharCode = "C";
				
			end
			
			//Char1, Msg1
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg;
				CharCode = "P";
			end
			
			//Char1, Msg2
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg;
				CharCode = "C";
				
			end
			//Char1, Msg3
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg;
				CharCode = "Y";
				
			end
			//Char1, Msg4
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg;
				CharCode = "V";
				
			end
			//Char1, Msg5
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg;
				CharCode = "Y";
				
			end
			//Char1, Msg6
			if((PairStartMsg < OutRequestPair) & (OutRequestPair <= PairStartMsg+8) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg;
				CharCode = "V";
				
			end
			
			//Char2
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "o";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "l";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "o";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "o";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "s";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "o";
					
			end
			
			if((PairStartMsg+8 < OutRequestPair) & (OutRequestPair <= PairStartMsg+16) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+8;
				CharCode = "s";
					
			end
			
			//Char3
			if((PairStartMsg+16 < OutRequestPair) & (OutRequestPair <= PairStartMsg+24) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+16;
				CharCode = "n";

			end
			
			if((PairStartMsg+16 < OutRequestPair) & (OutRequestPair <= PairStartMsg+24) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+16;
				CharCode = "a";

			end
			
			if((PairStartMsg+16 < OutRequestPair) & (OutRequestPair <= PairStartMsg+24) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+16;
				CharCode = "n";

			end
			
			if((PairStartMsg+16 < OutRequestPair) & (OutRequestPair <= PairStartMsg+24) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+16;
				CharCode = "u";

			end
			
			if((PairStartMsg+16 < OutRequestPair) & (OutRequestPair <= PairStartMsg+24) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+16;
				CharCode = "u";

			end
			
			//Char4
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "n";
				
			end
			
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "c";
				
			end
			
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "n";
				
			end
			
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "r";
				
			end
			
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "S";
				
			end
			
			if((PairStartMsg+24 < OutRequestPair) & (OutRequestPair <= PairStartMsg+32) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+24;
				CharCode = "W";
				
			end
			
			//Char5
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "e";

			end
			
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "e";

			end
			
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "e";

			end
			
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "h";

			end
			
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "W";

			end
			
			if((PairStartMsg+32 < OutRequestPair) & (OutRequestPair <= PairStartMsg+40) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+32;
				CharCode = "i";

			end
			
			//Char6
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "c";
			end
			
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "c";
			end
			
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "S";
			end
			
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "i";
			end
			
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "i";
			end
			
			if((PairStartMsg+40 < OutRequestPair) & (OutRequestPair <= PairStartMsg+48) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+40;
				
				CharCode = "n";
			end
			
			//Char7
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "t";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "S";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "t";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "h";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "p";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "n";
			end
			
			if((PairStartMsg+48 < OutRequestPair) & (OutRequestPair <= PairStartMsg+56) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+48;
				CharCode = "s";
			end
			
			//Char8
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "i";
				
			end
			
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "h";
			end
			
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "i";
				
			end
			
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "i";				
			end
						
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h5)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "!";
				
			end
			
			if((PairStartMsg+56 < OutRequestPair) & (OutRequestPair <= PairStartMsg+64) & (Msg==3'h6)) begin
				StartCharPair = PairStartMsg+56;
				CharCode = "!";
				
			end
			
			//Char9 Msg0
			if((PairStartMsg+64 < OutRequestPair) & (OutRequestPair <= PairStartMsg+72) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+64;
				CharCode = "n";
				
			end
			
			//Char9 Msg1
			if((PairStartMsg+64 < OutRequestPair) & (OutRequestPair <= PairStartMsg+72) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+64;
				CharCode = "i";
				
			end
			
			//Char9 Msg2
			if((PairStartMsg+64 < OutRequestPair) & (OutRequestPair <= PairStartMsg+72) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+64;
				CharCode = "o";
				
			end
			
			//Char9 Msg3
			if((PairStartMsg+64 < OutRequestPair) & (OutRequestPair <= PairStartMsg+72) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+64;
				CharCode = "p";
			end
			
			//Char9 Msg4
			if((PairStartMsg+64 < OutRequestPair) & (OutRequestPair <= PairStartMsg+72) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+64;
				CharCode = "S";
				
			end
			
			//Char10 Msg0
			if((PairStartMsg+72 < OutRequestPair) & (OutRequestPair <= PairStartMsg+80) & (Msg==3'h0)) begin
				StartCharPair = PairStartMsg+72;
				
				CharCode = "g";				
			end
			
			//Char10 Msg1
			if((PairStartMsg+72 < OutRequestPair) & (OutRequestPair <= PairStartMsg+80) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+72;
				
				CharCode = "p";
				
			end
			
			//Char10 Msg2
			if((PairStartMsg+72 < OutRequestPair) & (OutRequestPair <= PairStartMsg+80) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+72;
				
				CharCode = "n";
				
			end
			
			//Char10Msg4
			if((PairStartMsg+72 < OutRequestPair) & (OutRequestPair <= PairStartMsg+80) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+72;
				
				CharCode = "u";
				
			end
			
			//Char11 Msg1
			if((PairStartMsg+80 < OutRequestPair) & (OutRequestPair <= PairStartMsg+88) & (Msg==3'h1)) begin
				StartCharPair = PairStartMsg+80;
				CharCode ="s";
				
			end
			
			//Char11 Msg3
			if((PairStartMsg+80 < OutRequestPair) & (OutRequestPair <= PairStartMsg+88) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+80;
				CharCode = "S";
				
			end
			
			//Char11 Msg4
			if((PairStartMsg+80 < OutRequestPair) & (OutRequestPair <= PairStartMsg+88) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+80;
				CharCode = "n";
				
			end
			
			//Char12 Msg2
			if((PairStartMsg+88 < OutRequestPair) & (OutRequestPair <= PairStartMsg+96) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+88;
				CharCode = "L";
				
			end
			
			//Char12 Msg3
			if((PairStartMsg+88 < OutRequestPair) & (OutRequestPair <= PairStartMsg+96) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+88;
				CharCode = "u";	
			end
			
			//Char12 Msg4
			if((PairStartMsg+88 < OutRequestPair) & (OutRequestPair <= PairStartMsg+96) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+88;
				CharCode = "k";
			end
			
			//Char13 Msg2
			if((PairStartMsg+96 < OutRequestPair) & (OutRequestPair <= PairStartMsg+104) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+96;
				CharCode = "o";

			end
			
			//Char13 Msg3
			if((PairStartMsg+96 < OutRequestPair) & (OutRequestPair <= PairStartMsg+104) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+96;
				CharCode = "n";
				
			end
			
			//Char13 Msg4
			if((PairStartMsg+96 < OutRequestPair) & (OutRequestPair <= PairStartMsg+104) & (Msg==3'h4)) begin
				StartCharPair = PairStartMsg+96;
				CharCode = "!";
				
			end
			
			//Char14 Msg2			
			if((PairStartMsg+104 < OutRequestPair) & (OutRequestPair <= PairStartMsg+112) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+104;
				CharCode = "s";
				
			end
			
			//Char14 Msg3			
			if((PairStartMsg+104 < OutRequestPair) & (OutRequestPair <= PairStartMsg+112) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+104;
				CharCode = "k";
			
			end
			
			//Char15 Msg2
			if((PairStartMsg+112 < OutRequestPair) & (OutRequestPair <= PairStartMsg+120) & (Msg==3'h2)) begin
				StartCharPair = PairStartMsg+112;
				CharCode = "t";
			end
			
			//Char15 Msg3
			if((PairStartMsg+112 < OutRequestPair) & (OutRequestPair <= PairStartMsg+120) & (Msg==3'h3)) begin
				StartCharPair = PairStartMsg+112;
				CharCode = "!";

			end
		end
		
	end

	//---------------------------------------------------------------
	//	Output Register
	//---------------------------------------------------------------
	Register	DOReg(	.Clock(		Clock),
				.Reset(		Reset),
				.Set(		1'b0),
				.Enable(	Pipe2),
				.In(		DOutRaw),
				.Out(		DOut));
	defparam	DOReg.width =		32;
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------