  ;*************************************************************** 
  ;
  ;  Princess Rescue by Chris Spry, 2012.
  ;
  ;  Note from Chris Spry 9/20/2015: Added additional comments
  ;  for people to better understand this code. I did this for
  ;  Random Terrain to post on his batari Basic page.
  ;
  ;  Program adapted by Duane Alan Hahn (Random Terrain).
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
  ;  Initializes the batari Basic compiler directives.
  ;
  set kernel_options playercolors player1colors pfcolors
  set tv ntsc
  set romsize 32k
  set optimization speed
  set smartbranching on
  set optimization noinlinedata
  set optimization inlinerand



  ;***************************************************************
  ;
  ;  Debug. The rem below is removed when I want to check to see
  ;  if I'm going over cycle count during tests.
  ;
  rem set debug



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
  ;  Animation timer.
  ;
  dim _Animation_Timer = a

  ;```````````````````````````````````````````````````````````````
  ;  Level data pointer.
  ;
  dim _Level_Data_Pointer = b

  ;```````````````````````````````````````````````````````````````
  ;  Coin counter.
  ;
  dim _Coin_Counter = c

  ;```````````````````````````````````````````````````````````````
  ;  Player bit flags.
  ;
  dim _BitOp_Player_Data_Flags = d
  dim _Bit0_Player_Facing_Direction = d ; (0 = right, 1 = left)
  dim _Bit1_Jumping_Flag = d
  dim _Bit2_Fire_Button_Pressed = d
  dim _Bit3_Super_Mario_Power = d
  dim _Bit4_Firey_Mario_Power = d
  dim _Bit5_Ducking_Flag = d
  dim _Bit6_Regular_Mario = d
  dim _Bit7_Mario_Invincibility = d

  ;```````````````````````````````````````````````````````````````
  ;  Level timer.
  ;
  dim _Level_Timer = e

  ;```````````````````````````````````````````````````````````````
  ;  Boss life.
  ;
  dim _Boss_Life = e

  ;```````````````````````````````````````````````````````````````
  ;  Bit flags.
  ;
  dim _BitOp_Extra_Bits = f
  dim _Bit0_Genesis_Controller = f
  dim _Bit1_Genesis_Button_Pressed  = f
  dim _Bit7_2nd_Quest = f

  ;```````````````````````````````````````````````````````````````
  ;  Bit flags.
  ;
  dim _BitOp_Extra_Bit_Flags = g
  dim _Bit0_Mario_Fireball_Going_Down  = g ; (enabled if set)
  dim _Bit1_Mario_Fireball_Going_Up = g ; (enabled if set)
  dim _Bit2_Mario_Fireball_Direction = g ; (0 = left, 1 = right)
  dim _Bit3_Enemy_Direction = g ; (0 = left, 1 = right)
  dim _Bit4_Enemy_Dead_Flag = g
  dim _Bit5_Moving_Turtle_Shell_Direction  = g ; (0 = left, 1 = right)
  dim _Bit6_Checkpoint_Flag = g
  dim _Bit7_Mario_On_Off = g ; (Mario Sprite on/off flag for invincibility)

  ;```````````````````````````````````````````````````````````````
  ;  Object scroll-in data.
  ;
  dim _Object_Scroll_In_Data = h

  ;```````````````````````````````````````````````````````````````
  ;  Enemy type.
  ;
  dim _Enemy_Type = i

  ;```````````````````````````````````````````````````````````````
  ;  Enemy momentum.
  ;
  dim _Enemy_Momentum = j

  ;```````````````````````````````````````````````````````````````
  ;  Star invincibility timer.
  ;
  dim _Star_Invincibility_Timer = k

  ;```````````````````````````````````````````````````````````````
  ;  Lives counter.
  ;
  dim _Lives_Counter = l

  ;```````````````````````````````````````````````````````````````
  ;  Momentum left/right.
  ;
  dim _Momentum_Left_Right = m

  ;```````````````````````````````````````````````````````````````
  ;  Momentum up/down.
  ;
  dim _Momentum_Up_Down = n

  ;```````````````````````````````````````````````````````````````
  ;  Farthest traveled on level.
  ;
  dim _Farthest_Traveled_On_Level = o

  ;```````````````````````````````````````````````````````````````
  ;  Music duration.
  ;
  dim _Music_Duration = p

  ;```````````````````````````````````````````````````````````````
  ;  q and r used for sdata.
  ;
  ;```````````````````````````````````````````````````````````````

  ;```````````````````````````````````````````````````````````````
  ;  Moving shell x-coordinate.
  ;
  dim _Moving_Shell_X_Coordinate = s

  ;```````````````````````````````````````````````````````````````
  ;  Moving shell y-coordinate.
  ;
  dim _Moving_Shell_Y_Coordinate = t

  ;```````````````````````````````````````````````````````````````
  ;  u = miscellaneous variable.
  ;
  dim _Temp_u_PF_Column = u
  dim _Temp_u_PF_Row = u
  dim _Temp_u_Freq = u

  ;```````````````````````````````````````````````````````````````
  ;  World.
  ;
  dim _World = v

  ;```````````````````````````````````````````````````````````````
  ;  Level.
  ;
  dim _Level = w

  ;```````````````````````````````````````````````````````````````
  ;  x = miscellaneous variable.
  ;
  ;  y = miscellaneous variable.
  ;
  ;  z = miscellaneous variable.
  ;
  ;```````````````````````````````````````````````````````````````



  ;***************************************************************
  ;
  ;  Constants for enemies and objects.
  ;
  const _Goomba = 0
  const _Green_Koopa = 2
  const _Beetle = 4
  const _Spiney = 6
  const _Red_Koopa = 8
  const _Flying_Green_Koopa = 10
  const _Bullet_Bill = 12
  const _Flying_Red_Koopa = 14
  const _Spiney_Ball = 16
  const _Fireball_Enemy = 18
  const _Flagpole = 20
  const _Silver_Coin = 22
  const _Starman = 24
  const _1up_Mushroom = 26
  const _Kinetic_Platforms = 28
  const _Pirahna_Plant = 30
  const _P_Plant_31 = 31
  const _Beetle_Shell = 32
  const _Green_Shell = 34
  const _Red_Shell = 36
  const _Trampoline = 38
  const _P_Plant_39 = 39
  const _Thwomp = 40
  const _Two_Goombas = 42
  const _Two_Thwomps = 44
  const _Two_Spineys = 46
  const _Bowser_Jr = 64



  ;***************************************************************
  ;
  ;  Turns on the pfscore bars.
  ;
  const pfscore = 1




  ;*************************************************************** 
  ;***************************************************************
  ;
  ;  It all begins here. This is the initial stuff that happens
  ;  before the title screen shows up. Sets the world and level
  ;  to 1 - 1, score at zero, lives, etc. Checks the difficulty
  ;  switch (for starting lives), checks if a Genesis controller
  ;  is plugged in, etc..
  ;
__Start

  if switchleftb then _Lives_Counter = 3 else _Lives_Counter = 5

  _World = 1 : _Level = 1 : _Bit6_Regular_Mario{6} = 1

  _Bit6_Checkpoint_Flag{6} = 0 : score = 0 : _Coin_Counter = 0 : pfscore2 = 0 : d = 0 

  ballheight = 2


  ;***************************************************************
  ;  Genesis Controller detection. Sets bit 0 of variable
  ;  "_Bit0_Genesis_Controller". It's the flag for the Genesis
  ;  controller (1 = yes, 0 = no).
  ;
  if INPT1{7} then _Bit0_Genesis_Controller{0} = 1 else _Bit0_Genesis_Controller{0} = 0



  ;***************************************************************
  ;
  ;  We now go to the title screen in bank 2.
  ;
  gosub __Title_Screen bank2



  ;***************************************************************
  ;
  ;  This is the beginning of the program where you start after
  ;  the title screen or after you lose a life. The first part
  ;  goes to the intro screen in bank 4 where you see the lives
  ;  screen M X #. The line after checks if you are in the 2nd
  ;  part of the castle, where in that case it jumps you over to
  ;  the boss battle part of the code.
  ;
__Init

  drawscreen

  gosub __Intro_Screen bank4

  if _Level = 4 && _Bit6_Checkpoint_Flag{6} then goto __Bos_Setup bank4





  ;*************************************************************** 
  ;*************************************************************** 
  ;
  ;  MAIN LOOP (MAKES THE PROGRAM GO)
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Finally here is the beginning of the game loop code that is
  ;  executed while you play (except in the boss battle).
  ;
__Main_Loop



  ;*************************************************************** 
  ;
  ;  Resets object scroll.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Resets the object scroll in data variable so we don't
  ;  continuously respawn a new enemy or object.
  ;
  _Object_Scroll_In_Data = 0



  ;*************************************************************** 
  ;
  ;  Reset switch check.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  The next line will soft reset the Atari if the reset switch
  ;  is pressed. NOTE: Do not use the reboot command if you are
  ;  using rand because it messes up the randomization of numbers.
  ;  I use it because I do not use random numbers in my code.
  ;  The randomization of Princess Rescue comes from the use of
  ;  in-game variables.
  ;
  if switchreset then reboot



  ;***************************************************************
  ;
  ;  from this point any routines that are jumped to, I will give
  ;  more detail to what they are in the routine themselves.
  ;
  gosub __Set_Up_Mario

  gosub __Render_Screen

  goto __Enemy_Collision_Routine bank3



  ;***************************************************************
  ;
  ;  Since we jumped to the enemy collision detection routine in
  ;  the last line, this part is only executed when the program
  ;  goes to it. The reason why the code jumps around as much as
  ;  it does, causing it to be hard to follow, is because I was
  ;  running out of ROM space in places and had to completely
  ;  reshuffle my code into different banks to make it all fit.
  ;
  ;***************************************************************



  ;*************************************************************** 
  ;
  ;  Mario Hit.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  This is the part of the program that is executed when Mario
  ;  is hit by an enemy or object (Sprite1).
  ;
__Mario_Hit_01

  ;```````````````````````````````````````````````````````````````
  ;  If Mario is in invincibility mode or running into something
  ;  that won't make him lose power then skip the powerdown/death
  ;  part since it doesn't hurt him.
  ;
  if _Bit7_Mario_Invincibility{7} || _Enemy_Type = _Kinetic_Platforms then goto __Draw bank3

  if _Enemy_Type = _Trampoline then goto __Draw bank3

  ;```````````````````````````````````````````````````````````````
  ;  If Mario is small and is hurt then we all know what that
  ;  means. DEATH!
  ;
  if _Bit6_Regular_Mario{6} then goto __Mario_Death bank3

  ;```````````````````````````````````````````````````````````````
  ;  If not small, then Mario just "powers down".  This whole
  ;  routine here checks for what powerup you had, and "stops"
  ;  the game to do the power down animation in this routine.
  ;
  if _Bit4_Firey_Mario_Power{4} then _Bit3_Super_Mario_Power{3} = 1 : _Bit4_Firey_Mario_Power{4} = 0 else _Bit6_Regular_Mario{6} = 1 : _Bit3_Super_Mario_Power{3} = 0 : _Temp_u_Freq = 0 : y = 8

  for z = 1 to 8

  for x = 1 to 4

  if _Bit3_Super_Mario_Power{3} then gosub __Fire_Mario_Color : gosub __Super_Mario else gosub __Super_Mario_Color : gosub __Super_Mario

  gosub __Power_Down_SFX

  gosub __Render_Screen

  next x

  for x = 1 to 4

  if _Bit3_Super_Mario_Power{3} then gosub __Super_Mario_Color : gosub __Super_Mario else gosub __Mario_Color : gosub __Mario

  gosub __Power_Down_SFX

  gosub __Render_Screen

  next x

  next z

  ;```````````````````````````````````````````````````````````````
  ;  Sets Mario's invincibility flag or else he'd just keep
  ;  getting hit until he dies. Being scarce on variables, we'll
  ;  use the level timer to fix the duration of Mario's
  ;  invincibility. So if you get hit, it'll actually give you a
  ;  little extra time to finish the level. LOL.
  ;
  if _Enemy_Type < _Bowser_Jr then _Bit7_Mario_Invincibility{7} = 1 : _Level_Timer = 0 : _Bit7_Mario_On_Off{7} = 0 else _Star_Invincibility_Timer = 1 : _Bit7_Mario_On_Off{7} = 1 : _Bit7_Mario_Invincibility{7} = 1

  goto __Draw bank3




__Main_2

  gosub __Render_Screen

  ;*************************************************************** 
  ;
  ;  Mario momentum check.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Moves Mario if he has momentum.
  ;
  if _Momentum_Left_Right > 0 && _Bit0_Player_Facing_Direction{0} then player0x = player0x - _Momentum_Left_Right

  if _Momentum_Left_Right > 0 && !_Bit0_Player_Facing_Direction{0} then player0x = player0x + _Momentum_Left_Right

  if _Momentum_Up_Down > 0 && _Bit1_Jumping_Flag{1} then player0y = player0y - _Momentum_Up_Down

  if _Momentum_Up_Down > 0 && !_Bit1_Jumping_Flag{1} then player0y = player0y + _Momentum_Up_Down



  ;*************************************************************** 
  ;
  ;  Scroll check.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Scrolls screen if __Moving in middle. Also checks for edge
  ;  of levels.
  ;
  if player0x < 17 then player0x = 17

  if player0x > 137 then player0x = 137

  if _Enemy_Type > 60 then goto __Fall_Collision_Check

  if !_Bit0_Player_Facing_Direction{0} && player0x > 80 && _Level_Data_Pointer < 127 then player0x = 80 : gosub __Scroll_Left

  if _Bit0_Player_Facing_Direction{0} && player0x < 72 && _Level_Data_Pointer > 32 then player0x = 72 : gosub __Scroll_Right



  ;*************************************************************** 
  ;
  ;  Fall collision check.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Collision detection with playfield.
  ;
__Fall_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  Skips check if jumping
  ;
  if _Bit1_Jumping_Flag{1} then goto __Jump_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  If already falling, check current position for collision
  ;  and if not, check one pixel below to see if standing on
  ;  something.
  ;
  if _Momentum_Up_Down > 0 then z = 0 else z = 1

  ;```````````````````````````````````````````````````````````````
  ;  15 & 11 are used so the player can't fall through a single
  ;  playfield block if that's all there is to detect. It takes
  ;  away from the edges a little, but compromises need to be made.
  ;
  y = (player0y + z)/8

  x = (player0x - 15)/4

  ;```````````````````````````````````````````````````````````````
  ;  Checks if character has collided with a platform and if so,
  ;  we will reset the character one pixel above that platform
  ;  and mark him as no longer falling if he ever was in the first
  ;  place. If we found it here then skip ahead for next detection.
  ;  No need to waste precious clock cycles for another redundant
  ;  check in the next lines
  ;
  if pfread(x,y) then player0y = (y * 8) - 1 : _Momentum_Up_Down = 0 : goto __Jump_Collision_Check 

  x = (player0x - 11)/4

  if pfread(x,y) then player0y = (y * 8) - 1 : _Momentum_Up_Down = 0 : goto __Jump_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  Gets executed if nothing is below the character and is
  ;  falling or continues to fall. Momentum (gravity) increases
  ;  if not at terminal velocity. Can't go above 6 as I have found
  ;  or else he can fall through platforms! :(
  ;
  if _Momentum_Up_Down < 7 then _Momentum_Up_Down = _Momentum_Up_Down + 1



  ;*************************************************************** 
  ;
  ;  Jump collision check.
  ;
__Jump_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  Skip if not jumping.
  ;
  if !_Bit1_Jumping_Flag{1} then goto __Momentum_Left_Right_Check

  ;```````````````````````````````````````````````````````````````
  ;  A bunch of row checking.
  ;
  if _Bit3_Super_Mario_Power{3} || _Bit4_Firey_Mario_Power{4} then y = (player0y - 22)/8 : z = 10

  if _Bit5_Ducking_Flag{5} || _Bit6_Regular_Mario{6} then y = (player0y - 12)/8 : z = 0

  if y < 0 || y > 11 then goto __Jump_Collsn_Check_02

  if _Level = 3 && y > 1 then goto __Jump_Collsn_Check_02

  ;```````````````````````````````````````````````````````````````
  ;  Checks the playfield for a collision.
  ;
  x = (player0x - 15)/4

  if pfread(x,y) then player0y = (y * 8) + 18 + z : _Bit1_Jumping_Flag{1} = 0 : _Momentum_Up_Down = 1 : goto __Bonus_Check

  x = (player0x - 11)/4

  if pfread(x,y) then player0y = (y * 8) + 18 + z : _Bit1_Jumping_Flag{1} = 0 : _Momentum_Up_Down = 1 : goto __Bonus_Check



  ;*************************************************************** 
  ;
  ;  Jump collision check 02.
  ;
__Jump_Collsn_Check_02

  ;```````````````````````````````````````````````````````````````
  ;  If nothing is above then continue jumping up until momentum
  ;  runs out, once it does, turn jump flag off so he can start
  ;  falling again.
  ;
  _Momentum_Up_Down = _Momentum_Up_Down - 1

  if _Momentum_Up_Down < 1 then _Momentum_Up_Down = 1 : _Bit1_Jumping_Flag{1} = 0

  if player0y < 8 then player0y = 8



  ;*************************************************************** 
  ;
  ;  Momentum left/right check.
  ;
__Momentum_Left_Right_Check

  ;```````````````````````````````````````````````````````````````
  ;  We only check this if momentum is __Moving left or right or
  ;  else it's just a waste of more cycles since nothing will be
  ;  there anyway unless he's ducking.
  ;
  if _Level = 3 then goto __Finish_Check

  if _Bit0_Player_Facing_Direction{0} then x = (player0x - 17)/4 else x = (player0x - 9)/4

  y = (player0y - 4)/8

  if pfread(x,y) then goto __Fix_Mario

  y = (player0y - 11)/8

  if pfread(x,y) then goto __Fix_Mario

  if _Bit5_Ducking_Flag{5} || _Bit6_Regular_Mario{6} then goto __Finish_Check

  y = (player0y - 18)/8

  if pfread(x,y) then goto __Fix_Mario

  goto __Finish_Check



  ;*************************************************************** 
  ;
  ;  Bonus check.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  After done with this check do not do a Momentum left/right
  ;  check. It makes Mario bounce off the bricks weird. Plus
  ;  it will save a few cycles.
  ;
__Bonus_Check

  ;```````````````````````````````````````````````````````````````
  ;  This is the part that checks for anything special that might
  ;  be in the blocks that Mario breaks. It also checks to see if
  ;  an enemy was on top of the block. If so, you can kill it,
  ;  even if Mario is small.
  ;
  if _Level = 4 then goto __Momentum_Left_Right_Check

  if player1y < player0y then goto __Enemy_Bump



  ;*************************************************************** 
  ;
  ;  Bonus check 02.
  ;
__Bonus_Check_02

  ;```````````````````````````````````````````````````````````````
  ;  Each level in a world has its own attributes, so the yellow
  ;  power blocks are only on certain lines depending on which
  ;  level you are in. This checks for that.
  ;
  if y = 0 && _Level = 3 then goto __Yellow_Block

  if y = 1 && _Level = 1 then goto __Yellow_Block

  if y = 6 && _Level <> 3 then goto __Yellow_Block

__Brick_Block

  if y <> 1 && _Level = 3 then goto __Finish_Check

  if player1x = 0 && _Level_Data_Pointer > 31 && y > 1 && !_Bit6_Regular_Mario{6} then goto __Hidden_Block

__Brick_Block_02

  if _Bit6_Regular_Mario{6} then goto __Finish_Check

  AUDV0 = 10 : AUDC0 = 7 : AUDF0 = 22

  score = score + 10

  pfpixel x y off

  goto __Finish_Check



  ;***************************************************************
  ;
  ;  Yellow block.
  ;
__Yellow_Block

  ;```````````````````````````````````````````````````````````````
  ;  Determines if you get a coin or a power up from a yellow
  ;  block. If it's a power-up, then the power-up animation takes
  ;  place here too.
  ;
  pfpixel x y off

  if _Animation_Timer > 1 || _Bit4_Firey_Mario_Power{4} then score = score + 100 : goto __Add_Coin_Counter

  score = score + 1000

  if _Bit4_Firey_Mario_Power{4} then goto __Finish_Check

  if _Bit3_Super_Mario_Power{3} then _Bit3_Super_Mario_Power{3} = 0 : _Bit4_Firey_Mario_Power{4} = 1 else _Bit3_Super_Mario_Power{3} = 1 : _Bit4_Firey_Mario_Power{4} = 0 : _Bit6_Regular_Mario{6} = 0

  y = 31 : u = 0

  for z = 1 to 8

  for x = 1 to 4

  if _Bit3_Super_Mario_Power{3} then gosub __Super_Mario_Color : gosub __Super_Mario else gosub __Fire_Mario_Color : gosub __Super_Mario

  gosub __Power_Up_SFX

  gosub __Render_Screen

  next x

  for x = 1 to 4

  if _Bit3_Super_Mario_Power{3} then gosub __Mario_Color : gosub __Mario else gosub __Super_Mario_Color : gosub __Super_Mario

  gosub __Power_Up_SFX

  gosub __Render_Screen

  next x

  next z

  goto __Finish_Check



  ;***************************************************************
  ;
  ;  Hidden block.
  ;
__Hidden_Block

  ;```````````````````````````````````````````````````````````````
  ;  Now this routine isn't exactly what you think. There are no
  ;  hidden blocks in the game, however, this routine checks to
  ;  see if there is anything special inside a block you just
  ;  broke. Because we can only have 1 player1 sprite on the
  ;  screen at the same time, which is used for the enemies and
  ;  objects, this ONLY gets executed if there is no player1
  ;  sprite on the screen. This is why the special items show up
  ;  as rare as they do. They cannot spawn if there is an enemy on
  ;  the screen.
  ;
  u = _Level_Timer + _Animation_Timer

  if u = 10 || u = 16 then goto __Hidden_Blck_02

  if u = 25 then goto __Hidden_Blck_02

  goto __Brick_Block_02

__Hidden_Blck_02

  _Bit3_Enemy_Direction{3} = 0

  player1x = (x * 4) + 17

  player1y = y * 8

  _Enemy_Type = _Silver_Coin

  if _Animation_Timer > 3 && _Star_Invincibility_Timer = 0 then _Enemy_Type = _Starman

  if _Animation_Timer = 6 then _Enemy_Type = _1up_Mushroom

  _Enemy_Momentum = 3

  goto __Brick_Block_02



  ;***************************************************************
  ;
  ;  Enemy bump.
  ;
__Enemy_Bump

  ;```````````````````````````````````````````````````````````````
  ;  This is the part that is executed if you "bumped" an enemy
  ;  from below.
  ;
  _Temp_u_PF_Row = (y * 8) - 1

  if _Temp_u_PF_Row <> player1y then goto __Bonus_Check_02

  _Temp_u_PF_Column = (x * 4) + 13 : z = (x * 4) + 23

  if player1x > _Temp_u_PF_Column && player1x < z then goto __Enemy_Bump_02

  goto __Bonus_Check_02

__Enemy_Bump_02

  _Bit4_Enemy_Dead_Flag{4} = 1 : score = score + 300

  goto __Bonus_Check_02



  ;***************************************************************
  ;
  ;  Add a coin.
  ;
__Add_Coin_Counter

  ;```````````````````````````````````````````````````````````````
  ;  Adds a coin to your coin bar and checks if you got 32 in
  ;  total for an extra life..
  ;
  _Coin_Counter = _Coin_Counter + 1

  if _Coin_Counter > 3 then _Coin_Counter = 0 : pfscore2 = pfscore2 * 2|1

  AUDV0 = 12 : AUDC0 = 4 : AUDF0 = 7

  if pfscore2 < 250 then goto __Finish_Check

  y = 11 : _Temp_u_PF_Column = 0 : _Lives_Counter = _Lives_Counter + 1

  if _Lives_Counter = 255 then _Lives_Counter = 254



  ;***************************************************************
  ;
  ;  1-Up.
  ;
__1Up

  ;```````````````````````````````````````````````````````````````
  ;  You got a 1-up? Great, this part takes care of it..
  ;
  gosub __1Up_SFX

  gosub __Render_Screen : gosub __Render_Screen : gosub __Render_Screen : gosub __Render_Screen

  _Bit7_Mario_On_Off{7} = 1 : _Bit7_Mario_Invincibility{7} = 1

  gosub __Render_Screen : gosub __Render_Screen : gosub __Render_Screen : gosub __Render_Screen

  _Bit7_Mario_On_Off{7} = 0 : _Bit7_Mario_Invincibility{7} = 0 : gosub __Set_Up_Mario

  if y = 3 then pfscore2 = 0 : goto __Finish_Check

  goto __1Up



  ;***************************************************************
  ;
  ;  Fix Mario.
  ;
