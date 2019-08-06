//Chris Wilson
//EECS 150

module HFSM(Clock, Reset, HCount, I2CDone, HMuxControl, CntCtrl, State);

	//////////////////////////////////////////
	//Inputs/Outputs
	//////////////////////////////////////////
	
	input					Clock, Reset;
	//input		[8:0] 	HCount;
	input		[10:0]	HCount;
	input					I2CDone;
	
	output	[1:0]		HMuxControl;
	output 				CntCtrl;
	
	//for chipscope debugging
	output	[2:0]		State;
	
	//////////////////////////////////////////
	//Regs
	//////////////////////////////////////////
	
	reg		[2:0]		CurrentState, NextState;
	reg		[1:0]		HMuxControl;
	reg					CntCtrl;
	
	//////////////////////////////////////////
	//Parameters
	//////////////////////////////////////////	
	
	parameter	STATE_Init 						=	3'h0;
   parameter	STATE_EAV 						=	3'h1;
   parameter	STATE_HorizontalBlanking 	=	3'h2;
   parameter	STATE_SAV 						=	3'h3;
   parameter	STATE_ActivePortion 			=	3'h4;
	parameter	STATE_EarlyReq					=	3'h5;
	parameter 	STATE_EarlyEnd					=  3'h6;
	
	//////////////////////////////////////////
	//Logic and FSM
	//////////////////////////////////////////
	
	//for chipscope debugging
	assign State = CurrentState;
	
	initial begin
		CurrentState 	= STATE_Init;
		NextState 		= CurrentState;
	end
	
	always @ ( posedge Clock ) begin
		if (Reset)
			CurrentState <= STATE_Init;
		else
			CurrentState <= NextState;
	end
	
	always @ ( * ) begin
		NextState 		= 	CurrentState;
		HMuxControl 	= 	2'b01;
		CntCtrl			=	1'b0;
		
		case(CurrentState)
			STATE_Init: begin
				//State Transition
				if (I2CDone) 
					NextState = STATE_EAV;
				//Outputs
			end
			
			STATE_EAV: begin
				//State Transition
				//if (HCount == 9'd362) 
				if (HCount == 11'd1444)
					NextState = STATE_HorizontalBlanking;
				//Outputs
				HMuxControl = 2'b11;
			end
			
			STATE_HorizontalBlanking: begin
				//State Transition
				//if (HCount == 9'd427) 
				if(HCount == 11'd1712)
					NextState = STATE_SAV;
				//Outputs
				HMuxControl = 2'b01;
			end
			
			STATE_SAV: begin
				//State Transition
				//if (HCount == 9'd0) 
				if(HCount == 11'd1715)
					NextState = STATE_EarlyReq;
				//Outputs
				HMuxControl = 2'b10;
			end
			
			STATE_EarlyReq: begin
				if(HCount == 11'd0)
					NextState = STATE_ActivePortion;
					
				//Outputs
				HMuxControl = 2'b10;
				CntCtrl = 1'b1;
			end
			
			STATE_ActivePortion: begin
				//State Transition
				if (HCount == 11'd1439) 
					NextState = STATE_EarlyEnd;
				//Outputs
				HMuxControl = 2'b00;
				CntCtrl = 1'b1;
			end
			
			STATE_EarlyEnd: begin
				if(HCount == 11'd1440)
					NextState = STATE_EAV;
					
				//Outputs
				HMuxControl = 2'b00;
			end
			
			default: begin
			end
		endcase
	end

endmodule
