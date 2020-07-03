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
   ;  Multicolored playfield and no blank lines.
   ;  Cost: loss of missile0.
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
   ;  If you use different aliases for bit operations,
   ;  it's easier to understand and remember what they do.
   ;
   ;  I start variable aliases with one underscore so I won't
   ;  have to worry that I might be using bB keywords by mistake.
   ;  I also start labels with two underscores for the same
   ;  reason. The second underscore also makes labels stand out 
   ;  so I can tell at a glance that they are labels and not
   ;  variables.
   ;
   ;  Use bit operations any time you need a simple off/on
   ;  variable. One variable essentially becomes 8 smaller
   ;  variables when you use bit operations.
   ;
   ;  I start my bit aliases with "_Bit" then follow that
   ;  with the bit number from 0 to 7, then another underscore
   ;  and the name. Example: _Bit0_Reset_Restrainer 
   ;
   ;```````````````````````````````````````````````````````````````
   ;  _Master_Counter can be used for many things, but it is 
   ;  really useful for animating sprite frames when used
   ;  with _Frame_Counter.
   ;
   dim genesispad=a
   dim _Master_Counter = e
   dim _Frame_Counter = f
   ;```````````````````````````````````````````````````````````````
   ;
   ;       screen and coordinate counter for the animation.
   ;

   dim _Bitop_Screen_Counter = p
   dim _Bitop_Coord_Counter = q

   
   ;```````````````````````````````````````````````````````````````
   ;  Channel 0 sound variables.
   ;
   dim _Ch0_Sound = b
   dim _Ch0_Duration = c
   dim _Ch0_Counter = d

   ;```````````````````````````````````````````````````````````````
   ;  Channel 1 sound variables.
   ;
   dim _Ch1_Duration = m

   ;```````````````````````````````````````````````````````````````
   ;     AI attempt counter variable.
   ;
   dim _Will_Aftn_AI = n

   ;```````````````````````````````````````````````````````````````
   ;          Kill counter.
   ;

   dim _Kill_Count = o

   ;```````````````````````````````````````````````````````````````
   ;  Player0/ball direction bits.
   ;
   dim _BitOp_P0_M1_Dir = g
   dim _Bit0_P0_Dir_Up = g
   dim _Bit1_P0_Dir_Down = g
   dim _Bit2_P0_Dir_Left = g
   dim _Bit3_P0_Dir_Right = g
   dim _Bit4_M1_Dir_Up = g
   dim _Bit5_M1_Dir_Down = g
   dim _Bit6_M1_Dir_Left = g
   dim _Bit7_M1_Dir_Right = g
   
   
   ;```````````````````````````````````````````````````````````````
   ;
   ;
   dim _Main_CharX = player1x
   dim _Main_CharY = player1y
   
   dim _WillX = player0x
   dim _WillY = player0y

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play sprite direction.
   ;  0 = up, 1 = up/right, 2 = right, 3 = down/right, 4 = down,
   ;  5 = down/left, 6 = left, 7 = up/left.
   ;
   dim _T5_AP_Dir = temp5

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the opposite direction the sprite moved during
   ;  auto-play. Keeps the sprite from bouncing back and forth
   ;  between the same two directions like a ping-pong ball.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _AP_Mem_Dir = h

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Counter_Tmp = h

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the last position of the sprite during auto-play.
   ;  A new direction is chosen if the sprite stops moving.
   ;  These variables can be reused if you're sure it won't
   ;  interfere with auto-play.
   ;
   dim _AP_Mem_P0x = i
   dim _AP_Mem_P0y = j

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used for auto-play in the main loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _AP_2_Sec_Score_Flip = k

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Mem_Color_Tmp = k

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used for auto-play in the main loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _AP_Dir_Counter = l

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Color_Tmp = l

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _BitOp_02 = r

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the position of the BW switch.
   ;
   dim _Bit0_BW_Mem = r

   ;```````````````````````````````````````````````````````````````
   ;  Checks to see if the BW switch has moved.
   ;
   dim _Bit1_BW_Check = r

   ;```````````````````````````````````````````````````````````````
   ;  Lets pause section know if the B color scheme should be used.
   ;
   dim _Bit2_Pause_Clr_Scheme = r

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  These can be used for other things using different aliases,
   ;  but for the game over loop and auto-play in the main loop,
   ;  they are used to temporarily remember the score for the 2
   ;  second score/high score flip.
   ;
   dim _Score1_Mem = s
   dim _Score2_Mem = t
   dim _Score3_Mem = u

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the high score until the game is turned off.
   ;
   dim _High_Score1 = v
   dim _High_Score2 = w
   dim _High_Score3 = x

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Game_Control = y
   dim _Bit3_Auto_Play = y
   dim _Bit6_Swap_Scores = y
   dim _Bit7_M1_Moving = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers. 
   ;
   dim rand16 = z

   ;```````````````````````````````````````````````````````````````
   ;  Converts 6 digit score to 3 sets of two digits.
   ;
   ;  The 100 thousands and 10 thousands digits are held by _sc1.
   ;  The thousands and hundreds digits are held by _sc2.
   ;  The tens and ones digits are held by _sc3.
   ;
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2



    ;```````````````````````````````````````````````````````````````
    ;      Ball variable naming
    ;


    dim _Lost_Soul_X = ballx
    dim _Lost_Soul_Y = bally

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
   
   
   const pfscore=1





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PROGRAM START/RESTART
   ;
   ;
