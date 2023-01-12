   ;***************************************************************
   ;
   ;  Smooth Chase With Bresenham-Like Code
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;  Bresenham-like code provided by bogax:
   ;
   ;  http://atariage.com/forums/topic/235814-some-movement-code/
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Instructions:
   ;  
   ;  Use the joystick to move the sprite as another sprite
   ;  chases you. Press the fire button to make the other
   ;  sprite chase you faster.
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
   ;  Removes overhead from data tables, saving space. Doing so
   ;  will limit them to outside of code. That is, you can no
   ;  longer place data tables inline with code, or your program
   ;  may crash! 
   ;
   set optimization noinlinedata



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
   ;  Bresenham-related variables.
   ;
   dim _error_accumulator = a
   dim _delta_y = b
   dim _delta_x = c
   dim _octant = g
   dim _Chase_Delay = h

   ;```````````````````````````````````````````````````````````````
   ;  Bits that do various jobs.
   ;
   dim _Bit0_Reset_Restrainer = y
   dim _Bit5_EA = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers.
   ;
   dim rand16 = z



   ;***************************************************************
   ;
   ;  Defines the edges of the playfield for an 8 x 8 sprite.
   ;  If your sprite is a different size, you`ll need to adjust
   ;  the numbers.
   ;
   const _P_Edge_Top = 9
   const _P_Edge_Bottom = 88
   const _P_Edge_Left = 1
   const _P_Edge_Right = 153



   ;***************************************************************
   ;
   ;  Disables the score. (We don`t need it in this program.)
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
   ;  Clears 25 of the normal 26 variables (fastest way).
   ;  The variable z is used for random numbers in this program
   ;  and clearing it would mess up those random numbers.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0


   ;***************************************************************
   ;
   ;  Sets starting position of player1.
   ;
   player1x = 77 : player1y = 53


   ;***************************************************************
   ;
   ;  Sets random starting position of player0.
   ;
   player0x = (rand/2) + (rand&15) + 5 : player0y = 9


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
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Defines shape of player1 sprite.
   ;
   player1:
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
   ;  Defines shape of player0 sprite.
   ;
   player0:
   %00111100
   %01100110
   %11000011
   %11000011
   %11111111
   %11011011
   %01111110
   %00111100
end


   ;***************************************************************
   ;
   ;  Sets up the chase.
   ;
   goto __Chase_Setup





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Subtracts one from the chase delay counter.
   ;
   _Chase_Delay = _Chase_Delay - 1



   ;***************************************************************
   ;
   ;  Moves player1 sprite with the joystick while keeping the
   ;  sprite within the playfield area.
   ;
   if joy0up && player1y > _P_Edge_Top then player1y = player1y - 1

   if joy0down && player1y < _P_Edge_Bottom then player1y = player1y + 1

   if joy0left && player1x > _P_Edge_Left then player1x = player1x - 1

   if joy0right && player1x < _P_Edge_Right then player1x = player1x + 1



   ;***************************************************************
   ;
   ;  Collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if there is no collision.
   ;
   if !collision(player0, player1) then goto __Skip_p0_p1_Collision

   ;```````````````````````````````````````````````````````````````
   ;  Sets random starting position of enemy.
   ;
   player0x = (rand/2) + (rand&15) + 5 : player0y = 9

   ;```````````````````````````````````````````````````````````````
   ;  New location of Enemy influenced by location of player.
   ;
   if player1y <= 48 then player0y = 88

   ;```````````````````````````````````````````````````````````````
   ;  Sets error accumulator bit.
   ;
   _Bit5_EA{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to Bresenham-like chase setup.
   ;
   goto __Chase_Setup

__Skip_p0_p1_Collision



   ;***************************************************************
   ;
   ;  Bresenham-like chase (move code).
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Speeds up the chase if fire button pressed.
   ;
   if !joy0fire && !(_Chase_Delay & %00000001) then goto __Skip_Chase2

   ;```````````````````````````````````````````````````````````````
   ;  Code from bogax at AtariAge (needs more comments).
   ;
   temp1 = _error_accumulator

   if _octant{0} then goto __Skip_Chase1
   player0y = player0y + _Data_yinc[_octant]
   _error_accumulator = _error_accumulator - _delta_x
   if temp1 < _error_accumulator then _error_accumulator = _error_accumulator + _delta_y : player0x = player0x + _Data_xinc[_octant]

   goto __Skip_Chase2

__Skip_Chase1

   player0x = player0x + _Data_xinc[_octant]
   _error_accumulator = _error_accumulator - _delta_y
   if temp1 < _error_accumulator then _error_accumulator = _error_accumulator + _delta_x : player0y = player0y + _Data_yinc[_octant] 

__Skip_Chase2



   ;***************************************************************
   ;
   ;  Sets up the Bresenham-like chase.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If joystick not moved, skip this section.
   ;
   if !joy0up && !joy0down && !joy0left && !joy0right then goto __Skip_Bresenham_Setup

__Chase_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Code from bogax at AtariAge (needs more comments).
   ;
   if player0x < player1x then _octant{2} = 1 : _delta_x = player1x - player0x else _octant{2} = 0 : _delta_x = player0x - player1x
   if player0y < player1y then _octant{1} = 1 : _delta_y = player1y - player0y else _octant{1} = 0 : _delta_y = player0y - player1y

   if _delta_x < $80 then _delta_y = _delta_y * 2 : _delta_x = _delta_x * 2

   if _delta_x > _delta_y then goto __dx_gt
   _octant{0} = 0
   if _error_accumulator > _delta_y then _error_accumulator = _delta_y / 2
   goto __set_ea

__dx_gt
   _octant{0} = 1 
   if _error_accumulator > _delta_x then _error_accumulator = _delta_x / 2

__set_ea

   ;```````````````````````````````````````````````````````````````
   ;  Sets error accumulator (skips if collision hasn't happened).
   ;
   if !_Bit5_EA{5} then goto __Skip_Bresenham_Setup

   _Bit5_EA{5} = 0

   if _octant{0} then _error_accumulator = _delta_x / 2 else _error_accumulator = _delta_y / 2

__Skip_Bresenham_Setup



   ;***************************************************************
   ;
   ;  Sets color of player1 sprite.
   ;
   COLUP1 = $9C



   ;***************************************************************
   ;
   ;  Sets color of player0 sprite.
   ;
   COLUP0 = $46



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





   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  END OF MAIN LOOP
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````





   ;***************************************************************
   ;
   ;  Bresenham-like data.
   ;
   data _Data_yinc
   $FF, $FF, $01, $01, $FF, $FF,$01, $01
end

   data _Data_xinc
   $FF, $FF, $FF, $FF, $01, $01, $01, $01
end