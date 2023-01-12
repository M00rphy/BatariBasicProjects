   ;***************************************************************
   ;
   ;  Jumping Sprite Example Program
   ;
   ;  Example program by Duane Alan Hahn (Random Terrain) using
   ;  hints, tips, code snippets, and more from AtariAge members
   ;  such as batari, SeaGtGruff, RevEng, Robert M, Nukey Shay,
   ;  Atarius Maximus, jrok, supercat, GroovyBee, and bogax.
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
   ;  and the name. Example: _Bit7_Reset_Restrainer 
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Player1 left/right movement.
   ;
   dim _P1_Left_Right = player1x.a

   ;```````````````````````````````````````````````````````````````
   ;  Limits how high player can jump and affects speed slowdown.
   ;
   dim _Jump_Gravity_Counter = b

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity fall counter.
   ;
   dim _Fall_Gravity_Counter = c

   ;```````````````````````````````````````````````````````````````
   ;  Controls animation speed.
   ;
   dim _Master_Counter = d

   ;```````````````````````````````````````````````````````````````
   ;  Animation counter.
   ;
   dim _Frame_Counter = e

   ;```````````````````````````````````````````````````````````````
   ;  Channel 0 sound variables.
   ;
   dim _Ch0_Sound = f
   dim _Ch0_Duration = g
   dim _Ch0_Counter = h

   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;  All-purpose bits for various jobs.
   ;
   dim _BitOp_01 = y
   dim _Bit2_Fall_in_Progress = y      ; Player is falling if on.
   dim _Bit3_FireB_Restrainer = y      ; Player can't hold down fire button to jump.
   dim _Bit4_Flip_P1 = y               ; Flips player sprite when necessary.
   dim _Bit5_LR_Joy_Movement = y       ; Left or right joystick movement happened.
   dim _Bit6_Duck_in_Progress = y      ; Allows player to slide while duckting.
   dim _Bit7_Reset_Restrainer = y      ; Restrains the reset switch.



   ;***************************************************************
   ;
   ;  Constants for channel 0 sound effects (_Ch0_Sound).
   ;  [The c stands for constant.]
   ;
   const _c_Jump_Sound = 1



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
   ;  Clears all normal variables.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0





   ;***************************************************************
   ;***************************************************************
   ;
   ;  MAIN LOOP SETUP
   ;
   ;
__Main_Loop_Setup


   ;***************************************************************
   ;
   ;  Sets position of player1 sprite.
   ;
   player1x = 79 : player1y = 79


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit7_Reset_Restrainer{7} = 1


   ;***************************************************************
   ;
   ;  Sets up the playfield.
   ;
   playfield:
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
   ;  Sets colors.
   ;
   COLUPF = _C4 : COLUBK = _00



   ;***************************************************************
   ;
   ;  Controls animation speed.
   ;
   _Master_Counter = _Master_Counter + 1

   if _Master_Counter < 4 then goto __Skip_Frame_Counter

   _Frame_Counter = _Frame_Counter + 1 : _Master_Counter = 0

   if _Frame_Counter = 4 then _Frame_Counter = 0