__Start_Restart


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
   ;  Clears 7 of the 8 bits.
   ;
   ;  Bit 2 is not cleared because _Bit2_Game_Control{2} is used
   ;  to control how the program is reset.
   ;
   _BitOp_01 = _BitOp_01 & %00000100


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   _Main_CharY = 200 : _WillY = 200 : _Lost_Soul_Y = 200
   
   ;***************************************************************
   ;
   ;   Genesis controller detection.
   ;
genesisdetect
   genesispad=genesispad & $fe
   if INPT1{7} then genesispad=genesispad | 1
   if genesispad{0} then COLUBK=$8a
   if !genesispad{0} then COLUBK=$48

   ;***************************************************************
   ;
   ;  Skips title screen if game has been played and player
   ;  presses fire button or reset switch at the end of the game.
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   if _Bit2_Game_Control{2} then goto __Main_Loop_Setup bank2





   ;***************************************************************
   ;***************************************************************
   ;
   ;   TITLE SCREEN SETUP
   ;
   ;
__Title_Screen_Setup

   ;***************************************************************
   ;   pfscore bars initialize.
   ;
   pfscore1 = 0 : pfscore2 = 0 : scorecolor = 0


   ;***************************************************************
   ;
   ;  Sets title screen background color.
   ;
   COLUBK = 0


   ;***************************************************************
   ;
   ;  Restrains the reset switch.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after entering a different segment
   ;  of the program. It also does double duty by restraining the
   ;  fire button in the title screen loop.
   ;
   _Bit0_Reset_Restrainer{0} = 1
   
   
   playfieldpos = 8





   ;***************************************************************
   ;***************************************************************
   ;
   ;  TITLE SCREEN LOOP
   ;
   ;
__Title_Screen_Loop



   ;***************************************************************
   ;
   ;  Sets title screen playfield pixel colors.
   ;
   gosub titledrawscreen bank4



   ;***************************************************************
   ;
   ;  Auto-play check.
   ;
   ;  Switches to auto-play after 10 seconds if player doesn't
   ;  start the game.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increment _Master_Counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if counter is less than one second.
   ;
   if _Master_Counter < 30 then goto __TS_AP_Skip

   ;```````````````````````````````````````````````````````````````
   ;  Increments _Frame_Counter and clears _Master_Counter.
   ;
   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check.
   ;
   ;  Turns on auto-play and jumps to main loop setup if 10 
   ;  seconds have gone by.
   ;
   if _Frame_Counter > 9 then _Bit3_Auto_Play{3} = 1 : goto __Main_Loop_Setup bank2

__TS_AP_Skip



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Reset/fire button check and end of title screen loop.
   ;  
   ;  Starts the game if the reset switch or the fire button
   ;  is pressed appropriately.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears the restrainer bit and jumps to beginning of title 
   ;  screen loop if fire button or reset switch is not pressed.
   ;
   if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Title_Screen_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of title screen loop if reset or fire 
   ;  hasn't been released since starting title screen loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Title_Screen_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Sets control bit so program will jump to main loop setup.
   ;
   _Bit2_Game_Control{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Restarts game and program jumps to main loop setup.
   ;
   goto __Start_Restart


   bank 2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP
   ;
   ;
__Main_Loop_Setup


   ;***************************************************************
   ;
   ;  In the main loop, _Bit2_Game_Control{2} controls when the
   ;  game ends.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit2_Game_Control{2} = 0



   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed in the title
   ;  screen section or the game over section. If the reset
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
   ;  screen section or the game over section. If the fire
   ;  button isn't being held down, this bit will be cleared
   ;  in the main loop.
   ;
   _Bit1_FireB_Restrainer{1} = 1


   ;***************************************************************
   ;
   ;  Starting position of player0.
   ;
   _Main_CharX = 77 : _Main_CharY = 53


   ;***************************************************************
   ;
   ;  Sets score color.
   ;
   scorecolor = $1C
   
   ;***************************************************************
   ;   sets the number of lives and energy and the color.
   ;
   
   pfscore1 = %10101010 : pfscore2 = %11111111 : pfscorecolor = $06
   ;pfscore1 (lives) decimal values vidas
   ;10101010 (four lives) 170
   ;10101000 (three lives) = 168
   ;10100000 (two lives) = 160
   ;10000000 (one life) = 128

   ;pfscore2 (health) decimal values energia
   ;11111111 (full health) = 255
   ;11111110 = 254
   ;11111100 = 252
   ;11111000 = 248
   ;11110000 = 240
   ;11100000 = 224
   ;11000000 = 192
   ;10000000 = 128

   ;***************************************************************
   ;
   ;  Defines ball height.
   ;
   missile1height = 1


   ;***************************************************************
   ;
   ;  Sets beginning direction that ball will shoot if the
   ;  player doesn't move.
   ;
   _Bit3_P0_Dir_Right{3} = 1


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
   ;  Defines shape of player0 sprite.
   ;
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
   ;  Sets starting position of enemy.
   ;
   _WillY = (rand&63) + 15 : temp5 = rand

   if temp5 > 128 then _WillX = (rand&127) + (rand/16) : goto __Skip_Enemy_Setup

   _WillX = (rand&127) + (rand/16)

__Skip_Enemy_Setup



   ;***************************************************************
   ;
   ;  Remembers position of COLOR/BW switch.
   ;
   _Bit0_BW_Mem{0} = 0 : if switchbw then _Bit0_BW_Mem{0} = 1


   ;***************************************************************
   ;
   ;  Auto-play score swap setup.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears score and skips section if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then score = 0 : goto __AP_Skip_AP_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Sets up the score swap and clears the swap bit.
   ;
   _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3

   _Bit6_Swap_Scores{6} = 0

__AP_Skip_AP_Setup







   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE GAME GO)
   ;
   ;
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
   ;  Sets background color.
   ;
   COLUBK = 0
   CTRLPF = $31
   ballheight = 8



   ;***************************************************************
   ;
   ;  Sets playfield pixel colors.
   ;
   pfcolors:
   $2C
   $2C
   $2C
   $2C
   $2A
   $28
   $26
   $2C
   $2C
   $2C
   $2C
end



   ;***************************************************************
   ;
   ;  Sets sprite colors.
   ;
   COLUP0 = $9C : COLUP1 = $44



   ;***************************************************************
   ;
   ;  Sets ball width.
   ;
   NUSIZ1 = $10



   ;***************************************************************
   ;
   ;  Joystick movement precheck.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __Skip_Joystick_Precheck

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if joystick hasn't been moved.
   ;
   if !joy0up && !joy0down && !joy0left && !joy0right then goto __Skip_Joystick_Precheck

   ;```````````````````````````````````````````````````````````````
   ;  Clears player0 direction bits since joystick has been moved.
   ;
   _BitOp_P0_M1_Dir = _BitOp_P0_M1_Dir & %11110000

