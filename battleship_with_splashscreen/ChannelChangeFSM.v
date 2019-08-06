
module TrackChannelFSM(Clock, Reset, Channel, ChannelChange_done, ChannelChange, State);
	//---------------------------------------------------------------
	//	Input / Output Declarations
	//---------------------------------------------------------------
	
	//System Inputs
	input					Clock, Reset;
	
	//Channel input and control
	input		[3:0]		Channel;
	input					ChannelChange_done;
	output				ChannelChange;
	
	//Chipscope debugging
	output				State;
	
	//---------------------------------------------------------------
	//	Wires
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg					CurrentState, NextState;
	reg					ChannelChange;
	reg		[3:0]		PreviousChannel;
	reg		[3:0]		CurrentChannel;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter STATE_Unchanged	= 1'b0;
	parameter STATE_Changed	= 1'b1;
	//---------------------------------------------------------------		
	
	//---------------------------------------------------------------
	//	FSM
	//---------------------------------------------------------------
	
	//for chipscope debugging
	assign State = CurrentState;

	always @ ( posedge Clock ) begin
		if (Reset)
			CurrentState <= STATE_Unchanged;
		else
			CurrentState <= NextState;
		CurrentChannel <= Channel;
		PreviousChannel <= CurrentChannel;
	end
	
	always @ ( * ) begin
		NextState = CurrentState;
		ChannelChange = 1'b0;
		
		case(CurrentState)
			STATE_Unchanged: begin
				//State Transition
				if (PreviousChannel != CurrentChannel)
					NextState = STATE_Changed;
				//Outputs
			end
			
			STATE_Changed: begin
				//State Transition
				if (ChannelChange_done) 
					NextState = STATE_Unchanged;
				//Outputs
				ChannelChange = 1'b1;
			end
			
			default: begin
			end
		endcase
	end
	

endmodule
