//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:05:48 10/22/2006 
// Design Name: 
// Module Name:    EncoderControl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EncoderControl(Clock, Reset, EAV, SAV, HBlank, HActive, EvenOdd, VBlank, InRequest, InRequestLine, InRequestPair, HCount, VCount, Lineout, VBlankCount);
    
	//Inputs
	input Clock;
   input Reset;
    
	//Outputs
	output EAV;
   output SAV;
   output HBlank;
	output HActive;
   output InRequest;
	output EvenOdd;
	output VBlank;
   output [8:0] InRequestLine;
   output [8:0] InRequestPair;
	output [10:0] HCount;
	output [9:0] VCount;
	output [7:0] Lineout;
	output [5:0] VBlankCount;
	 
	//Wires
	wire EAV;
	wire SAV;
	wire HBlank;
	wire HActive;
	wire VBlank;
	wire InRequest;
	wire EarlyHActive;
	wire EvenOdd;
	wire [8:0] InRequestLine;
	wire [8:0] InRequestPair;
	
	wire [9:0] VCount;
	wire [10:0] HCount;
	wire [8:0] ReqlineOdd;
	wire [8:0] ReqlineEven;
	wire [1:0] Pulse;
	wire [7:0] Lineout;
	wire [5:0] VBlankCount;
	wire VCountR;
	wire VEn;
	wire HCountR;
	wire InLineOddEn;
	wire InLineOddR;
	wire InLineEvenEn;
	wire InLineEvenR;
	wire InReqPairR;
	wire Count4R;
	
	wire [10:0] Pair;
	
	/* Output Logic */
	assign Lineout = InRequestLine[8:1];
	assign ReqlineOdd[0] = 1'b0;
	assign ReqlineEven[0] = 1'b1;
	assign InRequestLine = EvenOdd ? ReqlineEven : ReqlineOdd;
	assign InRequestPair = Pair >> 2;
	assign InRequest = (Pulse==2'b00) & EarlyHActive & ~VBlank & (HCount!=11'd1715);
	/*
		parameter	END_ODD_BLANK_TOP		= 	10'd13,		//0-13
					END_ODD_ACTIVE			= 	10'd257,		//14-257  correct 257
					END_ODD_BLANK_BOT		=	10'd261,		//258-261
					END_EVEN_BLANK_TOP	= 	10'd276,		//262-276 correct 276
					END_EVEN_ACTIVE		=	10'd519,		//277-519 correct 519
					END_EVEN_BLANK_BOT	= 	10'd524;		//check this one correct 524*/
	
	/*Signals affected by VCount*/
	assign VBlank = ((10'd0<=VCount)&(VCount<=10'd13)) | ((10'd258<=VCount) & (VCount <= 10'd276)) | (VCount >= 10'd520);
	//assign VBlank = ~((10'd13 < VCount) & (VCount < 10'd258)) & ~((10'd276 < VCount) & (VCount < 10'd520));
	assign EvenOdd = (10'd262 <= VCount) & (VCount <= 10'd524);
	
	/*Signals affected by HCount*/
	assign EAV = ((11'd0 <= HCount) & (HCount <= 11'd3) & ~Reset);
	assign SAV = ((11'd272 <= HCount) & (HCount <= 11'd275));
	assign HBlank = ((11'd4 <= HCount) & (HCount <= 11'd271));
	assign HActive = ((11'd276 <= HCount) & (HCount <= 11'd1715));
	assign VEn = HCount == 11'd1715;
	//assign EarlyHActive = HActive;
	assign EarlyHActive = ((11'd273 <= HCount) & (HCount <= 11'd1712));
	//assign EarlyHActive = ((11'd274 <= HCount) & (HCount <= 11'd1713));
	//assign EarlyHActive = ((11'd275 <= HCount) & (HCount <= 11'd1714));
	
	/*DESCRIBE RESET BEHAVIOR OF EACH COUNTER*/
	assign VCountR = Reset | ((VCount == 10'd524) & (HCount == 11'd1715));    //-> VCount is on last line and HCount is finishing
	assign HCountR = Reset | (HCount == 11'd1715);
	assign Count4R = Reset | (Pulse == 2'b11);
	assign InLineOddR = Reset | ((HCount == 11'd1715) & (ReqlineOdd[8:1] == 8'd243));
	assign InLineEvenR = Reset | ((HCount == 11'd1715) & (ReqlineEven[8:1] == 8'd242));
	assign InReqPairR = Reset | (Pair == 11'd1439);
	
	/*Enable Behavior*/
	assign InLineOddEn = ~EvenOdd & (HCount == 11'd1715) & ~VBlank & HActive;
	assign InLineEvenEn = EvenOdd & (HCount == 11'd1715) & ~VBlank & HActive;
	
	
	/*Control for Request Line counters*/
	
	
	
	Counter		VCounter(.Clock(Clock), .Reset(VCountR), .Set(1'b0), .Load(1'b0), .Enable(VEn), .In(10'h000), .Count(VCount));
					defparam VCounter.width = 10;
	
	Counter		HCounter(.Clock(Clock), .Reset(HCountR), .Set(1'b0), .Load(1'b0), .Enable(~Reset), .In(11'h000), .Count(HCount));
					defparam HCounter.width = 11;
					
	Counter		InReqlineOdd(.Clock(Clock), .Reset(InLineOddR), .Set(1'b0), .Load(1'b0), .Enable(InLineOddEn), .In(8'h00), .Count(ReqlineOdd[8:1]));
					defparam InReqlineOdd.width = 8;
	
	Counter		InReqlineEven(.Clock(Clock), .Reset(InLineEvenR), .Set(1'b0), .Load(1'b0), .Enable(InLineEvenEn), .In(8'h00), .Count(ReqlineEven[8:1]));
					defparam InReqlineEven.width = 8;
	
	Counter		InReqPair(.Clock(Clock), .Reset(InReqPairR), .Set(1'b0), .Load(1'b0), .Enable(EarlyHActive & ~VBlank), .In(11'h000), .Count(Pair));
					defparam InReqPair.width = 11;
					
	Counter		Countby4(.Clock(Clock), .Reset(Count4R), .Set(1'b0), .Load(1'b0), .Enable(EarlyHActive), .In(2'b00), .Count(Pulse));
					defparam Countby4.width = 2;

	Counter		VBlankCounter(.Clock(Clock), .Reset(VCountR), .Set(1'b0), .Load(1'b0), .Enable(VEn & VBlank), .In(6'h00), .Count(VBlankCount));
					defparam VBlankCounter.width = 6;
endmodule
