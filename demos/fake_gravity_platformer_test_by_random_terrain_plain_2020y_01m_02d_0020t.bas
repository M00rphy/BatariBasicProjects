   ;***************************************************************
   ;
   ;  Fake Gravity Platformer Test
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  If this program will not compile for you, get the latest
   ;  version of batari Basic:
   ;  
   ;  http://www.randomterrain.com/atari-2600-memories-batari-basic-commands.html#gettingstarted
   ;  
   ;***************************************************************



   ;****************************************************************
   ;
   ;  The kernel options below cause the loss of missile1 and
   ;  missile0.
   ; 
   ;  But the missiles can be used as top to bottom strips using
   ;  ENAM0 = 2 and ENAM1 = 2 and turned off using ENAM0 = 0 and
   ;  ENAM1 = 0. ENAM0{1} = 1 and ENAM1{1} = 1 can also be used.
   ;  The colors of a multi-colored sprite will show up in the
   ;  missile at the same horizontal position. You must be careful
   ;  because the missile can be touched from top to bottom, not
   ;  just at the spot where you see color.
   ;
   set kernel_options player1colors pfcolors no_blank_lines



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
   ;  and the name. Example: _Bit7_Reset_Restrainer 
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Player1 left/right movement.
   ;
   dim _P1_Left_Right = player1x.a

   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite x position to x playfield position.
   ;
   dim _Convert_X = b

   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite y position to y playfield position.
   ;
   dim _Convert_Y = c

   ;```````````````````````````````````````````````````````````````
   ;  Limits how high player can jump and affects speed slowdown.
   ;
   dim _Jump_Gravity_Counter = d

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity fall counter.
   ;
   dim _Fall_Gravity_Counter = e

   ;```````````````````````````````````````````````````````````````
   ;  Counter for sliding.
   ;
   dim _Slide_Counter = f

   ;```````````````````````````````````````````````````````````````
   ;  Becomes slower each time it loops back around.
   ;
   dim _Slide_Speed = g

   ;```````````````````````````````````````````````````````````````
   ;  Slide is less while running than it is while in air.
   ;
   dim _Slide_Limit = h

   ;```````````````````````````````````````````````````````````````
   ;  Controls animation speed.
   ;
   dim _Master_Counter = i

   ;```````````````````````````````````````````````````````````````
   ;  Animation counter.
   ;
   dim _Frame_Counter = j

   ;```````````````````````````````````````````````````````````````
   ;  Channel 0 sound variables.
   ;
   dim _Ch0_Sound = k
   dim _Ch0_Duration = l
   dim _Ch0_Counter = m

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_02 = x
   dim _Bit6_LR_Joy_Movement = x       ; Left or right joystick movement happened.

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Fall_in_Progress = y         ; Player is falling if on.
   dim _Bit1_Slide_Left_in_Progress = y   ; Player moved left if on.
   dim _Bit2_Slide_Right_in_Progress = y  ; Player moved right if on.
   dim _Bit3_FireB_Restrainer = y         ; Player can't hold down fire button to jump.
   dim _Bit4_Flip_P1 = y                  ; Flips player sprite when necessary.
   dim _Bit5_Ground_Slide_in_Progress = y ; Lets player slide when direction changes.
   dim _Bit6_Duck_in_Progress = y         ; Allows player to slide while duckting.
   dim _Bit7_Reset_Restrainer = y         ; Restrains the reset switch.



   ;***************************************************************
   ;
   ;  Constants for channel 0 sound effects (_Ch0_Sound).
   ;  [The c stands for constant.]
   ;
   const _c_Jump_Sound = 1
   const _c_Fall_Sound = 2
   const _c_Slide_Sound = 3





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
   ;  Clears all normal variables.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0


   ;***************************************************************
   ;
   ;  Sets starting slide speed.
   ;
   _Slide_Speed = 1


   ;***************************************************************
   ;
   ;  Sets position of player1 sprite.
   ;
   player1x = 79 : player1y = 79


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit7_Reset_Restrainer{7} = 1


   ;***************************************************************
   ;
   ;  Sets up the playfield.
   ;
   playfield:
   ................................
   ................................
   ................................
   ................................
   ......XXXXXXX......XXXXXXX......
   ................................
   ................................
   ..........XXXXXXXXXXXX..........
   ................................
   ................................
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets colors.
   ;
   COLUPF = $96 : COLUBK = $00 : COLUP1 = $42



   ;***************************************************************
   ;
   ;  Sets playfield colors.
   ;
   pfcolors:
   $0C
   $0C
   $0C
   $0C
   $1C
   $00
   $0C
   $3C
   $00
   $0C
   $CC
   $C6
end



   ;***************************************************************
   ;
   ;  Converts player sprite position to playfield position.
   ;
   _Convert_X = (player1x-14)/4
   _Convert_Y = player1y/8



   ;***************************************************************
   ;
   ;  Controls animation speed.
   ;
   _Master_Counter = _Master_Counter + 1

   if _Master_Counter < 4 then goto __Skip_Frame_Counter

   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   if _Frame_Counter = 4 then _Frame_Counter = 0

__Skip_Frame_Counter



   ;***************************************************************
   ;
   ;  Default standing still position for player1 sprite.
   ;
   player1color:
   $26
   $9C
   $9C
   $9C
   $DA
   $DA
   $3C
   $3C
   $3C
   $26
end

   player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %01011010
   %00111100
   %00011000
   %00111100
   %00111100
   %00011000
end



   ;***************************************************************
   ;
   ;  Fire button (jump) section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if fire button is not pressed.
   ;
   if !joy0fire then _Jump_Gravity_Counter = 0 : _Bit3_FireB_Restrainer{3} = 0 : goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Deactivates running slide while in the air.
   ;
   _Bit5_Ground_Slide_in_Progress{5} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Used when player moves left/right while jumping or falling.
   ;
   if !_Bit3_FireB_Restrainer{3} then player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111101
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Arms up sprite used if player isn't moving left or right.
   ;
   if !joy0left && !joy0right && !_Bit3_FireB_Restrainer{3} then  player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %00011000
   %01111110
   %10011001
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Skips jump if player is falling.
   ;
   if _Bit0_Fall_in_Progress{0} then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips jump if fire button restrainer bit is on and jump and
   ;  fall are not happening. Fixes it so the player can't hold
   ;  down the fire button to jump repeatedly.
   ;
   if _Bit3_FireB_Restrainer{3} && !_Bit0_Fall_in_Progress{0} && !_Jump_Gravity_Counter then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Starts jumping sound effect if jump is not happening.
   ;
   if !_Jump_Gravity_Counter then _Ch0_Sound = _c_Jump_Sound : _Ch0_Duration = 1 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Turns on restrainer bit for fire button.
   ;
   _Bit3_FireB_Restrainer{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Adds one to the jump counter.
   ;
   _Jump_Gravity_Counter = _Jump_Gravity_Counter + 1 

   ;```````````````````````````````````````````````````````````````
   ;  Resets jump counter if limit is reached and starts a fall.
   ;
   if _Jump_Gravity_Counter > 12 then _Jump_Gravity_Counter = 0 : _Bit0_Fall_in_Progress{0} = 1 : goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Jump happens here.  
   ;
   ;  Skips jump if player1 sprite is at top edge of screen.
   ;
   if player1y < 13 then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Changes speed of jump over time depending on counter number.
   ;  (Slows down the higher it goes.)
   ;
   if _Jump_Gravity_Counter <= 7 then temp6 = 3
   if _Jump_Gravity_Counter > 7 && _Jump_Gravity_Counter <= 10 then temp6 = 2
   if _Jump_Gravity_Counter > 10 then temp6 = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 sprite up the screen.
   ;
   player1y = player1y - temp6

   ;```````````````````````````````````````````````````````````````
   ;  Converts player1 y position to playfield y position.
   ;
   temp5 = (player1y-5)/8

   ;```````````````````````````````````````````````````````````````
   ;  Checks to see if a pfpixel is in the way.
   ;
   if pfread(_Convert_X,temp5) then _Jump_Gravity_Counter = 0 : _Bit0_Fall_in_Progress{0} = 1 : goto __Skip_Jump

