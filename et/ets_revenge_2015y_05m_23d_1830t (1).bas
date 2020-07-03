   ;****************************************************************
   ;
   ;  E.T.'s Revenge
   ;
   ;  Stop E.T. from conquering the world.
   ;
   ;***************************************************************


   ;***************************************************************
   ;
   ;  Kernel options.
   ;
   set kernel_options player1colors pfcolors no_blank_lines


   ;***************************************************************
   ;
   ;  Variable aliases go here (DIMs).
   ;
   ;  You can have more than one alias for each variable.
   ;  If you use different aliases for bit operations, it is
   ;  easier to understand and remember what they do.
   ;
   ;```````````````````````````````````````````````````````````````

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
   dim _Sound0 = c
   dim _SoundCounter0 = d
   dim _C0 = e
   dim _V0 = f
   dim _F0 = g

   ;```````````````````````````````````````````````````````````````
   ;  Color change counter.
   ;
   dim _PFColor_Counter = h

   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _Bit3_PFP_Restrainer_Down = i
   dim _Bit4_PFP_Restrainer_Up = i
   dim _Bit5_Up = i
   dim _Bit6_Down = i
   dim _Bit7_First_Time = i

   ;```````````````````````````````````````````````````````````````
   ;  Converts 6 digit score to 3 sets of two digits.
   ;
   ;  The 100 thousands and 10 thousands digits are held by sc1.
   ;  The thousands and hundreds digits are held by sc2.
   ;  The tens and ones digits are held by sc3.
   ;
   dim sc1 = score
   dim sc2 = score+1
   dim sc3 = score+2

   ;```````````````````````````````````````````````````````````````
   ;  These can be used for other things using different aliases,
   ;  but for the GAME OVER loop, they are used to temporarily 
   ;  remember the score for the 2 second score/high score flip.
   ;
   dim _Temp_Score01 = s
   dim _Temp_Score02 = t
   dim _Temp_Score03 = u

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the high score until the game is turned off.
   ;
   dim _High_Score01 = v
   dim _High_Score02 = w
   dim _High_Score03 = x

   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_All_Purpose_01 = y
   dim _Bit0_Reset_Restrainer = y
   dim _Bit1_FireB_Restrainer = y
   dim _Bit2_Game_Over = y
   dim _Bit3_Swap_Scores = y
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
   ;***************************************************************
   ;
   ;  PROGRAM START/RESTART
   ;
   ;
__Start_Restart


   ;***************************************************************
   ;
   ;  Clears the screen.
   ;
   pfclear


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
   ;  Clears 7 of the 8 All_Purpose_01 bits.
   ;
   ;  Bit 2 is not cleared because _Bit2_Game_Over{2} is used
   ;  to control how the program is reset.
   ;
   _BitOp_All_Purpose_01 = _BitOp_All_Purpose_01 & %00000100


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   player1y = 200 : player0y = 200 : bally = 200


   ;***************************************************************
   ;
   ;  Skips title screen if game has been played and player
   ;  presses fire button or reset switch at the end of the game.
   ;
   if _Bit2_Game_Over{2} then goto __Main_Loop_Setup





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
   pfscore1 = 0 : score = 2015 : scorecolor = $BE


   ;***************************************************************
   ;
   ;  Sets title screen background color.
   ;
   COLUBK = $60


   ;***************************************************************
   ;
   ;  Restrains the reset switch.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after entering a different segment
   ;  of the program. It does double duty by restraining the
   ;  fire button too in the title screen loop.
   ;
   _Bit0_Reset_Restrainer{0} = 1


   ;***************************************************************
   ;
   ;  Makes sure playfield is back to normal.
   ;
   playfieldpos = 8


   ;***************************************************************
   ;
   ;  Sets up title screen playfield.
   ;
   playfield:
   .......XXX..XXX.X..XX...........
   .......X.....X..X.X..X..........
   .......XX....X.....X............
   .......X.....X...X..X...........
   .......XXX.X.X.X..XX............
   ................................
   XXX..XXX.X.X.XXX.X..X..XXX.XXX..
   X..X.X...X.X.X...XX.X.X....X....
   X..X.XX..X.X.XX..X.XX.X.XX.XX...
   XXX..X...X.X.X...X..X.X..X.X....
   X..X.XXX..X..XXX.X..X..XXX.XXX..
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
   pfcolors:
   $C0
   $C2
   $C6
   $C8
   $CA
   $CC
   $CE
   $CC
   $CA
   $C8
   $C6
   $C2
   $C0
