      ;****************************************************************
      ;
      ;  E.T.'s Revenge
      ;  (C) STGraves 2015
      ;  Stop E.T. from conquering the world.
      ;  wwww.stgravesof.zz.vc
      ;
      ;***************************************************************


      ;***************************************************************
      ;
      ;  Kernel options.
      ; 
      set kernel_options player1colors pfcolors no_blank_lines
      set romsize 32k
      set tv ntsc
	  set optimization inlinerand

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
      ;                 Variable for color cicle
      ;
      ;
      dim bmp_48x1_1_color = j
      dim _Animation = k
      ;``````````````````````````````````````````````````````````````
      ;            Next level screen variables
      ;
      dim _Level_Timer = l
      dim _Player_Data = m
      dim _Momentun_LR = n      
      ;``````````````````````````````````````````````````````````````
      ;    Player data flags
      ;
      ; 0 - Player Facing Direction (0-right 1-left)
      ; 3 - Sprite Super Mario
      ; 6 - Specific sprite data for something I don't remember
      
      ;```````````````````````````````````````````````````````````````
      ;              _Mytemp03 variable for the PF collision
      ;
      dim _MyTemp03 = o

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
      player1y = 200 : player0y = 200 : bally = 250


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

      bmp_48x1_1_color = bmp_48x1_1_color + 1


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

      playfieldpos = 8   
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
      ;  Starting position of player0 (Thomas).
      ;
      player1x = 74 : player1y = 78


      ;***************************************************************
      ;
      ;  Starting position of player0 (E.T.).
      ;
      player0x = (rand/2) + (rand&15) : player0y = 0 


      ;***************************************************************
      ;
      ;  Defines ball height and location.
      ;
      ballheight = 4 : bally = 78


      ;***************************************************************
      ;
      ;  Sets background color.
      ;
      COLUBK = $F0


      ;***************************************************************
      ;
      ;  Sets score and score color.
      ;
      score = 0 : scorecolor = $1E


      ;***************************************************************
      ;
      ;  Sets number of lives and sets color.
      ;
      pfscore1 = %11111111 : pfscorecolor = $AE



      ;***************************************************************
      ;
      ;  Sets playfield colors.
      ;      
      pfcolors:
      $50
      $52
      $56
      $58
      $5A
      $5C
      $5E
      $6C
      $6A
      $68
      $66
      $62
      $60
end


      ;***************************************************************
      ;
      ;  Sets up the main loop playfield.
      ;

        playfield:
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
        ................................
        ................................
        ................................
        ................................
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
        XXXXXXXXXXX.........XXXXXXXXXXXX
end





      ;***************************************************************
      ;***************************************************************
      ;
      ;  MAIN LOOP (MAKES THE GAME GO)
      ;
      ;

      playfieldpos = 8 
      CTRLPF = $31
      ballheight = 8

__Main_Loop


      ;***************************************************************
      ;
      ;  Sets E.T. sprite color.
      ;
      COLUP0 = $DC


      ;***************************************************************
      ;
      ;  Makes ball a little wider.
      ;
      NUSIZ0 = $35



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




      ;**************************************************************
      ;    mario static sprite
      ;
      player1color:
      $26
      $26
      $44
      $44
      $2A
      $2A
      $26
      $44
      $26
      $2A
      $2A
      $2A
      $2A
      $2A
      $44
      $44
end

      player1:
      %11100111
      %01100110
      %01100110
      %00111100
      %11011011
      %10100101
      %11011011
      %11011011
      %01011010
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end


      



      ;***************************************************************
      ;
      ;  E.T animation (4 frames, 0 through 3).
      ;
      on _Frame_Counter goto __ET00 __ET01 __ET02 __ET03

__ET_Frame_Done






      ;***************************************************************
      ;
      ;  ball check and fire button check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If ball is off the screen, jump to fire button check.
      ;
      if bally > 240 then goto __FireB_Check

      ;```````````````````````````````````````````````````````````````
      ;  Moves ball and skips fire button check.
      ;
      bally = bally - 2 : goto __Skip_FireB

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
      ;  Starts the firing of ball.
      ;
      bally = player1y - 16 : ballx = player1x + 4