__Fix_Mario

  ;```````````````````````````````````````````````````````````````
  ;  This "fixes" Mario to a standstill in case he ran into a
  ;  playfield block.
  ;
  if _Bit0_Player_Facing_Direction{0} then player0x = (x * 4) + 21 else player0x = (x * 4) + 9

  _Momentum_Left_Right = 0



  ;***************************************************************
  ;
  ;  Finish check.
  ;
__Finish_Check

  ;```````````````````````````````````````````````````````````````
  ;  When the screen starts scrolling, the enemies, fireballs,
  ;  etc, get moved too, but if we __Draw them before they get a
  ;  chance to move on their routine there will be a double
  ;  flicker effect so we turn them off for now until it's their
  ;  time for a full render on the next drawscreen. This may
  ;  cause a touch of flicker, but it's better than double-vision.
  ;
  if ballx > 0 then u = bally : bally = 120

  if _Object_Scroll_In_Data > 0 && _Bit0_Player_Facing_Direction{0} && player1x > 0 then player1x = player1x + 4

  if _Object_Scroll_In_Data > 0 && !_Bit0_Player_Facing_Direction{0} && player1x > 0 then player1x = player1x - 4

  if _Moving_Shell_X_Coordinate > 0 || _Moving_Shell_Y_Coordinate > 0 then gosub __Redraw_Shell

  gosub __Render_Screen

  ;```````````````````````````````````````````````````````````````
  ;  The enemy routine is in bank 2.
  ;
  goto __Fireball_Enemy_Routine bank2



  ;***************************************************************
  ;
  ;  Redraw shell.
  ;
__Redraw_Shell

  ;```````````````````````````````````````````````````````````````
  ;  Ran out of cycles for this so it'll do one extra drawscreen
  ;  here, which will slow down gameplay a little but only when
  ;  the shell is __Moving on screen (has been kicked), so it won't
  ;  happen that often.
  ;
  gosub __Render_Screen

  if _Object_Scroll_In_Data > 0 && _Bit0_Player_Facing_Direction{0} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate + 1

  if _Object_Scroll_In_Data > 0 && !_Bit0_Player_Facing_Direction{0} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate - 1

  if _Moving_Shell_X_Coordinate < 0 || _Moving_Shell_X_Coordinate > 30 then _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0 : return

  pfpixel _Moving_Shell_X_Coordinate _Moving_Shell_Y_Coordinate on

  x = _Moving_Shell_X_Coordinate + 1

  pfpixel x _Moving_Shell_Y_Coordinate on

  return thisbank



  ;***************************************************************
  ;
  ;  Set up Mario.
  ;
__Set_Up_Mario

  ;```````````````````````````````````````````````````````````````
  ;  This routine figures out which Mario sprite to display.
  ;
  if _Bit7_Mario_Invincibility{7} && _Bit7_Mario_On_Off{7} then _Bit7_Mario_On_Off{7} = 0 : gosub __No_Mario : return

  if _Bit7_Mario_Invincibility{7} && !_Bit7_Mario_On_Off{7} then _Bit7_Mario_On_Off{7} = 1 

  if _Animation_Timer > 3 then x = 1 else x = 0

  if _Momentum_Left_Right = 0 then x = 0

  if _Bit5_Ducking_Flag{5} then x = 3

  if _Bit1_Jumping_Flag{1} || _Momentum_Up_Down > 0 then x = 2

  if _Bit6_Regular_Mario{6} then goto __Small_Mario

  if _Bit3_Super_Mario_Power{3} then goto __Big_Mario_Color

  on x gosub __Fire_Mario_Color __Fire_Mario_Color __Fire_Mario_Jump_Color __Fire_Mario_Duck_Color

  goto __Big_Mario_Sprite

__Big_Mario_Color
  on x gosub __Super_Mario_Color __Super_Mario_Color __Super_Mario_Jump_Color __Mario_Duck_Color

__Big_Mario_Sprite
  on x gosub __Super_Mario __Super_Mario_02 __Super_Mario_Jump __Mario_Duck
  
  return

__Small_Mario
  on x gosub __Mario_Color __Mario_Color __Mario_Jump_Color __Mario_Color

  on x gosub __Mario __Mario2 __Mario_Jump __Mario

  return

__Power_Up_SFX

  y = y - 1 : _Temp_u_Freq = _Temp_u_Freq + 1

  if _Temp_u_Freq > 21 then y = y + 18 : _Temp_u_Freq = 0

  AUDV0 = 8 : AUDC0 = 4 : AUDF0 = y : AUDV1 = 0

  return thisbank

__Power_Down_SFX

  y = y + 1

  temp4 = 8

  if _Temp_u_Freq > 6 then y = 8 : _Temp_u_Freq = 0

  if y > 30 then _Temp_u_Freq = _Temp_u_Freq + 1 : y = 9 : temp4 = 8 - _Temp_u_Freq

  AUDV0 = temp4 : AUDC0 = 6 : AUDF0 = y : AUDV1 = 0

  return

__1Up_SFX

  y = y - 2 : _Temp_u_Freq = _Temp_u_Freq + 1

  if _Temp_u_Freq = 4 then _Temp_u_Freq = 0 : y = 7

  AUDV0 = 8 : AUDC0 = 4 : AUDF0 = y : AUDV1 = 0

  return



  ;***************************************************************
  ;
  ;  Magic time.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Here's the magical part of the program that scrolls the
  ;  screen, reads the level data, plots the new screen data,
  ;  and figures out if an object/enemy spawns the First one,
  ;  __Scroll_Left, is the main scrolling routine that scrolls to
  ;  the left when you go forward. This routine is also called
  ;  on the life display screen to scroll on the beginning of
  ;  the level in black, so you don't see it and it appears
  ;  instantly when you press the action button to start it.
  ;
  ;***************************************************************



  ;***************************************************************
  ;
  ;  Scroll left.
  ;
__Scroll_Left

  ;```````````````````````````````````````````````````````````````
  ;  Scrolls the screen left 1 playfield column.
  ;
  pfscroll left

  ;```````````````````````````````````````````````````````````````
  ;  If there's a fireball on the screen, move it left 4 pixels
  ;  to match the screen scroll rate.
  ;
  if ballx > 0 then ballx = ballx - 4

  ;```````````````````````````````````````````````````````````````
  ;  Here we mark the farthest point in the level that Mario has
  ;  been. We do this so we don't respawn powerups, because if
  ;  we do it'll make the game too easy. This is why the yellow
  ;  blocks do not respawn.
  ;
  x = _Level_Data_Pointer * 2

  if x > _Farthest_Traveled_On_Level then _Farthest_Traveled_On_Level = x

  ;```````````````````````````````````````````````````````````````
  ;  Now we figure out what stage you are on by combining the
  ;  world and level you are on.
  ;
  z = ((_World - 1) * 8) + ((_Level - 1) * 2)

  ;```````````````````````````````````````````````````````````````
  ;  If you are on the second half of the level, then we need to
  ;  add one to it.
  ;
  if _Bit6_Checkpoint_Flag{6} then z = z + 1

  ;```````````````````````````````````````````````````````````````
  ;  Now we go to the proper ROM bank where all the level data is.
  ;
  if z < 16 then gosub __Level_Data_Bank1 bank5 else gosub __Level_Data_Bank2 bank6

  ;```````````````````````````````````````````````````````````````
  ;  The next lines below figures out what new part of the level
  ;  to __Draw by comparing what is on the screen and what is in
  ;  the level data.
  ;
  if y{0} then var3 = var3 | 128 else var3 = var3 & 127

  ;```````````````````````````````````````````````````````````````
  ;  If Mario has already gotten this far, then don't bring back
  ;  power blocks (level 1 & 2 only).
  ;
  if _Farthest_Traveled_On_Level > x && _Level = 1 then var7 = var7 & 127 : goto __Render_1

  if y{1} then var7 = var7 | 128 else var7 = var7 & 127

__Render_1

  if y{2} then var11 = var11 | 128 else var11 = var11 & 127

  if y{3} then var15 = var15 | 128 else var15 = var15 & 127

  if y{4} then var19 = var19 | 128 else var19 = var19 & 127

  if y{5} then var23 = var23 | 128 else var23 = var23 & 127

  if _Farthest_Traveled_On_Level > x && _Level < 3 then var27 = var27 & 127 : goto __Render_2

  if y{6} then var27 = var27 | 128 else var27 = var27 & 127

__Render_2

  if y{7} then var31 = var31 | 128 else var31 = var31 & 127

  if u{0} then var35 = var35 | 128 else var35 = var35 & 127

  if u{1} then var39 = var39 | 128 else var39 = var39 & 127

  if u{2} then var43 = var43 | 128 else var43 = var43 & 127

  ;```````````````````````````````````````````````````````````````
  ;  If there is anything in this part of the U level data
  ;  variable (past the value of 7), then that means an enemy or
  ;  object is going to spawn in the new part.
  ;
  if u{3} then _Object_Scroll_In_Data = u else _Object_Scroll_In_Data = 1

  ;```````````````````````````````````````````````````````````````
  ;  Since we now have advanced one screen scroll, mark it.
  ;
  _Level_Data_Pointer = _Level_Data_Pointer + 1

  return


  ;***************************************************************
  ;
  ;  Scroll right.
  ;
__Scroll_Right

  ;```````````````````````````````````````````````````````````````
  ;  This works a lot like scroll left, instead it just takes
  ;  care of __Moving the screen in the other direction in case
  ;  you go back.
  ;
  pfscroll right

  if ballx > 0 then ballx = ballx + 4

  x = (_Level_Data_Pointer - 32) * 2

  z = ((_World - 1) * 8) + ((_Level - 1) * 2)

  if _Bit6_Checkpoint_Flag{6} then z = z + 1

  if z < 16 then gosub __Level_Data_Bank1 bank5 else gosub __Level_Data_Bank2 bank6

  if y{0} then var0 = var0 | 128 else var0 = var0 & 127

  ;```````````````````````````````````````````````````````````````
  ;  Mario has been here before since he's going back so don't
  ;  bring back power blocks (level 1 and 2 only).
  ;
  if  _Level = 1 && _Animation_Timer <> 250 then var4 = var4 & 127 : goto __Render_3

  if y{1} then var4 = var4 | 128 else var4 = var4 & 127

__Render_3

  if y{2} then var8 = var8 | 128 else var8 = var8 & 127

  if y{3} then var12 = var12 | 128 else var12 = var12 & 127

  if y{4} then var16 = var16 | 128 else var16 = var16 & 127

  if y{5} then var20 = var20 | 128 else var20 = var20 & 127

  if _Level < 3 && _Animation_Timer <>  250 then var24 = var24 & 127 : goto __Render_4

  if y{6} then var24 = var24 | 128 else var24 = var24 & 127

__Render_4

  if y{7} then var28 = var28 | 128 else var28 = var28 & 127

  if u{0} then var32 = var32 | 128 else var32 = var32 & 127

  if u{1} then var36 = var36 | 128 else var36 = var36 & 127

  if u{2} then var40 = var40 | 128 else var40 = var40 & 127

  if u{3} then _Object_Scroll_In_Data = u else _Object_Scroll_In_Data = 1

  _Level_Data_Pointer = _Level_Data_Pointer - 1

  return



  ;***************************************************************
  ;
  ;  Render screen.
  ;
__Render_Screen

  ;```````````````````````````````````````````````````````````````
  ;  This is a very important routine. It takes all the
  ;  information from certain variables to be able to properly
  ;  set up the TIA registers and then executes the batari Basic
  ;  drawscreen command. This is called on 60 times a second
  ;  (this or the other renderscreens in other banks).
  ;
  if _Level = 1 || _Level = 3 then COLUPF = $32 else COLUPF = $04

  if _Level = 2 then COLUPF = $A4

  if _Enemy_Type = _Kinetic_Platforms && !_Bit7_2nd_Quest{7} then NUSIZ1 = $17 : goto __Finish_Render

  if _Enemy_Type = _Kinetic_Platforms && _Bit7_2nd_Quest{7} then NUSIZ1 = $15 : goto __Finish_Render

  if _Enemy_Type = _Thwomp || _Enemy_Type = _Bowser_Jr then NUSIZ1 = $15 : goto __Finish_Render

  if _Enemy_Type = _Bullet_Bill then NUSIZ1 = $15 : goto __Finish_Render

  if _Enemy_Type = _Two_Goombas && player1x < 122 then NUSIZ1 = $11 : goto __Finish_Render

  if _Enemy_Type = _Two_Spineys && player1x < 122 then NUSIZ1 = $11 : goto __Finish_Render

  if _Enemy_Type = _Two_Thwomps && player1x < 106 then NUSIZ1 = $12

__Finish_Render

  if _Bit0_Player_Facing_Direction{0} then REFP0 = 8 else REFP0 = 0

  if _Bit3_Enemy_Direction{3} then REFP1 = 8 else REFP1 = 0

  drawscreen

  return



  ;***************************************************************
  ;
  ;  The Small Mario Sprite color tables.
  ;
__Mario_Color
  player0color:
  $44
  $44
  $3E
  $44
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
end
  return thisbank

__Mario_Jump_Color
  player0color:
  $44
  $44
  $44
  $3E
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
  $3E
  $3E
end
  return thisbank



  ;***************************************************************
  ;
  ;  Now the small Mario sprites.
  ;
__Mario
  player0:
  %01111100
  %01111000
  %01100100
  %11110000
  %11110110
  %01101100
  %00111110
  %01110000
  %11011011
  %10010111
  %00110100
  %11111111
  %01111100
end
  return thisbank

__Mario2
  player0:
  %11100110
  %11000011
  %11001010
  %11100000
  %11110110
  %01101100
  %00111110
  %01110000
  %11011011
  %10010111
  %00110100
  %11111111
  %01111100
end
  return thisbank

__Mario_Jump
  player0:
  %10000110
  %11000011
  %11000011
  %11001010
  %11100101
  %01101010
  %00111110
  %01110000
  %11011011
  %10010111
  %00110100
  %11111111
  %01111100
  %00000011
  %00000111
end
  return thisbank



  ;***************************************************************
  ;
  ;  Same format for Super Mario.
  ;
__Super_Mario_Color
  player0color:
  $44
  $44
  $44
  $44
  $3E
  $3E
  $44
  $44
  $44
  $44
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
  $44
  $44
end
  return thisbank

__Super_Mario
  player0:
  %01111111
  %01111110
  %00111000
  %00000000
  %11000010
  %11100010
  %11110000
  %11110111
  %11110111
  %11100111
  %11101110
  %01100000
  %00111110
  %01111000
  %11100011
  %10110111
  %00111111
  %00110100
  %01110100
  %00111100
  %11000000
  %11111111
  %01111100
  %00111100
end
  return thisbank



  ;***************************************************************
  ;
  ;  Same format for Firey Mario.
  ;
__Fire_Mario_Color
  player0color:
  $3A
  $38
  $36
  $16
  $3E
  $3E
  $16
  $1E
  $1C
  $1A
  $18
  $16
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $36
  $38
  $3A
  $3C
end
  return thisbank

__Fire_Mario_Jump_Color
  player0color:
  $3A
  $38
  $36
  $16
  $3E
  $3E
  $1E
  $1E
  $1C
  $1A
  $18
  $16
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $36
  $38
  $3A
  $3C
  $3E
  $3E
end
  return thisbank

__Super_Mario_02
  player0:
  %01100110
  %11000111
  %11000011
  %00000000
  %00011010
  %00011010
  %00111000
  %01110111
  %11110111
  %11101111
  %11101110
  %01000000
  %00111110
  %01111000
  %11100011
  %10110111
  %00111111
  %00110100
  %01110100
  %00111100
  %11000000
  %11111111
  %01111100
  %00111100
end
  return thisbank

__Super_Mario_Jump_Color
  player0color:
  $44
  $44
  $44
  $44
  $3E
  $3E
  $44
  $44
  $44
  $44
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
  $44
  $44
  $3E
  $3E
end
  return thisbank

__Super_Mario_Jump
  player0:
  %11000110
  %11000111
  %01000111
  %01100011
  %11001001
  %11101001
  %11100000
  %11110110
  %11110110
  %11100101
  %11101101
  %01100000
  %00111110
  %01110000
  %11000011
  %01101111
  %00111111
  %01101010
  %01101010
  %00111100
  %11000001
  %11111111
  %01111101
  %00111101
  %00000011
  %00000111
end
  return thisbank

__Mario_Duck_Color
  player0color:
  $44
  $44
  $44
  $44
  $44
  $44
  $44
  $3E
  $3E
  $44
  $44
  $44
  $44
end
  return thisbank

__Fire_Mario_Duck_Color
  player0color:
  $3A
  $38
  $1C
  $1A
  $1A
  $18
  $16
  $3E
  $3E
  $36
  $38
  $3A
  $3C
end
  return thisbank

__Mario_Duck
  player0:
  %00111100
  %01111000
  %00000110
  %01110110
  %11110000
  %11111100
  %01101100
  %01101101
  %00101100
  %11111011
  %01110110
  %00110110
  %00011100
end
  return thisbank


__No_Mario
  ;```````````````````````````````````````````````````````````````
  ;  This next sprite is when Mario is invincible (frame 2 of the
  ;  animation). I did this so that there is still proper
  ;  collision detection even when invincible. This is why you
  ;  see some pixels when he blinks.
  ;
  player0:
  %11100111
end
  return





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 2.
  ;
  ;
  bank 2



  ;***************************************************************
  ;
  ;  Object and enemy routines.
  ;
__Fireball_Enemy_Routine

  ;```````````````````````````````````````````````````````````````
  ;  New enemy/object on scroll check. If there is a new one,
  ;  initialize it then return. Not enough time to do anything
  ;  else after an init. We will make it function on the next
  ;  game loop.
  ;
  if _Object_Scroll_In_Data > 1 then gosub __Initialize_Enemy

  if ballx > 0 then bally = u else goto __Enemy_Routine

  ;```````````````````````````````````````````````````````````````
  ;  First we do Mario's fireball. If fireball isn't out, then
  ;  onto the next part.
  ;
  if _Bit2_Mario_Fireball_Direction{2} then ballx = ballx + 6 else ballx = ballx - 6

  bally = bally + 3

  if ballx > 137 then gosub __Kill_Fireball

  if ballx < 17 then gosub __Kill_Fireball

  if bally > 96 then gosub __Kill_Fireball

  x = (ballx - 17)/4 : y = bally/8

  if pfread(x,y) then goto __Fireball_Collision 

  goto __Enemy_Routine


__Fireball_Collision

  z = y - 1

  if pfread(x,z) then gosub __Kill_Fireball

  bally = bally - 6


__Enemy_Routine

  ;```````````````````````````````````````````````````````````````
  ;  Checks for that kicked __Moving turtle shell if it exists and
  ;  does what needs to be done with it.
  ;
  if _Moving_Shell_X_Coordinate > 0 || _Moving_Shell_Y_Coordinate > 0 then gosub __Moving_Shell_Routine

  if _Moving_Shell_Y_Coordinate > 0 && player1x > 0 then gosub __Render_Screen bank1

  ;```````````````````````````````````````````````````````````````
  ;  If there are no enemies on the screen then just loop game
  ;  cycle. Going back to __Main_Loop renders a new screen.
  ;
  if player1x = 0 then goto __Main_Loop bank1

  ;```````````````````````````````````````````````````````````````
  ;  If enemy goes off screen, then get rid of it.
  ;
  if player1x > 136 || player1x < 17 then gosub __Kill_Enemy : goto __Main_Loop bank1

  ;```````````````````````````````````````````````````````````````
  ;  If enemy has been killed, then continue dying routine.
  ;
  if _Bit4_Enemy_Dead_Flag{4} then goto __Enemy_Death_Routine

  ;```````````````````````````````````````````````````````````````
  ;  Takes care of each enemy and object. Checks which one it is
  ;  and goes to its routine to make it do its thing.
  ;
  if _Enemy_Type = _Bowser_Jr then goto __Bowser_Jr bank4

  if _Enemy_Type = _Thwomp || _Enemy_Type = _Two_Thwomps then goto __Thwomp bank8

  if _Enemy_Type = _Flying_Red_Koopa then goto __Red_Flying_Koopa

  if _Enemy_Type = _Spiney_Ball then goto __Spiney_Ball

  if _Enemy_Type = _Fireball_Enemy then goto __Fireball_Enemy

  if _Enemy_Type = _Pirahna_Plant then goto __Pirahna_Plant

  if _Enemy_Type = _Kinetic_Platforms then goto __Kinetic_Platform

  if _Enemy_Type = _Flagpole then goto __Enemy_Collision_Check

  if _Enemy_Type > _Flagpole && _Enemy_Type < _Kinetic_Platforms then goto __Special_Item

  if _Enemy_Type > _P_Plant_31 && _Enemy_Type < _P_Plant_39 then goto __Enemy_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  The first 7 enemy types will go left or right.
  ;
  if _Enemy_Type = _Bullet_Bill then x = 2 else x = 1

  if _Bit7_2nd_Quest{7} then x = x * 2

  if _Bit3_Enemy_Direction{3} then player1x = player1x + x else player1x = player1x - x

  if player1x < 17 || player1x > 137 then gosub __Kill_Enemy : goto __Main_Loop bank1



  ;***************************************************************
  ;
  ;  Enemy collision detection routines.
  ;
__Enemy_Collision_Check

  ;```````````````````````````````````````````````````````````````
  ;  If the enemy is airborne, we don't need to see if it's
  ;  standing on a platform.
  ;
  if _Enemy_Type > _Red_Koopa && _Enemy_Type < _Beetle_Shell then goto __Enemy_LR_Check

  if _Enemy_Momentum < 7 then _Enemy_Momentum = _Enemy_Momentum + 1

  player1y = player1y + _Enemy_Momentum

  if _Bit3_Enemy_Direction{3} then x = (player1x - 17)/4 else x = (player1x - 9)/4

  if _Bit3_Enemy_Direction{3} && _Enemy_Type = _Red_Koopa then x = x + 1

  if !_Bit3_Enemy_Direction{3} && _Enemy_Type = _Red_Koopa then x = x - 1

  y = (player1y + 1)/8

  if pfread(x,y) then player1y = (y * 8) - 1 : _Enemy_Momentum = 0 : goto __Enemy_LR_Check

  ;```````````````````````````````````````````````````````````````
  ;  If it's the red turtle, he wont fall off platform.
  ;
  if _Enemy_Type = _Red_Koopa && _Enemy_Momentum <> 8 then gosub __Fix_Enemy : player1y = (y * 8) - 1 : _Enemy_Momentum = 0 : goto __Enemy_LR_Check

  ;```````````````````````````````````````````````````````````````
  ;  If this is the dual goombas, just get rid of the original
  ;  since its going to fall anyway and we can't have its copy
  ;  fall through the solid platform.
  ;
  if _Enemy_Type = _Two_Goombas then player1x = player1x + 16 : _Enemy_Type = _Goomba

  if _Enemy_Type = _Two_Spineys then player1x = player1x + 16 : _Enemy_Type = _Spiney

  if player1y > 90 then gosub __Kill_Enemy : goto __Main_Loop bank1

__Enemy_LR_Check
  ;```````````````````````````````````````````````````````````````
  ;  If its Bullet Bill, then he can pass through the playfield.
  ;
  if _Enemy_Type = _Bullet_Bill then goto __Enemy_End_Move

  if !collision(playfield,player1) then goto __Enemy_End_Move

  gosub __Fix_Enemy


__Enemy_End_Move
  ;```````````````````````````````````````````````````````````````
  ;  Prep correct object or enemy to display.
  ;
  if _Enemy_Type > 29 && _Enemy_Type < _Two_Goombas then goto __Enemy_End_Move_32

  if _Animation_Timer > 3 && !_Bit4_Enemy_Dead_Flag{4} then x = _Enemy_Type + 1 else x = _Enemy_Type

  if x = 42 || x = 43 then x = x - 42

  if x = 46 || x = 47 then x = x - 40

  on x gosub __Goomba_Color __Goomba_Color __Green_Koopa_Color __Green_Koopa_Color __Beetle_Color __Beetle_Color __SpineyC __SpineyC __Red_Koopa_Color __Red_Koopa_Color __Green_Koopa_Color __Green_Koopa_Color __Bullet_Bill __Bullet_Bill __Red_Koopa_Color __Red_Koopa_Color __Spny_Ball_Color __Spny_Ball_Color __Fireball_Color __Fireball_Color __Flagpole __Flagpole __CoinC __CoinC __StarC1 __StarC2 __1UPC __1UPC __PlatformC __PlatformC

  on x gosub __Goomba_1 __Goomba_2 __Koopa_1 __Koopa_2 __Beetle_1 __Beetle_2 __Spiney1 __Spiney2 __Koopa_1 __Koopa_2 __F_Koopa_1 __F_Koopa_2 __Bullet_Bill __Bullet_Bill __F_Koopa_1 __F_Koopa_2 __Spny_Ball_1 __Spny_Ball_2 __Fireball_1 __Fireball_2 __Flagpole __Flagpole __Coin1 __Coin2 __Star __Star __1UPMush __1UPMush __Platform __Platform

  goto __Main_Loop bank1

__Enemy_End_Move_32

  x = _Enemy_Type - 30

  on x gosub __PirahnaC __PirahnaC __SBColor __SBColor __SGKColor __SGKColor __SRKColor __SRKColor __Tramp1C __Tramp1C 

  if _Animation_Timer > 3 && !_Bit4_Enemy_Dead_Flag{4} then x = x + 1

  on x gosub __Pirahna1 __Pirahna2 __ShellB __ShellB __ShellK __ShellK __ShellK __ShellK __Tramp1 __Tramp1

  ;```````````````````````````````````````````````````````````````
  ;  Time to go back to the beginning of the game cycle again!
  ;
  goto __Main_Loop bank1



  ;***************************************************************
  ;
  ;  The routines below are all the enemy / object handling
  ;  routines. They make player1's sprite do what they need to
  ;  do. You can pretty much figure out which one is which by the
  ;  beginning label.
  ;
