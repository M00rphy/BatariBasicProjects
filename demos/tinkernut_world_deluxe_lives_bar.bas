   ;****************************************************************
   ;
   ;  Tinkernut World Deluxe With Lives Bar
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) made by
   ;  adapting the original Tinkernut World from www.tinkernut.com
   ;  and using hints, tips, code snippets, and more from AtariAge
   ;  members such as batari, SeaGtGruff, RevEng, Robert M, Nukey
   ;  Shay, Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;  High score code provided by supercat and polished up by
   ;  Nukey Shay.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Instructions:
   ;  
   ;  Shoot the squirrel before he eats you.
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
   dim _Master_Counter = a
   dim _Frame_Counter = b

   ;```````````````````````````````````````````````````````````````
   ;  Sound variables.
   ;
   dim _Ch0_Sound = c
   dim _Ch0_Counter = d
   dim _C0 = e
   dim _V0 = f
   dim _F0 = g

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Counter_Tmp = h

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used for auto-play in the main loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _AP_2_Sec_Score_Flip = i

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Mem_Color_Tmp = i

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used for auto-play in the main loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _AP_Dir_Counter = j

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play or the pause feature.
   ;
   dim _Pause_Color_Tmp = j

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

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play direction bit for player0 sprite.
   ;
   dim _Bit3_AP_P0_Dir = r

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

   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Game_Control = y
   dim _Bit3_Auto_Play = y
   dim _Bit6_Swap_Scores = y
   dim _Bit7_Last_Life = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers. 
   ;
   dim rand16 = z



   ;***************************************************************
   ;
   ;  Turns on pfscore bars.
   ;
   const pfscore = 1



   ;***************************************************************
   ;
   ;  Defines the edges of the playfield for an 8 x 8 sprite.
   ;  If your sprite is a different size, you'll need to adjust
   ;  the numbers.
   ;
   const _P_Edge_Top = 10
   const _P_Edge_Bottom = 83
   const _P_Edge_Left = 1
   const _P_Edge_Right = 153





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
   player0y = 200 : player1y = 200 : missile0y = 200


   ;***************************************************************
   ;
   ;  Skips title screen if game has been played and player
   ;  presses fire button or reset switch at the end of the game.
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   if _Bit2_Game_Control{2} then goto __Main_Loop_Setup





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
   pfscore1 = 0 : scorecolor = $20


   ;***************************************************************
   ;
   ;  Sets title screen background color.
   ;
   COLUBK = $20


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
   XXX.X..X.X.X.XX.XX..X..X.X.X.XXX
   .X..X..X.X.X.X..X.X.X..X.X.X..X.
   .X..XX.X.XX..XX.XX..XX.X.X.X..X.
   .X..X.XX.X.X.X..X.X.X.XX.X.X..X.
   .X..X..X.X.X.XX.X.X.X..X.XXX..X.
   ................................
   ....X...X.XXXX.XXX..X...XXX.....
   ....X...X.X..X.X..X.X...X..X....
   ....X...X.X..X.XX...X...X..X....
   ....X.X.X.X..X.X.X..X...X..X....
   ....XX.XX.XXXX.X..X.XXX.XXX.....
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
   ;  Sets title screen playfield pixel color.
   ;
   COLUPF = $D8



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
   if _Frame_Counter > 9 then _Bit3_Auto_Play{3} = 1 : goto __Main_Loop_Setup

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
   ;  Starting position of player0 (acorn).
   ;
   player0x = 74 : player0y = 78


   ;***************************************************************
   ;
   ;  Starting position of player1 (squirrel).
   ;
   player1x = (rand/2) + (rand&15) : player1y = 0 


   ;***************************************************************
   ;
   ;  Defines missile0 height and location.
   ;
   missile0height = 4 : missile0y = 250


   ;***************************************************************
   ;
   ;  Sets score color.
   ;
   scorecolor = $1C


   ;***************************************************************
   ;
   ;  Sets number of lives and sets color.
   ;
   pfscore1 = %01010101 : pfscorecolor = $D2


   ;***************************************************************
   ;
   ;  Defines shape of player0 sprite.
   ;
   player0:
   %00011000
   %00111100
   %00111100
   %01111110
   %01111110
   %11111111
   %01111110
   %00011000
end


   ;***************************************************************
   ;
   ;  Sets up the main loop playfield.
   ;
   playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ...............................
   ...............................
   ...............................
   ...............................
   ...............................
   ...............................
   ...............................
   ...............................
   ...............................
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
   ;  Clears variables.
   ;
   _Master_Counter = 0 : _Frame_Counter = 0 

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
   COLUBK = $D6



   ;***************************************************************
   ;
   ;  Sets playfield pixel color.
   ;
   COLUPF = 0



   ;***************************************************************
   ;
   ;  Sets sprite colors.
   ;
   COLUP0 = $22 : COLUP1 = $20



   ;***************************************************************
   ;
   ;  Makes missile0 a little wider.
   ;
   NUSIZ0 = $10



   ;***************************************************************
   ;
   ;  Makes squirrel wider.
   ;
   NUSIZ1 = $05



   ;***************************************************************
   ;
   ;  Animation counters.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments _Master_Counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if _Master_Counter is less than 7.
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
   on _Frame_Counter goto __Sq00 __Sq01 __Sq02 __Sq03

__Squirrel_Frame_Done



   ;***************************************************************
   ;
   ;  Missile0 check and fire button check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Jumps to fire button check if missile0 is off the screen.
   ;
   if missile0y > 240 then goto __FireB_Check

   ;```````````````````````````````````````````````````````````````
   ;  Moves missile0 and skips fire button check.
   ;
   missile0y = missile0y - 2 : goto __Skip_FireB