__Skip_Joystick_Precheck




   ;***************************************************************
   ;
   ;  Auto-play direction change for player0 sprite.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_New_Dir

   ;```````````````````````````````````````````````````````````````
   ;  Adds to the auto-play direction change counter.
   ;
   _AP_Dir_Counter = _AP_Dir_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Forces a direction change when the counter gets too high or
   ;  when it's set high on purpose because the sprite was inactive.
   ;
   if _AP_Dir_Counter > 254 then goto __Get_New_AP_Direction

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 63) and adds 50. Change 50 to a
   ;  larger number if you want the sprite to move longer before
   ;  changing directions. Don't use a number larger than 190.
   ;
   temp6 = (rand&63) + 50

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the counter isn't high enough.
   ;
   if _AP_Dir_Counter < temp6 then goto __AP_Skip_New_Dir

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 255).
   ;
   temp5 = rand

   ;```````````````````````````````````````````````````````````````
   ;  There is a 90% chance that this section will be skipped.
   ;
   if temp5 < 230 then goto __AP_Skip_New_Dir

__Get_New_AP_Direction

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a new sprite direction from a random number (0 to 7).
   ;
   ;     0
   ;   7   1
   ;  6     2
   ;   5   3
   ;     4
   ;
   ;  0 = up, 1 = up/right, 2 = right, 3 = down/right, 4 = down,
   ;  5 = down/left, 6 = left, 7 = up/left.
   ;
   _T5_AP_Dir = (rand&7)

   ;```````````````````````````````````````````````````````````````
   ;  Compares the new sprite direction with the opposite direction
   ;  and selects a new direction if there is a match. This keeps
   ;  the sprite from bouncing back and forth between the same two
   ;  directions.
   ;
   if _T5_AP_Dir = _AP_Mem_Dir then _T5_AP_Dir = _T5_AP_Dir + (rand&1) + (rand&3) + 2 : if _T5_AP_Dir > 7 then _T5_AP_Dir = _T5_AP_Dir - 8

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes up/right or up/left if it is near bottom.
   ;
   if _Main_CharY > 85 then _T5_AP_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 7

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes down/right or down/left if it is near top.
   ;
   if _Main_CharY < 12 then _T5_AP_Dir = 3 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes up/left or down/left if it's near right side.
   ;
   if _Main_CharX > 148 then _T5_AP_Dir = 7 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes up/right or down/right if it's near left side.
   ;
   if _Main_CharX < 4 then _T5_AP_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 3

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the opposite direction the sprite is moving. Keeps
   ;  the sprite from bouncing back and forth between the same two
   ;  directions.
   ;
   _AP_Mem_Dir = _T5_AP_Dir + 4 : if _AP_Mem_Dir > 7 then _AP_Mem_Dir = _AP_Mem_Dir - 8

   ;```````````````````````````````````````````````````````````````
   ;  Clears counter and sprite direction bits.
   ;
   _AP_Dir_Counter = 0 : _BitOp_P0_M1_Dir = _BitOp_P0_M1_Dir & %11110000

   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite direction to bits to make things easier.
   ;
   if _T5_AP_Dir = 0 then _Bit0_P0_Dir_Up{0} = 1
   if _T5_AP_Dir = 1 then _Bit0_P0_Dir_Up{0} = 1 : _Bit3_P0_Dir_Right{3} = 1
   if _T5_AP_Dir = 2 then _Bit3_P0_Dir_Right{3} = 1
   if _T5_AP_Dir = 3 then _Bit1_P0_Dir_Down{1} = 1 : _Bit3_P0_Dir_Right{3} = 1
   if _T5_AP_Dir = 4 then _Bit1_P0_Dir_Down{1} = 1
   if _T5_AP_Dir = 5 then _Bit1_P0_Dir_Down{1} = 1 : _Bit2_P0_Dir_Left{2} = 1
   if _T5_AP_Dir = 6 then _Bit2_P0_Dir_Left{2} = 1
   if _T5_AP_Dir = 7 then _Bit0_P0_Dir_Up{0} = 1 : _Bit2_P0_Dir_Left{2} = 1

