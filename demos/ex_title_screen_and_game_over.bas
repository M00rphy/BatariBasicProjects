   ;****************************************************************
   ;
   ;  Title Screen and Game Over With Bankswitching
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;  High score code provided by supercat and polished up
   ;  by Nukey Shay.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  About this program:
   ;  
   ;  Besides being a working example of bankswitching, this
   ;  example program shows different parts of a game. There
   ;  is a fake title screen, a fake game, and a game over
   ;  screen with an initial 2 second freeze. The game over screen
   ;  also flips between the current score and the high score
   ;  every 2 seconds.
   ;
   ;  The fake title screen is displayed for 10 seconds, then it
   ;  switches to auto-play. The current score and high score are
   ;  also displayed during auto-play (just like on the game over
   ;  screen). This attract mode sequence repeats until you press
   ;  the reset switch or the fire button on the left joystick.
   ;
   ;  After you start the fake game, move the sprite with the left
   ;  joystick and press the fire button to shoot missiles. Add to
   ;  the score by shooting the walls with the missiles or by
   ;  shooting the enemy sprite.
   ;
   ;  To pause the fake game on an Atari 2600, flip the COLOR/BW
   ;  switch. To pause on an Atari 7800, press the pause button.
   ;  You can also pause the fake game by pressing the fire button
   ;  on the right controller. To resume play, press and release
   ;  the fire button on the left controller.
   ;
   ;  End the fake game by touching the enemy sprite.
   ;
   ;  Pressing the reset switch during the fake game will take you
   ;  back to the fake title screen. Pressing the reset switch or
   ;  the fire button while on the game over screen will restart
   ;  the fake game and skip the fake title screen. If you do
   ;  nothing for 20 seconds while on the game over screen, you'll
   ;  go back to the fake title screen.
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
   ;  Multicolored playfield and no blank lines.
   ;  Cost: loss of missile0.
   ;
   set kernel_options pfcolors no_blank_lines



   ;***************************************************************
   ;
   ;  This program has 8 banks (32k/4k = 8 banks).
   ;
   set romsize 32k



   ;***************************************************************
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
   ;  _Master_Counter can be used for many things, but it is 
   ;  really useful for animating sprite frames when used
   ;  with _Frame_Counter.
   ;
   dim _Master_Counter = e
   dim _Frame_Counter = f

   ;```````````````````````````````````````````````````````````````
   ;  Player0/missile1 direction bits.
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
   player0y = 200 : player1y = 200 : missile1y = 200


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
   ;
   ;  Sets score color for title screen.
   ;
   scorecolor = 0


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


   ;***************************************************************
   ;
   ;  Sets up title screen playfield.
   ;
   playfield:
   .XXXXXX.XXXXXX.XXXXXXXXXX.XXXXX.
   .XX.....XX..XX.XX..XX..XX.XX....
   .XX.XXX.XXXXXX.XX..XX..XX.XXXX..
   .XX..XX.XX..XX.XX..XX..XX.XX....
   .XXXXXX.XX..XX.XX..XX..XX.XXXXX.
   ................................
   ..XXXXXX.XX.XXXXXX.XX....XXXXX..
   ....XX...XX...XX...XX....XX.....
   ....XX...XX...XX...XX....XXXX...
   ....XX...XX...XX...XX....XX.....
   ....XX...XX...XX...XXXXX.XXXXX..
end





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
   pfcolors:
   $6E
   $6E
   $6C
   $6A
   $68
   $66
   $6E
   $6E
   $6C
   $6A
   $68
   $66
end



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
   if _Master_Counter < 60 then goto __TS_AP_Skip

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
   player0x = 77 : player0y = 53


   ;***************************************************************
   ;
   ;  Sets score color.
   ;
   scorecolor = $1C


   ;***************************************************************
   ;
   ;  Defines missile1 height.
   ;
   missile1height = 1


   ;***************************************************************
   ;
   ;  Sets beginning direction that missile1 will shoot if the
   ;  player doesn't move.
   ;
   _Bit3_P0_Dir_Right{3} = 1


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
   ;  Sets starting position of enemy.
   ;
   player1y = (rand&63) + 15 : temp5 = rand

   if temp5 > 128 then player1x = (rand&7) + 5 : goto __Skip_Enemy_Setup

   player1x = (rand&7) + 140

__Skip_Enemy_Setup


   ;***************************************************************
   ;
   ;  Sets up the main loop playfield.
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
   ;  Sets background color.
   ;
   COLUBK = 0



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
   ;  Sets missile1 width.
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
   if player0y > 85 then _T5_AP_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 7

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes down/right or down/left if it is near top.
   ;
   if player0y < 12 then _T5_AP_Dir = 3 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes up/left or down/left if it's near right side.
   ;
   if player0x > 148 then _T5_AP_Dir = 7 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Sprite goes up/right or down/right if it's near left side.
   ;
   if player0x < 4 then _T5_AP_Dir = 1 : temp6 = rand : if temp6 > 128 then _T5_AP_Dir = 3

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
   ;  Skips this section if hitting the edge.
   ;
   if player0y <= _P_Edge_Top then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player0x-10)/4

   temp4 = (player0x-17)/4

   temp3 = temp5 - 1

   temp6 = (player0y-9)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Up

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Up

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
   ;  Skips this section if hitting the edge.
   ;
   if player0y >= _P_Edge_Bottom then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player0x-10)/4

   temp4 = (player0x-17)/4

   temp3 = temp5 - 1

   temp6 = (player0y+1)/8

   if temp5 < 34 then if pfread(temp5,temp6) then goto __Skip_Joy0_Down

   if temp4 < 34 then if pfread(temp4,temp6) then goto __Skip_Joy0_Down

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
   ;  Skips this section if hitting the edge.
   ;
   if player0x <= _P_Edge_Left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player0y)/8

   temp3 = (player0y-8)/8

   temp6 = (player0x-18)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Left

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
   ;  Skips this section if hitting the edge.
   ;
   if player0x >= _P_Edge_Right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player0y)/8

   temp3 = (player0y-8)/8

   temp6 = (player0x-9)/4

   if temp6 < 34 then if pfread(temp6,temp5) then goto __Skip_Joy0_Right

   if temp6 < 34 then if pfread(temp6,temp3) then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 right.
   ;
   player0x = player0x + 1

__Skip_Joy0_Right



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
   if _AP_Mem_P0x = player0x && _AP_Mem_P0y = player0y then _AP_Dir_Counter = 254

   ;```````````````````````````````````````````````````````````````
   ;  Remembers sprite position during auto-play.
   ;
   _AP_Mem_P0x = player0x : _AP_Mem_P0y = player0y