__Skip_Jump



   ;***************************************************************
   ;
   ;  Fall down section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite y position to playfield y position.
   ;
   temp5 = (player1y+1)/8

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if player is jumping or pfpixel is in the way.
   ;
   if _Jump_Gravity_Counter || pfread(_Convert_X,temp5) then goto __Skip_Fall_01

   ;```````````````````````````````````````````````````````````````
   ;  Used when player moves left/right while jumping or falling.
   ;
   player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111101
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Arms up sprite used if player isn't moving left or right.
   ;
   if !joy0left && !joy0right then player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %00011000
   %01111110
   %10011001
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Adds one to the gravity counter.
   ;
   _Fall_Gravity_Counter = _Fall_Gravity_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity fall (speed keeps increasing during a fall).
   ;
   temp6 = 0
   if _Fall_Gravity_Counter > 8 && _Jump_Gravity_Counter <= 16 then temp6 = 1
   if _Fall_Gravity_Counter > 16 && _Jump_Gravity_Counter <= 24 then temp6 = 2
   if _Fall_Gravity_Counter > 24 && _Jump_Gravity_Counter <= 32 then temp6 = 3
   if _Fall_Gravity_Counter > 32 then temp6 = 4

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 down the screen.
   ;
    player1y = player1y + temp6

   ;```````````````````````````````````````````````````````````````
   ;  Skips sound effect if jump or fall sound effects are playing.
   ;
   if _Ch0_Sound = _c_Jump_Sound || _Ch0_Sound = _c_Fall_Sound then goto __Skip_Fall_Sound_Check

   ;```````````````````````````````````````````````````````````````
   ;  Makes falling sound effect under certain conditions.
   ;
   if _Fall_Gravity_Counter = 17 || _Fall_Gravity_Counter = 27 then _Ch0_Sound = _c_Fall_Sound : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Skip_Fall_Sound_Check

   ;```````````````````````````````````````````````````````````````
   ;  Lets the program know a fall is in progress.
   ;
   _Bit0_Fall_in_Progress{0} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Deactivates running slide while in the air.
   ;
   _Bit5_Ground_Slide_in_Progress{5} = 0 

   goto __Skip_Fall_02

