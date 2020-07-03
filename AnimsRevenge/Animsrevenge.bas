      ;****************************************************************
      ;
      ;  Anims's Revenge
      ;  (C) Nyxbyte 2015
      ;  Stop purple guy from killing more kids.
      ;  wwww.nyxbyte.16mb.com
      ;
      ;***************************************************************


      ;***************************************************************
      ;
      ;  Kernel options.
      ;
      set kernel_options player1colors playercolors pfcolors
      set romsize 32k
      set tv ntsc
	  set optimization inlinerand
	  set smartbranching on

      ;***************************************************************
      ;
      ;  Variable aliases go here (DIMs).
      ;
      ;  You can have more than one alias for each variable.
      ;  If you use different aliases for bit operations, it is
      ;  easier to understand and remember what they do.
      ;
      ;```````````````````````````````````````````````````````````````
      ;```````````````````````````````````````````````````````````````
      ;  _Master_Counter can be used for many things, but it is 
      ;  really useful for animating sprite frames when used
      ;  with _Frame_Counter.
      ;
      dim _Master_Counter = a
      dim _Frame_Counter = b

      ;```````````````````````````````````````````````````````````````
      ;  Sound variables.
      ;
      dim _Sound0 = c
      dim _SoundCounter0 = d
      dim _C0 = e
      dim _V0 = f
      dim _F0 = g
      
      ;```````````````````````````````````````````````````````````````
      ;  Character names diming.
      ;
      dim PGuyX = player0x.h
	  dim PGuyY = player0y.i
      
	  dim PuppetY = player1y
	  dim PuppetX = player1x
	  
	  ;```````````````````````````````````````````````````````````````
	  ; Pause screen variables. 
	  ;
	  dim _Pause_Mem_Color_Tmp = j
	  dim _Pause_Color_Tmp = m
	  dim _Bit2_Pause_Clr_Scheme = m
	  dim _Bit0_BW_Mem = m
	  dim _Bit1_BW_Check = m
      
	  ;```````````````````````````````````````````````````````````````
      ;  Player1/Ball direction variable bits
      ;
      
      dim _BitOp_P1_M0_Direction = k
      dim _Bit0_Player1_Direction_Up = k
      dim _Bit1_Player1_Direction_Down = k
      dim _Bit2_Player1_Direction_Left = k
      dim _Bit3_Player1_Direction_Right = k
      dim _Bit4_Ball_Direction_Up = k
      dim _Bit5_Ball_Direction_Down = k
      dim _Bit6_Ball_Direction_Left = k
      dim _Bit7_Ball_Direction_Right = k
      
      ;```````````````````````````````````````````````````````````````
      ; Screen flags/variables.
      ;
      dim _Bitop_Screen_Counter = l
      dim _Bit0_Main_Screen = l
      dim _Bit1_Up_Screen = l
      dim _Bit2_Down_Screen = l
      dim _Bit3_Left_Screen = l
      dim _Bit4_Right_Screen = l

      
      ;```````````````````````````````````````````````````````````````
      ;              _Mytemp03 variable for the PF collision
      ;
      dim _MyTemp03 = o
      
      
      ;```````````````````````````````````````````````````````````````
      ;         Pause screen counter variable.
      ;
      dim _Pause_Counter_Tmp = n
      
      ;```````````````````````````````````````````````````````````````
      ;          Player1 coordinate variables/flags.
      ;
      dim _Bitop_Coord_Counter = p
      dim _Bit0_Coord_Y_Up = p
      dim _Bit1_Coord_Y_Down = p
      dim _Bit2_Coord_X_Right = p
      dim _Bit3_Coord_X_Left = p
      
      ;```````````````````````````````````````````````````````````````
      ;           _MyTemp02 variable for PF collision
      ;
      dim _MyTemp02 = q
      ;```````````````````````````````````````````````````````````````
      ;       Temporal variable dims for partial collision detectionl.
      ;
      dim _MyTemp01 = r       
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
      dim _Bit4_Ball_Moving = y
      dim _Bit7_Last_Life = y



      ;```````````````````````````````````````````````````````````````
      ;  Makes better random numbers. 
      ;
      dim rand16 = z
      
      ;```````````````````````````````````````````````````````````````
      ;  Converts 6 digit score to 3 sets of two digits.
      ;
      ;  The 100 thousands and 10 thousands digits are held by sc1.
      ;  The thousands and hundreds digits are held by s2.
      ;  The tens and ones digits are held by s3.
      ;
      dim s1 = score
      dim s2 = score+1
      dim s3 = score+2

      ;***************************************************************
      ;
      ;  Turns on pfscore bars.
      ;
      const pfscore = 1
	  ;***************************************************************
	  ;
      ;  Defines the edges of the playfield for the missile.
      ;  If the missile is a different size, you'll need to adjust
      ;  the numbers.
      ;
      const _M_Edge_Top = 2
      const _M_Edge_Bottom = 88
      const _M_Edge_Left = 2
      const _M_Edge_Right = 159




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
      PuppetY = 200 : player0y = 200 : bally = 250


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
      ;  Starting position of player1 (The Puppet).
      ;
      PuppetX = 74 : PuppetY = 78


      ;***************************************************************
      ;
      ;  Starting position of player0 (Purple guy).
      ;
      player0x = (rand/4) + (rand&15) : player0y = 0 


      ;***************************************************************
      ;
      ;  Defines ball height and location.
      ;
      ballheight = 4 : bally = 78


      ;***************************************************************
      ;
      ;  Sets background color.
      ;
      COLUBK = $02


      ;***************************************************************
      ;
      ;  Sets score and score color.
      ;
      score = 0 : scorecolor = $1E


      ;***************************************************************
      ;
      ;  Sets number of lives and sets color.
      ;
      pfscore1 = %11111111 : pfscorecolor = $06

__Main_Screen
      ;***************************************************************
      ;
      ;  Sets playfield colors.
      ;      
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $00
end


      ;***************************************************************
      ;
      ;  Sets up the main loop playfield.
      ;

        playfield:
        XXXXXX....................XXXXXX
        XXXXXX....................XXXXXX
        XXX..........................XXX
        ................................
        ................................
        ................................
        ................................
        ................................
        ................................
        XXX..........................XXX
        XXXXXX....................XXXXXX
        XXXXXX....................XXXXXX