end



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
   ;  If fire button or reset switch is not pressed, clear the 
   ;  restrainer bit and jump to beginning of title screen loop.
   ;
   if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Title_Screen_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If reset/fire hasn't been released since starting 'title
   ;  screen' loop, jump to beginning of title screen loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Title_Screen_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset or Fire pressed appropriately. Jump to main loop setup.
   ;
   goto __Main_Loop_Setup





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP
   ;
   ;

   
__Main_Loop_Setup



   ;***************************************************************
   ;
   ;  Clears the GAME OVER bit for the main loop.
   ;
   _Bit2_Game_Over{2} = 0


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed in the title
   ;  screen section or the GAME OVER section. If the reset
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
   ;  screen section or the GAME OVER section. If the fire
   ;  button isn't being held down, this bit will be cleared
   ;  in the main loop.
   ;
   _Bit1_FireB_Restrainer{1} = 1


   ;***************************************************************
   ;
   ;  Starting position of player0 (Thomas).
   ;
   player1x = 74 : player1y = 78


   ;***************************************************************
   ;
   ;  Starting position of player0 (E.T.).
   ;
   player0x = (rand/2) + (rand&15) : player0y = 0 


   ;***************************************************************
   ;
   ;  Defines ball height and location.
   ;
   ballheight = 4 : bally = 250


   ;***************************************************************
   ;
   ;  Sets background color.
   ;
   COLUBK = $F0


   ;***************************************************************
   ;
   ;  Sets score and score color.
   ;
   score = 0 : scorecolor = $1E


   ;***************************************************************
   ;
   ;  Sets number of lives and sets color.
   ;
   pfscore1 = %01010101 : pfscorecolor = $AE


   ;***************************************************************
   ;
   ;  Sets playfield color change restrainer bits and first time bit.
   ;
   _Bit3_PFP_Restrainer_Down{3} = 1 : _Bit4_PFP_Restrainer_Up{4} = 1 : _Bit7_First_Time{7} = 1



   ;***************************************************************
   ;
   ;  Sets playfield colors.
   ;
   pfcolors:
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $60
end


   ;***************************************************************
   ;
   ;  Sets up the main loop playfield.
   ;

   playfield:
   ...........X.......X............
   ...........X.......X............
   ...........X.......X............
   ...........X.......X............
   XXXXXXXXXXXX.......XXXXXXXXXXXXX
   ...................X............
   ...................X............
   ...................X............
   XXXXXXXXXXXX.......XXXXXXXXXXXXX
   ...........X.......X............
   ...........X.......X............
   ...........X.......X............
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE GAME GO)
   ;
   ;


   CTRLPF = $31
   ballheight = 8

__Main_Loop




   ;***************************************************************
   ;
   ;  Sets E.T. sprite color.
   ;
   COLUP0 = $DC



   ;***************************************************************
   ;
   ;  Makes ball a little wider.
   ;
   NUSIZ0 = $35



   ;***************************************************************
   ;
   ;  Animation counters.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments _Master_Counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips this subsection if _Master_Counter is less than 7.
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
   ;  Thomas animation (4 frames, 0 through 3).
   ;
   on _Frame_Counter goto __Tom00 __Tom01 __Tom02 __Tom03

__Thomas_Frame_Done

   ;***************************************************************
   ;
   ;  E.T animation (4 frames, 0 through 3).
   ;
   on _Frame_Counter goto __ET00 __ET01 __ET02 __ET03

__ET_Frame_Done



   ;***************************************************************
   ;
   ;  ball check and fire button check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If ball is off the screen, jump to fire button check.
   ;
   if bally > 240 then goto __FireB_Check

   ;```````````````````````````````````````````````````````````````
   ;  Moves ball and skips fire button check.
   ;
   bally = bally - 2 : goto __Skip_FireB

__FireB_Check

   ;```````````````````````````````````````````````````````````````
   ;  Checks fire button since ball is off the screen.
   ;  If fire button is not pressed, skip this subsection.
   ;
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_FireB

   ;```````````````````````````````````````````````````````````````
   ;  If fire button hasn't been released since title screen,
   ;  skip this subsection.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Skip_FireB

   ;```````````````````````````````````````````````````````````````
   ;  Starts the firing of ball.
   ;
   bally = player1y - 16 : ballx = player1x + 4

