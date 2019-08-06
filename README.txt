CS150 README.txt
Charlie Lin: cs150-ek
Chris Wilson: cs150-ej

http://www-inst.eecs.berkeley.edu/~cs150/fa06/Home.php

**********************************************************************

                    8888888888  888    88888
                   88     88   88 88   88  88
                    8888  88  88   88  88888
                       88 88 888888888 88   88
                88888888  88 88     88 88    888888
 
                88  88  88   888    88888    888888
                88  88  88  88 88   88  88  88
                88 8888 88 88   88  88888    8888
                 888  888 888888888 88   88     88
                  88  88  88     88 88    8888888

		        B A T T L E S H I P
 
				By,

                                      /~\    
                                     |oo )   
                                     _\=/_   
                     ___            /  _  \   
                    / ()\          //|/.\|\\  
                  _|_____|_        \\ \_/  ||  
                 | | === | |        \|\ /| ||  
                 |_|  O  |_|        # _ _/ #  
                  ||  O  ||          | | |    
                  ||__*__||          | | |    
                 |~ \___/ ~|         []|[]    
                 /=\ /=\ /=\         | | |    
_________________[_]_[_]_[_]________/_]_[_\___________________________
                 Charlie Lin      Chris Wilson



                  A long time ago in a lab far,
                  far, far, underground....



                          E p i s o d e 0.1a 
 
 
            A   N E W   H O P E (...for sleep and sunshine)



It is a period of civil war. CS150 Students, striking from a hidden 
base deep inside Cory Hall have won their first victory against the 
evil EECS department.  During the battle, Rebel spies managed to steal 
the source code to the TA solution ’s ultimate weapon: a boring 
rendition of battleship.  Pursued by the EECS departments sinister 
agents (Leo and Min), Charlie and Chris race to the early checkpoint 
deadline, custodian of the stolen code that can save their grades and 
restore their bodies to a normal sleep schedule...

**********************************************************************


NOTES: We put up a splash screen. The image on the splash screen causes 
timing errors during synthesize.  However, the project works normally 
otherwise because the screen does not affect the actual gameplay 
portion.  Since the project synthesizes without any errors without the
splash screen, we have submitted 2 copies (one with the splash screen
and one without).



List of Buttons:

SW1:         Hard Reset

SW2:         Set values on dip switches

SW3:         Switch between Game State (gs), Channel Select (ch), and 
	     Source/Destination select

SW5:         Transition to initialization

SW6:         Soft Reset

Start:       Enter game

DPad /       Move
Joystick:

R:           Rotate ships

A:           Place ships and shots

***During Address Select phase:***

SW9[8:1]:    Source Address (DD7 and DD8)
SW10[8:1]:   Destination Address (DD5 and DD6)

***During Channel Select phase:***

SW9[4:1]:    Channel
SW9[5]:      CNS (0 if server, 1 if client)
SW9[6]:      TA (0 if not playing with TA solution, 1 if playing 
             with TA solution)



Setup Directions:

1.  Press SW1 to hard reset the Board.

2.  Use the SW3 switch to cycle between the setup modes.  During each
    mode, use the dip switches to select the desired value and then 
    press SW2 to set the value.

3.  After setting the desired channel and addresses, press SW5 to 
    enter the initialization phase.  

4.  Press START on the controller to enter the game. 

5.  Begin gameplay as normal.

6.  Once the game has finished, press SW6 (soft reset) to soft reset
    the game.
