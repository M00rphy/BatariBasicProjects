   ;***************************************************************
   ;
   ;  Repetition Restrainer for the Fire Button
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
   ;  This example program disables rapid-fire using a bit instead
   ;  of wasting a variable. Press the fire button to shoot the
   ;  missile. The fire button must be released and pressed to
   ;  shoot the missile again. This is used for games where you do
   ;  not want rapid-fire. A slightly edited version of this can
   ;  be used to keep a button press in a title screen section
   ;  or a game over section from contaminating another part of
   ;  your game. For example, you don't want a title screen
   ;  button press to count as a button press in the actual game.
   ;  A similar thing can be done for the reset switch.
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
   ;  All-purpose bits for various jobs.
   ;
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Missile0_Moving = y





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
   ;  Clears all normal variables (fastest way).
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = 0


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
   ;  Sets up missile0 position and height.
   ;
   missile0x = 85
   missile0y = 85
   missile0height = 4





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets score color and missile0 color.
   ;
   scorecolor = $1A : COLUP0 = $0C



   ;***************************************************************
   ;
   ;  Fire button check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Turns off restrainer bit and skips this section if button is
   ;  not pressed.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if button hasn't been released after
   ;  being pressed.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on restrainer bit for fire button and turns on
   ;  missile movement bit.
   ;
   _Bit1_FireB_Restrainer{1} = 1 : _Bit2_Missile0_Moving{2} = 1

__Skip_Fire



   ;***************************************************************
   ;
   ;  Missile0 movement check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if missile is not moving.
   ;
   if !_Bit2_Missile0_Moving{2} then goto __Skip_Missile0_Movement

   ;```````````````````````````````````````````````````````````````
   ;  Moves missile up the screen by 2 pixels.
   ;
   missile0y = missile0y - 2

   ;```````````````````````````````````````````````````````````````
   ;  Resets missile position and clears missile movement bit if
   ;  the missile moves off the screen.
   ;
   if missile0y > 250 then _Bit2_Missile0_Moving{2} = 0 : missile0y = 85

__Skip_Missile0_Movement



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
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of main loop if the reset switch hasn't
   ;  been released after being pressed.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Restarts the program.
   ;
   goto __Start_Restart