__Red_Flying_Koopa

  if _Bit7_2nd_Quest{7} then x = 4 else x = 2

  if _Bit3_Enemy_Direction{3} then player1y = player1y + x else player1y = player1y - x

  if player1y > 72 then gosub __Fix_Enemy : player1y = 72

  if player1y < 24 then gosub __Fix_Enemy : player1y = 24

  goto __Enemy_End_Move

__Spiney_Ball

  player1y = player1y + 4

  if _Bit3_Enemy_Direction{3} then x = (player1x - 17)/4 else x = (player1x - 9)/4

  y = (player1y + 1)/8

  if pfread(x,y) then _Enemy_Type = _Spiney

  goto __Enemy_End_Move

__Fireball_Enemy

  if _Bit3_Enemy_Direction{3} then player1y = player1y + _Enemy_Momentum else player1y = player1y - _Enemy_Momentum

  if _Bit3_Enemy_Direction{3} && player1y > 120 then _Bit3_Enemy_Direction{3} = 0

  if !_Bit3_Enemy_Direction{3} && player1y < 40 then _Enemy_Momentum = _Enemy_Momentum - 2

  if _Bit3_Enemy_Direction{3} && _Enemy_Momentum < 6 then _Enemy_Momentum = _Enemy_Momentum + 2

  if _Enemy_Momentum = 0 then _Bit3_Enemy_Direction{3} = 1

  x = player0x - 16

  if x > player1x then gosub __Kill_Enemy : goto __Main_Loop bank1

  goto __Enemy_End_Move

__Pirahna_Plant

  x = player1x + 16

  if player0x > x then gosub __Kill_Enemy : goto __Main_Loop bank1

  if _Bit3_Enemy_Direction{3} then player1y = 64 else player1y = 120

  _Enemy_Momentum = _Enemy_Momentum + 1

  if _Bit7_2nd_Quest{7} then x = 32 else x = 48

  if _Enemy_Momentum < x then goto __Enemy_End_Move

  _Enemy_Momentum = 0

  if _Bit3_Enemy_Direction{3} then _Bit3_Enemy_Direction{3} = 0 else _Bit3_Enemy_Direction{3} = 1

  goto __Enemy_End_Move

__Kinetic_Platform

  if collision(player1,playfield) then goto __K_Platform_03

  if player1y > 72 && _Bit3_Enemy_Direction{3} then _Enemy_Momentum = _Enemy_Momentum - 1 : goto __K_Platform_02

  if player1y < 24 && !_Bit3_Enemy_Direction{3} then _Enemy_Momentum = _Enemy_Momentum - 1 : goto __K_Platform_02

  if _Enemy_Momentum < 5 then _Enemy_Momentum = _Enemy_Momentum + 1

  goto __K_Platform_04

__K_Platform_02

  if _Enemy_Momentum > 0 then goto __K_Platform_04

__K_Platform_03

  if _Bit3_Enemy_Direction{3} then _Bit3_Enemy_Direction{3} = 0 else _Bit3_Enemy_Direction{3} = 1

__K_Platform_04

  if _Bit3_Enemy_Direction{3} then player1y = player1y + _Enemy_Momentum else player1y = player1y - _Enemy_Momentum

  goto __Enemy_End_Move

__Kill_Fireball

  ballx = 0 : bally = 120

  return thisbank


  ;***************************************************************
  ;
  ;  Initialize the enemy.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  You guessed it. This is the part that initializes the enemy.
  ;  Basically, where it gets placed on the screen when it is
  ;  spawned and what direction it is __Moving into. If Mario is
  ;  __Moving right then it'll spawn on the right side of the
  ;  screen, facing left. Vice versa if Mario is __Moving left.
  ;
__Initialize_Enemy

  ;```````````````````````````````````````````````````````````````
  ;  If enemy is already on the screen, we can't put another on,
  ;  unless it's the flagpole, then it gets priority.
  ;
  if _Object_Scroll_In_Data > 151 && _Object_Scroll_In_Data < 168 && _Level = 3 then goto __Init_Enemy_02

  if _Object_Scroll_In_Data > 167 && _Object_Scroll_In_Data < 184 then goto __Init_Enemy_02

  if _Object_Scroll_In_Data > 135 && _Object_Scroll_In_Data < 152 && _Level = 4 then goto __Init_Enemy_02

  if player1x > 0 then return thisbank

__Init_Enemy_02

  _Enemy_Type = _Object_Scroll_In_Data/8

  _Enemy_Type = _Enemy_Type - 1 : _Enemy_Momentum = 0

  if _Enemy_Type > 21 && _Enemy_Type < 27 then _Enemy_Type = _Enemy_Type + 20

  _Bit4_Enemy_Dead_Flag{4} = 0

  if _Bit7_2nd_Quest{7} && _Enemy_Type = _Goomba then _Enemy_Type = _Beetle

  if _Bit7_2nd_Quest{7} && _Enemy_Type = _Two_Goombas then _Enemy_Type = _Beetle

  if _Bit7_2nd_Quest{7} && _Enemy_Type = _Green_Koopa && _Animation_Timer > 3 then _Enemy_Type = _Red_Koopa

  if  _Enemy_Type = _Two_Thwomps then z = 24 : _Enemy_Momentum = 0 : _Bit3_Enemy_Direction{3} = 0 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Bullet_Bill && _Level = 4 && _Bit0_Player_Facing_Direction{0} then _Enemy_Type = _Goomba : return thisbank

  if _Enemy_Type = _Bullet_Bill then AUDC0 = 8 : AUDF0 = 31

  if _Enemy_Type > 9 && _Enemy_Type < 15 then z = (_Animation_Timer + 8) * 4 : goto __Enemy_Facing_Init

  if _Enemy_Type = _Spiney_Ball && _Level = 4 then _Enemy_Type = _Thwomp : z = 24 : _Enemy_Momentum = 0 : _Bit3_Enemy_Direction{3} = 0 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Spiney_Ball && _Level = 2 then _Enemy_Type = _Thwomp : z = 24 : _Enemy_Momentum = 0 : _Bit3_Enemy_Direction{3} = 0 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Spiney_Ball then z = 8 : _Bit3_Enemy_Direction{3} = 0 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Fireball_Enemy then z = 121 : _Bit3_Enemy_Direction{3} = 0 : _Enemy_Momentum = 6 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Kinetic_Platforms then z = 48 : _Bit3_Enemy_Direction{3} = 0 : goto __Finish_Enemy_Init

  if _Enemy_Type = _Pirahna_Plant then z = 120 : _Enemy_Momentum = 0 : _Bit3_Enemy_Direction{3} = 1 : goto __Finish_Enemy_Init

  y = 1

  if _Bit0_Player_Facing_Direction{0} then x = 0 else x = 31

__Init_Enemy_Placement

  y = y + 1

  ;```````````````````````````````````````````````````````````````
  ;  If there is no surface to start the enemy on, then return.
  ;
  if y = 11 then return

  if pfread(x,y) then z = (y * 8) - 1 else goto __Init_Enemy_Placement

__Enemy_Facing_Init

  if _Bit0_Player_Facing_Direction{0} then _Bit3_Enemy_Direction{3} = 1

  if !_Bit0_Player_Facing_Direction{0} then _Bit3_Enemy_Direction{3} = 0

__Finish_Enemy_Init

  if _Bit0_Player_Facing_Direction{0} then x = 17 else x = 135

  if _Enemy_Type = _Spiney_Ball then x = 96 + (_Animation_Timer * 4)

  player1x = x : player1y = z

  if _Enemy_Type = _Flagpole || _Enemy_Type = _Trampoline then _Bit3_Enemy_Direction{3} = 0

  gosub __Render_Screen bank1

  return thisbank

  ;```````````````````````````````````````````````````````````````
  ;  Reposition enemy (sprite 1) on screen scroll.
  ;
  if _Bit0_Player_Facing_Direction{0} then y = 0 else y = 8

  player1x = player1x + 4 - y

  return thisbank

  ;```````````````````````````````````````````````````````````````
  ;  Resets player1 and its associated variables.
  ;
__Kill_Enemy

  player1x = 0 : player1y = 150 : _Enemy_Type = _Goomba : _Bit3_Enemy_Direction{3} = 0 : _Enemy_Momentum = 0 : _Bit4_Enemy_Dead_Flag{4} = 0

  return thisbank

__Fix_Enemy

  if _Bit3_Enemy_Direction{3} then _Bit3_Enemy_Direction{3} = 0 else _Bit3_Enemy_Direction{3} = 1

  x = 2

  if _Enemy_Type = _Green_Koopa || _Enemy_Type = _Flying_Green_Koopa then x = 4

  if _Enemy_Type = _Red_Koopa then x = 4

  if _Bit7_2nd_Quest{7} then x = x * 2

  if _Bit3_Enemy_Direction{3} then player1x = player1x + x else player1x = player1x - x

  return thisbank

  ;```````````````````````````````````````````````````````````````
  ;  This routine is executed when you successfully shoot, stomp,
  ;  or whatever means necessary get rid of an enemy. This is
  ;  their "dying" sequence.
  ;
__Enemy_Death_Routine

  player1y = player1y + _Enemy_Momentum

  if _Enemy_Momentum < 6 then _Enemy_Momentum = _Enemy_Momentum + 1

  if player1y > 90 then gosub __Kill_Enemy

  if _Enemy_Momentum = 6 then goto __Enemy_End_Move

  temp4 = 26 - _Enemy_Momentum

  AUDV0 = 12
  AUDC0 = 4
  AUDF0 = temp4

  goto __Enemy_End_Move

  ;```````````````````````````````````````````````````````````````
  ;  This takes care of the kicked Koopa shell.
  ;
__Moving_Shell_Routine

  x = _Moving_Shell_X_Coordinate + 1

  pfpixel _Moving_Shell_X_Coordinate _Moving_Shell_Y_Coordinate off

  pfpixel x _Moving_Shell_Y_Coordinate off

  if _Bit5_Moving_Turtle_Shell_Direction{5} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate - 2 else _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate + 2

  if _Moving_Shell_X_Coordinate < 0 then _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0 : return thisbank

  if _Moving_Shell_X_Coordinate > 30 then _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0 : return thisbank

  y = _Moving_Shell_Y_Coordinate + 1

  if pfread(_Moving_Shell_X_Coordinate,y) then goto __Moving_Shell_02

  if pfread(x,y) then goto __Moving_Shell_02

  _Moving_Shell_Y_Coordinate = _Moving_Shell_Y_Coordinate + 1

  if _Moving_Shell_Y_Coordinate = 11 then _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0 : return thisbank

__Moving_Shell_02

  if _Level = 3 then goto __Moving_Shell_03

  y = 0

  if pfread(_Moving_Shell_X_Coordinate,_Moving_Shell_Y_Coordinate) then goto __Change_Shell_Direction

  y = 1

  x = _Moving_Shell_X_Coordinate + 1

  if pfread(x,_Moving_Shell_Y_Coordinate) then goto __Change_Shell_Direction

__Moving_Shell_03

  x = _Moving_Shell_X_Coordinate + 1

  pfpixel _Moving_Shell_X_Coordinate _Moving_Shell_Y_Coordinate on

  pfpixel x _Moving_Shell_Y_Coordinate on

  ;```````````````````````````````````````````````````````````````
  ;  Check for shell hitting enemy.
  ;
  if _Bit4_Enemy_Dead_Flag{4} || _Enemy_Type = _Flagpole then return thisbank

  x = (_Moving_Shell_X_Coordinate * 4) + 17

  y = (_Moving_Shell_X_Coordinate * 4) + 25

  if player1x >= x && player1x <= y then goto __Moving_Shell_04

  return thisbank

__Moving_Shell_04

  x = (_Moving_Shell_Y_Coordinate * 8)

  y = (_Moving_Shell_Y_Coordinate * 8) + 8

  if player1y >= x && player1y <= y then _Bit4_Enemy_Dead_Flag{4} = 1 : score = score + 400

  if _Enemy_Type > 41 then score = score + 800

  return thisbank

__Change_Shell_Direction

  if _Moving_Shell_Y_Coordinate < 8 && _Level < 3 then goto __Destroy_Block

  AUDV0 = 12
  AUDC0 = 1
  AUDF0 = 31

__Change_Shell_Dir_02

  if _Bit5_Moving_Turtle_Shell_Direction{5} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate + 4 : _Bit5_Moving_Turtle_Shell_Direction{5} = 0 : goto __Moving_Shell_03

  if !_Bit5_Moving_Turtle_Shell_Direction{5} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate - 4 : _Bit5_Moving_Turtle_Shell_Direction{5} = 1

  goto __Moving_Shell_03

__Destroy_Block

  score = score + 20

  if y = 0 then pfpixel _Moving_Shell_X_Coordinate _Moving_Shell_Y_Coordinate off

  if y = 1 then pfpixel x _Moving_Shell_Y_Coordinate off

  AUDV0 = 10
  AUDC0 = 7
  AUDF0 = 22

  goto __Change_Shell_Dir_02

__Special_Item

  if _Enemy_Momentum > 249 then gosub __Kill_Enemy : goto __Enemy_End_Move

  if _Enemy_Momentum > 199 then _Enemy_Momentum = _Enemy_Momentum + 1 : goto __Enemy_End_Move

  if _Bit3_Enemy_Direction{3} then _Enemy_Momentum = _Enemy_Momentum + 1 else _Enemy_Momentum = _Enemy_Momentum - 1

  if _Enemy_Momentum = 0 then _Bit3_Enemy_Direction{3} = 1

  if _Enemy_Momentum > 6 then _Enemy_Momentum = 6

  player1y = player1y + _Enemy_Momentum

  if _Enemy_Momentum < 5 then goto __Enemy_End_Move

  x = (player1x - 17)/4 : y = player1y/8

  if pfread(x,y) then player1y = (y * 8) - 1 : _Enemy_Momentum = 200

  goto __Enemy_End_Move

__Title_Screen

  ;***************************************************************
  ;
  ;  Sets the playfield colors.
  ;
  pfcolors:
  $08
  $0C
  $08
  $0A
  $0A
  $0C
  $08
  $0A
  $0A
  $0A
  $D4
end



  ;***************************************************************
  ;
  ;  Here's the castle.
  ;
  playfield:
  ................................
  ..........X..XX..XX..X..........
  ..........XXXXXXXXXXXX..........
  ..........XXX..XX..XXX..........
  ..........XXX..XX..XXX..........
  ......X..XX..XX..XX..XX..X......
  ......XXXXXXXXXXXXXXXXXXXX......
  ......XX..XXXX....XXXX..XX......
  ......XX..XXXX....XXXX..XX......
  ......XXXXXXXX....XXXXXXXX......
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end



  ;***************************************************************
  ;
  ;  This part makes Mario walk around BEHIND the playfiled blocks
  ;  to make him look like he's inside the castle and checks to
  ;  see if you press the action button to start. The call to the
  ;  routine __Set_Up_Mario in bank 1 is there, because that is
  ;  where the program determines what Mario sprite we use. Bank 1
  ;  is where all the Mario sprites exist. You'll notice that
  ;  there's a lot of jumping around in this program so I don't
  ;  have to do the same code twice and waste valuable ROM program
  ;  space! I also do this because data in ROM and tables in ROM
  ;  can only exist 1 bank at a time and since the Mario sprite
  ;  tables exist in bank 1, we need to go there! The game is also
  ;  set at 20 FPS (3 drawscreens per game cycle) to execute enough
  ;  of the code before the game recycles back to the top of the
  ;  gameplay code. This is why below there is a for/next loop of
  ;  3 drawscreens to keep the illusion of 20 FPS in the title
  ;  screen. Once the button is pressed, it's back to bank 1 we go
  ;  to the next routine, "__Main_Loop".
  ;
  player0y = 150 : player0x = 42 : _Bit3_Super_Mario_Power{3} = 1 : _Momentum_Left_Right = 2

  _Animation_Timer = 0 : _Level_Timer = 0 : _Bit6_Regular_Mario{6} = 0 : _Bit0_Player_Facing_Direction{0} = 0


__S2

  _Animation_Timer = _Animation_Timer + 1 

  if _Animation_Timer > 6 then _Animation_Timer = 0 : _Level_Timer = _Level_Timer + 1

  if player0y > 100 && _Level_Timer < 4 then goto __S3

  _Level_Timer = 0 : player0y = 79

  if _Bit0_Player_Facing_Direction{0} then player0x = player0x - 1 else player0x = player0x + 1

  if player0x < 42 then player0x = 42 : player0y = 150 : _Bit0_Player_Facing_Direction{0} = 0

  if player0x > 112 then player0x = 112 : player0y = 150 : _Bit0_Player_Facing_Direction{0} = 1

__S3

  gosub __Set_Up_Mario bank1

  for x = 1 to 3

  CTRLPF = $15

  if _Bit0_Player_Facing_Direction{0} then REFP0 = 8

  drawscreen

  next x

  if !joy0fire then goto __S2

  _Bit6_Regular_Mario{6} = 1

  _Bit3_Super_Mario_Power{3} = 0 : _Bit0_Player_Facing_Direction{0} = 0

  return otherbank



  ;***************************************************************
  ;
  ;  All the color and sprite tables for the enemies and objects.
  ;
__Goomba_Color
  player1color:
  $06
  $06
  $2E
  $2E
  $36
  $36
  $36
  $36
  $36
  $36
  $36
end
  return thisbank

__Goomba_1
  player1:
  %11100110
  %01000011
  %00111100
  %00111100
  %01111110
  %11111111
  %11011011
  %11000011
  %10111101
  %01111110
  %00111100
end
  return thisbank

__Goomba_2
  player1:
  %01100111
  %11000010
  %00111100
  %00111100
  %01111110
  %11111111
  %11011011
  %11000011
  %10111101
  %01111110
  %00111100
end
  return thisbank

__Beetle_Color
  player1color:
  $2E
  $2E
  $36
  $28
  $2A
  $2A
  $36
  $36
  $36
  $38
end
  return thisbank

__Beetle_1
  player1:
  %01100011
  %00110110
  %00111111
  %11110101
  %11010101
  %01110101
  %10001001
  %01110001
  %00100010
  %00011100
end
  return thisbank

__Beetle_2
  player1:
  %00110110
  %00110110
  %00111111
  %11110101
  %11010101
  %01110101
  %10001001
  %01110001
  %00100010
  %00011100
end
  return thisbank

__Bullet_Bill
  player1color:
  $0A
  $08
  $0A
  $0C
  $0E
  $0E
  $0C
  $0A
end

  player1:
  %00111101
  %01111101
  %01111101
  %11111101
  %11011101
  %01011101
  %01101101
  %00111101
end
  return thisbank

__Fireball_Color
  player1color:
  $44
  $46
  $38
  $3A
  $3A
  $38
  $46
  $44
end
  return thisbank

__Fireball_1
  player1:
  %00111010
  %01110100
  %11110001
  %11111100
  %11011110
  %11101110
  %01111110
  %00111100
end
  return thisbank

__Fireball_2
  player1:
  %00111100
  %01111110
  %01110111
  %01111011
  %00111111
  %10001111
  %00101110
  %01011100
end 
  return thisbank

__Green_Koopa_Color
  player1color:
  $2E
  $2E
  $C4
  $C6
  $C8
  $C8
  $C6
  $2E
  $2E
  $2E
  $2E
  $2E
  $2E
end
  return thisbank

__Red_Koopa_Color
  player1color:
  $2E
  $2E
  $48
  $4A
  $4A
  $48
  $46
  $2E
  $2E
  $2E
  $2E
  $2E
  $2E
end
  return thisbank

__F_Koopa_1
  player1:
  %01110111
  %00100010
  %00111110
  %01101011
  %01010101
  %00101010
  %00011100
  %11100010
  %00110101
  %11010110
  %10110111
  %10100011
  %01100001
end
  return thisbank

__F_Koopa_2
  player1:
  %00110110
  %00110110
  %00111110
  %01101011
  %01010101
  %00101010
  %00011100
  %11100010
  %00110111
  %11010011
  %10110000
  %10100000
  %01100000
end
  return thisbank

__Koopa_1
  player1:
  %01110111
  %00100010
  %00111110
  %01101011
  %01010101
  %00101010
  %00011100
  %11100000
  %00110000
  %11010000
  %10110000
  %10100000
  %01100000
end
  return thisbank

__Koopa_2
  player1:
  %00110110
  %00110110
  %00111110
  %01101011
  %01010101
  %00101010
  %00011100
  %11100000
  %00110000
  %11010000
  %10110000
  %10100000
  %01100000
end
  return thisbank

__Spny_Ball_Color
  player1color:
  $1E
  $48
  $48
  $46
  $44
  $44
  $46
  $48
  $1E
end
  return thisbank

__Spny_Ball_1
  player1:
  %01010100
  %00111100
  %01101110
  %11011111
  %11111111
  %11111011
  %01110110
  %00111100
  %00101010
end
  return thisbank

__Spny_Ball_2
  player1:
  %00101010
  %00111100
  %01110110
  %11111011
  %11111111
  %11011111
  %01101110
  %00111100
  %01010100
end
  return thisbank

__SBColor
  player1color:
  $36
  $26
  $2A
  $2A
  $36
  $36
  $36
  $38
end
  return thisbank

__ShellB
  player1:
  %00111100
  %01100110
  %10000001
  %10000001
  %01001010
  %01000010
  %00100100
  %00011000
end
  return thisbank

__SGKColor
  player1color:
  $2E
  $2E
  $C8
  $CA
  $CA
  $C8
  $C8
  $C6
end
  return thisbank

__SRKColor 
  player1color:
  $2E
  $2E
  $48
  $4A
  $4A
  $48
  $48
  $46
end
  return thisbank

__ShellK
  player1:
  %00100100
  %01011010
  %10111101
  %11011011
  %01100110
  %01011010
  %00111100
  %00011000
end
  return thisbank

__SpineyC
  player1color:
  $2E
  $2E
  $46
  $44
  $44
  $48
  $1A
  $1C
  $1E
end
  return thisbank

__Spiney1
  player1:
  %01110111
  %00100010
  %01111111
  %10110101
  %11101011
  %00110110
  %00101010
  %00101010
  %00001000
end
  return thisbank

__Spiney2
  player1:
  %00110110
  %00110110
  %01111111
  %10110101
  %11101011
  %00110110
  %00101010
  %00101010
  %00001000
end
  return thisbank

__Flagpole
  player1color:
  $0A
  $08
  $C4
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C4
  $0A
  $0C
  $0E
  $0E
  $0E
  $0C
  $0A
  $CA
end

  player1:
  %00000111
  %00000011
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00001110
  %00111110
  %11101010
  %11110110
  %11110110
  %00111110
  %00001110
  %00000001
end
  return thisbank

__1UPC
  player1color:
  $2A
  $2A
  $D8
  $C6
  $0C
  $0C
  $C6
  $C8
end
  return thisbank

__1UPMush
  player1:
  %00110100
  %00111100
  %11111111
  %11111111
  %11001111
  %01010110
  %00100100
  %00011000
end
  return thisbank

__CoinC
  player1color:
  $08
  $0A
  $0C
  $0C
  $0C
  $0C
  $0A
  $08
end
  return thisbank

__Coin1
  player1:
  %00011000
  %00100100
  %01011010
  %01011010
  %01011010
  %01011010
  %00100100
  %00011000
end
  return thisbank

__Coin2
  player1:
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
end
  return thisbank

__StarC1
  player1color:
  $1E
  $1E
  $1E
  $1E
  $1E
  $1E
  $1E
  $1E
end
  return thisbank

__StarC2
  player1color:
  $1E
  $28
  $28
  $28
  $28
  $28
  $28
  $28
end
  return thisbank

__Star
  player1:
  %00000000
  %11000110
  %01101100
  %00111000
  %01111100
  %11010110
  %00111000
  %00010000
end
  return thisbank

__PirahnaC
  player1color:
  $2A
  $2A
  $2A
  $2A
  $2A
  $2E
  $2E
  $C8
  $C8
  $CA
  $CA
  $CA
  $C8
  $C8
  $C6
end
  return thisbank

__Pirahna1
  player1:
  %00011000
  %00111100
  %01011010
  %10111101
  %11011011
  %00011000
  %00011000
  %00111100
  %01110110
  %11011111
  %11111101
  %10100111
  %11000011
  %11000011
  %10000001
end
  return thisbank

__Pirahna2
  player1:
  %00011000
  %00111100
  %01011010
  %10111101
  %11011011
  %00011000
  %00011000
  %00111100
  %01110110
  %11011111
  %11111101
  %10100111
  %11100111
  %01100110
  %00100100
end
  return thisbank

__PlatformC
  player1color:
  $44
  $38
  $38
  $3A
  $3A
  $38
  $44
  $3E
end
  return thisbank

__Platform
  player1:
  %11111111
  %11111111
  %10111101
  %10011001
  %10011001
  %10111101
  %11111111
  %11111111
end
  return thisbank

__Tramp1C
  player1color:
  $4A
  $0A
  $0C
  $0E
  $0E
  $0C
  $0A
  $46
end
  return thisbank

__Tramp1
  player1:
  %11111111
  %00111100
  %01100110
  %11000011
  %11000011
  %01100110
  %00111100
  %11111111
end
  return thisbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 3.
  ;
  ;
  bank 3


  ;***************************************************************
  ;
  ;  This part takes care of all the controls, how to position
  ;  Mario, and other miscellaneous functions.
  ;
__Draw

  ;```````````````````````````````````````````````````````````````
  ;  Increases the animation frame.
  ;
  _Animation_Timer = _Animation_Timer + 1

  ;```````````````````````````````````````````````````````````````
  ;  If we are at a boss fight skip everything that has to do with
  ;  the timer, since that part isn't timed.
  ;
  if _Enemy_Type > 63 then goto __Draw_Boss

  ;```````````````````````````````````````````````````````````````
  ;  Timer/animation handling.
  ;
  if _Animation_Timer > 7 then _Animation_Timer = 0 : _Level_Timer = _Level_Timer  + 1

  ;```````````````````````````````````````````````````````````````
  ;  If level timer is at max, then take a notch off overall level
  ;  timer and set invincibility flag to 0.
  ;
  if _Level_Timer > 6 && _Bit7_Mario_Invincibility{7} && _Star_Invincibility_Timer = 0 then _Bit7_Mario_Invincibility{7} = 0

  if _Star_Invincibility_Timer > 0 then _Star_Invincibility_Timer = _Star_Invincibility_Timer + 1 

  if _Star_Invincibility_Timer = 160 then gosub __Star_Power_End

  if _Level_Timer > 25 then _Level_Timer = 0 : pfscore1 = pfscore1/2

  if pfscore1 = 0 then goto __Mario_Death

  if pfscore1 < 6 && pfscore1 > 2 && _Level_Timer < 5 then AUDV0 = 10 : AUDC0 = 1 : AUDF0 = 10

  goto __Draw_2

__Draw_Boss

  ;```````````````````````````````````````````````````````````````
  ;  Boss fight animation and Bowser Jr.'s sequence handling.
  ;
  if _Animation_Timer > 7 then _Animation_Timer = 0

  if _Star_Invincibility_Timer > 0 then _Star_Invincibility_Timer = _Star_Invincibility_Timer + 1

  if _Star_Invincibility_Timer = 40 then _Star_Invincibility_Timer = 0 : _Bit7_Mario_On_Off{7} = 0 : _Bit7_Mario_Invincibility{7} = 0