__Skip_Fall_01

   ;```````````````````````````````````````````````````````````````
   ;  Not falling. Clears related variables.
   ;
   _Bit0_Fall_in_Progress{0} = 0 : _Fall_Gravity_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Converts player1 y position to playfield y position.
   ;
   temp5 = (player1y)/8

   ;```````````````````````````````````````````````````````````````
   ;  Moves sprite up one pixel if player sprite touches playfield.
   ;
   if pfread(_Convert_X,temp5) then player1y = player1y - 1

__Skip_Fall_02

   ;```````````````````````````````````````````````````````````````
   ;  Turns off duck.
   ;
   _Bit6_Duck_in_Progress{6} = 0



   ;***************************************************************
   ;
   ;  Duck section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips duck section if joystick not moved down.
   ;
   if !joy0down then goto __Skip_Duck

   ;```````````````````````````````````````````````````````````````
   ;  Skips duck section if jumping or falling.
   ;
   if _Bit0_Fall_in_Progress{0} || _Jump_Gravity_Counter then goto __Skip_Duck

   ;```````````````````````````````````````````````````````````````
   ;  Turns on duck bit.
   ;
   _Bit6_Duck_in_Progress{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets duck color and shape.
   ;
   player1color:
   $26
   $9C
   $DA
   $DA
   $3C
   $3C
   $3C
   $26
end

   player1:
   %01100110
   %01111110
   %01011010
   %00111100
   %00011000
   %00111100
   %00111100
   %00011000
end

__Skip_Duck



   ;***************************************************************
   ;
   ;  Clears left/right joystick movement bit.
   ;
   _Bit6_LR_Joy_Movement{6} = 0



   ;***************************************************************
   ;
   ;  Left movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick not moved left.
   ;
   if !joy0left then goto __Skip_Joy0Left

   ;```````````````````````````````````````````````````````````````
   ;  Deactivates running slide if player1 sprite is jumping or
   ;  falling and sets up left/right slide variables and skips the
   ;  slide check if-thens.
   ;
   if _Bit0_Fall_in_Progress{0} || _Jump_Gravity_Counter then _Bit5_Ground_Slide_in_Progress{5} = 0 : _Bit1_Slide_Left_in_Progress{1} = 1 : _Bit2_Slide_Right_in_Progress{2} = 0 : goto __Skip_Slide_Check_Left

   ;```````````````````````````````````````````````````````````````
   ;  If a running slide is in progress, sets up left/right slide
   ;  variables and skips this section. 
   ;
   if _Bit5_Ground_Slide_in_Progress{5} then _Bit5_Ground_Slide_in_Progress{5} = 1 : _Bit1_Slide_Left_in_Progress{1} = 0 : _Bit2_Slide_Right_in_Progress{2} = 1 : goto __Skip_Joy0Left

   ;```````````````````````````````````````````````````````````````
   ;  If player was running a different direction, turns on running
   ;  slide variable, sets up left/right slide variables and skips
   ;  this section.
   ;
   if _Bit2_Slide_Right_in_Progress{2} then _Bit5_Ground_Slide_in_Progress{5} = 1 : _Bit1_Slide_Left_in_Progress{1} = 0 : goto __Skip_Joy0Left

