   ;***************************************************************
   ;
   ;  Seaweed Assault
   ;
   ;  By Duane Alan Hahn (Random Terrain) using hints, tips,
   ;  code snippets, and more from AtariAge members such as
   ;  batari, SeaGtGruff, RevEng, Robert M, Atarius Maximus,
   ;  jrok, Nukey Shay, supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Please no not change a couple of things in this program and
   ;  claim it as your own original work. Please do not extract
   ;  the sound effects and place them in your own programs.
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
   ;  Multicolored sprite and multicolored playfield.
   ;
   set kernel_options player1colors pfcolors



   ;***************************************************************
   ;
   ;  The game will have 8 banks (32k/4k = 8 banks).
   ;
   set romsize 32kSC



   ;***************************************************************
   ;
   ;  Random numbers can slow down bank-switched games. This will
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
   ;  Player movement.
   ;
   dim _P0_Left_Right = player0x.a

   dim _P0_Up_Down = player0y.b

   ;```````````````````````````````````````````````````````````````
   ;  Enemy and bonus item movement.
   ;
   dim _P1_Up_Down = player1y.c

   dim _P1_Left_Right = player1x.d

   ;```````````````````````````````````````````````````````````````
   ;  _Master_Counter can be used for many things, but it is 
   ;  really useful for animating sprite frames when used
   ;  with _Frame_Counter.
   ;
   dim _Master_Counter = e
   dim _Frame_Counter = f

   ;```````````````````````````````````````````````````````````````
   ;  Sound channel 0 variables.
   ;
   dim _Ch0_Sound = g
   dim _Ch0_Duration = h
   dim _Ch0_Counter = i

   ;```````````````````````````````````````````````````````````````
   ;  Sound channel 1 variables.
   ;
   dim _Ch1_Sound = j
   dim _Ch1_Duration = k
   dim _Ch1_Counter = l

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity slide counter.
   ;
   dim _Slide_Counter = m

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity speed.
   ;
   dim _Slide_Speed = n

   ;```````````````````````````````````````````````````````````````
   ;  Counts how many bits of seaweed have been shot.
   ;
   dim _Seaweed_Shot = o

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program how often pixels will appear.
   ;
   dim _Plop_Rate = p

   ;```````````````````````````````````````````````````````````````
   ;  Score-related variables.
   ;
   dim _Shot_Bonus_Counter = q
   dim _Points_Roll_Up = r

   ;```````````````````````````````````````````````````````````````
   ;  Counter for tentacle grab.
   ;
   dim _Tentacle_Grab_Counter = s

   ;```````````````````````````````````````````````````````````````
   ;  Earliest the Wrothopod can appear.
   ;
   dim _Wrothopod_Counter = t

   ;```````````````````````````````````````````````````````````````
   ;  Homing Health cycle counter for score background.
   ;
   dim _Homing_Sc_Bck_Cntr = u.v

   ;```````````````````````````````````````````````````````````````
   ;  Corroded Canister appearance counter.
   ;
   dim _Corrdd_App_Counter = w

   ;```````````````````````````````````````````````````````````````
   ;  Corroded Canister timer.
   ;  
   dim _Corrdd_Timer = x

   ;```````````````````````````````````````````````````````````````
   ;  Corroded Canister shot counter.
   ;
   dim _Corrdd_Shot_Counter = y

   ;```````````````````````````````````````````````````````````````
   ;  Manatee hurt counter.
   ;
   dim _Manatee_Hurt_Counter = z

   ;```````````````````````````````````````````````````````````````
   ;  Manatee health counter.
   ;
   dim _Manatee_Health_Counter = var0

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the high score from game to game.
   ;  _High_Score1 remembers _sc1 until the game
   ;  is turned off. _High_Score2 remembers _sc2
   ;  until the game is turned off. _High_Score3
   ;  remembers _sc3 until the game is turned off.
   ;
   dim _High_Score1 = var1
   dim _High_Score2 = var2
   dim _High_Score3 = var3

   ;```````````````````````````````````````````````````````````````
   ;  Temporarily remembers the score for the game over and
   ;  auto play 2 second score/high score flip.
   ;
   dim _Score1_Mem = var4
   dim _Score2_Mem = var5
   dim _Score3_Mem = var6

   ;```````````````````````````````````````````````````````````````
   ;  Variables for the pause feature.
   ;
   dim _Pause_Counter = var7

   dim _Pause_Mem_Sprite1_UD = var8

   dim _Pause_Mem_Sprite1_LR = var9

   dim _Pause_Mem_Health_Color = var10

   dim _Pause_Mem_SCBack_Color = var11

   dim _Pause_Mem_Score_Color = var12

   dim _Pause_Mem_Sprite0_Color = var13

   dim _Pause_Mem_No_Repeat = var14

   dim _Pause_Mem_Missile0y = var15

   ;```````````````````````````````````````````````````````````````
   ;  Thousand bonus bit.
   ;
   dim _1000_Counter = var16

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the last Wrothopod color.
   ;
   dim _Wroth_Color_Mem = var17

   ;```````````````````````````````````````````````````````````````
   ;  Moves tentacle up and down.
   ;
   dim _Ball_Y = bally.var18

   ;```````````````````````````````````````````````````````````````
   ;  Used for displaying right/left handed screens for a certain
   ;  amount of time.
   ;
   dim _Select_Timer = var19

   ;```````````````````````````````````````````````````````````````
   ;  My temporary variables 01.
   ;  
   dim _MyTemp_01 = var20

   dim _MLSetup_Tmp_Close_In_01 = var20

   dim _ML_Tmp_AP_Ship_Dir = var20

   dim _GmOvr_Tmp_Tone_Flip_Counter = var20

   dim _GmOvr_Tmp_Anim_Counter = var20

   ;```````````````````````````````````````````````````````````````
   ;  My temporary variables 02.
   ; 
   dim _MyTemp_02 = var21

   dim _MLSetup_Tmp_Close_In_02 = var21

   dim _MLoop_Tmp_Corrdd_Anim_Count = var21

   dim _GmOvr_Tmp_Frame_Counter = var21

   ;```````````````````````````````````````````````````````````````
   ;  My temporary variables 03.
   ; 
   dim _MyTemp_03 = var22

   dim _MLSet_Tone_Flip_Cntr_Tmp = var22

   dim _AP_2_Sec_Score_Flip = var22

   dim _GmOvr_Tmp_Y_Fill_Counter = var22

   dim _GmOvr_Tmp_Scroll_Counter = var22

   ;```````````````````````````````````````````````````````````````
   ;  My temporary variables 04.
   ; 
   dim _MyTemp_04 = var23

   dim _MLSetup_Tmp_Close_In_Counter = var23

   dim _GmOvr_Tmp_x_Fill_Counter = var23

   dim _GmOvr_Tmp_8_Scroll_Counter = var23

   ;```````````````````````````````````````````````````````````````
   ;  Corroded canister X and Y shot memory.
   ;  
   dim _Corrdd_X_Shot_Mem = var24

   dim _Corrdd_Y_Shot_Mem = var25

   ;```````````````````````````````````````````````````````````````
   ;  Level counter.
   ; 
   dim _Level_Counter = var26

   ;```````````````````````````````````````````````````````````````
   ;  Plop timer.
   ; 
   dim _Plop_Timer = var27

   dim _GmOvr_Tmp_GOAnim_Counter = var27

   ;```````````````````````````````````````````````````````````````
   ;  Second Corroded Canister animation counter.
   ; 
   dim _Corroded_Anim_Frame = var28

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Ship BitOp variables.
   ;  
   dim _BitOp_Ship = var29

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which way the ship is facing.
   ;
   dim _Bit0_Ship_Facing_Up = var29
   dim _Bit1_Ship_Facing_Down = var29
   dim _Bit2_Ship_Facing_Left = var29
   dim _Bit3_Ship_Facing_Right = var29

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction to slide.
   ;
   dim _Bit4_Ship_U_Slide = var29
   dim _Bit5_Ship_D_Slide = var29
   dim _Bit6_Ship_L_Slide = var29
   dim _Bit7_Ship_R_Slide = var29

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Misc bits and snapshot of the ship direction to keep
   ;  the torpedo on track.
   ;
   dim _Bitop_Misc_Snapshot = var30

   ;```````````````````````````````````````````````````````````````
   ;  Tells program if torpedo is moving.
   ;
   dim _Bit0_Shot_Moving = var30

   ;```````````````````````````````````````````````````````````````
   ;  Player0 (Manatee) collision with seaweed.
   ;
   dim _Bit1_P0_Hit_Seaweed = var30

   ;```````````````````````````````````````````````````````````````
   ;  Limits the seaweed multiplier bonus.
   ;
   dim _Bit2_Bonus_Limit = var30

   ;```````````````````````````````````````````````````````````````
   ;  Flips player sprite when necessary.
   ;
   dim _Bit3_Flip_P0 = var30

   ;```````````````````````````````````````````````````````````````
   ;  Makes a snapshot of the ship direction so the torpedo will
   ;  stay on track until it hits something.
   ;
   dim _Bit4_Shot_U_Snapshot = var30
   dim _Bit5_Shot_D_Snapshot = var30
   dim _Bit6_Shot_L_Snapshot = var30
   dim _Bit7_Shot_R_Snapshot = var30

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Ship Restrainer
   ;
   ;  Keeps the player from going forward into the same 
   ;  pfpixel until the bounce back is over. They are also
   ;  used to control where the torpedo will start.
   ;
   dim _Bitop_Ship_Restrainer = var31
   dim _Bit0_Ship_Restrainer_U = var31
   dim _Bit1_Ship_Restrainer_D = var31
   dim _Bit2_Ship_Restrainer_L = var31
   dim _Bit3_Ship_Restrainer_R = var31
   dim _Bit4_Ship_Restrainer_UL = var31
   dim _Bit5_Ship_Restrainer_UR = var31
   dim _Bit6_Ship_Restrainer_DL = var31
   dim _Bit7_Ship_Restrainer_DR = var31

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Keeps Reset switch from contaminating other sections of the
   ;  game. Reset switch must be released before it will work.
   ;  _Bit0_Reset_Restrainer{0} does double duty in the title
   ;  screen and game over loops by including the fire button.
   ;
   dim _Bit0_Reset_Restrainer = var32

   ;```````````````````````````````````````````````````````````````
   ;  Keeps fire button from contaminating other sections of the
   ;  game. Fire button must be released before it will work.
   ;
   dim _Bit1_FireB_Restrainer = var32

   ;```````````````````````````````````````````````````````````````
   ;  Shared: Keeps player from holding joystick in one direction 
   ;  in the title screen loop.
   ;
   dim _Bit1_Joystick_Restrainer_Tmp = var32

   ;```````````````````````````````````````````````````````````````
   ;  Shared: Used in the game over Loop.
   ;
   dim _Bit1_Tmp_Ship_On_Screen = var32

   ;```````````````````````````````````````````````````````````````
   ;  Time for tentacle to grab Manatee.
   ;
   dim _Bit2_Move_Tentacle_Up = var32

   ;```````````````````````````````````````````````````````````````
   ;  The ship has been grabbed, now slide down a bit.
   ;
   dim _Bit3_Ship_Yanked_Down = var32

   ;```````````````````````````````````````````````````````````````
   ;  Makes the player sprite move down at the start of the game.
   ;
   dim _Bit4_Game_Started = var32

   ;```````````````````````````````````````````````````````````````
   ;  Alternative torpedo hitting seaweed sound.
   ;
   dim _Bit5_Sound_Alt_Torpedo_Hit = var32

   ;```````````````````````````````````````````````````````````````
   ;  Flips between the current score and the high score.
   ;
   dim _Bit6_Swap_Scores = var32

   ;```````````````````````````````````````````````````````````````
   ;  Vblank check.
   ;
   dim _Bit7_Vblank01 = var32

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Health canister on the screen.
   ;
   dim _Bit0_Canister_P1_On = var33

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod on the screen.
   ;
   dim _Bit1_Wrothopod_On = var33

   ;```````````````````````````````````````````````````````````````
   ;  Flips Wrothopod sprite when necessary.
   ;
   dim _Bit2_Wroth_Flip = var33

   ;```````````````````````````````````````````````````````````````
   ;  Tracks if another Health Canister is earned again while
   ;  the Health Canister is on the screen.
   ;
   dim _Bit3_Canister_Later = var33

   ;```````````````````````````````````````````````````````````````
   ;  Health Canister earned every thousand points.
   ;
   dim _Bit4_Bonus_500_On = var33

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod shot and angry.
   ;
   dim _Bit5_Wroth_Mad = var33

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod touched.
   ;
   dim _Bit6_Wroth_Touched = var33

   ;```````````````````````````````````````````````````````````````
   ;  Vblank check.
   ;
   dim _Bit7_Vblank02 = var33

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Give Thousand point canister later.
   ;
   dim _Bit0_Thousand_Bonus_Later = var34

   ;```````````````````````````````````````````````````````````````
   ;  Triggers the canister.
   ;
   dim _Bit1_Canister_Trigger = var34

   ;```````````````````````````````````````````````````````````````
   ;  Turns on corroded canister.
   ;
   dim _Bit2_Corrdd_Can_On = var34

   ;```````````````````````````````````````````````````````````````
   ;  Makes corroded canister chase player.
   ;
   dim _Bit3_Corroded_Can_Chase_Player = var34

   ;```````````````````````````````````````````````````````````````
   ;  Tells Corroded Canister section that seaweed has been shot.
   ;
   dim _Bit4_Corrdd_Can_Swd_Shot = var34

   ;```````````````````````````````````````````````````````````````
   ;  Health Canister trigger.
   ;
   dim _Bit5_Bonus_500_Trigger = var34

   ;```````````````````````````````````````````````````````````````
   ;  Homing color cycle bit for score background.
   ;
   dim _Bit6_Homing_Color_Cycle_On = var34

   ;```````````````````````````````````````````````````````````````
   ;  Homing color cycle for score background.
   ;
   dim _Bit7_Select_Restrainer = var34

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Pause position.
   ;
   dim _Bit0_Pause_Position = var35

   ;```````````````````````````````````````````````````````````````
   ;  Pause Check.
   ;
   dim _Bit1_Pause_Check = var35

   ;```````````````````````````````````````````````````````````````
   ;  Thousand bonus bit.
   ;
   dim _Bit2_1000_On = var35

   ;```````````````````````````````````````````````````````````````
   ;  Easter egg bit.
   ;
   dim _Bit3_Easter_Egg = var35

   ;```````````````````````````````````````````````````````````````
   ;  Manatee hurt color.
   ;
   dim _Bit4_Manatee_Hurt_Color = var35

   ;```````````````````````````````````````````````````````````````
   ;  Manatee health color.
   ;
   dim _Bit5_Manatee_Health_Color = var35

   ;```````````````````````````````````````````````````````````````
   ;  Manatee moved away.
   ;
   dim _Bit6_Manatee_Moved_Away = var35

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program if the tentacle touched the player.
   ;
   dim _Bit7_Tentacle_Touched = var35

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Remembers the seaweed replication rate. Do not clear.
   ;
   dim _Replication_Rate_Storage = var44

   ;```````````````````````````````````````````````````````````````
   ;  Assigns a variable to the score background.
   ;
   dim _SC_Back = var45

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Untouchable BitOp variables.
   ;
   ;  _Bit0_Game_Control controls when the game ends in the main
   ;  loop and how the game will be reset in the game over loop.
   ;  In the game over loop, the title screen is skipped if game
   ;  has been played and the player presses fire or reset.
   ;
   ;  From main loop:
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   ;  From the game over loop:
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   dim _Bit0_Game_Control = var46

   ;```````````````````````````````````````````````````````````````
   ;  Title screen auto-play.
   ;
   dim _Bit1_Auto_Play = var46

   ;```````````````````````````````````````````````````````````````
   ;  Right/Left Hand toggle.
   ;
   dim _Bit2_Right_Left_Hand = var46

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers. 
   ;
   dim rand16 = var47

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Converts 6 digit score to 3 sets of two digits.
   ;  _sc1 holds the 100 thousands and 10 thousands
   ;  digits of the score. _sc2 holds the thousands and
   ;  hundreds digits of the score. _sc3 holds the tens
   ;  and ones digits of the score.
   ;  
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2




   ;***************************************************************
   ;
   ;  Enables pfscore bars.
   ;
   const pfscore = 1




   ; Sound Effect Constants  -01-
   ;***************************************************************
   ;
   ;  Constants for channel 0 sound effects (_Ch0_Sound).
   ;  [The c stands for constant.]
   ;
   const _c_Torp_Hit_Seaweed_01 = 1
   const _c_Torp_Hit_Seaweed_02 = 2
   const _c_Ship_Bounce = 3
   const _c_Shoot = 4
   const _c_1000_Health = 5
   const _c_Game_Over = 6
   const _c_Gyvolver = 7



   ;***************************************************************
   ;
   ;  Constants for channel 1 sound effects (_Ch1_Sound).
   ;  [The c stands for constant].
   ;
   const _c_Ship_Drop_In = 1
   const _c_Tentacle_Reaching_Up = 2
   const _c_Wrothopod = 3
   const _c_Canister_Appear = 4
   const _c_Canister_Touched = 5
   const _c_Corroded_Tick_Down = 6
   const _c_Corroded_Seaweed_Moosh = 7
   const _c_Corroded_Chase = 8
   const _c_Corroded_Hit_Ship = 9
   const _c_GO_Seaweed_Attack = 10
   const _c_MLS_Seaweed_Close_In = 11



   ;***************************************************************
   ;
   ;  Clears the score the first time only. This happens once
   ;  at the beginning, outside of any game loops, so the high
   ;  score won't be erased.
   ;
   score = 0



   ;***************************************************************
   ;
   ;  Right/Left hand toggle. 1 = Right hand. 0 = Left hand.
   ;
   _Bit2_Right_Left_Hand{2} = 1





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PROGRAM START/RESTART  -02-
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
   ;  Makes sure objects are off the screen.
   ;
   player0y = 200 : player1y = 200 : missile0y = 200 : bally = 200


   ;***************************************************************
   ;
   ;  Clears the screen.
   ;
   pfclear


   ;***************************************************************
   ;
   ;  Makes background color black.
   ;
   COLUBK = 0


   ;***************************************************************
   ;
   ;  Updates the screen to avoid any screen flipping.
   ;
   drawscreen


   ;***************************************************************
   ;
   ;  Sets up variables, object locations, colors, and so on.
   ;  Do not clear out _Bit0_Game_Control{0} here. It is used to control
   ;  how the game is reset.
   ;
   gosub __Clear_and_Set


   ;***************************************************************
   ;
   ;  Skips title screen if game has been played and player
   ;  presses fire button or reset switch at the end of the game.
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   if _Bit0_Game_Control{0} then goto __Main_Loop_Setup




   ;***************************************************************
   ;***************************************************************
   ;
   ;  TITLE SCREEN SETUP  -03-
   ;
   ;
__Title_Screen_Setup


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
   ;  Restrains the select switch.
   ;
   _Bit7_Select_Restrainer{7} = 1


   ;***************************************************************
   ;
   ;  Clears variables for the title screen loop.
   ;
   _Bit1_Joystick_Restrainer_Tmp{1} = 0 : _Master_Counter = 0 : _Frame_Counter = 0


   ;***************************************************************
   ;
   ;  Sets up the playfield.
   ;
__Title_Screen_Playfield

   playfield:
   .XXX.XXX..XX..X...X.XXX.XXX.XXX.
   X....X...X..X.X...X.X...X...X..X
   .XX..XXX.XXXX.X.X.X.XXX.XXX.X..X
   ...X.X...X..X.XX.XX.X...X...X..X
   XXX..XXX.X..X.X...X.XXX.XXX.XXX.
   ................................
   .XX...XXX..XXX..XX..X..X.X.XXXXX
   X..X.X....X....X..X.X..X.X...X..
   XXXX..XX...XX..XXXX.X..X.X...X..
   X..X....X....X.X..X.X..X.X...X..
   X..X.XXX..XXX..X..X..XX..XXX.X..
end


   ;***************************************************************
   ;
   ;  Makes sure objects are off the screen.
   ;
   player0y = 200 : player1y = 200 : missile0y = 200 : bally = 200




   ;***************************************************************
   ;***************************************************************
   ;
   ;  TITLE SCREEN LOOP  -04-
   ;
   ;
__Title_Screen_Loop



   ;***************************************************************
   ;
   ;  Sets background, score, and bar colors.
   ;
   COLUBK = 0 : scorecolor = 0 : _SC_Back = 0 : pfscorecolor = 0



   ;***************************************************************
   ;
   ;  Sets playfield colors.
   ;
   pfcolors:
   $9E
   $9C
   $9A
   $98
   $96
   $1C
   $9E
   $9C
   $9A
   $98
   $96
end



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen


   ;***************************************************************
   ;
   ;  Makes a sound if joystick is moved.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if no joystick movement.
   ;
   if !joy0up && !joy0left && !joy0right && !joy0down then goto __TS_Skip_Joy_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound is playing.
   ;
   if _Bit1_Joystick_Restrainer_Tmp{1} then goto __TS_Skip_Joy_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Starts tentacle reaching up sound effect.
   ;
   _Ch0_Sound = _c_Tentacle_Reaching_Up

   _Frame_Counter = 0 : _Ch0_Counter = 0

   _Ch0_Duration = 1 : _Bit1_Joystick_Restrainer_Tmp{1} = 1 

__TS_Skip_Joy_Sound



   ;***************************************************************
   ;
   ;  Title screen sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 0 sounds if no ch. 0 sound effect is on.
   ;
   if !_Ch0_Sound then goto __TS_Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sections if duration counter is greater
   ;  than zero.
   ;
   if _Ch0_Duration then goto __TS_Skip_Ch_0



   ;***************************************************************
   ;
   ;  Title screen channel 0 sound effect.
   ;
   ;  Seaweed tentacle reaching up sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skip this subsection if sound isn't on.
   ;
   if _Ch0_Sound <> _c_Tentacle_Reaching_Up then goto __TS_Skip_Ch0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Title_Seaweed[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __TS_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Title_Seaweed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Title_Seaweed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration= _SD_Title_Seaweed[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __TS_Skip_Ch_0

__TS_Skip_Ch0_Sound_001



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __TS_Skip_Ch_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__TS_Clear_Ch_0

   _Ch0_Duration = 1
   
   _Ch0_Sound = 0 : _Ch0_Counter = 0 : AUDV0 = 0 : _Bit1_Joystick_Restrainer_Tmp{1} = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__TS_Skip_Ch_0



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
   if _Frame_Counter > 9 then _Bit1_Auto_Play{1} = 1 : goto __Main_Loop_Setup

__TS_AP_Skip



   ;***************************************************************
   ;
   ;  Select Switch Check
   ;  
   ;  Switches between right handed and left handed joystick.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if select hasn't been pressed.
   ;
   if !switchselect then _Bit7_Select_Restrainer{7} = 0 : goto __TS_Skip_Select

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if select hasn't been released after
   ;  being pressed.
   ;
   if _Bit7_Select_Restrainer{7} then goto __TS_Skip_Select

   ;```````````````````````````````````````````````````````````````
   ;  Select Pressed Once
   ;
   ;  Flips select bit and jumps to approppriate screen.
   ;  