__FireB_Check

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_Fire_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Determines if sprite should fire during auto-play.
   ;  There is a 90% chance that the missile will not fire.
   ;
   temp5 = rand : if temp5 < 230 then goto __Skip_FireB

   goto __AP_Fire

__AP_Skip_Fire_Missile

   ;```````````````````````````````````````````````````````````````
   ;  Clears the restrainer bit and skips this section if fire
   ;  button is not pressed.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_FireB

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if fire button hasn't been released since
   ;  the title screen.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Skip_FireB

__AP_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Starts the firing of missile0.
   ;
   missile0y = player0y - 2 : missile0x = player0x + 4

__Skip_FireB



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
   ;  Grabs a random number (0 to 63) and adds 50. Change 50 to a
   ;  larger number if you want the sprite to move longer before
   ;  changing directions. Don't use a number larger than 190.
   ;
   temp6 = (rand&63) + 50

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the counter isn't high enough.
   ;
   if _AP_Dir_Counter < temp6 then goto __AP_Move_Acorn

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 255).
   ;
   temp5 = rand

   ;```````````````````````````````````````````````````````````````
   ;  There is a 90% chance that this section will be skipped.
   ;
   if temp5 < 230 then goto __AP_Move_Acorn

   ;```````````````````````````````````````````````````````````````
   ;  Changes player0 direction.
   ;
   _Bit3_AP_P0_Dir{3} = !_Bit3_AP_P0_Dir{3}

   ;```````````````````````````````````````````````````````````````
   ;  Clears counter.
   ;
   _AP_Dir_Counter = 0

__AP_Move_Acorn

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 sprite.
   ;
   if !_Bit3_AP_P0_Dir{3} then if player0x > _P_Edge_Left then player0x = player0x - 1
   if _Bit3_AP_P0_Dir{3} then if player0x < _P_Edge_Right then player0x = player0x + 1

   goto __Skip_Joy_Movement

__AP_Skip_New_Dir



   ;***************************************************************
   ;
   ;  Joystick movement check. This section is skipped if
   ;  auto-play is on.
   ;
   if joy0up then if player0y > _P_Edge_Top then player0y = player0y - 1
   if joy0down then if player0y < _P_Edge_Bottom then player0y = player0y + 1
   if joy0left then if player0x > _P_Edge_Left then player0x = player0x - 1
   if joy0right then if player0x < _P_Edge_Right then player0x = player0x + 1