__Skip_Slide_Check_Left

   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite x position to playfield x position.
   ;
   temp5 = (player1x-18)/4

   ;```````````````````````````````````````````````````````````````
   ;  Does not move player1 left if a pfpixel is in the way.
   ;
   if pfread(temp5,_Convert_Y) then goto __Skip_Joy0Left

   ;```````````````````````````````````````````````````````````````
   ;  Turns on left slide bit and left/right movement bit.
   ;
   _Bit1_Slide_Left_in_Progress{1} = 1 : _Bit6_LR_Joy_Movement{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 left if not hitting border.
   ;
   if player1x > 17 then _P1_Left_Right = _P1_Left_Right - 1.38

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player1 sprite is facing the correct direction.
   ;
   _Bit4_Flip_P1{4} = 0

__Skip_Joy0Left



   ;***************************************************************
   ;
   ;  Right movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick not moved left.
   ;
   if !joy0right then goto __Skip_Joy0Right

   ;```````````````````````````````````````````````````````````````
   ;  Deactivates running slide if player1 sprite is jumping or
   ;  falling and sets up left/right slide variables and skips the
   ;  slide check if-thens.
   ;
   if _Bit0_Fall_in_Progress{0} || _Jump_Gravity_Counter then _Bit5_Ground_Slide_in_Progress{5} = 0 : _Bit2_Slide_Right_in_Progress{2} = 1 : _Bit1_Slide_Left_in_Progress{1} = 0 : goto __Skip_Slide_Check_Right

   ;```````````````````````````````````````````````````````````````
   ;  If a running slide is in progress, sets up left/right slide
   ;  variables and skips this section. 
   ;
   if _Bit5_Ground_Slide_in_Progress{5} then _Bit5_Ground_Slide_in_Progress{5} = 1 : _Bit2_Slide_Right_in_Progress{2} = 0 : _Bit1_Slide_Left_in_Progress{1} = 1 : goto __Skip_Joy0Right

   ;```````````````````````````````````````````````````````````````
   ;  If player was running a different direction, turns on running
   ;  slide variable, sets up left/right slide variables and skips
   ;  this section.
   ;
   if _Bit1_Slide_Left_in_Progress{1} then _Bit5_Ground_Slide_in_Progress{5} = 1 : _Bit2_Slide_Right_in_Progress{2} = 0 : goto __Skip_Joy0Right

__Skip_Slide_Check_Right

   ;```````````````````````````````````````````````````````````````
   ;  Converts sprite x position to playfield x position.
   ;
   temp5 = (player1x-10)/4

   ;```````````````````````````````````````````````````````````````
   ;  Does not move player1 right if a pfpixel is in the way.
   ;
   if pfread(temp5,_Convert_Y) then goto __Skip_Joy0Right

   ;```````````````````````````````````````````````````````````````
   ;  Turns on right slide bit and left/right movement bit.
   ;
   _Bit2_Slide_Right_in_Progress{2} = 1 : _Bit6_LR_Joy_Movement{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 right if not hitting border.
   ;
   if player1x < 137 then _P1_Left_Right = _P1_Left_Right + 1.38

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player1 sprite is facing the correct direction.
   ;
   _Bit4_Flip_P1{4} = 1

__Skip_Joy0Right



   ;***************************************************************
   ;
   ;  Left/right walking animation section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if joystick not moved left or right.
   ;
   if !_Bit6_LR_Joy_Movement{6} then  goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if player1 sprite is jumping or falling.
   ;
   if _Jump_Gravity_Counter || _Bit0_Fall_in_Progress{0} then goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if player1 sprite is hitting left/right edge.
   ;
   if player1x < 18 || player1x > 136 then goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Sets player1 color.
   ;
   player1color:
   $26
   $9C
   $9C
   $9C
   $DA
   $DA
   $3C
   $3C
   $3C
   $26
end

   ;```````````````````````````````````````````````````````````````
   ;  Animates player1 sprite.
   ;
   on _Frame_Counter goto __Frame0 __Frame1 __Frame0 __Frame2

__Done_Anim_jump



   ;***************************************************************
   ;
   ;  Slide section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips joystick check if slide is in progress.
   ;
   if _Bit5_Ground_Slide_in_Progress{5} then goto __Skip_Joy0_Slide_Check

   ;```````````````````````````````````````````````````````````````
   ;  Skips slide if joystick is moved left or right.
   ;
   if joy0right || joy0left then _Slide_Counter = 0 : _Slide_Speed = 1 : goto __Skip_Slide

__Skip_Joy0_Slide_Check

   ;```````````````````````````````````````````````````````````````
   ;  Resets slide variables if either border is hit.
   ;
   if player1x < 17 then _Slide_Counter = 0 : _Bit5_Ground_Slide_in_Progress{5} = 0 : _Bit1_Slide_Left_in_Progress{1} = 0 : _Slide_Speed = 1 : _Bit2_Slide_Right_in_Progress{2} = 1 : goto __Skip_Slide
   if player1x > 137 then _Slide_Counter = 0 : _Bit5_Ground_Slide_in_Progress{5} = 0 : _Bit2_Slide_Right_in_Progress{2} = 0 : _Slide_Speed = 1 : _Bit1_Slide_Left_in_Progress{1} = 1 : goto __Skip_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if player1 sprite is standing still.
   ;
   if !_Bit1_Slide_Left_in_Progress{1} && !_Bit2_Slide_Right_in_Progress{2} then goto __Skip_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Sets slide limit and turns on slide bit.
   ;
   _Slide_Limit = 31 : _Bit5_Ground_Slide_in_Progress{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Increases slide limit and turns off slide bit if jumping or
   ;  falling.
   ;
   if _Bit0_Fall_in_Progress{0} || _Jump_Gravity_Counter then _Slide_Limit = 127 : _Bit5_Ground_Slide_in_Progress{5} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Skips slide sprite shape if player1 is ducking.
   ;
   if _Bit6_Duck_in_Progress{6} then goto __Skip_Slide_Sprite

   ;```````````````````````````````````````````````````````````````
   ;  Skips slide sprite shape if player1 is jumping or falling.
   ;
   if _Jump_Gravity_Counter || _Bit0_Fall_in_Progress{0} then goto __Skip_Slide_Sprite

   ;```````````````````````````````````````````````````````````````
   ;  Slide sprite shape used if no jumping, falling, or ducking.
   ;
   player1:
   %01100011
   %00110110
   %00011100
   %00011000
   %10111010
   %01111100
   %00110000
   %01111000
   %01111000
   %00110000
end

   player1color:
   $26
   $9C
   $9C
   $9C
   $DA
   $DA
   $3C
   $3C
   $3C
   $26
end

__Skip_Slide_Sprite

   ;```````````````````````````````````````````````````````````````
   ;  Starts sliding sound effect if slide counter is zero and no
   ;  sound is playing.
   ;
   if _Slide_Counter = 0 && _Ch0_Sound = 0 then if !_Bit0_Fall_in_Progress{0} then _Ch0_Sound = _c_Slide_Sound : _Ch0_Duration = 1 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Adds one to the slide counter.
   ;
   _Slide_Counter = _Slide_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if the counter doesn't match the speed.
   ;
   if _Slide_Counter < _Slide_Speed then goto __Skip_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Speed becomes slower each time it loops back around.
   ;
   _Slide_Speed = _Slide_Speed * 2

   ;```````````````````````````````````````````````````````````````
   ;  Slides either left or right (last direction player moved).
   ;
   if _Bit1_Slide_Left_in_Progress{1} then _P1_Left_Right = _P1_Left_Right - 1.04
   if _Bit2_Slide_Right_in_Progress{2} then _P1_Left_Right = _P1_Left_Right + 1.04

   ;```````````````````````````````````````````````````````````````
   ;  Stops sliding if the slowest speed is reached.
   ;
   if _Slide_Speed > _Slide_Limit then _Slide_Speed = 1 : _Slide_Counter = 0 : _Bit1_Slide_Left_in_Progress{1} = 0 : _Bit2_Slide_Right_in_Progress{2} = 0 : _Bit5_Ground_Slide_in_Progress{5} = 0

__Skip_Slide



   ;****************************************************************
   ;
   ;  Flips player1 sprite horizontally when necessary.
   ;
   if _Bit4_Flip_P1{4} then REFP1 = 8



   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   ;
   if _Ch0_Duration then goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 001.
   ;
   ;  Jump sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> _c_Jump_Sound then goto __Skip_Ch0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Jump[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 002.
   ;
   ;  Fall sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 002 isn't on.
   ;
   if _Ch0_Sound <> _c_Fall_Sound then goto __Skip_Ch0_Sound_002

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Fall[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Fall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Fall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_Fall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_002



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 003.
   ;
   ;  Slide sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 003 isn't on.
   ;
   if _Ch0_Sound <> _c_Slide_Sound then goto __Skip_Ch0_Sound_003

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Slide[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Slide[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Slide[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_Slide[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_003



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Other channel 0 sound effects go here.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__Clear_Ch_0
   
   _Ch0_Sound = 0 : AUDV0 = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__Skip_Ch_0



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Reset switch check and end of main loop.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the reset switch is not pressed, turns off reset
   ;  restrainer bit and jumps to beginning of main loop.
   ;
   if !switchreset then _Bit7_Reset_Restrainer{7} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If reset switch hasn't been released after being pressed,
   ;  program jumps to beginning of main loop.
   ;
   if _Bit7_Reset_Restrainer{7} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset pressed correctly, so the the program is restarted.
   ;
   goto __Start_Restart





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data starts here.
   ;
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for jump.
   ;
   data _SD_Jump
   1,12,31
   1
   8,12,31
   1
   6,12,31
   1
   8,12,31
   1
   8,12,30
   1
   8,12,29
   1
   8,12,28
   1
   8,12,27
   1
   8,12,26
   1
   8,12,25
   1
   8,12,24
   1
   8,12,23
   1
   8,12,22
   1
   8,12,21
   1
   8,12,20
   1
   8,12,19
   1
   6,12,18
   1
   4,12,17
   1
   2,12,16
   2
   0,0,0
   8
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for falling.
   ;
   data _SD_Fall
   6,12,16
   1
   8,12,16
   1
   6,12,17
   1
   8,12,17
   1
   6,12,18
   1
   8,12,18
   1
   6,12,19
   1
   8,12,19
   1
   6,12,20
   1
   8,12,20
   1
   6,12,21
   1
   8,12,21
   1
   6,12,22
   1
   8,12,22
   1
   6,12,23
   1
   8,12,23
   1
   6,12,24
   1
   8,12,24
   1
   6,12,25
   1
   8,12,25
   1
   6,12,26
   1
   8,12,26
   1
   6,12,27
   1
   8,12,27
   1
   6,12,28
   1
   8,12,28
   1
   6,12,29
   1
   8,12,29
   1
   6,12,30
   1
   8,12,30
   1
   6,12,31
   1
   2,12,31
   2
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for slide.
   ;
   data _SD_Slide
   2,4,22
   1
   1,4,21
   1
   2,4,24
   1
   1,4,20
   1
   2,4,23
   1
   1,4,25
   1
   2,4,22
   1
   1,4,20
   1
   2,4,25
   1
   1,4,21
   1
   2,4,25
   1
   1,4,22
   1
   2,4,23
   1
   1,4,22
   1
   2,4,20
   1
   1,4,24
   1
   2,4,21
   1
   1,4,23
   1
   2,4,25
   1
   1,4,24
   1
   2,4,22
   1
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Animation frames for player1.
   ;
__Frame0
   player1:
   %01100110
   %00100110
   %00111100
   %00011100
   %00111100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_Anim_jump


__Frame1
   player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111100
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_Anim_jump


__Frame2
   player1:
   %00111100
   %00011100
   %00011100
   %00011100
   %00011100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_Anim_jump