__Skip_to_Select

   ;```````````````````````````````````````````````````````````````
   ;  Flips right/left bit.
   ;
   _Bit2_Right_Left_Hand{2} = !_Bit2_Right_Left_Hand{2}

   ;```````````````````````````````````````````````````````````````
   ;  Moves objects off the screen.
   ;
   player1y = 200 : missile0y = 200 : bally = 200

   ;```````````````````````````````````````````````````````````````
   ;  Sets colors and clears counter.
   ;
   COLUBK = 0 : _SC_Back = 0 : pfscorecolor = 0 : scorecolor = 0 : _Frame_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Turns on select switch restrainer bit.
   ;
   _Bit7_Select_Restrainer{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears the screen.
   ;
   pfclear

   ;```````````````````````````````````````````````````````````````
   ;  Updates the screen to avoid any screen flipping.
   ;
   drawscreen

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the right handed screen if the bit is on.
   ;
   if _Bit2_Right_Left_Hand{2} then goto __Right_Handed_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the left handed screen if the bit is off.
   ;
   if !_Bit2_Right_Left_Hand{2} then goto __Left_Handed_Setup

__TS_Skip_Select



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
   ;  Reset or Fire pressed appropriately. Turns off auto-play and 
   ;  jumps to main loop setup.
   ;
   _Bit1_Auto_Play{1} = 0 : goto __Main_Loop_Setup





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF TITLE SCREEN LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Right handed setup.  -05-
   ;
   ;
__Right_Handed_Setup

   player0x = 65 : player0y = 50 : _Select_Timer = 0 

   player0:
   %10101010
   %11001010
   %11001110
   %10101010
   %11001010
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Right handed loop.
   ;
   ;
__Right_Handed_Loop



   ;***************************************************************
   ;
   ;  Sets colors and sprite sizes.
   ;
   CTRLPF = $21 : NUSIZ0 = $07 : NUSIZ1 = $07 : REFP0 = 0 : REFP1 = 0 : COLUP0 = $9E : COLUBK = 0



   ;***************************************************************
   ;
   ;  Increases select switch timer.
   ;
   _Select_Timer = _Select_Timer + 1



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Keeps looping until counter reaches 60 frames (one second).
   ;
   if _Select_Timer > 59 then goto __Title_Screen_Playfield



   goto __Right_Handed_Loop





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Left handed setup.  -06-
   ;
   ;
__Left_Handed_Setup

   player0x = 65 : player0y = 50 : _Select_Timer = 0 


   player0:
   %11101010
   %10001010
   %10001110
   %10001010
   %10001010
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Left handed loop.
   ;
   ;
__Left_Handed_Loop



   ;***************************************************************
   ;
   ;  Sets colors and sprite sizes.
   ;
   CTRLPF = $21 : NUSIZ0 = $07 : NUSIZ1 = $07 : REFP0 = 0 : REFP1 = 0 : COLUP0 = $3E : COLUBK = 0



   ;***************************************************************
   ;
   ;  Increases select switch timer.
   ;
   _Select_Timer = _Select_Timer + 1



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Keeps looping until counter reaches 60 frames (one second).
   ;
   if _Select_Timer > 59 then goto __Title_Screen_Playfield



   goto __Left_Handed_Loop





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for title screen.  -07-
   ;
   data _SD_Title_Seaweed
   2,14,5
   1
   14,14,5
   8
   2,14,5
   8

   2,14,3
   1
   14,14,3
   12
   2,14,3
   8

   2,14,4
   1
   14,14,4
   12
   2,14,4
   24
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP PART 1  -08-
   ;
   ;
__Main_Loop_Setup


   ;***************************************************************
   ;
   ;  In the main loop, _Bit0_Game_Control{0} controls when the
   ;  game ends.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0


   ;***************************************************************
   ;
   ; Makes sure player0 and player1 sprites are off the screen.
   ;
   player0y = 200 : player1y = 200


   ;***************************************************************
   ;
   ;  Clears the screen.
   ;
   pfclear


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = $80


   ;***************************************************************
   ;
   ;  Draws the screen.
   ;
   drawscreen


   ;***************************************************************
   ;
   ;  Clears and sets up variables (among other things).
   ;
   gosub __Clear_and_Set


   ;***************************************************************
   ;
   ;  Makes the ball wider.
   ;
   CTRLPF = $21


   ;```````````````````````````````````````````````````````````````
   ;  Sets ball height.
   ;
   ballheight = 0


   ;***************************************************************
   ;
   ;  Sets color behind score.
   ;
   _SC_Back = $C4


   ;***************************************************************
   ;
   ;  Sets up the pfscore bars.
   ;
   pfscore1 = 0 : pfscore2 = 0 : pfscorecolor = $C4


   ;***************************************************************
   ;
   ;  Skips the close in loop if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then _SC_Back = $C4 : goto __Main_Loop_Setup_02


   ;***************************************************************
   ;
   ;  Turns on close in sound effect.
   ;
   _Ch1_Sound = _c_MLS_Seaweed_Close_In


   ;***************************************************************
   ;
   ;  Sets position of ball.
   ;
   ballx = 158 : bally = 87


   ;***************************************************************
   ;
   ;  Sets starting position of player1 sprite.
   ;
   player1x = 1 : player1y = 190


   ;***************************************************************
   ;
   ;  Sets player1 sprite color.
   ;
   player1color:
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
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
   $C6
end


   ;***************************************************************
   ;
   ;  Defines shape of player1 sprite.
   ;
   player1:
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
   %11110000
end


   ;***************************************************************
   ;
   ;  Defines shape of player0 sprite.
   ;
   player0:
   %11111111
   %11111111
   %11111111
end


   ;***************************************************************
   ;
   ;  Sets starting position of player0 sprite.
   ;
   player0x = 144 : player0y = 90





   ;***************************************************************
   ;***************************************************************
   ;
   ;  CLOSE IN LOOP  -09-
   ;
   ;
__Close_In_Loop



   ;***************************************************************
   ;
   ;  Sets colors.
   ;
   scorecolor = $1C : COLUP0 = $80 : COLUBK = $80



   ;***************************************************************
   ;
   ;  Sets missile/sprite width.
   ;
   NUSIZ0 = $17



   ;***************************************************************
   ;
   ;  Closes in the sides.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Raises ball and sprite.
   ;
   if _MLSetup_Tmp_Close_In_Counter < 4 then ballheight = ballheight + 6 : player1y = player1y - 6

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if master counter is less than 15.
   ;
   if _Master_Counter < 15 then goto __Skip_All_Close_In_Counters

   ;```````````````````````````````````````````````````````````````
   ;  Clears master counter and increments close in counter.
   ;
   _Master_Counter = 0 : _MLSetup_Tmp_Close_In_Counter = _MLSetup_Tmp_Close_In_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves ball and sprite to the next x position.
   ;
   player1y = 190 : player1x = player1x + 4 : if ballx > 146 then ballheight = 0 : ballx = ballx - 4

   ;```````````````````````````````````````````````````````````````
   ;  Sets up temp variables and skips ahead if counter = 1.
   ;
   if _MLSetup_Tmp_Close_In_Counter = 1 then _MLSetup_Tmp_Close_In_01 = 16 : _MLSetup_Tmp_Close_In_02 = 16 : goto __Skip_Close_In_Count

   ;```````````````````````````````````````````````````````````````
   ;  Skips calculations if limit is reached.
   ;
   if _MLSetup_Tmp_Close_In_02 >= 240 then goto __Skip_Close_In_Count

   ;```````````````````````````````````````````````````````````````
   ;  Calculations for adding another tentacle to the sides.
   ;
   _MLSetup_Tmp_Close_In_01 = (_MLSetup_Tmp_Close_In_01)*2

   temp5 = _MLSetup_Tmp_Close_In_02

   _MLSetup_Tmp_Close_In_02 = _MLSetup_Tmp_Close_In_01 + temp5

__Skip_Close_In_Count

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect if sides aren't filled up.
   ;
   if _MLSetup_Tmp_Close_In_02 < 240 then _Ch1_Sound = _c_MLS_Seaweed_Close_In : AUDV0 = 0 : _Ch0_Counter = 0 : _MLSet_Tone_Flip_Cntr_Tmp = 0

__Skip_All_Close_In_Counters

   ;```````````````````````````````````````````````````````````````
   ;  Adds seaweed tentacles to the sides of the screen.
   ;
   PF0 = _MLSetup_Tmp_Close_In_02



   ;***************************************************************
   ;
   ;  Sound effects for sides closing in.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound effect isn't turned on.
   ;
   if _Ch1_Sound <> _c_MLS_Seaweed_Close_In then goto __Skip_Close_In_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Sets volume and tone.
   ;
   AUDV0 = 8 : AUDC0 = 8

   ;```````````````````````````````````````````````````````````````
   ;  Increments flip counter.
   ;
   _MLSet_Tone_Flip_Cntr_Tmp = _MLSet_Tone_Flip_Cntr_Tmp + 1

   ;```````````````````````````````````````````````````````````````
   ;  Changes tone if counter value is odd.
   ;
   if _MLSet_Tone_Flip_Cntr_Tmp{0} then AUDC0 = 14

   ;```````````````````````````````````````````````````````````````
   ;  Increments _Ch0_Counter.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns off sound effect if Counter = 31.
   ;
   if _Ch0_Counter = 31 then AUDV0 = 0 : _Ch1_Sound = 0 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Changes sound frequency.
   ;
   AUDF0 = _Ch0_Counter

__Skip_Close_In_Sound



   ;***************************************************************
   ;
   ;  Sets the playfield colors.
   ;
   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end



   ;***************************************************************
   ;
   ;  A fix for the sides closing in.
   ;
   if ballx < 150 then COLUP0 = $C4 



   ;***************************************************************
   ;
   ;  Draws the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Continues loop if close in counter is less than 4.
   ;
   if _MLSetup_Tmp_Close_In_Counter < 4 then goto __Close_In_Loop



   ;***************************************************************
   ;
   ;  Continues loop if _Ch0_Counter is less than 30.
   ;
   if _Ch0_Counter < 30 then goto __Close_In_Loop



   ;***************************************************************
   ;
   ;  Clears and sets up variables (among other things).
   ;
   gosub __Clear_and_Set



   ;***************************************************************
   ;
   ;  Makes sure auto play is turned off.
   ;
   _Bit1_Auto_Play{1} = 0



   ;***************************************************************
   ;
   ; Makes sure player1 sprite is off the screen.
   ;
   player1y = 200



   ;***************************************************************
   ;
   ; Clears player1 sprite.
   ;
   player1:
   %00000000
end



   ;***************************************************************
   ;
   ;  Sets color behind score.
   ;
   _SC_Back = $C8





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP PART 2  -10-
   ;
   ;  Auto-play also jumps here to skip the close in loop.
   ;
   ;
__Main_Loop_Setup_02


   ;***************************************************************
   ;
   ;  Sets the playfield colors.
   ;
   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end


   ;***************************************************************
   ;
   ;  Sets up the pfscore bars.
   ;
   pfscore1 = 255 : pfscore2 = 255 : pfscorecolor = $AE


   ;***************************************************************
   ;
   ;  Puts sprites and missiles behind the playfield pixels
   ;  and makes the ball wider.
   ;
   CTRLPF = $25


   ;***************************************************************
   ;
   ;  Sets starting position of player0 sprite.
   ;
   player0x = 80 : player0y = 0


   ;***************************************************************
   ;
   ;  Turns on important bits.
   ;
   _Bit4_Game_Started{4} = 1 : _Bit1_Ship_Restrainer_D{1} = 1 : _Bit1_FireB_Restrainer{1} = 1 : _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Remembers position of COLOR/BW switch.
   ;
   _Bit0_Pause_Position{0} = 0

   if switchbw then _Bit0_Pause_Position{0} = 1


   ;***************************************************************
   ;
   ;  Turns on Manatee splash in sound effect.
   ;
   _Ch1_Sound = _c_Ship_Drop_In : _Ch1_Counter = 0 : _Ch1_Duration = 1


   ;***************************************************************
   ;
   ;  Auto-play score swap setup.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears score and skips this section if auto play isn't on.
   ;
   if !_Bit1_Auto_Play{1} then score = 0 : goto __AP_Skip_AP_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Sets up the score swap and clears variables/bits.
   ;
   _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3

   _MLSet_Tone_Flip_Cntr_Tmp = 0 : _Bit6_Swap_Scores{6} = 0

__AP_Skip_AP_Setup


   goto __Main_Loop bank2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Clear and Set Subroutine  -11-
   ;
   ;  Clears or sets variables, object locations, colors,
   ;  and so on. Do not clear out _Bit0_Game_Control{0} here. It
   ;  is used to control how the game is reset.
   ;
__Clear_and_Set

   ;```````````````````````````````````````````````````````````````
   ;  Clears most variables (fastest way).
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0

   var4 = 0 : var5 = 0 : var6 = 0 : var7 = 0 : var8 = 0
   var9 = 0 : var10 = 0 : var11 = 0 : var12 = 0 : var13 = 0 : var14 = 0
   var15 = 0 : var16 = 0 : var17 = 0 : var18 = 0 : var19 = 0 : var20 = 0
   var21 = 0 : var22 = 0 : var23 = 0 : var24 = 0 : var25 = 0 : var26 = 0
   var27 = 0 : var28 = 0 : var29 = 0 : var30 = 0 : var31 = 0 : var32 = 0
   var33 = 0 : var34 = 0 : var35 = 0 : var36 = 0 : var37 = 0 : var38 = 0
   var39 = 0 : var40 = 0 : var41 = 0 : var42 = 0 : var43 = 0

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure missile0 and ball are off the screen.
   ;
   missile0y = 200 : bally = 200

   ;```````````````````````````````````````````````````````````````
   ;  Sets missile0 height.
   ;
   missile0height = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sets ball height.
   ;
   ballheight = 100

   ;```````````````````````````````````````````````````````````````
   ;  Sets score color.
   ;
   scorecolor = 28

   ;```````````````````````````````````````````````````````````````
   ;  Mutes volume of both sound channels.
   ;
   AUDV0 = 0 : AUDV1 = 0

   ;```````````````````````````````````````````````````````````````
   ;  _Plop_Rate tells the program how often pixels will appear.
   ;  The range is 0 to 14. Increase the number to increase the
   ;  difficulty.
   ;
   _Plop_Rate = 1 : _Plop_Timer = 1

   return thisbank





   ;***************************************************************
   ;***************************************************************
   ;
   ;  PAUSE SETUP  -12-
   ;
__Pause_Setup


   ;***************************************************************
   ;
   ;  Remembers positions and colors.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Remembers player1 location.
   ;
   _Pause_Mem_Sprite1_UD = _P1_Up_Down
   _Pause_Mem_Sprite1_LR = _P1_Left_Right

   ;```````````````````````````````````````````````````````````````
   ;  Remembers missile0y position.
   ;
   _Pause_Mem_Missile0y = missile0y

   ;```````````````````````````````````````````````````````````````
   ;  Remembers various colors.
   ;
   _Pause_Mem_Health_Color = pfscorecolor
   _Pause_Mem_Score_Color = scorecolor
   _Pause_Mem_SCBack_Color = _SC_Back


   ;***************************************************************
   ;
   ;  Makes sure player1 sprite and missile0 are off the screen.
   ;
   player1y = 200 : missile0y = 250


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
   ;  Selects a random color scheme.
   ;
   temp5 = (rand&7)

   _Pause_Mem_No_Repeat = temp5

   on temp5 gosub __Pause0 __Pause1 __Pause2 __Pause3 __Pause4 __Pause5 __Pause6 __Pause7


   ;***************************************************************
   ;
   ;  Flips player sprite if necessary.
   ;
   if _Bit3_Flip_P0{3} then REFP0 = 8


   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen




   ;***************************************************************
   ;***************************************************************
   ;
   ;  PAUSE LOOP  -13-
   ;
__Pause_Game


   ;***************************************************************
   ;
   ;  Changes color scheme every 4 seconds.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increases the pause counter.
   ;
   _Pause_Counter = _Pause_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if counter isn't high enough.
   ;
   if _Pause_Counter < 240 then goto __Skip_Pause_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Resets the pause counter.
   ;
   _Pause_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Gets a random number from 0 to 7.
   ;
   temp5 = (rand&7)

   ;```````````````````````````````````````````````````````````````
   ;  If the last color scheme used is not the same, skip ahead.
   ;
   if _Pause_Mem_No_Repeat <> temp5 then goto __Skip_Color_Repeat_Check

   ;```````````````````````````````````````````````````````````````
   ;  Changes color since color scheme was the same as last time.
   ;
   temp5 = temp5 + 1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps the color scheme within the 0 to 7 range.
   ;
   if temp5 > 7 then temp5 = 0

__Skip_Color_Repeat_Check

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the latest color scheme.
   ;
   _Pause_Mem_No_Repeat = temp5

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the latest color scheme and comes back.
   ;
   on temp5 gosub __Pause0 __Pause1 __Pause2 __Pause3 __Pause4 __Pause5 __Pause6 __Pause7


__Skip_Pause_Counter



   ;***************************************************************
   ;
   ;  Flips player sprite if necessary.
   ;
   if _Bit3_Flip_P0{3} then REFP0 = 8



   ;***************************************************************
   ;
   ;  Pause color of player sprite.
   ;
   COLUP0 = _Pause_Mem_Sprite0_Color



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
   _Bit0_Pause_Position{0} = 0 : if switchbw then _Bit0_Pause_Position{0} = 1





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
   ;  Restores background color and player0 color.
   ;
   COLUBK = $80 : COLUP0 = $0A


   ;***************************************************************
   ;
   ;  Restores positions and colors.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Restores player1 location.
   ;
   _P1_Up_Down = _Pause_Mem_Sprite1_UD
   _P1_Left_Right = _Pause_Mem_Sprite1_LR

   ;```````````````````````````````````````````````````````````````
   ;  Restores missile0y position.
   ;
   missile0y = _Pause_Mem_Missile0y

   ;```````````````````````````````````````````````````````````````
   ;  Restores various colors.
   ;
   pfscorecolor = _Pause_Mem_Health_Color
   scorecolor = _Pause_Mem_Score_Color
   _SC_Back = _Pause_Mem_SCBack_Color


   ;***************************************************************
   ;
   ;  Restores playfield colors.
   ;
   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end


   goto __Main_Loop bank2





   ;***************************************************************
   ;
   ;  Sets pause colors to yellow.
   ;
__Pause0

   pfcolors:
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
   $1A
end

   _Pause_Mem_Sprite0_Color = $1C

   COLUBK = $1A

   scorecolor = $1C

   pfscorecolor = $1A

   _SC_Back = $1A

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to reddish-orange.
   ;
__Pause1

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

   _Pause_Mem_Sprite0_Color = $3C

   COLUBK = $3A

   scorecolor = $3C

   pfscorecolor = $3A

   _SC_Back = $3A

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to purple.
   ;
__Pause2

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

   _Pause_Mem_Sprite0_Color = $6C

   COLUBK = $6A

   scorecolor = $6C

   pfscorecolor = $6A

   _SC_Back = $6A

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to blue.
   ;
__Pause3

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

   _Pause_Mem_Sprite0_Color = $9C

   COLUBK = $9A

   scorecolor = $9C

   pfscorecolor = $9A

   _SC_Back = $9A

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to green.
   ;
__Pause4

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

   _Pause_Mem_Sprite0_Color = $CC

   COLUBK = $CA

   scorecolor = $CC

   pfscorecolor = $CA

   _SC_Back = $CA

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to yellowish.
   ;
__Pause5

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

   _Pause_Mem_Sprite0_Color = $FC

   COLUBK = $FA

   scorecolor = $FC

   pfscorecolor = $FA

   _SC_Back = $FA

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to darkish-blue.
   ;
__Pause6

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

   _Pause_Mem_Sprite0_Color = $8C

   COLUBK = $8A

   scorecolor = $8C

   pfscorecolor = $8A

   _SC_Back = $8A

   return thisbank



   ;***************************************************************
   ;
   ;  Sets pause colors to orange-brown.
   ;
__Pause7

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

   _Pause_Mem_Sprite0_Color = $2C

   COLUBK = $2A

   scorecolor = $2C

   pfscorecolor = $2A

   _SC_Back = $2A

   return thisbank





   ;
   ; Bank 2  -14- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 2
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP  -15-
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Main counters.
   ;
   ;  Controls animation speed and other things.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if master counter is less than 7.
   ;
   if _Master_Counter < 7 then goto __Skip_Frame_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Increments frame counter.
   ;
   _Frame_Counter = _Frame_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Increments tentacle counter.
   ;
   _Tentacle_Grab_Counter = _Tentacle_Grab_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Increments corroded canister counter.
   ;
   _Corrdd_App_Counter = _Corrdd_App_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Increments level counter.
   ;
   _Level_Counter = _Level_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears master counter.
   ;
   _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears frame counter and increments Wrothopod counter if
   ;  frame counter = 4.
   ;
   if _Frame_Counter = 4 then _Frame_Counter = 0 : _Wrothopod_Counter = _Wrothopod_Counter + 1

