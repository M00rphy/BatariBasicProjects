   ;****************************************************************
   ;
   ;  Maze With Animated Sprite and Roaming Sprite (32 x 24)
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Instructions:
   ;  
   ;  Use the joystick to move the sprite.
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
   ;  Kernel options for this program eliminate the blank lines.
   ;
   set kernel_options no_blank_lines



   ;****************************************************************
   ;
   ;  This program has 4 banks (16k/4k = 4 banks).
   ;
   set romsize 16kSC



   ;****************************************************************
   ;
   ;  Random numbers can slow down bankswitched games.
   ;  This will speed things up.
   ;
   set optimization inlinerand



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
   ;  Player0 fixed point variables for more flexibility in
   ;  gameplay mechanics.
   ;
   dim _P0_L_R = player0x.a
   dim _P0_U_D = player0y.b

   ;```````````````````````````````````````````````````````````````
   ;  Player1 fixed point variables for more flexibility in
   ;  gameplay mechanics.
   ;
   dim _P1_L_R = player1x.c
   dim _P1_U_D = player1y.d

   ;```````````````````````````````````````````````````````````````
   ;  Makes the enemy change directions properly and not bounce
   ;  back.
   ;
   dim _Enemy_Counter = e

   ;```````````````````````````````````````````````````````````````
   ;  How often enemy looks for opening.
   ;
   dim _Enemy_Rand_Look = f

   ;```````````````````````````````````````````````````````````````
   ; All-purpose, reusable variable.
   ;
   dim _MyTemp01 = k

   ;```````````````````````````````````````````````````````````````
   ; Animation counters.
   ;
   dim _Master_Counter = m
   dim _Frame_Counter = n

   ;```````````````````````````````````````````````````````````````
   ;  Player0/player1 direction bits.
   ;
   dim _BitOp_P0_P1_Dir = u
   dim _Bit0_P0_Dir_Up = u
   dim _Bit1_P0_Dir_Down = u
   dim _Bit2_P0_Dir_Left = u
   dim _Bit3_P0_Dir_Right = u
   dim _Bit4_P1_Dir_Up = u
   dim _Bit5_P1_Dir_Down = u
   dim _Bit6_P1_Dir_Left = u
   dim _Bit7_P1_Dir_Right = u

   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit3_vblank = y
   dim _Bit5_Direction_Changed = y
   dim _Bit6_Flip_P0 = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers.
   ;
   dim rand16 = z



   ;****************************************************************
   ;
   ;  Defines number of playfield rows.
   ;
   const pfres=23





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
   ;  Clears 25 of the normal 26 variables (fastest way).
   ;  The variable z is used for random numbers in this program
   ;  and clearing it would mess up those random numbers.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0


   ;***************************************************************
   ;
   ;  Sets starting position of player0.
   ;
   player0x = 77 : player0y = 47


   ;***************************************************************
   ;
   ;  Sets starting position of enemy sprite.
   ;
   player1x = 77 : player1y = 83


   ;***************************************************************
   ;
   ;  Sets playfield color.
   ;
   COLUPF = $96


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = 0


   ;***************************************************************
   ;
   ;  Sets beginning direction for player0.
   ;
   _Bit2_P0_Dir_Left{2} = 1


   ;***************************************************************
   ;
   ;  Sets beginning direction for the enemy sprite.
   ;
   _Bit7_P1_Dir_Right{7} = 1


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Determines how often the enemy looks for alternate routes.
   ;  The smaller the number, the less often it will happen.
   ;
   _Enemy_Rand_Look = 50


   ;***************************************************************
   ;
   ;  Sets up the playfield.
   ;
   playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............XX..............X
   X..............XX..............X
   X..XXX..XXXXX..XX..XXXXX..XXX..X
   X..............................X
   X..............................X
   X..XXX..X..XXXXXXXXXX..X..XXX..X
   X.......X......XX......X.......X
   X.......X......XX......X.......X
   XXXXXX..XXXXX..XX..XXXXX..XXXXXX
   X..............................X
   X..............................X
   X..XXX..XXXXXXX..XXXXXXX..XXX..X
   X....X....................X....X
   X....X....................X....X
   XXX..X..X..XXXXXXXXXX..X..X..XXX
   X.......X......XX......X.......X
   X.......X......XX......X.......X
   X..XXXXXXXXXX..XX..XXXXXXXXXX..X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end


   ;****************************************************************
   ;
   ;  Displays the screen prematurely so we won't go over 262.
   ;
   drawscreen


   goto __Main_Loop bank2





   bank 2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;****************************************************************
   ;
   ;  Sets color of sprites and score.
   ;
   COLUP0 = $1E : COLUP1 = $AE : scorecolor = $0A



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
   ;  Turns on vblank section.
   ;
   _Bit3_vblank{3} = 1



   ;****************************************************************
   ;
   ;  Flips player sprite when necessary.
   ;
   if _Bit6_Flip_P0{6} then REFP0 = 8



   ;****************************************************************
   ;
   ;  Starts counting if enemy direction has changed.
   ;  This keeps the enemy from changing directions right away
   ;  so he won't bounce back and reverse direction.
   ;
   if _Bit5_Direction_Changed{5} then _Enemy_Counter = _Enemy_Counter + 1



   ;****************************************************************
   ;
   ;  Enemy up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy up direction bit isn't on.
   ;
   if !_Bit4_P1_Dir_Up{4} then goto __Skip_P1_Up

   ;```````````````````````````````````````````````````````````````
   ;  Converts enemy sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp3 = (player1x-17)/4

   temp6 = (player1y/4)-2

   if pfread(temp3,temp6) then goto __Enemy_Cant_Move_Up

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Enemy_Cant_Move_Up

   goto __Skip_to_P1_Move_Up

__Enemy_Cant_Move_Up

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel in the way. Clears the up bit, gets a new 
   ;  direction and jumps to the beginning of enemy movement.
   ;
   _Bit4_P1_Dir_Up{4} = 0

   gosub __Check_P1_LR

   goto __Clear_Direction

__Skip_to_P1_Move_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy up only if sprite is lined up with playfield.
   ;
   temp5 = (temp3*4)+17

   if temp5 <> player1x then goto __Skip_P1_Up

   _P1_U_D = _P1_U_D - 0.52

   ;```````````````````````````````````````````````````````````````
   ;  Randomly checks to see if a new direction can be taken if
   ;  the direction hasn't changed lately.
   ;
   ;  Remember that the value of _Enemy_Rand_Look can be increased to make
   ;  it more likely that a new direction will be looked for.
   ;
   if _Bit5_Direction_Changed{5} then goto __Skip_Enemy_Look_Up

   temp5 = rand

   temp6 = (((player1y-7)/4)*4)+7

   if temp5 < _Enemy_Rand_Look then if temp6 = player1y then gosub __Check_P1_LR : if _Bit5_Direction_Changed{5} then _Bit4_P1_Dir_Up{4} = 0 : goto __Clear_Direction

   _Bit5_Direction_Changed{5} = 0

