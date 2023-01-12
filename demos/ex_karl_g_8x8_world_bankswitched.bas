   ;***************************************************************
   ;
   ;  8 x 8 World (64 Rooms)
   ;
   ;  Example program by Karl G and adapted by Duane Alan Hahn
   ;  (Random Terrain) using hints, tips, code snippets, and
   ;  more from AtariAge members such as batari, SeaGtGruff,
   ;  RevEng, Robert M, Nukey Shay, Atarius Maximus, jrok,
   ;  supercat, GroovyBee, and bogax.
   ;
   ;```````````````````````````````````````````````````````````````
   ;
   ;  About:
   ;  
   ;  This example program uses rand and unrand to generate an
   ;  8 x 8 world of 64 rooms without having to use variables
   ;  to track what type of screen is in what position.
   ;
   ;  Select a seed number using the score by moving the joystick
   ;  up, down, left or right. Leaving the score set to zero will
   ;  cause the program to select a random seed number. The screen
   ;  types will be consistent every time when using the same
   ;  seed number. Press the reset switch to restart the program
   ;  whenever you wish to select another seed number.
   ;
   ;  This 8 x 8 world version tracks whether each screen has been
   ;  visited. An eye icon shows at the bottom of the screen if
   ;  the current screen has been previously visited (using the
   ;  6lives minikernel to display the icon). This uses up 8
   ;  variables, so you may not want to use it in an actual game.
   ;  
   ;```````````````````````````````````````````````````````````````
   ;
   ;  If this program will not compile for you, get the latest
   ;  version of batari Basic:
   ;  
   ;  http://www.randomterrain.com/atari-2600-memories-batari-basic-commands.html#gettingstarted
   ;  
   ;***************************************************************



   ;****************************************************************
   ;
   ;  The kernel option below causes the loss of missile1.
   ; 
   set kernel_options player1colors



   ;***************************************************************
   ;
   ;  This program has 4 banks (16k/4k = 4 banks).
   ;
   set romsize 16k



   ;***************************************************************
   ;
   ;  Random numbers can slow down bankswitched games.
   ;  This will speed things up.
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
   ;  Which room player is in.
   ;
   dim _XRoom = a
   dim _YRoom = b

   ;```````````````````````````````````````````````````````````````
   ;  Which scene should be used.
   ;
   dim _CurrentScene = c

   ;```````````````````````````````````````````````````````````````
   ;  Title screen slowdown variable.
   ;
   dim _TS_Slowdown = c

   ;```````````````````````````````````````````````````````````````
   ;  The 8 variables below remember any rooms that were visited.
   ;
   dim _VisitedRooms = d
   dim _Row1Visited = e
   dim _Row2Visited = f
   dim _Row3Visited = g
   dim _Row4Visited = h
   dim _Row5Visited = i
   dim _Row6Visited = j
   dim _Row7Visited = k

   ;```````````````````````````````````````````````````````````````
   ;  Temp variable.
   ;
   dim _Temp = l

   ;```````````````````````````````````````````````````````````````
   ;  _Master_Counter can be used for many things, but it is 
   ;  really useful for animating sprite frames when used
   ;  with _Frame_Counter.
   ;
   dim _Master_Counter = m
   dim _Frame_Counter = n

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_01 = o
   dim _Bit0_Reset_Restrainer = o     ; Restrains the reset switch.
   dim _Bit1_Next_Room_Up = o         ; Time for new room.
   dim _Bit2_Next_Room_Down = o       ; Time for new room.
   dim _Bit3_Next_Room_Left = o       ; Time for new room.
   dim _Bit4_Next_Room_Right = o      ; Time for new room.
   dim _Bit5_UD_Joy_Movement = o      ; Up/down joystick movement happened.
   dim _Bit6_LR_Joy_Movement = o      ; Left/Right joystick movement happened.
   dim _Bit7_Over_Under = o           ; Overland or Underland.


   ;```````````````````````````````````````````````````````````````
   ;  Player1 left/right movement.
   ;
   dim _P1_Left_Right = player1x.p

   ;```````````````````````````````````````````````````````````````
   ;  Player1 up/down movement.
   ;
   dim _P1_Up_Down = player1y.q

   ;```````````````````````````````````````````````````````````````
   ;  Special rand used for the rooms.
   ;
   dim _RoomRand = y

   ;```````````````````````````````````````````````````````````````
   ;  Makes better random numbers.
   ;
   dim rand16 = z

   ;```````````````````````````````````````````````````````````````
   ;  Splits up the score into 3 parts.
   ;
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2



   ;***************************************************************
   ;
   ;  Defines the edges of the playfield for the sprite size used
   ;  in this program. If your sprite is a different size, you'll
   ;  need to adjust the numbers. [The c stands for constant.]
   ;
   const _c_Edge_Top = 10
   const _c_Edge_Bottom = 88
   const _c_Edge_Left = 2
   const _c_Edge_Right = 153



   ;***************************************************************
   ;
   ;  World limit constants. Change these based on world size.
   ;  The default here is 8 x 8 (64 rooms).
   ;  [The c stands for constant.]
   ;
   const _c_World_Limit_Top = 0
   const _c_World_Limit_Bottom = 7
   const _c_World_Limit_Left = 0
   const _c_World_Limit_Right = 7



   ;****************************************************************
   ;
   ;  NTSC colors.
   ;
   ;  Use these constants so you can quickly and easily swap them
   ;  out for PAL-60 colors. Or use this if you created a PAL-60
   ;  game and want to instantly convert the colors to NTSC (if you
   ;  were already using the PAL-60 constants).
   ;
   const _00 = $00
   const _02 = $02
   const _04 = $04
   const _06 = $06
   const _08 = $08
   const _0A = $0A
   const _0C = $0C
   const _0E = $0E
   const _10 = $10
   const _12 = $12
   const _14 = $14
   const _16 = $16
   const _18 = $18
   const _1A = $1A
   const _1C = $1C
   const _1E = $1E
   const _20 = $20
   const _22 = $22
   const _24 = $24
   const _26 = $26
   const _28 = $28
   const _2A = $2A
   const _2C = $2C
   const _2E = $2E
   const _30 = $30
   const _32 = $32
   const _34 = $34
   const _36 = $36
   const _38 = $38
   const _3A = $3A
   const _3C = $3C
   const _3E = $3E
   const _40 = $40
   const _42 = $42
   const _44 = $44
   const _46 = $46
   const _48 = $48
   const _4A = $4A
   const _4C = $4C
   const _4E = $4E
   const _50 = $50
   const _52 = $52
   const _54 = $54
   const _56 = $56
   const _58 = $58
   const _5A = $5A
   const _5C = $5C
   const _5E = $5E
   const _60 = $60
   const _62 = $62
   const _64 = $64
   const _66 = $66
   const _68 = $68
   const _6A = $6A
   const _6C = $6C
   const _6E = $6E
   const _70 = $70
   const _72 = $72
   const _74 = $74
   const _76 = $76
   const _78 = $78
   const _7A = $7A
   const _7C = $7C
   const _7E = $7E
   const _80 = $80
   const _82 = $82
   const _84 = $84
   const _86 = $86
   const _88 = $88
   const _8A = $8A
   const _8C = $8C
   const _8E = $8E
   const _90 = $90
   const _92 = $92
   const _94 = $94
   const _96 = $96
   const _98 = $98
   const _9A = $9A
   const _9C = $9C
   const _9E = $9E
   const _A0 = $A0
   const _A2 = $A2
   const _A4 = $A4
   const _A6 = $A6
   const _A8 = $A8
   const _AA = $AA
   const _AC = $AC
   const _AE = $AE
   const _B0 = $B0
   const _B2 = $B2
   const _B4 = $B4
   const _B6 = $B6
   const _B8 = $B8
   const _BA = $BA
   const _BC = $BC
   const _BE = $BE
   const _C0 = $C0
   const _C2 = $C2
   const _C4 = $C4
   const _C6 = $C6
   const _C8 = $C8
   const _CA = $CA
   const _CC = $CC
   const _CE = $CE
   const _D0 = $D0
   const _D2 = $D2
   const _D4 = $D4
   const _D6 = $D6
   const _D8 = $D8
   const _DA = $DA
   const _DC = $DC
   const _DE = $DE
   const _E0 = $E0
   const _E2 = $E2
   const _E4 = $E4
   const _E6 = $E6
   const _E8 = $E8
   const _EA = $EA
   const _EC = $EC
   const _EE = $EE
   const _F0 = $F0
   const _F2 = $F2
   const _F4 = $F4
   const _F6 = $F6
   const _F8 = $F8
   const _FA = $FA
   const _FC = $FC
   const _FE = $FE





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
   ;  Makes sure sprites are off screen.
   ;
   player1y = 150 : player0y = 150


   ;***************************************************************
   ;
   ;  Sets color and shape of life counter.
   ;
   lifecolor = _8A : lives = 0

   lives:
   %00000000
   %00011000
   %00100100
   %01011010
   %10011001
   %01011010
   %00100100
   %00011000