__AP_Skip_New_Dir




   ;***************************************************************
   ;
   ;  Joy0 up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps ahead if auto-play is on and the up bit is on.
   ;
   if _Bit3_Auto_Play{3} && _Bit0_P0_Dir_Up{0} then goto __AP_Move_Up

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved up.
   ;
   if !joy0up then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the up direction bit.
   ;
   _Bit0_P0_Dir_Up{0} = 1

__AP_Move_Up


   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (_Main_CharX-10)/4

   temp4 = (_Main_CharX-17)/4

   temp3 = temp5 - 1

   temp6 = (_Main_CharY-9)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Up

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Up

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 up.
   ;
   _Main_CharY = _Main_CharY - 1 : pfscroll downdown
   gosub _P_U bank5

__Skip_Joy0_Up



   ;***************************************************************
   ;
   ;  Joy0 down check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps ahead if auto-play is on and the down bit is on.
   ;
   if _Bit3_Auto_Play{3} && _Bit1_P0_Dir_Down{1} then goto __AP_Move_Down

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved down.
   ;
   if !joy0down then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the down direction bit.
   ;
   _Bit1_P0_Dir_Down{1} = 1

__AP_Move_Down


   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (_Main_CharX-10)/4

   temp4 = (_Main_CharX-17)/4

   temp3 = temp5 - 1

   temp6 = (_Main_CharY+1)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Down

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Down

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 down.
   ;
   _Main_CharY = _Main_CharY + 1 : pfscroll upup
   gosub _P_D bank5

__Skip_Joy0_Down



   ;***************************************************************
   ;
   ;  Joy0 left check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps ahead if auto-play is on and the left bit is on.
   ;
   if _Bit3_Auto_Play{3} && _Bit2_P0_Dir_Left{2} then goto __AP_Move_Left

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved to the left.
   ;
   if !joy0left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the left direction bit.
   ;
   _Bit2_P0_Dir_Left{2} = 1

__AP_Move_Left


   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (_Main_CharY)/8

   temp3 = (_Main_CharY-8)/8

   temp6 = (_Main_CharX-18)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Left

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 left.
   ;
   _Main_CharX = _Main_CharX - 1 : pfscroll right
   gosub _P_L bank5

__Skip_Joy0_Left



   ;***************************************************************
   ;
   ;  Joy0 right check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps ahead if auto-play is on and the right bit is on.
   ;
   if _Bit3_Auto_Play{3} && _Bit3_P0_Dir_Right{3} then goto __AP_Move_Right

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved to the right.
   ;
   if !joy0right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the right direction bit.
   ;
   _Bit3_P0_Dir_Right{3} = 1

__AP_Move_Right


   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (_Main_CharY)/8

   temp3 = (_Main_CharY-8)/8

   temp6 = (_Main_CharX-9)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Right

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 right.
   ;
   _Main_CharX = _Main_CharX + 1 : pfscroll left
   gosub _P_R bank5