__Skip_Enemy_Look_Up

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the up direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %00001111

   _Bit4_P1_Dir_Up{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Enemy sprite up frame.
   ;
   player1:
   %10101010
   %11111110
   %11111110
   %11111110
   %11010110
   %11010110
   %01111100
end

__Skip_P1_Up



   ;****************************************************************
   ;
   ;  Enemy down check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy down direction bit isn't on.
   ;
   if !_Bit5_P1_Dir_Down{5} then goto __Skip_P1_Down

   ;```````````````````````````````````````````````````````````````
   ;  Converts enemy sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp3 = (player1x-17)/4

   temp6 = ((player1y-3)/4) + 1

   if pfread(temp3,temp6) then goto __Enemy_Cant_Move_Down

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Enemy_Cant_Move_Down

   goto __Skip_to_P1_Move_Down

__Enemy_Cant_Move_Down

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel in the way. Clears the down bit, gets a new 
   ;  direction and jumps to the beginning of enemy movement.
   ;
   _Bit5_P1_Dir_Down{5} = 0

   gosub __Check_P1_LR

   goto __Clear_Direction

__Skip_to_P1_Move_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy down only if sprite is lined up with playfield.
   ;
   temp5 = (temp3*4)+17

   if temp5 <> player1x then goto __Skip_P1_Down

   _P1_U_D = _P1_U_D + 0.52

   ;```````````````````````````````````````````````````````````````
   ;  Randomly checks to see if a new direction can be taken if
   ;  the direction hasn't changed lately.
   ;
   ;  Remember that the value of _Enemy_Rand_Look can be increased to make
   ;  it more likely that a new direction will be looked for.
   ;
   if _Bit5_Direction_Changed{5} then goto __Skip_Enemy_Look_Down

   temp5 = rand

   temp6 = (((player1y-7)/4)*4)+7

   if temp5 < _Enemy_Rand_Look then if temp6 = player1y then gosub __Check_P1_LR : if _Bit5_Direction_Changed{5} then _Bit5_P1_Dir_Down{5} = 0 : goto __Clear_Direction

   _Bit5_Direction_Changed{5} = 0

__Skip_Enemy_Look_Down

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the down direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %00001111

   _Bit5_P1_Dir_Down{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Enemy sprite down frame.
   ;
   player1:
   %10101010
   %11111110
   %11010110
   %11010110
   %11111110
   %11111110
   %01111100
end

__Skip_P1_Down



   ;****************************************************************
   ;
   ;  Enemy left check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy left direction bit isn't on.
   ;
   if !_Bit6_P1_Dir_Left{6} then goto __Skip_P1_Left

   ;```````````````````````````````````````````````````````````````
   ;  Converts enemy sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp5 = ((player1x-14)/4) - 1

   temp6 = (player1y-7)/4

   if pfread(temp5,temp6) then goto __Enemy_Cant_Move_Left

   temp3 = temp6 + 1

   if pfread(temp5,temp3) then goto __Enemy_Cant_Move_Left

   goto __Skip_to_P1_Move_Left

__Enemy_Cant_Move_Left

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel in the way. Clears the left bit, gets a new 
   ;  direction and jumps to the beginning of enemy movement.
   ;
   _Bit6_P1_Dir_Left{6} = 0

   gosub __Check_P1_UD

   goto __Clear_Direction

__Skip_to_P1_Move_Left

   ;```````````````````````````````````````````````````````````````
   ;  Move enemy Left only if sprite is lined up with playfield.
   ;
   temp5 = (temp6*4)+7

   if temp5 <> player1y then goto __Skip_P1_Left

   _P1_L_R = _P1_L_R - 0.52

   ;```````````````````````````````````````````````````````````````
   ;  Randomly checks to see if a new direction can be taken if
   ;  the direction hasn't changed lately.
   ;
   ;  Remember that the value of _Enemy_Rand_Look can be increased to make
   ;  it more likely that a new direction will be looked for.
   ;
   if _Bit5_Direction_Changed{5} then goto __Skip_Enemy_Look_Left

   temp5 = rand

   if temp5 < _Enemy_Rand_Look then temp5 = (((player1x-17)/4)*4)+17 : if temp5 = player1x then gosub __Check_P1_UD : if _Bit5_Direction_Changed{5} then _Bit6_P1_Dir_Left{6} = 0 : goto __Clear_Direction

   _Bit5_Direction_Changed{5} = 0

__Skip_Enemy_Look_Left

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the left direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %00001111

   _Bit6_P1_Dir_Left{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Enemy sprite left frame.
   ;
   player1:
   %10101010
   %11111110
   %11111110
   %10101110
   %10101110
   %11111110
   %01111100
end

__Skip_P1_Left



   ;****************************************************************
   ;
   ;  Enemy right check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy right direction bit isn't on.
   ;
   if !_Bit7_P1_Dir_Right{7} then goto __Skip_P1_Right

   ;```````````````````````````````````````````````````````````````
   ;  Converts enemy sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp5 = ((player1x-13)/4)+1

   temp6 = ((player1y-7)/4)

   if pfread(temp5,temp6) then goto __Enemy_Cant_Move_Right

   temp3 = (temp6)+1

   if pfread(temp5,temp3) then goto __Enemy_Cant_Move_Right

   goto __Skip_to_P1_Move_Right

__Enemy_Cant_Move_Right

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel in the way. Clears the right bit, gets a new 
   ;  direction and jumps to the beginning of enemy movement.
   ;
   _Bit7_P1_Dir_Right{7} = 0

   gosub __Check_P1_UD

   goto __Clear_Direction

__Skip_to_P1_Move_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy right only if sprite is lined up with playfield.
   ;
   temp5 = (temp6*4)+7

   if temp5 <> player1y then goto __Skip_P1_Right

   _P1_L_R = _P1_L_R + 0.52

   ;```````````````````````````````````````````````````````````````
   ;  Randomly checks to see if a new direction can be taken if
   ;  the direction hasn't changed lately.
   ;
   ;  Remember that the value of _Enemy_Rand_Look can be increased to make
   ;  it more likely that a new direction will be looked for.
   ;
   if _Bit5_Direction_Changed{5} then goto __Skip_Enemy_Look_Right

   temp5 = rand

   if temp5 < _Enemy_Rand_Look then temp5 = (((player1x-17)/4)*4)+17 : if temp5 = player1x then gosub __Check_P1_UD : if _Bit5_Direction_Changed{5} then _Bit7_P1_Dir_Right{7} = 0 : goto __Clear_Direction

   _Bit5_Direction_Changed{5} = 0

__Skip_Enemy_Look_Right

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the right direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %00001111

   _Bit7_P1_Dir_Right{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Enemy sprite right frame.
   ;
   player1:
   %10101010
   %11111110
   %11111110
   %11101010
   %11101010
   %11111110
   %01111100
end

__Skip_P1_Right



   ;***************************************************************
   ;
   ;  Enemy counter check.
   ;
__Clear_Direction

   ;```````````````````````````````````````````````````````````````
   ;  Clears enemy direction flag and enemy counter if enemy
   ;  counter is greater than 2.
   ;
   if _Enemy_Counter = 3 then _Bit5_Direction_Changed{5} = 0 : _Enemy_Counter = 0



   ;****************************************************************
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
   ;  Restarts the program.
   ;
   goto __Start_Restart bank1





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF MAIN LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;****************************************************************
   ;
   ;  Checks left and right for an opening.
   ;
__Check_P1_LR

   ;```````````````````````````````````````````````````````````````
   ;  Clears direction changed bit and chooses which direction to
   ;  start looking.
   ;
   _Bit5_Direction_Changed{5} = 0

   temp5 = rand : if temp5 < 128 then goto __Skip_LR_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks to the left.
   ;
   temp5 = ((player1x-17)/4) - 1

   temp6 = (player1y-7)/4

   if pfread(temp5,temp6) then goto __Skip_LR_Check

   temp3 = temp6 + 1

   if pfread(temp5,temp3) then goto __Skip_LR_Check

   _Bit6_P1_Dir_Left{6} = 1 : _Bit5_Direction_Changed{5} = 1 : return

__Skip_LR_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks to the right.
   ;
   temp5 = ((player1x-13)/4)+1

   temp6 = ((player1y-7)/4)

   if pfread(temp5,temp6) then goto __Skip_R_Check

   temp3 = (temp6)+1

   if pfread(temp5,temp3) then goto __Skip_R_Check

   _Bit7_P1_Dir_Right{7} = 1 : _Bit5_Direction_Changed{5} = 1 : return

__Skip_R_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks to the left.
   ;
   temp5 = ((player1x-17)/4) - 1

   temp6 = (player1y-7)/4

   if pfread(temp5,temp6) then return

   temp3 = temp6 + 1

   if pfread(temp5,temp3) then return

   _Bit6_P1_Dir_Left{6} = 1 : _Bit5_Direction_Changed{5} = 1 : return



   ;****************************************************************
   ;
   ;  Looks up and down for an opening.
   ;
__Check_P1_UD

   ;```````````````````````````````````````````````````````````````
   ;  Clears direction changed bit and chooses which direction to
   ;  start looking.
   ;
   _Bit5_Direction_Changed{5} = 0

   temp5 = rand : if temp5 < 128 then goto __Skip_UD_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks up.
   ;
   temp3 = (player1x-17)/4

   temp6 = (player1y/4)-2

   if pfread(temp3,temp6) then goto __Skip_UD_Check

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Skip_UD_Check

   _Bit4_P1_Dir_Up{4} = 1 : _Bit5_Direction_Changed{5}=1 : return

__Skip_UD_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks down.
   ;
   temp3 = (player1x-17)/4

   temp6 = (player1y/4) + 1

   if pfread(temp3,temp6) then goto __Skip_U_Check

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Skip_U_Check

   _Bit5_P1_Dir_Down{5} = 1 : _Bit5_Direction_Changed{5} = 1 : return

__Skip_U_Check

   ;```````````````````````````````````````````````````````````````
   ;  Looks up.
   ;
   temp3 = (player1x-17)/4

   temp6 = (player1y/4)-2

   if pfread(temp3,temp6) then return

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then return

   _Bit4_P1_Dir_Up{4} = 1 : _Bit5_Direction_Changed{5} = 1 : return



   bank 3



   bank 4



   ;****************************************************************
   ;
   ;  I'm using vblank to avoid having a scanline count over 262.
   ;
   vblank

   if !_Bit3_vblank{3} then goto __Done_Player_Section


   ;****************************************************************
   ;
   ;  Joy0 up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the up bit is off or the joystick
   ;  isn't moved up.
   ;
   if _Bit0_P0_Dir_Up{0} then goto __Test_P0_Up

   if joy0up then goto __Test_P0_Up

   goto __Skip_Joy0_Up

__Test_P0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Converts player0 sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp3 = (player0x-17)/4

   temp6 = (player0y/4)-2

   if pfread(temp3,temp6) then goto __Cant_Move_Up

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Cant_Move_Up

   goto __P0_Move_Up

__Cant_Move_Up

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel is in the way.
   ;  Shows up frame only if up bit is on. Clears the up bit and
   ;  skips this section.
   ;
   if _Bit0_P0_Dir_Up{0} then gosub __Frame_U_01

   _Bit0_P0_Dir_Up{0} = 0

   goto __Skip_Joy0_Up

__P0_Move_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 up only if sprite is lined up with playfield.
   ;
   temp5 = (temp3*4)+17

   if temp5 <> player0x then goto __Skip_Joy0_Up

   _P0_U_D = _P0_U_D - 0.85

   ;```````````````````````````````````````````````````````````````
   ;  Sprite animation.
   ;
   on _Frame_Counter gosub __Frame_U_00 __Frame_U_01 __Frame_U_02 __Frame_U_01

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits and turns on the up direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %11110000

   _Bit0_P0_Dir_Up{0} = 1

__Skip_Joy0_Up



   ;****************************************************************
   ;
   ;  Joy0 down check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the down bit is off or the joystick
   ;  isn't moved down.
   ;
   if _Bit1_P0_Dir_Down{1} then goto __Test_P0_Down

   if joy0down then goto __Test_P0_Down

   goto __Skip_Joy0_Down

__Test_P0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Converts player0 sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp3 = (player0x-17)/4

   temp6 = ((player0y-3)/4) + 1

   if pfread(temp3,temp6) then goto __Cant_Move_Down

   temp5 = temp3 + 1

   if pfread(temp5,temp6) then goto __Cant_Move_Down

   goto __P0_Move_Down

__Cant_Move_Down

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel is in the way.
   ;  Shows down frame only if down bit is on. Clears the down bit
   ;  and skips this section.
   ;
   if _Bit1_P0_Dir_Down{1} then gosub __Frame_D_01

   _Bit1_P0_Dir_Down{1} = 0

   goto __Skip_Joy0_Down

__P0_Move_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves Player0 down only if sprite is lined up with playfield.
   ;
   temp5 = (temp3*4) + 17

   if temp5 <> player0x then goto __Skip_Joy0_Down

   _P0_U_D = _P0_U_D + 0.85

   ;```````````````````````````````````````````````````````````````
   ;  Sprite animation.
   ;
   on _Frame_Counter gosub __Frame_D_00 __Frame_D_01 __Frame_D_02 __Frame_D_01

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits and turns on the down direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %11110000

   _Bit1_P0_Dir_Down{1} = 1

__Skip_Joy0_Down



   ;****************************************************************
   ;
   ;  Joy0 left check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the left bit is off or the joystick
   ;  isn't moved left.
   ;
   if _Bit2_P0_Dir_Left{2} then goto __Test_P0_Left

   if joy0left then goto __Test_P0_Left

   goto __Skip_Joy0_Left

__Test_P0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Converts player0 sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp5 = ((player0x-14)/4)-1

   temp6 = (player0y-7)/4

   if pfread(temp5,temp6) then goto __Cant_Move_Left

   temp3 = temp6 + 1

   if pfread(temp5,temp3) then goto __Cant_Move_Left

   goto __P0_Move_Left

__Cant_Move_Left

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel is in the way.
   ;  Shows left frame only if left bit is on. Clears the left bit
   ;  and skips this section.
   ;
   if _Bit2_P0_Dir_Left{2} then gosub __Frame_LR_01

   _Bit2_P0_Dir_Left{2} = 0

   goto __Skip_Joy0_Left

__P0_Move_Left

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 left only if sprite is lined up with playfield.
   ;
   temp5 = (temp6*4)+7

   if temp5 <> player0y then goto __Skip_Joy0_Left

   _P0_L_R = _P0_L_R - 0.85

   ;```````````````````````````````````````````````````````````````
   ;  Sprite animation.
   ;
   on _Frame_Counter gosub __Frame_LR_00 __Frame_LR_01 __Frame_LR_02 __Frame_LR_01

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player sprite is facing the correct direction.
   ;
   _Bit6_Flip_P0{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits and turns on the left direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %11110000

   _Bit2_P0_Dir_Left{2} = 1

__Skip_Joy0_Left



   ;****************************************************************
   ;
   ;  Joy0 right check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the right bit is off or the joystick
   ;  isn't moved right.
   ;
   if _Bit3_P0_Dir_Right{3} then goto __Test_P0_Right

   if joy0right then goto __Test_P0_Right

   goto __Skip_Joy0_Right

__Test_P0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Converts player0 sprite coordinates and checks to see if
   ;  any playfield pixels are in the way.
   ;
   temp5 = ((player0x-13)/4)+1

   temp6 = ((player0y-7)/4)

   if pfread(temp5,temp6) then goto __Cant_Move_Right

   temp3 = (temp6)+1

   if pfread(temp5,temp3) then goto __Cant_Move_Right

   goto __P0_Move_Right

__Cant_Move_Right

   ;```````````````````````````````````````````````````````````````
   ;  Playfield pixel is in the way.
   ;  Shows right frame only if right bit is on. Clears the right
   ;  bit and skips this section.
   ;
   if _Bit3_P0_Dir_Right{3} then gosub __Frame_LR_01

   _Bit3_P0_Dir_Right{3} = 0

   goto __Skip_Joy0_Right

__P0_Move_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves Player0 right only if sprite is lined up with playfield.
   ;
   temp5 = (temp6*4)+7

   if temp5 <> player0y then goto __Skip_Joy0_Right

   _P0_L_R = _P0_L_R + 0.85

   ;```````````````````````````````````````````````````````````````
   ;  Sprite animation.
   ;
   on _Frame_Counter gosub __Frame_LR_00 __Frame_LR_01 __Frame_LR_02 __Frame_LR_01

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player sprite is facing the correct direction.
   ;
   _Bit6_Flip_P0{6} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits and turns on the right direction bit.
   ;
   _BitOp_P0_P1_Dir = _BitOp_P0_P1_Dir & %11110000

   _Bit3_P0_Dir_Right{3} = 1

__Skip_Joy0_Right

__Done_Player_Section

   _Bit3_vblank{3} = 0

   return



   ;****************************************************************
   ;
   ;  Left/right animation frames for player.
   ;
__Frame_LR_00
   player0:
   %01111100
   %11111110
   %11111110
   %11110000
   %11111110
   %11111110
   %01111100
end

   return


__Frame_LR_01
   player0:
   %01111100
   %11111110
   %11111000
   %11100000
   %11111000
   %11111110
   %01111100
end

   return


__Frame_LR_02
   player0:
   %01111100
   %11111000
   %11110000
   %11100000
   %11110000
   %11111000
   %01111100
end

   return


   ;****************************************************************
   ;
   ;  Up animation frames for player.
   ;
__Frame_U_00
   player0:
   %01111100
   %11111110
   %11111110
   %11111110
   %11101110
   %11101110
   %01101100
end

   return


__Frame_U_01
   player0:
   %01111100
   %11111110
   %11111110
   %11101110
   %11101110
   %11000110
   %01000100
end

   return


__Frame_U_02
   player0:
   %01111100
   %11111110
   %11111110
   %11101110
   %11000110
   %10000010
   %00000000
end

   return


   ;****************************************************************
   ;
   ;  Down animation frames for player.
   ;
__Frame_D_00
   player0:
   %01101100
   %11101110
   %11101110
   %11111110
   %11111110
   %11111110
   %01111100
end

   return


__Frame_D_01
   player0:
   %01000100
   %11000110
   %11101110
   %11101110
   %11111110
   %11111110
   %01111100
end

   return


__Frame_D_02
   player0:
   %00000000
   %10000010
   %11000110
   %11101110
   %11111110
   %11111110
   %01111100
end

   return