__Skip_FireB



   ;***************************************************************
   ;
   ;  Joystick movement check.
   ;
   if !joy0up then goto __Skip_JoyUp
   if _Bit5_Up{5} then goto __Skip_Up_Bit_Check
   if _Bit7_First_Time{7} then _PFColor_Counter = 12
   _PFColor_Counter = _PFColor_Counter - 2 : if _PFColor_Counter >= 250 then _PFColor_Counter = 11
__Skip_Up_Bit_Check
   player1y = player1y - 1
   _Bit5_Up{5} = 1 : _Bit6_Down{6} = 0 : _Bit7_First_Time{7} = 0
   pfscroll down
__Skip_JoyUp

   if !joy0down then goto __SkipJoyDown
   if !_Bit6_Down{6} && _Bit5_Up{5} then _PFColor_Counter = _PFColor_Counter + 2 : if _PFColor_Counter >= 12 then _PFColor_Counter = 0
   player1y = player1y + 1
   _Bit6_Down{6} = 1 : _Bit5_Up{5} = 0 : _Bit7_First_Time{7} = 0
   pfscroll up
__SkipJoyDown

   if joy0left then player1x = player1x - 1 : pfscroll right
   if joy0right then player1x = player1x + 1 : pfscroll left



   ;***************************************************************
   ;
   ;  Keeps player1 within screen borders.
   ;
   if player1x < 3 then player1x = 3
   if player1x > 150 then player1x = 150
   if player1y < 20 then player1y = 20
   if player1y > 84 then player1y = 84



   ;***************************************************************
   ;
   ;  E.T. chases the player.
   ;
   if player0y < player1y then player0y = player0y + 1
   if player0y > player1y then player0y = player0y - 1
   if player0x < player1x then player0x = player0x + 1
   if player0x > player1x then player0x = player0x - 1



   ;***************************************************************
   ;
   ;  E.T./ball collision check.
   ;
   if !collision(ball,player0) then goto __Skip_ET_Kill

   ;```````````````````````````````````````````````````````````````
   ;  Adds 1 to the score.
   ;
   score = score + 1

   ;```````````````````````````````````````````````````````````````
   ;  Sound effect 1 setup.
   ;
   if _Sound0 then goto __Skip_Sound0_Setup

   _Sound0 = 1 : _SoundCounter0 = 10

   _C0 = 4 : _V0 = 12 : _F0 = 14

   temp5 = 255 : if player0y < player1y then temp5 = player1y - player0y

   if temp5 < 30 then _C0 = 12 ; Makes a different sound when closer to player.

__Skip_Sound0_Setup

   ;```````````````````````````````````````````````````````````````
   ;  Moves E.T. to new location and removes missile.
   ;
   player0x = (rand/2) + (rand&15) : player0y = 0 : bally = 250

__Skip_ET_Kill



   ;***************************************************************
   ;
   ;  E.T./Thomas collision check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  if no collision between sprites, skip this subsection.
   ;
   if !collision(player0,player1) then goto __Skip_Players_Touch

   ;```````````````````````````````````````````````````````````````
   ;  Subtracts 1 from the score.
   ;
   if sc3 > 0 then score = score - 1

   ;```````````````````````````````````````````````````````````````
   ;  if pfscore1 bar is empty, activate last life bit.
   ;
   if !pfscore1 then _Bit7_Last_Life{7} = 1 

   ;```````````````````````````````````````````````````````````````
   ;  Deletes a life.
   ;
   if pfscore1 then pfscore1 = pfscore1/4

   ;```````````````````````````````````````````````````````````````
   ;  Moves E.T. to new location and removes missile.
   ;
   player0x = (rand/2) + (rand&15) : player0y = 0 : bally = 250

   ;```````````````````````````````````````````````````````````````
   ;  Sound effect 2 setup.
   ;
   if _Sound0 then goto __Skip_Players_Touch

   _Sound0 = 2 : _SoundCounter0 = 10

   _C0 = 7 : _V0 = 12 : _F0 = 12