end


   ;***************************************************************
   ;
   ;  Clears most normal variables.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0





   ;***************************************************************
   ;***************************************************************
   ;
   ;   TITLE SCREEN SETUP
   ;
   ;
__Title_Screen_Setup


   ;***************************************************************
   ;
   ;  Sets score color for title screen.
   ;
   scorecolor = _1C


   ;***************************************************************
   ;
   ;  Sets score and tracker variable.
   ;
   score = 0 : _RoomRand = 0


   ;***************************************************************
   ;
   ;  Sets title screen background color.
   ;
   COLUBK = _00


   ;***************************************************************
   ;
   ;  Sets title screen playfield pixel colors.
   ;
   COLUPF = _08


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
   .XXXXX.XXXX.XX...XXXX.XXXX.XXXX.
   .XX....XX...XX...XX...XX....XX..
   .XXXXX.XXXX.XX...XXXX.XX....XX..
   ....XX.XX...XX...XX...XX....XX..
   .XXXXX.XXXX.XXXX.XXXX.XXXX..XX..
   ................................
   XXXXX.XXXX.XXXX.XXXXX....XX.XX..
   XX....XX...XX...XX..XX..XXXXXXX.
   XXXXX.XXXX.XXXX.XX..XX...XX.XX..
   ...XX.XX...XX...XX..XX..XXXXXXX.
   XXXXX.XXXX.XXXX.XXXXX....XX.XX..
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
   ;  Controls seed number selection speed.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if master counter is less than _TS_Slowdown.
   ;
   if _Master_Counter < _TS_Slowdown then goto __Skip_TS_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Number seed selection for rooms using joystick.
   ;
   if joy0right && _RoomRand < 255 then score = score + 1 : _RoomRand = _RoomRand + 1 : _TS_Slowdown = 11
   if joy0left && _RoomRand > 0 then score = score - 1 : _RoomRand = _RoomRand - 1 : _TS_Slowdown = 11
   if joy0up && _RoomRand < 255 then score = score + 1 : _RoomRand = _RoomRand + 1 : _TS_Slowdown = 2
   if joy0down && _RoomRand > 0 then score = score - 1 : _RoomRand = _RoomRand - 1 : _TS_Slowdown = 2

   ;```````````````````````````````````````````````````````````````
   ;  Clears master counter.
   ;
   _Master_Counter = 0

__Skip_TS_Counter



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
   ;  Continues to main loop setup if fire button or reset pressed.
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
   ;  Sets starting position of player's sprite.
   ;
   player1x = 17 : player1y = 15


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
   ;  Selects a random world if _RoomRand is zero.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips if _RoomRand is greater than 0.
   ;
   if _RoomRand then goto __Skip_Rand_World

   ;```````````````````````````````````````````````````````````````
   ;  Makes _RoomRand a random number.
   ;
   _RoomRand = rand : if !_RoomRand then _RoomRand = 1

   ;```````````````````````````````````````````````````````````````
   ;  Puts the world number in the score.
   ;
   temp4 = _RoomRand

   _sc2 = _sc2 & 240 : _sc3 = 0
   if temp4 >= 100 then _sc2 = _sc2 + 1 : temp4 = temp4 - 100
   if temp4 >= 100 then _sc2 = _sc2 + 1 : temp4 = temp4 - 100
   if temp4 >= 50 then _sc3 = _sc3 + 80 : temp4 = temp4 - 50
   if temp4 >= 30 then _sc3 = _sc3 + 48 : temp4 = temp4 - 30
   if temp4 >= 20 then _sc3 = _sc3 + 32 : temp4 = temp4 - 20
   if temp4 >= 10 then _sc3 = _sc3 + 16 : temp4 = temp4 - 10
   _sc3 = _sc3 | temp4

__Skip_Rand_World


   ;***************************************************************
   ;
   ;  Jumps to get special starting random number for rooms.
   ;
   goto __Special_Rand bank2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP (MAKES THE PROGRAM GO)
   ;
   ;
__Main_Loop



   ;***************************************************************
   ;
   ;  Main counters.
   ;
   ;  Controls animation speed.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Increments the master counter.
   ;
   _Master_Counter = _Master_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if master counter is less than 5.
   ;
   if _Master_Counter < 5 then goto __Skip_Frame_Counter

   ;```````````````````````````````````````````````````````````````
   ;  Increments frame counter.
   ;
   _Frame_Counter = _Frame_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Clears master counter.
   ;
   _Master_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Clears frame counter when it's time.
   ;
   if _Frame_Counter = 4 then _Frame_Counter = 0

