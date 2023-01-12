   ;****************************************************************
   ;
   ;  Pause Example
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  About this program:
   ;  
   ;  Use the joystick to move the sprite. Notice how the sprite
   ;  smoothly glides along the walls when the the sprite is moved
   ;  diagonally. It doesn't stick or bounce.
   ;
   ;  To pause on an Atari 2600, flip the COLOR/BW switch. To
   ;  pause on an Atari 7800, press the pause button. You can also
   ;  pause by pressing the fire button on the right controller.
   ;  To unpause, press and release the fire button on the left
   ;  controller.
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
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with the pause feature.
   ;
   dim _Pause_Counter_Tmp = o

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with the pause feature.
   ;
   dim _Pause_Mem_Color_Tmp = p

   ;```````````````````````````````````````````````````````````````
   ;  Temporary variable used in the pause loop.
   ;  This variable can be reused if you're sure it won't
   ;  interfere with the pause feature.
   ;
   dim _Pause_Color_Tmp = q

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
   ;  Bits for various jobs.
   ;
   dim _BitOp_01 = y

   ;```````````````````````````````````````````````````````````````
   ;  Keeps the reset switch from repeating when pressed.
   ;
   dim _Bit0_Reset_Restrainer = y

   ;```````````````````````````````````````````````````````````````
   ;  Restrains the fire button.
   ;
   dim _Bit1_FireB_Restrainer = y

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
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
   ;  Clears 25 of the normal 26 variables (fastest way). The
   ;  variable z is used for random numbers in this program and
   ;  clearing it would mess up those random numbers.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP
   ;
   ;
__Main_Loop_Setup


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
   ;  Sets sprite color.
   ;
   COLUP0 = $9C



   ;***************************************************************
   ;
   ;  Sets missile1 width.
   ;
   NUSIZ1 = $10



   ;***************************************************************
   ;
   ;  Joy0 up check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick isn't moved up.
   ;
   if !joy0up then goto __Skip_Joy0_Up

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
   ;  Skips this section if joystick isn't moved down.
   ;
   if !joy0down then goto __Skip_Joy0_Down

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
   ;  Skips this section if joystick isn't moved to the left.
   ;
   if !joy0left then goto __Skip_Joy0_Left

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
   ;  Skips this section if joystick isn't moved to the right.
   ;
   if !joy0right then goto __Skip_Joy0_Right

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
   ;  Pause check.
   ;
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
   if joy1fire then goto __Pause_Setup

__AP_Skip_Pause



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


   goto __Main_Loop





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

   COLUP0 = $0C

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

   COLUP0 = $0A

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

   COLUP0 = $3C

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

   COLUP0 = $3A

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

   COLUP0 = $6C

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

   COLUP0 = $6A

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

   COLUP0 = $9C

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

   COLUP0 = $9A

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

   COLUP0 = $CC

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

   COLUP0 = $CA

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

   COLUP0 = $FC

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

   COLUP0 = $FA

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

   COLUP0 = $8C

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

   COLUP0 = $8A

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

   COLUP0 = $2C

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

   COLUP0 = $2A

   COLUBK = $2C

   scorecolor = $2A

   goto __Got_Pause_Colors