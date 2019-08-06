module WriteBlock(Clock, Reset, ShiporChar, OutRequestPair, OutRequestLine, StartPair, StartLine, ShipCode, CharCode, DOut);
	input Clock;
	input Reset;
	input ShiporChar;
	input [9:0] ShipCode;
	input [7:0] CharCode;
	input [8:0] OutRequestPair;
	input [8:0] OutRequestLine;
	input [8:0] StartPair;
	input [8:0] StartLine;
	
	output [31:0] DOut;	
	reg [31:0] DOut;
	
	CharROM	CharRom(.DotMatrix(CharDotMatrixin), .CharCode(CharCode));
	ShipROM ShipRom(.Data(ShipCode), .DotMatrix(ShipDotMatrixin));
	
	wire [63:0] ShipDotMatrixin;
	wire [63:0] CharDotMatrixin;
	wire [63:0] ShipDotMatrix;
	wire [63:0] CharDotMatrix;
	
	Register	CharReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(1'b1), .In(CharDotMatrixin), .Out(CharDotMatrix));
				defparam CharReg.width = 64;
	Register	ShipReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(1'b1), .In(ShipDotMatrixin), .Out(ShipDotMatrix));
				defparam ShipReg.width = 64;
	
	wire [63:0] DotMatrix;
	
	assign DotMatrix = ShiporChar ? ShipDotMatrix : CharDotMatrix;

	always @ ( * ) begin
		DOut = 32'h10801080;
		//if((StartLine < OutRequestLine) & (OutRequestLine <= (StartLine + 16))) begin
		//	if((StartPair < OutRequestPair) & (OutRequestPair <= (StartPair + 8))) begin
				if(DotMatrix[((OutRequestPair-(StartPair+9'h001)))%8 + ((OutRequestLine-(StartLine+9'h001))>>1)*8])
					//DOut = 32'ha910a9a5;
					DOut = 32'h51ef515a;
			//end
		//end
	end
	
	
endmodule


