   ;***************************************************************
   ;
   ;  Sound Example With Background "Music"
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
   ;  Use the joystick to move the sprite. Press the fire button
   ;  to shoot the missile. There is a sound effect on channel 0
   ;  for shooting a missile, hitting a wall with a missile,
   ;  hitting the enemy with a missile, and when the player and
   ;  enemy touch. Channel 1 is used for the background "music."
   ;  
   ;```````````````````````````````````````````````````````````````
   ;
   ;  If this program will not compile for you, get the latest
   ;  version of batari Basic:
   ;  
   ;  http://www.randomterrain.com/atari-2600-memories-batari-basic-commands.html#gettingstarted
   ;  
   ;***************************************************************


   ;***************************************************************
   ;
   ;  This program has 8 banks (32k/4k = 8 banks).
   ;
   set romsize 32k



   ;***************************************************************
   ;
   ;  Random numbers can slow down bankswitched games. This will
   ;  speed things up.
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
   ;  Player0/missile0 direction bits.
   ;
   dim _BitOp_P0_M0_Dir = g
   dim _Bit0_P0_Dir_Up = g
   dim _Bit1_P0_Dir_Down = g
   dim _Bit2_P0_Dir_Left = g
   dim _Bit3_P0_Dir_Right = g
   dim _Bit4_M0_Dir_Up = g
   dim _Bit5_M0_Dir_Down = g
   dim _Bit6_M0_Dir_Left = g
   dim _Bit7_M0_Dir_Right = g

   ;```````````````````````````````````````````````````````````````
   ;  Enemy direction bits.
   ;
   dim _BitOp_P1_Dir = h
   dim _Bit0_P1_Dir_Up = h
   dim _Bit1_P1_Dir_Down = h
   dim _Bit2_P1_Dir_Left = h
   dim _Bit3_P1_Dir_Right = h

   ;```````````````````````````````````````````````````````````````
   ;  Helps the program know when it's time for the enemy to
   ;  change direction.
   ;
   dim _Enemy_Counter = i

   ;```````````````````````````````````````````````````````````````
   ;  Enemy direction.
   ;  0 = up, 1 = up/right, 2 = right, 3 = down/right, 4 = down,
   ;  5 = down/left, 6 = left, 7 = up/left.
   ;
   dim _T5_Enemy_Dir = temp5

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the opposite direction the enemy moved. Keeps the
   ;  enemy sprite from bouncing back and forth between the same
   ;  two directions like a ping-pong ball.
   ;
   dim _Mem_E_Dir = j

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the last position of the enemy. A new direction is
   ;  chosen if the enemy stops moving.
   ;
   dim _Mem_P1x = k
   dim _Mem_P1y = l

   ;```````````````````````````````````````````````````````````````
   ;  Channel 0 sound variables.
   ;
   dim _Ch0_Sound = q
   dim _Ch0_Duration = r
   dim _Ch0_Counter = s

   ;```````````````````````````````````````````````````````````````
   ;  Channel 1 sound variables.
   ;
   dim _Ch1_Duration = t
  
   ;```````````````````````````````````````````````````````````````
   ;  u and v used for channel 1 sdata.
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

   ;```````````````````````````````````````````````````````````````
   ;  Bits that do various jobs.
   ;
   dim _Bit0_Reset_Restrainer = y
   dim _Bit7_M0_Moving = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers.
   ;
   dim rand16 = z



   ;***************************************************************
   ;
   ;  Defines the edges of the playfield for an 8 x 8 sprite.
   ;  If your sprite is a different size, you'll need to adjust
   ;  the numbers.
   ;
   const _P_Edge_Top = 9
   const _P_Edge_Bottom = 88
   const _P_Edge_Left = 1
   const _P_Edge_Right = 152



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
   ;
   ;  Disables the score. (We don't need it in this program.)
   ;
   const noscore = 1





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
   ;  Clears all normal variables except for z (used for rand).
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0


   ;***************************************************************
   ;
   ;  Sets starting position of enemy.
   ;
   player1y = (rand&63) + 15 : temp5 = rand

   if temp5 > 128 then player1x = (rand&7) + 5 : goto __Skip_Enemy_Setup

   player1x = (rand&7) + 140

__Skip_Enemy_Setup


   ;***************************************************************
   ;
   ;  Sets starting position of player0.
   ;
   player0x = 77 : player0y = 53


   ;***************************************************************
   ;
   ;  Makes sure missile0 is off the screen.
   ;
   missile0x = 200 : missile0y = 200


   ;***************************************************************
   ;
   ;  Defines missile0 height.
   ;
   missile0height = 1


   ;***************************************************************
   ;
   ;  Sets playfield color.
   ;
   COLUPF = $FC


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = 0


   ;***************************************************************
   ;
   ;  Sets beginning direction that missile0 will shoot if the
   ;  player doesn't move.
   ;
   _Bit3_P0_Dir_Right{3} = 1


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
   ;  Defines shape of player0 sprite.
   ;
   player0:
   %00111100
   %01111110
   %11000011
   %10111101
   %11111111
   %11011011
   %01111110
   %00111100
end


   ;***************************************************************
   ;
   ;  Defines shape of player1 sprite.
   ;
   player1:
   %00111100
   %01111110
   %11000011
   %11111111
   %11111111
   %11011011
   %01111110
   %00111100
end


   ;***************************************************************
   ;
   ;  Sets up the playfield.
   ;
   playfield:
   ................................
   ................................
   ....XXXXXXXXXX....XXXXXXXXXX....
   ....X......................X....
   ....X......................X....
   ....X......................X....
   ................................
   ................................
   ....XXXX....XXX..XXX....XXXX....
   ................................
   ................................
end


   ;***************************************************************
   ;
   ;  Starts the background "music."
   ;
   goto __BG_Music_Setup_01 bank2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets color of player0 sprite and missile.
   ;
   COLUP0 = $9C



   ;***************************************************************
   ;
   ;  Sets color of player1 sprite.
   ;
   COLUP1 = $44



   ;***************************************************************
   ;
   ;  Defines missile0 width.
   ;
   NUSIZ0 = $10



   ;***************************************************************
   ;
   ;  Joystick movement precheck.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if joystick hasn't been moved.
   ;
   if !joy0up && !joy0down && !joy0left && !joy0right then goto __Skip_Joystick_Precheck

   ;```````````````````````````````````````````````````````````````
   ;  Clears player0 direction bits since joystick has been moved.
   ;
   _BitOp_P0_M0_Dir = _BitOp_P0_M0_Dir & %11110000

__Skip_Joystick_Precheck



   ;***************************************************************
   ;
   ;  Joy0 up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved up.
   ;
   if !joy0up then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the up direction bit.
   ;
   _Bit0_P0_Dir_Up{0} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player0y <= _P_Edge_Top then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 up if a pfpixel is not in the way.
   ;
   temp5 = (player0x-10)/4

   temp6 = (player0y-9)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Up

   temp4 = (player0x-17)/4

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Up

   temp3 = temp5 - 1

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 up.
   ;
   player0y = player0y - 1

__Skip_Joy0_Up



   ;***************************************************************
   ;
   ;  Joy0 down check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved down.
   ;
   if !joy0down then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the down direction bit.
   ;
   _Bit1_P0_Dir_Down{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player0y >= _P_Edge_Bottom then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 down if a pfpixel is not in the way.
   ;
   temp5 = (player0x-10)/4

   temp6 = (player0y)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Down

   temp4 = (player0x-17)/4

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Down

   temp3 = temp5 - 1

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 down.
   ;
   player0y = player0y + 1

__Skip_Joy0_Down



   ;***************************************************************
   ;
   ;  Joy0 left check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved to the left.
   ;
   if !joy0left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the left direction bit.
   ;
   _Bit2_P0_Dir_Left{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player0x <= _P_Edge_Left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 left if a pfpixel is not in the way.
   ;
   temp5 = (player0y-1)/8

   temp6 = (player0x-18)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Left

   temp3 = (player0y-8)/8

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 left.
   ;
   player0x = player0x - 1

__Skip_Joy0_Left



   ;***************************************************************
   ;
   ;  Joy0 right check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved to the right.
   ;
   if !joy0right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the right direction bit.
   ;
   _Bit3_P0_Dir_Right{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player0x >= _P_Edge_Right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 right if a pfpixel is not in the way.
   ;
   temp5 = (player0y-1)/8

   temp6 = (player0x-9)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Right

   temp3 = (player0y-8)/8

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 right.
   ;
   player0x = player0x + 1

__Skip_Joy0_Right




   ;***************************************************************
   ;
   ;  Fire button check.
   ;  
   ;  Turns on missile0 movement if fire button is pressed and
   ;  missile0 is not moving.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the fire button is not pressed.
   ;
   if !joy0fire then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if missile0 is moving.
   ;
   if _Bit7_M0_Moving{7} then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on missile0 movement.
   ;
   _Bit7_M0_Moving{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Takes a 'snapshot' of player0 direction so missile0 will
   ;  stay on track until it hits something.
   ;
   _Bit4_M0_Dir_Up{4} = _Bit0_P0_Dir_Up{0}
   _Bit5_M0_Dir_Down{5} = _Bit1_P0_Dir_Down{1}
   _Bit6_M0_Dir_Left{6} = _Bit2_P0_Dir_Left{2}
   _Bit7_M0_Dir_Right{7} = _Bit3_P0_Dir_Right{3}

   ;```````````````````````````````````````````````````````````````
   ;  Sets up starting position of missile0.
   ;
   if _Bit4_M0_Dir_Up{4} then missile0x = player0x + 4 : missile0y = player0y - 5
   if _Bit5_M0_Dir_Down{5} then missile0x = player0x + 4 : missile0y = player0y - 1
   if _Bit6_M0_Dir_Left{6} then missile0x = player0x + 2 : missile0y = player0y - 3
   if _Bit7_M0_Dir_Right{7} then missile0x = player0x + 6 : missile0y = player0y - 3

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect.
   ;
   if _Ch0_Sound <> 3 then _Ch0_Sound = 2 : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Skip_Fire



   ;***************************************************************
   ;
   ;  Missile0 movement check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if missile0 isn't moving.
   ;
   if !_Bit7_M0_Moving{7} then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Moves missile0 in the appropriate direction.
   ;
   if _Bit4_M0_Dir_Up{4} then missile0y = missile0y - 2
   if _Bit5_M0_Dir_Down{5} then missile0y = missile0y + 2
   if _Bit6_M0_Dir_Left{6} then missile0x = missile0x - 2
   if _Bit7_M0_Dir_Right{7} then missile0x = missile0x + 2

   ;```````````````````````````````````````````````````````````````
   ;  Clears missile0 if it hits the edge of the screen.
   ;
   if missile0y < _M_Edge_Top then goto __Delete_Missile
   if missile0y > _M_Edge_Bottom then goto __Delete_Missile
   if missile0x < _M_Edge_Left then goto __Delete_Missile
   if missile0x > _M_Edge_Right then goto __Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Skips rest of section if no collision.
   ;
   if !collision(playfield,missile0) then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect.
   ;
   if _Ch0_Sound <> 3 then _Ch0_Sound = 1 : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Clears missile0 bit and moves missile0 off the screen.
   ;
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200
   
__Skip_Missile



   ;***************************************************************
   ;
   ;  Enemy/missile collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player1,missile0) then goto __Skip_Shot_Enemy

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect.
   ;
   _Ch0_Sound = 3 : _Ch0_Duration = 1 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears missile0 bit and moves missile0 off the screen.
   ;
   _Bit7_M0_Moving{7} = 0 : missile0x = 200 : missile0y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Places enemy in new location based on location of player.
   ;
   player1y = (rand&63) + 15

   if player0x >= 77 then player1x = (rand&7) + 5 : goto __Skip_Shot_Enemy

   player1x = (rand&7) + 140

__Skip_Shot_Enemy



   ;***************************************************************
   ;
   ;  Enemy/player collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player1,player0) then goto __Skip_P0_Touched_Enemy

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect.
   ;
   if _Ch0_Sound <> 4 then _Ch0_Sound = 4 : _Ch0_Duration = 1 : _Ch0_Counter = 0

__Skip_P0_Touched_Enemy



   ;***************************************************************
   ;
   ;  Enemy direction change.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Adds to the enemy counter.
   ;
   _Enemy_Counter = _Enemy_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Forces a direction change when the counter gets too high or
   ;  when it's set high on purpose because the enemy was inactive.
   ;
   if _Enemy_Counter > 254 then goto __Get_New_E_Direction

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 63) and adds 50. Change 50 to a
   ;  larger number if you want the enemy to move longer before
   ;  changing directions. Don't use a number larger than 190.
   ;
   temp6 = (rand&63) + 50

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if the counter isn't high enough.
   ;
   if _Enemy_Counter < temp6 then goto __Skip_New_E_Dir

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 255).
   ;
   temp5 = rand

   ;```````````````````````````````````````````````````````````````
   ;  There is a 90% chance that this section will be skipped.
   ;
   if temp5 < 230 then goto __Skip_New_E_Dir

__Get_New_E_Direction

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a new enemy direction from a random number (0 to 7).
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
   _T5_Enemy_Dir = (rand&7)

   ;```````````````````````````````````````````````````````````````
   ;  Compares the new enemy direction with the opposite direction
   ;  and selects a new direction if there is a match. This keeps
   ;  the enemy from bouncing back and forth between the same two
   ;  directions.
   ;
   if _T5_Enemy_Dir = _Mem_E_Dir then _T5_Enemy_Dir = _T5_Enemy_Dir + (rand&1) + (rand&3) + 2 : if _T5_Enemy_Dir > 7 then _T5_Enemy_Dir = _T5_Enemy_Dir - 8

   ;```````````````````````````````````````````````````````````````
   ;  Enemy goes up/right or up/left if it is near bottom.
   ;
   if player1y > 85 then _T5_Enemy_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_Enemy_Dir = 7

   ;```````````````````````````````````````````````````````````````
   ;  Enemy goes down/right or down/left if it is near top.
   ;
   if player1y < 12 then _T5_Enemy_Dir = 3 : temp6 = rand : if temp6 > 128 then _T5_Enemy_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Enemy goes up/left or down/left if it's near right side.
   ;
   if player1x > 148 then _T5_Enemy_Dir = 7 : temp6 = rand : if temp6 > 128 then _T5_Enemy_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Enemy goes up/right or down/right if it's near left side.
   ;
   if player1x < 4 then _T5_Enemy_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_Enemy_Dir = 3

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the opposite direction the enemy is moving. Keeps
   ;  the enemy from bouncing back and forth between the same two
   ;  directions.
   ;
   _Mem_E_Dir = _T5_Enemy_Dir + 4 : if _Mem_E_Dir > 7 then _Mem_E_Dir = _Mem_E_Dir - 8

   ;```````````````````````````````````````````````````````````````
   ;  Clears counter and enemy direction bits.
   ;
   _Enemy_Counter = 0 : _BitOp_P1_Dir = _BitOp_P1_Dir & %11110000

   ;```````````````````````````````````````````````````````````````
   ;  Converts enemy direction to bits to make things easier.
   ;
   if _T5_Enemy_Dir = 0 then _Bit0_P1_Dir_Up{0} = 1
   if _T5_Enemy_Dir = 1 then _Bit0_P1_Dir_Up{0} = 1 : _Bit3_P1_Dir_Right{3} = 1
   if _T5_Enemy_Dir = 2 then _Bit3_P1_Dir_Right{3} = 1
   if _T5_Enemy_Dir = 3 then _Bit1_P1_Dir_Down{1} = 1 : _Bit3_P1_Dir_Right{3} = 1
   if _T5_Enemy_Dir = 4 then _Bit1_P1_Dir_Down{1} = 1
   if _T5_Enemy_Dir = 5 then _Bit1_P1_Dir_Down{1} = 1 : _Bit2_P1_Dir_Left{2} = 1
   if _T5_Enemy_Dir = 6 then _Bit2_P1_Dir_Left{2} = 1
   if _T5_Enemy_Dir = 7 then _Bit0_P1_Dir_Up{0} = 1 : _Bit2_P1_Dir_Left{2} = 1

__Skip_New_E_Dir



   ;***************************************************************
   ;
   ;  Enemy up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy isn't moving up.
   ;
   if !_Bit0_P1_Dir_Up{0} then goto __Skip_Enemy_Up

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player1y <= _P_Edge_Top then goto __Skip_Enemy_Up

   ;```````````````````````````````````````````````````````````````
   ;  Checks for any playfield pixels that might be in the way.
   ;
   temp5 = (player1x-10)/4

   temp6 = (player1y-9)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Enemy_Up

   temp4 = (player1x-17)/4

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Enemy_Up

   temp3 = temp5 - 1

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Enemy_Up

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy up.
   ;
   player1y = player1y - 1

__Skip_Enemy_Up



   ;***************************************************************
   ;
   ;  Enemy down check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy isn't moving down.
   ;
   if !_Bit1_P1_Dir_Down{1} then goto __Skip_Enemy_Down

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player1y >= _P_Edge_Bottom then goto __Skip_Enemy_Down

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1x-10)/4

   temp6 = (player1y)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Enemy_Down

   temp4 = (player1x-17)/4

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Enemy_Down

   temp3 = temp5 - 1

   if temp3 < 34 then if pfread(temp3,temp6) then goto __Skip_Enemy_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy down.
   ;
   player1y = player1y + 1

