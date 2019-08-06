module BoardPlaceFSM(Clock, Reset, InitDone, GameMode, CursorX, CursorY, Horiz, NewCursor, XWidth, YWidth, WE, WData, WRow, WCol, SetDone, AButton, RButton, StartButton);
	
	input Clock;
	input Reset;
	input[3:0] 	CursorX;
	input[3:0] 	CursorY;
	input AButton;
	input RButton;
	input StartButton;
	input InitDone;
	
	output WE;
	output [9:0] WData;
	output [3:0] WRow;
	output [3:0] WCol;
	output NewCursor;
	output Horiz;
	output [3:0] GameMode;
	output [2:0]	XWidth;
	output [2:0]	YWidth;
	output SetDone;

	reg[7:0] CurState;
	reg[7:0] NextState;
	reg[3:0] GameMode;
	reg Horiz;
	reg WE;
	reg [9:0] WData;
	reg [3:0] WRow;
	reg [3:0] WCol;
	reg NewCursor;
	reg En;
	reg [2:0] XWidth;
	reg [2:0] YWidth;
	reg SetDone;

	wire [255:0] ShipCheck;
	
	RegFile	Checker(.Clock(Clock), .Reset(Reset), .WE(WE & (GameMode != 4'h0)), .WAddr((WRow*16) + WCol), .Out(ShipCheck));
	
	parameter STATE_Init = 8'h3C;
	parameter STATE_Ship1 = 8'h00;
	parameter STATE_Ship1v = 8'h3D;
	parameter STATE_NewC1 = 8'h01;
	parameter STATE_NewC1b = 8'h24;
	parameter STATE_Ship2 = 8'h02;
	parameter STATE_Ship2v = 8'h03;
	parameter STATE_NewC2 = 8'h04;
	parameter STATE_NewC2b = 8'h25;
	parameter STATE_Ship3 = 8'h05;
	parameter STATE_Ship3v = 8'h06;
	parameter STATE_NewC3 = 8'h07;
	parameter STATE_NewC3b = 8'h26;	
	parameter STATE_Ship4 = 8'h08;
	parameter STATE_Ship4v = 8'h09;
	parameter STATE_NewC4 = 8'h0A;
	parameter STATE_NewC4b = 8'h27;	
	parameter STATE_Ship5 = 8'h0B;
	parameter STATE_Ship5v = 8'h0C;
	parameter STATE_NewC5 = 8'h0D;
	parameter STATE_NewC5b = 8'h28;
	parameter STATE_NewC5c = 8'h29;
	parameter STATE_Ship6 = 8'h0E;
	parameter STATE_Ship6v = 8'h0F;
	parameter STATE_NewC6 = 8'h10;
	parameter STATE_NewC6b = 8'h2A;
	parameter STATE_NewC6c = 8'h2B;
	parameter STATE_Ship7 = 8'h11;
	parameter STATE_Ship7v = 8'h12;
	parameter STATE_NewC7 = 8'h13;
	parameter STATE_NewC7b = 8'h2C;
	parameter STATE_NewC7c = 8'h2D;
	parameter STATE_Ship8 = 8'h14;
	parameter STATE_Ship8v = 8'h15;
	parameter STATE_NewC8 = 8'h16;
	parameter STATE_NewC8b = 8'h2E;
	parameter STATE_NewC8c = 8'h2F;
	parameter STATE_Ship9 = 8'h17;
	parameter STATE_Ship9v = 8'h18;
	parameter STATE_NewC9 = 8'h19;
	parameter STATE_NewC9b = 8'h30;
	parameter STATE_NewC9c = 8'h31;
	parameter STATE_NewC9d = 8'h32;
	parameter STATE_Ship10 = 8'h1A;
	parameter STATE_Ship10v = 8'h1B;
	parameter STATE_NewC10 = 8'h1C;
	parameter STATE_NewC10b = 8'h33;
	parameter STATE_NewC10c = 8'h34;
	parameter STATE_NewC10d = 8'h35;
	parameter STATE_Ship11 = 8'h1D;
	parameter STATE_Ship11v = 8'h1E;
	parameter STATE_NewC11 = 8'h1F;
	parameter STATE_NewC11b = 8'h36;
	parameter STATE_NewC11c = 8'h37;
	parameter STATE_NewC11d = 8'h38;
	parameter STATE_Ship12 = 8'h20;
	parameter STATE_Ship12v = 8'h21;
	parameter STATE_NewC12 = 8'h22;
	parameter STATE_NewC12b = 8'h39;
	parameter STATE_NewC12c = 8'h3A;
	parameter STATE_NewC12d = 8'h3B;
	parameter STATE_NewC12e = 8'h3E;
	parameter STATE_Done = 8'h23;
	
	parameter STATE_NewC1v = 8'h3F;
	parameter STATE_NewC1bv = 8'h40;
	parameter STATE_NewC2v = 8'h41;
	parameter STATE_NewC2bv = 8'h42;
	parameter STATE_NewC3v = 8'h43;
	parameter STATE_NewC3bv = 8'h44;
	parameter STATE_NewC4v = 8'h45;
	parameter STATE_NewC4bv = 8'h46;
	parameter STATE_NewC5v = 8'h47;
	parameter STATE_NewC5bv = 8'h48;
	parameter STATE_NewC5cv = 8'h49;
	parameter STATE_NewC6v = 8'h4A;
	parameter STATE_NewC6bv = 8'h4B;
	parameter STATE_NewC6cv = 8'h4C;
	parameter STATE_NewC7v = 8'h4D;
	parameter STATE_NewC7bv = 8'h4E;
	parameter STATE_NewC7cv = 8'h4F;
	parameter STATE_NewC8v = 8'h50;
	parameter STATE_NewC8bv = 8'h51;
	parameter STATE_NewC8cv = 8'h52;
	parameter STATE_NewC9v = 8'h53;
	parameter STATE_NewC9bv = 8'h54;
	parameter STATE_NewC9cv = 8'h55;
	parameter STATE_NewC9dv = 8'h56;
	parameter STATE_NewC10v = 8'h57;
	parameter STATE_NewC10bv = 8'h58;
	parameter STATE_NewC10cv = 8'h59;
	parameter STATE_NewC10dv = 8'h5A;
	parameter STATE_NewC11v = 8'h5B;
	parameter STATE_NewC11bv = 8'h5C;
	parameter STATE_NewC11cv = 8'h5D;
	parameter STATE_NewC11dv = 8'h5E;
	parameter STATE_NewC12v = 8'h5F;
	parameter STATE_NewC12bv = 8'h60;
	parameter STATE_NewC12cv = 8'h61;
	parameter STATE_NewC12dv = 8'h62;
	parameter STATE_NewC12ev = 8'h63;
	
	wire[7:0] Addr;
	wire ResetDone;
	wire Check1, Check2h, Check3h, Check4h, Check5h;
	wire Check2v, Check3v, Check4v, Check5v;
	wire HtoV2, HtoV3, HtoV4, HtoV5;
	wire VtoH2, VtoH3, VtoH4, VtoH5;
	wire ResetDoneHold;
	
	assign HtoV2 = (16 - CursorY) > 1;
	assign HtoV3 = (16 - CursorY) > 2;
	assign HtoV4 = (16 - CursorY) > 3;
	assign HtoV5 = (16 - CursorY) > 4;
	assign VtoH2 = (16 - CursorX) > 1;
	assign VtoH3 = (16 - CursorX) > 2;
	assign VtoH4 = (16 - CursorX) > 3;
	assign VtoH5 = (16 - CursorX) > 4;
	assign Check1 = ShipCheck[CursorY*16 + CursorX];
	assign Check2h = ShipCheck[CursorY*16 + CursorX+1];
	assign Check3h = ShipCheck[CursorY*16 + CursorX+2];
	assign Check4h = ShipCheck[CursorY*16 + CursorX+3];
	assign Check5h = ShipCheck[CursorY*16 + CursorX+4];
	assign Check2v = ShipCheck[((CursorY+1)*16) + CursorX];
	assign Check3v = ShipCheck[((CursorY+2)*16) + CursorX];
	assign Check4v = ShipCheck[((CursorY+3)*16) + CursorX];
	assign Check5v = ShipCheck[((CursorY+4)*16) + CursorX];
	
	
	Counter 	Count(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En), .In(8'h00), .Count(Addr));
				defparam Count.width = 8;

	RisingEdgeDetector	ResetRAM(.Clock(Clock), .Reset(Reset), .In((Addr == 8'hFF)), .Out(ResetDone));
	
	Register		ResetSig(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(ResetDone), .In(1'b1), .Out(ResetDoneHold));
					defparam ResetSig.width = 1;
	
	always @(posedge Clock) begin
		
		if(Reset)
			CurState <= STATE_Init;
		else
			CurState <= NextState;
	
	end
	
	always @( * ) begin
		En = 1'b0;
		WE = 1'b0;
		WData = 10'h000;
		//WRow = 4'h0;
		//WCol = 4'h0;
		WRow = CursorY;
		WCol = CursorX;
		NextState = CurState;
		GameMode = 4'h0;
		NewCursor = 1'b0;
		XWidth = 3'h1;
		YWidth = 3'h1;
		Horiz = 1'b1;
		SetDone = 1'b0;

		case(CurState)
			
			STATE_Init: begin
				if(ResetDoneHold & InitDone)
					NextState = STATE_Ship1;
				
				En = 1'b1;
				WE = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'h000;
				NewCursor = 1'b1;
				Horiz = 1'b1;
			
			end
			
			STATE_Ship1: begin
				if(RButton & HtoV2)
					NextState = STATE_Ship1v;
				else if(AButton & ~Check1 & ~Check2h)
					NextState = STATE_NewC1;
				
				Horiz = 1'b1;
				GameMode = 4'h1;
				XWidth = 3'h2;
				YWidth = 3'h1;

			end
			
			STATE_Ship1v: begin
				if(RButton & VtoH2)
					NextState = STATE_Ship1;
				else if(AButton & ~Check1 & ~Check2v)
					NextState = STATE_NewC1v;
			
				Horiz = 1'b0;
				GameMode = 4'h1;
				XWidth = 3'h1;
				YWidth = 3'h2;
				
			end
				
			STATE_NewC1: begin
				NextState = STATE_NewC1b;
				//NewCursor = 1'b1;
				
				Horiz = 1'b1;
				GameMode = 4'h2;
				WE = 1'b1;
				WData = 10'b0000000010;
				WRow = CursorY;
				WCol = CursorX;
				////ShipCheck[{WRow, WCol}] = 1'b1;
				
			end
			
			STATE_NewC1b: begin
				NextState = STATE_Ship2;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h2;
				WE = 1'b1;
				WData = 10'b0000000110;
				WRow = CursorY;
				WCol = CursorX+1;
				////ShipCheck[{WRow, WCol}] = 1'b1;

			end
			
			STATE_NewC1v: begin
				NextState = STATE_NewC1bv;
				//NewCursor = 1'b1;
				
				Horiz = 1'b1;
				GameMode = 4'h2;
				WE = 1'b1;
				WData = 10'b0000001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
				
			end
			
			STATE_NewC1bv: begin
				NextState = STATE_Ship2;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h2;
				WE = 1'b1;

				WData = 10'b0000001100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship2: begin
				if(RButton & HtoV2)
					NextState = STATE_Ship2v;
				else if(AButton & ~Check1 & ~Check2h)
					NextState = STATE_NewC2;
				
				Horiz = 1'b1;
				GameMode = 4'h2;
				XWidth = 3'h2;
				YWidth = 3'h1;
			end
			
			STATE_Ship2v: begin
				if(RButton & VtoH2)
					NextState = STATE_Ship2;
				else if(AButton & ~Check1 & ~Check2v)
					NextState = STATE_NewC2v;
				
				Horiz = 1'b0;
				GameMode = 4'h2;
				XWidth = 3'h1;
				YWidth = 3'h2;
			end
				
			STATE_NewC2: begin
				NextState = STATE_NewC2b;
				//NewCursor = 1'b1;
				GameMode = 4'h3;
				Horiz = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0001000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;

			end
			
			STATE_NewC2b: begin
				NextState = STATE_Ship3;
				NewCursor = 1'b1;
				GameMode = 4'h3;
				Horiz = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0001000110;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC2v: begin
				NextState = STATE_NewC2bv;
				//NewCursor = 1'b1;
				GameMode = 4'h3;
				Horiz = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0001001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC2bv: begin
				NextState = STATE_Ship3;
				NewCursor = 1'b1;
				GameMode = 4'h3;
				Horiz = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0001001100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship3: begin
			
				if(RButton & HtoV2)
					NextState = STATE_Ship3v;
				else if(AButton & ~Check1 & ~Check2h)
					NextState = STATE_NewC3;
			
				Horiz = 1'b1;
				GameMode = 4'h3;
				XWidth = 3'h2;
				YWidth = 3'h1;
			end
			
			STATE_Ship3v: begin
				if(RButton & VtoH2)
					NextState = STATE_Ship3;
				else if(AButton & ~Check1 & ~Check2v)
					NextState = STATE_NewC3v;
			
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h3;
				XWidth = 3'h1;
				YWidth = 3'h2;
			end
				
			STATE_NewC3: begin
				NextState = STATE_NewC3b;
				GameMode = 4'h4;
				Horiz = 1'b1;
				//NewCursor = 1'b1;
				
				WE = 1'b1;

				WData = 10'b0010000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC3b: begin
				NextState = STATE_Ship4;
				GameMode = 4'h4;
				Horiz = 1'b1;
				NewCursor = 1'b1;
				
				WE = 1'b1;

				WData = 10'b0010000110;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC3v: begin
				NextState = STATE_NewC3bv;
				GameMode = 4'h4;
				Horiz = 1'b1;
				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0010001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC3bv: begin
				NextState = STATE_Ship4;
				GameMode = 4'h4;
				Horiz = 1'b1;
				NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b0010001100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship4: begin
				if(RButton & HtoV2)
					NextState = STATE_Ship4v;
				else if(AButton & ~Check1 & ~Check2h)
					NextState = STATE_NewC4;
				
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h4;
				XWidth = 3'h2;
				YWidth = 3'h1;
			end
			
			STATE_Ship4v: begin
				if(RButton & VtoH2)
					NextState = STATE_Ship4;
				else if(AButton & ~Check1 & ~Check2v)
					NextState = STATE_NewC4v;
				
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h4;
				XWidth = 3'h1;
				YWidth = 3'h2;
			end
				
			STATE_NewC4: begin
				NextState = STATE_NewC4b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h5;
				
				WE = 1'b1;

				WData = 10'b0011000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC4b: begin
				NextState = STATE_Ship5;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h5;
				
				WE = 1'b1;

				WData = 10'b0011000110;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC4v: begin
				NextState = STATE_NewC4bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h5;
				
				WE = 1'b1;
				WData = 10'b0011001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC4bv: begin
				NextState = STATE_Ship5;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h5;
				
				WE = 1'b1;
				WData = 10'b0011001100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship5: begin
				if(RButton & HtoV3)
					NextState = STATE_Ship5v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h)
					NextState = STATE_NewC5;
				
				XWidth = 3'h3;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h5;
			end
			
			STATE_Ship5v: begin
				if(RButton & VtoH3)
					NextState = STATE_Ship5;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v)
					NextState = STATE_NewC5v;
				
				XWidth = 3'h1;
				YWidth = 3'h3;
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h5;
			end
				
			STATE_NewC5: begin
				NextState = STATE_NewC5b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				
				WE = 1'b1;
				WData = 10'b0100000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC5b: begin
				NextState = STATE_NewC5c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				
				WE = 1'b1;

				WData = 10'b0100000100;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC5c: begin
				NextState = STATE_Ship6;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				
				WE = 1'b1;

				WData = 10'b0100000110;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC5v: begin
				NextState = STATE_NewC5bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				
				WE = 1'b1;
				WData = 10'b0100001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC5bv: begin
				NextState = STATE_NewC5cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				
				WE = 1'b1;
				WData = 10'b0100001010;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC5cv: begin
				NextState = STATE_Ship6;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h6;
				WE = 1'b1;
				WData = 10'b0100001100;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship6: begin
				
				if(RButton & HtoV3)
					NextState = STATE_Ship6v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h)
					NextState = STATE_NewC6;
				
				XWidth = 3'h3;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h6;
			end
			
			STATE_Ship6v: begin
				if(RButton & VtoH3)
					NextState = STATE_Ship6;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v)
					NextState = STATE_NewC6v;
				
				XWidth = 3'h1;
				YWidth = 3'h3;
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h6;
			end
				
			STATE_NewC6: begin
				NextState = STATE_NewC6b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				WE = 1'b1;
				WData = 10'b0101000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;

			end
			
			STATE_NewC6b: begin
				NextState = STATE_NewC6c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				
				WE = 1'b1;

				WData = 10'b0101000100;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC6c: begin
				NextState = STATE_Ship7;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				
				WE = 1'b1;

				WData = 10'b0101000110;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC6v: begin
				NextState = STATE_NewC6bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				
				WE = 1'b1;

				WData = 10'b0101001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC6bv: begin
				NextState = STATE_NewC6cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				
				WE = 1'b1;

				WData = 10'b0101001010;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC6cv: begin
				NextState = STATE_Ship7;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h7;
				
				WE = 1'b1;

				WData = 10'b0101001100;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship7: begin
				if(RButton & HtoV3)
					NextState = STATE_Ship7v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h)
					NextState = STATE_NewC7;
				
				XWidth = 3'h3;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h7;
			end
			
			STATE_Ship7v: begin
				if(RButton & VtoH3)
					NextState = STATE_Ship7;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v)
					NextState = STATE_NewC7v;
				
				XWidth = 3'h1;
				YWidth = 3'h3;
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h7;
			end
				
			STATE_NewC7: begin
				NextState = STATE_NewC7b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC7b: begin
				NextState = STATE_NewC7c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110000100;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC7c: begin
				NextState = STATE_Ship8;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110000110;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC7v: begin
				NextState = STATE_NewC7bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC7bv: begin
				NextState = STATE_NewC7cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110001010;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC7cv: begin
				NextState = STATE_Ship8;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h8;
				
				WE = 1'b1;
				WData = 10'b0110001100;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship8: begin
				if(RButton & HtoV3)
					NextState = STATE_Ship8v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h)
					NextState = STATE_NewC8;
				
				XWidth = 3'h3;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h8;
			end
			
			STATE_Ship8v: begin
				if(RButton & VtoH3)
					NextState = STATE_Ship8;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v)
					NextState = STATE_NewC8v;
				
				XWidth = 3'h1;
				YWidth = 3'h3;
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h8;
			end
				
			STATE_NewC8: begin
				NextState = STATE_NewC8b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111000010;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC8b: begin
				NextState = STATE_NewC8c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111000100;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC8c: begin
				NextState = STATE_Ship9;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111000110;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC8v: begin
				NextState = STATE_NewC8bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111001000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC8bv: begin
				NextState = STATE_NewC8cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111001010;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC8cv: begin
				NextState = STATE_Ship9;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'h9;
				
				WE = 1'b1;
				WData = 10'b0111001100;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship9: begin
				if(RButton & HtoV4)
					NextState = STATE_Ship9v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h & ~Check4h)
					NextState = STATE_NewC9;
				
				XWidth = 3'h4;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'h9;
			end
			
			STATE_Ship9v: begin
				if(RButton & VtoH4)
					NextState = STATE_Ship9;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v & ~Check4v)
					NextState = STATE_NewC9v;
			
				XWidth = 3'h1;
				YWidth = 3'h4;
				Horiz = 1'b0;
				//HorizW = 1'b0;
				GameMode = 4'h9;
			end
				
			STATE_NewC9: begin
				NextState = STATE_NewC9b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000001110;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9b: begin
				NextState = STATE_NewC9c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000010010;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9c: begin
				NextState = STATE_NewC9d;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000010100;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9d: begin
				NextState = STATE_Ship10;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000010110;
				WRow = CursorY;
				WCol = CursorX+3;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9v: begin
				NextState = STATE_NewC9bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000011000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9bv: begin
				NextState = STATE_NewC9cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000011100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9cv: begin
				NextState = STATE_NewC9dv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000011110;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC9dv: begin
				NextState = STATE_Ship10;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hA;
				
				WE = 1'b1;
				WData = 10'b1000100000;
				WRow = CursorY+3;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship10: begin
				if(RButton & HtoV4)
					NextState = STATE_Ship10v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h & ~Check4h)
					NextState = STATE_NewC10;
				
				XWidth = 3'h4;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'hA;
			end
			
			STATE_Ship10v: begin
				if(RButton & VtoH4)
					NextState = STATE_Ship10;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v & ~Check4v)
					NextState = STATE_NewC10v;
			
				XWidth = 3'h1;
				YWidth = 3'h4;
				GameMode = 4'hA;
				//HorizW = 1'b0;
				Horiz = 1'b0;
			end
				
			STATE_NewC10: begin
				NextState = STATE_NewC10b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001001110;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10b: begin
				NextState = STATE_NewC10c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001010010;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10c: begin
				NextState = STATE_NewC10d;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001010100;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10d: begin
				NextState = STATE_Ship11;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001010110;
				WRow = CursorY;
				WCol = CursorX+3;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10v: begin
				NextState = STATE_NewC10bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001011000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10bv: begin
				NextState = STATE_NewC10cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001011100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10cv: begin
				NextState = STATE_NewC10dv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001011110;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC10dv: begin
				NextState = STATE_Ship11;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hB;
				
				WE = 1'b1;
				WData = 10'b1001100000;
				WRow = CursorY+3;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship11: begin
				if(RButton & HtoV4)
					NextState = STATE_Ship11v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h & ~Check4h)
					NextState = STATE_NewC11;
				
				XWidth = 3'h4;
				YWidth = 3'h1;
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'hB;
			end
			
			STATE_Ship11v: begin
				if(RButton & VtoH4)
					NextState = STATE_Ship11;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v & ~Check4v)
					NextState = STATE_NewC11v;
			
				XWidth = 3'h1;
				YWidth = 3'h4;
				GameMode = 4'hB;
				//HorizW = 1'b0;
				Horiz = 1'b0;
			end
				
			STATE_NewC11: begin
				NextState = STATE_NewC11b;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010001110;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11b: begin
				NextState = STATE_NewC11c;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010010010;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11c: begin
				NextState = STATE_NewC11d;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010010100;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11d: begin
				NextState = STATE_Ship12;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010010110;
				WRow = CursorY;
				WCol = CursorX+3;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11v: begin
				NextState = STATE_NewC11bv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010011000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11bv: begin
				NextState = STATE_NewC11cv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010011100;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11cv: begin
				NextState = STATE_NewC11dv;
				//NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010011110;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC11dv: begin
				NextState = STATE_Ship12;
				NewCursor = 1'b1;
				Horiz = 1'b1;
				GameMode = 4'hC;
				
				WE = 1'b1;
				WData = 10'b1010100000;
				WRow = CursorY+3;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Ship12: begin
				if(RButton & HtoV5)
					NextState = STATE_Ship12v;
				else if(AButton & ~Check1 & ~Check2h & ~Check3h & ~Check4h & ~Check5h)
					NextState = STATE_NewC12;
				
				Horiz = 1'b1;
				//HorizW = 1'b1;
				GameMode = 4'hC;
				XWidth = 3'h5;
				YWidth = 3'h1;
			end
			
			STATE_Ship12v: begin
				if(RButton & VtoH5)
					NextState = STATE_Ship12;
				else if(AButton & ~Check1 & ~Check2v & ~Check3v & ~Check4v & ~Check5v)
					NextState = STATE_NewC12v;
			
				GameMode = 4'hC;
				//HorizW = 1'b0;
				Horiz = 1'b0;
				XWidth = 3'h1;
				YWidth = 3'h5;
			end
				
			STATE_NewC12: begin
				NextState = STATE_NewC12b;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011001110;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12b: begin
				NextState = STATE_NewC12c;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011010000;
				WRow = CursorY;
				WCol = CursorX+1;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12c: begin
				NextState = STATE_NewC12d;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011010010;
				WRow = CursorY;
				WCol = CursorX+2;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12d: begin
				NextState = STATE_NewC12e;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011010100;
				WRow = CursorY;
				WCol = CursorX+3;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12e: begin
				NextState = STATE_Done;
				GameMode = 4'hD;

				NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011010110;
				WRow = CursorY;
				WCol = CursorX+4;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12v: begin
				NextState = STATE_NewC12bv;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011011000;
				WRow = CursorY;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12bv: begin
				NextState = STATE_NewC12cv;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011011010;
				WRow = CursorY+1;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12cv: begin
				NextState = STATE_NewC12dv;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011011100;
				WRow = CursorY+2;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12dv: begin
				NextState = STATE_NewC12ev;
				GameMode = 4'hD;

				//NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011011110;
				WRow = CursorY+3;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_NewC12ev: begin
				NextState = STATE_Done;
				GameMode = 4'hD;

				NewCursor = 1'b1;
				
				WE = 1'b1;
				WData = 10'b1011100000;
				WRow = CursorY+4;
				WCol = CursorX;
				//ShipCheck[{WRow, WCol}] = 1'b1;
			end
			
			STATE_Done: begin
				GameMode = 4'hD;
				SetDone = 1'b1;
			end
			
		endcase
	
	end
endmodule