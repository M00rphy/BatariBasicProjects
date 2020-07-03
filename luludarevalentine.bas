    set kernel_options player1colors playercolors pfcolors
    set tv ntsc
	set romsize 16k

   ;```````````````````````````````````````````````````````````````
   ;  _Master_Counter can be used for many things, but it is 
   ;  really useful for animating sprite frames when used
   ;  with _Frame_Counter.
   ;
   dim _Master_Counter = a
   dim _Frame_Counter = b

   ;```````````````````````````````````````````````````````````````
   ;  Sound channel 0 variables.
   ;
   dim _Sound0 = c
   dim _Chan0_Duration = d
   dim _Chan0_Counter = e

   dim bmp_48x1_1_color = j
   ;```````````````````````````````````````````````````````````````
   ;  Converts 6 digit score to 3 sets of two digits.
   ;
   ;  The 100 thousands and 10 thousands digits are held by sc1.
   ;  The thousands and hundreds digits are held by sc2.
   ;  The tens and ones digits are held by sc3.
   ;
   dim sc1 = score
   dim sc2 = score+1
   dim sc3 = score+2

   ;```````````````````````````````````````````````````````````````
   ;  These can be used for other things using different aliases,
   ;  but for the GAME OVER loop, they are used to temporarily 
   ;  remember the score for the 2 second score/high score flip.
   ;
   dim _Temp_Score01 = s
   dim _Temp_Score02 = t
   dim _Temp_Score03 = u

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the high score until the game is turned off.
   ;
   dim _High_Score01 = v
   dim _High_Score02 = w
   dim _High_Score03 = x

   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_All_Purpose_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Game_Over = y
   dim _Bit3_Swap_Scores = y
   dim _Bit7_Last_Life = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers. 
   ;
   dim rand16 = z
   
   ;****************************************************************
   ;      Lulu base character variable naming.
   ;
   dim _LuluBX = player1x
   dim _LuluBY = player1y
   
   ;```````````````````````````````````````````````````````````````
   ; Lulu overlaping character colors cariable naming.
   ;
   dim _LHairX = player0x
   dim _LHairY = player0y
   
   ;***************************************************************
   ;     Ball/Key renaming variable.
   ;
   dim _ButtonY = bally
   dim _ButtonX = ballx
   
   ;***************************************************************
   ;
   ;  Turns on pfscore bars.
   ;
   const pfscore = 1





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PROGRAM START/RESTART
   ;
   ;
__Start_Restart


	  ;***************************************************************
      ;
      ;  Clears the screen.
      ;
      pfclear

   ;***************************************************************
   ;
   ;  Mutes volume of both sound channels.
   ;
   AUDV0 = 0 : AUDV1 = 0


   ;***************************************************************
   ;
   ;  Clears 21 of the normal 26 variables (fastest way).
   ;  Do not clear v, w, x, y, or z in this program. The variables
   ;  v through x remember the high score. The variable y holds a
   ;  bit that should not be cleared. The variable z is used for
   ;  random numbers in this program and clearing it would mess
   ;  up those random numbers.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0


   ;***************************************************************
   ;
   ;  Clears 7 of the 8 All_Purpose_01 bits.
   ;
   ;  Bit 2 is not cleared because _Bit2_Game_Over{2} is used
   ;  to control how the program is reset.
   ;
   _BitOp_All_Purpose_01 = _BitOp_All_Purpose_01 & %00000100


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   _LHairY = 200 : _LuluBY = 200 : missile0y = 200


   ;***************************************************************
   ;
   ;  Skips title screen if game has been played and player
   ;  presses fire button or reset switch at the end of the game.
   ;
   if _Bit2_Game_Over{2} then goto __Main_Loop_Setup





      ;***************************************************************
      ;***************************************************************
      ;
      ;   TITLE SCREEN SETUP
      ;
      ;
__Setup_Title_Screen


                        
      ;***************************************************************
      ;
      ;  Clears lives and sets score color.
      ;
      pfscore1 = 0 : scorecolor = $90
      


      ;***************************************************************
      ;
      ;  Sets title screen background color.
      ;
      COLUBK = $60


      ;***************************************************************
      ;
      ;  Restrains the reset switch.
      ;
      ;  This bit fixegs it so the reset switch becomes inactive if
      ;  it hasn't been released after entering a different segment
      ;  of the program. It does double duty by restraining the
      ;  fire button too in the title screen loop.
      ;
      _Bit0_Reset_Restrainer{0} = 1


      ;***************************************************************
      ;
      ;  Makes sure playfield is back to normal.
      ;
      playfieldpos = 8
      
      
   ;***************************************************************
   ;***************************************************************
   ;
   ;  TITLE SCREEN LOOP
   ;
   ;
__Title_Screen_Loop



	  bmp_48x1_1_color = bmp_48x1_1_color + 1

      gosub titledrawscreen bank2







      ;***************************************************************
      ; 
      ;  Reset/fire button check and end of title screen loop.
      ;  
      ;  Starts the game if the reset switch or the fire button
      ;  is pressed appropriately.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If fire button or select switch is not pressed, clear the 
      ;  restrainer bit and jump to beginning of title screen loop.
      ;
      if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Title_Screen_Loop

      ;```````````````````````````````````````````````````````````````
      ;  If reset/fire hasn't been released since starting 'title
      ;  screen' loop, jump to beginning of title screen loop.
      ;
      if _Bit0_Reset_Restrainer{0} then goto __Title_Screen_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset or Fire pressed appropriately. Jump to main loop setup.
   ;
   goto __Main_Loop_Setup





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP
   ;
   ;
