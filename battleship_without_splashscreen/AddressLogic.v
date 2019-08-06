//Chris Wilson
//EECS 150

module AddressLogic(Clock, Reset, VBlank, CntCtrl, HCtrl, EvenOdd, InRequest, InRequestLine, Vtrigger, HCount);

	//////////////////////////////////////////
	//Inputs/Outputs
	//////////////////////////////////////////
	
	input					Clock, Reset;
	input					VBlank, EvenOdd;
	input					CntCtrl;
	input [1:0]			HCtrl;
	input					Vtrigger;
	input [10:0]		HCount;
	
	output				InRequest;
	output	[8:0]		InRequestLine;
	
	//////////////////////////////////////////
	//Wires
	//////////////////////////////////////////
	reg Even_active;
	reg Odd_active;
	wire InRequest;
	wire [8:0] 	EvenOut;
	wire [8:0] 	OddOut;
	wire [8:0] 	InRequestLine;
	wire [1:0]	HCtrl;
	wire HBlank;
	wire [1:0]  InternalCount;
	
	//////////////////////////////////////////
	//Logic
	//////////////////////////////////////////
	
	//assign HBlank = (HCtrl!=2'b00);
	assign HBlank = ~CntCtrl;
	assign InRequest = ( ~(VBlank | HBlank) & (InternalCount == 2'b00));
	assign InRequestLine = (EvenOdd ? {EvenOut[8:1], 1'b1} : {OddOut[8:1], 1'b0});
	
	//////////////////////////////////////////
	//Instantiations
	//////////////////////////////////////////	
	
	InReqlineEven	InReqlineEven(.Clock(Clock), .Reset(Reset), .Even_active(Even_active), .Out(EvenOut), .HCount(HCount));
	InReqlineOdd	InReqlineOdd(.Clock(Clock), .Reset(Reset), .Odd_active(Odd_active), .Out(OddOut), .HCount(HCount));
	Counter			Count4(.Clock(Clock), .Reset(Reset | InternalCount == 2'b11 | HBlank), .Set(1'b0), .Load(1'b0), .Enable(CntCtrl), .In(2'b00), .Count(InternalCount));
		defparam Count4.width = 2;
	
	always @(posedge Clock) begin
		Odd_active <= ~VBlank & ~EvenOdd & Vtrigger;
		Even_active <= ~VBlank & EvenOdd & Vtrigger;
	end
endmodule