__Skip_Frame_Counter



   ;***************************************************************
   ;
   ;  Clears joystick movement bits and next room bits.
   ;
   _Bit5_UD_Joy_Movement{5} = 0 : _Bit6_LR_Joy_Movement{6} = 0 : _Bit1_Next_Room_Up{1} = 0 : _Bit2_Next_Room_Down{2} = 0 : _Bit3_Next_Room_Left{3} = 0 : _Bit4_Next_Room_Right{4} = 0



   ;***************************************************************
   ;
   ;  Default standing still position for player1 sprite.
   ;
   player1color:
   _26
   _9C
   _9C
   _9C
   _DA
   _DA
   _3C
   _3C
   _3C
   _26
end

   player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %01011010
   %00111100
   %00011000
   %00111100
   %00111100
   %00011000
end



   ;***************************************************************
   ;
   ;  Up movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Up: Skips this section if joystick not moved up.
   ;
   if !joy0up then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Up: Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1x-11)/4

   temp6 = (player1y-11)/8

   if temp5 < 32 then if pfread(temp5,temp6) then goto __Skip_Joy0_Up

   temp4 = (player1x-16)/4

   if temp4 < 32 then if pfread(temp4,temp6) then goto __Skip_Joy0_Up

   temp3 = temp5 - 1

   if temp3 < 32 then if pfread(temp3,temp6) then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Up: Turns on up/down movement bit.
   ;
   _Bit5_UD_Joy_Movement{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Up: Moves player1 up.
   ;
   _P1_Up_Down = _P1_Up_Down - 1.18

   ;```````````````````````````````````````````````````````````````
   ;  Up: Sprite color for up movement.
   ;
   player1color:
   _26
   _9C
   _9C
   _9C
   _DA
   _DA
   _3C
   _26
   _26
   _26
end

   ;```````````````````````````````````````````````````````````````
   ;  Up: Skips if player hasn't gone past top edge.
   ;
   if player1y >= _c_Edge_Top then goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Up: Keeps player within the world.
   ;
   if _YRoom = _c_World_Limit_Top then player1y = _c_Edge_Top : goto __Skip_Joy0_Up

   ;```````````````````````````````````````````````````````````````
   ;  Up: Moves player to bottom of screen for the next room.
   ;
   player1y = _c_Edge_Bottom

   ;```````````````````````````````````````````````````````````````
   ;  Up: Moves player to next room above.
   ;
   _YRoom = _YRoom - 1

   _Bit1_Next_Room_Up{1} = 1

__Skip_Joy0_Up



   ;***************************************************************
   ;
   ;  Down movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Down: Skips this section if joystick not moved up.
   ;
   if !joy0down then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Down: Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1x-11)/4

   temp6 = (player1y+1)/8

   if temp5 < 32 then if pfread(temp5,temp6) then goto __Skip_Joy0_Down

   temp4 = (player1x-16)/4

   if temp4 < 32 then if pfread(temp4,temp6) then goto __Skip_Joy0_Down

   temp3 = temp5 - 1

   if temp3 < 32 then if pfread(temp3,temp6) then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Down: Turns on up/down movement bit.
   ;
   _Bit5_UD_Joy_Movement{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Down: Moves player1 down.
   ;
   _P1_Up_Down = _P1_Up_Down + 1.18

   ;```````````````````````````````````````````````````````````````
   ;  Down: Skips if player hasn't gone past bottom edge.
   ;
   if player1y <= _c_Edge_Bottom then goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Down: Keeps player within the world.
   ;
   if _YRoom = _c_World_Limit_Bottom then player1y = _c_Edge_Bottom : goto __Skip_Joy0_Down

   ;```````````````````````````````````````````````````````````````
   ;  Down: Moves player to top of screen for the next room.
   ;
   player1y = _c_Edge_Top

   ;```````````````````````````````````````````````````````````````
   ;  Down: Moves player to next room below.
   ;
   _YRoom = _YRoom + 1

   _Bit2_Next_Room_Down{2} = 1

__Skip_Joy0_Down



   ;***************************************************************
   ;
   ;  Left movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Left: Skips this section if joystick not moved left.
   ;
   if !joy0left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Left: Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1y-1)/8

   temp6 = (player1x-18)/4

   if temp6 < 32 then if pfread(temp6,temp5) then goto __Skip_Joy0_Left

   temp3 = (player1y-9)/8

   if temp6 < 32 then if pfread(temp6,temp3) then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Left: Turns on left/right movement bit.
   ;
   _Bit6_LR_Joy_Movement{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Left: Moves player1 left.
   ;
   _P1_Left_Right = _P1_Left_Right - 1.48

   ;```````````````````````````````````````````````````````````````
   ;  Left: Makes sure player1 sprite is facing the correct direction.
   ;
   REFP1 = 0

   ;```````````````````````````````````````````````````````````````
   ;  Left: Skips if player hasn't gone past left edge.
   ;
   if player1x >= _c_Edge_Left then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Left: Keeps player within the world.
   ;
   if _XRoom = _c_World_Limit_Left then player1x = _c_Edge_Left : goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Left: Skips if player already moved up to next room.
   ;
   if _Bit1_Next_Room_Up{1} then goto __Skip_Joy0_Left

   ;```````````````````````````````````````````````````````````````
   ;  Left: Moves player to right edge of screen for the next room.
   ;
   player1x = _c_Edge_Right

   ;```````````````````````````````````````````````````````````````
   ;  Left: Moves player to next room on the left.
   ;
   _XRoom = _XRoom - 1

   _Bit3_Next_Room_Left{3} = 1

__Skip_Joy0_Left



   ;***************************************************************
   ;
   ;  Right movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Right: Skips this section if joystick not moved right.
   ;
   if !joy0right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Right: Stops movement if a playfield pixel is in the way.
   ;
   temp5 = (player1y-1)/8

   temp6 = (player1x-9)/4

   if temp6 < 32 then if pfread(temp6,temp5) then goto __Skip_Joy0_Right

   temp3 = (player1y-9)/8

   if temp6 < 32 then if pfread(temp6,temp3) then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Right: Turns on right movement bit.
   ;
   _Bit6_LR_Joy_Movement{6} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Right: Moves player1 right.
   ;
   _P1_Left_Right = _P1_Left_Right + 1.48

   ;```````````````````````````````````````````````````````````````
   ;  Right: Makes sure player1 sprite is facing the correct direction.
   ;
   REFP1 = 8

   ;```````````````````````````````````````````````````````````````
   ;  Right: Skips if player hasn't gone past left edge.
   ;
   if player1x <= _c_Edge_Right then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Right: Keeps player within the world.
   ;
   if _XRoom = _c_World_Limit_Right then player1x = _c_Edge_Right : goto __Skip_Joy0_Right
   
   ;```````````````````````````````````````````````````````````````
   ;  Right: Skips if player already moved down to next room.
   ;
   if _Bit2_Next_Room_Down{2} then goto __Skip_Joy0_Right

   ;```````````````````````````````````````````````````````````````
   ;  Right: Moves player to left edge of screen for the next room.
   ;
   player1x = _c_Edge_Left

   ;```````````````````````````````````````````````````````````````
   ;  Right: Moves player to next room on the right.
   ;
   _XRoom = _XRoom + 1

   _Bit4_Next_Room_Right{4} = 1

__Skip_Joy0_Right



   ;***************************************************************
   ;
   ;  Up/down walking animation section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if joystick not moved up or down.
   ;
   if !_Bit5_UD_Joy_Movement{5} then goto __Done_UD_Anim

   ;```````````````````````````````````````````````````````````````
   ;  Animates player1 sprite for up/down movement.
   ;
   on _Frame_Counter goto __FrameD0 __FrameD1 __FrameD2 __FrameD3

__Done_UD_Anim



   ;***************************************************************
   ;
   ;  Left/right walking animation section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if joystick not moved left or right.
   ;
   if !_Bit6_LR_Joy_Movement{6} then goto __Done_LR_Anim

   ;```````````````````````````````````````````````````````````````
   ;  Sets player1 left/right color.
   ;
   player1color:
   _26
   _9C
   _9C
   _9C
   _DA
   _DA
   _3C
   _3C
   _3C
   _26
end

   ;```````````````````````````````````````````````````````````````
   ;  Animates player1 sprite for left/right movement.
   ;
   on _Frame_Counter goto __FrameLR0 __FrameLR1 __FrameLR2 __FrameLR3

__Done_LR_Anim



   ;```````````````````````````````````````````````````````````````
   ;
   ;  MORE CODE CAN GO HERE.
   ;
   ;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



   ;***************************************************************
   ;
   ;  Continues program in Bank 2.
   ;
   goto __Continue_in_Bank_2 bank2





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Left/right animation frames for player1.
   ;
__FrameLR0
   player1:
   %01100110
   %01100110
   %00111100
   %00001100
   %00111100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_LR_Anim


__FrameLR1
   player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111100
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_LR_Anim


__FrameLR2
   player1:
   %00110110
   %00110110
   %00011100
   %00001100
   %00111100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_LR_Anim


__FrameLR3
   player1:
   %00111100
   %00011100
   %00011100
   %00000100
   %00011100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_LR_Anim



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Up/down animation frames for player1.
   ;
__FrameD0
   player1:
   %01100110
   %00100100
   %00011100
   %00011000
   %01111010
   %00111100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_UD_Anim
__FrameD1
   player1:
   %01100000
   %00100110
   %00111100
   %00011000
   %00111110
   %00111110
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_UD_Anim


__FrameD2
   player1:
   %01100110
   %00100100
   %00111000
   %00011000
   %01011110
   %00111100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_UD_Anim


__FrameD3
   player1:
   %00000110
   %01100100
   %00111100
   %00011000
   %01111100
   %01111100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_UD_Anim





   bank 2





__Continue_in_Bank_2



   ;```````````````````````````````````````````````````````````````
   ;
   ;  MORE CODE CAN GO HERE.
   ;
   ;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



   ;***************************************************************
   ;
   ;  Displays next room when it's time.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if next room bits are off.
   ;
   if !_Bit1_Next_Room_Up{1} && !_Bit2_Next_Room_Down{2} && !_Bit3_Next_Room_Left{3} && !_Bit4_Next_Room_Right{4} then goto __Done_Next_Room

   ;```````````````````````````````````````````````````````````````
   ;  Skips bBRand section if player didn't move right or down.
   ;
   if !_Bit4_Next_Room_Right{4} && !_Bit2_Next_Room_Down{2} then goto __Skip_bBRand

__Special_Rand

   _Temp = 0

   ;```````````````````````````````````````````````````````````````
   ;  Special Rand for rooms.
   ;
__bBRand
   asm
   lda _RoomRand
   lsr
   bcc __bB_Rand_no_eor
   eor #$B4
__bB_Rand_no_eor
   sta _RoomRand
end

   ;```````````````````````````````````````````````````````````````
   ;  Loops if player moves down to next room.
   ;
   if _Bit2_Next_Room_Down{2} then _Temp = _Temp + 1 : if _Temp <= _c_World_Limit_Right then goto __bBRand

   ;```````````````````````````````````````````````````````````````
   ;  Sets current scene variable.
   ;
   _CurrentScene = _RoomRand

__Skip_bBRand

   ;```````````````````````````````````````````````````````````````
   ;  Skips UnRand section if player didn't move up or left.
   ;
   if !_Bit1_Next_Room_Up{1} && !_Bit3_Next_Room_Left{3} then goto __Skip_UnRand

   _Temp = 0

   ;```````````````````````````````````````````````````````````````
   ;  Special UnRand for rooms.
   ;
__UnRand
   asm
   LDA _RoomRand
   ASL
   BCC __UnRand_no_eor
   EOR #$69
__UnRand_no_eor:
   STA _RoomRand
   STA _CurrentScene
end

   ;```````````````````````````````````````````````````````````````
   ;  Loops if player moves up to next room.
   ;
   if _Bit1_Next_Room_Up{1} then _Temp = _Temp + 1 : if _Temp <= _c_World_Limit_Right then goto __UnRand

__Skip_UnRand

   ;```````````````````````````````````````````````````````````````
   ;  Limits the current scene.
   ;
   _CurrentScene = (_CurrentScene&31)

   ;```````````````````````````````````````````````````````````````
   ;  Checks visited room.
   ;
   _Temp = _VisitedRooms[_YRoom]
   temp5 = _Data_Number_to_Bit[_XRoom]
   _Temp = (_Temp&temp5)

   ;```````````````````````````````````````````````````````````````
   ;  Displays or removes lives icon.
   ;
   if _Temp && lives < 32 then lives = lives + 32
   if !_Temp && lives >= 32 then lives = lives - 32

   ;```````````````````````````````````````````````````````````````
   ;  Sets visited room.
   ;
   _Temp = _VisitedRooms[_YRoom]
   temp5 = _Data_Number_to_Bit[_XRoom]
   _VisitedRooms[_YRoom] = (_Temp|temp5)

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the where current scene is drawn.
   ;
   goto __Set_Current_Scene

__Done_Next_Room



   ;```````````````````````````````````````````````````````````````
   ;
   ;  MORE CODE CAN GO HERE.
   ;
   ;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



   ;***************************************************************
   ;
   ;  Displays the screen.
   ;
   drawscreen



   ;***************************************************************
   ;
   ;  Continues program in Bank 3.
   ;
   goto __Continue_in_Bank_3 bank3





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sets the colors and playfield design of the current room.
   ;
__Set_Current_Scene
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Sets the playfield background and foreground color.
   ;
   COLUBK = _Data_Background_Color[_CurrentScene]
   COLUPF = _Data_Foreground_Color[_CurrentScene]

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to the current scene to be displayed.
   ;
   on _CurrentScene goto __s0 __s1 __s2 __s3 __s4 __s5 __s6 __s7 __s8 __s9 __sA __sB __sC __sD __sE __sF __sG __sH __sI __sJ __sK __sL __sM __sN __sO __sP __sQ __sR __sS __sT __sU __sV


__s0
   playfield:
   ................................
   ................................
   ..............X.................
   .............XXX.......X........
   ............XXXXX.....XXX.......
   ......X..............XXXXX......
   .....XXX............XXXXXXX.....
   ....XXXXX..........XXXXXXXXX....
   ...XXXXXXX......................
   ................................
   ................................
end

   goto __Done_Next_Room

   
__s1
   playfield:
   ................................
   ................................
   ....XXXX...XXXXXXXXXX...XXXX....
   ................................
   ................................
   ....XXXXXXXXXXXXXXXXXXXXXXXX....
   ................................
   ................................
   ....XXXX...XXXXXXXXXX...XXXX....
   ................................
   ................................
end

   goto __Done_Next_Room

   
__s2
   playfield:
   ................................
   ................................
   .......XXX............XXX.......
   ......XXXXX..........XXXXX......
   .......XXX............XXX.......
   ................................
   ..............XXXX..............
   .............XXXXXX.............
   ..............XXXX..............
   ................................
   ................................
end

   goto __Done_Next_Room


__s3
   playfield:
   ................................
   ................................
   ....XXXXX...XXXXXXX...XXXXXX....
   ....XXXXX...XXXXXXX...XXXXXX....
   ................................
   ................................
   ................................
   ....XXXXX...XXXXXXX...XXXXXX....
   ....XXXXX...XXXXXXX...XXXXXX....
   ................................
   ................................
end

   goto __Done_Next_Room


__s4
   playfield:
   ................................
   ................................
   ...............X................
   ..............XXX...............
   .............XXXXX..............
   ...........XXXXXXXXX............
   .........XXXXXXXXXXXXX..........
   .......XXXXXXXXXXXXXXXXX........
   .....XXXXXXXXXXXXXXXXXXXXX......
   ................................
   ................................
end

   goto __Done_Next_Room


__s5
   playfield:
   ................................
   ................................
   ....X.....X.....................
   ...XXX...XXX.........X..........
   ....X.....X.........XXX.........
   .....................X..........
   ...............X..........X.....
   ..............XXX........XXX....
   ...............X..........X.....
   ................................
   ................................
end

   goto __Done_Next_Room


__s6
   playfield:
   ................................
   ................................
   ............XX....XX............
   ............XX....XX............
   ....XXXXXX............XXXXXX....
   ....XXXXXX............XXXXXX....
   ....XXXXXX............XXXXXX....
   ............XX....XX............
   ............XX....XX............
   ................................
   ................................
end

   goto __Done_Next_Room


__s7
   playfield:
   ................................
   ................................
   ................XXXXXXXX........
   ..........XXXXXXXXXXXXXXX.......
   .........XXXXXXXXXXXXXX.........
   ........XXXXXXXXXXXXXXX.........
   ........XXXXXXXXXXXXXXXXXX......
   .........XXXXXXXXXXXXXXXXX......
   ............XXXXX..XXXXXX.......
   ................................
   ................................
end

   goto __Done_Next_Room


__s8
   playfield:
   ................................
   ................................
   ........XXXXXXXXX........X......
   ......XXXXXXXXXXXX......XXX.....
   .....XXXXXXXXXXXXX.....XXXXX....
   .....XXXXXXXXXXXX.....XXXXXXX...
   ......XX..XXXXXXX........X......
   ......XX..XXXXXX.........X......
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__s9
   playfield:
   ................................
   ................................
   ................................
   .....XXX........................
   ....XXXXX...........XXX.........
   ....XXXXX..........XXXXX........
   .....XXX...........XXXXX........
   ....................XXX.........
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__sA
   playfield:
   ................................
   ................................
   ....XXXXXX..XXXXXXXX..XXXXXX....
   ....XX....................XX....
   ....XX....................XX....
   ................................
   ................................
   ....XX....................XX....
   ....XXXXXX..XXXXXXXX..XXXXXX....
   ................................
   ................................
end
   goto __Done_Next_Room


__sB
   playfield:
   ................................
   ................................
   .......XXXX.....................
   .....XXXXXXXX...................
   ...XXXXXXXXXXXX.................
   .....XXXXXXXX...................
   .......XXXX............XXX......
   ......................XXXXX.....
   .......................XXX......
   ................................
   ................................
end

   goto __Done_Next_Room


__sC
   playfield:
   ................................
   ................................
   ......XXX...XXXXXXXX...XXX......
   ....XXXXXX....XXXX....XXXXXX....
   ...XXXXXXX....XXXX....XXXXXXX...
   ...XXXXXX.....XXXX.....XXXXXX...
   ....XXXX......XXXX......XXXX....
   ....XXX.....XXXXXXXX.....XXX....
   ....XXXX...XXXXXXXXXX...XXXX....
   ................................
   ................................
end

   goto __Done_Next_Room


__sD
   playfield:
   ................................
   ................................
   ..........XXXXXXXXXXXX..........
   ........XXXXXXXXXXXXXXXX........
   ........XXXXXXXXXXXXXXXX........
   ........XXXXXXXXXXXXXXXX........
   ........XXXXXXXXXXXXXXXX........
   ........XXXXXXXXXX..XXXX........
   ..........XXXXXXXX..XXX.........
   ................................
   ................................
end

   goto __Done_Next_Room


__sE
   playfield:
   ................................
   ................................
   ....XXXXXXXXXX....XXXXXXXXXX....
   ....XX....................XX....
   ....XX....................XX....
   ....XX....................XX....
   ............XXX..XXX............
   ............XXX..XXX............
   ....XXXXXX..XXX..XXX..XXXXXX....
   ................................
   ................................
end

   goto __Done_Next_Room


__sF
   playfield:
   ................................
   ................................
   ..........XXXXXXX...............
   .........XXXXXXXXXX.............
   .......XXXXXXXXXXXXXX...........
   ......XXXXXXXXXXXXXXX...........
   .......XXXXXXXXXXXXX............
   ..........XXXXXXX...............
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__sG
   playfield:
   ................................
   ................................
   ....XXXX................XXXX....
   ....XXXX................XXXX....
   ....XXXX................XXXX....
   ....XXXXXXXXX......XXXXXXXXX....
   ................................
   ................................
   ....XXXXXXXXX......XXXXXXXXX....
   ................................
   ................................
end

   goto __Done_Next_Room


__sH
   playfield:
   ................................
   ................................
   ...XXXXXXX......................
   ....XXXXX..........XXXXXXXXX....
   .....XXX............XXXXXXX.....
   ......X..............XXXXX......
   ............XXXXX.....XXX.......
   .............XXX.......X........
   ..............X.................
   ................................
   ................................
end

   goto __Done_Next_Room


__sI
   playfield:
   ................................
   ................................
   ....XXXXX..XX..XX..XX..XXXXX....
   ....XXXXX..XX..XX..XX..XXXXX....
   ....XXXXX..XX..XX..XX..XXXXX....
   ....XXXXX..XX..XX..XX..XXXXX....
   ...........XX..XX..XX...........
   ...........XX..XX..XX...........
   ....XXXXXXXXX..XX..XXXXXXXXX....
   ................................
   ................................
end

   goto __Done_Next_Room


__sJ
   playfield:
   ................................
   ................................
   ...................XX...........
   ..................XXXX..........
   .................XXXXXX.........
   ......XX.........XX..XX.........
   .....XXXX.......................
   ....XXXXXX......................
   ....XX..XX......................
   ................................
   ................................
end

   goto __Done_Next_Room


__sK
   playfield:
   ................................
   ................................
   ..............XXX...............
   .............XXXXX..............
   ..............XXX...............
   ................................
   .......XXX...........XXX........
   ......XXXXX.........XXXXX.......
   .......XXX...........XXX........
   ................................
   ................................
end

   goto __Done_Next_Room


__sL
   playfield:
   ................................
   ................................
   .....XX..XXXXXXXXXXXXXXXXXX.....
   .....XX..XX.....................
   .....XX..XX.....................
   .....XX..XX...XXXXXXXXXXXXX.....
   .....XX..XX...XX.........XX.....
   .....XX..XX...XX.........XX.....
   .....XX..XX...XX..XXXXX..XX.....
   ................................
   ................................
end

   goto __Done_Next_Room


__sM
   playfield:
   ................................
   ................................
   .......XXXXXXXXXX...............
   .....XXXXXXXXXXXXX..............
   .....XXXXXXXXXXXXX..............
   .....XXXXXXXXXXXXX..............
   .....XXX..XXXXXXXX.......XXX....
   ......XX..XXXXXXX........XXX....
   ................................
   ................................
   ................................
end


   goto __Done_Next_Room


__sN
   playfield:
   ................................
   ................................
   ......X.........XXXXXXX.........
   .....XXX......XXXXXXXXXXX.......
   ....XXXXX.....XXXXXXXXXXXX......
   ...XXXXXXX....XXXXXXXXXXXX......
   ......X.......XXX..XXXXXXX......
   ......X........XX..XXXXXX.......
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__sO
   playfield:
   ................................
   ................................
   ..................XXXXX.........
   ..................XXXXXXX.......
   ...................XXXXX........
   ................................
   .........XXXXX..................
   .......XXXXXXX..................
   ........XXXXX...................
   ................................
   ................................
end

   goto __Done_Next_Room


__sP
   playfield:
   ................................
   ................................
   .....XXXXXXXXXXXXXXXXXXXXXX.....
   .....XXX................XXX.....
   .....XXX................XXX.....
   .....XXX..XXXXXXXXXXXX..XXX.....
   .....XXX..XXXXXXXXXXXX..XXX.....
   .....XXX..XXXXXXXXXXXX..XXX.....
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__sQ
   playfield:
   ................................
   ................................
   .........XXX........XXX.........
   .......XXXXXXX....XXXXXXX.......
   ................................
   ................................
   ................................
   .......XXXXXXX....XXXXXXX.......
   .........XXX........XXX.........
   ................................
   ................................
end

   goto __Done_Next_Room


__sR
   playfield:
   ................................
   ................................
   .....XXXXXXXXXX..XXXX..XXXX.....
   .....XXXXXXXXXX..XXXX..XXXX.....
   .................XXXX..XXXX.....
   .................XXXX..XXXX.....
   .....XXXXXXXXXX..XXXX..XXXX.....
   .....XXXXXXXXXX..XXXX..XXXX.....
   ................................
   ................................
   ................................
end

   goto __Done_Next_Room


__sS
   playfield:
   ................................
   ................................
   ............XXX..XXX............
   ..........XXXXX..XXXXX..........
   ................................
   ................................
   ................................
   ..........XXXXX..XXXXX..........
   ............XXX..XXX............
   ................................
   ................................
end

   goto __Done_Next_Room


__sT
   playfield:
   ................................
   ................................
   .....XXX..XXXX....XXXX..XXX.....
   .....XXX..XXXXXXXXXXXX..XXX.....
   ................................
   ................................
   .....XXX..XXXXXXXXXXXX..XXX.....
   .....XXX..XXXX....XXXX..XXX.....
   .....XXX..XXXX....XXXX..XXX.....
   ................................
   ................................
end

   goto __Done_Next_Room


__sU
   playfield:
   ................................
   ................................
   ............XXX..XXX............
   ..........XXXXX..XXXXX..........
   .........XXXXXX..XXXXXX.........
   ........XXXXXXX..XXXXXXX........
   .........XXXXXX..XXXXXX.........
   ..........XXXXX..XXXXX..........
   ............XXX..XXX............
   ................................
   ................................
end

   goto __Done_Next_Room


__sV
   playfield:
   ................................
   ................................
   .....XXXXXXXXX....XXXXXXXXX.....
   .....XXXXXXXXX....XXXXXXXXX.....
   .....XXXX..............XXXX.....
   ................................
   ...........XXX....XXX...........
   ...........XXX....XXX...........
   .....XXXXXXXXX....XXXXXXXXX.....
   ................................
   ................................
end

   goto __Done_Next_Room





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Playfield background color data.
   ;
   data _Data_Background_Color
   _20
   _30
   _50
   _B0
   _C0
   _D0
   _E0
   _F0

   _80
   _62
   _C2
   _60
   _40
   _D2
   _30
   _D0

   _62
   _62
   _90
   _90
   _D0
   _D0
   _40
   _40

   _C2
   _C0
   _20
   _22
   _22
   _D2
   _C2
   _22
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Playfield foreground color data.
   ;
   data _Data_Foreground_Color
   _BC
   _3C
   _BC
   _CC
   _2C
   _0C
   _BC
   _AC

   _9C
   _6C
   _CC
   _3C
   _CC
   _9C
   _CC
   _2C

   _5C
   _9C
   _BC
   _5C
   _2C
   _4C
   _0C
   _3C

   _0C
   _AC
   _CC
   _4C
   _3C
   _EC
   _4C
   _2E
end



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Data for converting a room number into a bit (visited rooms).
   ;
   data _Data_Number_to_Bit
   %00000001
   %00000010
   %00000100
   %00001000
   %00010000
   %00100000
   %01000000
   %10000000
end





   bank 3





__Continue_in_Bank_3



   ;```````````````````````````````````````````````````````````````
   ;
   ;  MORE CODE CAN GO HERE.
   ;
   ;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



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
   if !switchreset then _Bit0_Reset_Restrainer{0} = 0 : goto __Main_Loop bank1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to beginning of main loop if the reset switch hasn't
   ;  been released after being pressed.
   ;
   if _Bit0_Reset_Restrainer{0} then goto __Main_Loop bank1

   ;```````````````````````````````````````````````````````````````
   ;  Restarts the program.
   ;
   goto __Start_Restart bank1





   bank 4





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Life counter minikernel.
   ;
   inline 6lives.asm
