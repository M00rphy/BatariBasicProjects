 rem *******************************************************************
 rem ** Demo of playercolors+no_blank_lines kernel   
 rem ** 
 rem ** It provides 2xplayers with color and a ball. (no missiles)
 rem ** the trade-off is the middle playfield bytes are symmetrical
 rem *******************************************************************
 set kernel_options pfcolors no_blank_lines player1colors

 rem ** in adventure, counts of 3 are important...
 dim threecount = a 

 rem ** track which room the player is in...
 dim playerroom = b

 rem ** we use saved variables for sliding off walls
 dim oldballx = w 
 dim oldbally = x 


 rem ** screen resolution = 7, so we can re-use screen variables for enemy vars
 rem ** if you need more resolution, use SC ram instead
 const pfres = 8


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

initialsetup

  playfield:
   ...XXXXXXXXXXXXXXXXXXXXXXXXX....
   ....XXXXXXXXXXXXXXXXXXXXXXX.....
   ......XXXXXXXXXXXXXXXXXXX.......
   ..........XXXXXXXXXXX...........
   ............XXXXXXX.............
   ............XXXXXXX.............
   ............XXXXXXX.............
   ............XXXXXXX.............
   ........XXXXXXXXXXXXXXX.........
   ......XXXXXXXXXXXXXXXXXXXX......
   ....XXXXXXXXXXXXXXXXXXXXXXXX....
end

 pfcolors:
   _06
   _06
   _06
   _06
   _06
   _BE
   _BE
   _BE
   _BE
   _0A
   _0A
   _0A
end

 player0:
 %01111100
 %00111000
 %00010000
 %00010000
 %01111100
 %10010010
 %11111110
 %10000010
end
 player0color:
 $f8
 $f6
 $f4
 $f4
 $f6
 $46
 $fa
 $fa
end

 scorecolor = $0f

 player1:
 %00111100
 %01010110
 %10101011
 %11111111
 %10010011
 %10111011
 %01111110
 %00001100
end
 player1color:
 $f4
 $f6
 $f8
 $fa
 $fa
 $f8
 $f6
 $c6
end

 player0x=30:player0y=40
 player1x=130:player1y=60
 ballx=80:bally=70:ballheight=3:CTRLPF=$21
 oldballx=ballx
 oldbally=bally

mainloop
 threecount=threecount+1:if threecount>2 then threecount=0

 COLUPF=$ad

 drawscreen

 on threecount goto one two three
one
 if !collision(ball,playfield) then goto nocollisionone
 temp1=oldballx:oldballx=ballx:ballx=temp1
nocollisionone

checknewroom
 if ballx<3 then playerroom=playerroom-1:ballx=157:gosub drawroom
 if ballx>157 then playerroom=playerroom+1:ballx=3:gosub drawroom
 if bally<3 then playerroom=playerroom-4:bally=85:gosub drawroom
 if bally>85 then playerroom=playerroom+4:bally=3:gosub drawroom

 oldballx=ballx:oldbally=bally
 if joy0up then bally=bally-3
 if joy0down then bally=bally+3
 if joy0left then ballx=ballx-3
 if joy0right then ballx=ballx+3

 goto donethreecount
two
 if !collision(ball,playfield) then goto donethreecount
 temp1=oldballx:oldballx=ballx:ballx=temp1
 goto donethreecount
three
 if !collision(ball,playfield) then goto donethreecount
 temp1=oldbally:oldbally=bally:bally=temp1
 temp1=oldballx:oldballx=ballx:ballx=temp1

donethreecount

 goto mainloop

drawroom
 rem ** this is where room drawing code would go
 return