__Skip_Players_Touch



   ;***************************************************************
   ;
   ;  Point sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the sound isn't on, skip this subsection.
   ;
   if _Sound0 <> 1 then goto __Skip_Sound1

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
   _SoundCounter0 = _SoundCounter0 - 1

   ;```````````````````````````````````````````````````````````````
   ;  If sound counter is zero, clear _Sound0 and mute channel.
   ;
   if !_SoundCounter0 then _Sound0 = 0 : AUDV0 = 0

__Skip_Sound1




   ;***************************************************************
   ;
   ;  E.T. touches Thomas sound.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the sound isn't on, skip this subsection.
   ;
   if _Sound0 <> 2 then goto __Skip_Sound2

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
   _SoundCounter0 = _SoundCounter0 - 1

   ;```````````````````````````````````````````````````````````````
   ;  If sound counter is zero, clear _Sound0 and mute channel.
   ;  Also tells game to end if last life is lost.
   ;
   if !_SoundCounter0 then _Sound0 = 0 : AUDV0 = 0 : if _Bit7_Last_Life{7} then _Bit2_Game_Over{2} = 1

__Skip_Sound2



   ;***************************************************************
   ;
   ;  Sets player1 color.
   ;
   player1color:
   $26
   $26
   $44
   $44
   $2A
   $2A
   $26
   $44
   $26
   $2A
   $2A
   $2A
   $2A
   $2A
   $44
   $44
end



   ;***************************************************************
   ;
   ;  Playfield color fix for player moving down.
   ;
   if playfieldpos <> 8 then _Bit3_PFP_Restrainer_Down{3} = 0 : goto __Skip_PF_Color_Change_Down

   if !_Bit6_Down{6} then goto __Skip_PF_Color_Change_Down

   if _Bit3_PFP_Restrainer_Down{3} then goto __Skip_PF_Color_Change_Down

   _Bit3_PFP_Restrainer_Down{3} = 1

   on _PFColor_Counter gosub __PFC00 __PFC01 __PFC02 __PFC03 __PFC04 __PFC05 __PFC06 __PFC07 __PFC08 __PFC09 __PFC10 __PFC11

   _PFColor_Counter = _PFColor_Counter + 1 : if _PFColor_Counter >= 12 then _PFColor_Counter = 0

__Skip_PF_Color_Change_Down



   ;***************************************************************
   ;
   ;  Playfield color fix for player moving up.
   ;
   if playfieldpos <> 1 then _Bit4_PFP_Restrainer_Up{4} = 0 : goto __Skip_PF_Color_Change_Up

   if !_Bit5_Up{5} then goto __Skip_PF_Color_Change_Up

   if _Bit4_PFP_Restrainer_Up{4} then goto __Skip_PF_Color_Change_Up

   _Bit4_PFP_Restrainer_Up{4} = 1

   on _PFColor_Counter gosub __PFC00 __PFC01 __PFC02 __PFC03 __PFC04 __PFC05 __PFC06 __PFC07 __PFC08 __PFC09 __PFC10 __PFC11

   _PFColor_Counter = _PFColor_Counter - 1 : if _PFColor_Counter >= 250 then _PFColor_Counter = 11