end


   ;***************************************************************
   ;
   ;  Remembers position of COLOR/BW switch.
   ;
   _Bit0_BW_Mem{0} = 0 : if switchbw then _Bit0_BW_Mem{0} = 1


      ;***************************************************************
      ;***************************************************************
      ;
      ;  MAIN LOOP (MAKES THE GAME GO)
      ;
      ;
 
      CTRLPF = $31
      ballheight = 8
      _Bitop_Screen_Counter = 0

__Main_Loop

	  



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


	  ;*************************************************************
	  ;    Clears the player1 coordinates counter if returns or is
	  ;    in the main screen.
	  ;
	  _Bitop_Coord_Counter = 0 : _Bitop_Screen_Counter = 0



      ;**************************************************************
      ;    The puppet static sprite
      ;
__Puppet
      player1color:
      $00
      $0e
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $00
      $00
      $0e
      $00
      $0e
      $00
      $00
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
end

 player1:
 %01000010
 %01000010
 %01000010
 %01000010
 %01000010
 %01000010
 %01000010
 %01000010
 %00100100
 %10011001
 %10011001
 %10011001
 %10011001
 %10011001
 %01011010
 %00111100
 %00011000
 %00111100
 %01100110
 %01100110
 %01011010
 %00011000
 %01111110
end
      ;***************************************************************
      ;
      ;  Purple guyanimation (4 frames, 0 through 3).
      ;
__Purple1
	  player0color:
      $34
      $54
      $54
      $54
      $54
      $54
      $54
      $54
      $54
      $54
      $54
      $54      
      $1c
      $54
      $54
      $54
      $54
      $54
      $54
      $54      
end      
      on _Frame_Counter goto __PG00 __PG01 __PG02 __PG03

__PG_Frame_Done

      ;***************************************************************
      ;
      ;  ball check and fire button check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;If ball is moving skip this subsection.
      ;
      if _Bit4_Ball_Moving{4} then goto __Skip_FireB

      ;```````````````````````````````````````````````````````````````
      ;Turns on Ball movement.
      ;
      _Bit4_Ball_Moving{4} = 1
      
      ;```````````````````````````````````````````````````````````````
      ;Takes a 'sanpshot' of player1 direction so the ball will stay
      ;on track until it hits something
      ;
      _Bit4_Ball_Direction_Up{4} = _Bit0_Player1_Direction_Up{0}
      _Bit5_Ball_Direction_Down{5} = _Bit1_Player1_Direction_Down{1}
      _Bit6_Ball_Direction_Left{6} = _Bit2_Player1_Direction_Left{2}
      _Bit7_Ball_Direction_Right{7} = _Bit3_Player1_Direction_Right{3}
      

__FireB_Check

      ;```````````````````````````````````````````````````````````````
      ;  Checks fire button since ball is off the screen.
      ;  If fire button is not pressed, skip this subsection.
      ;
      if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_FireB
      

      ;```````````````````````````````````````````````````````````````
      ;  If fire button hasn't been released since title screen,
      ;  skip this subsection.
      ;
      if _Bit1_FireB_Restrainer{1} then goto __Skip_FireB
	  ;```````````````````````````````````````````````````````````````
	  ;  Turns on fire button restrainer.
	  ;
	  _Bit1_FireB_Restrainer{1} = 1


      ;```````````````````````````````````````````````````````````````
      ;  Starts the firing of ball.
      ;
      if _Bit4_Ball_Direction_Up{4} then ballx = PuppetX + 4 : bally = PuppetY - 5
      if _Bit5_Ball_Direction_Down{5} then ballx = PuppetX + 4 : bally = PuppetY - 1
      if _Bit6_Ball_Direction_Left{6} then ballx = PuppetX + 2 : bally = PuppetY - 3
      if _Bit7_Ball_Direction_Right{7} then ballx = PuppetX + 6 : bally = PuppetY - 3

__Skip_FireB


	   ;***************************************************************
	   ;Ball movement check
	   ;
	   ;```````````````````````````````````````````````````````````````
	   ; If ball isn't moving, skip this subsection.
	   ;
	   if !_Bit4_Ball_Moving{4} then goto __Skip_Ball
	   
	   ;```````````````````````````````````````````````````````````````
	   ; Move Ball in the appropiate direction.
	   ;
	   if _Bit4_Ball_Direction_Up{4} then bally = bally - 8
	   if _Bit5_Ball_Direction_Down{5} then bally = bally + 8
	   if _Bit6_Ball_Direction_Left{6} then ballx = ballx - 8
	   if _Bit7_Ball_Direction_Right{7} then ballx = ballx + 8
	   
	   ;```````````````````````````````````````````````````````````````
	   ; Clears ball if it hits the edge of the screen.
	   ;
	   if bally < _M_Edge_Top then goto __Delete_Ball
	   if bally > _M_Edge_Bottom then goto __Delete_Ball
	   if ballx < _M_Edge_Left then goto __Delete_Ball
	   if ballx > _M_Edge_Right then goto __Delete_Ball
	   
	   ;```````````````````````````````````````````````````````````````
	   ; Clears ball if it hits a playfield pixel.
	   ;
	   if collision(playfield,ball) then goto __Delete_Ball

	   goto __Skip_Ball

