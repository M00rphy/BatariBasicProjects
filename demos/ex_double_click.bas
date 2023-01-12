   ;***************************************************************
   ;
   ;  Double Click
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
   ;  Double click the fire button on the left joystick to change
   ;  the background color.
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
   ;  Color change variable.
   ;
   dim _Color_Change = q

   ;```````````````````````````````````````````````````````````````
   ;  Timer for double click.
   ;
   dim _Timer = r

   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_1st_Click = y
   dim _Bit2_2nd_Click = y
   dim _Bit3_Finish_Double_Click = y



   ;***************************************************************
   ;
   ;  Disables the score. (We don't need it in this program.)
   ;
   const noscore = 1



   ;***************************************************************
   ;
   ;  Double click speed (how much time you have between clicks).
   ;  [The c stands for constant.]
   ;
   const _c_Double_Click_Speed = 15





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
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Sets starting color.
   ;
   _Color_Change = $0C


   ;***************************************************************
   ;
   ;  Turns off double click timer (200 = off).
   ;
   _Timer = 200





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = _Color_Change



   ;***************************************************************
   ;
   ;  Timer section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if timer is off (200 = off).
   ;
   if _Timer = 200 then goto __Skip_Timer

   ;```````````````````````````````````````````````````````````````
   ;  Increases the timer.
   ;
   _Timer = _Timer + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips rest of section if timer is not at the limit.
   ;
   if _Timer < _c_Double_Click_Speed then goto __Skip_Timer

   ;```````````````````````````````````````````````````````````````
   ;  Time ran out! Turns off timer and clears double click bits.
   ;
   _Timer = 200

   _Bit1_1st_Click{1} = 0 : _Bit2_2nd_Click{2} = 0 : _Bit3_Finish_Double_Click{3} = 0

__Skip_Timer



   ;***************************************************************
   ;
   ;  Double click section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Fire button ON subsection.
   ;
   ;  Skips subsection if fire button is off or finish bit is on.
   ;
   if !joy0fire || _Bit3_Finish_Double_Click{3} then goto __Skip_DC_Fire_01

   ;```````````````````````````````````````````````````````````````
   ;  First click check (fire button ON).
   ;
   ;  If 2nd click bit is OFF and 1st click bit is OFF, turns on
   ;  the 1st click bit and restarts the timer.
   ;
   if !_Bit2_2nd_Click{2} && !_Bit1_1st_Click{1} then _Bit1_1st_Click{1} = 1 : _Timer = 0

   ;```````````````````````````````````````````````````````````````
   ;  Second click check (fire button ON).
   ;
   ;  If the 2nd click bit is ON, clears the 2nd click bit, turns
   ;  on the finish bit and restarts the timer.
   ;
   if _Bit2_2nd_Click{2} then _Bit2_2nd_Click{2} = 0 : _Bit3_Finish_Double_Click{3} = 1 : _Timer = 0

__Skip_DC_Fire_01

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Fire button OFF subsection.
   ;
   ;  Skips subsection if fire button is on.
   ;
   if joy0fire then goto __Skip_DC_Fire_02

   ;```````````````````````````````````````````````````````````````
   ;  First click done check (fire button OFF).
   ;
   ;  If 1st click bit is ON, clears the 1st click bit, turns on
   ;  the 2nd click bit, and restarts the timer.
   ;
   if _Bit1_1st_Click{1} then _Bit1_1st_Click{1} = 0 : _Bit2_2nd_Click{2} = 1 : _Timer = 0

   ;```````````````````````````````````````````````````````````````
   ;  Double click finish check (fire button OFF).
   ; 
   ;  If finish bit is OFF, skips finish of double click.
   ;
   if !_Bit3_Finish_Double_Click{3} then goto __Skip_DC_Fire_02

   ;```````````````````````````````````````````````````````````````
   ;  Finish bit is on, so the it's the end of the double click.
   ;
   ;  Turns off the double click bits and turns off the timer.
   ;
   _Bit3_Finish_Double_Click{3} = 0 : _Bit1_1st_Click{1} = 0 : _Bit2_2nd_Click{2} = 0 : _Timer = 200

   ;```````````````````````````````````````````````````````````````
   ;  Changes background color. (Replace this color change with
   ;  whatever you need done with a double click.)
   ;
   _Color_Change = _Color_Change + $10

__Skip_DC_Fire_02



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
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If reset switch hasn't been released after being pressed,
   ;  program jumps to beginning of main loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset pressed correctly, so the the program is restarted.
   ;
   goto __Start_Restart