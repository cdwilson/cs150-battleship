//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:09:00 10/20/2006 
// Design Name: 
// Module Name:    LowClip 
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
module LowClip(Data, DOut);
    input [7:0] Data;
    output [7:0] DOut;
	 
	 wire [7:0] DOut;
	 wire [7:0] temp;
	 wire [7:0] temp2;
	 
	 assign temp = (Data < 8'h10) ? 8'h10 : Data;
	 assign temp2 = (temp > 8'hF0) ? 8'hF0 : temp;
	 
	 assign DOut = temp2;

endmodule