__Skip_Frame_Counter



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
   ;  Fire button (jump) section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if fire button is not pressed.
   ;
   if !joy0fire then _Jump_Gravity_Counter = 0 : _Bit3_FireB_Restrainer{3} = 0 : goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Used when player moves left/right while jumping or falling.
   ;
   if !_Bit3_FireB_Restrainer{3} then player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111101
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Arms up sprite used if player isn't moving left or right.
   ;
   if !joy0left && !joy0right && !_Bit3_FireB_Restrainer{3} then  player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %00011000
   %01111110
   %10011001
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Skips jump if player is falling.
   ;
   if _Bit2_Fall_in_Progress{2} then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips jump if fire button restrainer bit is on and jump and
   ;  fall are not happening. Fixes it so the player can't hold
   ;  down the fire button to jump repeatedly.
   ;
   if _Bit3_FireB_Restrainer{3} && !_Bit2_Fall_in_Progress{2} && !_Jump_Gravity_Counter then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Starts jumping sound effect if jump is not happening.
   ;
   if !_Jump_Gravity_Counter then _Ch0_Sound = _c_Jump_Sound : _Ch0_Duration = 1 : _Ch0_Counter = 0

   ;```````````````````````````````````````````````````````````````
   ;  Turns on restrainer bit for fire button.
   ;
   _Bit3_FireB_Restrainer{3} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Adds one to the jump counter.
   ;
   _Jump_Gravity_Counter = _Jump_Gravity_Counter + 1 

   ;```````````````````````````````````````````````````````````````
   ;  Resets jump counter if limit is reached and starts a fall.
   ;  The higher the number used here, the higher the jump.
   ;
   if _Jump_Gravity_Counter > 12 then _Jump_Gravity_Counter = 0 : _Bit2_Fall_in_Progress{2} = 1 : goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Jump happens here.  
   ;
   ;  Skips jump if player1 sprite is at top edge of screen.
   ;
   if player1y < 13 then goto __Skip_Jump

   ;```````````````````````````````````````````````````````````````
   ;  Changes speed of jump over time depending on counter number.
   ;  (Slows down the higher it goes.)
   ;
   if _Jump_Gravity_Counter <= 7 then temp6 = 3
   if _Jump_Gravity_Counter > 7 && _Jump_Gravity_Counter <= 10 then temp6 = 2
   if _Jump_Gravity_Counter > 10 then temp6 = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 sprite up the screen.
   ;
   player1y = player1y - temp6

__Skip_Jump



   ;***************************************************************
   ;
   ;  Fall down section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips section if player is jumping.
   ;
   if _Jump_Gravity_Counter then goto __Skip_Fall_01

   ;```````````````````````````````````````````````````````````````
   ;  Skips section if player is on the ground.
   ;
   if player1y >= 79 then player1y = 80 : goto __Skip_Fall_01

   ;```````````````````````````````````````````````````````````````
   ;  Used when player moves left/right while jumping or falling.
   ;
   player1:
   %11000011
   %01100011
   %00111110
   %00011100
   %00111101
   %01011110
   %00011000
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Arms up sprite used if player isn't moving left or right.
   ;
   if !joy0left && !joy0right then player1:
   %01100110
   %00100100
   %00111100
   %00011000
   %00011000
   %01111110
   %10011001
   %00111100
   %00111100
   %00011000
end

   ;```````````````````````````````````````````````````````````````
   ;  Adds one to the gravity counter.
   ;
   _Fall_Gravity_Counter = _Fall_Gravity_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Fake gravity fall (speed keeps increasing during a fall).
   ;
   temp6 = 0
   if _Fall_Gravity_Counter > 8 && _Jump_Gravity_Counter <= 16 then temp6 = 1
   if _Fall_Gravity_Counter > 16 && _Jump_Gravity_Counter <= 24 then temp6 = 2
   if _Fall_Gravity_Counter > 24 && _Jump_Gravity_Counter <= 32 then temp6 = 3
   if _Fall_Gravity_Counter > 32 then temp6 = 4

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 down the screen.
   ;
   player1y = player1y + temp6

   ;```````````````````````````````````````````````````````````````
   ;  Lets the program know a fall is in progress.
   ;
   _Bit2_Fall_in_Progress{2} = 1

   goto __Skip_Fall_02

__Skip_Fall_01

   ;```````````````````````````````````````````````````````````````
   ;  Not falling. Clears related variables.
   ;
   _Bit2_Fall_in_Progress{2} = 0 : _Fall_Gravity_Counter = 0