__Main_Loop_Setup


   ;***************************************************************
   ;
   ;  Clears the GAME OVER bit for the main loop.
   ;
   _Bit2_Game_Over{2} = 0


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed in the title
   ;  screen section or the GAME OVER section. If the reset
   ;  switch isn't being held down, this bit will be cleared
   ;  in the main loop.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Restrains the fire button for the main loop.
   ;
   ;  This bit fixes it so the fire button becomes inactive if it
   ;  hasn't been released after being pressed in the title
   ;  screen section or the GAME OVER section. If the fire
   ;  button isn't being held down, this bit will be cleared
   ;  in the main loop.
   ;
   _Bit1_FireB_Restrainer{1} = 1


   ;***************************************************************
   ;
   ;  Starting position of player0 (acorn).
   ;
   _LHairX = 74 : _LHairY = 78


   ;***************************************************************
   ;
   ;  Starting position of player0 (squirrel).
   ;
   _LuluBX = (rand/2) + (rand&15) : _LuluBY = 0 


   ;***************************************************************
   ;
   ;  Defines missile0 height and location.
   ;
   missile0height = 4 : missile0y = 250


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = $B6


   ;***************************************************************
   ;
   ;  Sets score and score color.
   ;
   score = 0 : scorecolor = $1C


   ;***************************************************************
   ;
   ;  Sets health bar and sets color.
   ;
   pfscore1 = %11111111 : pfscorecolor = $D2


   ;***************************************************************
   ;
   ;  Defines shape of player0 sprite.
   ;
	  player1color:
      $00
      $50
      $50
      $50
      $50
      $80
      $80
      $80
      $80
      $80
      $80
      $5e
      $5e
      $5E
      $5E
      $5E
      $5E
end
 player1:
 %01100110
 %00100100
 %00100100
 %00100100
 %00111100
 %00111100
 %00111100
 %10111101
 %10111101
 %01111110
 %00111100
 %00011000
 %00111100
 %00100100
 %00111100
 %00011000
 %00111100