__Skip_Frame_Counter





   ;***************************************************************
   ;
   ;  Manatee splash in.
   ;
   ;  Moves Manatee down for a while if game just started.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if game started bit is off.
   ;
   if !_Bit4_Game_Started{4} then goto __Skip_Game_Started

   ;```````````````````````````````````````````````````````````````
   ;  Clears game started bit if Manatee moves down far enough.
   ;
   if player0y > 35 then _Bit4_Game_Started{4} = 0

   goto __GoD

__Skip_Game_Started




   ;***************************************************************
   ;
   ;  Advanced joystick reading.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Looks at the joystick.
   ;
   temp5 = SWCHA/16

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if auto-play is off.
   ;
   if !_Bit1_Auto_Play{1} then goto __AP_Skip_Joy

   ;```````````````````````````````````````````````````````````````
   ;  Checks select switch if auto-play is on.
   ;
   if switchselect then _sc1=_Score1_Mem : _sc2=_Score2_Mem : _sc3=_Score3_Mem : goto __Skip_to_Select bank1

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 255).
   ;
   temp5 = rand

   ;```````````````````````````````````````````````````````````````
   ;  Gets a random ship direction if conditions are right.
   ;
   if _Frame_Counter = 0 && temp5 > 220 then _ML_Tmp_AP_Ship_Dir = (rand&15)

   ;```````````````````````````````````````````````````````````````
   ;  Ship goes up or right if it is low on the screen.
   ;
   if player0y > 80 then _ML_Tmp_AP_Ship_Dir = 14 : temp6 = rand : if temp6 > 128 then _ML_Tmp_AP_Ship_Dir = 7

   ;```````````````````````````````````````````````````````````````
   ;  Ship goes down or down/left if it is near top of screen.
   ;
   if player0y < 15 then _ML_Tmp_AP_Ship_Dir = 13 : temp6 = rand : if temp6 > 128 then _ML_Tmp_AP_Ship_Dir = 9

   ;```````````````````````````````````````````````````````````````
   ;  Ship goes left or down/left if it is on right side.
   ;
   if player0x > 130 then _ML_Tmp_AP_Ship_Dir = 11 : temp6 = rand : if temp6 > 128 then _ML_Tmp_AP_Ship_Dir = 9

   ;```````````````````````````````````````````````````````````````
   ;  Ship goes right or down/right if it is on left side.
   ;
   if player0x < 22 then _ML_Tmp_AP_Ship_Dir = 7 : temp6 = rand : if temp6 > 128 then _ML_Tmp_AP_Ship_Dir = 5

   ;```````````````````````````````````````````````````````````````
   ;  Gets the auto-play ship direction.
   ;
   temp5 = _ML_Tmp_AP_Ship_Dir

__AP_Skip_Joy



   ;***************************************************************
   ;
   ;  Right/Left handed joystick handling.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check. Jumps to right handed movement if on.
   ;
   if _Bit1_Auto_Play{1} then goto __AP_Joystick

   ;```````````````````````````````````````````````````````````````
   ;  Skips right handed movement if left handed has been chosen.
   ;  1 = Right hand. 0 = Left hand.
   ;
   if !_Bit2_Right_Left_Hand{2} then goto __Skip_Right_Hand

__AP_Joystick

   ;```````````````````````````````````````````````````````````````
   ;  Right handed ship movement.
   ;                 0       1       2      3        4      5      6      7     8       9     10     11     12     13    14     15
   on temp5 goto __Slide __Slide __Slide __Slide __Slide __GoDR __GoUR __GoR __Slide __GoDL __GoUL __GoL __Slide __GoD __GoU __Slide

__Skip_Right_Hand

   ;```````````````````````````````````````````````````````````````
   ;  Skips left handed movement if right handed has been chosen.
   ;
   if _Bit2_Right_Left_Hand{2} then goto __Skip_Left_Hand

   ;```````````````````````````````````````````````````````````````
   ;  Left handed ship movement.
   ;                 0       1       2       3       4      5      6      7     8       9      10     11    12     13    14     15
   on temp5 goto __Slide __Slide __Slide __Slide __Slide __GoDL __GoDR __GoD __Slide __GoUL __GoUR __GoU __Slide __GoL __GoR __Slide

__Skip_Left_Hand




   ;***************************************************************
   ;
   ;  Fake gravity slide.
   ;
   ;  This is a simplistic cheat that does not use complicated
   ;  calculations.
   ;
__Slide

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if it's not time to slide.
   ;
   if !_Slide_Speed then goto __Done_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Increments the slide counter.
   ;
   _Slide_Counter = _Slide_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if slide counter doesn't match speed.
   ;
   if _Slide_Counter < _Slide_Speed then goto __Done_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Speed becomes slower each time it loops back around.
   ;
   _Slide_Speed = _Slide_Speed * 2

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if ship isn't yanked down.
   ;
   if !_Bit3_Ship_Yanked_Down{3} then goto __Skip_Grab_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Sets up ship grab and yank down.
   ;
   _Bit4_Ship_U_Slide{4} = 0 : _Bit5_Ship_D_Slide{5} = 1

   _Bit6_Ship_L_Slide{6} = 0 : _Bit7_Ship_R_Slide{7} = 0

   goto __Skip_Normal_Slide_Setup

__Skip_Grab_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Reverse Bounce Slide Setup
   ;
   ;  Skips ahead if Manatee didn't hit seaweed.
   ;
   if !_Bit1_P0_Hit_Seaweed{1} then goto __Skip_Reverse_Bounce_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Sets up a backwards slide from a bounce.
   ;
   _Bit4_Ship_U_Slide{4} = !_Bit0_Ship_Facing_Up{0} : _Bit5_Ship_D_Slide{5} = !_Bit1_Ship_Facing_Down{1}

   _Bit6_Ship_L_Slide{6} = !_Bit2_Ship_Facing_Left{2} : _Bit7_Ship_R_Slide{7} = !_Bit3_Ship_Facing_Right{3}

   goto __Skip_Normal_Slide_Setup

__Skip_Reverse_Bounce_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Normal Slide Setup
   ;
   ;  Sets up a normal slide.
   ;
   _Bit4_Ship_U_Slide{4} = _Bit0_Ship_Facing_Up{0} : _Bit5_Ship_D_Slide{5} = _Bit1_Ship_Facing_Down{1}
   _Bit6_Ship_L_Slide{6} = _Bit2_Ship_Facing_Left{2} : _Bit7_Ship_R_Slide{7} = _Bit3_Ship_Facing_Right{3}

__Skip_Normal_Slide_Setup

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  
   ;  Ship Slide
   ;
   ;  Slides player0 if not hitting the border.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   if _Bit4_Ship_U_Slide{4} && _P0_Up_Down > 10 then _P0_Up_Down=_P0_Up_Down - 1.02

   if _Bit5_Ship_D_Slide{5} && _P0_Up_Down < 84 then _P0_Up_Down=_P0_Up_Down + 1.02

   if _Bit6_Ship_L_Slide{6} && _P0_Left_Right > 18 then _P0_Left_Right=_P0_Left_Right - 1.02

   if _Bit7_Ship_R_Slide{7} && _P0_Left_Right < 137 then _P0_Left_Right=_P0_Left_Right + 1.02

   ;```````````````````````````````````````````````````````````````
   ;  Stops sliding If the slowest speed is reached.
   ;
   if _Slide_Speed = 128 then _Slide_Speed = 0 : _Bit1_P0_Hit_Seaweed{1} = 0 : _Bit3_Ship_Yanked_Down{3} = 0

   goto __Done_Slide

__Done_Joystick0



   ;***************************************************************
   ;
   ;  Setup for Fake Gravity Slide
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears and sets up variables.
   ;
   _Slide_Counter = 0 : _Bit1_P0_Hit_Seaweed{1} = 0

   _Slide_Speed = 1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps player from pushing up or down to be safe.
   ;
   if _Bit0_Ship_Restrainer_U{0} && _P0_Up_Down < 11 then goto __Done_Slide

   if _Bit1_Ship_Restrainer_D{1} && _P0_Up_Down > 85 then goto __Done_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Ship moved up or down.
   ;
   ;  Does not clear the tentacle-related variables if the
   ;  tentacle is on the screen and ship moves up or down (keeps
   ;  the tentacle coming).
   ; 
   if !_Bit2_Move_Tentacle_Up{2} then goto __Skip_Up_Down_Check

   if _Bit0_Ship_Restrainer_U{0} || _Bit1_Ship_Restrainer_D{1} then goto __Done_Slide

__Skip_Up_Down_Check

   ;```````````````````````````````````````````````````````````````
   ;  Ship Moved Left, Right, or Diagonally
   ;
   ;  Clears tentacle-related variables.
   ;
   if !_Bit2_Move_Tentacle_Up{2} then _Tentacle_Grab_Counter = 0 : _Bit2_Move_Tentacle_Up{2} = 0 : _Bit3_Ship_Yanked_Down{3} = 0 : goto __Skip_Tentacle_LR_Check

   _Bit6_Manatee_Moved_Away{6} = 1

__Skip_Tentacle_LR_Check

__Done_Slide



   ;***************************************************************
   ;
   ;  Flips player sprite if necessary.
   ;
   if _Bit3_Flip_P0{3} then REFP0 = 8



   ;***************************************************************
   ;
   ;  Wrothopod Animation
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if Wrothopod bit is off.
   ;
   if !_Bit1_Wrothopod_On{1} then goto __Done_Enemy_Anim

   ;```````````````````````````````````````````````````````````````
   ;  Grabs the correct animation frame.
   ;
   on _Frame_Counter goto __P1_Plain __P1_Move01 __P1_Move02 __P1_Move01

__Done_Enemy_Anim



   ;***************************************************************
   ;
   ;  Fire button.
   ;
   ;  Shoots torpedo when fire button is pressed.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check.
   ;
   if !_Bit1_Auto_Play{1} then goto __AP_Skip_Fire_Torpedo

   ;```````````````````````````````````````````````````````````````
   ;  Determines if Manatee should fire during auto-play.
   ;
   temp5 = rand : if temp5 > 20 then goto __Done_Fire

   goto __AP_Fire

__AP_Skip_Fire_Torpedo

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the fire button is not pressed.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Done_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the fire button hasn't been released
   ;  since starting the game.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Done_Fire

__AP_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the torpedo is moving.
   ;
   if _Bit0_Shot_Moving{0} then goto __Done_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on shot moving bit and sets shot bonus counter.
   ;
   _Bit0_Shot_Moving{0} = 1 : _Shot_Bonus_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears bonus limit bit.
   ;
   _Bit2_Bonus_Limit{2} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Tells the torpedo where to start.
   ;
   if _Bit0_Ship_Restrainer_U{0} then temp5 = 4 : temp6 = 250
   if _Bit1_Ship_Restrainer_D{1} then temp5 = 4 : temp6 = 255
   if _Bit2_Ship_Restrainer_L{2} then temp5 = 1 : temp6 = 252
   if _Bit3_Ship_Restrainer_R{3} then temp5 = 7 : temp6 = 252
   if _Bit4_Ship_Restrainer_UL{4} then temp5 = 1 : temp6 = 250
   if _Bit5_Ship_Restrainer_UR{5} then temp5 = 7 : temp6 = 250
   if _Bit6_Ship_Restrainer_DL{6} then temp5 = 1 : temp6 = 255
   if _Bit7_Ship_Restrainer_DR{7} then temp5 = 7 : temp6 = 255

   missile0x = player0x + temp5 : missile0y = player0y + temp6

   ;```````````````````````````````````````````````````````````````
   ;  Makes a snapshot of the ship direction so the torpedo will
   ;  stay on track until it hits something.
   ;
   _Bit4_Shot_U_Snapshot{4} = _Bit0_Ship_Facing_Up{0}
   _Bit5_Shot_D_Snapshot{5} = _Bit1_Ship_Facing_Down{1}
   _Bit6_Shot_L_Snapshot{6} = _Bit2_Ship_Facing_Left{2}
   _Bit7_Shot_R_Snapshot{7} = _Bit3_Ship_Facing_Right{3}

   ;```````````````````````````````````````````````````````````````
   ;  Starts torpedo fire sound effect (channel 0).
   ;
   if _Ch0_Sound = _c_Ship_Bounce then goto __Done_Fire

   if _Ch0_Sound = _c_1000_Health then goto __Done_Fire

   _Ch0_Counter = 0 : _Ch0_Sound = _c_Shoot : _Ch0_Duration = 1