__Draw_2

  ;```````````````````````````````````````````````````````````````
  ;  If player is below visible screen that means he fell to his
  ;  death.
  ;
  if player0y > 94 then goto __Mario_Death

  ;```````````````````````````````````````````````````````````````
  ;  For x - 3 levels, check to see if player is at the end of
  ;  the first part of that stage, if so, then spawn that
  ;  trampoline so they can get to the second half.
  ;
  if _Level = 3 && _Level_Data_Pointer > 126 && player1y > 96 then _Enemy_Type = _Trampoline : player1x = 135 : player1y = 79

  ;```````````````````````````````````````````````````````````````
  ;  Joystick handling routines.
  ;
  if !joy0down then _Bit5_Ducking_Flag{5} = 0

  if joy0down && player0y = 63 && _Momentum_Up_Down = 0 && player0x > 110 then goto __Checkpoint

__More_Joy_Checks

  if joy0down && !_Bit6_Regular_Mario{6} then _Bit5_Ducking_Flag{5} = 1

  if joy0left && !_Bit5_Ducking_Flag{5} then _Bit0_Player_Facing_Direction{0} = 1 : goto __Moving

  if joy0right  && !_Bit5_Ducking_Flag{5} then _Bit0_Player_Facing_Direction{0} = 0  : goto __Moving

  if _Momentum_Left_Right > 0 then _Momentum_Left_Right = _Momentum_Left_Right - 1

  goto __Check_Fire



  ;***************************************************************
  ;
  ;  As you probably figured, Mario has momentum as provided with
  ;  the _Momentum_Left_Right variable, so when you move left or
  ;  right you're actually adjusting the momentum variable. His
  ;  position is calculated by using the _Momentum_Left_Right and
  ;  _Momentum_Up_Down variables.
  ;
__Moving
  _Momentum_Left_Right = _Momentum_Left_Right + 1

  ;```````````````````````````````````````````````````````````````
  ;  Genesis controller C button.
  ;
  if _Bit0_Genesis_Controller{0} && !INPT1{7} && _Momentum_Left_Right > 4 then _Momentum_Left_Right = 4

  if _Bit0_Genesis_Controller{0} && INPT1{7} && _Momentum_Left_Right > 2 then _Momentum_Left_Right = 2

  if _Bit0_Genesis_Controller{0} then goto __Check_Fire

  ;```````````````````````````````````````````````````````````````
  ;  Do this if using Atari joystick.
  ;
  if joy0up && _Momentum_Left_Right > 4 then _Momentum_Left_Right = 4

  if !joy0up && _Momentum_Left_Right > 2 then _Momentum_Left_Right = 2

__Check_Fire

  ;```````````````````````````````````````````````````````````````
  ;  Genesis controller C button.
  ;
  if _Bit0_Genesis_Controller{0} && INPT1{7} then _Bit1_Genesis_Button_Pressed{1} = 0

  if _Bit0_Genesis_Controller{0} && !INPT1{7} && _Bit4_Firey_Mario_Power{4} && ballx = 0 && !_Bit1_Genesis_Button_Pressed{1} then gosub __Init_Fire

  if _Bit0_Genesis_Controller{0} then goto __Check_Jump

  ;```````````````````````````````````````````````````````````````
  ;  Do this if using Atari joystick.
  ;
  if !joy0up then _Bit1_Genesis_Button_Pressed{1} = 0

  if joy0up && _Bit4_Firey_Mario_Power{4} && ballx = 0 && !_Bit1_Genesis_Button_Pressed{1} then gosub __Init_Fire

__Check_Jump

  if !joy0fire then _Bit2_Fire_Button_Pressed{2} = 0

  if joy0fire && !_Bit1_Jumping_Flag{1} && _Momentum_Up_Down = 0 && !_Bit2_Fire_Button_Pressed{2} then gosub __Init_Jump

  ;```````````````````````````````````````````````````````````````
  ;  Jumping sound effect.
  ;
  if !_Bit1_Jumping_Flag{1} then goto __Check_Shell

  temp4 = 6 + _Momentum_Up_Down

  AUDV0 = 12
  AUDC0 = 12
  AUDF0 = temp4

  ;```````````````````````````````````````````````````````````````
  ;  Turn off moving shell if its around for one draw because
  ;  if we don't then the Mario playfield collision routines will
  ;  get confused with it.
  ;
__Check_Shell

  if _Moving_Shell_X_Coordinate = 0 && _Moving_Shell_Y_Coordinate = 0 then goto __Music_Part

  pfpixel _Moving_Shell_X_Coordinate _Moving_Shell_Y_Coordinate off

  x = _Moving_Shell_X_Coordinate + 1

  pfpixel x _Moving_Shell_Y_Coordinate off



  ;***************************************************************
  ;
  ;  All the music routines reside in Bank 7.
  ;
__Music_Part

  if _Star_Invincibility_Timer > 0 && _Enemy_Type < 63 then goto __Get_Star_Music bank7 

  if _Level = 1 || _Level = 3 then goto __Get_Music bank7

  if _Level = 2 || _Level = 4 then goto __Get_UW_Music bank7

__Got_Music

  goto __Main_2 bank1

__Init_Jump

  _Bit1_Jumping_Flag{1} = 1  : _Momentum_Up_Down = 7  : _Bit2_Fire_Button_Pressed{2} = 1

  if _Momentum_Left_Right = 4 then _Momentum_Up_Down = 8

  return thisbank

__Init_Fire

  if _Bit0_Player_Facing_Direction{0} then ballx = player0x : _Bit2_Mario_Fireball_Direction{2} = 0 else ballx = player0x + 4 : _Bit2_Mario_Fireball_Direction{2} = 1

  bally = player0y - 8

  _Bit0_Mario_Fireball_Going_Down{0} = 1 : _Bit1_Genesis_Button_Pressed{1} = 1

  AUDV0 = 12
  AUDC0 = 14
  AUDF0 = 0

  return thisbank



  ;***************************************************************
  ;
  ;  Now if you've jumped on an enemy, this routine takes care of
  ;  how to dispose of them.
  ;
__Enemy_Hit

  if _Enemy_Type = _Two_Thwomps then goto __Draw

  score = score + 200

  if _Enemy_Type < _Flagpole && _Star_Invincibility_Timer = 0 then _Bit1_Jumping_Flag{1} = 1 : _Momentum_Up_Down = 2 : _Bit2_Fire_Button_Pressed{2} = 1

  if _Enemy_Type > 41 && _Star_Invincibility_Timer = 0 then _Bit1_Jumping_Flag{1} = 1 : _Momentum_Up_Down = 2 : _Bit2_Fire_Button_Pressed{2} = 1

  if _Star_Invincibility_Timer > 0 && _Enemy_Type > 41 then goto __Double_To_Single

  if _Star_Invincibility_Timer > 0 then goto __Enemy_Hit_2

  if _Enemy_Type < _Fireball_Enemy && joy0fire then _Momentum_Up_Down = 6

  if _Enemy_Type > 41 && joy0fire then _Momentum_Up_Down = 6 : AUDV0 = 12 : AUDC0 = 4 : AUDF0 = 24

  if !joy0fire then player0y = player0y - 3

  if _Enemy_Type > 41 then goto __Double_To_Single

  if _Enemy_Type = _Flying_Green_Koopa then _Enemy_Type = _Green_Koopa : goto __Draw

  if _Enemy_Type = _Flying_Red_Koopa then _Enemy_Type = _Red_Koopa : _Enemy_Momentum = 8 : goto __Draw

  if _Enemy_Type = _Green_Koopa then _Enemy_Type = _Green_Shell : goto __Draw

  if _Enemy_Type = _Beetle then _Enemy_Type = _Beetle_Shell : goto __Draw

  if _Enemy_Type = _Red_Koopa then _Enemy_Type = _Red_Shell : goto __Draw

  if _Enemy_Type > _P_Plant_31 && _Enemy_Type < _Trampoline then goto __Init_Kicked_Shell

__Enemy_Hit_2

  player1y = player1y - 3

  _Bit4_Enemy_Dead_Flag{4} = 1

  goto __Draw



  ;***************************************************************
  ;
  ;  This handles turning a dual Goomba into a single Goomba.
  ;
__Double_To_Single

  _Enemy_Type = _Enemy_Type - 42

  x = player1x + 8

  if player0x < x then player1x = player1x + 16

  goto __Draw



  ;***************************************************************
  ;
  ;  This routine handles how to dispose of an enemy if you shoot
  ;  them.
  ;
__Enemy_Hit_By_Fireball

  if _Enemy_Type = _Bowser_Jr then goto __Fireball_BJr_Collision bank4

  if _Enemy_Type = _Kinetic_Platforms then goto __Draw

  if _Enemy_Type < _Two_Goombas then ballx = 0 : bally = 120

  if _Enemy_Type = _Beetle then goto __Draw

  if _Enemy_Type = _Bullet_Bill then goto __Draw

  if _Enemy_Type = _Beetle_Shell then goto __Draw

  if _Enemy_Type = _Trampoline then goto __Draw

  if _Enemy_Type = _Thwomp || _Enemy_Type = _Two_Thwomps then goto __Draw

  if _Enemy_Type > 17 && _Enemy_Type < 29 then goto __Draw

  if _Enemy_Type = _Spiney_Ball then _Enemy_Type = _Spiney

  score = score + 100

  if _Enemy_Type > 41 then goto __Double_To_Single_Fire

  player1y = player1y - 3

  _Bit4_Enemy_Dead_Flag{4} = 1

  goto __Draw



  ;***************************************************************
  ;
  ;  Same as the one from before except this handles being shot
  ;  by fireballs.
  ;
__Double_To_Single_Fire

  if _Enemy_Type = _Two_Goombas then _Enemy_Type = _Goomba else _Enemy_Type = _Spiney

  x = player1x + 8

  if ballx < x then player1x = player1x + 16

  ballx = 0 : bally = 120

  goto __Draw



  ;***************************************************************
  ;
  ;  This routine handles Mario kicking a shell. It will be
  ;  kicked in the direction you are facing.
  ;
__Init_Kicked_Shell

  player0y = player0y + 3

  _Enemy_Type = _Goomba : _Bit3_Enemy_Direction{3} = 0 : _Enemy_Momentum = 0 : _Bit4_Enemy_Dead_Flag{4} = 0

  if !_Bit0_Player_Facing_Direction{0} then _Bit5_Moving_Turtle_Shell_Direction{5} = 0 else _Bit5_Moving_Turtle_Shell_Direction{5} = 1

  _Moving_Shell_X_Coordinate = (player1x - 13)/4 : _Moving_Shell_Y_Coordinate = (player1y - 4)/8

  if _Bit5_Moving_Turtle_Shell_Direction{5} then _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate - 1 else _Moving_Shell_X_Coordinate = _Moving_Shell_X_Coordinate + 1

  player1x = 0 : player1y = 150

  goto __Draw



  ;***************************************************************
  ;
  ;  Takes care of the Mario death sequence and animation.
  ;
__Mario_Death

  if player0y > 94 then player0y = 150

  gosub __Death_Music bank7

  gosub __Mario_Die

  p = 1 : _Lives_Counter = _Lives_Counter - 1 : _Bit6_Regular_Mario{6} = 1 : _Bit4_Firey_Mario_Power{4} = 0 : _Bit3_Super_Mario_Power{3} = 0 : _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0

  ballx = 0 : bally = 150

  for x = 6 to 0 step -1

  if player0y <> 150 then player0y = player0y - x

  gosub __Play_Death_Music bank7

  gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3

  next x

__Mario_Death_2

  if x < 7 then x = x + 1

  if player0y <> 150 then player0y = player0y + x

  gosub __Play_Death_Music bank7

  if _Music_Duration = 255 then goto __Check_Lives

  gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3

  if player0y > 120 then player0y = 120

  goto __Mario_Death_2

__Check_Lives

  _Enemy_Type = _Goomba : player1y = 150

  player1x = 0 : _Star_Invincibility_Timer = 0 : _Bit7_Mario_Invincibility{7} = 0 : _Bit7_Mario_On_Off{7} = 0 : _Bit5_Ducking_Flag{5} = 0 : _Level_Timer = 0 : _Momentum_Up_Down = 0 : _Momentum_Left_Right = 0 : _Bit1_Jumping_Flag{1} = 0

  if _Lives_Counter < 1 then goto __Game_Over_Screen bank4 else goto __Init bank1



  ;***************************************************************
  ;
  ;  This whole routine handles taking Mario from the end of the
  ;  first part of the level, transporting him to the second part
  ;  of the level and then flagging that as the checkpoint in case
  ;  you die.
  ;
__Checkpoint

  x = (player0x - 9)/4

  if !pfread(x,9) then goto __More_Joy_Checks

  x = (player0x - 17)/4

  if !pfread(x,9) then goto __More_Joy_Checks

  y = 8 : bally = 150

  ballx = 0 : u = 0 : _Star_Invincibility_Timer = 0 : _Bit7_Mario_Invincibility{7} = 0 : _Bit7_Mario_On_Off{7} = 0

__fl2

  CTRLPF = $15

  player0y = player0y + 1

  gosub __Power_Down_SFX bank1

  gosub __Render_Screen_B3

  if player0y < 79 then goto __fl2

  player0x = 0 : player0y = 150

  pfclear

  _Enemy_Type = _Goomba : player1y = 150 : player1x = 0

  _Level_Data_Pointer = 32 : _Bit6_Checkpoint_Flag{6} = 1 : _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0

  for x = 1 to 32

  gosub __Power_Down_SFX bank1

  gosub __Render_Screen_B3

  next x

  gosub __Intro_Screen_3 bank4

  if _Level = 4 then goto __Bos_Setup bank4

  player0x = 24 : player0y = 80 

__fl3

  player0y = player0y - 1

  gosub __Power_Down_SFX bank1

  gosub __Render_Screen_B3

  if player0y < 64 then CTRLPF = $11 : goto __More_Joy_Checks

  goto __fl3

  ;```````````````````````````````````````````````````````````````
  ;  This part of the checkpoint routine is for x - 3 levels
  ;  using the trampoline instead of the pipe.
  ;
__Checkpoint_L3

  _Temp_u_Freq = 31

  gosub __Tramp2C

__Checkpoint_2

  player0y = player0y - 8

  AUDV0 = 8
  AUDC0 = 12
  AUDF0 = _Temp_u_Freq
  AUDV1 = 0

  gosub __Render_Screen_B3

  _Temp_u_Freq = _Temp_u_Freq - 4

  if player0y > 8 then goto __Checkpoint_2

  player0x = 0 : player0y = 150

  _Enemy_Type = _Goomba : player1x = 0 : player1y = 150

  _Level_Data_Pointer = 32 : _Bit6_Checkpoint_Flag{6} = 1

  pfclear

  AUDV0 = 0

  for x = 1 to 32

  gosub __Render_Screen_B3

  next x

  gosub __Intro_Screen_3 bank4

  player0x = 24 : player0y = 100

  _Temp_u_Freq = 31

  x = 8

__Checkpoint_3

  player0y = player0y - x

  AUDV0 = 8
  AUDC0 = 12
  AUDF0 = _Temp_u_Freq
  AUDV1 = 0

  gosub __Render_Screen_B3

  _Temp_u_Freq = _Temp_u_Freq - 4 : x = x - 1

  if player0y < 80 then goto __More_Joy_Checks

  goto __Checkpoint_3



  ;***************************************************************
  ;
  ;  This routine handles the end of the level sequence as well
  ;  as the animation right after you touch the flagpole.
  ;
__Level_Completed

  ballx = 0 : bally = 150

  gosub __Flag_Pole_Down

  gosub __Fanfare_Music bank7

  z = player1y - player0y

  if z = 0 then z = 1

  AUDV0 = 0
  AUDV1 = 0

  player0y = player1y : _Music_Duration = 1

  _Animation_Timer = 0 : _Bit1_Jumping_Flag{1} = 0 : _Bit0_Player_Facing_Direction{0} = 0 : _Bit5_Ducking_Flag{5} = 0 : _Momentum_Up_Down = 0 : _Bit7_Mario_Invincibility{7} = 0 : _Bit7_Mario_On_Off{7} = 0 : _Momentum_Left_Right = 0

  gosub __Set_Up_Mario bank1

  for y = 1 to z

  score = score + 100

  gosub __Render_Screen_B3

  AUDV0 = 8
  AUDC0 = 12
  AUDF0 = y

  next y

  AUDV0 = 0

  _Momentum_Left_Right = 2

__elr3

  gosub __Play_FF_Music bank7

  _Animation_Timer = _Animation_Timer + 1

  player0x = player0x + 1

  if player0x > 137 then player0x = 137 : player0y = 150

  if _Animation_Timer > 6 then _Animation_Timer = 0

  gosub __Set_Up_Mario bank1

  gosub __Render_Screen_B3 : gosub __Render_Screen_B3

  if _Music_Duration <> 255 then goto __elr3

__elr4

  if pfscore1 = 0 then goto __elr5

  AUDV0 = 8
  AUDC0 = 4
  AUDF0 = 8
  AUDV1 = 0

  pfscore1 = pfscore1/2

  score = score + 500

  gosub __Render_Screen_B3

  AUDV0 = 0

  gosub __Render_Screen_B3

  goto __elr4

__elr5

  for x = 1 to 64

  gosub __Render_Screen_B3

  next x

  _Bit6_Checkpoint_Flag{6} = 0 : _Enemy_Type = _Goomba : player1y = 150 : player1x = 0 : _Star_Invincibility_Timer = 0 : _Bit7_Mario_Invincibility{7} = 0 : _Bit7_Mario_On_Off{7} = 0 : _Bit5_Ducking_Flag{5} = 0 : _Level_Timer = 0

  _Moving_Shell_X_Coordinate = 0 : _Moving_Shell_Y_Coordinate = 0 : _Bit1_Jumping_Flag{1} = 0 : _Momentum_Up_Down = 0 : _Momentum_Left_Right = 0

  _Level = _Level + 1

  if _Level = 5 then _Level = 1 : _World = _World + 1

  goto __Init bank1



  ;***************************************************************
  ;
  ;  Routine that handles the collection of the 8 coin item.
  ;
__8coins

  score = score + 800

  pfscore2 = pfscore2 * 2|1

  AUDV0 = 12
  AUDC0 = 4
  AUDF0 = 7

  player1x = 0 : player1y = 150 : _Enemy_Type = _Goomba

  if pfscore2 < 250 then goto __Draw

  pfscore2 = 0

  goto __1Up_Mushroom



  ;***************************************************************
  ;
  ;  Routine that handles the collection of the Starman item.
  ;
__Star_Power

  _Star_Invincibility_Timer = 1 : _Bit7_Mario_Invincibility{7} = 1 : _Bit7_Mario_On_Off{7} = 1

  score = score + 1000

  player1x = 0 : player1y = 150 : _Enemy_Type = _Goomba

  _Music_Duration = 1

  gosub __Star_Power_Music bank7

  goto __Draw



  ;***************************************************************
  ;
  ;  Routine that handles the collection of the 1-up Mushroom.
  ;
__1Up_Mushroom

  y = 11 : u = 0 : _Lives_Counter = _Lives_Counter + 1

  if _Lives_Counter = 255 then _Lives_Counter = 254

  player1x = 0 : player1y = 150 : _Enemy_Type = _Goomba

__1Up_Mush_2

  gosub __1Up_SFX_B3

  gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3

  x = player0x : z = player0y : player0x = 0 : player0y = 150

  gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3 : gosub __Render_Screen_B3

  player0x = x : player0y = z

  if y = 3 then goto __Draw

  goto __1Up_Mush_2

__1Up_SFX_B3

  y = y - 2 : u = u + 1

  if u = 4 then u = 0 : y = 7

  AUDV0 = 8
  AUDC0 = 4
  AUDF0 = y
  AUDV1 = 0

  return thisbank



  ;***************************************************************
  ;
  ;  Routine that handles what happens after your star power runs
  ;  out.
  ;
__Star_Power_End

  _Star_Invincibility_Timer = 0 : _Level_Timer = 0

  if _Level = 1 || _Level = 3 then gosub __OW_Music bank7

  if _Level = 2 || _Level = 4 then gosub __UW_Music bank7

  return thisbank



  ;***************************************************************
  ;
  ;  Now we check if Mario and an enemy are in contact with each
  ;  other and where to go if that is the case.
  ;
__Enemy_Collision_Routine

  ;```````````````````````````````````````````````````````````````
  ;  Fireball collision with enemy check.
  ;
  if collision(ball,player1) && !_Bit4_Enemy_Dead_Flag{4} then goto __Enemy_Hit_By_Fireball

  ;```````````````````````````````````````````````````````````````
  ;  Mario death and Mario-enemy collision detections are here
  ;  since we just finished plotting the enemy character for a
  ;  final accurate screen render.
  ;
  if _Moving_Shell_X_Coordinate > 0 && _Moving_Shell_Y_Coordinate > 0 then goto __Moving_Shell_Collision

