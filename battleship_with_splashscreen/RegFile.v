module RegFile(Clock, Reset, WE, WAddr, Out);
	
	input Clock;
	input Reset;
	input WE;
	input [7:0] WAddr;
	parameter		width = 		256;
	output [width-1:0] Out;

	reg [width-1:0] Out;
	
	always @ (posedge Clock) begin
		if(Reset)
			Out <= {width{1'b0}};
		else if(WE)
			Out[WAddr] <= 1'b1;
	end

endmodule