__Skip_Enemy_Down



   ;***************************************************************
   ;
   ;  Enemy left check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy isn't moving left.
   ;
   if !_Bit2_P1_Dir_Left{2} then goto __Skip_Enemy_Left

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player1x <= _P_Edge_Left then goto __Skip_Enemy_Left

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1y-1)/8

   temp6 = (player1x-18)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Enemy_Left

   temp3 = (player1y-8)/8

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Enemy_Left

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy left.
   ;
   player1x = player1x - 1

__Skip_Enemy_Left



   ;***************************************************************
   ;
   ;  Enemy right check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if enemy isn't moving right.
   ;
   if !_Bit3_P1_Dir_Right{3} then goto __Skip_Enemy_Right

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hitting the edge.
   ;
   if player1x >= _P_Edge_Right then goto __Skip_Enemy_Right

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1y-1)/8

   temp6 = (player1x-9)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Enemy_Right

   temp3 = (player1y-8)/8

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Enemy_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves enemy right.
   ;
   player1x = player1x + 1

__Skip_Enemy_Right



   ;***************************************************************
   ;
   ;  Enemy inactivity check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Enemy gets a new direction if it is sitting still.
   ;
   if _Mem_P1x = player1x && _Mem_P1y = player1y then _Enemy_Counter = 254

   ;```````````````````````````````````````````````````````````````
   ;  Remembers enemy position.
   ;
   _Mem_P1x = player1x : _Mem_P1y = player1y



   ;***************************************************************
   ;
   ;  Code continues in next bank.
   ;
   goto __Code_Section_2 bank2




   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  End of first section of main loop.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 2
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Second section of main loop.
   ;
__Code_Section_2



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
   ;  Up sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> 1 then goto __Skip_Ch0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Shot_Wall[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shot_Wall[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 002.
   ;
   ;  Shoot missile sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 002 isn't on.
   ;
   if _Ch0_Sound <> 2 then goto __Skip_Ch0_Sound_002

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Shoot_Miss[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shoot_Miss[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_002



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 003.
   ;
   ;  Shoot enemy.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 003 isn't on.
   ;
   if _Ch0_Sound <> 3 then goto __Skip_Ch0_Sound_003

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Shoot_Enemy[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Shoot_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_003



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 004.
   ;
   ;  Touch enemy.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 004 isn't on.
   ;
   if _Ch0_Sound <> 4 then goto __Skip_Ch0_Sound_004

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Touch_Enemy[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Touch_Enemy[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_004



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
   ;  Channel 1 background music check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips music if left difficulty switch is set to A.
   ;
   if !switchleftb then AUDV1 = 0 : goto __Skip_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 1 duration counter.
   ;
   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 1 if duration counter is greater than zero.
   ;
   if _Ch1_Duration then goto __Skip_Ch_1



   ;***************************************************************
   ;
   ;  Channel 1 background music.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __BG_Music_Setup_01

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   temp5 = sread(_SD_Music01)
   temp6 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = sread(_SD_Music01)



   ;***************************************************************
   ;
   ;  End of channel 1 area.
   ;
__Skip_Ch_1



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
   ;  Turns off reset restrainer bit and jumps to beginning of
   ;  main loop if the reset switch is not pressed.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop bank1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of main loop if the reset switch hasn't
   ;  been released after being pressed.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop bank1

   ;```````````````````````````````````````````````````````````````
   ;  Restarts the program.
   ;
   goto __Start_Restart bank1





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  End of second section of main loop.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shot hitting wall.
   ;
   data _SD_Shot_Wall
   8,8,0
   1
   8,8,1
   1
   8,14,1
   1
   8,8,0
   1
   8,8,2
   1
   8,14,2
   1
   8,8,1
   1
   7,8,3
   1
   6,8,2
   1
   5,8,4
   1
   4,8,3
   1
   3,8,5
   1
   2,14,4
   4
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shooting missile.
   ;
   data _SD_Shoot_Miss
   8,15,0
   1
   12,15,1
   1
   8,7,20
   1
   10,15,3
   1
   8,7,22
   1
   10,15,5
   1
   8,15,6
   1
   10,7,24
   1
   8,15,8
   1
   9,7,27
   1
   8,15,10
   1
   7,14,11
   1
   6,15,12
   1
   5,6,13
   1
   4,15,14
   1
   3,6,27
   1
   2,6,30
   8
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for shooting enemy.
   ;
   data _SD_Shoot_Enemy
   12,4,23
   4
   10,4,29
   4
   8,4,23
   4
   6,4,29
   4
   4,4,23
   4
   3,4,29
   4
   2,4,23
   1
   1,4,29
   1
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for touching enemy.
   ;
   data _SD_Touch_Enemy
   2,7,11
   2
   10,7,12
   2
   8,7,13
   2
   8,7,14
   2
   8,7,21
   8
   4,7,22
   2
   2,7,23
   1
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Channel 1 background music sound data.
   ;
__BG_Music_Setup_01

   sdata _SD_Music01 = u
   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,26
   11

   8,12,23
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,26
   8
   2,8,2
   1
   2,12,26
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,26
   8
   2,8,2
   1
   3,12,26
   8

   4,8,2
   1
   2,12,26
   8
   2,8,2
   1
   1,12,26
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,24
   8
   2,8,2
   1
   2,12,24
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   3,12,31
   8

   4,8,2
   1
   2,12,31
   8
   2,8,2
   1
   1,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,19
   8
   2,8,2
   1
   2,12,19
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   3,12,15
   8
   
   4,8,2
   1
   2,12,15
   8
   2,8,2
   1
   1,12,15
   8


   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8


   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8



   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   3,12,20
   8


   4,8,2
   1
   2,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   3,12,17
   8

   4,8,2
   1
   2,12,17
   8
   2,8,2
   1
   1,12,17
   8

   4,8,2
   1
   8,12,14
   8
   2,8,2
   1
   3,12,14
   8

   4,8,2
   1
   2,12,14
   8
   2,8,2
   1
   1,12,14
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8
   255
end

   _Ch1_Duration = 1

   goto __Skip_Ch_1



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 3
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 4
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 5
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 6
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 7
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 8
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````