__Done_Fire



   ;***************************************************************
   ;
   ;  Makes sure that vblank code only runs using the drawscreen
   ;  below in this main loop. Thanks to the bit below, the vblank
   ;  code will not run when any other drawscreens are used.
   ;
   _Bit7_Vblank01{7} = 1



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Clears the Corroded Canister seaweed shot bit.
   ;
   _Bit4_Corrdd_Can_Swd_Shot{4} = 0



   ;***************************************************************
   ;
   ;  Missile/playfield collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if there is no collision between missile0
   ;  and playfield.
   ;
   if !collision(playfield,missile0) then goto __Skip_Missl_Pixl_Collisn

   ;```````````````````````````````````````````````````````````````
   ;  Converts missile coordinates to playfield coordinates. 
   ;
   temp5 = (missile0x-17)/4 : temp6 = (missile0y)/8

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if missile is not in the playfield area. 
   ;
   if temp5 > 31 then goto __Skip_Missl_Pixl_Collisn

   if temp6 > 10 then goto __Skip_Missl_Pixl_Collisn

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if a playfield pixel is not there. 
   ;
   if !pfread(temp5,temp6) then goto __Skip_Missl_Pixl_Collisn

   ;```````````````````````````````````````````````````````````````
   ;  Deletes the playfield pixel.
   ;
   pfpixel temp5 temp6 off

   ;```````````````````````````````````````````````````````````````
   ;  Skips the points area if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __AP_Skip_Points

   ;```````````````````````````````````````````````````````````````
   ;  Adds to the bonus counter if limit has not been reached.
   ;
   if !_Bit2_Bonus_Limit{2} then _Shot_Bonus_Counter = _Shot_Bonus_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the bonus limit bit if the limit has been reached.
   ;
   if _Shot_Bonus_Counter > 10 then _Shot_Bonus_Counter = 10 : _Bit2_Bonus_Limit{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Adds to the points roll up variable for adding to the score.
   ;
   _Points_Roll_Up = _Points_Roll_Up + _Shot_Bonus_Counter

__AP_Skip_Points

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the spot where the last piece of seaweed was shot
   ;  in case it's time for a corroded canister to appear there.
   ;
   if !_Bit4_Corrdd_Can_Swd_Shot{4} && !_Bit2_Corrdd_Can_On{2} then _Corrdd_X_Shot_Mem = temp5 : _Corrdd_Y_Shot_Mem = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Adds to the seaweed shot counter.
   ;
   _Seaweed_Shot = _Seaweed_Shot + 1

   ;```````````````````````````````````````````````````````````````
   ;  Adds to the corroded canister shot counter (a certain amount
   ;  of seaweed has to be shot before the corroded canister can
   ;  appear).
   ;
   _Corrdd_Shot_Counter = _Corrdd_Shot_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the corroded canister seaweed shot bit.
   ;
   _Bit4_Corrdd_Can_Swd_Shot{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the second vblank section.
   ;
   _Bit7_Vblank02{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips sound effect setup if certain sounds are playing.
   ;
   if _Ch0_Sound = _c_Ship_Bounce then goto __Skip_Missl_Pixl_Collisn

   if _Ch0_Sound = _c_1000_Health then goto __Skip_Missl_Pixl_Collisn

   ;```````````````````````````````````````````````````````````````
   ;  Starts torpedo hit seaweed sound effect (channel 0). 
   ;
   _Ch0_Sound = 0 : _Ch0_Counter = 0

   _Ch0_Duration = 1

   ;```````````````````````````````````````````````````````````````
   ;  Flips alternative torpedo hitting seaweed sound bit.
   ;
   _Bit5_Sound_Alt_Torpedo_Hit{5} = !_Bit5_Sound_Alt_Torpedo_Hit{5}

   ;```````````````````````````````````````````````````````````````
   ;  Plays a different sound depending on bit.
   ;
   if _Bit5_Sound_Alt_Torpedo_Hit{5} then _Ch0_Sound = _c_Torp_Hit_Seaweed_01 : goto __Skip_Missl_Pixl_Collisn

   if !_Bit5_Sound_Alt_Torpedo_Hit{5} then _Ch0_Sound = _c_Torp_Hit_Seaweed_02

__Skip_Missl_Pixl_Collisn



   ;***************************************************************
   ;
   ;  Auto-play score flipper.
   ;
   ;  Flips between high score and current score.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto-play bit is not on.
   ;
   if !_Bit1_Auto_Play{1} then goto __AP_Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  Increments the auto play 2-second counter.
   ;
   _AP_2_Sec_Score_Flip = _AP_2_Sec_Score_Flip + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto play 2-second counter is less
   ;  than 2 seconds (120 = 2 seconds).
   ;
   if _AP_2_Sec_Score_Flip < 120 then goto __AP_Skip_Score

   ;```````````````````````````````````````````````````````````````
   ;  Clears the 2-second counter and flips the score swapping bit.
   ;
   _AP_2_Sec_Score_Flip = 0 : _Bit6_Swap_Scores{6} = !_Bit6_Swap_Scores{6}

   ;```````````````````````````````````````````````````````````````
   ;  Skips high score swap if swap bit is off.
   ;
   if !_Bit6_Swap_Scores{6} then goto __AP_Skip_HiScore_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays high score (blue-green).
   ;
   scorecolor = $BE

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __AP_Skip_Score

__AP_Skip_HiScore_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (yellow).
   ;
   scorecolor = $1C

   _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem
   
   goto __AP_Skip_Score

__AP_Skip_Flip



   ;***************************************************************
   ;
   ;  Score section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Remembers thousands digit for bonus (part 1 of 2).
   ;
   ;  Saves the thousands digit without the hundreds digit.
   ;
   temp5 = (_sc2 & $F0)

   ;```````````````````````````````````````````````````````````````
   ;  Adds points to the score.
   ;
   ;  Points roll up code from Nukey Shay. 
   ;
   asm
   lda  _Points_Roll_Up
   beq  __No_Points_To_Add
   dec  _Points_Roll_Up
   sed
   clc
   lda  _sc3
   adc  #1
   sta  _sc3
   lda  _sc2
   adc  #0
   sta  _sc2
   lda  _sc1
   adc  #0
   sta  _sc1
   cld
__No_Points_To_Add:
end

   ;```````````````````````````````````````````````````````````````
   ;  Checks thousands digit for bonus (part 2 of 2).
   ;
   ;  Grabs the thousands digit.
   ;
   temp6 = (_sc2 & $F0)

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if thousands digit has NOT changed.
   ;
   if temp5 = temp6 then goto __Skip_Thousand_Test

   ;```````````````````````````````````````````````````````````````
   ;  Turns on thousand bonus bit and clears counter.
   ;
   _Bit2_1000_On{2} = 1 : _1000_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Sets up the pfscore bars.
   ;
   pfscore1 = 255 : pfscore2 = 255 : pfscorecolor = $AE

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the Manatee health color cycle bit (bluish flash).
   ;
   _Bit5_Manatee_Health_Color{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  _Bit0_Game_Control{0} controls when the game ends.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Turns on sound effect.
   ;
   _Ch0_Counter = 0 : _Ch0_Sound = _c_1000_Health : _Ch0_Duration = 1

__Skip_Thousand_Test

__AP_Skip_Score



   ;***************************************************************
   ;
   ;  Player/playfield collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if collision already happened (keeps 
   ;  from draining too much energy).
   ;
   if _Bit1_P0_Hit_Seaweed{1} then goto __Skip_Player0_Pixel_Hit

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if no collision.
   ;
   if !collision(playfield,player0) then goto __Skip_Player0_Pixel_Hit

   ;```````````````````````````````````````````````````````````````
   ;  Bounces ship back after hitting a playfield pixel.
   ;
   if !_Bit0_Ship_Facing_Up{0} then if _P0_Up_Down > 11 then _P0_Up_Down=_P0_Up_Down - 2.02

   if !_Bit1_Ship_Facing_Down{1} then if _P0_Up_Down < 83 then _P0_Up_Down=_P0_Up_Down + 2.02

   if !_Bit2_Ship_Facing_Left{2} then if _P0_Left_Right > 19 then _P0_Left_Right=_P0_Left_Right - 2.02

   if !_Bit3_Ship_Facing_Right{3} then if _P0_Left_Right < 136 then _P0_Left_Right=_P0_Left_Right + 2.02

   ;```````````````````````````````````````````````````````````````
   ;  Decreases health.
   ;
   if pfscore1 = 0 then pfscore2 = pfscore2/2

   if pfscore1 > 0 && pfscore2 = 255 then pfscore1 = pfscore1/2

   ;```````````````````````````````````````````````````````````````
   ;  Sets related bits.
   ;
   _Bit1_P0_Hit_Seaweed{1} = 1 : _Bit4_Manatee_Hurt_Color{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Changes health bar color when needed or ends the game.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   if pfscore2 < 16 then pfscorecolor = $1C

   if pfscore2 < 3 then pfscorecolor = $42

   if pfscore2 < 1 then _Bit0_Game_Control{0} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Starts player collision (bounce) sound effect. 
   ;
   if _Ch0_Sound = _c_1000_Health then goto __Skip_Ouch_Sound_02

   _Ch0_Sound = _c_Ship_Bounce : _Ch0_Counter = 0 : _Ch0_Duration = 1

__Skip_Ouch_Sound_02

__Skip_Player0_Pixel_Hit



   ;***************************************************************
   ;
   ;  Code continues in next bank.
   ;
   goto __Code_Section_2 bank3





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  End of first section of main loop.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Player Movement Routines  -16-
   ;
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Up joystick direction.
   ;
__GoU

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit0_Ship_Restrainer_U{0} && _Bit1_P0_Hit_Seaweed{1} then if _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down > 10 then _P0_Up_Down = _P0_Up_Down - 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after the
   ;  ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00000001
   _Bitop_Ship_Restrainer = 0 : _Bit0_Ship_Restrainer_U{0} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is not reflected. 
   ;
   _Bit3_Flip_P0{3} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame.
   ;
   on _Frame_Counter goto __P0_U_00 __P0_U_01 __P0_U_02 __P0_U_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Down joystick direction.
   ;
__GoD

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit1_Ship_Restrainer_D{1} && _Bit1_P0_Hit_Seaweed{1} && _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down < 86 then _P0_Up_Down = _P0_Up_Down + 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00000010
   _Bitop_Ship_Restrainer = 0 : _Bit1_Ship_Restrainer_D{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is not reflected. 
   ;
   _Bit3_Flip_P0{3} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame.
   ;
   on _Frame_Counter goto __P0_D_00 __P0_D_01 __P0_D_02 __P0_D_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Joystick direction: Left.
   ;
__GoL

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit2_Ship_Restrainer_L{2} && _Bit1_P0_Hit_Seaweed{1} && _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Left_Right > 16 then _P0_Left_Right = _P0_Left_Right - 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00000100
   _Bitop_Ship_Restrainer = 0 : _Bit2_Ship_Restrainer_L{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is not reflected. 
   ;
   _Bit3_Flip_P0{3} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame.
   ;
   on _Frame_Counter goto __P0_L_00 __P0_L_01 __P0_L_02 __P0_L_03

   
   
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Joystick direction: Right.
   ;
__GoR

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit3_Ship_Restrainer_R{3} && _Bit1_P0_Hit_Seaweed{1} && _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Left_Right < 138 then _P0_Left_Right=_P0_Left_Right+1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00001000
   _Bitop_Ship_Restrainer = 0 : _Bit3_Ship_Restrainer_R{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is reflected. 
   ;
   _Bit3_Flip_P0{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame (shared with __GoL).
   ;
   on _Frame_Counter goto __P0_L_00 __P0_L_01 __P0_L_02 __P0_L_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Up-Left joystick direction.
   ;
__GoUL

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit4_Ship_Restrainer_UL{4} && _Bit1_P0_Hit_Seaweed{1} then if _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down > 10 then _P0_Up_Down = _P0_Up_Down - 1.42
   if _P0_Left_Right > 2 then _P0_Left_Right = _P0_Left_Right - 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00000101
   _Bitop_Ship_Restrainer = 0 : _Bit4_Ship_Restrainer_UL{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is not reflected. 
   ;
   _Bit3_Flip_P0{3} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame.
   ;
   on _Frame_Counter goto __P0_UL_00 __P0_UL_01 __P0_UL_02 __P0_UL_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Up-Right joystick direction.
   ;
__GoUR

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit5_Ship_Restrainer_UR{5} && _Bit1_P0_Hit_Seaweed{1} then if _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down > 10 then _P0_Up_Down = _P0_Up_Down - 1.42

   if _P0_Left_Right < 152 then _P0_Left_Right = _P0_Left_Right + 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00001001
   _Bitop_Ship_Restrainer = 0 : _Bit5_Ship_Restrainer_UR{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is reflected. 
   ;
   _Bit3_Flip_P0{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame (shared with __GoUL).
   ;
   on _Frame_Counter goto __P0_UL_00 __P0_UL_01 __P0_UL_02 __P0_UL_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Down-Left joystick direction.
   ;
__GoDL

   ;```````````````````````````````````````````````````````````````
   ;  Keep sliding if player tries to push into the same pfpixel.
   ;
   if _Bit6_Ship_Restrainer_DL{6} && _Bit1_P0_Hit_Seaweed{1} then if _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down < 86  then _P0_Up_Down = _P0_Up_Down + 1.42
   if _P0_Left_Right > 2 then _P0_Left_Right = _P0_Left_Right - 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00000110
   _Bitop_Ship_Restrainer = 0 : _Bit6_Ship_Restrainer_DL{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is not reflected. 
   ;
   _Bit3_Flip_P0{3} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame.
   ;
   on _Frame_Counter goto __P0_DL_00 __P0_DL_01 __P0_DL_02 __P0_DL_03



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Joystick direction: Down-Right.
   ;
__GoDR

   ;```````````````````````````````````````````````````````````````
   ;  Keeps sliding if player tries to push into the same pfpixel.
   ;
   if _Bit7_Ship_Restrainer_DR{7} && _Bit1_P0_Hit_Seaweed{1} then if _Slide_Speed > 0 then goto __Slide

   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 if not hitting the border. 
   ;
   if _P0_Up_Down < 86  then _P0_Up_Down = _P0_Up_Down + 1.42
   if _P0_Left_Right < 152 then _P0_Left_Right = _P0_Left_Right + 1.42

   ;```````````````````````````````````````````````````````````````
   ;  Tells the program which direction the ship is pointing.
   ;  Also keeps the player from pushing ahead after
   ;  the ship bangs into something.
   ;
   _BitOp_Ship = 0 : _BitOp_Ship = _BitOp_Ship | %00001010
   _Bitop_Ship_Restrainer = 0 : _Bit7_Ship_Restrainer_DR{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sprite is reflected. 
   ;
   _Bit3_Flip_P0{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the next animation frame (shared with __GoDL).
   ;
   on _Frame_Counter goto __P0_DL_00 __P0_DL_01 __P0_DL_02 __P0_DL_03





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Animation frames for Manatee.  -17-
   ;
__P0_U_00
   player0:
   %01011010
   %01100110
   %00111100
   %01111110
   %11111111
   %00011000
   %00011000
   %00011000
end
   goto __Done_Joystick0


__P0_U_01
   player0:
   %01100110
   %01000010
   %10111101
   %01111110
   %11111111
   %00011000
   %00011000
   %00011000
end
   goto __Done_Joystick0


__P0_U_02
   player0:
   %01000010
   %11000011
   %10111101
   %01111110
   %11111111
   %00011000
   %00011000
   %00011000
end
   goto __Done_Joystick0


__P0_U_03
   player0:
   %11100111
   %11000011
   %10111101
   %01111110
   %11111111
   %00011000
   %00011000
   %00011000
end
   goto __Done_Joystick0


__P0_D_00
   player0:
   %00011000
   %00011000
   %00011000
   %11111111
   %01111110
   %00111100
   %01100110
   %01011010
end
   goto __Done_Joystick0


__P0_D_01
   player0:
   %00011000
   %00011000
   %00011000
   %11111111
   %01111110
   %10111101
   %01000010
   %01100110
end
   goto __Done_Joystick0


__P0_D_02
   player0:
   %00011000
   %00011000
   %00011000
   %11111111
   %01111110
   %10111101
   %11000011
   %01000010
end
   goto __Done_Joystick0


__P0_D_03
   player0:
   %00011000
   %00011000
   %00011000
   %11111111
   %01111110
   %10111101
   %11000011
   %11100111
end
   goto __Done_Joystick0


__P0_L_00
   player0:
   %00010000
   %00011011
   %00011110
   %11111101
   %11111101
   %00011110
   %00011011
   %00010000
end
   goto __Done_Joystick0


__P0_L_01
   player0:
   %00010100
   %00011011
   %00011101
   %11111100
   %11111100
   %00011101
   %00011011
   %00010100
end
   goto __Done_Joystick0


__P0_L_02
   player0:
   %00010110
   %00011011
   %00011100
   %11111100
   %11111100
   %00011100
   %00011011
   %00010110
end
   goto __Done_Joystick0


__P0_L_03
   player0:
   %00010111
   %00011011
   %00011101
   %11111100
   %11111100
   %00011101
   %00011011
   %00010111
end
   goto __Done_Joystick0


__P0_UL_00
   player0:
   %00001000
   %10010010
   %11111000
   %01111101
   %00111110
   %01111100
   %11101100
   %11000110
end
   goto __Done_Joystick0


__P0_UL_01
   player0:
   %00001100
   %11010000
   %11111001
   %01111101
   %00111110
   %01111110
   %11101100
   %11000110
end
   goto __Done_Joystick0


__P0_UL_02
   player0:
   %00101000
   %11010000
   %11111000
   %01111101
   %00111110
   %01111111
   %11101100
   %11000110
end
   goto __Done_Joystick0


__P0_UL_03
   player0:
   %00111100
   %11110000
   %11111001
   %01111101
   %00111111
   %01111111
   %11101100
   %11000110
end
   goto __Done_Joystick0


__P0_DL_00
   player0:
   %11000110
   %11101100
   %01111100
   %00111110
   %01111101
   %11111000
   %10010010
   %00001000
end
   goto __Done_Joystick0


__P0_DL_01
   player0:
   %11000110
   %11101100
   %01111110
   %00111110
   %01111101
   %11111001
   %11010000
   %00001100
end
   goto __Done_Joystick0


__P0_DL_02
   player0:
   %11000110
   %11101100
   %01111111
   %00111110
   %01111101
   %11111000
   %11010000
   %00101000
end
   goto __Done_Joystick0


__P0_DL_03
   player0:
   %11000110
   %11101100
   %01111111
   %00111111
   %01111101
   %11111001
   %11110000
   %00111100
end
   goto __Done_Joystick0





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Animation frames for Wrothopod.  -18-
   ;
__P1_Plain
   player1:
   %11111111
   %11111111
   %00111100
   %01111110
   %11111111
   %10111101
   %10100101
   %10100101
end
   _Bit2_Wroth_Flip{2}= !_Bit2_Wroth_Flip{2}

   goto __Done_Enemy_Anim


__P1_Move01
   player1:
   %11111111
   %11111111
   %00111100
   %01111110
   %11111111
   %10111101
   %10100101
   %01010101
end
   goto __Done_Enemy_Anim


__P1_Move02

   player1:
   %11111111
   %11111111
   %00111100
   %01111110
   %11111111
   %10111101
   %01010101
   %00101101
end

   goto __Done_Enemy_Anim





   ; Bank 3  -19- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 3
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Second section of main loop.  -20-
   ;
__Code_Section_2



   ;***************************************************************
   ;
   ;  Checks for 100th shot for canister drop.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If auto-play is on and 5 pieces of seaweed have been shot,
   ;  health canister is turned on.
   ;  
   if _Bit1_Auto_Play{1} then if _Seaweed_Shot > 4 then goto __AP_Canister_Appearance

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __Skip_100_Shot

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if 100 bits of seaweed have not been shot.
   ;
   if _Seaweed_Shot < 100 then goto __Skip_100_Shot

__AP_Canister_Appearance

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if seaweed replication counter value is odd.
   ;
   if _Plop_Rate{0} then goto __Canister_is_Odd

   ;```````````````````````````````````````````````````````````````
   ;  Seaweed replication counter value is even. Grabs a random
   ;  number from 0 to 15.
   ;
   temp5 = (rand&15)

   ;```````````````````````````````````````````````````````````````
   ;  Activates homing canister if random number is lower than 11.
   ;
   if temp5 <= 10 then goto __Activate_Homing_Canister

   goto __Skip_Homing_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Seaweed replication counter value is odd.
   ;
__Canister_is_Odd

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number from 0 to 15.
   ;
   temp5 = (rand&15)

   ;```````````````````````````````````````````````````````````````
   ;  Activates homing canister if random number is higher than 10.
   ;
   if temp5 < 11 then goto __Skip_Homing_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Homing canister is activated.
   ;
__Activate_Homing_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Bonus trigger is turned on.
   ;
   _Bit5_Bonus_500_Trigger{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Seaweed shot counter is cleared. Homing score background
   ;  counter is cleared.
   ;
   _Seaweed_Shot = 0 : _Homing_Sc_Bck_Cntr = 0

   goto __Skip_100_Shot

__Skip_Homing_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Canister trigger is turned on.
   ;
   _Bit1_Canister_Trigger{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Seaweed shot counter is cleared. Homing score background
   ;  counter is cleared.
   ;
   _Seaweed_Shot = 0 : _Homing_Sc_Bck_Cntr = 0


__Skip_100_Shot




   ;***************************************************************
   ;
   ;  Player1 Check
   ;  
   ;  Checks to see if any Player1 sprites are on the screen.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If Player1 is on the screen, program skips ahead.
   ; 
   if _Bit1_Wrothopod_On{1} then goto __Skip_Memory_Check

   if _Bit2_Corrdd_Can_On{2} then goto __Skip_Memory_Check

   if _Bit0_Canister_P1_On{0} then goto __Skip_Memory_Check

   if _Bit4_Bonus_500_On{4} then goto __Skip_Memory_Check

   ;```````````````````````````````````````````````````````````````
   ;  If canister later bit is on, turn it off and turn on
   ;  canister trigger.
   ;
   if _Bit3_Canister_Later{3} then _Bit3_Canister_Later{3} = 0 : _Bit1_Canister_Trigger{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  If Thousand bonus later bit is on, turn it off and turn on
   ;  bonus Thousand bit.
   ;
   if _Bit0_Thousand_Bonus_Later{0} then _Bit0_Thousand_Bonus_Later{0} = 0 : _Bit5_Bonus_500_Trigger{5} = 1

   goto __Move_or_New_Canister_Check

__Skip_Memory_Check

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to remember bonus if a bonus bit is on.
   ;
   if _Bit1_Canister_Trigger{1} || _Bit5_Bonus_500_Trigger{5} then goto __Remember_Bonus

   goto __Move_or_New_Canister_Check

__Remember_Bonus

   ;```````````````````````````````````````````````````````````````
   ;  Player1 is on screen, so remember bonuses.
   ;
   if _Bit1_Canister_Trigger{1} then _Bit1_Canister_Trigger{1} = 0 : _Bit3_Canister_Later{3} = 1

   if _Bit5_Bonus_500_Trigger{5} then _Bit5_Bonus_500_Trigger{5} = 0 : _Bit0_Thousand_Bonus_Later{0} = 1 




   ;***************************************************************
   ;
   ;  Canister check.
   ;
__Move_or_New_Canister_Check

   ;```````````````````````````````````````````````````````````````
   ;  Move canister check.
   ;
   ;  Goes to canister move section if canister bit is on.
   ;
   if _Bit0_Canister_P1_On{0} then goto __Canister_Move

   ;```````````````````````````````````````````````````````````````
   ;  Make new canister check.
   ;
   ;  Goes to new canister section if trigger/Thousand bit is on.
   ;
   if _Bit1_Canister_Trigger{1} || _Bit5_Bonus_500_Trigger{5} then goto __New_Canister

   goto __Canister_Section_End



   ;***************************************************************
   ;
   ;  New canister.
   ;
__New_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if bonus trigger bit isn't on.
   ;
   if !_Bit5_Bonus_500_Trigger{5} then goto __Skip_500_Canister_Check

   ;```````````````````````````````````````````````````````````````
   ;  Turns on bonus bit and clears bonus trigger bit.
   ;
   _Bit4_Bonus_500_On{4} = 1

   _Bit5_Bonus_500_Trigger{5} = 0

__Skip_500_Canister_Check

   ;```````````````````````````````````````````````````````````````
   ;  Turns on homing color cycle bit for score background.
   ;
   _Bit6_Homing_Color_Cycle_On{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Increases rate of seaweed replication.
   ;
   if _Plop_Rate < 14 then _Plop_Rate = _Plop_Rate + 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns on canister bit, moves player1 to the top, and clears
   ;  the canister trigger bit.
   ;
   _Bit0_Canister_P1_On{0} = 1

   player1y = 0 : _Bit1_Canister_Trigger{1} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Starts canister arrival sound effect (channel 1).
   ;
   _Ch1_Sound = _c_Canister_Appear : _Ch1_Duration = 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips a note if normal canister.
   ;
   _Ch1_Counter = 24

   ;```````````````````````````````````````````````````````````````
   ;  Starts sound at beginning if it's the Thousand canister.
   ;
   if _Bit4_Bonus_500_On{4} then _Ch1_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Draws canister
   ;
   player1:
   %11110000
   %11110000
   %01100000
   %01100000
   %11110000
   %11110000
end

   ;```````````````````````````````````````````````````````````````
   ;  Puts canister on right side if player on left side.
   ;
   if player0x < 80 then temp5 = (rand/8) : player1x = temp5 + 93 : goto __Canister_Move

   ;```````````````````````````````````````````````````````````````
   ;  Puts canister on left side if player on right side.
   ;
   temp5 = (rand/8) : player1x = temp5 + 30

__Canister_Move

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Canister movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If Thousand bonus is on and canister appear sound is on, wait
   ;  a little before coming down. Gives the player a
   ;  heads-up warning. (Plays 2 notes before dropping.)
   ;
   if _Bit4_Bonus_500_On{4} then if _Ch1_Sound = _c_Canister_Appear && _Ch1_Counter < 48 then goto __Skip_Canister_Move

   ;```````````````````````````````````````````````````````````````
   ;  If normal canister appear sound is on, wait
   ;  a little before coming down. Gives the player a
   ;  heads-up warning. (Plays 2 notes before dropping.)
   ;
   if !_Bit4_Bonus_500_On{4} then if _Ch1_Sound = _c_Canister_Appear && _Ch1_Counter < 72 then goto __Skip_Canister_Move

   ;```````````````````````````````````````````````````````````````
   ;  Move canister down.
   ;
   _P1_Up_Down = _P1_Up_Down + 0.42

   ;```````````````````````````````````````````````````````````````
   ;  If it's a Thousand bonus, move toward player.
   ;
   if !_Bit4_Bonus_500_On{4} then goto __Skip_Canister_Move

   if player1x < player0x then _P1_Left_Right = _P1_Left_Right + 0.72

   if player1x > player0x then _P1_Left_Right = _P1_Left_Right - 0.72

__Skip_Canister_Move

   ;```````````````````````````````````````````````````````````````
   ;  Player1 position check.
   ;
   if player1y < 100 then goto __Skip_Player1_Position_Check

   goto __Canister_Off_Screen

__Skip_Player1_Position_Check

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Top 3rd of screen (canister color and collision check).
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if canister is not in top 3rd of screen.
   ;
   if player1y > 33 then goto __Skip_Top_3rd

   ;```````````````````````````````````````````````````````````````
   ;  Sets color of canister.
   ;
   player1color:
   $AA
   $AE
   $AA
   $A6
   $AA
   $AE
end

   ;```````````````````````````````````````````````````````````````
   ;  Skips whole section if no collision.
   ;
   if !collision(player1,player0) then goto __Canister_Section_End

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure the game isn't over since points are being added.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Adds points.
   ;
   _Points_Roll_Up = _Points_Roll_Up + 50

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the Manatee health color cycle bit (bluish flash).
   ;
   _Bit5_Manatee_Health_Color{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Shield energy loop starts here.
   ;
   temp5 = 0

__Top_3rd_Score_Test_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Makes the energy loop go.
   ;
   temp5 = temp5 + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips to points area if both shield energy banks are full.
   ;
   if pfscore2 = 255 && pfscore1 = 255 then goto __Top_Both_Full

   goto __Skip_Top_Both_Full

__Top_Both_Full

   ;```````````````````````````````````````````````````````````````
   ;  Points area.
   ;
   if temp5 = 1 then _Points_Roll_Up = _Points_Roll_Up + 25 : goto __Skip_Clear_Can

   if temp5 = 2 then _Points_Roll_Up = _Points_Roll_Up + 10 : goto __Skip_Clear_Can

   _Points_Roll_Up = _Points_Roll_Up + 5 : goto __Skip_Clear_Can

__Skip_Top_Both_Full

   ;```````````````````````````````````````````````````````````````
   ;  If main bank is full, puts energy in the second bank (if
   ;  it's not full).
   ;
   if pfscore2 = 255 then if pfscore1 <= 127 then pfscore1 = pfscore1*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Adds energy to main bank if main bank is not full.
   ;
   if pfscore2 < 128 then pfscore2 = pfscore2*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Loops 3 times.
   ;
   if temp5 < 3 then goto __Top_3rd_Score_Test_Loop

   goto __Skip_Clear_Can

__Skip_Top_3rd

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Middle 3rd of screen (canister color and collision check).
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if canister is not in middle 3rd of screen.
   ;
   if player1y > 59 then goto __Skip_Middle_3rd

   ;```````````````````````````````````````````````````````````````
   ;  Sets color of canister.
   ;
   player1color:
   $FA
   $FE
   $FA
   $F6
   $FA
   $FE
end

   ;```````````````````````````````````````````````````````````````
   ;  Skips whole canister section if no collision.
   ;
   if !collision(player1,player0) then goto __Canister_Section_End

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure the game isn't over since points are being added.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Adds points.
   ;
   _Points_Roll_Up = _Points_Roll_Up + 25

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the Manatee health color cycle bit (bluish flash).
   ;
   _Bit5_Manatee_Health_Color{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Shield energy loop for middle area of screen starts here.
   ;
   temp5 = 0

__Middle_3rd_Score_Test_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Makes the energy loop go.
   ;
   temp5 = temp5 + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips to next part if both shield energy banks are full.
   ;
   if pfscore2 = 255 && pfscore1 = 255 then goto __Middle_Both_Full

   goto __Skip_Middle_Both_Full

__Middle_Both_Full

   ;```````````````````````````````````````````````````````````````
   ;  Points area.
   ;
   if temp5 = 1 then _Points_Roll_Up = _Points_Roll_Up + 10 : goto __Skip_Clear_Can

   _Points_Roll_Up = _Points_Roll_Up + 5 : goto __Skip_Clear_Can

__Skip_Middle_Both_Full

   ;```````````````````````````````````````````````````````````````
   ;  If main bank is full, puts energy in the second bank (if
   ;  it's not full).
   ;
   if pfscore2 = 255 then if pfscore1 <= 127 then pfscore1 = pfscore1*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Adds energy to main bank if main bank is not full.
   ;
   if pfscore2 < 128 then pfscore2 = pfscore2*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Loops 2 times.
   ;
   if temp5 < 2 then goto __Middle_3rd_Score_Test_Loop

   goto __Skip_Clear_Can

__Skip_Middle_3rd

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Bottom 3rd of screen (canister color and collision check).
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if canister is not in bottom 3rd of screen.
   ;
   if player1y < 60 then goto __Canister_Section_End

   ;```````````````````````````````````````````````````````````````
   ;  Sets color of canister.
   ;
   player1color:
   $4A
   $4E
   $4A
   $46
   $4A
   $4E
end

   ;```````````````````````````````````````````````````````````````
   ;  Skips whole section if no collision.
   ;
   if !collision(player1,player0) then goto __Canister_Section_End

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure the game isn't over since points are being added.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Adds points.
   ;
   _Points_Roll_Up = _Points_Roll_Up + 10

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the Manatee health color cycle bit (bluish flash).
   ;
   _Bit5_Manatee_Health_Color{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  If both Shield energy banks are full, add points instead.
   ;
   if pfscore2 = 255 && pfscore1 = 255 then _Points_Roll_Up = _Points_Roll_Up + 5 : goto __Skip_Clear_Can

   ;```````````````````````````````````````````````````````````````
   ;  If main bank is full, puts energy in the second bank (if
   ;  it's not full).
   ;
   if pfscore2 = 255 then if pfscore1 <= 127 then pfscore1 = pfscore1*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Adds energy to main bank if main bank is not full.
   ;
   if pfscore2 < 128 then pfscore2 = pfscore2*2|1


__Skip_Clear_Can

   ;```````````````````````````````````````````````````````````````
   ;  Adjusts health bar colors (blue, yellow, or red).
   ;
   if pfscore2 > 15 then pfscorecolor = $AE

   if pfscore2 < 16 then pfscorecolor = $1C

   if pfscore2 < 3 then pfscorecolor = $32

   ;```````````````````````````````````````````````````````````````
   ;  Sets up touch canister sound.
   ;
   _Ch1_Sound = _c_Canister_Touched : _Ch1_Counter = 0 : _Ch1_Duration = 1

__Canister_Off_Screen

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure Player1 sprite is off screen.
   ;
   player1y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Turns off canister bit.
   ;
   _Bit0_Canister_P1_On{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  If bonus Thousand bit is on, turn it off.
   ;
   if _Bit4_Bonus_500_On{4} then _Bit4_Bonus_500_On{4} = 0


__Canister_Section_End



   ;***************************************************************
   ;
   ;  Wrothopod drop.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if health canister is on screen.
   ;
   if _Bit0_Canister_P1_On{0} then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Corroded Canister is on screen or
   ;  related sound is playing.
   ;
   if _Bit2_Corrdd_Can_On{2} then goto __Skip_Enemy_Drop

   if _Ch1_Sound = _c_Corroded_Hit_Ship then goto __Skip_Enemy_Drop

   if _Ch1_Sound = _c_Canister_Touched then goto __Skip_Enemy_Drop

   if _Ch1_Sound = _c_Corroded_Seaweed_Moosh then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Skips to movement area if Wrothopod bit is already on.
   ;
   if _Bit1_Wrothopod_On{1} then goto __Wrothopod_Move

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if enough time hasn't gone by.
   ;
   if _Wrothopod_Counter < 37 then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Decision to turn on Wrothopod partially based on health bar.
   ;
   if pfscore2 > 2 then temp5 = rand  : temp4 = _Plop_Rate * 4 : temp6 = 86 - temp4

   if pfscore2 < 3 then temp5 = rand  : temp4 = _Plop_Rate * 2 : temp6 = 86 - temp4

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if random number is greater.
   ;
   if temp5 > temp6 then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Turns on Wrothopod bit and puts the sprite at the top.
   ;
   _Bit1_Wrothopod_On{1} = 1 : player1y = 0

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 31).
   ;
   temp5 = (rand&31)

   ;```````````````````````````````````````````````````````````````
   ;  Checks to see if previous Wrothopod color is the same.
   ;
   if _Wroth_Color_Mem <> temp5 then goto __Skip_Wroth_Repeat_Check

   ;```````````````````````````````````````````````````````````````
   ;  Previous color was the same. Picks the next one in line.
   ;
   temp5 = temp5 + 1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps Wrothopod color from going out-of-bounds.
   ;
   if temp5 > 31 then temp5 = 0

__Skip_Wroth_Repeat_Check

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the new Wrothopod color.
   ;
   _Wroth_Color_Mem = temp5

   ;```````````````````````````````````````````````````````````````
   ;  Gets the Wrothopod color.
   ;
   if temp5 < 10 then on temp5 goto __W_Clr_0 __W_Clr_1 __W_Clr_2 __W_Clr_3 __W_Clr_4 __W_Clr_5 __W_Clr_6 __W_Clr_7 __W_Clr_8 __W_Clr_9

   temp6 = temp5 - 10

   if temp6 < 10 then on temp6 goto __W_Clr_10 __W_Clr_11 __W_Clr_12 __W_Clr_13 __W_Clr_14 __W_Clr_15 __W_Clr_16 __W_Clr_17 __W_Clr_18 __W_Clr_19

   temp6 = temp5 - 20

   if temp6 < 12 then on temp6 goto __W_Clr_20 __W_Clr_21 __W_Clr_22 __W_Clr_23 __W_Clr_24 __W_Clr_25 __W_Clr_26 __W_Clr_27 __W_Clr_28 __W_Clr_29 __W_Clr_30 __W_Clr_31

__Wroth_Color_Done

   ;```````````````````````````````````````````````````````````````
   ;  Sound Effect: Wrothopod Arrival (channel 1)
   ;
   _Ch1_Sound = _c_Wrothopod : _Ch1_Counter = 0 : _Ch1_Duration = 1

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod placement.
   ;
   ;  Puts Wrothopod in general area above the player.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If player is on left side of screen, start Wroth on left.
   ;
   if player0x < 80 then temp5 = (rand/8) : player1x = temp5 + 30 : goto __Wrothopod_Move

   ;```````````````````````````````````````````````````````````````
   ;  If player is on right side of screen, start Wroth on right.
   ;
   if player0x > 79 then temp5 = (rand/8) : player1x = temp5 + 93 : goto __Wrothopod_Move

__Wrothopod_Move

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod hit by torpedo check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Wrothopod is not shot.
   ;
   if !collision(missile0,player1) then goto __Skip_Wroth_Shot

   ;```````````````````````````````````````````````````````````````
   ;  Gets rid of torpedo and makes Wrothopod angry.
   ;
   missile0y = 250 : _Bit5_Wroth_Mad{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Health bar is decreased.
   ;
   gosub __Ouch_Dec_Health_01

   ;```````````````````````````````````````````````````````````````
   ;  Activates Easter Egg if game is over and auto-play is off.
   ;
   if !_Bit1_Auto_Play{1} then if pfscore2 = 0 then _Bit3_Easter_Egg{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Sound Effect: Wrothopod Shot (channel 1)
   ;
   ;  This skips the first part of the Wroth arrival sound effect,
   ;  getting a semi-new sound effect using the same data.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears and sets up sound effect bits.
   ;
   _Ch1_Sound = _c_Wrothopod : _Ch1_Counter = 28 : _Ch1_Duration = 1

__Skip_Wroth_Shot

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Player/Wrothopod collision.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if Wroth touched bit is already on.
   ;
   if _Bit6_Wroth_Touched{6} then goto __Skip_Wroth_Ouch

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if there is no collision.
   ;
   if !collision(player0,player1) then goto __Skip_Wroth_Ouch

   ;```````````````````````````````````````````````````````````````
   ;  Turns on Wroth touched bit.
   ;
   _Bit6_Wroth_Touched{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  If Manatee is too low, health is decreased, but Manatee is
   ;  not moved down.
   ;
   if _P0_Up_Down > 83 then goto __Skip_Wroth_Move_Ship_Down

   ;```````````````````````````````````````````````````````````````
   ;  Moves Manatee down.
   ;
   _P0_Up_Down = _P0_Up_Down + 2.02

__Skip_Wroth_Move_Ship_Down

   ;```````````````````````````````````````````````````````````````
   ;  Sets up slide, sound effect, and channel 1 sound counter.
   ;
   _Slide_Counter = 0

   _Bit3_Ship_Yanked_Down{3} = 1 : _Slide_Speed = 1 : _Ch1_Duration = 1

   _Ch1_Counter = 28 : _Ch1_Sound = _c_Wrothopod

   ;```````````````````````````````````````````````````````````````
   ;  Health bar is decreased.
   ;
   gosub __Ouch_Dec_Health_01

__Skip_Wroth_Ouch

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if Wrothopod is on the screen.
   ;
   if player1y < 100 then goto __Skip_Wroth_Bottom

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod has moved off the screen.
   ;
   ;  Clears Wrothopod-related bits.
   ;
   _Wrothopod_Counter = 0 : _Bit1_Wrothopod_On{1} = 0 : _Bit5_Wroth_Mad{5} = 0 : _Bit6_Wroth_Touched{6} = 0

   goto __Skip_Enemy_Drop

__Skip_Wroth_Bottom

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if Wrothopod is angry.
   ;
   if _Bit5_Wroth_Mad{5} then goto __Wroth_Swim

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if certain sounds are playing.
   ;
   if _Ch1_Sound = _c_Tentacle_Reaching_Up || _Bit6_Wroth_Touched{6} then goto __Wroth_Swim

   ;```````````````````````````````````````````````````````````````
   ;  Uses Wroth appear sound as a warning. Makes Wrothopod wait a
   ;  little before coming down.
   ;
   if _Ch1_Sound = _c_Wrothopod && _Ch1_Counter < 136 then goto __Skip_Enemy_Drop

__Wroth_Swim

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod swim section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Swims medium speed before and after full leg move.
   ;
   if _Frame_Counter = 1 || _Frame_Counter = 3 then _P1_Up_Down = _P1_Up_Down + 0.52 : goto __Skip_Swim

   ;```````````````````````````````````````````````````````````````
   ;  Swims fastest speed during full leg move.
   ;
   if _Frame_Counter = 2 then _P1_Up_Down = _P1_Up_Down + 0.72 : goto __Skip_Swim

   ;```````````````````````````````````````````````````````````````
   ;  Swims slowest speed the rest of the time.
   ;
   _P1_Up_Down = _P1_Up_Down + 0.32

__Skip_Swim

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod swims toward player.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if Wrothopod is angry.
   ;
   if _Bit5_Wroth_Mad{5} then goto __Angry_Wrothopod

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod will ignore player1x position after passing.
   ;
   if player1y > player0y then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Wrothopod moves toward the player.
   ;
   if player1x < player0x then _P1_Left_Right = _P1_Left_Right + 0.82

   if player1x > player0x then _P1_Left_Right = _P1_Left_Right - 0.82

   goto __Skip_Enemy_Drop

__Angry_Wrothopod

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Angry Wrothopod section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Angry: Wrothopod color.
   ;
   player1color:
   $4C
   $4E
   $48
   $4E
   $4C
   $4A
   $48
   $46
end

   ;```````````````````````````````````````````````````````````````
   ;  Angry: Speeds up Wrothopod.
   ;
   _P1_Up_Down = _P1_Up_Down + 0.32

   ;```````````````````````````````````````````````````````````````
   ;  Angry: Wrothopod will ignore player's position after passing.
   ;
   if player1y > player0y then goto __Skip_Enemy_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Angry: Wrothopod moves toward the player.
   ;
   if player1x < player0x then _P1_Left_Right = _P1_Left_Right + 1.12

   if player1x > player0x then _P1_Left_Right = _P1_Left_Right - 1.12

__Skip_Enemy_Drop



   ;***************************************************************
   ;
   ;  Corroded canister.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if health canister is on screen.
   ;
   if _Bit0_Canister_P1_On{0} then goto __Clear_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Wrothopod is on screen.
   ;
   if _Bit1_Wrothopod_On{1} then goto __Clear_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Corroded canister cannot appear if tentacle is on screen.
   ;
   if !_Bit2_Corrdd_Can_On{2} && _Bit2_Move_Tentacle_Up{2} then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if Corroded Canister is already on.
   ;
   if _Bit2_Corrdd_Can_On{2} then goto __Canister_Activated

   ;```````````````````````````````````````````````````````````````
   ;  If tentacle is on, don't make corroded canister appear.
   ;  Note from 2015: This line might be unnecessary.
   ;
   if _Bit2_Move_Tentacle_Up{2} then goto __Clear_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check.
   ;
   if _Bit1_Auto_Play{1} then goto __AP_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if appearance counter is less than around 2
   ;  seconds.
   ;
   if _Corrdd_App_Counter < 25 then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Starts at 5 and adds more based on difficulty (0 to 14).
   ;
   temp5 = 5 + _Plop_Rate

   ;```````````````````````````````````````````````````````````````
   ;  Makes corroded canister more likely to appear if the main
   ;  energy bar is half full or less.
   ;
   if pfscore2 < 16 then temp6 = _Plop_Rate/2 : temp5 = 5 + temp6

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if player hasn't shot enough seaweed.
   ;
   if _Corrdd_Shot_Counter < temp5 then goto __Skip_Corroded_Canister

__AP_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Skips Section if a piece of seaweed hasn't just been shot.
   ;
   if !_Bit4_Corrdd_Can_Swd_Shot{4} then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Uses one number if energy isn't too low.
   ;
   if pfscore2 > 15 then temp5 = rand  : temp4 = _Plop_Rate * 4 : temp6 = 86 - temp4

   ;```````````````````````````````````````````````````````````````
   ;  Uses a different number if energy is low.
   ;
   if pfscore2 < 16 then temp4 = _Plop_Rate * 2 : temp6 = 86 - temp4

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if random number is greater.
   ;
   if temp5 > temp6 then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Sets up Corroded Canister variables.
   ;
   _Corrdd_App_Counter = 30 : _Corrdd_Shot_Counter = 20

   _Bit2_Corrdd_Can_On{2} = 1

   _MLoop_Tmp_Corrdd_Anim_Count = 0 : _Corroded_Anim_Frame = 0

   ;```````````````````````````````````````````````````````````````
   ;  Sets Corroded Canister color.
   ;
   player1color:
   $36
   $3A
   $36
   $32
   $36
   $3A
end

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random number (0 to 7).
   ;
   temp5 = (rand&7)

   ;```````````````````````````````````````````````````````````````
   ;  Grabs a random Corroded Canister frame.
   ;
   on temp5 gosub __Cor_Anim_0 __Cor_Anim_1 __Cor_Anim_2 __Cor_Anim_0 __Cor_Anim_4 __Cor_Anim_5 __Cor_Anim_1 __Cor_Anim_5

   ;```````````````````````````````````````````````````````````````
   ;  Puts the Corroded Canister where the torpedo hit.
   ;
   player1x = (_Corrdd_X_Shot_Mem*4)+17

   player1y = (_Corrdd_Y_Shot_Mem*8)+6

   ;```````````````````````````````````````````````````````````````
   ;  Turns on corroded tick down sound.
   ;
   _Ch1_Sound = _c_Corroded_Tick_Down : _Ch1_Counter = 0 : _Ch1_Duration = 1

__Canister_Activated

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the chase player section if the bit is on.
   ;
   if _Bit3_Corroded_Can_Chase_Player{3} then goto __Cor_Can_Chase_Player

   ;```````````````````````````````````````````````````````````````
   ;  Increases Corroded Canister timer.
   ;
   _Corrdd_Timer = _Corrdd_Timer + 1

   ;```````````````````````````````````````````````````````````````
   ;  Canister/player collision check.
   ;
   if !collision(player0,player1) then goto __Skip_Corroded_Activated_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Removes Canister from screen and sets up sound effect.
   ;
   player1y = 200

   _Ch1_Sound = _c_Canister_Touched : _Ch1_Counter = 0 : _Ch1_Duration = 1

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure the game isn't over since points are being added.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Add points.
   ;
   _Points_Roll_Up = _Points_Roll_Up + 10

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the Manatee health color cycle bit (bluish flash).
   ;
   _Bit5_Manatee_Health_Color{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  If both Shield energy banks are full, adds points instead.
   ;
   if pfscore2 = 255 && pfscore1 = 255 then _Points_Roll_Up = _Points_Roll_Up + 5 : goto __Clear_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  If main bank is full, puts energy in the second bank (if
   ;  it's not full).
   ;
   if pfscore2 = 255 then if pfscore1 < 128 then pfscore1 = pfscore1*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Adds energy to main bank if main bank is not full.
   ;
   if pfscore2 < 128 then pfscore2 = pfscore2*2|1

   ;```````````````````````````````````````````````````````````````
   ;  Adjusts Health bar colors.
   ;
   if pfscore2 > 15 then pfscorecolor = $AE

   if pfscore2 < 16 then pfscorecolor = $1C

   if pfscore2 < 3 then pfscorecolor = $32

   goto __Clear_Corroded

__Skip_Corroded_Activated_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Skips if Corroded Canister timer is less than 2 seconds.
   ;
   if _Corrdd_Timer < 205 then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Turns on the chase player bit.
   ;
   _Bit3_Corroded_Can_Chase_Player{3} = 1

__Cor_Can_Chase_Player

   ;```````````````````````````````````````````````````````````````
   ;  Turns on chase sound effect if it isn't on.
   ;
   if _Ch1_Sound = _c_Corroded_Chase then goto __Skip_Chase_Sound

   _Ch1_Sound = _c_Corroded_Chase : _Ch1_Counter = 0 : _Ch1_Duration = 1

__Skip_Chase_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Animation for Corroded Canister.
   ;
   _MLoop_Tmp_Corrdd_Anim_Count = _MLoop_Tmp_Corrdd_Anim_Count + 1

   if _MLoop_Tmp_Corrdd_Anim_Count < 7 then goto __Skip_Corroded_Anim

   _Corroded_Anim_Frame = _Corroded_Anim_Frame + 1 : _MLoop_Tmp_Corrdd_Anim_Count = 0

   if _Corroded_Anim_Frame > 5 then _Corroded_Anim_Frame = 0

   on _Corroded_Anim_Frame gosub __Cor_Anim_0 __Cor_Anim_1 __Cor_Anim_2 __Cor_Anim_3 __Cor_Anim_4 __Cor_Anim_5

__Skip_Corroded_Anim

   ;```````````````````````````````````````````````````````````````
   ;  Moves Corroded Canister toward player.
   ;
   if player1x < player0x then _P1_Left_Right = _P1_Left_Right + 1.08
   if player1x > player0x then _P1_Left_Right = _P1_Left_Right - 1.08

   if player1y < player0y then _P1_Up_Down = _P1_Up_Down + 1.10
   if player1y > player0y then _P1_Up_Down = _P1_Up_Down - 1.10

   ;```````````````````````````````````````````````````````````````
   ;  Collision with seaweed check.
   ;
   if !collision(playfield,player1) then goto __Next_Corroded_Collision_Check

   ;```````````````````````````````````````````````````````````````
   ;  Moves Corroded Canister off screen.
   ;
   player1y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Sets up Seaweed Moosh sound effect.
   ;
   _Ch1_Sound = _c_Corroded_Seaweed_Moosh : _Ch1_Counter = 0 : _Ch1_Duration = 1

   goto __Clear_Corroded

__Next_Corroded_Collision_Check

   ;```````````````````````````````````````````````````````````````
   ;  Checks for collision with canister and player.
   ;
   if !collision(player0,player1) then goto __Skip_Corroded_Canister

   ;```````````````````````````````````````````````````````````````
   ;  Moves Corroded Canister off screen.
   ;
   player1y = 200

   ;```````````````````````````````````````````````````````````````
   ;  Sets up Corroded Canister hitting ship sound effect (ch. 1).
   ;
   _Ch1_Sound = _c_Corroded_Hit_Ship : _Ch1_Counter = 0 : _Ch1_Duration = 1

   ;```````````````````````````````````````````````````````````````
   ;  Decreases player's health and clears the seaweed hit bit.
   ;
   gosub __Ouch_Dec_Health_01 : _Bit1_P0_Hit_Seaweed{1} = 0

__Clear_Corroded

   ;```````````````````````````````````````````````````````````````
   ;  Clears Corroded Canister bits and counters.
   ;
   _Corrdd_App_Counter = 0 : _Corrdd_Timer = 0 : _Corrdd_Shot_Counter = 0

   _Bit2_Corrdd_Can_On{2} = 0 : _Bit3_Corroded_Can_Chase_Player{3} = 0

__Skip_Corroded_Canister



   ;***************************************************************
   ;
   ;  Turns on seaweed tentacle.
   ;
   ;  7 milliseconds x 8 = 56 milliseconds (almost a second).
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if tentacle is already activated.
   ;
   if _Bit2_Move_Tentacle_Up{2} then goto __Skip_Tentacle_Activation

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if tentacle counter isn't correct number.
   ;
   if _Tentacle_Grab_Counter <> 8 then goto __Skip_Tentacle_Activation

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if tentacle is on screen.
   ;
   if bally < 200 then goto __Skip_Tentacle_Activation

   ;```````````````````````````````````````````````````````````````
   ;  Clears the tentacle counter.
   ;
   _Tentacle_Grab_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check (skips sound effect check).
   ;
   if _Bit1_Auto_Play{1} then goto __Activate_Tentacle

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if a sound effect is playing.
   ;
   if _Ch1_Sound then goto __Skip_Tentacle_Activation

__Activate_Tentacle

   ;```````````````````````````````````````````````````````````````
   ;  Sets up bits/variables and moves the tentacle into place.
   ;
   _Tentacle_Grab_Counter = 20 : _Bit2_Move_Tentacle_Up{2} = 1 : ballx = player0x + 3

   ;```````````````````````````````````````````````````````````````
   ;  Sets up seaweed tentacle sound effect (channel 1).
   ;
   _Ch1_Sound = _c_Tentacle_Reaching_Up : _Ch1_Counter = 0 : _Ch1_Duration = 1

__Skip_Tentacle_Activation



   ;***************************************************************
   ;
   ;  Tentacle Movement and Manatee Grab
   ;
   ;  Grabs the player if resting too long.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If tentacle isn't moving up, checks if it needs to move down.
   ;
   if !_Bit2_Move_Tentacle_Up{2} then if bally < 200 then goto __Skip_Tentacle_Reach

   ;```````````````````````````````````````````````````````````````
   ;  Clears the touched bit and skips if tentacle isn't moving up.
   ;
   if !_Bit2_Move_Tentacle_Up{2} then _Bit7_Tentacle_Touched{7} = 0 : goto __Skip_Grab

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Sound Test
   ;
   ;  Skips ahead if the tentacle sound is off.
   ;
   if _Ch1_Sound <> _c_Tentacle_Reaching_Up then goto __Skip_Grab_Sound_Test

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __Skip_Grab_Sound_Test

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if Manatee is on bottom 3rd of screen and the
   ;  tentacle sound hasn't played long enough.
   ;
   if player0y > 59 then if _Ch1_Counter < 17 then goto __Skip_Grab

__Skip_Grab_Sound_Test

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Tentacle Reach
   ;
   ;  Moves tentacle up the screen.
   ;
   _Ball_Y = _Ball_Y - 1.00

   ;```````````````````````````````````````````````````````````````
   ;  Speeds up the tentacle if Manatee is higher on the screen.
   ;
   if player0y < 60 then _Ball_Y = _Ball_Y - 0.32

   ;```````````````````````````````````````````````````````````````
   ;  Speeds up tentacle even more if Manatee moved left or right.
   ;
   if _Bit6_Manatee_Moved_Away{6} then _Ball_Y = _Ball_Y - 3.00

__Skip_Tentacle_Reach

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Tentacle Collision Check
   ;
   ;  Clears tentacle up bit and skips ahead if tentacle touched
   ;  bit is already on.
   ;
   if _Bit7_Tentacle_Touched{7} then _Bit2_Move_Tentacle_Up{2} = 0 : goto __Skip_Tentacle_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if no collision between Manatee and tentacle.
   ;
   if !collision(ball,player0) then goto __Skip_Tentacle_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Tentacle grabbed player (collision happened). Tentacle up
   ;  bit is turned off and tentacle touched bit is turned on.
   ;
   _Bit2_Move_Tentacle_Up{2} = 0 : _Bit7_Tentacle_Touched{7} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Ouches the Manatee, but does not move it down if it's too
   ;  low on the screen.
   ;
   if _P0_Up_Down > 83 then gosub __Ouch_Dec_Health_01 : goto __Check_Grab_Position

   ;```````````````````````````````````````````````````````````````
   ;  Ship high enough. Moves it down, slides it, and ouches it.
   ;
   _Slide_Counter = 0

   _Slide_Speed = 1 : _Bit3_Ship_Yanked_Down{3} = 1

   _P0_Up_Down = _P0_Up_Down + 4.02

   gosub __Ouch_Dec_Health_01

   goto __Check_Grab_Position

__Skip_Tentacle_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits/variables if tentacle reaches high enough.
   ;
   if bally < 103 then _Tentacle_Grab_Counter = 0 : _Bit2_Move_Tentacle_Up{2} = 0 : _Bit6_Manatee_Moved_Away{6} = 0

__Check_Grab_Position

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if tentacle is moving up.
   ;
   if _Bit2_Move_Tentacle_Up{2} then goto __Skip_Grab

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Tentacle Down Check
   ;  
   ;  Moves tentacle down if Manatee has moved left or right
   ;  or it has been ouched.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if tentacle is off the screen.
   ;
   if bally > 199 then goto __Skip_Grab

   ;```````````````````````````````````````````````````````````````
   ;  Clears bits/variables.
   ;
   _Bit2_Move_Tentacle_Up{2} = 0 : _Bit6_Manatee_Moved_Away{6} = 0 : _Tentacle_Grab_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Moves tentacle down.
   ;
   _Ball_Y = _Ball_Y + 2.00 

__Skip_Grab



   ;***************************************************************
   ;
   ;  Homing Health color cycle for score background.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skip this section if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __Skip_Homing_Cycle

   ;```````````````````````````````````````````````````````````````
   ;  Skip this section if color cycle isn't on.
   ;
   if !_Bit6_Homing_Color_Cycle_On{6} then goto __Skip_Homing_Cycle

   ;```````````````````````````````````````````````````````````````
   ;  Reads homing health color data for score background.
   ;
   temp5 = _D_Homing_H[_Homing_Sc_Bck_Cntr]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data. Skips ahead if not the end.
   ;
   if temp5 < 255 then goto __Skip_Homing_End

   ;```````````````````````````````````````````````````````````````
   ;  End of data.
   ;
   ;  Clears bits/variables.
   ;
   _Bit6_Homing_Color_Cycle_On{6} = 0 : _Homing_Sc_Bck_Cntr = 0

   ;```````````````````````````````````````````````````````````````
   ;  Changes score background color.
   ;
   if _Seaweed_Shot < 20 then _SC_Back = $C8

   if _Seaweed_Shot > 19 && _Seaweed_Shot < 40 then _SC_Back = $C6

   if _Seaweed_Shot > 39 && _Seaweed_Shot < 60 then _SC_Back = $C4

   if _Seaweed_Shot > 59 && _Seaweed_Shot < 80 then _SC_Back = $C2

   if _Seaweed_Shot > 79 then _SC_Back = $C0

   goto __Skip_Homing_Cycle

__Skip_Homing_End

   ;```````````````````````````````````````````````````````````````
   ;  Sets score background color from data.
   ;
   _SC_Back = temp5

   ;```````````````````````````````````````````````````````````````
   ;  Increases score background color data counter.
   ;
   _Homing_Sc_Bck_Cntr = _Homing_Sc_Bck_Cntr + 0.4

__Skip_Homing_Cycle



   ;***************************************************************
   ;  
   ;  Code continues in next bank.
   ;
   goto __Code_Section_3 bank4





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
   ;  Ouch subroutine for bank 3  -21-
   ;
   ;  Decreases health bar. Changes color if needed or ends game.
   ;
__Ouch_Dec_Health_01

   ;```````````````````````````````````````````````````````````````
   ;  Decreases second health bar if the first one is empty.
   ;
   if pfscore1 = 0 then pfscore2 = pfscore2/2

   ;```````````````````````````````````````````````````````````````
   ;  Decreases first health bar if it isn't empty and the second
   ;  health bar is full.
   ;
   if pfscore1 > 0 && pfscore2 = 255 then pfscore1 = pfscore1/2

   ;```````````````````````````````````````````````````````````````
   ;  Sets hit seaweed bit and Manatee hurt bit.
   ;
   _Bit1_P0_Hit_Seaweed{1} = 1 : _Bit4_Manatee_Hurt_Color{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Changes health bar color when needed or ends the game.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   if pfscore2 < 16 then pfscorecolor = $1C

   if pfscore2 < 3 then pfscorecolor = $42

   if pfscore2 < 1 then _Bit0_Game_Control{0} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Starts player collision sound effect. 
   ;
   if _Ch0_Sound = _c_1000_Health then goto __Skip_Ouch_Sound

   _Ch0_Counter = 0 : _Ch0_Sound = _c_Ship_Bounce : _Ch0_Duration = 1

__Skip_Ouch_Sound

   return thisbank




   ;***************************************************************
   ;
   ;  Data for Homing Health Canister.  -22-
   ;
   data _D_Homing_H
   $80,$82,$84,$86,$88,$8A,$8C,$8E,$8C,$8A,$88,$86,$84,$82
   $80,$82,$84,$86,$88,$8A,$8C,$8E,$8C,$8A,$88,$86,$84,$82
   $80,$C0,$C0,$C2,$C4,$C6,$C8,255
end




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Corroded Canister animation frames.  -23-
   ;
__Cor_Anim_0

   _Corroded_Anim_Frame = 0

   player1:
   %11010000
   %11110000
   %01100000
   %01100000
   %11110000
   %10110000
end

   return thisbank


__Cor_Anim_1

   _Corroded_Anim_Frame = 1

   player1:
   %10110000
   %11110000
   %01100000
   %01100000
   %11110000
   %01110000
end

   return thisbank


__Cor_Anim_2

   _Corroded_Anim_Frame = 2

   player1:
   %01110000
   %11110000
   %01100000
   %01100000
   %11110000
   %11110000
end

   return thisbank


__Cor_Anim_3

   _Corroded_Anim_Frame = 3

   player1:
   %11110000
   %11110000
   %01100000
   %01100000
   %11110000
   %11110000
end

   return thisbank


__Cor_Anim_4

   _Corroded_Anim_Frame = 4

   player1:
   %11110000
   %11110000
   %01100000
   %01100000
   %11110000
   %11100000
end

   return thisbank


__Cor_Anim_5

   _Corroded_Anim_Frame = 5

   player1:
   %11100000
   %11110000
   %01100000
   %01100000
   %11110000
   %11010000
end

   return thisbank




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Wrothopod colors.  -24-
   ;
__W_Clr_0
   ; wrothopod_purple_01.spr
   player1color:
   $78
   $7E
   $66
   $7E
   $7C
   $7A
   $8A
   $78
end

   goto __Wroth_Color_Done


__W_Clr_1
   ; wrothopod_1_purple_yellow_stripes_01.spr
   player1color:
   $78
   $1C
   $66
   $1C
   $1A
   $18
   $7C
   $78
end

   goto __Wroth_Color_Done


__W_Clr_2
   ; wrothopod_2_brownish_yellow_purple_stripes_01.spr
   player1color:
   $78
   $2E
   $66
   $DC
   $D8
   $D6
   $DA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_3
   ; wrothopod_2_darker_brownish_yellow_purple_stripes_01.spr
   player1color:
   $78
   $1C
   $66
   $7E
   $7C
   $7A
   $CA
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_4
   ; wrothopod_2_purple_darker_brown_stripes_01.spr
   player1color:
   $78
   $1C
   $66
   $AE
   $AA
   $A8
   $AA
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_5
   ; wrothopod_3_orange_purple_stripes_01.spr
   player1color:
   $78
   $0C
   $66
   $0C
   $DA
   $D8
   $DA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_6
   ;  wrothopod_3_darker_orange_purple_stripes_01.spr
   player1color:
   $78
   $9E
   $66
   $7E
   $7C
   $7A
   $9A
   $98
end

   goto __Wroth_Color_Done


__W_Clr_7
   ; wrothopod_9_purple_darker_blue_stripes_01.spr
   player1color:
   $78
   $7E
   $66
   $7E
   $7A
   $78
   $9A
   $98
end

   goto __Wroth_Color_Done


__W_Clr_8
   ; wrothopod_A_blue_purple_02.spr
   player1color:
   $78
   $AE
   $66
   $AC
   $AA
   $A8
   $78
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_9
   ; wrothopod_B_puke_green_purple_stripes_02.spr
   player1color:
   $78
   $CC
   $66
   $BC
   $B8
   $B6
   $BA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_10
   ; wrothopod_D_light_green_purple_stripes_01.spr
   player1color:
   $78
   $DE
   $66
   $DA
   $D8
   $D6
   $78
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_11
   ; wrothopod_F_yellow_purple_stripes_02.spr
   player1color:
   $78
   $1A
   $66
   $FA
   $F8
   $F6
   $16
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_12
   ; wrothopod_5_pink_and_purple_01.spr
   player1color:
   $78
   $7E
   $66
   $1C
   $18
   $16
   $D8
   $F8
end

   goto __Wroth_Color_Done


__W_Clr_13
   ; wrothopod_D_and_1_yellow_green_purple_01.spr
   player1color:
   $78
   $1C
   $66
   $1A
   $DC
   $D8
   $18
   $68
end

   goto __Wroth_Color_Done


__W_Clr_14
   ; wrothopod_A_and_2_brown_blue_purple_01.spr
   player1color:
   $78
   $AC
   $66
   $1C
   $18
   $16
   $AA
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_15
   ; wrothopod_0_gray_blue_purple_01.spr
   player1color:
   $78
   $0A
   $66
   $0A
   $08
   $06
   $DA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_16

   player1color:
   $78
   $1C
   $66
   $1C
   $1A
   $18
   $BA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_17

   player1color:
   $78
   $CC
   $66
   $0A
   $08
   $06
   $9A
   $98
end

   goto __Wroth_Color_Done


__W_Clr_18

   player1color:
   $78
   $CC
   $66
   $BC
   $B8
   $B6
   $18
   $68
end

   goto __Wroth_Color_Done


__W_Clr_19

   player1color:
   $78
   $DE
   $66
   $FA
   $F8
   $F6
   $AA
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_20

   player1color:
   $78
   $0A
   $66
   $7E
   $7C
   $7A
   $9A
   $98
end

   goto __Wroth_Color_Done


__W_Clr_21

   player1color:
   $78
   $0A
   $66
   $0A
   $08
   $06
   $7C
   $78
end

   goto __Wroth_Color_Done


__W_Clr_22

   player1color:
   $78
   $1C
   $66
   $1C
   $1A
   $18
   $78
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_23

   player1color:
   $78
   $AE
   $66
   $DC
   $D8
   $D6
   $DA
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_24

   player1color:
   $78
   $7E
   $66
   $AC
   $AA
   $A8
   $78
   $A6
end

   goto __Wroth_Color_Done


__W_Clr_25

   player1color:
   $78
   $7E
   $66
   $7E
   $7C
   $7A
   $08
   $68
end

   goto __Wroth_Color_Done


__W_Clr_26

   player1color:
   $78
   $1A
   $66
   $0A
   $08
   $06
   $D8
   $F8
end

   goto __Wroth_Color_Done


__W_Clr_27

   player1color:
   $78
   $1A
   $66
   $7E
   $7C
   $7A
   $8A
   $78
end

   goto __Wroth_Color_Done


__W_Clr_28

   player1color:
   $78
   $0A
   $66
   $7E
   $7A
   $78
   $18
   $68
end

   goto __Wroth_Color_Done


__W_Clr_29

   player1color:
   $78
   $AC
   $66
   $FA
   $F8
   $F6
   $16
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_30

   player1color:
   $78
   $AC
   $66
   $0A
   $08
   $06
   $16
   $D6
end

   goto __Wroth_Color_Done


__W_Clr_31

   player1color:
   $78
   $0A
   $66
   $AC
   $AA
   $A8
   $78
   $A6
end

   goto __Wroth_Color_Done





   ; Bank 4  -25- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 4
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Third section of main loop.  -26-
   ;
__Code_Section_3



   ;***************************************************************
   ;
   ;  Sets the playfield colors back to normal if the thousand
   ;  points bonus bit isn't on.
   ;
   if _Bit2_1000_On{2} then goto __Skip_Normal_Colors

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

__Skip_Normal_Colors



   ;***************************************************************
   ;
   ;  1000 points color cycle effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if thousand points bonus bit is off.
   ;
   if !_Bit2_1000_On{2} then goto __Skip_1000_Bonus

   ;```````````````````````````````````````````````````````````````
   ;  Gets the playfield color.
   ;
   on _1000_Counter gosub __1k_Color00 __1k_Color01 __1k_Color02 __1k_Color03 __1k_Color04 __1k_Color05 __1k_Color06 __1k_Color07 __1k_Color08 __1k_Color09 __1k_Color10 __1k_Color11

   ;```````````````````````````````````````````````````````````````
   ;  Slows down the thousand points bonus counter.
   ;
   if _Master_Counter < 3 then goto __Skip_1000_Bonus

   ;```````````````````````````````````````````````````````````````
   ;  Increments the thousand points bonus counter.
   ;
   _1000_Counter = _1000_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips if the thousand bonus counter hasn't reached the end.
   ;
   if _1000_Counter < 12 then goto __Skip_1000_Bonus

   ;```````````````````````````````````````````````````````````````
   ;  Clears the thousand points bonus bit and counter.
   ;
   _Bit2_1000_On{2} = 0 : _1000_Counter = 0

__Skip_1000_Bonus



   ;***************************************************************
   ;
   ;  Reset switch check.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check.
   ;
   if !_Bit1_Auto_Play{1} then goto __AP_Skip_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Starts game during auto-play if reset switch or fire button
   ;  is pressed (also clears auto-play bit).
   ;
   if switchreset || joy0fire then _Bit1_Auto_Play{1} = 0 : goto __Main_Loop_Setup bank1

__AP_Skip_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Turns off reset restainer bit and skips this section if
   ;  reset switch is not pressed.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Skip_Main_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the reset switch hasn't been released
   ;  since it was pressed to start the game.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Skip_Main_Reset

   ;```````````````````````````````````````````````````````````````
   ;  Clears the game over bit so the title screen will appear.
   ;
   _Bit0_Game_Control{0} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the game over setup section and checks for a high
   ;  score, then jumps to the title screen.
   ;
   goto __Game_Over_Setup bank5

__Skip_Main_Reset



   ;***************************************************************
   ;
   ;  Game Over Check
   ;
   ;  _Bit0_Game_Control{0} controls when the game ends.
   ;
   ;  0 = Game not over.
   ;  1 = Game over.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if game control bit is off.
   ;
   if !_Bit0_Game_Control{0} then goto __Skip_Check_G_Over

   ;```````````````````````````````````````````````````````````````
   ;  Auto-play check. Puts score back to current score and jumps
   ;  back to the title screen if auto-play bit is on.
   ;
   if _Bit1_Auto_Play{1} then _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem : goto __Title_Screen_Setup bank1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to game over set up.
   ;
   goto __Game_Over_Setup bank5

__Skip_Check_G_Over



   ;***************************************************************
   ;
   ;  Pause check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __AP_Skip_Pause

   ;```````````````````````````````````````````````````````````````
   ;  Checks current position of COLOR/BW switch.
   ;
   _Bit1_Pause_Check{1} = 0

   if switchbw then _Bit1_Pause_Check{1} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Compares bits to see if COLOR/BW switch has moved.
   ;  The game is paused if the switch has moved.
   ;
   if _Bit0_Pause_Position{0} then if !_Bit1_Pause_Check{1} then goto __Pause_Setup bank1

   if !_Bit0_Pause_Position{0} then if _Bit1_Pause_Check{1} then goto __Pause_Setup bank1

   ;```````````````````````````````````````````````````````````````
   ;  Pauses game if fire button of second joystick is pressed.
   ;
   if joy1fire && !_Bit1_FireB_Restrainer{1} then goto __Pause_Setup bank1

__AP_Skip_Pause



   ;***************************************************************
   ;
   ;  Skips sound check if auto-play is on.
   ;
   if _Bit1_Auto_Play{1} then goto __Main_Loop bank2



   ;***************************************************************
   ;
   ;  Channel 0 Sound Effects  -27-
   ;
   ;  Sound effect check for channel 0.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 0 sounds if no ch. 0 sound effect is on.
   ;
   if !_Ch0_Sound then goto __ML_Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sections if duration counter is greater
   ;  than zero.
   ;
   if _Ch0_Duration > 0 then goto __ML_Skip_Ch_0



   ;***************************************************************
   ;
   ;  Torpedo hitting seaweed sound 01.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch0_Sound <> _c_Torp_Hit_Seaweed_01 then goto __Skip_Sound_Torpedo_Hit

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_M_Hit[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_M_Hit[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_M_Hit[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_M_Hit[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __ML_Skip_Ch_0

__Skip_Sound_Torpedo_Hit



   ;***************************************************************
   ;
   ;  Ship ouch sound. 
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch0_Sound <> _c_Ship_Bounce then goto __Skip_Sound_Ship_Ouch

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Ouch[_Ch0_Counter]
   
   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Ouch[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Ouch[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration= _SD_Ouch[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __ML_Skip_Ch_0

__Skip_Sound_Ship_Ouch



   ;***************************************************************
   ;
   ;  Torpedo hitting seaweed sound 01.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch0_Sound <> _c_Shoot then goto __Skip_Sound_Effect_Torpedo_Shoot

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves channel 0 data and increments counter.
   ;
   temp4 = _SD_Shoot[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_Shoot[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __ML_Skip_Ch_0

__Skip_Sound_Effect_Torpedo_Shoot



   ;***************************************************************
   ;
   ;  Torpedo hitting seaweed sound 02.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch0_Sound <> _c_Torp_Hit_Seaweed_02 then goto __Skip_Sound_Effect_Torpedo_Hit_02

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_M_H_02[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_M_H_02[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_M_H_02[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_M_H_02[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __ML_Skip_Ch_0

__Skip_Sound_Effect_Torpedo_Hit_02



   ;***************************************************************
   ;
   ;  1000 health sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch0_Sound <> _c_1000_Health then goto __Skip_Sound_Effect_1000_Health
   
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_1000_Health[_Ch0_Counter]
   
   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_1000_Health[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_1000_Health[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch0_Duration = _SD_1000_Health[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __ML_Skip_Ch_0

__Skip_Sound_Effect_1000_Health



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __ML_Skip_Ch_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__ML_Clear_Ch_0

   _Ch0_Duration = 1
   
   _Ch0_Sound = 0 : _Ch0_Counter = 0 : AUDV0 = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__ML_Skip_Ch_0



   ;***************************************************************
   ;
   ;  Channel 1 Sound Effects  -28-
   ;
   ;  Sound effect check for channel 1.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 1 sounds if no ch. 1 sound effect is on.
   ;
   if !_Ch1_Sound then goto __ML_Skip_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Decreases channel 1 duration counter.
   ;
   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 1 sections if duration counter is greater
   ;  than zero.
   ;
   if _Ch1_Duration > 0 then goto __ML_Skip_Ch_1



   ;***************************************************************
   ;
   ;  Seaweed tentacle reaching up sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Tentacle_Reaching_Up then goto __Skip_Sound_Effect_Tent_Reach
   
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Grab[_Ch1_Counter]
   
   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Grab[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Grab[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Grab[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Tent_Reach



   ;***************************************************************
   ;
   ;  Manatee drop in sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Ship_Drop_In then goto __Skip_Sound_Effect_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Ship_Drop_In[_Ch1_Counter]
   
   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Ship_Drop_In[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Ship_Drop_In[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Ship_Drop_In[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Drop



   ;***************************************************************
   ;
   ;  Health canister touched sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Canister_Touched then goto __Skip_Sound_Effect_Canister_Touch

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Bonus_Get[_Ch1_Counter]
   
   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Bonus_Get[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Bonus_Get[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration= _SD_Bonus_Get[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Canister_Touch



   ;***************************************************************
   ; 
   ;  Health canister dropped sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Canister_Appear then goto __Skip_Sound_Effect_Canister_Drop

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Health_Can[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Health_Can[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Health_Can[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration= _SD_Health_Can[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Canister_Drop



   ;***************************************************************
   ;
   ;  Wrothopod on the way sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Wrothopod then goto __Skip_Sound_Effect_Wroth_Coming

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Wroth[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Wroth[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Wroth[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Wroth[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Wroth_Coming



   ;***************************************************************
   ;
   ;  Corroded canister tick down sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Corroded_Tick_Down then goto __Skip_Sound_Effect_Corroded_Tick_Down

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Corroded_Tick_Down[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Corroded_Tick_Down[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Corroded_Tick_Down[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Corroded_Tick_Down[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Corroded_Tick_Down



   ;***************************************************************
   ;
   ;  Corroded seaweed moosh sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Corroded_Seaweed_Moosh then goto __Skip_Sound_Effect_Corroded_Seaweed_Moosh

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Corroded_Seaweed_Moosh[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Corroded_Seaweed_Moosh[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Corroded_Seaweed_Moosh[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Corroded_Seaweed_Moosh[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Corroded_Seaweed_Moosh



   ;***************************************************************
   ;
   ;  Corroded canister hit ship sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Corroded_Hit_Ship then goto __Skip_Sound_Effect_Corroded_Hit_Ship

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Corroded_Hit_Ship[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Corroded_Hit_Ship[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Corroded_Hit_Ship[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Corroded_Hit_Ship[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Corroded_Hit_Ship



   ;***************************************************************
   ;
   ;  Corroded chase sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the sound isn't on. 
   ;
   if _Ch1_Sound <> _c_Corroded_Chase then goto __Skip_Sound_Effect_Corroded_Chase

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Corroded_Chase[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __ML_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Corroded_Chase[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Corroded_Chase[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Corroded_Chase[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __ML_Skip_Ch_1

__Skip_Sound_Effect_Corroded_Chase



   ;***************************************************************
   ;
   ;  Jumps to end of channel 1 area. (This catches any mistakes.)
   ;
   goto __ML_Skip_Ch_1



   ;***************************************************************
   ;
   ;  Clears channel 1.
   ;
__ML_Clear_Ch_1

   _Ch1_Duration = 1
   
   _Ch1_Sound = 0 : _Ch1_Counter = 0 : AUDV1 = 0



   ;***************************************************************
   ;
   ;  End of channel 1 area.
   ;
__ML_Skip_Ch_1
   

   goto __Main_Loop bank2





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  End of third section of main loop.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  1000 bonus color data for playfield.
   ;
__1k_Color00

   pfcolors:
   $AE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color01

   pfcolors:
   $AE
   $AE
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color02

   pfcolors:
   $CE
   $AE
   $AE
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color03

   pfcolors:
   $CE
   $CC
   $CC
   $AE
   $AE
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color04

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $AE
   $AE
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color05

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $AE
   $AE
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color06

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $AE
   $AE
   $C6
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color07

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $AE
   $AE
   $C4
   $C4
   $C4
end

   return thisbank


__1k_Color08

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $AE
   $A6
   $C4
   $C4
end

   return thisbank


__1k_Color09

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $AC
   $AE
   $C4
end

   return thisbank


__1k_Color10

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $AE
   $C4
end

   return thisbank


__1k_Color11

   pfcolors:
   $CE
   $CC
   $CC
   $CA
   $CA
   $C8
   $C8
   $C6
   $C6
   $C4
   $C4
   $C4
end

   return thisbank




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data starts here.  -29-
   ;
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for torpedo hitting seaweed 01.
   ;
   data _SD_M_Hit
   8,6,1
   1
   8,6,2
   1
   6,6,1
   1
   8,6,3
   1
   5,6,0
   1
   7,6,4
   1
   7,6,5
   1
   7,6,6
   1
   6,6,7
   1
   6,6,8
   1
   6,6,9
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Torpedo hitting seaweed 02.
   ;
   data _SD_M_H_02
   8,6,30
   1
   8,6,31
   1
   6,6,0
   1
   8,6,1
   1
   8,6,2
   1
   8,6,3
   1
   8,6,4
   1
   8,6,5
   1
   8,6,6
   1
   7,6,7
   1
   7,6,8
   1
   6,6,9
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Ship ouch.
   ;
   data _SD_Ouch
   8,12,17
   1
   8,12,18
   1
   8,12,17
   1
   8,12,19
   1
   8,12,17
   1
   8,12,20
   1
   8,12,21
   1
   8,12,22
   1
   8,12,23
   1
   8,12,24
   1
   6,12,25
   1
   4,12,26
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Torpedo shoot.
   ;
   data _SD_Shoot
   8,14,0
   1
   8,14,1
   1
   8,14,0
   1
   8,14,2
   1
   8,14,1
   1
   7,14,3
   1
   6,14,2
   1
   5,14,4
   1
   4,14,3
   1
   3,14,5
   1
   2,14,4
   4
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for seaweed tentacle .
   ;
   data _SD_Grab
   2,14,5
   1
   14,14,5
   8
   2,14,5
   8

   2,14,3
   1
   14,14,3
   12
   2,14,3
   8

   2,14,4
   1
   14,14,4
   12
   2,14,4
   24
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Wrothopod coming.
   ;
   data _SD_Wroth
   6,4,18
   1
   8,4,20
   1
   8,4,19
   1
   8,4,21
   1
   8,4,20
   1
   8,4,22
   1
   6,4,21
   1

   8,4,17
   1
   8,4,18
   1
   8,4,17
   1
   8,4,19
   1
   7,4,18
   1
   7,4,20
   1
   7,4,19
   1
   7,4,21
   1
   6,4,20
   1
   6,4,22
   1
   6,4,21
   1
   6,4,23
   1
   5,4,22
   1
   5,4,24
   1
   5,4,23
   1
   5,4,25
   1
   4,4,24
   1
   4,4,26
   1
   4,4,25
   1
   4,4,27
   1
   3,4,26
   1
   3,4,28
   1
   3,4,27
   1
   3,4,29
   1
   2,4,28
   1
   2,4,30
   1
   1,4,31
   1
   1,4,30
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Manatee drop in.
   ;
   data _SD_Ship_Drop_In
   12,6,30
   1
   9,14,31
   1
   9,14,0
   1
   8,6,1
   1
   6,6,2
   1
   3,6,3
   1
   3,6,4
   1
   3,6,3
   1
   2,6,5
   1
   1,6,6
   1
   12,6,7
   1
   12,6,8
   1
   11,6,9
   1
   9,6,10
   1
   6,6,11
   1
   6,6,12
   1
   5,6,13
   1
   3,6,14
   1
   4,6,13
   1
   4,6,12
   1
   4,6,11
   1
   4,6,10
   1
   5,6,9
   1
   5,6,8
   1
   5,6,7
   1
   5,6,6
   1
   5,6,7
   1
   6,6,5
   1
   6,6,4
   1
   6,6,5
   1
   6,6,3
   1
   6,6,2
   1
   7,6,1
   1
   7,14,0
   1
   7,14,31
   1
   2,14,31
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for 1,000 health.
   ;
   data _SD_1000_Health
   8,8,26
   1
   8,8,25
   1
   8,8,26
   1
   8,8,24
   1
   8,8,25
   1
   8,8,23
   1
   8,8,24
   1
   8,8,22
   1
   8,8,23
   1
   8,8,21
   1
   8,8,22
   1
   8,8,20
   1
   8,8,21
   1
   8,8,19
   1
   8,8,20
   1
   8,8,18
   1
   8,8,19
   1
   8,8,17
   1
   8,8,18
   1
   8,8,16
   1
   8,8,17
   1
   8,8,15
   1
   8,8,16
   1
   8,8,14
   1
   8,8,15
   1
   8,8,13
   1
   8,8,14
   1
   8,8,12
   1
   8,8,13
   1
   8,8,11
   1
   8,8,12
   1
   8,8,10
   1
   8,8,11
   1
   8,8,9
   1
   8,8,10
   1
   8,8,8
   1
   8,8,9
   1
   8,8,7
   1
   8,8,8
   1
   8,8,6
   1
   8,8,7
   1
   8,8,5
   1
   8,8,6
   1
   8,8,4
   1
   8,8,5
   1
   8,8,3
   1
   8,8,4
   1
   8,8,2
   1
   8,8,3
   1
   8,8,1
   1
   8,8,2
   1
   8,8,0
   1
   8,8,1
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Health Canister touched.
   ;
   data _SD_Bonus_Get
   8,6,29
   1
   6,6,30
   1
   8,6,31
   1
   8,6,0
   1
   8,6,1
   1
   6,6,0
   1
   8,6,2
   1
   8,6,1
   1
   8,6,3
   1
   8,6,2
   1
   7,6,4
   1
   7,6,3
   1
   6,6,5
   1
   6,6,4
   1
   5,6,6
   1
   4,6,5
   1
   4,6,7
   1
   5,6,6
   1
   5,6,5
   1
   6,6,4
   1
   6,6,5
   1
   7,6,3
   1
   7,6,2
   1
   6,6,1
   1
   3,6,2
   1
   2,6,0
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Health Canister dropped.
   ;
   data _SD_Health_Can
   8,4,26
   2
   8,4,26
   2
   1,4,26
   1
   2,4,26
   2
   4,4,26
   2
   2,4,26
   4

   8,4,23
   2
   8,4,23
   2
   1,4,23
   1
   2,4,23
   2
   4,4,23
   2
   2,4,23
   4

   8,4,15
   2
   8,4,15
   2
   1,4,15
   1
   2,4,15
   2
   4,4,15
   2
   2,4,15
   4

   8,4,19
   2
   8,4,19
   2
   1,4,19
   1
   2,4,19
   2
   4,4,19
   2
   2,4,19
   8
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Corroded tick down.
   ;
   data _SD_Corroded_Tick_Down
   0,0,0
   25

   2,12,18
   1
   7,12,18
   1
   4,12,18
   1
   7,12,18
   1
   4,12,18
   6
   2,12,18
   2


   2,12,18
   1
   7,12,18
   1
   4,12,18
   1
   7,12,18
   1
   4,12,18
   6
   2,12,18
   8

   0,0,0
   60

   2,12,18
   1
   7,12,18
   1
   4,12,18
   1
   7,12,18
   1
   4,12,18
   6
   2,12,18
   2


   2,12,18
   1
   7,12,18
   1
   4,12,18
   1
   7,12,18
   1
   4,12,18
   6
   2,12,18
   8
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Corroded seaweed moosh.
   ;
   data _SD_Corroded_Seaweed_Moosh
   2,8,16
   1
   4,8,15
   1
   6,8,16
   1
   8,8,14
   1
   4,8,15
   1
   8,8,13
   1
   4,8,14
   1
   8,8,12
   1
   4,8,11
   1
   8,8,10
   1
   4,8,9
   1
   8,8,8
   1
   7,8,7
   1
   6,8,6
   1
   5,8,5
   1
   4,8,4
   1
   3,8,3
   1
   2,8,2
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Corroded hit ship.
   ;
   data _SD_Corroded_Hit_Ship
   8,8,9
   1
   5,8,10
   1
   8,8,11
   1
   7,8,12
   1
   8,8,13
   1
   5,8,14
   1
   8,8,15
   1
   7,8,16
   1
   8,8,17
   1
   5,8,18
   1
   8,8,19
   1
   7,8,20
   1
   8,8,21
   1
   5,8,22
   1
   8,8,23
   1
   7,8,24
   1
   8,8,25
   1
   5,8,26
   1
   8,8,27
   1
   7,8,28
   1
   4,8,29
   1
   3,8,30
   1
   2,8,31
   1
   2,8,30
   1
   2,8,31
   1
   255
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Corroded chase.
   ;
   data _SD_Corroded_Chase
   2,12,18
   1
   4,12,19
   1
   8,12,15
   1
   8,12,18
   1
   8,12,19
   1
   8,12,15
   1
   8,12,18
   1
   8,12,19
   1
   8,12,15
   1
   8,12,18
   1
   7,12,19
   1
   6,12,15
   1
   5,12,18
   1
   4,12,19
   1
   3,12,15
   1
   2,12,18
   1
   1,12,19
   1

   2,6,28
   1
   4,6,30
   1
   6,6,24
   1
   8,6,28
   1
   10,6,30
   1
   10,6,24
   1
   10,6,28
   1
   8,6,30
   1
   10,6,24
   1
   8,6,28
   1
   7,6,30
   1
   6,6,24
   1
   5,6,28
   1
   4,6,30
   1
   3,6,24
   1
   2,6,28
   1
   1,6,30
   1

   0,0,0
   10
   255
end





   ; Bank 5  -30- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 5
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  GAME OVER SETUP  -31-
   ;
   ;
__Game_Over_Setup


   ;***************************************************************
   ;
   ;  High Score Check
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
   ;  Restarts the game if the reset switch is pressed. Continues
   ;  in the game over setup section if the game ends naturally.
   ;
   if !_Bit0_Game_Control{0} then goto __Start_Restart bank1


   ;***************************************************************
   ;
   ;  Mutes sounds and clear variables.
   ;
   AUDV0=0 : AUDV1=0 : _Ch0_Counter = 0 : _Ch1_Counter = 0 : _Master_Counter = 0 : _Frame_Counter = 0 : _Bit6_Swap_Scores{6} = 0

   _GmOvr_Tmp_x_Fill_Counter = 0 : _GmOvr_Tmp_Frame_Counter = 0 : _GmOvr_Tmp_Tone_Flip_Counter = 0

   _Ch0_Sound = 0 : _GmOvr_Tmp_GOAnim_Counter = 0


   ;***************************************************************
   ;
   ;  Sets up Game Over variables and bits and gets rid of missile.
   ;
   _Ch0_Sound = _c_Game_Over

   _Ch0_Duration = 1 : _Ch1_Duration = 1 : _Bit0_Reset_Restrainer{0} = 1 

   _Bit1_Tmp_Ship_On_Screen{1} = 1 : _Bit6_Homing_Color_Cycle_On{6} = 1

   _Ch1_Sound = _c_GO_Seaweed_Attack : _GmOvr_Tmp_Y_Fill_Counter = 11

   if _Bit3_Easter_Egg{3} then _GmOvr_Tmp_Y_Fill_Counter = 12

   _Homing_Sc_Bck_Cntr = 0 : missile0y = 250


   ;***************************************************************
   ;
   ;  Remembers current score.
   ;
   _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3


   ;***************************************************************
   ;
   ;  Clears pfscore bars.
   ;
   pfscore1 = 0 : pfscore2 = 0


   ;***************************************************************
   ;
   ;  Changes score background color.
   ;
   _SC_Back = $44


   ;***************************************************************
   ;
   ;  Displays canister or a creature.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips to Wrothopod if health canister is not on screen.
   ;
   if !_Bit0_Canister_P1_On{0} then goto __GmOvrSetup_Wroth

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure health canister is red.
   ;
   player1color:
   $4A
   $4E
   $4A
   $46
   $4A
   $4E
end

   ;```````````````````````````````````````````````````````````````
   ;  It was a health canister. Skips to game over loop.
   ;
   goto __Game_Over_Loop

__GmOvrSetup_Wroth

   ;```````````````````````````````````````````````````````````````
   ;  Skips to game over loop if Wrothopod is not on screen.
   ;
   if !_Bit1_Wrothopod_On{1} then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure Wroth is red and changes shape.
   ;
   player1:
   %11111111
   %11111111
   %00111100
   %01111110
   %11111111
   %10111101
   %10100101
   %10100101
end

   player1color:
   $4C
   $4E
   $48
   $4E
   $4C
   $4A
   $48
   $46
end





   ;***************************************************************
   ;
   ;  GAME OVER LOOP  -32-
   ;
   ;
__Game_Over_Loop



   ;***************************************************************
   ;
   ;  Sets Colors and Border
   ;
   ;  Sets sprite color, color of top playfield row,
   ;  background color, and turns on side borders.
   ;
   COLUP0 = $48 : COLUPF = $CE : COLUBK = $80 : PF0 = %11110000



   ;***************************************************************
   ;
   ;  Flips player sprite if necessary.
   ;
   if _Bit3_Flip_P0{3} then REFP0 = 8



   ;***************************************************************
   ;
   ;  20 Second Counter
   ;
   ;  Shows high score every 2 seconds and goes to title screen
   ;  after 20 seconds if player does nothing.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments master counter every frame (60 frames = 1 second).
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if master counter is less than 2 seconds.
   ;
   if _Master_Counter < 120 then goto __Skip_20_Second_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Increments frame counter and clears master counter.
   ;  (One increment = 2 seconds.)
   ;
   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Flips the score swapping bit.
   ;
   _Bit6_Swap_Scores{6} = !_Bit6_Swap_Scores{6}

   ;```````````````````````````````````````````````````````````````
   ;  Restores the current score, resets the game, and goes to the
   ;  title screen if 20 seconds have gone by.
   ;
   ;  0 = Go to title screen.
   ;  1 = Skip title screen and play game.
   ;
   if _Frame_Counter > 9 then _Bit0_Game_Control{0} = 0 : _sc1=_Score1_Mem : _sc2=_Score2_Mem : _sc3=_Score3_Mem: goto __Start_Restart bank1

   ;```````````````````````````````````````````````````````````````
   ;  Skips and displays the current score if swap bit is off.
   ;
   if !_Bit6_Swap_Scores{6} then goto __Skip_GmOver_High_Score_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays high score (blue-green) and skips.
   ;
   scorecolor = $BE

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __Skip_20_Second_Counter

__Skip_GmOver_High_Score_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (yellow).
   ;
   scorecolor = $1C

   _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem 

__Skip_20_Second_Counter



   ;***************************************************************
   ;
   ;  Easter egg screen scroll section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if easter egg bit is turned off.
   ;
   if !_Bit3_Easter_Egg{3} then goto __Skip_Scroll_Screen

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if screen is done scrolling down.
   ;
   if _GmOvr_Tmp_Scroll_Counter < 1 then goto __Skip_Scroll_Screen

   ;```````````````````````````````````````````````````````````````
   ;  Increments the secondary scrolling counter.
   ;
   _GmOvr_Tmp_8_Scroll_Counter = _GmOvr_Tmp_8_Scroll_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Decrements the main scrolling counter if the secondary
   ;  counter reaches 8.
   ;
   if _GmOvr_Tmp_8_Scroll_Counter = 8 then _GmOvr_Tmp_8_Scroll_Counter = 0 : _GmOvr_Tmp_Scroll_Counter = _GmOvr_Tmp_Scroll_Counter - 1

   ;```````````````````````````````````````````````````````````````
   ;  Scrolls the screen down.
   ;
   pfscroll down

   ;```````````````````````````````````````````````````````````````
   ;  Clears the invisible row.
   ;
   w124 = 0 : w125 = 0 : w126 = 0 : w127 = 0

__Skip_Scroll_Screen



   ;***************************************************************
   ;
   ;  Easter egg Gyvolver section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if easter egg bit is turned off.
   ;
   if !_Bit3_Easter_Egg{3} then goto __Skip_Gyvolver

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if screen isn't done scrolling.
   ;
   if _GmOvr_Tmp_Scroll_Counter > 0 then goto __Skip_Gyvolver

   ;```````````````````````````````````````````````````````````````
   ;  Stops moving Gyvolver when it reaches the top of the screen.
   ;
   if player1y < 1 then goto __Skip_Gyvolver

   ;```````````````````````````````````````````````````````````````
   ;  Moves Gyvolver up the screen.
   ;
   _P1_Up_Down = _P1_Up_Down - 0.60

   ;```````````````````````````````````````````````````````````````
   ;  Increments the Gyvolver animation counter.
   ;
   _GmOvr_Tmp_Anim_Counter = _GmOvr_Tmp_Anim_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if the animation counter is less than 4.
   ;  This slows down the Gyvolver animation.
   ;
   if _GmOvr_Tmp_Anim_Counter < 4 then goto __Skip_Gyvolver

   ;```````````````````````````````````````````````````````````````
   ;  Time to update Gyvolver animation. Clears animation counter.
   ;
   _GmOvr_Tmp_Anim_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Sets Gyvolver color.
   ;
   player1color:
   $00
   $42
   $F6
   $C6
   $C8
   $CA
   $FE
   $46
end

   ;```````````````````````````````````````````````````````````````
   ;  Gets the current Gyvolver sprite frame.
   ;
   on _GmOvr_Tmp_Frame_Counter goto __Gy_Anim_00 __Gy_Anim_01 __Gy_Anim_02 __Gy_Anim_03 __Gy_Anim_04 __Gy_Anim_05

__Gy_Anim_Done

   ;```````````````````````````````````````````````````````````````
   ;  Increments the Gyvolver frame counter.
   ;
   _GmOvr_Tmp_Frame_Counter = _GmOvr_Tmp_Frame_Counter + 1

__Skip_Gyvolver



   ;***************************************************************
   ;
   ;  Seaweed Attack
   ;
   ;  Fills Screen from bottom to top, coming in from the sides.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if the easter egg bit is on.
   ;
   if _Bit3_Easter_Egg{3} then goto __Skip_All_GmOver_Pixels
   
   ;```````````````````````````````````````````````````````````````
   ;  Skips section when the screen is full.
   ;
   if _GmOvr_Tmp_x_Fill_Counter > 15 && _GmOvr_Tmp_Y_Fill_Counter > 10 then goto __Skip_Pixel_Fill

   ;```````````````````````````````````````````````````````````````
   ;  Increments the y fill counter.
   ;
   _GmOvr_Tmp_Y_Fill_Counter = _GmOvr_Tmp_Y_Fill_Counter - 1

   ;```````````````````````````````````````````````````````````````
   ;  Puts a playfield pixel on the screen.
   ;
   pfpixel _GmOvr_Tmp_x_Fill_Counter _GmOvr_Tmp_Y_Fill_Counter on

   ;```````````````````````````````````````````````````````````````
   ;  Gets the x fill number in reverse for other side of screen.
   ;
   temp5 = 31 - _GmOvr_Tmp_x_Fill_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Puts a playfield pixel on the other side of screen.
   ;
   pfpixel temp5 _GmOvr_Tmp_Y_Fill_Counter on

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if it's not time to start a new column.
   ;
   if _GmOvr_Tmp_Y_Fill_Counter <> 0 then goto __Skip_Pixel_Fill

   ;```````````````````````````````````````````````````````````````
   ;  Time for a new column.
   ;
   _GmOvr_Tmp_Y_Fill_Counter = 11

   ;```````````````````````````````````````````````````````````````
   ;  Increments the x fill counter.
   ;
   _GmOvr_Tmp_x_Fill_Counter = _GmOvr_Tmp_x_Fill_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Starts seaweed attack sound effect.
   ;
   _Ch1_Sound = _c_GO_Seaweed_Attack

   AUDV0 = 0 : _Ch0_Counter = 0 : _GmOvr_Tmp_Tone_Flip_Counter = 0

__Skip_Pixel_Fill

   ;```````````````````````````````````````````````````````````````
   ;  Grabs 2 random numbers (0 to 31) and (0 to 10).
   ;
   temp5 = (rand&31) : temp6 = (rand&7) + (rand/64)

   ;```````````````````````````````````````````````````````````````
   ;  Puts a random playfield pixel on the screen.
   ;
   pfpixel temp5 temp6 on

__Skip_All_GmOver_Pixels



   ;***************************************************************
   ;
   ;  Makes sound effect for seaweed attack.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if easter egg bit is on.
   ;
   if _Bit3_Easter_Egg{3} then goto __Skip_GmOver_Close_In_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if sound effect isn't turned on.
   ;
   if _Ch1_Sound <> _c_GO_Seaweed_Attack then goto __Skip_GmOver_Close_In_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Sets volume and tone.
   ;
   AUDV0 = 3

   if _Ch1_Counter > 48 then AUDV0 = 4

   if _Ch1_Counter > 96 then AUDV0 = 5

   if _Ch1_Counter > 140 then AUDV0 = 6
   
   if _Ch0_Sound <> _c_Game_Over then AUDV0 = 7

   AUDC0 = 8

   ;```````````````````````````````````````````````````````````````
   ;  Increments flip counter.
   ;
   _GmOvr_Tmp_Tone_Flip_Counter = _GmOvr_Tmp_Tone_Flip_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Changes tone if flip counter value is an odd number.
   ;
   if _GmOvr_Tmp_Tone_Flip_Counter{0} then AUDC0 = 14

   ;```````````````````````````````````````````````````````````````
   ;  Increments frequency counter.
   ;
   _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Turns off sound effect if Counter = 31.
   ;
   if _Ch0_Counter = 31 then AUDV0 = 0 : _Ch1_Sound = 0 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Changes sound frequency.
   ;
   AUDF0 = _Ch0_Counter

__Skip_GmOver_Close_In_Sound



   ;***************************************************************
   ;
   ;  Channel 1 Sound Effects
   ;
   ;  Sound effect check for channel 1.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 1 sounds if no ch. 1 sound effect is on.
   ;
   if !_Ch1_Sound then goto __GO_Skip_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Decreases channel 1 duration counter.
   ;
   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 1 sections if duration counter is greater
   ;  than zero.
   ;
   if _Ch1_Duration > 0 then goto __GO_Skip_Ch_1



   ;***************************************************************
   ;
   ;  End of game sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if game over sound bit is off.
   ;
   if _Ch0_Sound <> _c_Game_Over then goto __GO_Skip_End_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves channel 1 data and increments counter.
   ;
   temp4 = _SD_Over[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __GO_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Over[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Over[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Over[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __GO_Skip_Ch_1

__GO_Skip_End_Sound



   ;***************************************************************
   ;
   ;  Easter egg Gyvolver sound effect. 
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Easter egg bit is off.
   ;
   if !_Bit3_Easter_Egg{3} then goto __GO_Skip_Gyvolver_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if game over sound is on.
   ;
   if _Ch0_Sound = _c_Game_Over then goto __GO_Skip_Gyvolver_Sound
   
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Gyvolver sound bit is off.
   ;
   if _Ch0_Sound <> _c_Gyvolver then goto __GO_Skip_Gyvolver_Sound

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = _SD_Gyvolver[_Ch1_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __GO_Clear_Ch_1

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   _Ch1_Counter = _Ch1_Counter + 1
   temp5 = _SD_Gyvolver[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1
   temp6 = _SD_Gyvolver[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = _SD_Gyvolver[_Ch1_Counter] : _Ch1_Counter = _Ch1_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 1 area.
   ;
   goto __GO_Skip_Ch_1

__GO_Skip_Gyvolver_Sound



   ;***************************************************************
   ;
   ;  Jumps to end of channel 1 area. (This catches any mistakes.)
   ;
   goto __GO_Skip_Ch_1



   ;***************************************************************
   ;
   ;  Clears channel 1.
   ;
__GO_Clear_Ch_1

   AUDV1 = 0 : _Ch0_Sound = 0

   _Ch1_Duration = 1 : _Ch1_Counter = 200



   ;***************************************************************
   ;
   ;  End of channel 1 area.
   ;
__GO_Skip_Ch_1



   ;***************************************************************
   ;
   ;  Lowers seaweed tentacle if it is on the screen.
   ;
   if bally < 200 then bally = bally + 1



   ;***************************************************************
   ;
   ;  Drops Wrothopod or canister if it is on the screen. 
   ;
   if _Bit1_Tmp_Ship_On_Screen{1} && player1y < 200 then _P1_Up_Down = _P1_Up_Down + 0.98



   ;***************************************************************
   ;
   ;  Moves Manatee down if it is still on screen. 
   ;
   if _Bit1_Tmp_Ship_On_Screen{1} then if player0y < 150 then _P0_Up_Down = _P0_Up_Down + 0.80



   ;***************************************************************
   ;
   ;  Easter egg: Gyvolver activation.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Easter egg bit is off.
   ;
   if !_Bit3_Easter_Egg{3} then goto __Skip_Gyvolver_Activation

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if Manatee is on screen or Gyvolver has
   ;  already been activated.
   ;
   if player0y <> 120 then goto __Skip_Gyvolver_Activation

   ;```````````````````````````````````````````````````````````````
   ;  Sets bits/variables, starts sound effect, and places sprites.
   ;
   _Bit1_Tmp_Ship_On_Screen{1} = 0 : _Ch1_Counter = 0

   _Ch0_Sound = _c_Gyvolver : _Ch1_Duration = 1

   player1x = 80 : player1y = 100 : player0y = 150

__Skip_Gyvolver_Activation



   ;***************************************************************
   ;
   ;  Game over message.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if Easter egg bit is on.
   ;
   if _Bit3_Easter_Egg{3} then goto __Skip_Game_Over_Message

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if ship isn't off bottom of screen.
   ;
   if _Bit1_Tmp_Ship_On_Screen{1} && player0y < 100 then goto __Skip_Game_Over_Message

   ;```````````````````````````````````````````````````````````````
   ;  Sets up GAME OVER message (needs to be in the loop).
   ;
   NUSIZ0 = $07 : NUSIZ1 = $07 : REFP0 = 0 : COLUP0 = $44

   ;```````````````````````````````````````````````````````````````
   ;  Moves Game Over sprites up the screen if they aren't in
   ;  position yet and only when the counter is an odd number
   ;  (to slow it down).
   ;
   if player0y > 56 then if _Master_Counter{0} then player0y = player0y - 1 : player1y = player1y - 1

   ;```````````````````````````````````````````````````````````````
   ;  Increments the Game Over animation counter.
   ;
   _GmOvr_Tmp_GOAnim_Counter = _GmOvr_Tmp_GOAnim_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips if the Game Over animation counter is less than 13.
   ;  This slows down the Game Over animation.
   ;
   if _GmOvr_Tmp_GOAnim_Counter < 13 then goto __Skip_Game_Over_Message

   ;```````````````````````````````````````````````````````````````
   ;  Time to update Game Over animation. Clears counter.
   ;
   _GmOvr_Tmp_GOAnim_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Gets the current Game Over sprite frame.
   ;
   on _GmOvr_Tmp_Frame_Counter goto __GOAn_00 __GOAn_01 __GOAn_02 __GOAn_03 __GOAn_04 __GOAn_05

__Game_Over_Anim_Done

   ;```````````````````````````````````````````````````````````````
   ;  Increments the Game Over frame counter.
   ;
   _GmOvr_Tmp_Frame_Counter = _GmOvr_Tmp_Frame_Counter + 1

__Game_Over_Anim_Done_02

   ;```````````````````````````````````````````````````````````````
   ;  Skips the set up after doing it once.
   ;
   if !_Bit1_Tmp_Ship_On_Screen{1} then goto __Skip_Game_Over_Message

   ;```````````````````````````````````````````````````````````````
   ;  Turns off the ship on screen bit.
   ;
   _Bit1_Tmp_Ship_On_Screen{1} = 0

   ;```````````````````````````````````````````````````````````````
   ;  One-time set up for the GAME OVER message.
   ;
   CTRLPF = $21 : player0x = 48 : player0y = 120 : player1x = player0x + 32: player1y = 120

   player1color:
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
   $44
end

   player0:
   %00000000
end

   player1:
   %00000000
end

__Skip_Game_Over_Message



   ;***************************************************************
   ;
   ;  Draw the screen.
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
   ;  Sound data for game over sound effect.
   ;
   data _SD_Over
   8,8,1
   1
   8,14,10
   1
   8,8,2
   1
   8,8,3
   1
   8,14,10
   1
   8,8,4
   1
   8,8,5
   1
   8,14,10
   1
   8,8,6
   1
   8,8,7
   1
   8,14,10
   1
   8,8,8
   1
   8,8,9
   1
   8,14,10
   1
   8,8,10
   1
   8,8,11
   1
   8,14,10
   1
   8,8,12
   1
   8,8,13
   1
   8,14,10
   1
   8,8,14
   1
   8,8,15
   1
   8,14,10
   1
   8,8,16
   1
   8,8,17
   1
   8,14,10
   1
   8,8,18
   1
   8,8,19
   1
   8,14,10
   1
   8,8,20
   1
   8,8,21
   1
   8,14,10
   1
   8,8,22
   1
   8,8,23
   1
   8,14,10
   1
   8,8,24
   1
   8,8,25
   1
   8,14,10
   1
   8,8,26
   1
   8,8,27
   1
   8,14,10
   1
   8,8,28
   1
   8,8,29
   1
   8,14,10
   1
   8,8,30
   1
   8,14,10
   1
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for Gyvolver sound effect.
   ;
   data _SD_Gyvolver
   8,12,17
   2
   2,12,17
   8
   8,12,19
   2
   2,12,19
   8
   8,12,29
   2
   2,12,29
   8
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Gyvolver animation frames.
   ;
   ;
__Gy_Anim_00
   player1:
   %00000000
   %10000010
   %10000010
   %10111010
   %10111110
   %01111100
   %11010110
   %01000100
end
   goto __Gy_Anim_Done


__Gy_Anim_01
   player1:
   %00000000
   %01000100
   %01000100
   %01011100
   %01011100
   %01111100
   %11010110
   %01000100
end
   goto __Gy_Anim_Done


__Gy_Anim_02
   player1:
   %00000000
   %00101000
   %00101000
   %00101000
   %01101100
   %01111100
   %11010110
   %01000100
end
   goto __Gy_Anim_Done


__Gy_Anim_03
   player1:
   %00000000
   %00010000
   %00010000
   %00110000
   %01110100
   %01111100
   %11010110
   %01000100
end
   goto __Gy_Anim_Done


__Gy_Anim_04
   player1:
   %00000000
   %00101000
   %00101000
   %00101000
   %01111000
   %01111100
   %11010110
   %01000100
end
   goto __Gy_Anim_Done


__Gy_Anim_05
   player1:
   %00000000
   %01000100
   %01000100
   %01111100
   %01111100
   %01111100
   %11010110
   %01000100
end

   ;```````````````````````````````````````````````````````````````
   ;  Resets the frame counter.
   ;
   _GmOvr_Tmp_Frame_Counter = 0

   goto __Skip_Gyvolver





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Game Over animation frames.
   ;
   ;
__GOAn_00
   player0:
   %00000010
   %00100010
   %00100101
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %00100101
   %00100000
   %00000000
   %00000000
   %00001010
   %01101010
   %01101010
   %10101010
   %10101110
   %10101110
   %10101010
   %10001010
   %10000100
   %01100100
   %01100000
end

   player1:
   %00001010
   %01101010
   %01101100
   %01001100
   %01001100
   %01101100
   %01101010
   %01001010
   %01001100
   %01101100
   %01100000
   %00000000
   %00000000
   %00000011
   %10001011
   %10001010
   %10001010
   %10001011
   %10101011
   %10101010
   %11011010
   %11011011
   %10001011
   %10001000
end

   goto __Game_Over_Anim_Done


__GOAn_01
   player0:
   %00000000
   %00100010
   %01100111
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %00010101
   %00100101
   %00100000
   %00000000
   %00000000
   %00001010
   %01101010
   %11101010
   %10101010
   %10101010
   %10101110
   %10101110
   %10001010
   %00000000
   %01100100
   %01100100
end

   player1:
   %01001010
   %01101010
   %01101000
   %01001100
   %01001100
   %01101100
   %01101110
   %01001010
   %01001000
   %01101100
   %00100100
   %00000000
   %00000000
   %10000001
   %10001011
   %10001010
   %10001010
   %10001011
   %10101011
   %11101010
   %11011010
   %10011011
   %10001011
   %00001010
end

   goto __Game_Over_Anim_Done


__GOAn_02
   player0:
   %00100000
   %00100010
   %01000011
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %00110101
   %00100101
   %00000100
   %00000000
   %00000000
   %01000010
   %01101010
   %10101010
   %10101010
   %10101010
   %10101110
   %10101110
   %10001010
   %01001000
   %01100100
   %00100100
end

   player1:
   %01100010
   %01101010
   %01101000
   %01001100
   %01101100
   %01101100
   %01101110
   %01001010
   %01101000
   %01101100
   %00101100
   %00000000
   %00000000
   %10000001
   %10001011
   %10001011
   %10001010
   %10101011
   %10101011
   %11001011
   %11011010
   %10011011
   %10001011
   %00001011
end

   goto __Game_Over_Anim_Done


__GOAn_03
   player0:
   %00100000
   %00100010
   %01010010
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %00100101
   %00100101
   %00000101
   %00000000
   %00000000
   %01100000
   %01101010
   %10101010
   %10101010
   %10101010
   %10101110
   %10001110
   %10001010
   %01101010
   %01100100
   %00000100
end

   player1:
   %01100000
   %01101010
   %01001010
   %01001100
   %01101100
   %01101100
   %01001100
   %01001010
   %01101010
   %01101100
   %00001100
   %00000000
   %00000000
   %10001000
   %10001011
   %10001011
   %10001010
   %10101010
   %10101011
   %11011011
   %11011010
   %10001010
   %10001011
   %00000011
end

   goto __Game_Over_Anim_Done


__GOAn_04
   player0:
   %00000000
   %00100010
   %01110110
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %00000101
   %00100101
   %00100001
   %00000000
   %00000000
   %00101000
   %01101010
   %11101010
   %10101010
   %10101010
   %10101110
   %10001110
   %10001010
   %00100010
   %01100100
   %01000100
end

   player1:
   %00101000
   %01101010
   %01001010
   %01001100
   %01101100
   %01101100
   %01001100
   %01001010
   %01101010
   %01101100
   %01000100
   %00000000
   %00000000
   %10001010
   %10001011
   %10001011
   %10001010
   %10001010
   %10101011
   %11111011
   %11011010
   %10001010
   %10001011
   %00000001
end

   goto __Game_Over_Anim_Done


__GOAn_05
   player0:
   %00000010
   %00100010
   %00110100
   %01010101
   %01010101
   %01010101
   %01010101
   %01010101
   %01000101
   %00100101
   %00100001
   %00000000
   %00000000
   %00101000
   %01101010
   %01101010
   %10101010
   %10101110
   %10101110
   %10001010
   %10001010
   %10100110
   %01100100
   %01000000
end

   player1:
   %00101000
   %01101010
   %01101110
   %01001100
   %01101100
   %01101100
   %01101000
   %01001010
   %01101110
   %01101100
   %01100000
   %00000000
   %00000000
   %00001011
   %10001011
   %10001011
   %10001010
   %10001011
   %10101011
   %10111011
   %11011010
   %11001011
   %10001011
   %10000001
end

   ;```````````````````````````````````````````````````````````````
   ;  Resets the frame counter.
   ;
   _GmOvr_Tmp_Frame_Counter = 0

   goto __Game_Over_Anim_Done_02





   ; Bank 6  -33- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 6
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Vblank code routine.  -34-
   ;
__VBLANK_Code

   ;***************************************************************
   ;
   ;  Sets score color, sprite color, color of top playfield row,
   ;  background color, and turns on side borders.
   ;
   if !_Bit1_Auto_Play{1} then scorecolor = 28

   COLUP0 = $0A : COLUBK = $80 : PF0 = %11110000



   ;***************************************************************
   ;
   ;  Increases size of missile.
   ;
   NUSIZ0 = $10



   ;***************************************************************
   ;
   ;  Flips Wrothopod sprite if necessary.
   ;
   if _Bit1_Wrothopod_On{1} && _Bit2_Wroth_Flip{2} then REFP1 = 8



   ;***************************************************************
   ;
   ;  Torpedo movement.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skip this section if the torpedo is not moving.
   ;
   if !_Bit0_Shot_Moving{0} then goto __Done_Shot

   ;```````````````````````````````````````````````````````````````
   ;  Resets for the next shot if the torpedo hits the border.
   ;
   if missile0y < 3 || missile0y > 86 then goto __Border_Hit
   if missile0x < 16 || missile0x > 147 then goto __Border_Hit

   ;```````````````````````````````````````````````````````````````
   ;  Moves the torpedo using the snapshot info to stay on track.
   ;
   if _Bit4_Shot_U_Snapshot{4} then missile0y = missile0y - 2
   if _Bit5_Shot_D_Snapshot{5} then missile0y = missile0y + 2
   if _Bit6_Shot_L_Snapshot{6} then missile0x = missile0x - 2
   if _Bit7_Shot_R_Snapshot{7} then missile0x = missile0x + 2

   goto __Done_Shot

__Border_Hit

   ;```````````````````````````````````````````````````````````````
   ;  Border has been hit. Resets for the next shot.
   ;
   _Bit0_Shot_Moving{0}=0 : missile0y=200

   _Bitop_Misc_Snapshot = _Bitop_Misc_Snapshot & %00001111

__Done_Shot



   ;***************************************************************
   ;
   ;  Manatee gets health color change.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if Manatee is hurt.
   ;
   if _Bit4_Manatee_Hurt_Color{4} then goto __Skip_Health_Color

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if health color bit is off.
   ;
   if !_Bit5_Manatee_Health_Color{5} then goto __Skip_Health_Color

   ;```````````````````````````````````````````````````````````````
   ;  Changes Manatee color based on counter value.
   ;
   if _Manatee_Health_Counter < 6 then COLUP0 = $AE

   if _Manatee_Health_Counter > 5 && _Manatee_Health_Counter < 11 then COLUP0 = $AA

   if _Manatee_Health_Counter > 10 && _Manatee_Health_Counter < 16 then COLUP0 = $A6

   if _Manatee_Health_Counter > 15 && _Manatee_Health_Counter < 21 then COLUP0 = $A4
   
   ;```````````````````````````````````````````````````````````````
   ;  Increments health counter.
   ;
   _Manatee_Health_Counter = _Manatee_Health_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears counter and health bit if counter limit reached.
   ;
   if _Manatee_Health_Counter > 20 then _Bit5_Manatee_Health_Color{5} = 0 : _Manatee_Health_Counter = 0

__Skip_Health_Color



   ;***************************************************************
   ;
   ;  Manatee gets hurt color change.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if hurt color bit is off.
   ;
   if !_Bit4_Manatee_Hurt_Color{4} then goto __Skip_Hurt_Color

   ;```````````````````````````````````````````````````````````````
   ;  Changes color of Manatee.
   ;
   COLUP0 = $48

   ;```````````````````````````````````````````````````````````````
   ;  Increments hurt counter.
   ;
   _Manatee_Hurt_Counter = _Manatee_Hurt_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears counter and hurt bit if counter limit reached.
   ;
   if _Manatee_Hurt_Counter > 15 then _Bit4_Manatee_Hurt_Color{4} = 0 : _Manatee_Hurt_Counter = 0

__Skip_Hurt_Color



   ;***************************************************************
   ;
   ;  Seaweed replication.
   ;
   ;  Places a random playfield pixel on the screen.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Slows this section down a bit.
   ;
   if _Level_Counter < _Plop_Timer then goto __Skip_Pixel_Plop

   ;```````````````````````````````````````````````````````````````
   ;  Clears level counter.
   ;
   _Level_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  1 XOR 3 = 2. 2 XOR 3 = 1
   ;
   _Plop_Timer = _Plop_Timer ^ 3

   ;```````````````````````````````````````````````````````````````
   ;  Sets plop timer if seaweed replication counter = 1.
   ;
   if _Plop_Rate = 1 then _Plop_Timer = 1

   ;```````````````````````````````````````````````````````````````
   ;  Decides if a playfield pixel gets placed.
   ;
   temp6 = (rand&1)

   if temp6 = 0 then temp5 = (rand/16)

   if temp6 = 1 then temp5 = (rand&15)

   if temp5 > _Plop_Rate then goto __Skip_Pixel_Plop

   ;```````````````````````````````````````````````````````````````
   ;  Gets random numbers for playfield.
   ;
   ;  (rand&31) = 0 to 31
   ;  (rand&7) = 0 to 7
   ;  (rand/64) = 0 to 3
   ;
   temp5 = (rand&31) : temp6 = (rand&7) + (rand/64)

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Player0 check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Converts player0x position to playfield position.
   ;  The 'temp3 > 200' part checks to see if it's a
   ;  negative number.
   ;
   temp3 = ((player0x - 17)/4) - 5 : if temp3 > 200 then temp3 = 0
   temp4 = temp3 + 12

   ;```````````````````````````````````````````````````````````````
   ;  Converts player0y position to playfield position.
   ;  The 'temp1 > 200' part checks to see if it's a
   ;  negative number.
   ;
   temp1 = ((player0y - 7)/8) - 2 : if temp1 > 200 then temp1 = 0
   temp2 = temp1 + 5

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if pixel would go on top of Corroded canister.
   ;
   if _Bit2_Corrdd_Can_On{2} then if _Corrdd_X_Shot_Mem = temp5 && _Corrdd_Y_Shot_Mem = temp6 then goto __Skip_Pixel_Plop

   ;```````````````````````````````````````````````````````````````
   ;  Places pixel only if pixel will not land on player.
   ;
   if temp5 < temp3 || temp5 > temp4 then goto __Plop_Pixel

   if temp6 < temp1 || temp6 > temp2  then goto __Plop_Pixel

   goto __Skip_Pixel_Plop

__Plop_Pixel

   ;```````````````````````````````````````````````````````````````
   ;  Places the playfield pixel (bit of seaweed).
   ;
   pfpixel temp5 temp6 on

__Skip_Pixel_Plop


   goto __Skip_Vblank_01 bank8





   ; Bank 7  -35- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 7
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ; Bank 8  -36- ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   bank 8
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;***************************************************************
   ;
   ;  LAST BANK
   ;  
   ;  Graphics will be automatically placed in the last bank no
   ;  matter where you define them. If you have a lot of graphics,
   ;  you may not have much room here for code. Visual batari Basic
   ;  shows the ROM space you have left under the Messages tab
   ;  whenever you compile a game, so you'll always know the
   ;  remaining ROM space in each bank.
   ;
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Vblank section.  -37-
   ;
   vblank

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if first vblank bit is off.
   ;
   if !_Bit7_Vblank01{7} then goto __Skip_Vblank_01

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to first vblank code.
   ;
   goto __VBLANK_Code bank6

__Skip_Vblank_01

   ;```````````````````````````````````````````````````````````````
   ;  Clears first vblank bit.
   ;
   _Bit7_Vblank01{7} = 0

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Second vblank section.
   ;
   ;  Skips ahead if second vblank bit is off.
   ;
   if !_Bit7_Vblank02{7} then goto __Skip_Second_Vblank

   ;```````````````````````````````````````````````````````````````
   ;  Changes color of score background.
   ;
   if _Seaweed_Shot = 20 then _SC_Back = $C6

   if _Seaweed_Shot = 40 then _SC_Back = $C4

   if _Seaweed_Shot = 60 then _SC_Back = $C2

   if _Seaweed_Shot = 80 then _SC_Back = $C0

__Skip_Second_Vblank

   ;```````````````````````````````````````````````````````````````
   ;  Clears second vblank bit.
   ;
   _Bit7_Vblank02{7} = 0

   return




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Score background color code from RevEng.
   ;
   asm
minikernel
   sta WSYNC
   lda _SC_Back
   sta COLUBK
   rts
end