__Delete_Ball

       ;```````````````````````````````````````````````````````````````
       ; Clears ball moving bit and moves it off the screen.
       ;
       _Bit4_Ball_Moving{4} = 0 : ballx = 200 : bally = 200
       
__Skip_Ball       

	   ;***************************************************************
	   ;
	   ;  Joystick movement precheck.
	   ;
	   ;```````````````````````````````````````````````````````````````
	   ;  If joystick not moved, skip this subsection.
	   ;
	   if !joy0up && !joy0down && !joy0left && !joy0right then goto __Skip_Joystick_Precheck

	   ;```````````````````````````````````````````````````````````````
	   ;  Joy0 has been moved, so this clears player1 direction bits.
	   ;
	   _BitOp_P1_M0_Direction = _BitOp_P1_M0_Direction & %11110000

__Skip_Joystick_Precheck

      ;***************************************************************
	  ;
      ;  Joy0 up check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved up, skip this subsection.
      ;
      if !joy0up then goto __Skip_Joy0_Up
      gosub _P_U bank3
      ;```````````````````````````````````````````````````````````````
      ; Turns on the up direction bit
      ;
	  _Bit0_Player1_Direction_Up{0} = 1
      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x left side coordinate to pf coordinate.
      ;
      _MyTemp01 = ((PuppetX-15)/4)

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x right side coordinate to pf coordinate.
      ;
      temp5 = (((PuppetX)-15)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = (((PuppetY+6)-player1height)/8)-1

      ;```````````````````````````````````````````````````````````````
      ;  Copies right side playfield coordinate for the for-next loop.
      ;
      _MyTemp02 = temp5

      ;```````````````````````````````````````````````````````````````
      ;  This for-next loop uses pfread to see if any playfield pixels
      ;      are in the way.
      ;
      for _MyTemp03 = _MyTemp01 to temp5

      if pfread(_MyTemp02,temp6) then goto __Skip_Joy0_Up

      _MyTemp02 = _MyTemp02 - 1

      next
      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite up.
      ;	
      PuppetY = PuppetY - 1 : pfscroll downdown 
      ;```````````````````````````````````````````````````````````````
      ;  Checks for a collision with the playfield.
      ;
      if !collision(playfield,player1) then goto __Skip_Joy0_Up

      ;```````````````````````````````````````````````````````````````
      ;  Converts playfield coordinate to sprite x coordinate.
      ;
      _MyTemp02 = (_MyTemp01*4)+16

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite left if collision happened on the left side of
      ;      the playfield pixel.
      ;
      if PuppetX > _MyTemp02 then PuppetX = PuppetX - 1 : goto __Skip_Joy0_Up

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite right if collision happened on the right side
      ;      of the playfield pixel.
      ;
      PuppetX = PuppetX + 1

__Skip_Joy0_Up

      ;***************************************************************
      ;
      ;  Joy0 down check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved down, skip this subsection.
      ;
      if !joy0down then goto __Skip_Joy0_Down
      gosub _P_D bank4
      ;```````````````````````````````````````````````````````````````
      ;Turns on the down direction bit
      ;
	  _Bit1_Player1_Direction_Down{1} = 1
      
      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x left side coordinate to pf coordinate.
      ;
      _MyTemp01 = ((PuppetX-15)/4)

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x right side coordinate to pf coordinate.
      ;
      temp5 = (((PuppetX)-15)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = ((PuppetY-7)/8)+1

      ;```````````````````````````````````````````````````````````````
      ;  Copies right side playfield coordinate for the for-next loop.
      ;
      _MyTemp02 = temp5

      ;```````````````````````````````````````````````````````````````
      ;  This for-next loop uses pfread to see if any playfield pixels
      ;      are in the way.
      ;
      for _MyTemp03 = _MyTemp01 to temp5

      if pfread(_MyTemp02,temp6) then goto __Skip_Joy0_Down

      _MyTemp02 = _MyTemp02 - 1

      next
   
      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite down.
      ;
      PuppetY = PuppetY + 1 : pfscroll upup

      ;```````````````````````````````````````````````````````````````
      ;  Checks for a collision with the playfield.
      ;
      if !collision(playfield,player1) then goto __Skip_Joy0_Down

      ;```````````````````````````````````````````````````````````````
      ;  Converts playfield coordinate to sprite x coordinate.
      ;
      _MyTemp02 = (_MyTemp01*4)+16

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite left if collision happened on the left side of
      ;      the playfield pixel.
      ;
      if PuppetX > _MyTemp02 then PuppetX = PuppetX - 1 : goto __Skip_Joy0_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite right if collision happened on the right side
      ;      of the playfield pixel.
      ;
      PuppetX = PuppetX + 1

__Skip_Joy0_Down

      ;***************************************************************
      ;
      ;  Joy0 left check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved to the left, skip this subsection.
      ;
      if !joy0left then goto __Skip_Joy0_Left
      gosub _P_L bank6
      ;```````````````````````````````````````````````````````````````
      ;Turn on the left direction bit.
      ;
      _Bit2_Player1_Direction_Left{2} = 1
      

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x coordinate to playfield coordinate.
      ;
      temp5 = ((PuppetX-14)/4)-1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = (PuppetY-1)/8

      ;```````````````````````````````````````````````````````````````
      ;  Sets up variables for the for-next loop.
      ;
      _MyTemp01 = ((PuppetY-(player1height+1)))/8
      _MyTemp02 = temp6

      ;```````````````````````````````````````````````````````````````
      ;  This for-next loop uses pfread to see if any playfield pixels
      ;      are in the way.
      ;
      for _MyTemp03 = _MyTemp01 to temp6

      if pfread(temp5,_MyTemp02) then goto __Skip_Joy0_Left

      _MyTemp02 = _MyTemp02 - 1

      next

      ;```````````````````````````````````````````````````````````````
      ;  Moves player1 sprite to the left.
      ;
      PuppetX = PuppetX - 1 : pfscroll right

      ;```````````````````````````````````````````````````````````````
      ;  Skips the rest of this subsection if joy0 is moved up or down.
      ;
      if joy0up || joy0down then goto __Skip_Joy0_Left

      ;```````````````````````````````````````````````````````````````
      ;  Checks for a collision with the playfield.
      ;
      if !collision(playfield,player1) then goto __Skip_Joy0_Left
      ;```````````````````````````````````````````````````````````````
      ;  Converts playfield coordinate to sprite y coordinate.
      ;
      _MyTemp02 = (temp6 * 8) + 8

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite up if collision happened on the top side of
      ;      the playfield pixel.
      ;
      if PuppetY > _MyTemp02 then goto __Left_Move_Down

      PuppetY = PuppetY - 1

      _MyTemp02 = ((PuppetY-(player1height+1)))/8

      if pfread(temp5,_MyTemp02) then PuppetY = PuppetY + 1

      goto __Skip_Joy0_Left

__Left_Move_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite down if collision happened on the bottom side
      ;      of the playfield pixel.
      ;
      PuppetY = PuppetY + 1

__Skip_Joy0_Left

      ;***************************************************************
      ;
      ;  Joy0 right check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick isn't moved to the right, skip this subsection.
      ;
      if !joy0right then goto __Skip_Joy0_Right
      gosub _P_R bank5

      ;```````````````````````````````````````````````````````````````
      ;Turns on the right direction bit.
      ;
      _Bit3_Player1_Direction_Right{3} = 1

      ;```````````````````````````````````````````````````````````````
      ;  Converts PuppetX coordinate to playfield coordinate.
      ;
      temp5 = (((PuppetX)-13)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts PuppetY coordinate to playfield coordinate.
      ;
      temp6 = (PuppetY-1)/8

      ;```````````````````````````````````````````````````````````````
      ;  Sets up variables for the for-next loop.
      ;
      _MyTemp01 = ((PuppetY-(player1height+1)))/8
      _MyTemp02 = temp6

      ;```````````````````````````````````````````````````````````````
      ;  This for-next loop uses pfread to see if any playfield pixels
      ;      are in the way.
      ;
      for _MyTemp03 = _MyTemp01 to temp6

      if pfread(temp5,_MyTemp02) then goto __Skip_Joy0_Right

      _MyTemp02 = _MyTemp02 - 1

      next

      ;```````````````````````````````````````````````````````````````
      ;  Moves player1 sprite to the right.
      ;
      PuppetX = PuppetX + 1 : pfscroll left

      ;```````````````````````````````````````````````````````````````
      ;  Skips the rest of this subsection if joy0 is moved up or down.
      ;
      if joy0up || joy0down then goto __Skip_Joy0_Right

      ;```````````````````````````````````````````````````````````````
      ;  Checks for a collision with the playfield.
      ;
      if !collision(playfield,player1) then goto __Skip_Joy0_Right

      ;```````````````````````````````````````````````````````````````
      ;  Converts playfield coordinate to sprite y coordinate.
      ;
      _MyTemp02 = (temp6 * 8) + 8

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite up if collision happened on the top side of
      ;      the playfield pixel.
      ;
      if PuppetY > _MyTemp02 then goto __Right_Move_Down

      PuppetY = PuppetY - 1

      _MyTemp02 = ((PuppetY-(player1height+1)))/8

      if pfread(temp5,_MyTemp02) then PuppetY = PuppetY + 1

      goto __Skip_Joy0_Right

__Right_Move_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite down if collision happened on the bottom side
      ;      of the playfield pixel.
      ;
      PuppetY = PuppetY + 1
      

__Skip_Joy0_Right





      ;***************************************************************
      ;
      ;  Keeps player1 within screen borders.
      ;
      if PuppetX < 17 then PuppetX = 17
      if PuppetX > 136 then PuppetX = 136
      if PuppetY < 24 then PuppetY = 24
      if PuppetY > 89 then PuppetY = 89



      ;***************************************************************
      ;
      ;  Purple guy chases the player.
      ;
      if PGuyY < PuppetY then PGuyY = PGuyY + 0.85
      if PGuyY > PuppetY then PGuyY = PGuyY - 0.85
      if PGuyX < PuppetX then PGuyX = PGuyX + 0.85
      if PGuyX > PuppetX then PGuyX = PGuyX - 0.85
__Screen_Logic      
      ;***************************************************************
      ;    Player1 coordinates counter math for the first screen.
      ;
      ;if PuppetY = 89 then _Bit1_Coord_Y_Down = 1 : _Bit2_Down_Screen = 2
      ;if PuppetY = 24 then _Bit0_Coord_Y_Up = 2 : _Bit1_Up_Screen = 1
      ;if PuppetX = 17 then _Bit3_Coord_X_Left = 3 : _Bit3_Left_Screen = 3
      ;if PuppetX = 136 then _Bit2_Coord_X_Right = 4 : _Bit4_Right_Screen = 4
      
      ;***************************************************************
      ;   Coordinates counter value actions.
      ;
      ;if _Bit1_Up_Screen = 1 then gosub __Lvl_5 bank5
      ;if _Bit2_Down_Screen = 2 then gosub __Lvl_2
      ;if _Bit3_Left_Screen = 3 then gosub __Lvl_4 bank4
      ;if _Bit4_Right_Screen = 4 then gosub __Lvl_3 bank3
      
      
      ;if _Bit1_Up_Screen = 1 && _Bit1_Coord_Y_Down = 1 then _Bit0_Main_Screen = 1
      
      
     ; if _Bit0_Main_Screen = 1 then gosub __Semi_Main_Screen bank7
      
      ;*`````````````````````````````````````````````````````````````
      ; to do = get the screen logic to work.  



	  ;***************************************************************
      ;
      ;  Purpleguy/ball collision check.
      ;
      if !collision(ball,player0) then goto __Skip_PG_Kill

      ;```````````````````````````````````````````````````````````````
      ;  Adds 1 to the score.
      ;
      score = score + 1 
      if pfscore1 < 255 then pfscore1 = pfscore1*2|1
      
      
      ;```````````````````````````````````````````````````````````````
      ;  Checks to see if the score is 15 to go to the next screen
      ;
      if s3 = 15 then goto __Lvl_2

      ;```````````````````````````````````````````````````````````````
      ;  Sound effect 1 setup.
      ;
      if _Sound0 then goto __Skip_Sound0_Setup

      _Sound0 = 1 : _SoundCounter0 = 10

      _C0 = 4 : _V0 = 12 : _F0 = 14

      temp5 = 255 : if PGuyY < PuppetY then temp5 = PuppetY - PGuyY

      if temp5 < 30 then _C0 = 12 ; Makes a different sound when closer to player.

__Skip_Sound0_Setup

      ;```````````````````````````````````````````````````````````````
      ;  Moves Purple guy to new location and removes missile.
      ;
      player0x = PuppetX + (rand&127) + (rand/16) : player0y = PuppetY + (rand/4) + (rand&63) - 1 : bally = 250

__Skip_PG_Kill                                    

      ;***************************************************************
      ;
      ;  Purple guy/The Puppet collision check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  if no collision between sprites, skip this subsection.
      ;
      if !collision(player0,player1) then goto __Skip_Players_Touch

	  ;```````````````````````````````````````````````````````````````
      ; Deletes a point from the current score.
      ;
      
      if s3 > 0 then score = score - 1
      

      ;```````````````````````````````````````````````````````````````
      ;  if pfscore1 bar is empty, activate last life bit.
      ;
      if !pfscore1 then _Bit7_Last_Life{7} = 1 

      ;```````````````````````````````````````````````````````````````
      ;  Deletes a life.
      ;
      if pfscore1 then pfscore1 = pfscore1/2
      ;```````````````````````````````````````````````````````````````
      ;                     if score is 0 end game
      ;
      if !s1 = $00 && !s2 = $00 && !s3 = $00 then goto _skip_death                        
      if s1 = $00 && s2 = $00 && s3 = $00 then goto __Game_Over_Loop
_skip_death

      ;```````````````````````````````````````````````````````````````
      ;  Moves Purple guy to new location and removes missile.
      ;
      player0x = PuppetX + (rand&127) + (rand/16) : player0y = PuppetY + (rand/4) + (rand&63) - 1 : bally = 250

      ;```````````````````````````````````````````````````````````````
      ;  Sound effect 2 setup.
      ;
      if _Sound0 then goto __Skip_Players_Touch

      _Sound0 = 2 : _SoundCounter0 = 10

      _C0 = 7 : _V0 = 12 : _F0 = 12

__Skip_Players_Touch


      ;***************************************************************
      ;
      ;  Point sound.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If the sound isn't on, skip this subsection.
      ;
      if _Sound0 <> 1 then goto __Skip_Sound1

      ;```````````````````````````````````````````````````````````````
      ;  Flips the frequency between 11 and 14.
      ;
      _F0 = _F0 ^ 5

      ;```````````````````````````````````````````````````````````````
      ;  Sets the tone, volume and frequency.
      ;
      AUDC0 = _C0 : AUDV0 = _V0 : AUDF0 = _F0

      ;```````````````````````````````````````````````````````````````
      ;  Decreases volume by 1 and makes sure it doesn't go below 2.
      ;
      _V0 = _V0 - 1 : if _V0 < 2 then _V0 = 2

      ;```````````````````````````````````````````````````````````````
      ;  Decreases the sound counter.
      ;
      _SoundCounter0 = _SoundCounter0 - 1

      ;```````````````````````````````````````````````````````````````
      ;  If sound counter is zero, clear _Sound0 and mute channel.
      ;
      if !_SoundCounter0 then _Sound0 = 0 : AUDV0 = 0

__Skip_Sound1




      ;***************************************************************
      ;
      ;  Purple guy touches The Puppet sound.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If the sound isn't on, skip this subsection.
      ;
      if _Sound0 <> 2 then goto __Skip_Sound2

      ;```````````````````````````````````````````````````````````````
      ;  Sets the tone, volume and frequency.
      ;
      AUDC0 = _C0 : AUDV0 = _V0 : AUDF0 = _F0

      ;```````````````````````````````````````````````````````````````
      ;  Decreases volume by 1 and makes sure it doesn't go below 2.
      ;
      _V0 = _V0 - 1 : if _V0 < 2 then _V0 = 2

      ;```````````````````````````````````````````````````````````````
      ;  Decreases the sound counter.
      ;
      _SoundCounter0 = _SoundCounter0 - 1

      ;```````````````````````````````````````````````````````````````
      ;  If sound counter is zero, clear _Sound0 and mute channel.
      ;  Also tells game to end if last life is lost.
      ;
      if !_SoundCounter0 then _Sound0 = 0 : AUDV0 = 0 : if _Bit7_Last_Life{7} then _Bit2_Game_Over{2} = 1

__Skip_Sound2

   ;***************************************************************
   ;
   ;  Pause check.
   ;
   if switchselect then goto __AP_Skip_Pause
   ;```````````````````````````````````````````````````````````````
   ;  Checks current position of COLOR/BW switch.
   ;
   _Bit1_BW_Check{1} = 0

   if switchbw then _Bit1_BW_Check{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Compares bits to see if COLOR/BW switch has moved.
   ;  The game is paused if the switch has moved.
   ;
   if _Bit0_BW_Mem{0} then if !_Bit1_BW_Check{1} then goto __Pause_Setup bank3

   if !_Bit0_BW_Mem{0} then if _Bit1_BW_Check{1} then goto __Pause_Setup bank3

   ;```````````````````````````````````````````````````````````````
   ;  Pauses game if fire button of second joystick is pressed.
   ;
   if joy1fire && !_Bit1_FireB_Restrainer{1} then goto __Pause_Setup bank3

__AP_Skip_Pause



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
      ;  restrainer bit and skip this subsection.
      ;
      if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

      ;```````````````````````````````````````````````````````````````
      ;  If the reset switch hasn't been released since starting the
      ;  game, skip this subsection.
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
      ;  END OF MAIN LOOP.
      ;
      ;***************************************************************
      
      ;***************************************************************
      ;     Pause Setup.
      ;
      
__Pause_Setup

	  ;***************************************************************
	  ;       Sound muting.
	  ;
	  AUDV0 = 0 : AUDV1 = 0
	  
	  ;***************************************************************
	  ; Restrains the fire button for using to unpause the game.
	  ;
	  _Bit1_FireB_Restrainer{1} = 1
	  
	  ;***************************************************************
	  ;     Clears the pause counter.
	  ;
	  _Pause_Counter_Tmp = 0
	  
	  ;***************************************************************
	  ;     Pause screen color randomizer.
	  ;
	  _Pause_Color_Tmp = (rand&7)
	  _Pause_Mem_Color_Tmp = _Pause_Color_Tmp
	  
	  ;***************************************************************
	  ; Pause Loop.
	  ;
__Pause_Game


	  ;***************************************************************
	  ;      Changes color scheme every 4 seconds
	  ;
	  ;```````````````````````````````````````````````````````````````
	  ; Increases the pause counter.
	  ;
	  _Pause_Counter_Tmp = _Pause_Counter_Tmp + 1
	  
	  ;```````````````````````````````````````````````````````````````
	  ;   Skips ahead if counter isn't high enough
	  ;
	  if _Pause_Counter_Tmp < 240 then goto __Skip_Pause_Counter
	  
	  ;```````````````````````````````````````````````````````````````
	  ;    Resets the pause counter.
	  ;
	  _Pause_Counter_Tmp = 0
	  
	  ;```````````````````````````````````````````````````````````````
	  ;    Gets a random number between 0 and 7.
	  ;
	  _Pause_Color_Tmp = (rand&7)
	  
	  ;```````````````````````````````````````````````````````````````
	  ;    Compares new color scheme with the previuos color scheme
	  ;    and selects a new color scheme if the color's are the same.
	  ;
	  
	  if _Pause_Color_Tmp = _Pause_Mem_Color_Tmp then _Pause_Color_Tmp = _Pause_Color_Tmp + (rand&3) + 1 : if _Pause_Color_Tmp > 7 then _Pause_Color_Tmp = _Pause_Color_Tmp - 8
	  
	  ;```````````````````````````````````````````````````````````````
	  ;  Remembers the new color scheme overriding the previous one.
	  ;
	  
	  _Pause_Mem_Color_Tmp = _Pause_Color_Tmp
	  
	  ;```````````````````````````````````````````````````````````````
	  ;  Decides if the B color scheme should be used instead.
	  ;
	  _Bit2_Pause_Clr_Scheme{2} = 0
	  
	  temp5 = rand : if temp5 < 128 then _Bit2_Pause_Clr_Scheme{2} = 1
	  
__Skip_Pause_Counter


	  ;***************************************************************
	  ;
	  ;  Jumps to the latest color scheme.
	  ;
	  on _Pause_Color_Tmp goto __Ps0 __Ps1 __Ps2 __Ps3 __Ps4 __Ps5 __Ps6 __Ps7

__Got_Pause_Colors
	  
	  
      ;***************************************************************
      ;
      ;  Purple guy animation frames.
      ;
      
__PG00
	 player0:
	 %00000111
	 %11100100
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %10111100
	 %00111100
	 %01111110
	 %10111101
	 %10111101
	 %10111101
	 %11111111
	 %01111110
	 %00111100
	 %01000010
	 %01011010
	 %01111110
	 %01011010
	 %00111100
end
      goto __PG_Frame_Done


__PG01
	 player0:
	 %00000111
	 %11100100
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %10111100
	 %00111100
	 %01111110
	 %10111101
	 %10111101
	 %10111101
	 %11111111
	 %01111110
	 %00111100
	 %01000010
	 %01011010
	 %01111110
	 %01011010
	 %00111100
end
      goto __PG_Frame_Done


__PG02
	 REFP0 = 8
	 player0:
	 %00000111
	 %11100100
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %10111100
	 %00111100
	 %01111110
	 %10111101
	 %10111101
	 %10111101
	 %11111111
	 %01111110
	 %00111100
	 %01000010
	 %01011010
	 %01111110
	 %01011010
	 %00111100
end
      goto __PG_Frame_Done



__PG03
	 REFP0 = 8
	 player0:
	 %00000111
	 %11100100
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %10111100
	 %00111100
	 %01111110
	 %10111101
	 %10111101
	 %10111101
	 %11111111
	 %01111110
	 %00111100
	 %01000010
	 %01011010
	 %01111110
	 %01011010
	 %00111100
end
      goto __PG_Frame_Done

	
__Lvl_2
	  PuppetY = 30 : PuppetX = 80 : player0x = 200 : player0y = 200
      pfclear
      playfieldpos = 8
      COLUBK = $02
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $04
end


	  playfield:
	 .........XXXX......XXXX.........
	 .........X............X.........
	 .........X............X.........
	 .........X............X.........
	 XXXXXXXXXX............XXXXXXXXXX
	 ................................
	 ................................
	 ................................
	 ................................
	 ................................
	 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
	  drawscreen

	  return
	  
	 ;***************************************************************
	 ;
     ;  Unpause check and end of pause loop.
	 ;
     ;```````````````````````````````````````````````````````````````
     ;  Jumps to beginning of the pause loop if the fire button
     ;  isn't pressed. Also clears the restrainer bit.
     ;
     if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Pause_Game

     ;```````````````````````````````````````````````````````````````
     ;  Jumps to beginning of the pause loop if the fire button
     ;  hasn't been released since starting the pause loop.
     ;
     if _Bit1_FireB_Restrainer{1} then goto __Pause_Game

     ;```````````````````````````````````````````````````````````````
     ;  Remembers position of COLOR/BW switch.
     ;
     _Bit0_BW_Mem{0} = 0 : if switchbw then _Bit0_BW_Mem{0} = 1

     ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
     ;```````````````````````````````````````````````````````````````
     ;
     ;  END OF PAUSE LOOP
     ;
     ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
     ;```````````````````````````````````````````````````````````````
     
   ;***************************************************************
   ;***************************************************************
   ;
   ;  RESTORES GAME FROM PAUSE
   ;
   ;  Puts everything back the way it was.
   ;
__Restore_Game_from_Pause


   ;***************************************************************
   ;
   ;  Restrains the fire button for the main loop.
   ;
   _Bit1_FireB_Restrainer{1} = 1


   ;***************************************************************
   ;
   ;  Restores score color.
   ;
   scorecolor = $1C


   goto __Main_Loop







   ;***************************************************************
   ;
   ;  Sets pause colors to gray.
   ;
__Ps0

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps0B

   pfcolors:
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
   $0C
end

   COLUP0 = $0C

   COLUBK = $0A

   scorecolor = $0C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to gray.
   
   
__Ps0B

   pfcolors:
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
   $0A
end

   COLUP0 = $0A

   COLUBK = $0C

   scorecolor = $0A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to reddish-orange.
   ;
__Ps1

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps1B

   pfcolors:
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
   $3C
end

   COLUP0 = $3C

   COLUBK = $3A

   scorecolor = $3C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to reddish-orange.
   ;
__Ps1B

   pfcolors:
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
   $3A
end

   COLUP0 = $3A

   COLUBK = $3C

   scorecolor = $3A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to purple.
   ;
__Ps2

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps2B

   pfcolors:
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
   $6C
end

   COLUP0 = $6C

   COLUBK = $6A

   scorecolor = $6C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to purple.
   ;
__Ps2B

   pfcolors:
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
   $6A
end

   COLUP0 = $6A

   COLUBK = $6C

   scorecolor = $6A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to blue.
   ;
__Ps3

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps3B

   pfcolors:
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
   $9C
end

   COLUP0 = $9C

   COLUBK = $9A

   scorecolor = $9C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to blue.
   ;
__Ps3B

   pfcolors:
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
   $9A
end

   COLUP0 = $9A

   COLUBK = $9C

   scorecolor = $9A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to green.
   ;
__Ps4

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps4B

   pfcolors:
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
   $CC
end

   COLUP0 = $CC

   COLUBK = $CA

   scorecolor = $CC

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to green.
   ;
__Ps4B

   pfcolors:
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
   $CA
end

   COLUP0 = $CA

   COLUBK = $CC

   scorecolor = $CA

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to yellowish.
   ;
__Ps5

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps5B

   pfcolors:
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
   $FC
end

   COLUP0 = $FC

   COLUBK = $FA

   scorecolor = $FC

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to yellowish.
   ;
__Ps5B

   pfcolors:
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
   $FA
end

   COLUP0 = $FA

   COLUBK = $FC

   scorecolor = $FA

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to darkish-blue.
   ;
__Ps6

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps6B

   pfcolors:
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
   $8C
end

   COLUP0 = $8C

   COLUBK = $8A

   scorecolor = $8C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to darkish-blue.
   ;
__Ps6B

   pfcolors:
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
   $8A
end

   COLUP0 = $8A

   COLUBK = $8C

   scorecolor = $8A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to orange-brown.
   ;
__Ps7

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps7B

   pfcolors:
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
   $2C
end

   COLUP0 = $2C

   COLUBK = $2A

   scorecolor = $2C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to orange-brown.
   ;
__Ps7B

   pfcolors:
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
   $2A
end

   COLUP0 = $2A

   COLUBK = $2C

   scorecolor = $2A

   goto __Got_Pause_Colors

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
      if s1 > _High_Score01 then goto __New_High_Score
      if s1 < _High_Score01 then goto __Skip_High_Score

      ;```````````````````````````````````````````````````````````````
      ;  First byte equal. Do the next test. 
      ;
      if s2 > _High_Score02 then goto __New_High_Score
      if s2 < _High_Score02 then goto __Skip_High_Score

      ;```````````````````````````````````````````````````````````````
      ;  Second byte equal. Do the next test. 
      ;
      if s3 > _High_Score03 then goto __New_High_Score
      if s3 < _High_Score03 then goto __Skip_High_Score

      ;```````````````````````````````````````````````````````````````
      ;  All bytes equal. Current score is the same as the high score.
      ;
      goto __Skip_High_Score

__New_High_Score

      ;```````````````````````````````````````````````````````````````
      ;  Saves new high score.
      ;
      _High_Score01 = s1 : _High_Score02 = s2 : _High_Score03 = s3

__Skip_High_Score


      ;***************************************************************
      ;
      ;  Saves the latest score for the high score flip.
      ;
      _Temp_Score01 = s1 : _Temp_Score02 = s2 : _Temp_Score03 = s3


      ;***************************************************************
      ;
      ;  Clears the counters.
      ;
      _Master_Counter = 0 : _Frame_Counter = 0


      ;***************************************************************
      ;
      ;  Makes sure sprites and missile are off the screen.
      ;
      player0y = 200 : PuppetY = 200 : bally = 200


      ;***************************************************************
      ;
      ;  Restrains reset switch and fire button for GAME OVER loop.
      ;
      ;  This bit fixes it so the reset switch becomes inactive if
      ;  it hasn't been released after entering a different segment
      ;  of the program. It does double duty by restraining the
      ;  fire button too in the GAME OVER loop.
      ;
      _Bit0_Reset_Restrainer{0} = 1


      ;***************************************************************
      ;
      ;  Puts playfield back to normal after all of the scrolling.
      ;
      playfieldpos = 8


      ;***************************************************************
      ;
      ;  Clears the screen.
      ;
      pfclear


      ;***************************************************************
      ;
      ;  Sets GAME OVER background color.
      ;
      COLUBK = $54


      ;***************************************************************
      ;
      ;  Sets up GAME OVER playfield.
      ;
      playfield:
      .X..X..X..X..XXX.X.X.XXX.XX.....
  	  X.X.XX.X.X.X..X..X.X.X...X.X....
      XXX.X.XX.X.X..X..XXX.XX..XX.....
      X.X.X..X.X.X..X..X.X.X...X.X....
      X.X.X..X..X...X..X.X.XXX.X.X....
      ................................
      X..X.XXX.XX......XX..XXX.XXX.XX.
      X.X...X..X.X.....X.X..X..X...X.X
      XX....X..X.X.....X.X..X..XX..X.X
      X.X...X..X.X.....X.X..X..X...X.X
      X..X.XXX.XX......XX..XXX.XXX.XX.
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
      if _Bit3_Swap_Scores{3} then scorecolor = $AE : s1=_High_Score01 : s2=_High_Score02 : s3=_High_Score03 : goto __Skip_Flip

      ;```````````````````````````````````````````````````````````````
      ;  If the Swap_Scores bit is off, display the current score.
      ;
      scorecolor = $1C : s1=_Temp_Score01 : s2=_Temp_Score02 : s3=_Temp_Score03 

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
      ;  Sets GAME OVER playfield pixel color.
      ;
      pfcolors:
      $0C
      $0E
      $0C
      $0A
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $0C
      $0E
end


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
      


      ;**************************************************************
      ;                 Titlescreen kernel call.
      ;
      bank 2
      asm
      include "titlescreen/asm/titlescreen.asm"
end

      bank 3
_P_U
     ;***************************************************************
     ;           The puppet moving forward.
     ;
     
	  player1color:
	  $00
      $00
      $0e
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
end

      on _Frame_Counter goto __Pu00 __Pu01 __Pu02 __Pu03

__Pu_Frame_Done
	  return

__Pu00	  
	 player1:
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01111110
	 %01111110
	 %01111110
	 %01111110
	 %01111110
end

	 goto __Pu_Frame_Done
	 
__Pu01
	 player1:
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01111110
	 %01111110
	 %01111110
	 %01111110
	 %01111110
end

	 goto __Pu_Frame_Done

__Pu02

	 player1:
	 %00000000
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01111110
	 %01111110
	 %01111110
	 %01111110
	 %01111110
end

	 goto __Pu_Frame_Done
	 
__Pu03
	 player1:
	 %00000000
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01111110
	 %01111110
	 %01111110
	 %01111110
	 %01111110
end

	 goto __Pu_Frame_Done

 return
       ;***************************************************************
      ; Right screen
      ;
__Lvl_3
	  PuppetY = 57 : PuppetX = 18 : player0x = 200 : player0y = 200 
      pfclear
      playfieldpos = 8
      COLUBK = $02
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $04
end


 playfield:
 ........X...................XXXX
 ........X...................XXXX
 ........X...................XXXX
 XXXXXXXXX...................XXXX
 ............................XXXX
 ............................XXXX
 ............................XXXX
 ............................XXXX
 XXXXXXXXX...................XXXX
 ........X...................XXXX
 ........X...................XXXX
 ........X...................XXXX
end
	  drawscreen
	  return

      bank 4
_P_D
      ;******************************************************************
      ;     The puppet moving downwards.
      ;

	  player1color:
	  $00
      $00
      $0e
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
end

      on _Frame_Counter goto __Pd00 __Pd01 __Pd02 __Pd03

__Pd_Frame_Done
	  return
	  
__Pd00

	 player1:
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01100110
	 %01100110
	 %01011010
	 %00011000
	 %01111110
end

     goto __Pd_Frame_Done
     
__Pd01
	 player1:
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01100110
	 %01100110
	 %01011010
	 %00011000
	 %01111110
end
     goto __Pd_Frame_Done
     
__Pd02

	 player1:
	 %00000000
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01100110
	 %01100110
	 %01011010
	 %00011000
	 %01111110
end
     goto __Pd_Frame_Done
     
__Pd03

	 player1:
	 %00000000
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %01000010
	 %00100100
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %10011001
	 %01011010
	 %00111100
	 %00011000
	 %00111100
	 %01100110
	 %01100110
	 %01011010
	 %00011000
	 %01111110
end
     goto __Pd_Frame_Done

__Lvl_4
	  PuppetY = 60 : PuppetX = 136 : player0x = 200 : player0y = 200
      pfclear
      playfieldpos = 8
      COLUBK = $02
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $04
end


 playfield:
 XXXX...................X........ 
 XXXX...................X........ 
 XXXX...................X........ 
 XXXX...................XXXXXXXXX 
 XXXX............................ 
 XXXX............................ 
 XXXX............................ 
 XXXX............................ 
 XXXX...................XXXXXXXXX 
 XXXX...................X........ 
 XXXX...................X........ 
 XXXX...................X........ 
end
	  drawscreen 
	  return


     bank 5
_P_R     
	  ;*********************************************************************
	  ;  The puppet right moving sprite.
	  ;
	  player1color:
	  $00
      $00
      $0e
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
end
      on _Frame_Counter goto __Pr00 __Pr01 __Pr02 __Pr03

__Pr_Frame_Done
	  return
    
__Pr00	  
	  player1:
	  %10100000
	  %10010000
	  %01001000
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %01111100
	  %01110100
	  %01111100
	  %01110101
	  %01111110
	  %01110100
	  %00111100
	  %00011100
	  %00111100
	  %01110010
	  %01110010
	  %01101100
	  %01001000
	  %00111110
end
  goto __Pr_Frame_Done
  
__Pr01	  
	  player1:
	  %10100000
	  %10010000
	  %01001000
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %01111100
	  %01110100
	  %01111100
	  %01110101
	  %01111110
	  %01110100
	  %00111100
	  %00011100
	  %00111100
	  %01110010
	  %01110010
	  %01101100
	  %01001000
	  %00111110
end
  goto __Pr_Frame_Done  

__Pr02	  
	  player1:
	  %00000000
	  %10100000
	  %10010000
	  %01001000
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %01111100
	  %01110100
	  %01111100
	  %01110101
	  %01111110
	  %01110100
	  %00111100
	  %00011100
	  %00111100
	  %01110010
	  %01110010
	  %01101100
	  %01001000
	  %00111110
end
  goto __Pr_Frame_Done  

__Pr03	  
	  player1:
	  %00000000
	  %10100000
	  %10010000
	  %01001000
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %01111100
	  %01110100
	  %01111100
	  %01110101
	  %01111110
	  %01110100
	  %00111100
	  %00011100
	  %00111100
	  %01110010
	  %01110010
	  %01101100
	  %01001000
	  %00111110
end
  goto __Pr_Frame_Done    
  
      return
__Lvl_5
	  PuppetY = 87 : PuppetX = 80 : player0x = 200 : player0y = 200 : _Bit1_Up_Screen = 0
      pfclear
      playfieldpos = 8
      COLUBK = $02
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $04
end


 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXX.......XXXXXXXXXXXX
 ............X.......X...........
 ............X.......X...........
 ............X.......X...........
end
	  drawscreen
	  if _Bit1_Up_Screen = 0 && PuppetY = 87 : PuppetX = 82 then _Bit0_Main_Screen = 1 
	  return      

      
      bank 6
_P_L
	  ;***************************************************************
      ;
      ;  The puppet left move animation.
      ;
      
	  player1color:
	  $00
      $00
      $0e
      $00
      $0e
      $00
      $0e
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $00
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
      $0e
end

      on _Frame_Counter goto __Pl00 __Pl01 __Pl02 __Pl03

__Pl_Frame_Done
	  return

__Pl00	  
	  player1:
	  %00000101
	  %00001001
	  %00010010
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00111110
	  %00101110
	  %00111110
	  %10101110
	  %01111110
	  %00101110
	  %00111100
	  %00111000
	  %00111100
	  %01001110
	  %01001110
	  %00110110
	  %00010010
	  %01111100
end
   goto __Pl_Frame_Done
   
__Pl01	 
	  player1:
	  %00000101
	  %00001001
	  %00010010
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00111110
	  %00101110
	  %00111110
	  %10101110
	  %01111110
	  %00101110
	  %00111100
	  %00111000
	  %00111100
	  %01001110
	  %01001110
	  %00110110
	  %00010010
	  %01111100
end
   goto __Pl_Frame_Done   
   
__Pl02	  
	  player1:
	  %00000000
	  %00000101
	  %00001001
	  %00010010
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00111110
	  %00101110
	  %00111110
	  %10101110
	  %01111110
	  %00101110
	  %00111100
	  %00111000
	  %00111100
	  %01001110
	  %01001110
	  %00110110
	  %00010010
	  %01111100
end
   goto __Pl_Frame_Done
   
__Pl03
	  player1:
	  %00000000
	  %00000101
	  %00001001
	  %00010010
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00100100
	  %00111110
	  %00101110
	  %00111110
	  %10101110
	  %01111110
	  %00101110
	  %00111100
	  %00111000
	  %00111100
	  %01001110
	  %01001110
	  %00110110
	  %00010010
	  %01111100
end
   goto __Pl_Frame_Done   
   
   return
   
   bank 7 
__Semi_Main_Screen

	  PuppetY = 80 : PuppetX = 77 : player0y = 200 : player0x = 200
      pfcolors:
      $00
      $04
      $06
      $08
      $0A
      $0C
      $0E
      $0C
      $0A
      $08
      $06
      $04
      $00
end


        playfield:
        XXXXXX....................XXXXXX
        XXXXXX....................XXXXXX
        XXX..........................XXX
        ................................
        ................................
        ................................
        ................................
        ................................
        ................................
        XXX..........................XXX
        XXXXXX....................XXXXXX
        XXXXXX....................XXXXXX
end
   drawscreen
   if PuppetY = 25 then _Bit0_Coord_Y_Up = 2 : _Bit1_Up_Screen = 1
   return
   
; todo implement def instead of this many bitsw for variables, if you forget
;		  how does def works check randomterrain!