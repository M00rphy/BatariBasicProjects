   ;***************************************************************
   ;
   ;  Move a Sprite With Smooth Slide
   ;
   ;  Example program by Lillapojkenpaon and adapted by Duane Alan
   ;  Hahn (Random Terrain) using hints, tips, code snippets, and
   ;  more from AtariAge members such as batari, SeaGtGruff,
   ;  RevEng, Robert M, Nukey Shay, Atarius Maximus, jrok,
   ;  supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Instructions:
   ;  
   ;  Use the joystick to move the sprite. Stop moving the sprite
   ;  to watch it slide.
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
   ;  Player0 fractional values for smoother movement.
   ;
   dim _P0x = player0x.a
   dim _P0y = player0y.b

   ;```````````````````````````````````````````````````````````````
   ;  Speed variables (fractional values for smoother movement).
   ;
   dim _P0xSpeed1 = c.d
   dim _P0xSpeed2 = d
   dim _P0ySpeed1 = e.f
   dim _P0ySpeed2 = f

   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _Bit0_Reset_Restrainer = g ; Reset switch becomes inactive if it hasn't been released.
   dim _Bit2_SlideU = g           ; Bit is turned on if joystick pushed up.
   dim _Bit3_SlideD = g           ; Bit is turned on if joystick pushed down.
   dim _Bit4_SlideL = g           ; Bit is turned on if joystick pushed left.
   dim _Bit5_SlideR = g           ; Bit is turned on if joystick pushed right.



   ;***************************************************************
   ;
   ;  Acceleration amount. Change this number to change the
   ;  acceleration throughout the code.
   ;
   ;  The def statement is similar to the dim statement, but it
   ;  lets you define an entire string and assign it to a logical
   ;  name. [The d stands for def.]
   ;
   def _d_Acceleration=0.060



   ;***************************************************************
   ;
   ;  Disables the score. (We don't need it in this program.)
   ;
   const noscore = 1



   ;***************************************************************
   ;
   ;  Defines the edges of the playfield for an 8 x 8 sprite.
   ;  If your sprite is a different size, you`ll need to adjust
   ;  the numbers. [The c stands for constant.]
   ;
   const _c_Edge_Top = 9
   const _c_Edge_Bottom = 88
   const _c_Edge_Left = 1
   const _c_Edge_Right = 153



   ;***************************************************************
   ;
   ;  Maximum speed. Increase this number to make sprite faster.
   ;  [The c stands for constant.]
   ;
   const _c_Max_Speed = 2





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
   ;  Sets starting position of player0.
   ;
   player0x = 77 : player0y = 53


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
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Sets color of player0 sprite.
   ;
   COLUP0 = $9C



   ;***************************************************************
   ;
   ;  Up movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips up section if player0 sprite is sliding down.
   ;
   if _Bit3_SlideD{3} then __Skip_Up_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to up slide subsection if joystick not pushed up.
   ;
   if !joy0up then __Up_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Increases speed if not at maximum.
   ;
   if _P0ySpeed1 < _c_Max_Speed then _P0ySpeed1 = _P0ySpeed1 + _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns on up slide bit.
   ;  (Remembers direction when joystick is let go.)
   ;
   _Bit2_SlideU{2} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to sprite movement (skips slide).
   ;
   goto __Move_Up

__Up_Slide

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Skips slide if up slide bit is off.
   ;
   if !_Bit2_SlideU{2} then __Skip_Up_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Decreases slide speed.
   ;
   _P0ySpeed1 = _P0ySpeed1 - _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns off up slide bit if both integer and fraction of
   ;  speed is zero.
   ;
   if _P0ySpeed1 = 0 && _P0ySpeed2 = 0 then _Bit2_SlideU{2} = 0

__Move_Up

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 sprite up.
   ;
   _P0y = _P0y - _P0ySpeed1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps player0 sprite from moving beyond edge of screen.
   ;
   if player0y <= _c_Edge_Top then player0y = _c_Edge_Top : _P0ySpeed1 = 0 : _P0ySpeed2 = 0 : _Bit2_SlideU{2} = 0