__Enemy_Coll_Rout_2

  if !collision(player0,player1) then goto __Draw

  if _Enemy_Type = _Kinetic_Platforms then goto __Convert_Platform

  if _Enemy_Type = _Trampoline then goto __Checkpoint_L3

  if _Enemy_Type >= _Bowser_Jr then goto __Mario_BJr_Collision bank4

  if _Bit4_Enemy_Dead_Flag{4} then goto __Draw

  ;```````````````````````````````````````````````````````````````
  ;  If Mario is above the enemy, then he wins...most of the time.
  ;
  if _Enemy_Type = _Flagpole then goto __Level_Completed

  if _Enemy_Type = _Silver_Coin then goto __8coins

  if _Enemy_Type = _Starman then goto __Star_Power

  if _Enemy_Type = _1up_Mushroom then goto __1Up_Mushroom

  if _Star_Invincibility_Timer > 0 then goto __Enemy_Hit

  if _Enemy_Type = _Spiney then goto __Mario_Hit_01 bank1

  if _Enemy_Type = _Spiney_Ball then goto __Mario_Hit_01 bank1

  if _Enemy_Type = _Fireball_Enemy then goto __Mario_Hit_01 bank1

  if _Enemy_Type = _Pirahna_Plant || _Enemy_Type = _Two_Spineys then goto __Mario_Hit_01 bank1

  if _Enemy_Type = _Thwomp || _Enemy_Type = _Two_Thwomps then goto __Mario_Hit_01 bank1

  if _Enemy_Type >= _Flagpole then goto __Enemy_Hit

  if player0y < player1y && !_Bit4_Enemy_Dead_Flag{4} then goto __Enemy_Hit

  goto __Mario_Hit_01 bank1



  ;***************************************************************
  ;
  ;  Since the __Moving shell is a playfield block in motion, we
  ;  need a separate collision check for that.
  ;
__Moving_Shell_Collision

  x = (player0x - 13)/4 : y = (player0y)/8

  if _Moving_Shell_X_Coordinate = x && _Moving_Shell_Y_Coordinate = y then goto __Mario_Hit_01 bank1

  z = _Moving_Shell_X_Coordinate + 1

  if z = x && _Moving_Shell_Y_Coordinate = y then goto __Mario_Hit_01 bank1

  goto __Enemy_Coll_Rout_2



  ;***************************************************************
  ;
  ;  Interaction with the moving platform. If you jumped on top
  ;  of it, then it gets converted to playfield blocks.
  ;
__Convert_Platform

  x = (player1x - 14)/4 : y = player1y/8

  _Enemy_Type = _Goomba : player1y = 150 : player1x = 0

  gosub __Render_Screen_B3

  if _Bit7_2nd_Quest{7} then z = x + 3 else z = x + 7

  pfhline x y z on

  player0y = player0y - _Momentum_Up_Down - 4

  gosub __Render_Screen_B3

  goto __Draw



  ;***************************************************************
  ;
  ;  This is the same as __Render_Screen from bank 1. It is here
  ;  too with the added suffix B3 (for bank3)  because we needed
  ;  to do some screen drawing in this bank too. In Zippy the
  ;  Porcupine, I've remedied this so that the rendering routine
  ;  is just in one bank so it doesn't waste valuable ROM space.
  ;
__Render_Screen_B3

  if _Level = 1 || _Level = 3 then COLUPF = $32 else COLUPF = $04

  if _Level = 2 then COLUPF = $A4

  if _Enemy_Type = _Kinetic_Platforms && !_Bit7_2nd_Quest{7} then NUSIZ1 = $17 : goto __Finish_Render_B3

  if _Enemy_Type = _Kinetic_Platforms && _Bit7_2nd_Quest{7} then NUSIZ1 = $15 : goto __Finish_Render_B3

  if _Enemy_Type = _Thwomp || _Enemy_Type = _Bowser_Jr then NUSIZ1 = $15 : goto __Finish_Render_B3

  if _Enemy_Type = _Bullet_Bill then NUSIZ1 = $15 : goto __Finish_Render_B3

  if _Enemy_Type = _Two_Goombas && player1x < 122 then NUSIZ1 = $11 : goto __Finish_Render_B3

  if _Enemy_Type = _Two_Spineys && player1x < 122 then NUSIZ1 = $11 : goto __Finish_Render_B3

  if _Enemy_Type = _Two_Thwomps && player1x < 106 then NUSIZ1 = $12

__Finish_Render_B3

  if _Bit0_Player_Facing_Direction{0} then REFP0 = 8 else REFP0 = 0

  if _Bit3_Enemy_Direction{3} then REFP1 = 8 else REFP1 = 0

  drawscreen

  return thisbank



  ;***************************************************************
  ;
  ;  All the sprite tables needed for this bank.
  ;
__Mario_Die
  player0color:
  $44
  $44
  $3E
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
  $3E
  $3E
end

  player0:
  %11011011
  %10111101
  %00100100
  %01000010
  %11011011
  %00111100
  %01000010
  %10011001
  %00111100
  %11011011
  %01011010
  %10111101
  %11011011
  %11000011
  %01000010
end
  return thisbank

__Flag_Pole_Down
  player1color:
  $0A
  $08
  $C4
  $0A
  $0C
  $0E
  $0E
  $0E
  $0C
  $0A
  $C6
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $C8
  $CA
end

  player1:
  %00000111
  %00000011
  %00000001
  %00001110
  %00111110
  %11101010
  %11110110
  %11110110
  %00111110
  %00001110
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
  %00000001
end
  return thisbank

__Tramp2C
  player1color:
  $4A
  $0A
  $0C
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0C
  $0A
  $46
end

  player1:
  %11111111
  %00011000
  %00100100
  %00100100
  %00100100
  %01000010
  %01000010
  %01000010
  %01000010
  %01000010
  %01000010
  %00100100
  %00100100
  %00100100
  %00011000
  %11111111
end
  return thisbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 4.
  ;
  ;
  bank 4


  ;***************************************************************
  ;
  ;  This is the part of the game that shows how many lives you
  ;  have before the game starts.
  ;
__Intro_Screen

  AUDV0 = 0 : AUDV1 = 0 

  pfclear

  _Level_Data_Pointer = 63 : _Animation_Timer = 250

  gosub __Setup_Colors

__Intro_Screen_2

  gosub __Show_Level

  COLUPF = $00

  x = _Lives_Counter - 1

  gosub __Mario_Icon

  gosub __Number_Colors_P1

  on x gosub __1Mario __2Mario __3Mario __4Mario __5Mario __6Mario __7Mario __8Mario __9Mario

  player0x = 71 : player1x = 81

  player0y = 56 : player1y = 54

  drawscreen

  ;```````````````````````````````````````````````````````````````
  ;  Believe it or not, the level gets scrolled on in darkness
  ;  behind the sprites here. This is how the level gets plotted
  ;  from the beginning.
  ;
  if _Level = 4 && _Bit6_Checkpoint_Flag{6} then _Level_Data_Pointer = 0 : goto __Skip_Scroll

  if _Level_Data_Pointer > 31 then gosub __Scroll_Right bank1

__Skip_Scroll

  if !joy0fire then goto __Intro_Screen_2

  if _Level_Data_Pointer > 31 then goto __Intro_Screen_2

  _Level_Timer = 0 : pfscore1 = 255

  _Bit2_Fire_Button_Pressed{2} = 1

  if !_Bit6_Checkpoint_Flag{6} then player0y = 79

  if _Bit6_Checkpoint_Flag{6} && _Level < 3 then player0y = 63

  goto __Intro_Screen_6

__Intro_Screen_3

  AUDV0 = 0 : AUDV1 = 0 : _Level_Data_Pointer = 63 : _Animation_Timer = 250

  gosub __Setup_Colors

