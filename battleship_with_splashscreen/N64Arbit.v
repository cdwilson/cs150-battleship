
module N64Arbit(	Clock,
						Reset,
						N64Status,
						CursorXWidth,
						CursorYWidth,
						CursorX,
						CursorY,
						A,
						B,
						Z,
						Start,
						L,
						R,
						CUp,
						CDown,
						CLeft,
						CRight,
						StatusEn,
						JoyX,
						JoyY,
						NewCursor);

	//-----------------------------------------------------------------
	// Input / Output
	//-----------------------------------------------------------------
	
	//System I/0
	input 				Clock;
	input 				Reset;
	
	//Controller Status
	input					NewCursor;
	input		[29:0]	N64Status;
	input		[2:0]		CursorXWidth, CursorYWidth;
	output	[3:0]		CursorX, CursorY;
	output				A, B, Z, Start, L, R, CUp, CDown, CLeft, CRight;
	output StatusEn;
	output	[7:0]		JoyX, JoyY;
	
	reg		[3:0]		CursorX, CursorY;
	
	//-----------------------------------------------------------------
	// Wires / Regs
	//-----------------------------------------------------------------
	wire					StatusEn;
	wire		[22:0]	sampleDelay;
	wire		[29:0]	N64StatusSampled;
	wire					DUp, DDown, DLeft, DRight;
	wire		[7:0]		JoyX, JoyY;
	

	//assign DUp = N64StatusSampled[25];
	//assign DDown = N64StatusSampled[24];
	//assign DLeft = N64StatusSampled[23];
	//assign DRight = N64StatusSampled[22];
	assign DUp = N64Status[25];
	assign DDown = N64Status[24];
	assign DLeft = N64Status[23];
	assign DRight = N64Status[22];
	assign JoyX = N64StatusSampled[15:8];
	assign JoyY = N64StatusSampled[7:0];
	
	RisingEdgeDetector riseA(.Clock(Clock), .Reset(Reset), .In(N64Status[29]), .Out(A));
	RisingEdgeDetector riseB(.Clock(Clock), .Reset(Reset), .In(N64Status[28]), .Out(B));
	RisingEdgeDetector riseZ(.Clock(Clock), .Reset(Reset), .In(N64Status[27]), .Out(Z));
	RisingEdgeDetector riseStart(.Clock(Clock), .Reset(Reset), .In(N64Status[26]), .Out(Start));
	RisingEdgeDetector riseL(.Clock(Clock), .Reset(Reset), .In(N64Status[21]), .Out(L));
	RisingEdgeDetector riseR(.Clock(Clock), .Reset(Reset), .In(N64Status[20]), .Out(R));
	RisingEdgeDetector riseCUp(.Clock(Clock), .Reset(Reset), .In(N64Status[19]), .Out(Cup));
	RisingEdgeDetector riseCDown(.Clock(Clock), .Reset(Reset), .In(N64Status[18]), .Out(CDown));
	RisingEdgeDetector riseCLeft(.Clock(Clock), .Reset(Reset), .In(N64Status[17]), .Out(CLeft));
	RisingEdgeDetector riseCRight(.Clock(Clock), .Reset(Reset), .In(N64Status[16]), .Out(CRight));
	
	
	// ~1sec counter at 27Mhz 
	Counter		sampleDelayCounter(	.Clock(Clock), .Reset(Reset | StatusEn), 
												.Set(1'b0), .Load(1'b0), .Enable(1'b1), 
												.In(22'h0), .Count(sampleDelay));
					defparam		sampleDelayCounter.width = 23;
	assign StatusEn = (sampleDelay == 23'd3500000);
	
	//holds the status of the n64 controller
	Register		regN64Status(	.Clock(Clock), .Reset(Reset/* | StatusEn*/),
										.Set(1'b0), .Enable(StatusEn),
										.In(N64Status), .Out(N64StatusSampled));
					defparam regN64Status.width = 30;
					//defparam regDipChannel.width = 30;
					
	always @ ( posedge Clock ) begin
		if (Reset | NewCursor)
			begin
				CursorX <= 0;
				CursorY <= 0;
			end
		else 
			begin
				if (StatusEn)	begin
						if (DUp & (CursorY > 4'b0))
							CursorY <= CursorY - 1;
						else if (DDown & (CursorY < (5'd16 - CursorYWidth)))
							CursorY <= CursorY + 1;
						if (DLeft & (CursorX > 4'b0))
							CursorX <= CursorX - 1;
						else if (DRight & (CursorX < (5'd16 - CursorXWidth)))
							CursorX <= CursorX + 1;
						if ((8'h60 > JoyY) & (JoyY > 8'h20) & (CursorY > 4'b0))
							CursorY <= CursorY - 1;
						else if ((8'ha0 < JoyY) & (JoyY < 8'hE0) & (CursorY < (5'd16 - CursorYWidth)))
							CursorY <= CursorY + 1;
						if ((8'ha0 < JoyX) & (JoyX < 8'hE0) & (CursorX > 4'b0))
							CursorX <= CursorX - 1;
						else if ((8'h60 > JoyX) & (JoyX > 8'h20) & (CursorX < (5'd16 - CursorXWidth)))
							CursorX <= CursorX + 1;
				end
			end
	end
					
	
endmodule