__Skip_Joy0_Right



   ;***************************************************************
   ;
   ;  Purple guy chases the player.
   ;
   if _WillY < _Main_CharY then _WillY = _WillY + 1
   if _WillY > _Main_CharY then _WillY = _WillY - 1
   if _WillX < _Main_CharX then _WillX = _WillX + 1
   if _WillX > _Main_CharX then _WillX = _WillX - 1



   ;***************************************************************
   ;
   ;  Auto-play inactivity check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Inactivity

   ;```````````````````````````````````````````````````````````````
   ;  Sprite gets a new direction if it is sitting still.
   ;
   if _AP_Mem_P0x = _Main_CharX && _AP_Mem_P0y = _Main_CharY then _AP_Dir_Counter = 254

   ;```````````````````````````````````````````````````````````````
   ;  Remembers sprite position during auto-play.
   ;
   _AP_Mem_P0x = _Main_CharX : _AP_Mem_P0y = _Main_CharY

__AP_Inactivity



   ;***************************************************************
   ;
   ;  Fire button check.
   ;  
   ;  Turns on ball movement if fire button is pressed and
   ;  ball is not moving.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_Fire_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Determines if sprite should fire during auto-play.
   ;  There is a 90% chance that the missile will not fire.
   ;
   temp5 = rand : if temp5 < 230 then goto __Skip_Fire

   goto __AP_Fire

__AP_Skip_Fire_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Clears the restrainer bit and skips this section if fire
   ;  button is not pressed.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if fire button hasn't been released since
   ;  the title screen.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Skip_Fire

__AP_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if ball is moving.
   ;
   if _Bit7_M1_Moving{7} then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on ball movement.
   ;
   _Bit7_M1_Moving{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Takes a 'snapshot' of player0 direction so ball will
   ;  stay on track until it hits something.
   ;
   _Bit4_M1_Dir_Up{4} = _Bit0_P0_Dir_Up{0}
   _Bit5_M1_Dir_Down{5} = _Bit1_P0_Dir_Down{1}
   _Bit6_M1_Dir_Left{6} = _Bit2_P0_Dir_Left{2}
   _Bit7_M1_Dir_Right{7} = _Bit3_P0_Dir_Right{3}

   ;```````````````````````````````````````````````````````````````
   ;  Sets up starting position of ball.
   ;
   if _Bit4_M1_Dir_Up{4} then _Lost_Soul_X = _Main_CharX + 4 : _Lost_Soul_Y = _Main_CharY - 5
   if _Bit5_M1_Dir_Down{5} then _Lost_Soul_X = _Main_CharX + 4 : _Lost_Soul_Y = _Main_CharY - 1
   if _Bit6_M1_Dir_Left{6} then _Lost_Soul_X = _Main_CharX + 2 : _Lost_Soul_Y = _Main_CharY - 3
   if _Bit7_M1_Dir_Right{7} then _Lost_Soul_X = _Main_CharX + 6 : _Lost_Soul_Y = _Main_CharY - 3
   

__Skip_Fire



   ;***************************************************************
   ;
   ;  Ball movement check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if ball isn't moving.
   ;
   if !_Bit7_M1_Moving{7} then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Moves ball in the appropriate direction.
   ;
   if _Bit4_M1_Dir_Up{4} then _Lost_Soul_Y = _Lost_Soul_Y - 6
   if _Bit5_M1_Dir_Down{5} then _Lost_Soul_Y = _Lost_Soul_Y + 6
   if _Bit6_M1_Dir_Left{6} then _Lost_Soul_X = _Lost_Soul_X - 6
   if _Bit7_M1_Dir_Right{7} then _Lost_Soul_X = _Lost_Soul_X + 6

   ;```````````````````````````````````````````````````````````````
   ;  Clears ball if it hits the edge of the screen.
   ;
   if _Lost_Soul_Y < _M_Edge_Top then goto __Delete_Missile
   if _Lost_Soul_Y > _M_Edge_Bottom then goto __Delete_Missile
   if _Lost_Soul_X < _M_Edge_Left then goto __Delete_Missile
   if _Lost_Soul_X > _M_Edge_Right then goto __Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Skips rest of section if no collision.
   ;
   if !collision(playfield,ball) then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Skips points if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Adds a point to the score.
   ;
   ;score = score + 1


__Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Clears Missile1_Moving bit and moves ball off screen.
   ;
   _Bit7_M1_Moving{7} = 0 : _Lost_Soul_X = 200 : _Lost_Soul_Y = 200

__Skip_Missile



   ;***************************************************************
   ;
   ;  Ends the fake game if player0 touches player0.
   ;
   if !collision(player1,player0) then goto _Skip_touch
   if _sc3 > 0 then score = score - 1


   ;```````````````````````````````````````````````````````````````
   ;  if pfscore2 bar is empty, delete one guy.
   ;
   if !pfscore2 then pfscore1 = pfscore1/4

   ;```````````````````````````````````````````````````````````````
   ;  Deletes a life.
   ; corrige aqui
   if pfscore1 = 168 then pfscore2 = 255
   if !pfscore1 then _Bit2_Game_Control{2} = 1
   _WillX = _Main_CharX + (rand&127) + (rand/16) : _WillY = _Main_CharY + (rand/4) + (rand&63) - 1
   
_Skip_touch


   
   ;_Bit2_Game_Control{2} = 1
   

   ;***************************************************************
   ;
   ;  Enemy/missile collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player0,ball) then goto __Skip_Shot_Enemy

   ;```````````````````````````````````````````````````````````````
   ;  Clears ball bit and moves ball off the screen.
   ;
   _Bit7_M1_Moving{7} = 0 : _Lost_Soul_X = 200 : _Lost_Soul_Y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Skips points if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __AP_Skip_Enemy_Points

   ;```````````````````````````````````````````````````````````````
   ;  Adds 1 points to the score.
   ;
   score = score + 1 
   if pfscore2 < 255 then pfscore2 = pfscore2*2|1
   if pfscore1 > 255 && pfscore2 = 255 then pfscore1 = pfscore1*2|1

   ;```````````````````````````````````````````````````````````````
   ; Adds one point to the kill count to control William's AI
   ;
   _Kill_Count = _Kill_Count + 1

   ;```````````````````````````````````````````````````````````````
   ;    Controls kill count so that it doesn't glitch or overflow the
   ; 	Dificulty level.

   if _Kill_Count >= 3 then _Kill_Count = 0