__Skip_PF_Color_Change_Up



   ;***************************************************************
   ;
   ;  Makes sure top of screen is black.
   ;
   COLUPF = 0



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Checks to see if the game is over.
   ;
   if _Bit2_Game_Over{2} then goto __Game_Over_Setup



   ;***************************************************************
   ;
   ;  Reset switch check and end of main loop.
   ;
   ;  Any Atari 2600 program should restart when the reset  
   ;  switch is pressed. It is part of the usual standards
   ;  and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  If the reset switch is not pressed, turn off reset
   ;  restrainer bit and skip this subsection.
   ;
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If the reset switch hasn't been released since starting the
   ;  game, skip this subsection.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Clears the GAME OVER bit so the title screen will appear.
   ;
   _Bit2_Game_Over{2} = 0

   ;```````````````````````````````````````````````````````````````
   ;  Reset pressed appropriately. Restart the program.
   ;
   goto __Start_Restart



   ;***************************************************************
   ;
   ;  Sets main loop playfield pixel color.
   ;
__PFC00

   pfcolors:
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $00
end

   return


__PFC01

   pfcolors:
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $00
end

   return

__PFC02

   pfcolors:
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $00
end

   return

__PFC03

   pfcolors:
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $00
end

   return

__PFC04

   pfcolors:
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $00
end

   return

__PFC05

   pfcolors:
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $00
end

   return

__PFC06

   pfcolors:
   $6C
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $00
end

   return

__PFC07

   pfcolors:
   $6A
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $00
end

   return

__PFC08

   pfcolors:
   $68
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $00
end

   return

__PFC09

   pfcolors:
   $66
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $00
end

   return

__PFC10

   pfcolors:
   $62
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $00
end

   return


__PFC11

   pfcolors:
   $50
   $52
   $56
   $58
   $5A
   $5C
   $5E
   $6C
   $6A
   $68
   $66
   $62
   $00
end

   return





   ;***************************************************************
   ;
   ;  Thomas animation frames.
   ;
__Tom00
   player1:
   %11100111
   %01100110
   %01100110
   %00111100
   %11011011
   %10100101
   %11011011
   %11011011
   %01011010
   %00011100
   %00110000
   %01111011
   %01010110
   %00010100
   %01111111
   %00111100
end
   goto __Thomas_Frame_Done


__Tom01
   player1:
   %01100000
   %11000000
   %01100011
   %00001111
   %11011101
   %11001010
   %11100100
   %01110101
   %00101011
   %00011101
   %00110000
   %01111011
   %01010110
   %00010100
   %01111111
   %00111100
end
   goto __Thomas_Frame_Done


__Tom02
   player1:
   %00000111
   %10000110
   %11110110
   %11111010
   %00111100
   %00111110
   %01001111
   %01010011
   %00101100
   %00011100
   %00110000
   %01111011
   %01010110
   %00010100
   %01111111
   %00111100
end
   goto __Thomas_Frame_Done



__Tom03
   player1:
   %00011000
   %00110010
   %00110100
   %00101110
   %01110011
   %01101101
   %01011100
   %01011010
   %00111010
   %00011100
   %00110000
   %01111011
   %01010110
   %00010100
   %01111111
   %00111100
end
   goto __Thomas_Frame_Done





   ;***************************************************************
   ;
   ;  E.T. animation frames.
   ;
__ET00
   player0:
   %01110000
   %00110111
   %00011111
   %10011111
   %11111111
   %00011111
   %00001111
   %00000011
   %11000011
   %11111111
   %10111111
   %11111100
end
   goto __ET_Frame_Done


__ET01
   player0:
   %01110000
   %00110111
   %00011111
   %10011111
   %11111111
   %00011111
   %00001111
   %00000011
   %00000011
   %00000011
   %11000011
   %11111111
   %10111111
   %11111100
end
   goto __ET_Frame_Done


__ET02
   player0:
   %00000111
   %01110011
   %00011111
   %10011111
   %11111111
   %00011111
   %00001111
   %00000011
   %00000011
   %00000011
   %00000011
   %00000011
   %11000011
   %11111111
   %10111111
   %11111100
end
   goto __ET_Frame_Done



__ET03
   player0:
   %00000111
   %01110011
   %00011111
   %10011111
   %11111111
   %00011111
   %00001111
   %00000011
   %00000011
   %00000011
   %11000011
   %11111111
   %10111111
   %11111100
end
   goto __ET_Frame_Done





   ;***************************************************************
   ;***************************************************************
   ;
   ;  GAME OVER SETUP
   ;
   ;
__Game_Over_Setup


   ;***************************************************************
   ;
   ;  Checks for a new high score.
   ;
   if sc1 > _High_Score01 then goto __New_High_Score
   if sc1 < _High_Score01 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  First byte equal. Do the next test. 
   ;
   if sc2 > _High_Score02 then goto __New_High_Score
   if sc2 < _High_Score02 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Second byte equal. Do the next test. 
   ;
   if sc3 > _High_Score03 then goto __New_High_Score
   if sc3 < _High_Score03 then goto __Skip_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  All bytes equal. Current score is the same as the high score.
   ;
   goto __Skip_High_Score

__New_High_Score

   ;```````````````````````````````````````````````````````````````
   ;  Saves new high score.
   ;
   _High_Score01 = sc1 : _High_Score02 = sc2 : _High_Score03 = sc3