end



   ;***************************************************************
   ;
   ;  Sets up the main loop playfield.
   ;
   playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   XX...........................XX
   XX...........................XX
   X.............................X
   X.............................X
   X.............................X
   X.............................X
   X.............................X
   XX...........................XX
   XX...........................XX
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE GAME GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets playfield pixel color.
   ;
   COLUPF = 0
   ballheight = 8
   CTRLPF = $31
   
   ;***************************************************************
   ;   Key positioning.
   ;
   _ButtonX = 30 : _ButtonY = 12

   ;***************************************************************
   ;
   ;  Animation counters.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments _Master_Counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this subsection if _Master_Counter is less than 7.
   ;
   if _Master_Counter < 7 then goto __Skip_Counters

   ;```````````````````````````````````````````````````````````````
   ;  Increments _Frame_Counter and clears _Master_Counter.
   ;
   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears _Frame_Counter if it is greater than 3.
   ;
   if _Frame_Counter > 3 then _Frame_Counter = 0

__Skip_Counters



   ;***************************************************************
   ;
   ;  Squirrel animation (4 frames, 0 through 3).
   ;
      player0color:
   $00
   $00
   $00
   $00
   $00
   $00
   $5E
   $00
   $00
   $30
   $30
   $30
   $30
   $30
   $30
   $30
   $30
   $30
   $30
   $30
   $30
end
   on _Frame_Counter goto __Sq00 __Sq01 __Sq02 __Sq03

__Squirrel_Frame_Done






   ;***************************************************************
   ;
   ;  Joystick movement check.
   ;
   if joy0up then _LHairY = _LHairY - 1
   if joy0down then _LHairY = _LHairY + 1
   if joy0left then _LHairX = _LHairX - 1
   if joy0right then _LHairX = _LHairX + 1



   ;***************************************************************
   ;
   ;  Keeps player0 within screen borders.
   ;
   if _LHairX < 8 then _LHairX = 8
   if _LHairX > 150 then _LHairX = 150
   if _LHairY < 8 then _LHairY = 8
   if _LHairY > 84 then _LHairY = 84



   ;***************************************************************
   ;
   ;  Keeps the overlapping hair on top of Lulu at all times.
   ;
   _LuluBY = _LHairY
   _LuluBX = _LHairX
   
   ;***************************************************************
   ;     Checks for collision with button.
   ;
   if collision(player0,ball) then gosub _subscreen bank3 : _ButtonX = 200
   
   
   ;***************************************************************
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If no channel 0 sound effect is on, skip all channel 0
   ;  sound effect subsections.
   ;
   if !_Sound0 then goto __Skip_Channel_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Chan0_Duration = _Chan0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  If channel 0 duration counter is not zero, skip all
   ;  channel 0 sound effect subsections.
   ;
   if _Chan0_Duration then goto __Skip_Channel_0



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 1.
   ;
   ;  Fire button sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If sound 1 isn't on, skip this subsection.
   ;
   if _Sound0 <> 1 then goto __Skip_Chan0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves channel 0 data.
   ;
   temp4 = _Data_Fire_B_Sound[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp5 = _Data_Fire_B_Sound[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp6 = _Data_Fire_B_Sound[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Channel_0

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Chan0_Duration = _Data_Fire_B_Sound[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Channel_0

__Skip_Chan0_Sound_001



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 2.
   ;
   ;  Squirrel killed sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If sound 2 isn't on, skip this subsection.
   ;
   if _Sound0 <> 2 then goto __Skip_Chan0_Sound_002

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves channel 0 data.
   ;
   temp4 = _Data_Enemy_Destroyed[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp5 = _Data_Enemy_Destroyed[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp6 = _Data_Enemy_Destroyed[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Channel_0

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Chan0_Duration = _Data_Enemy_Destroyed[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Channel_0

__Skip_Chan0_Sound_002



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 3.
   ;
   ;  Player damaged sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If sound 3 isn't on, skip this subsection.
   ;
   if _Sound0 <> 3 then goto __Skip_Chan0_Sound_003

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves channel 0 data.
   ;
   temp4 = _Data_Player_Damaged[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp5 = _Data_Player_Damaged[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1
   temp6 = _Data_Player_Damaged[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Tells game to end if last life is lost and sound is done.
   ;
   if temp4 = 255 then if _Bit7_Last_Life{7} then _Bit2_Game_Over{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Channel_0

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Chan0_Duration = _Data_Player_Damaged[_Chan0_Counter] : _Chan0_Counter = _Chan0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Channel_0

__Skip_Chan0_Sound_003



   ;***************************************************************
   ;
   ;  Other channel 0 sound effects go here.
   ;
   ;***************************************************************



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __Skip_Channel_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__Clear_Channel_0

   ;```````````````````````````````````````````````````````````````
   ;  Turns off channel 0 sound variable and mutes channel.
   ;
   _Sound0 = 0 : AUDV0 = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__Skip_Channel_0


   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Checks to see if the game is over.
   ;
   if _Bit2_Game_Over{2} then goto __Game_Over_Setup



   ;***************************************************************
   ;
   ;  Reset switch check and end of main loop.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the reset switch is not pressed, turn off reset
   ;  restrainer bit and jump to beginning of main loop.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If the reset switch hasn't been released since starting the
   ;  game, jump to beginning of main loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Clears the GAME OVER bit so the title screen will appear.
   ;
   _Bit2_Game_Over{2} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Reset pressed appropriately. Restart the program.
   ;
   goto __Start_Restart





   ;***************************************************************
   ;
   ;  Squirrel animation frames.
   ;