__Skip_FireB


      ;***************************************************************
	  ;
      ;  Joy0 up check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved up, skip this subsection.
      ;
      if !joy0up then goto __Skip_Joy0_Up &&  __Clear_Channel_0
      gosub _mario_up bank3 
      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x left side coordinate to pf coordinate.
      ;
      _MyTemp01 = ((player1x-15)/4)

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x right side coordinate to pf coordinate.
      ;
      temp5 = (((player1x)-15)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = (((player1y+6)-player1height)/8)-1

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
      player1y = player1y - 1

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
      if player1x > _MyTemp02 then player1x = player1x - 1 : goto __Skip_Joy0_Up

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite right if collision happened on the right side
      ;      of the playfield pixel.
      ;
      player1x = player1x + 1

__Skip_Joy0_Up

      ;***************************************************************
      ;
      ;  Joy0 down check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved down, skip this subsection.
      ;
      if !joy0down then goto __Skip_Joy0_Down
      gosub _mario_down bank4     
      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x left side coordinate to pf coordinate.
      ;
      _MyTemp01 = ((player1x-15)/4)

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x right side coordinate to pf coordinate.
      ;
      temp5 = (((player1x)-15)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = ((player1y-7)/8)+1

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
      player1y = player1y + 1

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
      if player1x > _MyTemp02 then player1x = player1x - 1 : goto __Skip_Joy0_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite right if collision happened on the right side
      ;      of the playfield pixel.
      ;
      player1x = player1x + 1

__Skip_Joy0_Down

      ;***************************************************************
      ;
      ;  Joy0 left check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick not moved to the left, skip this subsection.
      ;
      if !joy0left then goto __Skip_Joy0_Left
      gosub _M_L bank6
      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite x coordinate to playfield coordinate.
      ;
      temp5 = ((player1x-14)/4)-1

      ;```````````````````````````````````````````````````````````````
      ;  Converts sprite y coordinate to playfield coordinate.
      ;
      temp6 = (player1y-1)/8

      ;```````````````````````````````````````````````````````````````
      ;  Sets up variables for the for-next loop.
      ;
      _MyTemp01 = ((player1y-(player1height+1)))/8
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
      player1x = player1x - 1

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
      if player1y > _MyTemp02 then goto __Left_Move_Down

      player1y = player1y - 1

      _MyTemp02 = ((player1y-(player1height+1)))/8

      if pfread(temp5,_MyTemp02) then player1y = player1y + 1

      goto __Skip_Joy0_Left

__Left_Move_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite down if collision happened on the bottom side
      ;      of the playfield pixel.
      ;
      player1y = player1y + 1

__Skip_Joy0_Left

      ;***************************************************************
      ;
      ;  Joy0 right check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  If joystick isn't moved to the right, skip this subsection.
      ;
      if !joy0right then goto __Skip_Joy0_Right
      gosub _M_R bank5
      ;```````````````````````````````````````````````````````````````
      ;  Converts player1x coordinate to playfield coordinate.
      ;
      temp5 = (((player1x)-13)/4)+1

      ;```````````````````````````````````````````````````````````````
      ;  Converts player1y coordinate to playfield coordinate.
      ;
      temp6 = (player1y-1)/8

      ;```````````````````````````````````````````````````````````````
      ;  Sets up variables for the for-next loop.
      ;
      _MyTemp01 = ((player1y-(player1height+1)))/8
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
      ;  Moves player1 sprite to the left.
      ;
      player1x = player1x + 1 

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
      if player1y > _MyTemp02 then goto __Right_Move_Down

      player1y = player1y - 1

      _MyTemp02 = ((player1y-(player1height+1)))/8

      if pfread(temp5,_MyTemp02) then player1y = player1y + 1

      goto __Skip_Joy0_Right

__Right_Move_Down

      ;```````````````````````````````````````````````````````````````
      ;  Moves sprite down if collision happened on the bottom side
      ;      of the playfield pixel.
      ;
      player1y = player1y + 1
      

__Skip_Joy0_Right

	  ;```````````````````````````````````````````````````````````````
	  ;             start the transition and go to the next screen.
	  ;
	  if player1x = 17 then goto _L_Screen
	  goto __Skip_Col
__Skip_Col	  





      ;***************************************************************
      ;
      ;  Sets the width of sprite0.
      ;
      NUSIZ1 = $10

      ;***************************************************************
      ;
      ;  Keeps player1 within screen borders.
      ;
      if player1x < 3 then player1x = 3
      if player1x > 150 then player1x = 150
      if player1y < 20 then player1y = 20
      if player1y > 84 then player1y = 84



      ;***************************************************************
      ;
      ;  E.T. chases the player.
      ;
      if player0y < player1y then player0y = player0y + 1
      if player0y > player1y then player0y = player0y - 1
      if player0x < player1x then player0x = player0x + 1
      if player0x > player1x then player0x = player0x - 1



	  ;***************************************************************
      ;
      ;  E.T./ball collision check.
      ;
      if !collision(ball,player0) then goto __Skip_ET_Kill

      ;```````````````````````````````````````````````````````````````
      ;  Adds 1 to the score.
      ;
      score = score + 1
                        
      ;````````````````````````````````````````````````````````````````
      ;      Checks the current score and if it is 15 redirects to
      ;      "win screen"
      ;
__Check_Score
      if s1 = $00 && s2 = $00 && s3 = $15 then goto _Next_Level_Screen
      goto __Skip_Check
__Skip_Check



      ;```````````````````````````````````````````````````````````````
      ;  Sound effect 1 setup.
      ;
      if _Sound0 then goto __Skip_Sound0_Setup

      _Sound0 = 1 : _SoundCounter0 = 10

      _C0 = 4 : _V0 = 12 : _F0 = 14

      temp5 = 255 : if player0y < player1y then temp5 = player1y - player0y

      if temp5 < 30 then _C0 = 12 ; Makes a different sound when closer to player.

__Skip_Sound0_Setup

      ;```````````````````````````````````````````````````````````````
      ;  Moves E.T. to new location and removes missile.
      ;
      player0x = (rand/2) + (rand&15) : player0y = 0 : bally = 250

__Skip_ET_Kill



      ;***************************************************************
      ;
      ;  E.T./Thomas collision check.
      ;
      ;```````````````````````````````````````````````````````````````
      ;  if no collision between sprites, skip this subsection.
      ;
      if !collision(player0,player1) then goto __Skip_Players_Touch

      ;```````````````````````````````````````````````````````````````
      ;  Subtracts 1 from the score.
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
      ;  Moves E.T. to new location and removes missile.
      ;
      player0x = (rand/2) + (rand&15) : player0y = 0 : bally = 250

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
      ;  E.T. touches Thomas sound.
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
      ; left screen
      ;
_L_Screen

      player0x = 200 : player0y = 200 : player1x = 135 : player1y = 55
      pfclear
      playfieldpos = 8
      COLUBK = $00
      pfcolors:
      $70
      $72
      $74
      $76
      $78
      $7A
      $7C
      $7E
      $8E
      $8C
      $8A
      $88
      $86
end

      playfield:
      .X....X.........................
      .X....X.........................
      XX....XXXXXXXXXXXXXXXXXXXXXXXXXX
      ...............................X
      ...............................X
      ...............................X
      ...............................X
      ...............................X
      XX....XXXXXXXXXXXXXXXXXXXXXXXXXX
      .X....X.........................
      .X....X.........................
end
      goto __Main_Loop
	  if player1x = 134 then goto __Main_Loop_Setup
	  goto _L_Screen
	  drawscreen
	  


      ;***************************************************************
      ;
      ;  E.T. animation frames.
      ;
__ET00
      player0:
      %01110000
      %00110111
      %00011111
      %10011111
      %11111111
      %00011111
      %00001111
      %00000011
      %11000011
      %11111111
      %10111111
      %11111100
end
      goto __ET_Frame_Done


__ET01
      player0:
      %01110000
      %00110111
      %00011111
      %10011111
      %11111111
      %00011111
      %00001111
      %00000011
      %00000011
      %00000011
      %11000011
      %11111111
      %10111111
      %11111100
end
      goto __ET_Frame_Done


__ET02
      player0:
      %00000111
      %01110011
      %00011111
      %10011111
      %11111111
      %00011111
      %00001111
      %00000011
      %00000011
      %00000011
      %00000011
      %00000011
      %11000011
      %11111111
      %10111111
      %11111100
end
      goto __ET_Frame_Done



__ET03
      player0:
      %00000111
      %01110011
      %00011111
      %10011111
      %11111111
      %00011111
      %00001111
      %00000011
      %00000011
      %00000011
      %11000011
      %11111111
      %10111111
      %11111100
end
      goto __ET_Frame_Done





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
      player0y = 200 : player1y = 200 : bally = 200


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
      COLUBK = $6E


      ;***************************************************************
      ;
      ;  Sets up GAME OVER playfield.
      ;
      playfield:
      XXX..XXX.....XX...XX..XX.XX.XXX.
      X.....X.....X..X.X..X.X.X.X.X...
      XX....X.....X....XXXX.X...X.XX..
      X.....X.....X..X.X..X.X...X.X...
      XXX.X.X.X....XX..X..X.X...X.XXX.
      ................................
      XXX...XX...XX..X..X..X.X.X......
      X..X.X..X.X..X.X.X...X.X.X......
      XXX..XXXX.X....XX....X.X.X......
      X..X.X..X.X..X.X.X..............
      XXX..X..X..XX..X..X..X.X.X......
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
      $80
      $82
      $84
      $86
      $88
      $8A
      $8C
      $8E
      $8C
      $8A
      $88
      $86
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

      ;***************************************************************
      ;
      ;               next level screen screen.
      ;
      pfclear
      playfieldpos=8   
_Next_Level_Screen
      bally = 200 : ballx = 200 : player0x = 200 : player0y = 200 : player1x = 18 : player1y = 71
      COLUBK = $00
      pfcolors:
      $C4
      $C4
      $C4
      $C4
      $C4
      $C4
      $C4
      $C4
      $C4
      $C4
      $24
      $00
end
      playfield:
      ............................XXXX
      ............................XXXX
      ............................XXXX
      ............................XXXX
      ............................XXXX
      ............................XXXX
      .........................X..XXXX
      .........................XXXXXXX
      .........................XXXXXXX
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

S2
      _Animation = _Animation + 1 
      if _Animation > 6 then _Animation = 0 : _Level_Timer = _Level_Timer + 1
      _Level_Timer = 0 : player1y = 76
      if _Player_Data{0} then player1x = player1x - 1 else player1x = player1x + 1
      if player1x < 17 then player1x = 17 : player1y = 76 : _Player_Data{0} = 0
      if player1x > 135 then player1x = 135 : player1y = 76 : _Player_Data{0} = 1
S3
      ballx = 200 : player0x = 200 : player0y = 200 : player1y = 71 : _Animation = 0 : _Level_Timer = 0 : _Player_Data{6} = 0 : _Player_Data{0} = 0 : _Momentun_LR = 2
      CTRLPF=$15
      if _Player_Data{0} then REFP1 = 8
      drawscreen
      if player1x = 135 then goto __Title_Screen_Loop
      goto S2
      _Player_Data{6} = 1 : _Player_Data{3} = 0 : _Player_Data{0} = 0      
      return 

        
      ;**************************************************************
      ;                 Bank 2
      ;
      bank 2
      asm
      include "titlescreen/asm/titlescreen.asm"
end

      bank 3
_mario_up
      player1color:
      $26
      $26
      $44
      $44
      $2A
      $2A
      $26
      $44
      $26
      $2A
      $2A
      $2A
      $2A
      $2A
      $44
      $44
end
      on _Frame_Counter goto __Mup00 __Mup01 __Mup02 __Mup03

__Mup_Frame_Done
	  return

__Mup00

      player1:
      %11100000
      %01100111
      %00100100
      %00111100
      %10000001
      %10111101
      %11111111
      %11111111
      %11111111
      %01111110
      %00011000
      %00111100
      %01111110
      %00111100
      %01111110
      %00111100
      
end
      goto __Mup_Frame_Done
      
__Mup01
	 player1:
	 %11100111
	 %01100110
	 %00100100
	 %00111100
	 %10000001
	 %10111101
	 %11111111
	 %11111111
	 %11111111
	 %01111110
	 %00011000
	 %00111100
	 %01111110
	 %00111100
	 %01111110
	 %00111100
	 
end
     goto __Mup_Frame_Done
     
__Mup02
     player1:
	 %00000111
	 %11100110
	 %00100100
	 %00111100
	 %10000001
	 %10111101
	 %11111111
	 %11111111
	 %11111111
	 %01111110
	 %00011000
	 %00111100
	 %01111110
	 %00111100
	 %01111110
	 %00111100
end	 
    goto __Mup_Frame_Done

__Mup03
	 player1:
	 %11100111
	 %01100110
	 %00100100
	 %00111100
	 %10000001
	 %10111101
	 %11111111
	 %11111111
	 %11111111
	 %01111110
	 %00011000
	 %00111100
	 %01111110
	 %00111100
	 %01111110
	 %00111100
end
    goto __Mup_Frame_Done

                        
      bank 4
_mario_down

      player1color:
      $26
      $26
      $44
      $44
      $2A
      $2A
      $26
      $44
      $26
      $2A
      $2A
      $22
      $2A
      $2A
      $44
      $44
end

      on _Frame_Counter goto __Md00 __Md01 __Md02 __Md03

__Md_Frame_Done
	  return
	  
__Md00

	 player1:
	 %11100111
	 %01100110
	 %00100100
	 %00111100
     %11011011
     %10100101
     %11011011
     %11011011
     %01011010
	 %00011000
	 %00100100
	 %00111100
	 %01011010
	 %00111100
	 %01111110
	 %00111100
end

     goto __Md_Frame_Done
     
__Md01
	 player1:
	 %11100000
	 %01100111
	 %00100100
	 %00111100
     %11011011
     %10100101
     %11011011
     %11011011
     %01011010
	 %00011000
	 %00100100
	 %00111100
	 %01111110
	 %00111100
	 %01111110
	 %00111100
end
     goto __Md_Frame_Done
     
__Md02

	 player1:
	 %11100111
	 %01100110
	 %00100100
	 %00111100
     %11011011
     %10100101
     %11011011
     %11011011
     %01011010
	 %00011000
	 %00100100
	 %00111100
	 %01011010
	 %00111100
	 %01111110
	 %00111100
end
     goto __Md_Frame_Done
     
__Md03

	 player1:
	 %00000111
	 %11100110
	 %00100100
	 %00111100
     %11011011
     %10100101
     %11011011
     %11011011
     %01011010
	 %00011000
	 %00100100
	 %00111100
	 %01011010
	 %00111100
	 %01111110
	 %00111100
end
     goto __Md_Frame_Done


     bank 5
_M_R     
      player1color:
      $26
      $26
      $44
      $44
      $2A
      $2A
      $26
      $44
      $26
      $2A
      $2A
      $2A
      $2A
      $2A
      $44
      $44
end
	  ;***************************************************************
      ;
      ;  Mario right move animation.
      ;
      on _Frame_Counter goto __Thom00 __Thom01 __Thom02 __Thom03

__Thomas_Frame_Done1
   return
   
__Thom00
      player1:
      %11100111
      %01100110
      %01100110
      %00111100
      %11011011
      %10100101
      %11011011
      %11011011
      %01011010
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Thomas_Frame_Done1


__Thom01
      player1:
      %01100000
      %11000000
      %01100011
      %00001111
      %11011101
      %11001010
      %11100100
      %01110101
      %00101011
      %00011101
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Thomas_Frame_Done1


__Thom02
      player1:
      %00000111
      %10000110
      %11110110
      %11111010
      %00111100
      %00111110
      %01001111
      %01010011
      %00101100
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Thomas_Frame_Done1



__Thom03
      player1:
      %00011000
      %00110010
      %00110100
      %00101110
      %01110011
      %01101101
      %01011100
      %01011010
      %00111010
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Thomas_Frame_Done1
      return 
      
      bank 6
_M_L     
      player1color:
      $26
      $26
      $44
      $44
      $2A
      $2A
      $26
      $44
      $26
      $2A
      $2A
      $2A
      $2A
      $2A
      $44
      $44
end
	  ;***************************************************************
      ;
      ;  Mario lefty move animation.
      ;
      REFP1 = 8
      on _Frame_Counter goto __Tum00 __Tum01 __Tum02 __Tum03

__Tum_Frame_Done
   return
   
__Tum00
      player1:
      %11100111
      %01100110
      %01100110
      %00111100
      %11011011
      %10100101
      %11011011
      %11011011
      %01011010
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Tum_Frame_Done


__Tum01
      player1:
      %01100000
      %11000000
      %01100011
      %00001111
      %11011101
      %11001010
      %11100100
      %01110101
      %00101011
      %00011101
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Tum_Frame_Done


__Tum02
      player1:
      %00000111
      %10000110
      %11110110
      %11111010
      %00111100
      %00111110
      %01001111
      %01010011
      %00101100
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Tum_Frame_Done



__Tum03
      player1:
      %00011000
      %00110010
      %00110100
      %00101110
      %01110011
      %01101101
      %01011100
      %01011010
      %00111010
      %00011100
      %00110000
      %01111011
      %01010110
      %00010100
      %01111111
      %00111100
end
      goto __Tum_Frame_Done
   return      