__AP_Skip_Enemy_Points


    ;``````````````````````````````````````````````````````````````
    ;           WIP
    ;


    ;``````````````````````````````````````````````````````````````
    ;      Kill Count definitions.
    ;

    if _Kill_Count = 3 then _Will_Aftn_AI = 1

    ;`````````````````````````````````````````````````````````````
    ; Will Aften difficulty level definitions.
    ;
    if _Will_Aftn_AI = 1 then _Lost_Soul_Y = 250


   ;```````````````````````````````````````````````````````````````
   ;  Places enemy in new location based on location of player.
   ;
   _WillY = (rand/4) + (rand&63) + 15

   if _Main_CharX >= 77 then _WillX = (rand&127) + (rand/16) + 5 : goto __Skip_Shot_Enemy

   _WillX = (rand&127) + (rand/16) + 140


__Skip_Shot_Enemy



   ;***************************************************************
   ;
   ;  Auto-play score flipper.
   ;
   ;  Flips between high score and current score.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto-play bit is not on.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  Increments the auto play 2-second counter.
   ;
   _AP_2_Sec_Score_Flip = _AP_2_Sec_Score_Flip + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto play 2-second counter is less
   ;  than 2 seconds (120 = 2 seconds).
   ;
   if _AP_2_Sec_Score_Flip < 120 then goto __AP_Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  Clears the 2-second counter and flips the score swapping bit.
   ;
   _AP_2_Sec_Score_Flip = 0 : _Bit6_Swap_Scores{6} = !_Bit6_Swap_Scores{6}

   ;```````````````````````````````````````````````````````````````
   ;  Skips high score swap if swap bit is off.
   ;
   if !_Bit6_Swap_Scores{6} then goto __AP_Skip_HiScore_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays high score (blue) and skips rest of section.
   ;
   scorecolor = $AE

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __AP_Skip_Flip

__AP_Skip_HiScore_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (yellow).
   ;
   scorecolor = $1C

   _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem

__AP_Skip_Flip




   ;***************************************************************
   ;
   ;  Pause check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __AP_Skip_Pause

   ;```````````````````````````````````````````````````````````````
   ;  Checks current position of COLOR/BW switch.
   ;
   _Bit1_BW_Check{1} = 0

   if switchbw then _Bit1_BW_Check{1} = 1
   
   ;```````````````````````````````````````````````````````````````
   ;     Pauses the game if the button C of the genesis controller
   ;     is pressed.
   ;
   if genesispad{0} && !INPT1{7} then _Bit1_BW_Check{1} = 1

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
   ;  Defines shape of player0 sprite.
   ;
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
	 player0:
	 %11100111
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %00100100
	 %10111101
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


   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Game Over Check
   ;
   ;  _Bit2_Game_Control{2} controls when the game ends.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if game control bit is off.
   ;
   if !_Bit2_Game_Control{2} then goto __Skip_Check_G_Over

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check. Puts score back to current score and jumps
   ;  back to the title screen if auto-play bit is on.
   ;
   if _Bit3_Auto_Play{3} then _Bit2_Game_Control{2} = 0 : _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem : goto __Start_Restart bank1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to game over set up.
   ;
   goto __Game_Over_Setup bank3

__Skip_Check_G_Over



   ;***************************************************************
   ;
   ;  Reset switch check and end of main loop.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Starts game during auto-play if reset switch or fire button
   ;  is pressed. Also clears auto-play bit and sets game control
   ;  bit so game will start instead of going to title screen.
   ;
   if switchreset || joy0fire then _Bit3_Auto_Play{3} = 0 : _Bit2_Game_Control{2} = 1 : goto __Start_Restart bank1

__AP_Skip_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Turns off reset restrainer bit and jumps to beginning of
   ;  main loop if the reset switch is not pressed.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of main loop if the reset switch hasn't
   ;  been released after being pressed.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Clears the game over bit so the title screen will appear.
   ;
   _Bit2_Game_Control{2} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the game over setup section and checks for a high
   ;  score, then jumps to the title screen.
   ;
   goto __Game_Over_Setup bank3





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF MAIN LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   bank 3





   ;***************************************************************
   ;***************************************************************
   ;
   ;  GAME OVER SETUP
   ;
   ;
__Game_Over_Setup


   ;***************************************************************
   ;
   ;  High score check.
   ;
   ;  Checks for a new high score.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Checks first byte.
   ;
   if _sc1 > _High_Score1 then goto __New_High_Score
   if _sc1 < _High_Score1 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  First byte equal. Checks second byte.
   ;
   if _sc2 > _High_Score2 then goto __New_High_Score
   if _sc2 < _High_Score2 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Second byte equal. Checks third byte.
   ;
   if _sc3 > _High_Score3 then goto __New_High_Score
   if _sc3 < _High_Score3 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes equal. Skips high score.
   ;
   goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes not equal. New high score!
   ;
__New_High_Score

   _High_Score1 = _sc1 : _High_Score2 = _sc2 : _High_Score3 = _sc3

__Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Restarts the game if the reset switch was pressed. Continues
   ;  in the game over setup section if the game ended naturally.
   ;
   if !_Bit2_Game_Control{2} then goto __Start_Restart bank1


   ;***************************************************************
   ;
   ;  Saves the latest score for the high score flip.
   ;
   _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3


   ;***************************************************************
   ;
   ;  Clears the counters.
   ;
   _Master_Counter = 0 : _Frame_Counter = 0


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   _Main_CharY = 200 : _WillY = 200 : _Lost_Soul_Y = 200


   ;***************************************************************
   ;
   ;  Restrains reset switch and fire button for game over loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after entering a different segment
   ;  of the program. It also does double duty by restraining the
   ;  fire button in the game over loop.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Sets up game over playfield.
   ;
   playfieldpos = 8
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
   ;  20 second counter.
   ;
   ;  This includes a 2 second countdown timer. Any Atari 2600
   ;  game should disable the fire button for 2 seconds when
   ;  the game is over to keep the player from restarting by
   ;  mistake. It is part of the usual standards and procedures.
   ;
   ;  This section also flips between the current score and the
   ;  high score every 2 seconds. It jumps to the title screen
   ;  after 20 seconds if the player does nothing.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments master counter every frame (60 frames = 1 second).
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if master counter is less than 2 seconds.
   ;  The master counter resets every 2 seconds (60 + 60 = 120).
   ;
   if _Master_Counter < 120 then goto __Skip_20_Second_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Increments frame counter and clears master counter.
   ;  (One increment = 2 seconds.)
   ;
   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Restores the current score, resets the game, and goes to the
   ;  title screen if 20 seconds have gone by.
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   if _Frame_Counter > 9 then _Bit2_Game_Control{2} = 0 : _sc1=_Score1_Mem : _sc2=_Score2_Mem : _sc3=_Score3_Mem: goto __Start_Restart bank1

   ;```````````````````````````````````````````````````````````````
   ;  Flips the score swapping bit.
   ;
   _Bit6_Swap_Scores{6} = !_Bit6_Swap_Scores{6}

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to current score if swap bit is off.
   ;
   if !_Bit6_Swap_Scores{6} then goto __GO_Current_Score

   ;```````````````````````````````````````````````````````````````
   ;  Displays high score (blue) and skips rest of section.
   ;
   scorecolor = $AE

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __Skip_20_Second_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (yellow).
   ;
__GO_Current_Score

   scorecolor = $1C

   _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem

__Skip_20_Second_Counter



   ;***************************************************************
   ;
   ;  Playfield and background colors.
   ;
   ;  Changes colors after 2 seconds. This is only done to let
   ;  you, the programmer, know when 2 seconds have gone by. The
   ;  color change doesn't need to happen in a real game.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if first 2 seconds are over.
   ;
   if _Frame_Counter then goto __Skip_First_Colors

   ;```````````````````````````````````````````````````````````````
   ;  Sets background color for first 2 seconds.
   ;
   COLUBK = $44

   ;```````````````````````````````````````````````````````````````
   ;  Sets playfield color for first 2 seconds.
   ;
   pfcolors:
   $2E
   $2E
   $2C
   $2A
   $28
   $26
   $2E
   $2E
   $2C
   $2A
   $28
   $26
end

   goto __Skip_Second_Colors

__Skip_First_Colors

   ;```````````````````````````````````````````````````````````````
   ;  Sets background color after first 2 seconds.
   ;
   COLUBK = $D2

   ;```````````````````````````````````````````````````````````````
   ;  Sets playfield color after first 2 seconds.
   ;
   pfcolors:
   $DE
   $DE
   $DC
   $DA
   $D8
   $D6
   $DE
   $DE
   $DC
   $DA
   $D8
   $D6
end

__Skip_Second_Colors



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Reset/fire button check and end of game over loop.
   ;  
   ;  Restarts the program if the reset switch or the fire
   ;  button is pressed appropriately.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of the game over loop if the initial
   ;  2 second freeze is not over.
   ;
   if _Frame_Counter = 0 then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Clears the restrainer bit and jumps to beginning of game
   ;  over loop if fire button or reset switch is not pressed.
   ;
   if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of the game over loop if fire button
   ;  hasn't been released since leaving the main loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  The program is restarted.
   ;
   goto __Start_Restart bank1


   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF GAME OVER LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PAUSE SETUP
   ;
__Pause_Setup


   ;***************************************************************
   ;
   ;  Mutes the sound.
   ;
   AUDV0 = 0 : AUDV1 = 0


   ;***************************************************************
   ;
   ;  Restrains the fire button for the pause loop.
   ;
   _Bit1_FireB_Restrainer{1} = 1


   ;***************************************************************
   ;
   ;  Clears the pause counter.
   ;
   _Pause_Counter_Tmp = 0


   ;***************************************************************
   ;
   ;  Selects a random color scheme.
   ;
   _Pause_Color_Tmp = (rand&7)

   _Pause_Mem_Color_Tmp = _Pause_Color_Tmp





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PAUSE LOOP
   ;
__Pause_Game



   ;***************************************************************
   ;
   ;  Sets ball width.
   ;
   NUSIZ1 = $10



   ;***************************************************************
   ;
   ;  Changes color scheme every 4 seconds.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increases the pause counter.
   ;
   _Pause_Counter_Tmp = _Pause_Counter_Tmp + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if counter isn't high enough.
   ;
   if _Pause_Counter_Tmp < 240 then goto __Skip_Pause_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Resets the pause counter.
   ;
   _Pause_Counter_Tmp = 0

   ;```````````````````````````````````````````````````````````````
   ;  Gets a random number from 0 to 7.
   ;
   _Pause_Color_Tmp = (rand&7)

   ;```````````````````````````````````````````````````````````````
   ;  Compares the new color scheme with the previous color scheme
   ;  and selects a new color scheme if they are the same.
   ;
   if _Pause_Color_Tmp = _Pause_Mem_Color_Tmp then _Pause_Color_Tmp = _Pause_Color_Tmp + (rand&3) + 1 : if _Pause_Color_Tmp > 7 then _Pause_Color_Tmp = _Pause_Color_Tmp - 8

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the new color scheme.
   ;
   _Pause_Mem_Color_Tmp = _Pause_Color_Tmp

   ;```````````````````````````````````````````````````````````````
   ;  Decides if the B color scheme should be used.
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
   ;  Displays the screen.
   ;
   drawscreen



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


   goto __Main_Loop bank2





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
end

   COLUP0 = $0C : COLUP1 = $0C

   COLUBK = $0A

   scorecolor = $0C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to gray.
   ;
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

   COLUP0 = $0A : COLUP1 = $0A

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

   COLUP0 = $3C : COLUP1 = $3C

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

   COLUP0 = $3A : COLUP1 = $3A

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

   COLUP0 = $6C : COLUP1 = $6C

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

   COLUP0 = $6A : COLUP1 = $6A

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

   COLUP0 = $9C : COLUP1 = $9C

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

   COLUP0 = $9A : COLUP1 = $9A

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

   COLUP0 = $CC : COLUP1 = $CC

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

   COLUP0 = $CA : COLUP1 = $CA

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

   COLUP0 = $FC : COLUP1 = $FC

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

   COLUP0 = $FA : COLUP1 = $FA

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

   COLUP0 = $8C : COLUP1 = $8C

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

   COLUP0 = $8A : COLUP1 = $8A

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

   COLUP0 = $2C : COLUP1 = $2C

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

   COLUP0 = $2A : COLUP1 = $2A

   COLUBK = $2C

   scorecolor = $2A

   goto __Got_Pause_Colors



   bank 4

   asm
   include "titlescreen/asm/titlescreen.asm"
end




   bank 5
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
  return
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



   bank 6



   bank 7



   bank 8



   ;***************************************************************
   ;
   ;  Sprite graphics will be placed in the last bank no matter
   ;  where you define them. If you have a lot of graphics, you
   ;  may not have much room here for code. Visual batari Basic
   ;  shows the ROM space you have left under the Messages tab
   ;  whenever you compile a game, so you'll always know the
   ;  remaining ROM space in each bank.
   ;
   ;***************************************************************