__AP_Inactivity



   ;***************************************************************
   ;
   ;  Fire button check.
   ;  
   ;  Turns on missile1 movement if fire button is pressed and
   ;  missile1 is not moving.
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
   ;  Skips this section if missile1 is moving.
   ;
   if _Bit7_M1_Moving{7} then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on missile1 movement.
   ;
   _Bit7_M1_Moving{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Takes a 'snapshot' of player0 direction so missile1 will
   ;  stay on track until it hits something.
   ;
   _Bit4_M1_Dir_Up{4} = _Bit0_P0_Dir_Up{0}
   _Bit5_M1_Dir_Down{5} = _Bit1_P0_Dir_Down{1}
   _Bit6_M1_Dir_Left{6} = _Bit2_P0_Dir_Left{2}
   _Bit7_M1_Dir_Right{7} = _Bit3_P0_Dir_Right{3}

   ;```````````````````````````````````````````````````````````````
   ;  Sets up starting position of missile1.
   ;
   if _Bit4_M1_Dir_Up{4} then missile1x = player0x + 4 : missile1y = player0y - 5
   if _Bit5_M1_Dir_Down{5} then missile1x = player0x + 4 : missile1y = player0y - 1
   if _Bit6_M1_Dir_Left{6} then missile1x = player0x + 2 : missile1y = player0y - 3
   if _Bit7_M1_Dir_Right{7} then missile1x = player0x + 6 : missile1y = player0y - 3

__Skip_Fire



   ;***************************************************************
   ;
   ;  Missile1 movement check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if missile1 isn't moving.
   ;
   if !_Bit7_M1_Moving{7} then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Moves missile1 in the appropriate direction.
   ;
   if _Bit4_M1_Dir_Up{4} then missile1y = missile1y - 2
   if _Bit5_M1_Dir_Down{5} then missile1y = missile1y + 2
   if _Bit6_M1_Dir_Left{6} then missile1x = missile1x - 2
   if _Bit7_M1_Dir_Right{7} then missile1x = missile1x + 2

   ;```````````````````````````````````````````````````````````````
   ;  Clears missile1 if it hits the edge of the screen.
   ;
   if missile1y < _M_Edge_Top then goto __Delete_Missile
   if missile1y > _M_Edge_Bottom then goto __Delete_Missile
   if missile1x < _M_Edge_Left then goto __Delete_Missile
   if missile1x > _M_Edge_Right then goto __Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Skips rest of section if no collision.
   ;
   if !collision(playfield,missile1) then goto __Skip_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Skips points if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Adds a point to the score.
   ;
   score = score + 1

__Delete_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Clears Missile1_Moving bit and moves missile1 off screen.
   ;
   _Bit7_M1_Moving{7} = 0 : missile1x = 200 : missile1y = 200

__Skip_Missile



   ;***************************************************************
   ;
   ;  Ends the fake game if player0 touches player1.
   ;
   if collision(player0,player1) then _Bit2_Game_Control{2} = 1



   ;***************************************************************
   ;
   ;  Enemy/missile collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player1,missile1) then goto __Skip_Shot_Enemy

   ;```````````````````````````````````````````````````````````````
   ;  Clears missile1 bit and moves missile1 off the screen.
   ;
   _Bit7_M1_Moving{7} = 0 : missile1x = 200 : missile1y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Skips points if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __AP_Skip_Enemy_Points

   ;```````````````````````````````````````````````````````````````
   ;  Adds 20 points to the score.
   ;
   score = score + 20

__AP_Skip_Enemy_Points

   ;```````````````````````````````````````````````````````````````
   ;  Places enemy in new location based on location of player.
   ;
   player1y = (rand&63) + 15

   if player0x >= 77 then player1x = (rand&7) + 5 : goto __Skip_Shot_Enemy

   player1x = (rand&7) + 140

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
   player0y = 200 : player1y = 200 : missile1y = 200


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
   ;  Sets missile1 width.
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



   bank 5



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