__Sq00
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
 %00000000
 %00000000
 %00000000
 %10000001
 %11000011
 %01000010
 %11011011
 %01000010
 %11000011
 %01000010
 %01111110
end

   goto __Squirrel_Frame_Done


__Sq01
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
 %00000000
 %00000000
 %00000000
 %10000001
 %11000011
 %01000010
 %11011011
 %01000010
 %11000011
 %01000010
 %01111110
end

   goto __Squirrel_Frame_Done


__Sq02
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
 %00000000
 %00000000
 %00000000
 %10000001
 %11000011
 %01000010
 %11011011
 %01000010
 %11000011
 %01000010
 %01111110
end

   goto __Squirrel_Frame_Done



__Sq03
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
 %00000000
 %00000000
 %00000000
 %10000001
 %11000011
 %01000010
 %11011011
 %01000010
 %11000011
 %01000010
 %01111110
end

   goto __Squirrel_Frame_Done





   ;***************************************************************
   ;***************************************************************
   ;
   ;  GAME OVER SETUP
   ;
   ;
__Game_Over_Setup


   ;***************************************************************
   ;
   ;  Checks for a new high score.
   ;
   if sc1 > _High_Score01 then goto __New_High_Score
   if sc1 < _High_Score01 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  First byte equal. Do the next test. 
   ;
   if sc2 > _High_Score02 then goto __New_High_Score
   if sc2 < _High_Score02 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Second byte equal. Do the next test. 
   ;
   if sc3 > _High_Score03 then goto __New_High_Score
   if sc3 < _High_Score03 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes equal. Current score is the same as the high score.
   ;
   goto __Skip_High_Score

__New_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Saves new high score.
   ;
   _High_Score01 = sc1 : _High_Score02 = sc2 : _High_Score03 = sc3

__Skip_High_Score


   ;***************************************************************
   ;
   ;  Saves the latest score for the high score flip.
   ;
   _Temp_Score01 = sc1 : _Temp_Score02 = sc2 : _Temp_Score03 = sc3


   ;***************************************************************
   ;
   ;  Clears the counters.
   ;
   _Master_Counter = 0 : _Frame_Counter = 0


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   _LHairY = 200 : _LuluBY = 200 : missile0y = 200


   ;***************************************************************
   ;
   ;  Restrains reset switch and fire button for GAME OVER loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after entering a different segment
   ;  of the program. It also does double duty by restraining the
   ;  fire button in the GAME OVER loop.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Sets up GAME OVER playfield.
   ;
   playfield:
   .XXXXXX.XXXXXX.XXXXXXXXXX.XXXXX.
   .XX.....XX..XX.XX..XX..XX.XX....
   .XX.XXX.XXXXXX.XX..XX..XX.XXXX..
   .XX..XX.XX..XX.XX..XX..XX.XX....
   .XXXXXX.XX..XX.XX..XX..XX.XXXXX.
   ................................
   ...XXXXXX.XX..XX.XXXXX.XXXXXX...
   ...XX..XX.XX..XX.XX....XX..XX...
   ...XX..XX.XX..XX.XXXX..XXXXX....
   ...XX..XX.XX..XX.XX....XX..XX...
   ...XXXXXX...XX...XXXXX.XX..XX...
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  GAME OVER LOOP
   ;
   ;
