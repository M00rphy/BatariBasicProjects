   ;***************************************************************
   ;
   ;  Save High Score
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
   ;  Instructions:
   ;  
   ;  Move the joystick to increase the score. Press the fire
   ;  button to end the fake game and the score will flip
   ;  between the current score and the high score every 2
   ;  seconds on the game over screen. Press the fire button or
   ;  reset switch to go back to the fake game.
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
   ;  Temporary variable used for auto-play in the main loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with auto-play.
   ;
   dim _AP_2_Sec_Score_Flip = k

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
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Game_Control = y
   dim _Bit3_Auto_Play = y
   dim _Bit6_Swap_Scores = y

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
   ;  Clears 21 of the normal 26 variables (fastest way using asm).
   ;  Do not clear v, w, x, y, or z in this program. The variables
   ;  v through x remember the high score. The variable y holds a
   ;  bit that should not be cleared. The variable z is used for
   ;  random numbers in this program and clearing it would mess
   ;  up those random numbers.
   ;
   asm
   LDA #0
   STA a
   STA b
   STA c
   STA d
   STA e
   STA f
   STA g
   STA h
   STA i
   STA j
   STA k
   STA l
   STA m
   STA n
   STA o
   STA p
   STA q
   STA r
   STA s
   STA t
   STA u
end


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
   ;  Game control bit tells program where to go.
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
   ;  Sets title screen playfield pixel color.
   ;
   COLUPF = $2C



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
   ;  Sets background color.
   ;
   COLUBK = $80


   ;***************************************************************
   ;
   ;  Sets score color.
   ;
   scorecolor = $AE


   ;***************************************************************
   ;
   ;  Sets up the main loop playfield.
   ;
   playfield:
   ................................
   ................................
   ................................
   .XXXXXX.XXXXXX.XXXXXXXXXX.XXXXX.
   .XX.....XX..XX.XX..XX..XX.XX....
   .XX.XXX.XXXXXX.XX..XX..XX.XXXX..
   .XX..XX.XX..XX.XX..XX..XX.XX....
   .XXXXXX.XX..XX.XX..XX..XX.XXXXX.
   ................................
   ................................
   ................................
end


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
   ;  Sets up the score swap, clears the swap bit, sets background
   ;  color, and draws auto-play screen.
   ;
   _Score1_Mem = _sc1 : _Score2_Mem = _sc2 : _Score3_Mem = _sc3

   _Bit6_Swap_Scores{6} = 0 : COLUBK = $30

   playfield:
   ..XXXXXX.XX..XX.XXXXXX.XXXXXX...
   ..XX..XX.XX..XX...XX...XX..XX...
   ..XXXXXX.XX..XX...XX...XX..XX...
   ..XX..XX.XX..XX...XX...XX..XX...
   ..XX..XX.XXXXXX...XX...XXXXXX...
   ................................
   ..XXXXXX.XX.....XXXXXX.XX..XX...
   ..XX..XX.XX.....XX..XX.XX..XX...
   ..XXXXXX.XX.....XXXXXX.XXXXXX...
   ..XX.....XX.....XX..XX...XX.....
   ..XX.....XXXXXX.XX..XX...XX.....
end

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
   ;  Sets playfield pixel color.
   ;
   COLUPF = $9A



   ;***************************************************************
   ;
   ;  Auto-play playfield pixel color.
   ;
   if _Bit3_Auto_Play{3} then COLUPF = $3A



   ;***************************************************************
   ;
   ;  Slows down the joystick and adds 10 to the score if the
   ;  joystick is moved.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips ahead if auto-play is off.
   ;
   if !_Bit3_Auto_Play{3} then goto __AP_Skip_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if master counter is less than 2 seconds.
   ;  The master counter resets every 2 seconds (60 + 60 = 120).
   ;
   if _Master_Counter < 120 then goto __Skip_Joystick_Check

   ;```````````````````````````````````````````````````````````````
   ;  Increments frame counter and clears master counter.
   ;  (One increment = 2 seconds.)
   ;
   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Ends auto-play if 10 seconds have gone by.
   ;
   if _Frame_Counter > 4 then _Bit2_Game_Control{2} = 1

   goto __Skip_Joystick_Check

__AP_Skip_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Skip this section if the counter is less than 8.
   ;
   if _Master_Counter < 8 then goto __Skip_Joystick_Check

   ;```````````````````````````````````````````````````````````````
   ;  Clears the counter.
   ;
   _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Adds 10 points to the score if joystick is moved.
   ;
   if !joy0up && !joy0down && !joy0left && !joy0right then goto __Skip_Joystick_Check

   score = score + 10

__Skip_Joystick_Check



   ;***************************************************************
   ;
   ;  Fire button section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Clears the restrainer bit and skips this section if the fire
   ;  button is not pressed.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Done_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if the fire button hasn't been released
   ;  since starting.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Done_Fire

   ;```````````````````````````````````````````````````````````````
   ;  For this example, the fire button ends the program.
   ;
   _Bit2_Game_Control{2} = 1

__Done_Fire



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
   ;  Displays high score (yellow) and skips rest of section.
   ;
   scorecolor = $1C

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __AP_Skip_Flip

__AP_Skip_HiScore_Swap

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (blue).
   ;
   scorecolor = $AE

   _sc1 = _Score1_Mem : _sc2 = _Score2_Mem : _sc3 = _Score3_Mem

__AP_Skip_Flip



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
   ;  Sets up GAME OVER playfield.
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
   ;  Displays high score (yellow) and skips rest of section.
   ;
   scorecolor = $1C

   _sc1 = _High_Score1 : _sc2 = _High_Score2 : _sc3 = _High_Score3

   goto __Skip_20_Second_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Displays current score (blue).
   ;
__GO_Current_Score

   scorecolor = $AE

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
   goto __Start_Restart