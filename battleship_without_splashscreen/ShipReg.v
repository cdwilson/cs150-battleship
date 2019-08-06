module ShipReg(Clock, Reset, WE, ShipIndex, Ship0, Ship1, Ship2, Ship3, Ship4, Ship5, Ship6, Ship7, Ship8, Ship9, Ship10, Ship11);
	
	input Clock;
	input Reset;
	input WE;
	input [3:0] ShipIndex;

	output[2:0]	Ship8, Ship9, Ship10, Ship11;
	output[2:0] Ship0, Ship1, Ship2, Ship3, Ship4, Ship5, Ship6, Ship7;

	reg En0, En1, En2, En3, En4, En5, En6, En7, En8, En9, En10, En11;
	
	Counter	Ship0Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En0), .In(3'b0), .Count(Ship0));
				defparam Ship0Cnt.width = 3;
	Counter	Ship1Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En1), .In(3'b0), .Count(Ship1));
				defparam Ship1Cnt.width = 3;
	Counter	Ship2Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En2), .In(3'b0), .Count(Ship2));
				defparam Ship2Cnt.width = 3;
	Counter	Ship3Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En3), .In(3'b0), .Count(Ship3));
				defparam Ship3Cnt.width = 3;
	Counter	Ship4Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En4), .In(3'b0), .Count(Ship4));
				defparam Ship4Cnt.width = 3;
	Counter	Ship5Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En5), .In(3'b0), .Count(Ship5));
				defparam Ship5Cnt.width = 3;
	Counter	Ship6Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En6), .In(3'b0), .Count(Ship6));
				defparam Ship6Cnt.width = 3;
	Counter	Ship7Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En7), .In(3'b0), .Count(Ship7));
				defparam Ship7Cnt.width = 3;
	Counter	Ship8Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En8), .In(3'b0), .Count(Ship8));
				defparam Ship8Cnt.width = 3;
	Counter	Ship9Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En9), .In(3'b0), .Count(Ship9));
				defparam Ship9Cnt.width = 3;
	Counter	Ship10Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En10), .In(3'b0), .Count(Ship10));
				defparam Ship10Cnt.width = 3;
	Counter	Ship11Cnt(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En11), .In(3'b0), .Count(Ship11));
				defparam Ship11Cnt.width = 3;
	
	always@( * ) begin
		En0 = 1'b0;
		En1 = 1'b0;
		En2 = 1'b0;
		En3 = 1'b0;
		En4 = 1'b0;
		En5 = 1'b0;
		En6 = 1'b0;
		En7 = 1'b0;
		En8 = 1'b0;
		En9 = 1'b0;
		En10 = 1'b0;
		En11 = 1'b0;
		
		
		case(ShipIndex)
			4'h0: En0 = WE;
			4'h1: En1 = WE;
			4'h2: En2 = WE;
			4'h3: En3 = WE;
			4'h4: En4 = WE;
			4'h5: En5 = WE;
			4'h6: En6 = WE;
			4'h7: En7 = WE;
			4'h8: En8 = WE;
			4'h9: En9 = WE;
			4'hA: En10 = WE;
			4'hB: En11 = WE;
		
		endcase
	
	end
	
	
endmodule
