//Charlie Lin

module	BEDCounter(Clock, Reset, Enable, Dig1, Dig2, Dig3);

	input Clock, Reset, Enable;
	output [3:0] Dig1, Dig2, Dig3;


	wire Dig2Enable, Dig3Enable;
	
	assign Dig2Enable = (Dig1 == 4'h9);
	assign Dig3Enable = (Dig2 == 4'h9) & Dig2Enable;
	
	wire [3:0] Dig1, Dig2, Dig3;

	Counter	Dig1Cnt(.Clock(Clock), .Reset(Reset | Dig2Enable), .Set(1'b0), .Load(1'b0), .Enable(Enable), .In(4'h0), .Count(Dig1));
				defparam Dig1Cnt.width = 4;
	Counter	Dig2Cnt(.Clock(Clock), .Reset(Reset | Dig3Enable), .Set(1'b0), .Load(1'b0), .Enable(Dig2Enable), .In(4'h0), .Count(Dig2));
				defparam Dig2Cnt.width = 4;
	Counter	Dig3Cnt(.Clock(Clock), .Reset(Reset | ((Dig3 == 4'h9) & Dig3Enable)), .Set(1'b0), .Load(1'b0), .Enable(Dig3Enable), .In(4'h0), .Count(Dig3));
				defparam Dig3Cnt.width = 4;
				

endmodule
//-----------------------------------------------------------------------