__Skip_High_Score


   ;***************************************************************
   ;
   ;  Saves the latest score for the high score flip.
   ;
   _Temp_Score01 = sc1 : _Temp_Score02 = sc2 : _Temp_Score03 = sc3


   ;***************************************************************
   ;
   ;  Clears the counters.
   ;
   _Master_Counter = 0 : _Frame_Counter = 0


   ;***************************************************************
   ;
   ;  Makes sure sprites and missile are off the screen.
   ;
   player0y = 200 : player1y = 200 : bally = 200


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
   ;  Puts playfield back to normal after all of the scrolling.
   ;
   playfieldpos = 8


   ;***************************************************************
   ;
   ;  Clears the screen.
   ;
   pfclear


   ;***************************************************************
   ;
   ;  Sets GAME OVER background color.
   ;
   COLUBK = $6E


   ;***************************************************************
   ;
   ;  Sets up GAME OVER playfield.
   ;
   playfield:
   XXX..XXX.....XX...XX..XX.XX.XXX.
   X.....X.....X..X.X..X.X.X.X.X...
   XX....X.....X....XXXX.X...X.XX..
   X.....X.....X..X.X..X.X...X.X...
   XXX.X.X.X....XX..X..X.X...X.XXX.
   ................................
   XXX...XX...XX..X..X..X.X.X......
   X..X.X..X.X..X.X.X...X.X.X......
   XXX..XXXX.X....XX....X.X.X......
   X..X.X..X.X..X.X.X..............
   XXX..X..X..XX..X..X..X.X.X......
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
   ;  Goes to title screen after 20 seconds if player does nothing.
   ;
   ;  This includes a 2 second countdown timer. Any Atari 2600
   ;  program should freeze for 2 seconds when the game is over.
   ;  It is part of the usual standards and procedures.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  The master counter resets every 2 seconds (60 + 60 = 120).
   ;
   if _Master_Counter < 120 then goto __Skip_20_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Clears the master counter after 2 seconds have gone by
   ;  and flips the Swap_Scores bit.
   ;
   _Master_Counter = 0 : _Bit3_Swap_Scores{3} = !_Bit3_Swap_Scores{3}

   ;```````````````````````````````````````````````````````````````
   ;  If the Swap_Scores bit is on, display the high score.
   ;
   if _Bit3_Swap_Scores{3} then scorecolor = $AE : sc1=_High_Score01 : sc2=_High_Score02 : sc3=_High_Score03 : goto __Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  If the Swap_Scores bit is off, display the current score.
   ;
   scorecolor = $1C : sc1=_Temp_Score01 : sc2=_Temp_Score02 : sc3=_Temp_Score03 

__Skip_Flip

   ;```````````````````````````````````````````````````````````````
   ;  The frame counter increments every 2 seconds.
   ;
   _Frame_Counter = _Frame_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  If _Frame_Counter reaches 10 (2 x 10 = 20 seconds), the
   ;  program resets and goes to the title screen. The GAME OVER
   ;  bit is cleared so the title screen will appear.
   ;
   if _Frame_Counter = 10 then _Bit2_Game_Over{2} = 0 : goto __Start_Restart

__Skip_20_Counter



   ;***************************************************************
   ;
   ;  Sets GAME OVER playfield pixel color.
   ;
   pfcolors:
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $8C
   $8A
   $88
   $86
end



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
   ;  If the initial 2 second freeze is not over, jump to
   ;  beginning of the GAME OVER loop.
   ;
   if _Frame_Counter = 0 then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If fire button or reset switch is not pressed, clear the 
   ;  restrainer bit and jump to beginning of GAME OVER loop.
   ;
   if !switchreset && !joy0fire then _Bit0_Reset_Restrainer{0} = 0 : goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If fire button hasn't been released since leaving the
   ;  main loop, jump to beginning of the GAME OVER loop.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Game_Over_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset or Fire pressed appropriately. Restart the program.
   ;
   goto __Start_Restart