__Skip_Joy_Movement



   ;***************************************************************
   ;
   ;  Squirrel chases the player.
   ;
   if player1y < player0y then player1y = player1y + 1
   if player1y > player0y then player1y = player1y - 1
   temp5 = player1x + 8 : if temp5 < player0x then if player1x < 144 then player1x = player1x + 1
   temp5 = player1x + 8 : if temp5 > player0x then if player1x > 0 then player1x = player1x - 1



   ;***************************************************************
   ;
   ;  Squirrel/missile0 collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(missile0,player1) then goto __Skip_Squirrel_Kill

   ;```````````````````````````````````````````````````````````````
   ;  Temporarily remembers squirrel's y position.
   ;
   temp6 = player1y

   ;```````````````````````````````````````````````````````````````
   ;  Moves squirrel to new location and removes missile.
   ;
   player1x = (rand/2) + (rand&15) : player1y = 0 : missile0y = 250

   ;```````````````````````````````````````````````````````````````
   ;  Skips sound and points if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __Skip_Squirrel_Kill

   ;```````````````````````````````````````````````````````````````
   ;  Adds 1 to the score.
   ;
   score = score + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sound effect 1 setup.
   ;
   if _Ch0_Sound then goto __Skip_Squirrel_Kill

   _Ch0_Sound = 1 : _Ch0_Counter = 10

   _C0 = 4 : _V0 = 12 : _F0 = 14

   ;```````````````````````````````````````````````````````````````
   ;  Makes a different sound when closer to player.
   ;
   temp5 = 255 : if player0y > temp6 then temp5 = player0y - temp6

   if temp5 < 30 then _C0 = 12

__Skip_Squirrel_Kill



   ;***************************************************************
   ;
   ;  Squirrel/acorn collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player0,player1) then goto __Skip_Acorn_Eaten

   ;```````````````````````````````````````````````````````````````
   ;  Activates last life bit if pfscore1 bar is empty. Also ends
   ;  auto-play if it's on.
   ;
   if !pfscore1 then _Bit7_Last_Life{7} = 1 : if _Bit3_Auto_Play{3} then _Bit2_Game_Control{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Deletes a life.
   ;
   if pfscore1 then pfscore1 = pfscore1/4

   ;```````````````````````````````````````````````````````````````
   ;  Moves squirrel to new location and removes missile.
   ;
   player1x = (rand/2) + (rand&15) : player1y = 0 : missile0y = 250

   ;```````````````````````````````````````````````````````````````
   ;  Skips sound effect and score if auto-play is on.
   ;
   if _Bit3_Auto_Play{3} then goto __Skip_Acorn_Eaten

   ;```````````````````````````````````````````````````````````````
   ;  Subtracts 1 from the score.
   ;
   if _sc3 > 0 then score = score - 1

   ;```````````````````````````````````````````````````````````````
   ;  Sound effect 2 setup.
   ;
   if _Ch0_Sound then goto __Skip_Acorn_Eaten

   _Ch0_Sound = 2 : _Ch0_Counter = 10

   _C0 = 7 : _V0 = 12 : _F0 = 12

__Skip_Acorn_Eaten



   ;***************************************************************
   ;
   ;  Point sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on.
   ;
   if _Ch0_Sound <> 1 then goto __Skip_Sound1

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
   _Ch0_Counter = _Ch0_Counter - 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears _Ch0_Sound and mutes channel if sound counter is zero.
   ;
   if !_Ch0_Counter then _Ch0_Sound = 0 : AUDV0 = 0

__Skip_Sound1



   ;***************************************************************
   ;
   ;  Squirrel eats acorn sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on.
   ;
   if _Ch0_Sound <> 2 then goto __Skip_Sound2

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
   _Ch0_Counter = _Ch0_Counter - 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears _Ch0_Sound and mutes channel if sound counter is zero.
   ;  Also tells game to end if last life is lost.
   ;
   if !_Ch0_Counter then _Ch0_Sound = 0 : AUDV0 = 0 : if _Bit7_Last_Life{7} then _Bit2_Game_Control{2} = 1

__Skip_Sound2



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
   if _Bit0_BW_Mem{0} then if !_Bit1_BW_Check{1} then goto __Pause_Setup

   if !_Bit0_BW_Mem{0} then if _Bit1_BW_Check{1} then goto __Pause_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Pauses game if fire button of second joystick is pressed.
   ;
   if joy1fire && !_Bit1_FireB_Restrainer{1} then goto __Pause_Setup

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
   if _Bit3_Auto_Play{3} then _Bit2_Game_Control{2} = 0 : _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem : goto __Start_Restart

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to game over set up.
   ;
   goto __Game_Over_Setup

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
   if switchreset || joy0fire then _Bit3_Auto_Play{3} = 0 : _Bit2_Game_Control{2} = 1 : goto __Start_Restart

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
   goto __Game_Over_Setup




   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF MAIN LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;
   ;  Squirrel animation frames.
   ;
__Sq00
   player1:
   %00001010
   %00001110
   %00110011
   %01110100
end

   goto __Squirrel_Frame_Done


__Sq01
   player1:
   %00001001
   %00001110
   %00110011
   %01110100
end

   goto __Squirrel_Frame_Done


__Sq02
   player1:
   %00010001
   %00001110
   %00110011
   %01110100
end

   goto __Squirrel_Frame_Done


__Sq03
   player1:
   %00010010
   %00001110
   %00110011
   %01110100
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
   if !_Bit2_Game_Control{2} then goto __Start_Restart


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
   player0y = 200 : player1y = 200 : missile0y = 200


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
   if _Frame_Counter > 9 then _Bit2_Game_Control{2} = 0 : _sc1=_Score1_Mem : _sc2=_Score2_Mem : _sc3=_Score3_Mem: goto __Start_Restart

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
   ;  Sets background color and playfield color.
   ;
   COLUBK = $44 : COLUPF = $2C

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
   goto __Start_Restart





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
   ;  Makes missile0 a little wider.
   ;
   NUSIZ0 = $10



   ;***************************************************************
   ;
   ;  Makes squirrel wider.
   ;
   NUSIZ1 = $05



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
   ;  Restores score color and more.
   ;
   scorecolor = $1C : pfscorecolor = $D2


   goto __Main_Loop





   ;***************************************************************
   ;
   ;  Sets pause colors to gray.
   ;
__Ps0

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps0B

   COLUPF = $0C : COLUP0 = $0C : COLUP1 = $0C : pfscorecolor = $0C : scorecolor = $0C

   COLUBK = $0A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to gray.
   ;
__Ps0B

   COLUPF = $0A : COLUP0 = $0A : COLUP1 = $0A : pfscorecolor = $0A : scorecolor = $0A

   COLUBK = $0C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to reddish-orange.
   ;
__Ps1

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps1B

   COLUPF = $3C : COLUP0 = $3C : COLUP1 = $3C : pfscorecolor = $3C : scorecolor = $3C

   COLUBK = $3A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to reddish-orange.
   ;
__Ps1B

   COLUPF = $3A : COLUP0 = $3A : COLUP1 = $3A : pfscorecolor = $3A : scorecolor = $3A

   COLUBK = $3C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to purple.
   ;
__Ps2

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps2B

   COLUPF = $6C : COLUP0 = $6C : COLUP1 = $6C : pfscorecolor = $6C : scorecolor = $6C

   COLUBK = $6A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to purple.
   ;
__Ps2B

   COLUPF = $6A : COLUP0 = $6A : COLUP1 = $6A : pfscorecolor = $6A : scorecolor = $6A



   COLUBK = $6C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to blue.
   ;
__Ps3

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps3B

   COLUPF = $9C : COLUP0 = $9C : COLUP1 = $9C : pfscorecolor = $9C : scorecolor = $9C

   COLUBK = $9A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to blue.
   ;
__Ps3B

   COLUPF = $9A : COLUP0 = $9A : COLUP1 = $9A : pfscorecolor = $9A : scorecolor = $9A

   COLUBK = $9C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to green.
   ;
__Ps4

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps4B

   COLUPF = $CC : COLUP0 = $CC : COLUP1 = $CC : pfscorecolor = $CC : scorecolor = $CC

   COLUBK = $CA

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to green.
   ;
__Ps4B

   COLUPF = $CA : COLUP0 = $CA : COLUP1 = $CA : pfscorecolor = $CA : scorecolor = $CA

   COLUBK = $CC

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to yellowish.
   ;
__Ps5

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps5B

   COLUPF = $FC : COLUP0 = $FC : COLUP1 = $FC : pfscorecolor = $FC : scorecolor = $FC

   COLUBK = $FA

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to yellowish.
   ;
__Ps5B

   COLUPF = $FA : COLUP0 = $FA : COLUP1 = $FA : pfscorecolor = $FA: scorecolor = $FA

   COLUBK = $FC

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to darkish-blue.
   ;
__Ps6

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps6B

   COLUPF = $8C : COLUP0 = $8C : COLUP1 = $8C : pfscorecolor = $8C : scorecolor = $8C

   COLUBK = $8A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to darkish-blue.
   ;
__Ps6B

   COLUPF = $8A : COLUP0 = $8A : COLUP1 = $8A : pfscorecolor = $8A : scorecolor = $8A

   COLUBK = $8C

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to orange-brown.
   ;
__Ps7

   if _Bit2_Pause_Clr_Scheme{2} then goto __Ps7B

   COLUPF = $2C : COLUP0 = $2C : COLUP1 = $2C : pfscorecolor = $2C : scorecolor = $2C

   COLUBK = $2A

   goto __Got_Pause_Colors



   ;***************************************************************
   ;
   ;  Sets pause colors to orange-brown.
   ;
__Ps7B

   COLUPF = $2A : COLUP0 = $2A : COLUP1 = $2A : pfscorecolor = $2A : scorecolor = $2A

   COLUBK = $2C

   goto __Got_Pause_Colors