__Skip_Up_Slide



   ;***************************************************************
   ;
   ;  Down movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips down section if player0 sprite is sliding up.
   ;
   if _Bit2_SlideU{2} then __Skip_Down_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to down slide subsection if joystick not pushed down.
   ; 
   if !joy0down then __Down_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Increases speed if not at maximum.
   ;
   if _P0ySpeed1 < _c_Max_Speed then _P0ySpeed1 = _P0ySpeed1 + _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns on down slide bit.
   ;  (Remembers direction when joystick is let go.)
   ;
   _Bit3_SlideD{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to sprite movement (skips slide).
   ;
   goto __Move_Down
   
__Down_Slide

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Skips slide if down slide bit is off.
   ;
   if !_Bit3_SlideD{3} then __Skip_Down_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Decreases slide speed.
   ; 
   _P0ySpeed1 = _P0ySpeed1 - _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns off down slide bit if both integer and fraction of
   ;  speed is zero.
   ;
   if _P0ySpeed1 = 0 && _P0ySpeed2 = 0 then _Bit3_SlideD{3} = 0

__Move_Down

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 sprite down.
   ;
   _P0y = _P0y + _P0ySpeed1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps player0 sprite from moving beyond edge of screen.
   ;
   if player0y >= _c_Edge_Bottom then player0y = _c_Edge_Bottom : _P0ySpeed1 = 0 : _P0ySpeed2 = 0 : _Bit3_SlideD{3} = 0

__Skip_Down_Slide



   ;***************************************************************
   ;
   ;  Left movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips left section if player0 sprite is sliding right.
   ;
   if _Bit5_SlideR{5} then __Skip_Left_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to left slide subsection if joystick not pushed left.
   ;
   if !joy0left then __Left_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Increases speed if not at maximum.
   ;
   if _P0xSpeed1 < _c_Max_Speed then _P0xSpeed1 = _P0xSpeed1 + _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns on left slide bit.
   ;  (Remembers direction when joystick is let go.)
   ;
   _Bit4_SlideL{4} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to sprite movement (skips slide).
   ;
   goto __Move_Left

__Left_Slide

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Skips slide if left slide bit is off.
   ;
   if !_Bit4_SlideL{4} then __Skip_Left_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Decreases slide speed.
   ;
   _P0xSpeed1 = _P0xSpeed1 - _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns off left slide bit if both integer and fraction of
   ;  speed is zero.
   ;
   if _P0xSpeed1 = 0 && _P0xSpeed2 = 0 then _Bit4_SlideL{4} = 0

__Move_Left

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 sprite to the left.
   ;
   _P0x = _P0x - _P0xSpeed1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps player0 sprite from moving beyond edge of screen.
   ;
   if player0x <= _c_Edge_Left || player0x > 200 then player0x = _c_Edge_Left : _P0xSpeed1 = 0 : _P0xSpeed2 = 0 : _Bit4_SlideL{4} = 0

__Skip_Left_Slide



   ;***************************************************************
   ;
   ;  Right movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips right section if player0 sprite is sliding left.
   ;
   if _Bit4_SlideL{4} then __Skip_Right_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to right slide subsection if joystick not pushed right.
   ;
   if !joy0right then __Right_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Increases speed if not at maximum.
   ;
   if _P0xSpeed1 < _c_Max_Speed then _P0xSpeed1 = _P0xSpeed1 + _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns on right slide bit.
   ;  (Remembers direction when joystick is let go.)
   ;
   _Bit5_SlideR{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to sprite movement (skips slide).
   ;
   goto __Move_Right

__Right_Slide

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Skips slide if right slide bit is off.
   ;
   if !_Bit5_SlideR{5} then __Skip_Right_Slide

   ;```````````````````````````````````````````````````````````````
   ;  Decreases speed every frame.
   ;
   _P0xSpeed1 = _P0xSpeed1 - _d_Acceleration

   ;```````````````````````````````````````````````````````````````
   ;  Turns off right slide bit if both integer and fraction of
   ;  speed is zero.
   ;
   if _P0xSpeed1 = 0 && _P0xSpeed2 = 0 then _Bit5_SlideR{5} = 0

__Move_Right

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  Moves player0 sprite to the right.
   ;
   _P0x = _P0x + _P0xSpeed1

   ;```````````````````````````````````````````````````````````````
   ;  Keeps player0 sprite from moving beyond edge of screen.
   ;
   if player0x >= _c_Edge_Right then player0x = _c_Edge_Right : _P0xSpeed1 = 0 : _P0xSpeed2 = 0 : _Bit5_SlideR{5} = 0

__Skip_Right_Slide



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