__Intro_Screen_5

  COLUPF = $00 : COLUBK = $00

  gosub __Scroll_Right  bank1

  drawscreen

  if _Level_Data_Pointer > 31 then goto __Intro_Screen_5

  ;```````````````````````````````````````````````````````````````
  ;  This part sets up the music routines depending on what
  ;  levels the player is about to go on, and other variables
  ;  before the game starts.
  ;
__Intro_Screen_6

  if _Level = 1 then gosub __OW1_Colors : COLUBK = $00 : gosub __OW_Music bank7

  if _Level = 2 then gosub __UW1_Colors : COLUBK = $00 : gosub __UW_Music bank7

  if _Level = 3 then gosub __OW2_Colors : COLUBK = $A0 : gosub __OW_Music bank7

  if _Level = 4 then COLUBK = $00

  if _Level = 4 && !_Bit6_Checkpoint_Flag{6} then gosub __UW2_Colors : gosub __UW_Music bank7

  if _Level = 4 && _Bit6_Checkpoint_Flag{6} then gosub __Boss_Level_Setup

  _Momentum_Left_Right = 0 : _Animation_Timer = 0 : _Momentum_Up_Down = 0  : _Object_Scroll_In_Data = 0 : _Farthest_Traveled_On_Level = 0 : _Moving_Shell_X_Coordinate = 0 : u = 0

  scorecolor = $0E : _Level_Data_Pointer = 32 : _Music_Duration = 1 : _Bit5_Moving_Turtle_Shell_Direction{5} = 1

  player1y = 150 : bally = 150 : player0x = 24 : pfscorecolor = 28

  player1x = 0 : var44 = 0 : var45 = 0 : var46 = 0 : var47 = 0 : ballx = 0 

  return otherbank

__Boss_Level_Setup

  if _World = 1 then gosub __Boss_PF_Setup bank5

  if _World = 2 then gosub __Boss_PF_Setup_2 bank5

  if _World = 3 then gosub __Boss_PF_Setup_3 bank6

  if _World = 4 then gosub __Boss_PF_Setup_4 bank6

  gosub __Boss_Colors

  return thisbank



  ;***************************************************************
  ;
  ;  The tables below are the playfield line color tables for the
  ;  levels, including the black invisible color table for loading
  ;  the level on the lives screen.
  ;
__Setup_Colors
  pfcolors:
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
  $00
end
  return thisbank

__OW1_Colors
  pfcolors:
  $32
  $18
  $32
  $32
  $32
  $32
  $18
  $32
  $C6
  $C6
  $24
end
  return thisbank

__OW2_Colors
  pfcolors:
  $18
  $34
  $DA
  $DA
  $DA
  $D8
  $D8
  $D8
  $D8
  $C6
  $C6
end
  return thisbank

__UW1_Colors
  pfcolors:
  $A4
  $A4
  $A4
  $A4
  $A4
  $A4
  $18
  $A4
  $C6
  $C6
  $A2
end
  return thisbank

__UW2_Colors
  pfcolors:
  $04
  $06
  $06
  $06
  $06
  $06
  $06
  $06
  $C6
  $C6
  $0A
end
  return thisbank

__Boss_Colors
  pfcolors:
  $04
  $04
  $06
  $06
  $08
  $08
  $0A
  $0A
  $0C
  $0C
  $0E
end
  return thisbank



  ;***************************************************************
  ;
  ;  The entire Game Over routine.
  ;
__Game_Over_Screen

  pfclear

  COLUBK = $00

  gosub __Game_Over_Music

  _Music_Duration = 1

__Gm_Ovr_Scrn_2

  gosub __Number_Colors_P0 : gosub __Number_Colors_P1

  gosub __GA : gosub __ME

  player0x = 73 : player1x = 81

  player0y = 32 : player1y = 32

  gosub __Play_Game_Over_Music

  drawscreen

  gosub __OV : gosub __ER

  player0x = 73 : player1x = 81

  player0y = 44 : player1y = 44

  gosub __Play_Game_Over_Music

  drawscreen

  if _Music_Duration = 255 then _Level = 1 : _Coin_Counter = 0 : _Bit3_Super_Mario_Power{3} = 0 : _Bit4_Firey_Mario_Power{4} = 0 : pfscore2 = 0 : g = 0 : _Bit6_Regular_Mario{6} = 1 : _Animation_Timer = _World : goto __Gm_Ovr_Scrn_3

  goto __Gm_Ovr_Scrn_2

__Gm_Ovr_Scrn_3

  gosub __Show_Level

  if !joy0up then _Bit0_Mario_Fireball_Going_Down{0} = 0

  if !joy0down then _Bit1_Mario_Fireball_Going_Up{1} = 0

  if joy0up && !_Bit0_Mario_Fireball_Going_Down{0} then _Level = _Level + 1 : _Bit0_Mario_Fireball_Going_Down{0} = 1

  if joy0down && !_Bit1_Mario_Fireball_Going_Up{1} then _Level = _Level - 1 : _Bit1_Mario_Fireball_Going_Up{1} = 1

  if joy0fire then goto __Gm_Ovr_Scrn_4

  if _Level = 0 then _Level = 4 : _World = _World - 1

  if _Level = 5 then _Level = 1 : _World = _World + 1

  if _World = 0 then _World = _Animation_Timer : _Level = 1

  if _World = _Animation_Timer && _Level > 1 then _World = 1 : _Level = 1

  goto __Gm_Ovr_Scrn_3

__Gm_Ovr_Scrn_4

  if switchleftb then _Lives_Counter = 3 else _Lives_Counter = 5

  g = 0 : _Animation_Timer = 0 : score = 0

  goto __Init bank1



  ;***************************************************************
  ;
  ;  This part displays the level you are on, on the lives screen.
  ;  Since we can only have 2 sprites, there is a flicker that
  ;  happens. The first drawscreen shows the lives, while the
  ;  second one shows the level.
  ;
__Show_Level

  COLUBK = $00 : COLUPF = $00 : CTRLPF = $11 : x = _World - 1 : y = _Level - 1

  gosub __Number_Colors_P0 : gosub __Number_Colors_P1

  on x gosub __1World __2World __3World __4World

  on y gosub __1Level __2Level __3Level __4Level

  player0x = 73 : player1x = 81

  player0y = 32 : player1y = 32

  if switchreset then reboot

  drawscreen

  return thisbank



  ;***************************************************************
  ;
  ;  The sprite colors for the text. All white.
  ;
__Number_Colors_P0
  player0color:
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
end
  return thisbank

__Number_Colors_P1
  player1color:
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
  $0E
end
  return thisbank 



  ;***************************************************************
  ;
  ;  Here's the boss fight routines for BJ.
  ;
__Bowser_Jr

  if ballx > 0 && _Farthest_Traveled_On_Level < 3 then _Level_Data_Pointer = 5 : goto __Bowser_Jr_2

__Bowser_Jr_1

  if _Farthest_Traveled_On_Level = 0 then goto __Bowser_Jr_Moving

  if _Farthest_Traveled_On_Level > 0 && _Farthest_Traveled_On_Level < 11 then goto __Bowser_Jr_Jumping

  if _Farthest_Traveled_On_Level = 11 || _Farthest_Traveled_On_Level = 12 then goto __Bowser_Jr_Shell

  if _Farthest_Traveled_On_Level > 12 then goto __Bowser_Jr_Standing

__Bowser_Jr_2

  on _Level_Data_Pointer gosub __BJC1 __BJC1 __BJCColor __BJJColor __BJSC __BJDC

  on _Level_Data_Pointer gosub __BJ1 __BJ2 __BJC __BJJ __BJS __BJD

  goto __Main_Loop bank1

__Bowser_Jr_Moving

  if !_Bit3_Enemy_Direction{3} then x = player1x - 3 : y = (x - 13)/4 else x = player1x + 3 : y = x/4

  if _Animation_Timer > 3 then _Level_Data_Pointer = 1 else _Level_Data_Pointer = 0

__Bowser_Jr_Moving_2

  if pfread(y,9) then gosub __Change_Bowser_Jr_Direction : goto __Bowser_Jr_2

  if !pfread(y,10) then gosub __Change_Bowser_Jr_Direction : goto __Bowser_Jr_2

  player1x = x

  if _Enemy_Momentum < 1 && _Farthest_Traveled_On_Level = 12 then _Farthest_Traveled_On_Level = 13 : _Level_Data_Pointer = 0 : _Enemy_Momentum = 8

  if _Farthest_Traveled_On_Level = 0 && _Animation_Timer > 4 && _Music_Duration = 3 then _Farthest_Traveled_On_Level = 1

  if _Farthest_Traveled_On_Level = 11 && _Animation_Timer > 4 && _Music_Duration = 3 then _Farthest_Traveled_On_Level = 12 : _Enemy_Momentum = 6

  goto __Bowser_Jr_2

__Change_Bowser_Jr_Direction

  if _Bit3_Enemy_Direction{3} then _Bit3_Enemy_Direction{3} = 0 else _Bit3_Enemy_Direction{3} = 1

  return thisbank

__Bowser_Jr_Jumping

  if !_Bit3_Enemy_Direction{3} && player1x < 68 && _Farthest_Traveled_On_Level = 1 then _Farthest_Traveled_On_Level = 0 : _Level_Data_Pointer = 0 : goto __Bowser_Jr_2

  if _Bit3_Enemy_Direction{3} && player1x > 82 && _Farthest_Traveled_On_Level = 1 then _Farthest_Traveled_On_Level = 0 : _Level_Data_Pointer = 0 : goto __Bowser_Jr_2

  if _Farthest_Traveled_On_Level < 8 then _Farthest_Traveled_On_Level = _Farthest_Traveled_On_Level + 1 : _Level_Data_Pointer = 2 : goto __Bowser_Jr_2

  if _Farthest_Traveled_On_Level = 8 then _Level_Data_Pointer = 3 : _Farthest_Traveled_On_Level = 9 : _Enemy_Momentum = 8 : goto __Bowser_Jr_2

  if _Farthest_Traveled_On_Level = 9 then  player1y = player1y - _Enemy_Momentum else player1y = player1y + _Enemy_Momentum

  if !_Bit3_Enemy_Direction{3} then player1x = player1x - 3 else player1x = player1x + 3

  if _Farthest_Traveled_On_Level = 9 then  _Enemy_Momentum = _Enemy_Momentum - 1 else _Enemy_Momentum = _Enemy_Momentum + 1

  if _Enemy_Momentum = 0 then _Farthest_Traveled_On_Level = 10

  if player1y > 79 then player1y = 79 : _Farthest_Traveled_On_Level = 11 : _Level_Data_Pointer = 4

  goto __Bowser_Jr_2

__Bowser_Jr_Shell

  if _Farthest_Traveled_On_Level = 11 then _Enemy_Momentum = 6 else _Enemy_Momentum = _Enemy_Momentum - 1

  if !_Bit3_Enemy_Direction{3} then x = player1x - _Enemy_Momentum : y = (x - 13)/4 else x = player1x + _Enemy_Momentum : y = x/4

  goto __Bowser_Jr_Moving_2

__Bowser_Jr_Standing

  _Enemy_Momentum = _Enemy_Momentum - 1

  if _Enemy_Momentum < 1 then _Farthest_Traveled_On_Level = 0 : _Level_Data_Pointer = 0

  goto __Bowser_Jr_2

__Fireball_BJr_Collision

  ballx = 0 : bally = 120

  if _Level_Data_Pointer > 3 then goto __Draw bank3

  score = score + 300

__Bowser_Jr_Hit

  _Level_Timer = _Level_Timer - 1 : _Level_Data_Pointer = 2 : _Farthest_Traveled_On_Level = 13 : _Enemy_Momentum = 6

  pfscore1 = pfscore1/2

  if _Level_Timer < 1 then goto __Bowser_Jr_Defeated

  goto __Draw bank3

__Mario_BJr_Collision

  if player1y <= player0y then goto __Mario_Hit_01 bank1

  if _Farthest_Traveled_On_Level = 11 || _Farthest_Traveled_On_Level = 12 then player0y = player0y - 3 : _Bit1_Jumping_Flag{1} = 1 : _Momentum_Up_Down = 2 : _Bit2_Fire_Button_Pressed{2} = 1 : score = score + 50 : goto __Draw bank3

  x = player1y - player0y

  if x < 12 then goto __Mario_Hit_01 bank1

  player0y = player0y - 3 : _Bit1_Jumping_Flag{1} = 1 : _Momentum_Up_Down = 2 : _Bit2_Fire_Button_Pressed{2} = 1 : _Momentum_Left_Right = 6

  if player1y < 79 then player1y = 79

  if _Level_Data_Pointer = 2 then _Enemy_Momentum = 6 : _Farthest_Traveled_On_Level = 13 : goto __Draw bank3

  score = score + 400

  goto __Bowser_Jr_Hit

__Bowser_Jr_Defeated

  gosub __Pause_Boss

  player0y = 79 : player1y = 79 : _Bit1_Jumping_Flag{1} = 0 : _Momentum_Up_Down = 0 : _Bit0_Player_Facing_Direction{0} = 0 : _Momentum_Left_Right = 0 : player0x = player1x - 16

  if player0x < 24 then player0x = 24

  _Bit7_Mario_Invincibility{7} = 0 : _Bit7_Mario_On_Off{7} = 0

  gosub __Set_Up_Mario bank1

  AUDV0 = 0 : AUDV1 = 0

  score = score + 5000

  player1color:
  $1A
  $1C
  $1E
  $2A
  $2E
  $2A
  $2E
  $0C
  $2E
  $2E
  $2E
  $2E
  $C6
  $C6
  $44
  $44
  $46
  $46
end

  player1:
  %11010111
  %11111011
  %10111000
  %00001011
  %00001011
  %00010111
  %00001110
  %00010100
  %01111100
  %01010110
  %10101111
  %11111110
  %01101100
  %00111000
  %01110010
  %01010100
  %00000110
  %00001100
end

  AUDV0 = 12 : AUDC0 = 7 : AUDF0 = 31

  gosub __Pause_Boss

  gosub __Fanfare_Music bank7

__BJr_Defeated_2

  gosub __Play_FF_Music bank7

  gosub __Render_Screen_Boss : gosub __Render_Screen_Boss 

  if _Music_Duration <> 255 then goto __BJr_Defeated_2

  if _World = 4 then goto __Final bank8

  gosub __BJCColor : gosub __BJC

  gosub __Pause_Boss

  gosub __BJSC : gosub __BJS

__BJr_Defeated_3

  AUDV0 = 12 : AUDC0 = 8 : AUDF0 = 31 : player1x = player1x + 4

  if player1x > 137 then player1x = 0 : player1y = 120 : _Enemy_Type = _Goomba : goto __BJr_Defeated_4

  if player1x > 120 then pfhline 30 7 31 off : pfhline 30 8 31 off : pfhline 30 9 31 off : AUDC0 = 7

  gosub __Slow_Boss

  goto __BJr_Defeated_3 

__BJr_Defeated_4

  AUDV0 = 0 : _Animation_Timer = _Animation_Timer + 1 : _Momentum_Left_Right = 2

  if _Animation_Timer > 6 then _Animation_Timer = 0

  gosub __Set_Up_Mario bank1

  player0x = player0x + 2

  gosub __Slow_Boss

  if player0x > 138 then player0x = 0 : player0y = 120 : goto __elr5 bank3

  goto __BJr_Defeated_4


__Bos_Setup

  AUDV0 = 0 : AUDV1 = 0

  player0x = 32 : player0y = 0

  _Momentum_Up_Down = 4 : u = 10 : pfscore1 = 0 : _Bit0_Player_Facing_Direction{0} = 0

  gosub __Set_Up_Mario bank1

  y = 1

__Mario_Fall

  u = u + 1 : AUDV0 = 8 : AUDC0 = 4 : AUDF0 = u : player0y = player0y + y

  if y < 7 then y = y + 1

  if player0y > 80 then player0y = 79 : _Momentum_Up_Down = 0 : _Momentum_Left_Right = 0 : gosub __Set_Up_Mario bank1 : AUDC0 = 1 : AUDF0 = 8

  gosub __Slow_Boss

  if player0y = 79 then x = 9 : _Momentum_Up_Down = 0 : _Bit1_Jumping_Flag{1} = 0 : _Momentum_Left_Right = 0 : gosub __Set_Up_Mario bank1 : goto __Boss_Fall

  goto __Mario_Fall

__Boss_Fall

  AUDV0 = 0

  for z = 1 to 3

  gosub __Pause_Boss

  next z

  player1x = 116 : player1y = 0

  u = 10 : x = 1 : g = 0 : _Bit6_Checkpoint_Flag{6} = 1

  gosub __BJJColor : gosub __BJJ

__Boss_Fall_2

  u = u + 1 : AUDV0 = 8 : AUDC0 = 4 : AUDF0 = u : player1y = player1y + x

  if x < 7 then x = x + 1

  if player1y > 80 then player1y = 79 : gosub __BJCColor : gosub __BJC : AUDC0 = 1 : AUDF0 = 8 : gosub __Pause_Boss

  gosub __Slow_Boss

  if player1y = 79 then gosub __BJC1 : gosub __BJ1 : x = 0 : goto __Boss_Fall_Fill_Lifebar

  goto __Boss_Fall_2

__Boss_Fall_Fill_Lifebar

  x = x + 1

  if x = 1 then pfscore1 = 1 else pfscore1 = pfscore1 * 2|1

  AUDV0 = 8 : AUDC0 = 7 : AUDF0 = 6

  gosub __Pause_Boss

  if x < 3 then goto __Boss_Fall_Fill_Lifebar

__Boss_Fall_3

  AUDV0 = 0

  for z = 1 to 3

  gosub __Pause_Boss

  next z

  for z = 1 to 3

  u = $0e : x = 17

__Boss_Fall_4

  x = x + 1

  COLUBK = u

  AUDV0 = 8 : AUDC0 = 1 : AUDF0 = x

  gosub __Render_Screen_Boss

  if u > 0 then u = u - 1 : goto __Boss_Fall_4

  next z

  _Enemy_Type = _Bowser_Jr : _Level_Data_Pointer = 0 : _Level_Timer = 3 : _Bit3_Enemy_Direction{3} = 0 : _Object_Scroll_In_Data = 0 : _Farthest_Traveled_On_Level = 0

  gosub __UW_Music bank7

  goto __Main_Loop bank1

__Pause_Boss

  for y = 1 to 30

  gosub __Render_Screen_Boss

  if y > 3 then AUDV0 = 0

  next y

  return thisbank

__Slow_Boss

  for y = 1 to 3

  gosub __Render_Screen_Boss

  next y

  return thisbank

__Render_Screen_Boss

  COLUPF = $04

  NUSIZ1 = $15

  if _Bit0_Player_Facing_Direction{0} then REFP0 = 8 else REFP0 = 0

  if _Bit3_Enemy_Direction{3} then REFP1 = 8 else REFP1 = 0

  drawscreen

  return thisbank


__1World
  player0:
  %01111000
  %00110000
  %00110000
  %00110011
  %00110000
  %00110000
  %01110000
  %00110000
end
  return thisbank

__2World
  player0:
  %01111000
  %01111000
  %01100000
  %01110011
  %00111000
  %00011000
  %01111000
  %01110000
end
  return thisbank

__3World
  player0:
  %01110000
  %01111000
  %00011000
  %01111011
  %01111000
  %00011000
  %01111000
  %01110000
end
  return thisbank

__4World
  player0:
  %00011000
  %00011000
  %00011000
  %00111011
  %01111000
  %01101000
  %01101000
  %01101000
end
  return thisbank

__1Level
  player1:
  %01111000
  %00110000
  %00110000
  %00110000
  %00110000
  %00110000
  %01110000
  %00110000
end
  return thisbank

__2Level
  player1:
  %01111000
  %01111000
  %01100000
  %01110000
  %00111000
  %00011000
  %01111000
  %01110000
end
  return thisbank

__3Level
  player1:
  %01110000
  %01111000
  %00011000
  %01111000
  %01111000
  %00011000
  %01111000
  %01110000
end
  return thisbank

__4Level
  player1:
  %00011000
  %00011000
  %00011000
  %00111000
  %01111000
  %01101000
  %01101000
  %01101000
end
  return thisbank

__1Mario
  player1:
  %00001111
  %00000110
  %00000110
  %10100110
  %01000110
  %10100110
  %00001110
  %00000110
end
  return thisbank

__2Mario
  player1:
  %00001111
  %00001111
  %00001100
  %10101110
  %01000111
  %10100011
  %00001111
  %00001110
end
  return thisbank

__3Mario
  player1:
  %00001110
  %00001111
  %00000011
  %10101111
  %01001111
  %10100011
  %00001111
  %00001110
end
  return thisbank

__4Mario
  player1:
  %00000011
  %00000011
  %00000011
  %10100111
  %01001111
  %10101101
  %00001101
  %00001101
end
  return thisbank

__5Mario
  player1:
  %00001110
  %00001111
  %00000011
  %10100111
  %01001110
  %10101100
  %00001111
  %00001111
end
  return thisbank

__6Mario
  player1:
  %00001111
  %00001101
  %00001101
  %10101111
  %01001111
  %10101100
  %00001111
  %00000111
end
  return thisbank

__7Mario
  player1:
  %00000110
  %00000110
  %00000110
  %10100111
  %01000011
  %10100011
  %00001111
  %00001111
end
  return thisbank

__8Mario
  player1:
  %00001111
  %00001111
  %00001001
  %10101111
  %01001111
  %10101001
  %00001111
  %00001111
end
  return thisbank

__9Mario
  player1:
  %00000110
  %00000111
  %00000011
  %10100111
  %01001101
  %10101001
  %00001111
  %00000110
end
  return thisbank

__Mario_Icon
  player0color:
  $44
  $44
  $3E
  $44
  $44
  $44
  $3E
  $3E
  $3E
  $3E
  $3E
  $44
  $44
end

  player0:
  %01111100
  %01111000
  %01100100
  %11110000
  %11110110
  %01101100
  %00111110
  %01110000
  %11011011
  %10010111
  %00110100
  %11111111
  %01111100
end
  return thisbank


__GA
  player0:
  %11001000
  %10101010
  %10101010
  %10101010
  %10001110
  %10001010
  %10001010
  %01100110
end
  return thisbank

__ME
  player1:
  %10010011
  %10001010
  %10001010
  %10001010
  %10101011
  %10101010
  %11111010
  %01111001
end
  return thisbank

__OV
  player0:
  %11001100
  %10101010
  %10101010
  %10101010
  %10101010
  %10101010
  %10101010
  %01100010
end
  return thisbank

__ER
  player1:
  %11001000
  %10001010
  %10001010
  %10001010
  %11101100
  %10001010
  %10001010
  %01101110
end
  return thisbank

__BJC1
  player1color:
  $1A
  $1E
  $1E
  $0E
  $2A
  $1E
  $1E
  $2A
  $2E
  $2A
  $2E
  $2A
  $0C
  $2E
  $2E
  $2E
  $2E
  $C6
  $C6
  $44
  $44
  $46
  $46
  $46
end
  return thisbank

__BJDColor
  player1color:
  $1A
  $1C
  $1E
  $0E
  $C2
  $C4
  $C6
  $C6
  $C6
  $C6
  $C8
  $C8
  $C6
  $C6
  $C6
  $C6
  $C4
  $C2
  $42
  $44
  $46
end
  return thisbank

__BJ1
  player1:
  %01110111
  %00110110
  %00010100
  %00010100
  %00111000
  %01100010
  %01100110
  %01110110
  %01110110
  %01110110
  %00111010
  %00111100
  %00010100
  %01111100
  %00010110
  %11100111
  %11111110
  %01101100
  %00101000
  %01110110
  %01010111
  %00000110
  %00000011
  %00000010
end
  return thisbank

__BJ2
  player1:
  %01100110
  %11100111
  %11000011
  %00100010
  %00011000
  %10110001
  %10110011
  %01110011
  %01110111
  %01110110
  %00111010
  %00111100
  %00101000
  %01111100
  %00010110
  %11100111
  %11111110
  %01101100
  %00101000
  %01110111
  %01010110
  %00000011
  %00000010
  %00000001
end
  return thisbank

__BJCColor
  player1color:
  $1A
  $1C
  $1E
  $0C
  $1E
  $2A
  $2E
  $2A
  $2E
  $0C
  $2E
  $2E
  $2E
  $2E
  $C6
  $C6
  $44
  $44
  $46
  $46
end
  return thisbank

__BJC
  player1:
  %11101111
  %11110111
  %01100110
  %00100100
  %10101100
  %01110110
  %01110110
  %01111011
  %00111011
  %00010100
  %01111100
  %00010110
  %11101111
  %11111110
  %01101100
  %00111100
  %01110110
  %01010100
  %00000110
  %00001100
end
  return thisbank

__BJJColor
  player1color:
  $1E
  $1A
  $1E
  $1E
  $0E
  $2A
  $1E
  $1E
  $2E
  $2A
  $2E
  $2A
  $D6
  $0C
  $2E
  $2E
  $2E
  $2E
  $C6
  $C6
  $44
  $44
  $2E
  $1E
  $1E
end
  return thisbank

__BJJ
  player1:
  %00011011
  %00011011
  %00011011
  %00110110
  %00100100
  %00111100
  %00111001
  %00111011
  %01111011
  %01111011
  %01110110
  %01110110
  %00111100
  %00010100
  %00111110
  %00010111
  %01101111
  %01111111
  %00110110
  %00010101
  %00111011
  %00101011
  %11000000
  %11000000
  %11100000
end
  return thisbank

__BJDC
  player1color:
  $1A
  $1C
  $1E
  $0E
  $C2
  $C4
  $C6
  $C6
  $C6
  $C6
  $C8
  $C8
  $C6
  $C6
  $C6
  $C6
  $C4
  $C2
  $42
  $44
  $46
end
  return thisbank

__BJD
  player1:
  %00101011
  %00110110
  %00010100
  %00011010
  %00011100
  %00101010
  %01010110
  %01010101
  %10101011
  %10101011
  %01010101
  %01010101
  %10101011
  %10101011
  %01010101
  %01010110
  %00101010
  %00011100
  %00001111
  %00000110
  %00001100
end
  return thisbank

__BJSC
  player1color:
  $2E
  $2E
  $C8
  $CA
  $CA
  $C8
  $C8
  $C6
end
  return thisbank

__BJS
  player1:
  %00100100
  %01011010
  %10111101
  %11011011
  %01100110
  %01011010
  %00111100
  %00011000
end
  return thisbank

__Play_Game_Over_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_Gm_Ovr_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_GameOverMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 255 : goto __Got_Gm_Ovr_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_GameOverMusicData)
  temp6 = sread(_GameOverMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_GameOverMusicData)
  temp5 = sread(_GameOverMusicData)
  temp6 = sread(_GameOverMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_GameOverMusicData)

__Got_Gm_Ovr_Music

  return thisbank



  ;***************************************************************
  ;
  ;  Sound effect data for game over music.
  ;
__Game_Over_Music
  sdata _GameOverMusicData=q
  8,4,14
  4,4,23
  10
  4,4,14
  2,4,23
  10
  0,0,0
  0,0,0
  10
  8,4,19
  4,4,29
  10
  4,4,19
  2,4,29
  10
  0,0,0
  0,0,0
  10
  8,4,23
  4,12,26
  20
  8,4,17
  4,4,21
  13
  8,4,15
  4,4,21
  13
  8,4,17
  4,4,21
  14
  8,4,18
  4,4,21
  20
  8,4,16
  4,4,21
  20
  8,4,18
  4,4,21
  20
  8,4,19
  4,4,23
  10
  8,4,19
  4,4,26
  10
  8,4,19
  4,4,23
  40
  0,0,0
  0,0,0
  3
  255
end
  return thisbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 5.
  ;
  ;
  bank 5



  ;***************************************************************
  ;
  ;  The next 2 ROM Banks handle the storage and loading of the
  ;  level data. I'll go into more detail of the level formats
  ;  after the loading routines below.
  ;
__Level_Data_Bank1
  on z goto __W11A __W11B __W12A __W12B __W13A __W13B __W14 __W14 __W21A __W21B __W22A __W22B __W23A __W23B __W24 __W24

__W11A
  y = _Data_Level1A[x]:x = x + 1 : u = _Data_Level1A[x]:return otherbank

__W11B
  y = _Data_Level1B[x]:x = x + 1 : u = _Data_Level1B[x]:return otherbank

__W12A
  y = _Data_Level2A[x}:x = x + 1 : u = _Data_Level2A[x]:return otherbank

__W12B
  y = _Data_Level2B[x]:x = x + 1 : u = _Data_Level2B[x]:return otherbank

__W13A
  y = _Data_Level3A[x]:x = x + 1 : u = _Data_Level3A[x]:return otherbank

__W13B
  y = _Data_Level3B[x}:x = x + 1 : u = _Data_Level3B[x]:return otherbank

__W14
  y = _Data_Level4[x]:x = x + 1 : u = _Data_Level4[x]:return otherbank

__W21A
  y = _Data_Level5A[x}:x = x + 1 : u = _Data_Level5A[x]:return otherbank

__W21B
  y = _Data_Level5B[x}:x = x + 1 : u = _Data_Level5B[x]:return otherbank

__W22A
  y = _Data_Level6A[x}:x = x + 1 : u = _Data_Level6A[x]:return otherbank

__W22B
  y = _Data_Level6B[x}:x = x + 1 : u = _Data_Level6B[x]:return otherbank

__W23A
  y = _Data_Level7A[x}:x = x + 1 : u = _Data_Level7A[x]:return otherbank

__W23B
  y = _Data_Level7B[x}:x = x + 1 : u = _Data_Level7B[x]:return otherbank

__W24
  y = _Data_Level8[x]:x = x + 1 : u = _Data_Level8[x]:return otherbank



  ;***************************************************************
  ;
  ;  Alright, now here's the part most of you are probably
  ;  wondering about. The level data format. First, each level is
  ;  divided into 2 halves. In batari Basic, you can only have
  ;  256 bytes of information in each data table that's not sdata.
  ;  The reason why I use regular data statements for the level
  ;  data tables is because I need to call up the data information
  ;  in the table out of sequence depending on where you are.
  ;  This is why you can run backwards back into the level. This
  ;  also makes for a short level. I got around that by dividing
  ;  a stage into 2 halves.
  ;
  ;  Each Data table is one half of a level. Each column of level
  ;  data is in 2 bytes sequences. The first byte of the sequence
  ;  is the binary appearance of the first 8 rows of a column in
  ;  a level (playfield block on or off). The first 3 bits of the
  ;  second byte of the sequence is rows 9, 10 and 11 of a column
  ;  in a level. The last 5 bits of this second byte contain the
  ;  enemy/object spawning number. If the second byte is under 8,
  ;  then no object will spawn there. Because it's the last 5
  ;  bits of that number, every increment of 8 represents a
  ;  different enemy/object. This means we can only have 32
  ;  enemies and objects in the game. That's really the meat and
  ;  potatoes of it. If it doesn't make sense to you, feel free
  ;  to experiment with the values to try to figure out how it
  ;  works and make your own levels!
  ;
  data _Data_Level1A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4
  0,4,64,4,36,4,36,4,36,4,36,4,36,4,66,4,129,4,129,4,129,4,129
  4,129,4,64,4,0,4,0,12,0,12

  0,12,0,12,0,12,0,4,0,7,0,7,0,7,0,4,0,4,0,12,16,4,16,4,16,4,16
  4,16,4,16,4,0,12,0,4,0,7,0,7,0,7,0,4,0,4,0,12,0,12,0,12,0,12
  0,4,0,4,0,0,0,0,0,0

  0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,32,12,32,12,32,12,32,12,36
  4,36,4,68,4,4,4,4,4,0,28,0,28,4,4,36,4,36,4,36,4,36,4,32,4,32
  4,32,4,0,188,0,188,0,188,0,4

  0,4,128,4,128,4,128,4,128,4,32,4,32,4,32,4,32,4,32,4,32,4,8,24
  8,24,8,24,8,24,8,24,8,24,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,7,0
  7,0,7,0,4,0,4,0,4,0,4
end


  data _Data_Level1B
  0,4,0,7,0,7,0,7,0,4,0,188,0,188,0,188,64,4,0,188,0,188,0,188,0
  188,66,4,0,188,0,188,0,188,0,188,64,4,0,188,0,188,0,188,0,188
  0,188,0,188,32,4,32,4,32,4,32,4,0,12,0,12,0,12
  
  0,12,0,4,0,6,0,6,0,7,0,7,128,7,128,7,0,0,0,0,0,0,0,0,0,0,0,0,0
  0,0,0,128,7,128,7,0,7,0,7,0,6,0,6,0,4,0,4,0,28,16,4,16,4,16,4
  16,4,16,4,0,188,0,188

  0,188,0,188,0,188,0,188,0,188,0,188,33,4,33,4,33,4,33,4,33,4,33
  4,33,4,33,4,33,4,33,4,0,188,0,188,0,12,0,12,0,12,0,12,0,4,0,7,0
  7,0,7,0,4,0,4,0,188,0,188,64,4,32,4

  32,4,32,4,32,4,0,4,0,12,0,12,0,12,0,12,0,4,0,4,0,6,0,6,0,7,0,7
  128,7,128,7,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0
  172,0,4,0,4,0,4
end


  data _Data_Level2A
  255,7,0,4,0,4,0,4,0,4,0,4,0,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1
  4,1,4,65,4,65,4,65,4,65,4,65,4,65,4,1,188,1,188,1,188,1,188,1
  188,1,188,1,188,1,188,1,188

  1,12,1,12,1,4,1,4,1,7,1,7,1,4,1,4,129,7,129,7,1,4,1,4,33,4,33,4
  1,12,1,4,129,7,129,7,1,4,1,4,1,7,1,7,1,4,1,4,1,4,1,28,1,28,1,28
  1,28,1,28,1,28,1,28

  49,4,49,4,33,4,33,4,33,4,33,4,49,4,49,4,1,28,1,28,1,28,1,28,1
  28,63,4,63,4,32,4,32,4,129,4,129,4,1,188,1,188,1,188,1,188,1
  188,1,188,129,12,129,12,129,12,129,12,129,12,129,12,17,12

  17,12,17,12,17,12,17,12,17,12,1,6,1,6,1,6,1,0,1,0,1,0,1,0,1,7,1
  7,1,255,1,0,1,0,1,0,1,0,129,7,129,7,129,7,1,0,1,0,1,0,1,0,1,7,1
  7,1,7,1,0,1,0,255,7
end


  data _Data_Level2B
  255,7,1,0,1,7,1,7,1,7,1,0,1,0,1,0,1,0,129,7,129,7,1,7,1,7,1,6,1
  6,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,0
  0,0,0

  0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,4,32,4,32,76,32,76
  32,76,32,76,32,76,32,76,32,76,32,76,32,76,32,4,32,4,0,0,0,0,0,0
  0,0,0,0,8,0,8,0,8,0,8,0

  0,0,0,0,0,0,0,4,0,76,64,4,64,4,32,4,32,4,32,4,32,4,32,4,32,4,64
  4,64,4,0,76,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4
  0,6,0,6,0,15

  0,15,128,15,128,15,0,0,0,0,32,0,32,0,32,0,32,0,32,0,32,0,32,0
  224,7,224,7,224,7,224,7,224,7,224,7,224,7,224,7,224,7,224,7
  224,7,224,7,224,175,224,7,224,7,224,7,224,7,224,7,224,7,224,7
end


  data _Data_Level3A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,128,0
  128,0,128,0,128,0,128,0,128,0,128,0,128,0,128,0,128,0,128,0,0
  0,16,8,16,8,16,8,16,8,16,8,16,8

  16,8,16,8,16,8,16,8,16,8,16,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0
  4,0,4,16,76,16,76,17,76,16,76,16,76,0,0,0,0,0,0,0,2,0,2,0,2,0,2
  0,2,0,2,64,24,64,24

  64,24,64,24,64,24,64,24,64,24,64,24,64,24,64,0,64,0,64,0,64,0,64
  0,0,0,0,0,0,4,0,4,0,92,0,92,0,88,0,88,0,88,0,88,0,88,0,88,0,88,0
  0,0,0,64,4,64,76,64,76,64,76,64,76

  64,76,64,4,0,4,0,4,0,0,0,0,0,0,0,0,16,0,16,0,16,0,16,0,16,0,16,0
  0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,188,0,188,0,188
  0,188,0,188,0,188
end


  data _Data_Level3B
  16,4,16,4,16,4,16,4,16,4,144,4,128,4,128,4,132,4,132,4,132,4,132
  4,4,0,4,0,4,0,0,0,0,0,0,0,0,0,8,0,8,0,8,0,8,0,8,0,8,0,136,0,136
  0,128,4,128,4,128,4,128,4,0,0

  0,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0
  128,0,128,0,128,24,128,24,128,24,128,24,128,0,0,0,0,0,0,0,72,0
  72,0,72,0,72,0,72,0,72,0,0,0

  0,0,0,120,0,120,0,120,0,120,0,0,0,0,16,0,16,0,16,0,16,0,17,0,17
  0,16,0,16,0,16,0,16,0,0,0,0,0,0,0,0,92,0,92,0,92,0,92,0,92,0,92
  0,92,0,92,0,92,0,92,0,4,0,4

  0,4,128,4,128,4,128,4,128,0,16,0,16,0,16,72,16,72,16,72,16,0,0,0
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,4,0,4,0,4
  0,4,0,172,0,4,0,4
end


  data _Data_Level4
  1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,6
  1,6,3,7,3,7,135,7,135,7,135,7,135,7,135,7,135,7,135,7,135,7,131
  7,131,7,1,0,1,0,1,0

  1,0,1,152,1,0,1,0,1,0,1,0,129,7,129,7,129,7,129,7,129,7,129,7,3
  7,3,7,7,6,7,6,15,4,15,4,15,4,15,4,15,4,1,4,1,4,1,140,1,4,1,4,1
  4,63,4,63,4,63,4,31,4,31,4

  15,0,15,0,7,0,7,0,3,0,3,0,1,0,1,0,1,0,1,4,1,4,1,4,1,4,127,4,127,4
  31,4,31,4,7,4,7,4,3,7,3,7,195,7,195,7,193,31,193,31,193,31,193,31
  193,31,1,1,1,1,1,0,1,152

  1,152,1,152,1,0,1,0,1,4,1,4,1,4,65,4,65,4,113,4,113,4,1,28,1,28
  113,28,113,28,65,28,65,4,1,4,1,4,1,0,1,0,1,152,1,152,1,152,1,0
  1,4,1,4,17,7,17,7,17,7,17,4,255,7
end


  data _Data_Level5A
  34,4,34,4,32,4,32,4,56,4,56,4,0,4,0,4,0,4,0,4,0,4,0,4,128,4,128
  4,128,4,128,4,64,4,64,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,0,7
  0,7,0,7,0,4,0,44

  0,44,0,44,32,4,32,4,32,4,64,4,64,4,64,4,32,4,32,4,32,4,0,44,0,44
  0,4,0,4,0,7,0,7,0,7,0,4,0,4,0,12,0,12,0,12,0,12,0,12,0,4,0,4,0,0
  0,0,0,0,0,0,0,0

  0,0,0,0,0,0,0,4,0,4,0,4,16,79,16,79,16,79,0,0,0,0,0,0,0,0,0,0,0
  0,0,4,0,4,0,4,0,4,0,188,0,188,0,188,0,188,128,12,128,12,128,12
  128,12,32,12,32,12,32,12,32,12,0,188

  0,188,8,4,8,4,8,4,8,4,0,4,0,4,0,4,128,7,128,7,128,7,128,4,136,4
  136,76,136,76,136,76,136,76,184,76,184,76,56,76,56,76,56,76,56
  4,16,4,16,4,16,4,16,7,8,7,8,7,60,4,60,4,60,4
end


  data _Data_Level5B
  0,0,0,7,0,7,0,7,0,0,0,0,128,4,128,4,128,4,128,4,0,4,0,4,32,4,32
  4,32,4,32,4,32,4,32,4,32,4,16,7,17,7,17,7,17,4,17,4,81,4,81,4
  16,4,0,0,0,0,0,0,0,0,0,88

  0,88,0,88,0,88,0,0,0,4,0,4,0,4,0,4,0,4,0,4,0,7,0,7,0,255,0,108
  0,108,64,108,64,108,0,108,0,108,0,108,0,111,0,111,0,111,0,108
  0,108,0,108,0,108,0,104,0,104,0,104,128,104,128,104

  128,104,136,104,136,104,136,104,8,104,16,108,16,108,16,108,16
  108,160,108,160,108,160,108,160,108,136,108,136,108,8,108,8
  108,0,104,0,104,0,104,0,104,0,104,0,104,8,104,8,104,4,104,5,108,5

  108,5,111,5,111,5,111,5,108,0,108,0,44,0,44,0,44,0,44,128,44,128
  44,128,44,128,44,0,44,0,44,0,44,0,44,0,44,32,44,32,44,48,44,48
  46,56,46,56,46,0,0,0,0,0,0,0,0,0,0,0,0,32,0,32,168,32,0,32,0,32,0,32,0
end


  data _Data_Level6A
  255,7,0,4,0,4,0,4,0,4,0,4,0,4,1,4,1,0,1,4,1,0,1,0,1,4,1,4,1,0,1,0
  1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,4,1,4,0,7,0,7,0,7,0,4

  0,4,0,0,0,0,0,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,8,0,8,0
  8,0,8,0,8,0,8,0,0,0,0,0,0,0,0,0,0,0,0,7,0,7,0,255,0,4,0,4,64,4,0,4

  0,0,0,0,0,0,0,0,0,0,128,7,128,7,128,7,0,0,0,0,0,0,0,0,33,0,33,72
  33,72,33,72,33,72,33,0,1,0,1,0,1,0,1,4,1,4,1,4,1,4,1,4,1,4,1,6,1
  6,1,6,1,6,1,0

  1,0,1,0,1,0,1,0,1,0,1,6,3,6,3,6,7,6,7,4,7,4,1,4,1,4,1,204,7,4,7,4
  7,4,7,4,7,4,1,4,1,4,1,4,7,6,7,6,7,6,3,6,3,4,1,4,1,7,1,7,1,7,255,7
end


  data _Data_Level6B
  255,7,1,4,1,7,1,7,1,7,1,0,1,0,1,0,1,0,1,0,1,0,1,4,1,4,1,4,1,4,1
  0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,7,1,7

  1,255,1,0,1,0,1,0,1,0,1,0,3,0,3,6,3,6,7,4,7,4,71,4,79,4,31,4,31
  4,71,4,67,4,1,44,1,44,1,44,3,4,3,4,7,4,7,4,79,4,15,4,7,4,1,6,1
  6,1,7,1,7,129,7

  129,7,161,31,161,31,49,24,49,24,16,24,16,0,0,0,0,0,0,0,0,0,0,0,0
  0,0,0,225,7,225,79,227,7,227,7,227,7,227,7,129,7,129,7,129,7,129
  7,1,4,1,4,1,188,1,188,1,188,65,188,65,188,1,12

  1,12,1,4,1,7,1,7,1,7,1,4,1,4,1,4,1,4,1,4,1,4,33,44,33,44,33,44,33
  44,48,44,48,44,56,44,56,44,56,44,56,44,0,0,0,0,0,0,0,0,0,0,0,0,48
  0,48,168,48,0,48,0,48,0
end


  data _Data_Level7A
  68,4,68,4,68,4,68,4,0,4,0,4,0,4,0,4,0,4,16,0,16,0,16,0,16,0,16,0
  16,4,16,4,16,4,0,4,0,0,0,0,0,0,0,0,0,0,0,0,8,0,8,0,8,0,8,0,8,0,8
  0,64,0,64,0

  64,0,64,0,32,0,32,0,32,0,32,0,16,8,16,8,16,8,16,8,8,8,9,8,9,8,8
  8,0,0,0,0,0,0,0,88,0,88,0,88,0,92,0,92,0,92,0,4,8,4,8,76,8,72,8
  72,8,72,8,74,0,2,0,2

  0,90,0,90,0,90,0,88,0,88,0,0,64,4,64,4,64,4,64,4,64,4,0,188,0,188
  8,4,8,4,0,4,0,4,0,0,0,0,0,0,0,0,0,120,0,120,0,120,0,120,0,0,0,0
  64,0,64,72,64,72,64,72,64,72

  68,72,68,0,4,0,4,0,0,0,8,0,8,0,8,0,16,0,16,0,16,0,0,0,0,0,0,0,0
  0,0,0,0,0,0,0,0,0,144,0,144,72,144,72,16,72,16,76,16,76,0,4,0,4
  0,4,0,4,0,4,0,4,0,4
end


  data _Data_Level7B
  0,4,0,4,64,4,64,4,64,4,64,4,0,0,0,0,0,0,16,0,16,0,16,0,16,4,16,4
  16,4,16,4,16,4,16,4,16,4,16,0,16,0,0,0,0,0,0,0,0,0,0,4,0,4,16,4
  16,4,16,0,16,8,16,8

  16,8,17,8,16,8,17,12,16,12,17,12,16,8,16,8,0,0,0,0,0,88,0,88,0,92
  0,92,0,92,128,4,128,4,0,4,0,0,16,0,16,0,16,0,0,0,0,0,8,0,8,72,8
  72,8,72,8,72,8,0,0,0,0,104

  0,104,64,104,64,104,64,104,64,104,64,104,64,104,64,104,64,104,0
  106,0,106,0,106,0,106,8,104,8,104,8,104,8,104,64,104,64,104,64
  104,64,104,0,104,0,104,4,104,4,104,4,104,0,104,0,104,0

  104,0,104,0,106,0,106,4,106,4,106,4,106,4,106,0,104,0,104,0,104
  0,104,0,104,0,104,0,104,0,106,0,106,0,106,0,106,0,106,0,106,0,1
  0,1,128,0,128,0,128,0,0,0,0,0,0,0,0,1,0,1,0,1,0,169,0,1,0,1,0,1
end


  data _Data_Level8
  1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,6,1,6,1,7,1,7,129,7,129
  7,193,7,193,7,225,7,225,7,225,7,225,7,225,7,225,7,225,7,225,7,225
  7,225,7,227,7,227,7,227,7,227,7

  1,4,1,4,1,140,1,4,1,4,1,4,7,4,7,4,7,4,63,4,63,4,63,4,33,4,33,4,1
  4,1,4,1,4,1,6,1,6,17,7,17,7,17,7,17,0,17,0,49,0,33,0,33,0,33,24
  33,24,33,24,33,24,33,24

  33,24,33,24,33,24,33,24,49,24,17,24,17,24,17,24,17,24,17,0,1,7,1
  7,1,7,1,0,31,0,15,0,15,0,7,4,7,4,3,4,3,4,3,0,3,0,1,152,1,152,1
  152,1,0,1,4,33,4,33,4,1,6,1,6

  1,4,1,4,1,4,1,4,65,4,65,4,65,28,65,28,65,28,1,28,1,28,1,28,1,28,1
  28,1,28,241,31,241,31,241,31,241,7,1,0,1,0,1,152,1,152,1,152,1,0
  1,4,1,4,1,7,1,7,1,7,1,4,255,7
end


__Boss_PF_Setup
  playfield:
  XX....XXXXXXXXXXXXXXXXXX......XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
  return otherbank

__Boss_PF_Setup_2
  playfield:
  XX......XXXXXXXXXXXXXXXX......XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX..XXXXXXXXXXXXXXXXXXXXXXXX..XX
end
  return otherbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 6.
  ;
  ;
  bank 6


__Level_Data_Bank2
  z = z - 16
  on z goto __W31A __W31B __W32A __W32B __W33A __W33B __W34 __W34 __W41A __W41B __W42A __W42B __W43A __W43B __W44 __W44

__W31A
  y = _Level9A[x]:x = x + 1 : u = _Level9A[x]:return otherbank

__W31B
  y = _Level9B[x]:x = x + 1 : u = _Level9B[x]:return otherbank

__W32A
  y = _Level10A[x]:x = x + 1 : u = _Level10A[x]:return otherbank

__W32B
  y = _Level10B[x]:x = x + 1 : u = _Level10B[x]:return otherbank

__W33A
  y = _Level11A[x]:x = x + 1 : u = _Level11A[x]:return otherbank

__W33B
  y = _Level11B[x]:x = x + 1 : u = _Level11B[x]:return otherbank

__W34
  y = _Level12[x]:x = x + 1 : u = _Level12[x]:return otherbank

__W41A
  y = _Level13A[x]:x = x + 1 : u = _Level13A[x]:return otherbank

__W41B
  y = _Level13B[x]:x = x + 1 : u = _Level13B[x]:return otherbank

__W42A
  y = _Level14A[x]:x = x + 1 : u = _Level14A[x]:return otherbank

__W42B
  y = _Level14B[x]:x = x + 1 : u = _Level14B[x]:return otherbank

__W43A
  y = _Level15A[x]:x = x + 1 : u = _Level15A[x]:return otherbank

__W43B
  y = _Level15B[x]:x = x + 1 : u = _Level15B[x]:return otherbank

__W44
  y = _Level16[x]:x = x + 1 : u = _Level16[x]:return otherbank


  data _Level9A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,7
  0,7,0,4,0,4,0,4,32,4,34,4,34,4,34,4,32,4,0,4,0,4,0,4,0,4,0,4,0
  4,0,220,0,220,0,220,0,220,32,140,32,140,64,140,64,140

  32,140,32,140,0,140,0,140,0,142,0,142,0,143,0,143,128,143,128
  143,128,143,0,136,0,136,0,136,0,136,0,136,0,136,0,136,0,136
  128,143,128,143,132,143,4,143,4,143,4,142,4,142,4,140,4,140,0
  140,0

  140,0,140,0,143,16,143,16,255,16,136,16,136,16,136,16,136,0,136
  0,136,0,140,0,140,0,140,0,140,4,140,4,140,4,140,4,140,0,220,0
  220,0,220,0,220,0,220,0,220,66,140,0,140,0,140,0,140,66,140,0
  
  220,0,220,0,220,0,220,0,140,0,140,0,140,0,142,0,142,0,143,0
  143,128,143,128,143,128,143,128,143,128,143,128,143,132,143
  4,143,4,143,4,142,4,142,4,140,4,140,4,143,4,143,4,143,4,140
  4,140,4,140
end


  data _Level9B
  0,0,0,7,0,7,0,7,0,0,0,0,32,0,34,0,34,0,32,0,0,0,0,0,0,7,0,7,0,7
  0,4,0,4,8,4,8,4,72,4,72,4,64,4,64,4,0,4,4,4,4,4,4,4,180,5,180,5
  180,5,0,108,0,108,0,108,0,108,16,104,16,104

  31,104,31,104,16,108,16,108,16,108,16,108,16,108,0,108,0,105,0
  105,0,105,0,105,0,104,0,104,32,108,32,108,40,108,40,108,8,108
  8,108,8,108,8,108,8,111,8,111,8,255,8,108,8,108,8,111

  8,111,8,255,8,108,8,108,8,111,8,111,8,255,8,108,8,108,8,108,8
  108,0,188,72,4,72,4,72,4,72,4,0,4,13,4,13,4,0,188,0,188,0,188
  32,4,32,4,34,4,34,4,32,4,32,4,0,188,0,188,0,4,0,4

  128,8,128,8,160,8,160,8,8,8,8,8,8,12,8,12,0,4,0,4,0,6,0,6,0,7,0
  7,128,7,128,7,128,7,128,7,160,7,160,7,160,7,160,7,0,0,0,0,0,0,0
  0,0,0,0,0,32,0,32,168,32,0,32,0
end


  data _Level10A
  255,7,0,4,0,4,0,4,0,4,0,4,0,4,1,4,129,4,129,4,129,4,129,4,32,4,32
  4,32,0,32,0,32,0,32,0,0,0,0,0,0,0,0,0,16,0,16,0,16,0,16,0,0,0,0,0
  0,0,0,0,240,7,240,7

  240,7,32,0,0,0,0,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63,4,63,4,1
  4,1,4,1,4,1,4,17,4,17,28,17,28,17,28,17,28,17,28,17,28,17,28,17
  28,1,4,1,4,1,7,1,7,1,255

  1,0,1,0,1,120,1,120,192,7,192,7,192,7,192,7,0,0,0,0,0,120,0,120
  240,7,240,7,240,7,240,7,0,0,0,0,0,88,0,88,0,88,0,88,0,88,15,0,7
  4,3,4,1,4,1,4,1,4,137,4,137,44,137,44

  137,44,129,44,129,44,129,44,129,28,17,24,17,24,17,24,17,24,17,24
  129,28,129,44,129,44,137,44,137,44,137,44,9,76,9,76,9,12,9,12,1
  12,1,76,65,44,65,44,65,44,65,44,1,76,1,4,3,7,7,7,15,7,255,7
end


  data _Level10B
  0,0,16,7,16,7,16,7,16,4,16,4,16,4,0,4,64,4,0,4,64,4,0,4,64,4,0,4
  0,4,0,4,176,4,176,4,176,4,176,4,176,4,177,4,177,4,177,4,161,4,161
  4,161,4,161,4,163,4,163,4,1,4,1,4

  1,204,3,4,3,4,3,7,3,7,3,7,1,4,1,4,1,4,163,7,163,7,161,7,33,0,33
  0,1,4,1,4,1,4,1,4,63,4,63,4,31,4,15,4,7,4,3,4,65,4,65,4,1,188,1
  188,1,188,1,188,3,0,7,0

  15,6,31,6,31,6,31,6,3,7,1,31,0,31,0,31,16,24,16,24,16,24,16,24
  16,0,17,0,17,0,17,0,1,0,1,4,1,4,1,4,31,4,31,4,1,7,1,7,1,255,1
  4,1,4,9,4,9,4,1,15,1,15,193,15

  193,15,240,15,240,15,0,4,0,4,0,4,64,4,64,4,0,28,1,28,11,6,11,6,1
  31,1,31,129,31,129,31,128,31,128,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  0,0,0,0,129,7,129,7,129,175,129,7,129,7
end


  data _Level11A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,128,4,128,4,128,4,128
  4,0,0,0,0,0,0,0,0,0,0,0,0,64,4,64,4,64,4,64,4,64,4,64,4,64,4,0,4
  0,4,0,4,0,140,0,140,0,140,0,140,16,140,16,140,16,140

  16,140,16,140,16,140,0,140,0,140,0,140,0,140,0,136,16,136,16,136
  16,136,16,136,16,136,16,136,0,136,0,136,0,136,0,136,0,136,0,136
  32,136,32,136,32,136,32,136,32,136,32,136

  32,136,0,136,0,136,0,136,0,136,0,136,0,136,0,136,32,140,32,140,32
  140,33,4,32,0,33,0,32,0,33,0,0,4,0,4,0,4,0,4,0,4,0,92,0,92,0,92,0
  88,0,88,0,0,0,0,8,0,8,72,8,76,8,76

  64,76,64,76,64,76,64,76,0,4,0,4,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,4,0
  4,0,4,0,4,0,4,0,4,8,0,8,0,8,0,8,72,8,72,8,72,8,76,8,76,8,76,8,76
  8,76,0,76,0,4
end


  data _Level11B
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,64,0
  64,0,64,0,64,0,64,0,64,0,64,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,4,0
  4,0,92

  0,92,0,140,80,140,81,4,81,4,80,140,0,140,0,140,0,92,0,92,0,92,0
  88,0,88,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,80,4,81,4,81,4
  80,4,0,4,0,4,0,4,0,0,0,0

  0,120,0,120,0,120,0,120,0,120,0,120,0,0,64,0,64,0,64,0,64,0,64
  0,64,0,64,0,64,0,64,0,8,0,8,0,8,0,8,0,0,0,0,120,0,120,0,124,0
  124,0,124,0,124,0,124,0,124,0,120,0,120,0,88

  0,88,0,88,0,88,0,88,0,90,0,90,0,90,0,90,0,88,0,88,0,88,0,0,0,0
  0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,172
  0,4,0,4,0,4,0,4
end


  data _Level12
  1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,6,1,6,1,7,1,7,129,7,129
  7,193,7,193,7,227,7,227,7,227,7,227,7,227,7,227,7,3,4,3,4,3,4,3,4
  127,4,127,4,1,4,1,4

  1,140,1,4,1,4,1,4,3,6,3,6,3,6,3,6,3,6,3,6,3,0,3,0,3,0,195,7,192,7
  192,7,192,7,0,0,0,0,8,0,8,0,8,0,252,7,252,7,0,4,0,4,0,4,63,4,63,4
  32,4,32,4,0,4

  0,0,0,152,0,152,0,0,4,7,4,7,4,7,4,7,0,7,0,0,0,0,0,152,0,0,248,7
  252,7,28,0,12,0,28,0,252,7,248,7,0,0,0,0,0,0,0,0,24,6,24,44,24
  44,24,44,24,44,63,4,63,4,48,4

  48,4,32,4,32,4,0,28,0,28,0,30,0,30,128,31,128,31,248,31,248,31
  248,31,0,0,0,0,1,0,63,4,63,4,1,4,1,4,1,31,1,31,193,31,193,31,1
  0,1,0,1,152,1,152,1,152,1,7,1,7,1,7,255,7
end


  data _Level13A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,4,0,0,0,0
  0,0,0,4,0,4,0,0,0,0,0,0,0,4,0,4,0,0,0,0,0,0,0,4,0,4,0,28,32,4,34,4

  32,4,34,4,32,4,0,28,0,188,64,4,0,188,64,4,0,188,0,188,0,188,32
  12,32,12,32,12,32,4,0,7,0,7,0,7,0,4,0,4,64,4,64,4,0,44,0,4,0,7
  0,7,0,7,0,0,0,0,0,0,0,0,0,0

  0,0,0,4,0,4,0,4,60,4,60,4,32,4,32,28,32,28,32,28,32,28,32,28,0,28
  0,28,0,28,0,28,0,31,0,31,128,31,128,31,0,0,0,0,0,88,0,88,0,88,33
  0,33,72,34,72,34,72,33,72,33,72,0,0

  0,0,0,88,0,88,0,0,160,7,160,7,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,4
  0,4,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,0,0,0,8,7,8,7,8,255,0,0,0,0,0,0
end


  data _Level13B
  0,4,0,7,0,7,0,7,0,4,0,4,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,4,0,0,0,0
  0,4,0,4,0,4,0,0,0,0,0,4,0,4,0,4,0,0,0,0,0,0,0,4,0,4,0,4,0,4,128,44

  128,44,128,44,128,44,128,44,0,40,16,40,16,40,16,40,16,40,0,0,0,0
  0,88,0,88,0,88,0,0,13,7,13,7,13,255,0,4,0,4,0,4,0,4,16,12,16,12
  16,8,16,8,176,15,176,15,64,4,0,4,0,0,0,0

  0,0,0,0,0,7,0,7,0,255,0,4,0,4,0,76,40,4,40,4,0,76,0,76,0,88,0,88
  0,88,0,88,4,89,4,89,4,89,4,89,4,89,4,89,0,88,0,88,0,88,0,88,0,92
  0,92,0,92,0,92,0,92,0,88

  0,120,0,120,0,126,0,94,0,94,0,88,0,88,128,95,128,95,128,95,0,0,0
  0,32,0,32,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4
  0,4,0,4,0,172,0,4,0,4
end


  data _Level14A
  0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,6,0,6,0,7,0,7,128,7,128
  7,0,0,0,0,176,7,176,7,176,7,176,7,0,0,0,0,0,0,0,0,188,7,188,7,0,4
  0,4,0,188,0,188

  63,4,63,4,0,4,0,188,0,4,0,4,0,4,128,7,128,7,0,92,0,92,0,88,0,92,0
  92,0,88,0,88,0,0,32,4,32,76,32,72,32,72,0,4,0,4,0,120,0,120,0,0
  10,108,10,108,128,108,128,108,128,104,128,104

  0,104,0,104,0,104,0,104,0,108,0,108,42,108,42,108,0,108,0,108,0
  108,0,108,0,111,0,111,0,111,0,108,0,108,16,104,16,104,16,104,16
  104,0,104,0,104,0,104,128,104,128,108,128,108,128,108,64

  108,64,108,64,108,64,108,0,108,0,108,145,104,145,104,145,104,145
  104,1,104,1,104,63,108,63,108,8,4,8,4,8,4,8,4,0,0,0,0,128,0,128
  0,128,0,0,0,0,0,188,7,188,7,188,7,0,0,0,0,0,7,0,7,0,255,0,0,0,0,0,0
end


  data _Level14B
  1,4,1,7,1,7,1,7,1,4,1,4,1,4,1,4,1,4,1,4,1,0,1,0,1,0,1,0,1,0,1,0
  1,4,1,4,1,4,1,4,1,0,1,0,1,0,1,0,1,0,1,0,1,7,1,7,1,7,3,7,3,7,1,7

  1,7,1,207,3,7,3,7,3,7,3,7,3,7,1,7,1,7,1,7,163,7,163,7,163,7,163
  7,3,7,3,7,0,0,0,0,0,0,0,120,0,120,0,120,0,120,0,120,0,120,0,124
  0,124,0,124,0,124,0,120,0,120,0,120

  0,120,0,120,0,120,0,0,0,4,0,4,0,7,0,7,0,255,0,108,0,108,80,108
  80,108,80,108,80,108,0,104,0,104,176,111,176,111,176,111,0,108
  0,108,0,0,0,0,4,0,4,72,188,79,188,79,4,74,4,74,0,104,0,104

  31,104,31,104,0,108,0,108,0,108,0,108,128,104,128,104,128,104,0
  104,0,104,32,104,32,104,32,104,0,104,0,104,4,104,4,104,4,104,0
  104,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,48,0,48,168,48,0,48,0
end


  data _Level15A
  64,4,64,4,64,4,64,4,0,4,4,4,4,4,4,4,4,4,0,4,0,4,128,4,128,4,128
  4,132,4,4,4,4,4,4,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,8,0,8,4,8,4
  8,4,8,4,8,4

  8,4,8,4,8,4,8,12,8,12,8,12,0,4,0,4,0,124,0,124,0,124,0,124,0,4,0
  4,16,4,16,76,16,76,16,76,16,76,16,76,0,4,0,4,0,4,4,4,4,28,4,28,4
  28,4,28,4,28,4,28,4,28,4,28

  4,28,4,28,4,24,0,0,0,0,0,120,0,120,0,120,0,0,0,4,16,140,16,140
  16,140,16,140,16,140,16,140,16,140,16,140,16,140,16,140,16,140
  16,140,0,140,0,140,0,120,0,120,0,120,0,120,0,124,0,124,4,104,4,104

  4,104,4,104,0,104,0,104,32,104,32,104,32,104,32,104,0,104,0,104
  0,104,8,0,8,0,8,0,8,0,0,0,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,4,0
  124,0,124,0,124,0,124,0,124,0,4,0,0
end


  data _Level15B
  0,4,0,4,0,4,0,4,0,4,0,4,64,4,64,4,64,4,64,4,64,4,64,0,4,0,4,0,4
  0,4,0,4,0,0,0,0,0,0,0,0,0,4,0,4,4,4,4,4,0,4,0,4,0,4,0,4,0,4,0,0
  0,0,0

  0,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,120,0
  120,0,120

  0,120,0,120,0,120,0,104,0,104,0,104,0,104,0,104,0,104,0,108,0
  108,0,108,0,108,0,108,0,108,0,108,0,108,144,108,145,76,145,76
  145,76,145,76,144,76,0,0,0,0,0,88,0,88,4,88,4,88,4,88,4,88,4,88

  4,88,0,88,0,88,0,88,0,88,0,88,0,104,0,108,0,108,0,108,0,108,0
  108,0,104,128,104,128,104,128,104,128,104,0,104,0,104,0,104,0
  104,0,104,0,108,0,108,0,108,0,108,16,4,16,172,16,4,144,4,144
  4,144,4
end


  data _Level16
  1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,0,1,0,1,0,1,0,129,7,129
  7,193,7,193,7,225,7,225,7,225,0,225,0,225,0,225,0,225,0,225,0,225
  7,225,7,195,7,195,7,135,7,135,7

  135,7,7,0,7,0,7,0,4,152,4,24,132,31,132,31,132,31,132,31,4,31,12
  31,12,30,24,4,24,4,112,4,112,4,64,4,64,4,64,4,70,4,70,4,68,4,0,4
  0,4,252,7,252,7,0,4,0,4,0,4,0,4,0,0

  0,0,64,0,64,0,64,0,64,0,0,0,0,0,0,0,0,0,31,108,31,108,31,108,31
  108,8,104,8,104,0,104,0,104,128,104,128,104,252,104,252,104,0
  104,0,104,0,104,0,108,0,76,32,4,32,4,127,4,127,4,64,4,64,4

  0,76,0,108,240,111,240,111,0,104,0,104,193,111,195,111,3,108,3
  108,3,108,3,0,3,0,3,0,3,6,3,6,15,6,15,6,1,6,1,6,1,142,1,6,1,6
  1,6,195,7,195,7,7,0,7,0,15,7,15,7,31,7,255,7
end



__Boss_PF_Setup_3
  playfield:
  XX......XXXXXXXXXXXXXXXX......XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XX............................XX
  XXXX........................XXXX
  XX............................XX
  XX.............XX.............XX
  XX.............XX.............XX
  XX..XXXXXXXXXXXXXXXXXXXXXXXX..XX
end
  return otherbank

  
  
__Boss_PF_Setup_4
  playfield:
  XXX.....XXXXXXXXXXXXXXXX.....XXX
  XX.......XXXXXXXXXXXXXX.......XX
  XXX.......XXXX....XXXX.......XXX
  XX.........XX......XX.........XX
  XX............................XX
  XX............................XX
  XXXX........................XXXX
  XX............................XX
  XX.............XX.............XX
  XX.............XX.............XX
  XXXXXXXXXXXXX..XX..XXXXXXXXXXXXX
end
  return otherbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 7.
  ;
  ;
  bank 7



  ;***************************************************************
  ;
  ;  Soundtrack routines.
  ;
__Get_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_Music bank3

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_OWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 1 : gosub __OW_Music : goto __Get_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_OWMusicData)
  temp6 = sread(_OWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  if _Bit1_Jumping_Flag{1} || _Bit4_Enemy_Dead_Flag{4} then goto __Skip_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

__Skip_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_OWMusicData)
  temp5 = sread(_OWMusicData)
  temp6 = sread(_OWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_OWMusicData)

  goto __Got_Music bank3


  ;***************************************************************
  ;
  ;  Music data block information.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Format: 
  ;  v,c,f (channel 0)
  ;  v,c,f (channel 1) 
  ;  d
  ;
  ;  Explanation: 
  ;  v - volume (0 to 15)
  ;  c - control [a.k.a. tone, voice, and distortion] (0 to 15)
  ;  f - frequency (0 to 31)
  ;  d - duration.
  ;
  ;```````````````````````````````````````````````````````````````


  ;***************************************************************
  ;
  ;  Sound effect data for OW music.
  ;
