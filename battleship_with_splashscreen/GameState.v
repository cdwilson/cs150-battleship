/*
Charlie Lin
EECS150

GameState module
holds the state data for a game of battleship
*/

module GameState(	Clock, 
						Reset, 
						SoftReset, 
						RMyPosValid, 
						RMyPosData, 
						RMyPosRow, 
						RMyPosCol,
						RMyPosDataG, 
						RMyPosRowG, 
						RMyPosColG, 						
						RVsPosValid, 
						RVsPosData, 
						RVsPosRow, 
						RVsPosCol,
						RVsPosDataG, 
						RVsPosRowG, 
						RVsPosColG,
						WMyPosEnable, 
						WMyPosData, 
						WMyPosRow, 
						WMyPosCol, 
						WVsPosEnable, 
						WVsPosData, 
						WVsPosRow, 
						WVsPosCol);
						
	////////////////////
	//SYSTEM SIGNALS
	////////////////////	
			
	input Clock;
	input Reset;
	input SoftReset;
	
	////////////////////
	//INPUTS
	////////////////////
	
	input[3:0]	RMyPosRow;
	input[3:0]	RMyPosCol;
	input[3:0]	RVsPosRow;
	input[3:0]	RVsPosCol;
	input[3:0]	RMyPosRowG;
	input[3:0]	RMyPosColG;
	input[3:0]	RVsPosRowG;
	input[3:0]	RVsPosColG;
	
	
	input 		WMyPosEnable;
	input[9:0]	WMyPosData;
	input[3:0]	WMyPosRow;
	input[3:0]	WMyPosCol;
	
	input			WVsPosEnable;
	input[9:0]	WVsPosData;
	input[3:0]	WVsPosRow;
	input[3:0]	WVsPosCol;
	
	////////////////////
	//OUTPUTS
	////////////////////	
	
	output 		RMyPosValid;
	output		RVsPosValid;
	output[9:0]	RMyPosData;
	output[9:0] RVsPosData;
	output[9:0]	RMyPosDataG;
	output[9:0] RVsPosDataG;
	
	
	wire			RMyPosValid;
	wire			RVsPosValid;
	
	
	////////////////////
	//INSTANTIATIONS
	////////////////////	
	
	RAM		MyBoard(.Clock(Clock), .WE(WMyPosEnable), .WAddr({WMyPosRow, WMyPosCol}), .WData(WMyPosData), .RAddr({RMyPosRow, RMyPosCol}), .RData(RMyPosData));
	RAM		VsBoard(.Clock(Clock), .WE(WVsPosEnable), .WAddr({WVsPosRow, WVsPosCol}), .WData(WVsPosData), .RAddr({RVsPosRow, RVsPosCol}), .RData(RVsPosData));
	RAM		MyBoardGame(.Clock(Clock), .WE(WMyPosEnable), .WAddr({WMyPosRow, WMyPosCol}), .WData(WMyPosData), .RAddr({RMyPosRowG, RMyPosColG}), .RData(RMyPosDataG));
	//RAM		VsBoardGame(.Clock(Clock), .WE(WVsPosEnable), .WAddr({WVsPosRow, WVsPosCol}), .WData(WVsPosData), .RAddr({RVsPosRowG, RVsPosColG}), .RData(RVsPosDataG));
endmodule