__Skip_Fall_02



   ;***************************************************************
   ;
   ;  Clears left/right joystick movement bit.
   ;
   _Bit5_LR_Joy_Movement{5} = 0



   ;***************************************************************
   ;
   ;  Left movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick not moved left.
   ;
   if !joy0left then goto __Skip_Joy0Left

   ;```````````````````````````````````````````````````````````````
   ;  Turns on left/right movement bit.
   ;
   _Bit5_LR_Joy_Movement{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 left if not hitting border.
   ;
   if player1x > 17 then _P1_Left_Right = _P1_Left_Right - 1.38

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player1 sprite is facing the correct direction.
   ;
   _Bit4_Flip_P1{4} = 0

__Skip_Joy0Left



   ;***************************************************************
   ;
   ;  Right movement section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if joystick not moved left.
   ;
   if !joy0right then goto __Skip_Joy0Right

   ;```````````````````````````````````````````````````````````````
   ;  Turns on left/right movement bit.
   ;
   _Bit5_LR_Joy_Movement{5} = 1

   ;```````````````````````````````````````````````````````````````
   ;  Moves player1 right if not hitting border.
   ;
   if player1x < 137 then _P1_Left_Right = _P1_Left_Right + 1.38

   ;```````````````````````````````````````````````````````````````
   ;  Makes sure player1 sprite is facing the correct direction.
   ;
   _Bit4_Flip_P1{4} = 1

__Skip_Joy0Right



   ;***************************************************************
   ;
   ;  Left/right walking animation section.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if joystick not moved left or right.
   ;
   if !_Bit5_LR_Joy_Movement{5} then  goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if player1 sprite is jumping or falling.
   ;
   if _Jump_Gravity_Counter || _Bit2_Fall_in_Progress{2} then goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Skips animation if player1 sprite is hitting left/right edge.
   ;
   if player1x < 18 || player1x > 136 then goto __Done_Anim_jump

   ;```````````````````````````````````````````````````````````````
   ;  Sets player1 color.
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
   ;  Animates player1 sprite.
   ;
   on _Frame_Counter goto __Frame0 __Frame1 __Frame0 __Frame2

__Done_Anim_jump



   ;****************************************************************
   ;
   ;  Flips player1 sprite horizontally when necessary.
   ;
   if _Bit4_Flip_P1{4} then REFP1 = 8



   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if duration counter is greater
   ;  than zero
   ;
   if _Ch0_Duration then goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Channel 0 sound effect 001.
   ;
   ;  Jump sound effect.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> _c_Jump_Sound then goto __Skip_Ch0_Sound_001

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 0 data.
   ;
   temp4 = _SD_Jump[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets Duration.
   ;
   _Ch0_Duration = _SD_Jump[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Other channel 0 sound effects go here.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (This catches any mistakes.)
   ;
   goto __Skip_Ch_0



   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__Clear_Ch_0
   
   _Ch0_Sound = 0 : AUDV0 = 0



   ;***************************************************************
   ;
   ;  End of channel 0 area.
   ;
__Skip_Ch_0



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
   if !switchreset then _Bit7_Reset_Restrainer{7} = 0 : goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  If reset switch hasn't been released after being pressed,
   ;  program jumps to beginning of main loop.
   ;
   if _Bit7_Reset_Restrainer{7} then goto __Main_Loop

   ;```````````````````````````````````````````````````````````````
   ;  Reset pressed correctly, so the the program is restarted.
   ;
   goto __Start_Restart




   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  End of main loop.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data starts here.
   ;
   ;***************************************************************
   ;***************************************************************
   ;
   ;  Sound data for jump.
   ;
   data _SD_Jump
   1,12,31
   1
   8,12,31
   1
   6,12,31
   1
   8,12,31
   1
   8,12,30
   1
   8,12,29
   1
   8,12,28
   1
   8,12,27
   1
   8,12,26
   1
   8,12,25
   1
   8,12,24
   1
   8,12,23
   1
   8,12,22
   1
   8,12,21
   1
   8,12,20
   1
   8,12,19
   1
   6,12,18
   1
   4,12,17
   1
   2,12,16
   2
   0,0,0
   8
   255
end





   ;***************************************************************
   ;***************************************************************
   ;
   ;  Animation frames for player1.
   ;
__Frame0
   player1:
   %01100110
   %00100110
   %00111100
   %00011100
   %00111100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_Anim_jump


__Frame1
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

   goto __Done_Anim_jump


__Frame2
   player1:
   %00111100
   %00011100
   %00011100
   %00011100
   %00011100
   %00011100
   %00011000
   %00111100
   %00111100
   %00011000
end

   goto __Done_Anim_jump