__OW_Music
  sdata _OWMusicData=q
  8,4,23
  4,6,13
  2
  2,4,23
  1,6,13
  1
  8,4,23
  4,6,13
  3
  2,4,23
  1,6,13
  3
  8,4,23
  4,6,13
  3  
  2,4,23
  1,6,13
  3
  8,4,29
  4,6,13
  3
  8,4,23
  4,6,13
  3
  2,4,23
  1,6,13
  3
  8,4,19
  4,6,20
  3
  2,4,19
  1,6,20
  3
  0,0,0
  0,0,0
  6
  8,12,26
  4,6,20
  3
  2,12,26
  1,6,20
  3
  0,0,0
  0,0,0
  6
  8,4,14
  4,12,26
  3
  4,4,14
  2,12,26
  3
  0,0,0
  0,0,0
  3
  8,4,19
  4,12,31
  3
  4,4,19
  2,12,31
  3
  0,0,0
  0,0,0
  3
  8,4,23
  4,1,15
  3
  4,4,23
  2,1,15
  3
  0,0,0
  0,0,0
  3
  8,4,17
  4,12,29
  3
  4,4,17
  2,12,29
  3
  8,4,15
  4,12,26
  3
  4,4,15
  2,12,26
  3
  8,4,16
  4,12,27
  3
  8,4,17
  4,12,29
  3
  4,4,17
  2,12,29
  3
  8,4,19
  4,12,31
  4
  8,4,23
  4,12,19
  4
  8,4,19
  4,12,15
  4
  8,4,17
  4,12,14
  3
  4,4,17
  2,12,14
  3
  8,4,21
  4,12,17
  3
  8,4,19
  4,12,15
  3
  4,4,19
  2,12,15
  3
  8,4,23
  4,12,11
  3
  4,4,23
  2,12,11
  3
  8,4,29
  4,12,23
  3
  8,4,26
  4,12,20
  3
  8,4,31
  4,12,26
  3
  4,4,31
  2,12,26
  3
  0,0,0
  0,0,0
  3
  8,4,29
  4,12,26
  3
  4,4,29
  2,12,26
  3
  0,0,0
  0,0,0
  3
  8,4,19
  4,12,31
  3
  4,4,19
  2,12,31
  3
  0,0,0
  0,0,0
  3
  8,4,23
  4,1,15
  3
  4,4,23
  2,1,15
  3
  0,0,0
  0,0,0
  3
  8,4,17
  4,12,29
  3
  4,4,17
  2,12,29
  3
  8,4,15
  4,12,26
  3
  4,4,15
  2,12,26
  3
  8,4,16
  4,12,27
  3
  8,4,17
  4,12,29
  3
  4,4,17
  2,12,29
  3
  8,4,19
  4,12,31
  4
  8,4,23
  4,12,19
  4
  8,4,19
  4,12,15
  4
  8,4,17
  4,12,14
  3
  4,4,17
  2,12,14
  3
  8,4,21
  4,12,17
  3
  8,4,19
  4,12,15
  3
  4,4,19
  2,12,15
  3
  8,4,23
  4,12,11
  3
  4,4,23
  2,12,11
  3
  8,4,29
  4,12,23
  3
  8,4,26
  4,12,20
  3
  8,4,31
  4,12,26
  3
  4,4,31
  2,12,26
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,19
  3
  8,4,23
  2,12,19
  3
  4,4,23
  4,12,29
  3
  4,1,4
  2,12,29
  3
  8,12,11
  4,12,14
  3
  8,4,29
  4,12,19
  3
  4,4,29
  4,12,19
  3
  8,12,11
  4,12,19
  3
  8,4,29
  4,12,29
  3
  8,4,26
  4,12,29
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,26
  3
  8,4,23
  4,12,19
  3
  4,4,23
  2,12,19
  3
  8,4,14
  8,4,21
  3
  4,4,14
  4,4,21
  3
  8,4,14
  8,4,21
  2
  4,4,14
  4,4,21
  1
  8,4,14
  8,4,21
  3
  4,4,14
  4,4,21
  3
  0,0,0
  4,12,26
  3
  0,0,0
  2,12,26
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,19
  3
  8,4,23
  2,12,19
  3
  4,4,23
  4,12,29
  3
  4,1,4
  2,12,29
  3
  8,12,11
  4,12,14
  3
  8,4,29
  4,12,19
  3
  4,4,29
  4,12,19
  3
  8,12,11
  4,12,19
  3
  8,4,29
  4,12,29
  3
  8,4,26
  4,12,29
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,24
  4,1,19
  3
  4,4,24
  2,1,19
  3
  0,0,0
  0,0,0
  3
  8,4,26
  4,1,17
  3
  4,4,26
  2,1,17
  3
  0,0,0
  0,0,0
  3
  8,4,29
  4,1,15
  3
  4,4,29
  2,1,15
  3
  0,0,0
  0,0,0
  3
  0,0,0
  4,12,26
  2
  0,0,0
  2,12,26
  1
  0,0,0
  4,12,26
  3
  0,0,0
  2,12,26
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,19
  3
  8,4,23
  2,12,19
  3
  4,4,23
  4,12,29
  3
  4,1,4
  2,12,29
  3
  8,12,11
  4,12,14
  3
  8,4,29
  4,12,19
  3
  4,4,29
  4,12,19
  3
  8,12,11
  4,12,19
  3
  8,4,29
  4,12,29
  3
  8,4,26
  4,12,29
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,26
  3
  8,4,23
  4,12,19
  3
  4,4,23
  2,12,19
  3
  8,4,14
  8,4,21
  3
  4,4,14
  4,4,21
  3
  8,4,14
  8,4,21
  2
  4,4,14
  4,4,21
  1
  8,4,14
  8,4,21
  3
  4,4,14
  4,4,21
  3
  0,0,0
  4,12,26
  3
  0,0,0
  2,12,26
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,19
  4,4,23
  3
  8,4,20
  4,12,31
  3
  8,4,21
  4,4,26
  3
  8,4,24
  4,4,31
  3
  4,4,24
  4,12,19
  3
  8,4,23
  2,12,19
  3
  4,4,23
  4,12,29
  3
  4,1,4
  2,12,29
  3
  8,12,11
  4,12,14
  3
  8,4,29
  4,12,19
  3
  4,4,29
  4,12,19
  3
  8,12,11
  4,12,19
  3
  8,4,29
  4,12,29
  3
  8,4,26
  4,12,29
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,24
  4,1,19
  3
  4,4,24
  2,1,19
  3
  0,0,0
  0,0,0
  3
  8,4,26
  4,1,17
  3
  4,4,26
  2,1,17
  3
  0,0,0
  0,0,0
  3
  8,4,29
  4,1,15
  3
  4,4,29
  2,1,15
  3
  0,0,0
  0,0,0
  3
  0,0,0
  4,12,26
  2
  0,0,0
  2,12,26
  1
  0,0,0
  4,12,26
  3
  0,0,0
  2,12,26
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  8,4,29
  3,1,9
  2
  4,4,29
  1,1,9
  1
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  8,4,26
  4,12,24
  3
  4,4,26
  2,12,24
  3
  8,4,23
  4,12,26
  3
  8,4,29
  4,12,15
  3
  4,4,29
  2,12,15
  3
  8,12,11
  4,1,31
  3
  8,12,26
  4,12,19
  3
  4,12,26
  2,12,19
  3
  0,0,0
  4,6,20
  3
  0,0,0
  2,6,20
  3
  8,4,29
  3,1,9
  2
  4,4,29
  1,1,9
  1
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  8,4,26
  4,12,24
  3
  4,4,23
  4,12,26
  3
  0,0,0
  2,12,26
  3
  0,0,0
  0,0,0
  3
  0,0,0
  4,1,31
  3
  0,0,0
  2,1,31
  3
  0,0,0
  0,0,0
  3
  0,0,0
  4,6,20
  3
  0,0,0
  2,6,20
  3
  8,4,29
  3,1,9
  2
  4,4,29
  1,1,9
  1
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  4,4,29
  1,1,9
  3
  8,4,29
  3,1,9
  3
  8,4,26
  4,12,24
  3
  4,4,26
  2,12,24
  3
  8,4,23
  4,12,26
  3
  8,4,29
  4,12,15
  3
  4,4,29
  2,12,15
  3
  8,12,11
  4,1,31
  3
  8,12,26
  4,12,19
  3
  4,12,26
  2,12,19
  3
  0,0,0
  4,6,20
  3
  0,0,0
  2,6,20
  3
  255