__Game_Over_Loop



   ;***************************************************************
   ;
   ;  Goes to title screen after 20 seconds if player does nothing.
   ;
   ;  This includes a 2 second countdown timer. Any Atari 2600
   ;  program should freeze for 2 seconds when the game is over.
   ;  It is part of the usual standards and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  The master counter resets every 2 seconds (60 + 60 = 120).
   ;
   if _Master_Counter < 120 then goto __Skip_20_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Clears the master counter after 2 seconds have gone by
   ;  and flips the Swap_Scores bit.
   ;
   _Master_Counter = 0 : _Bit3_Swap_Scores{3} = !_Bit3_Swap_Scores{3}

   ;```````````````````````````````````````````````````````````````
   ;  If the Swap_Scores bit is on, display the high score.
   ;
   if _Bit3_Swap_Scores{3} then scorecolor = $AE : sc1=_High_Score01 : sc2=_High_Score02 : sc3=_High_Score03 : goto __Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  If the Swap_Scores bit is off, display the current score.
   ;
   scorecolor = $1C : sc1=_Temp_Score01 : sc2=_Temp_Score02 : sc3=_Temp_Score03 

__Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  The frame counter increments every 2 seconds.
   ;
   _Frame_Counter = _Frame_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  If _Frame_Counter reaches 10 (2 x 10 = 20 seconds), the
   ;  program resets and goes to the title screen. The GAME OVER
   ;  bit is cleared so the title screen will appear.
   ;
   if _Frame_Counter = 10 then _Bit2_Game_Over{2} = 0 : goto __Start_Restart

__Skip_20_Counter



   ;***************************************************************
   ;
   ;  Sets background color and playfield color.
   ;
   COLUBK = $00 : COLUPF = $2C

   ;```````````````````````````````````````````````````````````````
   ;  Changes colors after 2 seconds. This is only done to let
   ;  you, the programmer, know when 2 seconds have gone by. The
   ;  color change doesn't need to happen in a real game.
   ;
   if _Frame_Counter > 0 then COLUBK = $D2 : COLUPF = $DA



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Reset/fire button check and end of GAME OVER loop.
   ;  
   ;  Restarts the program if the reset switch or the fire
   ;  button is pressed appropriately.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the initial 2 second freeze is not over, jump to
   ;  beginning of the GAME OVER loop.
   ;
   if _Frame_Counter = 0 then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If fire button or reset switch is not pressed, clear the 
   ;  restrainer bit and jump to beginning of GAME OVER loop.
   ;
   if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If fire button hasn't been released since leaving the
   ;  main loop, jump to beginning of the GAME OVER loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset or Fire pressed appropriately. Restart the program.
   ;
   goto __Start_Restart




   ;***************************************************************
   ;***************************************************************
   ;
   ;
   ;  Sound effect data starts here.
   ;
   ;
   ;***************************************************************


   ;***************************************************************
   ;
   ;  Fire button sound effect.
   ;
   data _Data_Fire_B_Sound
   8,8,2
   1
   8,8,8
   1
   8,8,12
   1
   8,8,19
   1
   8,8,23
   1
   2,8,27
   4
   255
end



   ;***************************************************************
   ;
   ;  Enemy Destroyed sound effect.
   ;
   data _Data_Enemy_Destroyed
   10,8,15
   1
   8,15,15
   1
   8,4,17
   1
   6,7,16
   1
   4,8,19
   1
   2,7,10
   1
   6,4,18
   1
   6,8,5
   1
   10,7,10
   1
   10,4,19
   1
   10,8,29
   1
   2,4,21
   1
   2,15,18
   8
   255
end



   ;***************************************************************
   ;
   ;  Player Damaged sound effect.
   ;
   data _Data_Player_Damaged
   12,8,3
   1
   8,6,3
   1
   6,8,6
   1
   8,8,9
   1
   10,8,12
   1
   8,8,15
   1
   6,8,17
   1
   4,8,19
   1
   8,8,21
   1
   10,8,23
   1
   12,8,25
   1
   10,8,27
   1
   8,8,27
   1
   6,8,29
   1
   4,6,29
   1
   2,8,31
   8
   255
end
      ;**************************************************************
      ;                 Titlescreen kernel call.
      ;
      bank 2
      asm
      include "titlescreen/asm/titlescreen.asm"
end

;TODO implement the ball enemy, make the 3 other screens and make the titlescreen and win screen.

	  bank 3
_subscreen
   playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   XX...........................XX
   XX...........................XX
   ..............................X
   ..............................X
   ..............................X
   ..............................X
   ..............................X
   XX...........................XX
   XX...........................XX
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
	drawscreen
		ballx = 250
	bally = 250
  return