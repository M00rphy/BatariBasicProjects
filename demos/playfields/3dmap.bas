   ;****************************************************************
   ;
   ;  This program uses the DPC+ kernel.
   ;
   set kernel DPC+


   ;****************************************************************
   ;
   ;  Standard used in North America and most of South America.
   ;
   set tv ntsc


   ;****************************************************************
   ;
   ;  Helps player1 sprites register a collision with the playfield.
   ;
   set kernel_options collision(player1,playfield)


   ;***************************************************************
   ;
   ;  Variable aliases go here (DIMs).
   ;
   ;***************************************************************
   ;
   ;  (You can have more than one alias for each variable.)
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Scroll counter.
   ;
   dim _Scroll_Counter = a

   ;```````````````````````````````````````````````````````````````
   ;  Bits for various jobs.
   ;
   dim _Bit0_Reset_Restrainer = y
   dim _Bit7_Flip_Scroll = y



   goto __Bank_2 bank2



   bank 2
   temp1=temp1



__Bank_2



   ;***************************************************************
   ;***************************************************************
   ;
   ;  Program Start/Restart
   ;
__Start_Restart


   ;***************************************************************
   ;
   ;  Displays the screen to avoid going over 262 when reset.
   ;
   drawscreen


   ;***************************************************************
   ;
   ;  Clears the playfield.
   ;
   pfclear


   ;***************************************************************
   ;
   ;  Mutes volume of both sound channels.
   ;
   AUDV0 = 0 : AUDV1 = 0


   ;***************************************************************
   ;
   ;  Clears all normal variables and the extra 9.
   ;
   a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
   j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
   s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0
   var0 = 0 : var1 = 0 : var2 = 0 : var3 = 0 : var4 = 0
   var5 = 0 : var6 = 0 : var7 = 0 : var8 = 0


   ;***************************************************************
   ;
   ;  Playfield data.
   ;
   playfield:
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
   .X....X..X....X..X....X..X....X.
   .XXXXXX..XXXXXX..XXXXXX..XXXXXX.
end


   ;***************************************************************
   ;
   ;  Playfield colors.
   ;
   pfcolors:
   $0E
   $0C
   $0A
   $08
   $06
   $1E
   $1C
   $1A
   $18
   $16
   $2E
   $2C
   $2A
   $28
   $26
   $3E
   $3C
   $3A
   $38
   $36
   $4E
   $4C
   $4A
   $48
   $46
   $5E
   $5C
   $5A
   $58
   $56
   $6E
   $6C
   $6A
   $68
   $66
   $7E
   $7C
   $7A
   $78
   $76
   $9E
   $9C
   $9A
   $98
   $96
   $AE
   $AC
   $AA
   $A8
   $A6
   $BE
   $BC
   $BA
   $B8
   $B6
   $CE
   $CC
   $CA
   $C8
   $C6
   $DE
   $DC
   $DA
   $D8
   $D6
   $EE
   $EC
   $EA
   $E8
   $E6
   $3E
   $3C
   $3A
   $38
   $36
   $4E
   $4C
   $4A
   $48
   $46
   $5E
   $5C
   $5A
   $58
   $56
   $6E
   $6C
   $6A
   $68
   $66
   $7E
   $7C
   $7A
   $78
   $76
   $8E
   $8C
   $8A
   $88
   $86
   $9E
   $9C
   $9A
   $98
   $96
   $BE
   $BC
   $BA
   $B8
   $B6
   $CE
   $CC
   $CA
   $C8
   $C6
   $FE
   $FC
   $FA
   $F8
   $F6
end


   ;***************************************************************
   ;
   ;  Background colors.
   ;
   bkcolors:
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $8E
   $80
   $82
   $84
   $86
   $88
   $8A
   $8C
   $80
end


   ;***************************************************************
   ;
   ;  Score colors.
   ;
   scorecolors:
   $1E
   $1C
   $1A
   $1A
   $18
   $18
   $16
   $16
end


   ;***************************************************************
   ;
   ;  Restrains the reset switch for the main loop.
   ;
   ;  This bit fixes it so the reset switch becomes inactive if
   ;  it hasn't been released after being pressed once.
   ;
   _Bit0_Reset_Restrainer{0} = 1




   ;***************************************************************
   ;***************************************************************
   ;
   ;  Main Loop
   ;
__Main_Loop



   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````
   ;
   ;  Gameplay logic goes here.
   ;
   ;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ;```````````````````````````````````````````````````````````````



   ;***************************************************************
   ;
   ;  Scrolls the foreground color up and down.
   ;
   _Scroll_Counter = _Scroll_Counter + 1

   if _Bit7_Flip_Scroll{7} then pfscroll 255 4 4

   if !_Bit7_Flip_Scroll{7} then pfscroll 1 4 4

   if _Scroll_Counter < 32 then goto __Skip_Scroll

   _Scroll_Counter = 0

   _Bit7_Flip_Scroll{7} = !_Bit7_Flip_Scroll{7}

__Skip_Scroll



   ;***************************************************************
   ;
   ;  88 rows that are 2 scanlines high.
   ;
   DF6FRACINC = 255 ; Background colors.
   DF4FRACINC = 255 ; Playfield colors.

   DF0FRACINC = 128 ; Column 0.
   DF1FRACINC = 128 ; Column 1.
   DF2FRACINC = 128 ; Column 2.
   DF3FRACINC = 128 ; Column 3.



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



   bank 3
   temp1=temp1


   bank 4
   temp1=temp1


   bank 5
   temp1=temp1


   bank 6
   temp1=temp1