end
  return




  ;***************************************************************
  ;
  ;  Star power music routines.
  ;
__Get_Star_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_Music bank3

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_StarPowerMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 1 : gosub __Star_Power_Music : goto __Get_Star_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_StarPowerMusicData)
  temp6 = sread(_StarPowerMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Skips channel 0 if certain flags are set.
  ;
  if _Bit1_Jumping_Flag{1} || _Bit4_Enemy_Dead_Flag{4} then goto __Skip_Star_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

__Skip_Star_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_StarPowerMusicData)
  temp5 = sread(_StarPowerMusicData)
  temp6 = sread(_StarPowerMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_StarPowerMusicData)

  goto __Got_Music bank3



  ;***************************************************************
  ;
  ;  Music data block information.
  ;
  ;```````````````````````````````````````````````````````````````
  ;  Format: 
  ;  v,c,f (channel 0)
  ;  v,c,f (channel 1) 
  ;  d
  ;
  ;  Explanation: 
  ;  v - volume (0 to 15)
  ;  c - control [a.k.a. tone, voice, and distortion] (0 to 15)
  ;  f - frequency (0 to 31)
  ;  d - duration.
  ;
  ;```````````````````````````````````````````````````````````````


  ;***************************************************************
  ;
  ;  Sound effect data for star power music.
  ;
__Star_Power_Music
  sdata _StarPowerMusicData=q
  8,4,29
  4,1,28
  3
  4,4,29
  2,1,28
  1
  8,4,29
  4,12,14
  3
  4,4,29
  2,12,14
  1
  8,4,29
  4,12,23
  3
  4,4,29
  2,12,23
  1
  8,12,17
  0,0,0
  2
  8,4,29
  4,12,17
  2
  0,0,0
  0,0,0
  2
  8,4,29
  4,12,14
  3
  4,4,29
  2,12,14
  1
  8,12,17
  0,0,0
  2
  8,4,29
  4,12,23
  2
  8,12,17
  4,12,23
  2
  8,4,29
  4,12,17
  3
  4,4,29
  4,12,17
  1
  8,4,31
  4,1,31
  3
  4,4,29
  2,1,31
  1
  8,4,31
  4,12,15
  3
  4,4,31
  2,12,15
  1
  8,4,31
  4,12,26
  3
  4,4,31
  2,12,26
  1
  8,12,19
  0,0,0
  2
  8,4,31
  4,12,19
  2
  0,0,0
  0,0,0
  2
  8,4,31
  4,12,15
  3
  4,4,31
  2,12,15
  1
  8,12,19
  0,0,0
  2
  8,4,31
  4,12,26
  2
  8,12,19
  4,12,26
  2
  8,4,31
  4,12,19
  2
  8,4,31
  4,12,19
  3
  255
end
  return




  ;***************************************************************
  ;
  ;  Underworld music routines.
  ;
__Get_UW_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1
  if _Music_Duration = 7 || _Music_Duration = 12 then AUDV0 = 0 : AUDV1 = 0 : goto __Got_Music bank3
  if _Music_Duration = 17 || _Music_Duration = 22 then AUDV0 = 0 : AUDV1 = 0 : goto __Got_Music bank3
  if _Music_Duration = 27 || _Music_Duration = 31 then AUDV0 = 0 : AUDV1 = 0 : goto __Got_Music bank3
  if _Music_Duration > 0 then goto __Got_Music bank3

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_UWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 1 : gosub __UW_Music : goto __Get_UW_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_UWMusicData)
  temp6 = sread(_UWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Skips channel 0 if certain flags are set.
  ;
  if _Bit1_Jumping_Flag{1} || _Bit4_Enemy_Dead_Flag{4} then goto __Skip_UW_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

__Skip_UW_Melody

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_UWMusicData)
  temp5 = sread(_UWMusicData)
  temp6 = sread(_UWMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_UWMusicData)

  goto __Got_Music bank3



  ;***************************************************************
  ;
  ;  Sound effect data for UW music.
  ;
__UW_Music
  sdata _UWMusicData=q
  0,0,0
  8,1,15
  3
  0,0,0
  8,12,19
  3
  0,0,0
  8,1,18
  3
  0,0,0
  8,12,23
  3
  0,0,0
  8,1,17
  3
  0,0,0
  8,1,8
  3
  0,0,0
  0,0,0
  18
  0,0,0
  8,1,15
  3
  0,0,0
  8,12,19
  3
  0,0,0
  8,1,18
  3
  0,0,0
  8,12,23
  3
  0,0,0
  8,1,17
  3
  0,0,0
  8,1,8
  3
  0,0,0
  0,0,0
  18
  0,0,0
  8,1,23
  3
  0,0,0
  8,12,29
  3
  0,0,0
  8,1,28
  3
  0,0,0
  8,6,13
  3
  0,0,0
  8,1,26
  3
  0,0,0
  8,6,12
  3
  0,0,0
  0,0,0
  18
  0,0,0
  8,1,23
  3
  0,0,0
  8,12,29
  3
  0,0,0
  8,1,28
  3
  0,0,0
  8,6,13
  3
  0,0,0
  8,1,26
  3
  0,0,0
  8,6,12
  3
  0,0,0
  0,0,0
  12
  0,0,0
  8,1,26
  2
  0,0,0
  8,1,28
  2
  0,0,0
  8,1,29
  2
  0,0,0
  8,1,31
  6
  0,0,0
  8,1,26
  6
  0,0,0
  8,1,28
  6
  0,0,0
  8,1,19
  6
  0,0,0
  8,7,20
  6
  0,0,0
  8,1,29
  6
  0,0,0
  8,1,31
  2
  0,0,0
  8,1,19
  2
  0,0,0
  8,1,23
  2
  0,0,0
  8,6,24
  2
  0,0,0
  8,1,17
  2
  0,0,0
  8,1,18
  2
  0,0,0
  8,1,19
  4
  0,0,0
  8,1,26
  4
  0,0,0
  8,14,10
  4
  0,0,0
  8,14,12
  4
  0,0,0
  8,14,14
  4
  0,0,0
  8,14,16
  4
  0,0,0
  0,0,0
  36
  255
end
  return

__Play_FF_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_FF_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_FanFareMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 255 : goto __Got_FF_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_FanFareMusicData)
  temp6 = sread(_FanFareMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_FanFareMusicData)
  temp5 = sread(_FanFareMusicData)
  temp6 = sread(_FanFareMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_FanFareMusicData)

__Got_FF_Music

  return otherbank



  ;***************************************************************
  ;
  ;  Sound effect data for fanfare music.
  ;
__Fanfare_Music
  sdata _FanFareMusicData=q
  8,12,26
  4,12,26
  4
  8,12,19
  4,12,31
  4
  8,12,15
  4,12,26
  4
  8,4,19
  3,1,31
  4
  8,4,29
  4,12,31
  4
  8,4,23
  4,12,26
  4
  8,4,19
  4,12,15
  12
  8,4,23
  4,12,19
  12
  8,12,24
  4,12,24
  4
  8,12,19
  3,1,26
  4
  8,12,16
  4,12,24
  4
  6,1,4
  3,1,31
  4
  8,4,29
  3,1,26
  4
  8,4,24
  4,12,24
  4
  8,4,18
  4,12,16
  12
  8,4,24
  4,12,19
  12
  6,1,8
  0,0,0
  4
  8,12,17
  4,12,29
  4
  8,12,14
  3,1,8
  4
  6,1,8
  3,1,13
  4
  8,4,26
  4,12,29
  4
  8,4,21
  3,1,8
  4
  8,4,16
  4,12,14
  10
  4,4,16
  2,12,14
  2
  8,4,16
  4,12,17
  3
  4,4,16
  2,12,17
  1
  8,4,16
  4,12,17
  3
  4,4,16
  2,12,17
  1
  8,4,16
  4,12,17
  3
  4,4,16
  2,12,17
  1
  8,4,14
  4,12,15
  24
  0,0,0
  0,0,0
  12
  255
end
  return

__Play_Death_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_Death_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_DeathMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 255 : goto __Got_Death_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_DeathMusicData)
  temp6 = sread(_DeathMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 1 data.
  ;
  temp4 = sread(_DeathMusicData)
  temp5 = sread(_DeathMusicData)
  temp6 = sread(_DeathMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 1.
  ;
  AUDV1 = temp4
  AUDC1 = temp5
  AUDF1 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_DeathMusicData)

__Got_Death_Music

  return otherbank



  ;***************************************************************
  ;
  ;  Sound effect data for death music.
  ;
__Death_Music
  sdata _DeathMusicData=q
  8,4,29
  0,0,0
  1
  8,4,27
  0,0,0
  1
  8,4,26
  0,0,0
  1
  0,0,0
  0,0,0
  9
  8,4,31
  4,12,26
  3
  8,4,21
  4,4,26
  3
  4,4,21
  2,4,26
  3
  8,4,21
  4,12,26
  2
  4,4,21
  2,12,26
  1
  8,4,21
  4,12,26
  4
  8,4,23
  4,12,23
  4
  8,4,26
  4,12,20
  4
  8,4,29
  4,12,19
  3
  8,12,15
  2,12,19
  3
  4,12,15
  4,12,26
  3
  8,12,15
  2,12,26
  3
  8,12,19
  4,1,31
  3
  4,12,19
  2,1,31
  3
  0,0,0
  0,0,0
  9
  255
end
  return otherbank

__Play_Final_Music

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of current note.
  ;
  _Music_Duration = _Music_Duration - 1

  if _Music_Duration > 0 then goto __Got_Final_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves channel 0 data.
  ;
  temp4 = sread(_FinalMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Checks for end of data.
  ;
  if temp4 = 255 then _Music_Duration = 255  : goto __Got_Final_Music

  ;```````````````````````````````````````````````````````````````
  ;  Retrieves more channel 0 data.
  ;
  temp5 = sread(_FinalMusicData)
  temp6 = sread(_FinalMusicData)

  ;```````````````````````````````````````````````````````````````
  ;  Plays channel 0.
  ;
  AUDV0 = temp4
  AUDC0 = temp5
  AUDF0 = temp6

  ;```````````````````````````````````````````````````````````````
  ;  Sets duration.
  ;
  _Music_Duration = sread(_FinalMusicData)

__Got_Final_Music

  return otherbank



  ;***************************************************************
  ;
  ;  Sound effect data for final music.
  ;
__Final_Music
  sdata _FinalMusicData=q
  8,12,29
  4
  8,12,17
  4
  8,12,19
  4
  8,12,29
  4
  8,12,17
  4
  8,12,19
  4
  8,12,29
  4
  8,12,17
  4
  8,12,19
  2
  7,12,19
  2
  6,12,19
  2
  5,12,19
  2
  4,12,19
  2
  3,12,19
  2
  2,12,19
  2
  1,12,19
  2
  0,0,0
  2
  255
end
  return otherbank





  ;***************************************************************
  ;***************************************************************
  ;
  ;  Bank 8.
  ;
  ;
  bank 8



  ;***************************************************************
  ;
  ;  Not a whole lot here in Bank 8 because this is where all the
  ;  sprite and table information is stored when batari Basic
  ;  compiles your program. This means you have less program space
  ;  in this bank. So in this bank is basically where I added one
  ;  more enemy I wanted (Thwomps) and the entire ending sequence of the game..
  ;
__Thwomp

  gosub __ThwompC

  if _Enemy_Type = _Thwomp then NUSIZ1 = $15

  if _Bit3_Enemy_Direction{3} then goto __T2

  if player0x < player1x then x = player1x - player0x

  if player0x > player1x then x = player0x - player1x

  if x < 32 then _Bit3_Enemy_Direction{3} = 1

  gosub __Thwomp1

  goto __Main_Loop bank1


__T2

  if _Enemy_Momentum = 0 then player1y = player1y + 8 : gosub __Thwomp2

  if _Enemy_Momentum > 0 && _Enemy_Momentum < 16 then _Enemy_Momentum = _Enemy_Momentum + 1 : gosub __Thwomp2

  if _Enemy_Momentum = 2 || _Enemy_Momentum = 4 then player1y = player1y - 1

  if _Enemy_Momentum = 3 || _Enemy_Momentum = 5 then player1y = player1y + 1

  if _Enemy_Momentum = 16 then player1y = player1y - 4 : gosub __Thwomp1

  x = (player1x - 9)/4

  if _Enemy_Momentum = 16 then y = (player1y - 12)/8 else y = (player1y/8)

  if !pfread(x,y) then goto __Main_Loop bank1

  if _Enemy_Momentum = 0 then _Enemy_Momentum = 1 : player1y = (y * 8) - 1 : AUDV0 = 10 : AUDC0 = 7 : AUDF0 = 22

  if _Enemy_Momentum = 16 then _Enemy_Momentum = 0 : player1y = 24 : _Bit3_Enemy_Direction{3} = 0

  goto __Main_Loop bank1

__ThwompC
  player1color:
  $0E
  $0C
  $0A
  $04
  $06
  $08
  $08
  $08
  $08
  $06
  $0A
  $0E
  $0E
  $0A
  $0C
  $0E
end
  return thisbank

__Thwomp1
  player1:
  %11011011
  %11011011
  %10000001
  %01111110
  %11111111
  %01011010
  %11100111
  %01111110
  %01111110
  %10011001
  %01111110
  %11111111
  %01100110
  %10011001
  %11011011
  %11011011
end
  return thisbank

__Thwomp2
  player1:
  %11011011
  %11011011
  %10000001
  %01111110
  %10111101
  %10111101
  %11000011
  %01111110
  %01011010
  %11000011
  %00011000
  %11111111
  %01100110
  %10011001
  %11011011
  %11011011
end
  return thisbank



__Final

  y = 30 : gosub __Pause_B8

  for z = 1 to 8

  pfclear

  y = 4 : gosub __Pause_B8

  gosub __Boss_PF_Setup_4 bank6

  gosub __Pause_B8

  next z

  pfclear

  y = 30 : gosub __Pause_B8


__Final2

  if player1x > 0 then player1x = player1x - 1 else player1y = 150 : goto __Final3

  if player0x > 0 then player0x = player0x - 1 else player0y = 150

  NUSIZ1 = $15

  drawscreen

  goto __Final2


__Final3

  _Enemy_Type = _Goomba : gosub __Pause_B8

  gosub __PrincessC : gosub __PB

  player1y = 80

  for x = 150 to 100 step -1

  player1x = x

  REFP1 = 8

  drawscreen

  next x

  gosub __Pause_B8

  _Animation_Timer = 0 : _Bit6_Regular_Mario{6} = 0 : _Bit3_Super_Mario_Power{3} = 1 : _Momentum_Left_Right = 1 : player0y = 80

  for z = 0 to 74

  _Animation_Timer = _Animation_Timer + 1

  if _Animation_Timer > 6 then _Animation_Timer = 0

  gosub __Set_Up_Mario bank1

  player0x = z

  y = 3 : gosub __Pause_B8

  next z

  _Animation_Timer = 0 : gosub __Set_Up_Mario bank1

  y = 30 : gosub __Pause_B8

  gosub __PA

  y = 40 : gosub __Pause_B8

  _Enemy_Type = 1

  y = 120 : gosub __Pause_B8

  for z = 100 to 84 step -1

  player1x = z

  y = 3 : gosub __Pause_B8

  next z

  gosub __Final_Music bank7

  _Music_Duration = 1

  pfcolors:
  $46
  $48
  $4A
  $4A
  $4A
  $48
  $48
  $00
  $00
  $00
  $0A
end

  playfield:
  ..............XX.XX.............
  .............XXXXXXX............
  .............XXXXXXX............
  ..............XXXXX.............
  ...............XXX..............
  ................X...............
  ................................
  ................................
  ................................
  ................................
  ................................
end

__Final4

  gosub __Play_Final_Music bank7

  if _Music_Duration = 255 then goto __Final5

  y = 4 : gosub __Pause_B8

  goto __Final4

__Final5

  _World = 1 : _Level = 1

  _Coin_Counter = 0 : _Bit3_Super_Mario_Power{3} = 0 : _Bit4_Firey_Mario_Power{4} = 0 : g = 0 : pfscore2 = 0

  _Bit6_Regular_Mario{6} = 1 : _Bit7_2nd_Quest{7} = 1

  if joy0fire then score = 0 : goto __Gm_Ovr_Scrn_4 bank4

  COLUPF = $46

  drawscreen

  goto __Final5

__Pause_B8

  for x = 1 to y

  COLUPF = $46

  if _Enemy_Type = _Bowser_Jr then NUSIZ1 = $15 : COLUPF = $04 

  if _Enemy_Type = _Goomba then REFP1 = 8

  drawscreen

  next x

  return thisbank

__PrincessC 
  player1color:
  $0C
  $0C
  $4A
  $4A
  $4A
  $48
  $0C
  $0C
  $0A
  $4A
  $4A
  $48
  $28
  $3C
  $3C
  $3C
  $3C
  $3C
  $3C
  $2C
  $2A
  $28
  $1C
  $1E
end
  return thisbank

__PA
  player1:
  %11111111
  %00111100
  %11000011
  %11111111
  %01111110
  %01111110
  %10110000
  %01011100
  %00001100
  %00110010
  %01111110
  %00111100
  %00000110
  %00110011
  %01011011
  %01111101
  %00101101
  %00101011
  %01011011
  %10100111
  %11111111
  %01111110
  %01101100
  %01010100
end
  return thisbank

__PB
  player1:
  %11111111
  %00111100
  %11000011
  %11111111
  %01111110
  %01111110
  %00000000
  %01011100
  %10101100
  %00110010
  %01111110
  %00111100
  %00000110
  %00111011
  %01111011
  %01110101
  %00100101
  %01011011
  %10100111
  %11111111
  %11111111
  %01111110
  %01101100
  %01010100
end
  return thisbank