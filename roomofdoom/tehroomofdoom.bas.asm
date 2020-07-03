 processor 6502
 include "vcs.h"
 include "macro.h"
 include "2600basic.h"
 include "2600basic_variable_redefs.h"
 ifconst bankswitch
 if bankswitch == 8
 ORG $1000
 RORG $D000
 endif
 if bankswitch == 16
 ORG $1000
 RORG $9000
 endif
 if bankswitch == 32
 ORG $1000
 RORG $1000
 endif
 if bankswitch == 64
 ORG $1000
 RORG $1000
 endif
 else
 ORG $F000
 endif

 ifconst bankswitch_hotspot
 if bankswitch_hotspot = $083F ; 0840 bankswitching hotspot
 .byte 0 ; stop unexpected bankswitches
 endif
 endif
game
.
 ;

.
 ;

.
 ;

.L00 ; set tv ntsc

.L01 ; set kernel_options player1colors pfcolors no_blank_lines

.L02 ; set romsize 32k

.L03 ; rem Create the title screen

.opening
 ; opening

.L04 ; pfcolors:

 lda # $8A
 sta COLUPF
 ifconst pfres
 lda #>(pfcolorlabel13-132+pfres*pfwidth)
 else
 lda #>(pfcolorlabel13-84)
 endif
 sta pfcolortable+1
 ifconst pfres
 lda #<(pfcolorlabel13-132+pfres*pfwidth)
 else
 lda #<(pfcolorlabel13-84)
 endif
 sta pfcolortable
.L05 ; playfield:

 ifconst pfres
 ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
 else
 ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
 endif
 jmp pflabel0
PF_data0
 .byte %00100000, %00001000
 if (pfwidth>2)
 .byte %01000100, %00001000
 endif
 .byte %00111000, %00010100
 if (pfwidth>2)
 .byte %10100110, %00001100
 endif
 .byte %00100110, %10100010
 if (pfwidth>2)
 .byte %00010101, %00001010
 endif
 .byte %00100001, %10100010
 if (pfwidth>2)
 .byte %00010100, %00001001
 endif
 .byte %00100001, %10100010
 if (pfwidth>2)
 .byte %00010100, %00001000
 endif
 .byte %00100001, %10100010
 if (pfwidth>2)
 .byte %00010100, %00001000
 endif
 .byte %00100010, %10100010
 if (pfwidth>2)
 .byte %00010100, %00001000
 endif
 .byte %00100100, %10100010
 if (pfwidth>2)
 .byte %00010100, %00001000
 endif
 .byte %00100100, %00010100
 if (pfwidth>2)
 .byte %10100100, %00001000
 endif
 .byte %00101000, %00001000
 if (pfwidth>2)
 .byte %01000100, %00001000
 endif
 .byte %00110000, %00000000
 if (pfwidth>2)
 .byte %00000000, %00001000
 endif
 .byte %00100000, %00000000
 if (pfwidth>2)
 .byte %00000000, %00001000
 endif
pflabel0
 lda PF_data0,x
 sta playfield,x
 dex
 bpl pflabel0
.
 ;

.L06 ; rem Loop the screen until the spacebar is pressed

.title
 ; title

.L07 ; drawscreen

 sta temp7
  lda #>(ret_point1-1)
 pha
 lda #<(ret_point1-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point1
.L08 ; if joy0fire || joy1fire then goto skiptitle

 bit INPT4
 BMI .skipL08
.condpart0
 jmp .condpart1
.skipL08
 bit INPT5
 BMI .skip0OR
.condpart1
 jmp .skiptitle

.skip0OR
.L09 ; goto title

 jmp .title

.
 ;

.L010 ; rem This function displays after the title is skipped

.skiptitle
 ; skiptitle

.
 ;

.L011 ; rem Colors

.L012 ; COLUPF = 0

 LDA #0
 STA COLUPF
.L013 ; COLUBK = $08

 LDA #$08
 STA COLUBK
.
 ; 

.L014 ; rem Player location

.L015 ; player0x = 78 : player0y = 88

 LDA #78
 STA player0x
	 LDA #88
 STA player0y
.L016 ; player1x = 20 : player1y = 20

 LDA #20
 STA player1x
	STA player1y
.
 ;

.L017 ; rem Score setting and color

.L018 ; score = 5 : scorecolor = 0

 LDA #$05
 STA score+2
 LDA #$00
 STA score+1
 LDA #$00
 STA score
	 LDA #0
 STA scorecolor
.
 ; 

.L019 ; rem Missle size and location

.L020 ; ballheight = 4 : bally = 255

 LDA #4
 STA ballheight
	 LDA #255
 STA bally
.L021 ; NUSIZ0 = 16

 LDA #16
 STA NUSIZ0
.
 ; 

.L022 ; rem Create a variable to keep up with lives

.L023 ; a = 5

 LDA #5
 STA a
.
 ; 

.L024 ; rem Create the playfield

.
 ;

.L025 ; pfcolors:

 lda # $36
 sta COLUPF
 ifconst pfres
 lda #>(pfcolorlabel13-131+pfres*pfwidth)
 else
 lda #>(pfcolorlabel13-83)
 endif
 sta pfcolortable+1
 ifconst pfres
 lda #<(pfcolorlabel13-131+pfres*pfwidth)
 else
 lda #<(pfcolorlabel13-83)
 endif
 sta pfcolortable
.L026 ; playfield:

 ifconst pfres
 ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
 else
 ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
 endif
 jmp pflabel1
PF_data1
 .byte %00011111, %11111111
 if (pfwidth>2)
 .byte %11111111, %00011111
 endif
 .byte %00000001, %11111111
 if (pfwidth>2)
 .byte %11111111, %00000001
 endif
 .byte %00000000, %11111110
 if (pfwidth>2)
 .byte %11111110, %00000000
 endif
 .byte %00000000, %11111000
 if (pfwidth>2)
 .byte %11111000, %00000000
 endif
 .byte %00000000, %11100000
 if (pfwidth>2)
 .byte %11100000, %00000000
 endif
 .byte %00000000, %11100000
 if (pfwidth>2)
 .byte %11100000, %00000000
 endif
 .byte %00000000, %11100000
 if (pfwidth>2)
 .byte %11100000, %00000000
 endif
 .byte %00000000, %11111000
 if (pfwidth>2)
 .byte %11111000, %00000000
 endif
 .byte %00000000, %11111110
 if (pfwidth>2)
 .byte %11111110, %00000000
 endif
 .byte %00000001, %11111111
 if (pfwidth>2)
 .byte %11111111, %00000001
 endif
 .byte %00011111, %11111111
 if (pfwidth>2)
 .byte %11111111, %00011111
 endif
pflabel1
 lda PF_data1,x
 sta playfield,x
 dex
 bpl pflabel1
.
 ;

.
 ;

.L027 ; rem This main function is what loops constantly

.main
 ; main

.
 ;

.L028 ; rem This is the animation function

.animate
 ; animate

.L029 ; rem This frame variable slows down the animation

.L030 ; v = v + 1

 INC v
.
 ;

.L031 ; rem This code animates the sprites

.L032 ; if v = 7 && w = 0 then ax

 LDA v
 CMP #7
 BNE .skipL032
.condpart2
 LDA w
 
 beq .ax
 if ( (((((#>*)&$1f)*256)|(#<.ax))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.ax))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL032
.L033 ; if v = 7 && w = 1 then bx

 LDA v
 CMP #7
 BNE .skipL033
.condpart3
 LDA w
 CMP #1
 beq .bx
 if ( (((((#>*)&$1f)*256)|(#<.bx))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.bx))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL033
.L034 ; if v = 7 && w = 2 then cx

 LDA v
 CMP #7
 BNE .skipL034
.condpart4
 LDA w
 CMP #2
 beq .cx
 if ( (((((#>*)&$1f)*256)|(#<.cx))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.cx))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL034
.L035 ; if v = 7 && w = 3 then dx

 LDA v
 CMP #7
 BNE .skipL035
.condpart5
 LDA w
 CMP #3
 beq .dx
 if ( (((((#>*)&$1f)*256)|(#<.dx))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.dx))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.skipL035
.
 ;

.L036 ; goto nextstep

 jmp .nextstep

.
 ;

.L037 ; rem These four sprites are different stages of the animation

.ax
 ; ax

.L038 ; v = 0

 LDA #0
 STA v
.L039 ; w = 1

 LDA #1
 STA w
.L040 ; player1:

 LDX #<playerL040_1
 STX player1pointerlo
 LDA #>playerL040_1
 STA player1pointerhi
	 LDA #3
 STA player1height
.L041 ; goto nextstep

 jmp .nextstep

.
 ;

.bx
 ; bx

.L042 ; v = 0

 LDA #0
 STA v
.L043 ; w = 2

 LDA #2
 STA w
.L044 ; player1:

 LDX #<playerL044_1
 STX player1pointerlo
 LDA #>playerL044_1
 STA player1pointerhi
	 LDA #3
 STA player1height
.L045 ; goto nextstep

 jmp .nextstep

.
 ;

.cx
 ; cx

.L046 ; v = 0

 LDA #0
 STA v
.L047 ; w = 3

 LDA #3
 STA w
.L048 ; player1:

 LDX #<playerL048_1
 STX player1pointerlo
 LDA #>playerL048_1
 STA player1pointerhi
	 LDA #3
 STA player1height
.L049 ; goto nextstep

 jmp .nextstep

.
 ;

.dx
 ; dx

.L050 ; v = 0

 LDA #0
 STA v
.L051 ; w = 0

 LDA #0
 STA w
.L052 ; player1:

 LDX #<playerL052_1
 STX player1pointerlo
 LDA #>playerL052_1
 STA player1pointerhi
	 LDA #3
 STA player1height
.L053 ; goto nextstep

 jmp .nextstep

.
 ;

.L054 ; rem Create acorn sprite

.nextstep
 ; nextstep

.L055 ; player0:

 LDX #<playerL055_0
 STX player0pointerlo
 LDA #>playerL055_0
 STA player0pointerhi
	 LDA #14
 STA player0height
.
 ; 

.L056 ; rem check to see if a missile has already been fired

.checkfire
 ; checkfire

.L057 ; if bally > 240 then goto skip

 LDA #240
 CMP bally
 BCS .skipL057
.condpart6
 jmp .skip

.skipL057
.L058 ; bally = bally - 2 : goto draw

 LDA bally
 SEC
 SBC #2
 STA bally
 jmp .draw

.
 ;

.L059 ; rem if a missile hasn't been fired, then fire missile

.skip
 ; skip

.L060 ; if joy0fire then bally = player0y - 2 : ballx = player0x + 4

 bit INPT4
 BMI .skipL060
.condpart7
 LDA player0y
 SEC
 SBC #2
 STA bally
	 lda player0x
 CLC
 ADC #4
 STA ballx
.skipL060
.
 ;

.L061 ; rem Draw output to screen

.draw
 ; draw

.L062 ; drawscreen

 sta temp7
  lda #>(ret_point2-1)
 pha
 lda #<(ret_point2-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point2
.
 ;

.L063 ; rem Fix player wraparound bug

.L064 ; if player0x < 8 then player0x = 8

 LDA player0x
 CMP #8
 BCS .skipL064
.condpart8
 LDA #8
 STA player0x
.skipL064
.L065 ; if player0x > 150 then player0x = 150

 LDA #150
 CMP player0x
 BCS .skipL065
.condpart9
 LDA #150
 STA player0x
.skipL065
.L066 ; if player0y < 8 then player0y = 8

 LDA player0y
 CMP #8
 BCS .skipL066
.condpart10
 LDA #8
 STA player0y
.skipL066
.L067 ; if player0y > 88 then player0y = 88

 LDA #88
 CMP player0y
 BCS .skipL067
.condpart11
 LDA #88
 STA player0y
.skipL067
.
 ;

.L068 ; rem Have player 1 chase player 2

.L069 ; if player1y < player0y then player1y = player1y + 1

 LDA player1y
 CMP player0y
 BCS .skipL069
.condpart12
 INC player1y
.skipL069
.L070 ; if player1y > player0y then player1y = player1y - 1

 LDA player0y
 CMP player1y
 BCS .skipL070
.condpart13
 DEC player1y
.skipL070
.L071 ; if player1x < player0x then player1x = player1x + 1

 LDA player1x
 CMP player0x
 BCS .skipL071
.condpart14
 INC player1x
.skipL071
.L072 ; if player1x > player0x then player1x = player1x - 1

 LDA player0x
 CMP player1x
 BCS .skipL072
.condpart15
 DEC player1x
.skipL072
.L073 ; player1x = player1x : player1y = player1y

 LDA player1x
 STA player1x
	 lda player1y
 STA player1y
.
 ; 

.
 ; 

.L074 ; rem Detect missile collision with squirrel

.L075 ; if collision(ball,player1) then score = score + 1 : player1x = rand / 2 : player1y = 0 : bally = 255 : goto pointsound

 bit CXP1FB
 BVC .skipL075
.condpart16
 SED
 CLC
 LDA score+2
 ADC #$01
 STA score+2
 LDA score+1
 ADC #$00
 STA score+1
 LDA score
 ADC #$00
 STA score
	CLD
 sta temp7
  lda #>(ret_point3-1)
 pha
 lda #<(ret_point3-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point3
 lsr
 STA player1x
	 LDA #0
 STA player1y
	 LDA #255
 STA bally
 jmp .pointsound

.skipL075
.L076 ; rem Detect squirrel collision with the acorn

.L077 ; if collision(player0,player1) then score = score - 1 : player1x = rand / 2 : player1y = 0 : bally = 255 : a = a - 1 : goto deadsound

 bit CXPPMM
 BPL .skipL077
.condpart17
 SED
 SEC
 LDA score+2
 SBC #$01
 STA score+2
 LDA score+1
 SBC #$00
 STA score+1
 LDA score
 SBC #$00
 STA score
	CLD
 sta temp7
  lda #>(ret_point4-1)
 pha
 lda #<(ret_point4-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point4
 lsr
 STA player1x
	 LDA #0
 STA player1y
	 LDA #255
 STA bally
	DEC a
 jmp .deadsound

.skipL077
.
 ;

.
 ;

.L078 ; rem joystick movements

.
 ;

.
 ;

.L079 ; if joy0left then player0x = player0x - 1 : goto skipmove

 bit SWCHA
 BVS .skipL079
.condpart18
 DEC player0x
 jmp .skipmove

.skipL079
.L080 ; if joy0right then player0x = player0x + 1 : goto skipmove

 bit SWCHA
 BMI .skipL080
.condpart19
 INC player0x
 jmp .skipmove

.skipL080
.
 ;

.L081 ; rem refresh the screen

.skipmove
 ; skipmove

.L082 ; goto main

 jmp .main

.
 ;

.L083 ; rem Play point sound

.pointsound
 ; pointsound

.L084 ; AUDV0 = 5 : AUDC0 = 4 : AUDF0 = 10

 LDA #5
 STA AUDV0
	 LDA #4
 STA AUDC0
	 LDA #10
 STA AUDF0
.L085 ; p = p + 1

 INC p
.L086 ; drawscreen

 sta temp7
  lda #>(ret_point5-1)
 pha
 lda #<(ret_point5-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point5
.L087 ; if p < 2 then pointsound

 LDA p
 CMP #2
 bcc .pointsound
 if ( (((((#>*)&$1f)*256)|(#<.pointsound))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.pointsound))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.L088 ; p = 0

 LDA #0
 STA p
.L089 ; AUDV0 = 0 : AUDC0 = 0 : AUDF0 = 0

 LDA #0
 STA AUDV0
	STA AUDC0
 STA AUDF0
.L090 ; goto main

 jmp .main

.
 ;

.L091 ; rem Play dead sound

.deadsound
 ; deadsound

.L092 ; AUDV1 = 10

 LDA #10
 STA AUDV1
.L093 ; AUDC1 = 7

 LDA #7
 STA AUDC1
.L094 ; AUDF1 = 12

 LDA #12
 STA AUDF1
.L095 ; p = p + 1

 INC p
.L096 ; drawscreen

 sta temp7
  lda #>(ret_point6-1)
 pha
 lda #<(ret_point6-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #8
 jmp BS_jsr
ret_point6
.L097 ; if p < 10 then deadsound

 LDA p
 CMP #10
 bcc .deadsound
 if ( (((((#>*)&$1f)*256)|(#<.deadsound))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.deadsound))<=(bankswitch_hotspot+bs_mask)) )
 echo "WARNING: branch near the end of bank 1 may accidentally trigger a bankswitch. Reposition code there if bad things happen."
 endif
.L098 ; p = 0

 LDA #0
 STA p
.L099 ; AUDV1 = 0 : AUDC1 = 0 : AUDF1 = 0

 LDA #0
 STA AUDV1
	STA AUDC1
 STA AUDF1
.L0100 ; if a = 0 then goto opening

 LDA a
 
 BNE .skipL0100
.condpart20
 jmp .opening

.skipL0100
.L0101 ; goto main

 jmp .main

.
 ;

.
 ;

.
 ;

.
 ;

.
 ;

.
 ;

.
 ;

.
 ;

.
 ;

 if ECHO1
 echo " ",[(start_bank1 - *)]d , "bytes of ROM space left in bank 1")
 endif
ECHO1 = 1
 ORG $1FF4-bscode_length
 RORG $1FF4-bscode_length
start_bank1 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $1FFC
 RORG $1FFC
 .word start_bank1
 .word start_bank1
 ORG $2000
 RORG $3000
 if ECHO2
 echo " ",[(start_bank2 - *)]d , "bytes of ROM space left in bank 2")
 endif
ECHO2 = 1
 ORG $2FF4-bscode_length
 RORG $3FF4-bscode_length
start_bank2 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $2FFC
 RORG $3FFC
 .word start_bank2
 .word start_bank2
 ORG $3000
 RORG $5000
 if ECHO3
 echo " ",[(start_bank3 - *)]d , "bytes of ROM space left in bank 3")
 endif
ECHO3 = 1
 ORG $3FF4-bscode_length
 RORG $5FF4-bscode_length
start_bank3 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $3FFC
 RORG $5FFC
 .word start_bank3
 .word start_bank3
 ORG $4000
 RORG $7000
 if ECHO4
 echo " ",[(start_bank4 - *)]d , "bytes of ROM space left in bank 4")
 endif
ECHO4 = 1
 ORG $4FF4-bscode_length
 RORG $7FF4-bscode_length
start_bank4 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $4FFC
 RORG $7FFC
 .word start_bank4
 .word start_bank4
 ORG $5000
 RORG $9000
 if ECHO5
 echo " ",[(start_bank5 - *)]d , "bytes of ROM space left in bank 5")
 endif
ECHO5 = 1
 ORG $5FF4-bscode_length
 RORG $9FF4-bscode_length
start_bank5 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $5FFC
 RORG $9FFC
 .word start_bank5
 .word start_bank5
 ORG $6000
 RORG $B000
 if ECHO6
 echo " ",[(start_bank6 - *)]d , "bytes of ROM space left in bank 6")
 endif
ECHO6 = 1
 ORG $6FF4-bscode_length
 RORG $BFF4-bscode_length
start_bank6 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $6FFC
 RORG $BFFC
 .word start_bank6
 .word start_bank6
 ORG $7000
 RORG $D000
 if ECHO7
 echo " ",[(start_bank7 - *)]d , "bytes of ROM space left in bank 7")
 endif
ECHO7 = 1
 ORG $7FF4-bscode_length
 RORG $DFF4-bscode_length
start_bank7 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
 lda 4,x ; get high byte of return address
 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $7FFC
 RORG $DFFC
 .word start_bank7
 .word start_bank7
 ORG $8000
 RORG $F000
 ; This is a 2-line kernel!
 ifnconst vertical_reflect
kernel
 endif
 sta WSYNC
      lda #255
 sta TIM64T

      lda #1
 sta VDELBL
     sta VDELP0
 ldx ballheight
 inx
 inx
 stx temp4
 lda player1y
 sta temp3

     ifconst shakescreen
 jsr doshakescreen
 else
 ldx missile0height
 inx
 endif

 inx
 stx stack1

 lda bally
 sta stack2

      lda player0y
 ldx #0
 sta WSYNC
     stx GRP0
 stx GRP1
 stx PF1L
 stx PF2
 stx CXCLR
 ifconst readpaddle
 stx paddle
 else
 sleep 3
 endif

 sta temp2,x

 ;store these so they can be retrieved later
 ifnconst pfres
 ldx #128-44+(4-pfwidth)*12
 else
 ldx #132-pfres*pfwidth
 endif

 dec player0y

 lda missile0y
 sta temp5
      lda missile1y
 sta temp6

      lda playfieldpos
 sta temp1
     
     ifconst pfrowheight
 lda #pfrowheight+2
 else
 ifnconst pfres
 lda #10
 else
 lda #(96/pfres)+2 ; try to come close to the real size
 endif
 endif
 clc
 sbc playfieldpos
 sta playfieldpos
     jmp .startkernel

.skipDrawP0
 lda #0
 tay
 jmp .continueP0

.skipDrawP1
 lda #0
 tay
 jmp .continueP1

.kerloop ; enter at cycle 59??

continuekernel
 sleep 2
continuekernel2
 lda ballheight

 ifconst pfres
 ldy playfield+pfres*pfwidth-132,x
 sty PF1L ;3
 ldy playfield+pfres*pfwidth-131-pfadjust,x
 sty PF2L ;3
 ldy playfield+pfres*pfwidth-129,x
 sty PF1R ; 3 too early?
 ldy playfield+pfres*pfwidth-130-pfadjust,x
 sty PF2R ;3
 else
 ldy playfield-48+pfwidth*12+44-128,x
 sty PF1L ;3
 ldy playfield-48+pfwidth*12+45-128-pfadjust,x ;4
 sty PF2L ;3
 ldy playfield-48+pfwidth*12+47-128,x ;4
 sty PF1R ; 3 too early?
 ldy playfield-48+pfwidth*12+46-128-pfadjust,x;4
 sty PF2R ;3
 endif

 ; should be playfield+$38 for width=2

 dcp bally
 rol
 rol
 ; rol
 ; rol
goback
 sta ENABL 
.startkernel
 lda player1height ;3
 dcp player1y ;5
 bcc .skipDrawP1 ;2
 ldy player1y ;3
 lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
 ; so it doesn't cross a page boundary!

.continueP1
 sta GRP1 ;3

 ifnconst player1colors
 lda missile1height ;3
 dcp missile1y ;5
 rol;2
 rol;2
 sta ENAM1 ;3
 else
 lda (player1color),y
 sta COLUP1
         ifnconst playercolors
 sleep 7
 else
 lda.w player0colorstore
 sta COLUP0
         endif
 endif

 ifconst pfres
 lda playfield+pfres*pfwidth-132,x
 sta PF1L ;3
 lda playfield+pfres*pfwidth-131-pfadjust,x
 sta PF2L ;3
 lda playfield+pfres*pfwidth-129,x
 sta PF1R ; 3 too early?
 lda playfield+pfres*pfwidth-130-pfadjust,x
 sta PF2R ;3
 else
 lda playfield-48+pfwidth*12+44-128,x ;4
 sta PF1L ;3
 lda playfield-48+pfwidth*12+45-128-pfadjust,x ;4
 sta PF2L ;3
 lda playfield-48+pfwidth*12+47-128,x ;4
 sta PF1R ; 3 too early?
 lda playfield-48+pfwidth*12+46-128-pfadjust,x;4
 sta PF2R ;3
 endif
 ; sleep 3

 lda player0height
 dcp player0y
 bcc .skipDrawP0
 ldy player0y
 lda (player0pointer),y
.continueP0
 sta GRP0

     ifnconst no_blank_lines
 ifnconst playercolors
 lda missile0height ;3
 dcp missile0y ;5
 sbc stack1
 sta ENAM0 ;3
 else
 lda (player0color),y
 sta player0colorstore
             sleep 6
 endif
 dec temp1
 bne continuekernel
 else
 dec temp1
 beq altkernel2
 ifconst readpaddle
 ldy currentpaddle
 lda INPT0,y
 bpl noreadpaddle
 inc paddle
 jmp continuekernel2
noreadpaddle
 sleep 2
 jmp continuekernel
 else
 ifnconst playercolors
 ifconst PFcolors
 txa
 tay
 lda (pfcolortable),y
 ifnconst backgroundchange
 sta COLUPF
                     else
 sta COLUBK
                     endif
 jmp continuekernel
 else
 ifconst kernelmacrodef
 kernelmacro
 else
 sleep 12
 endif
 endif
 else
 lda (player0color),y
 sta player0colorstore
                 sleep 4
 endif
 jmp continuekernel
 endif
altkernel2
 txa
 ifnconst vertical_reflect
 sbx #256-pfwidth
 else
 sbx #256-pfwidth/2
 endif
 bmi lastkernelline
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
 lda #8
 else
 lda #(96/pfres) ; try to come close to the real size
 endif
 endif
 sta temp1
         jmp continuekernel
 endif

altkernel

 ifconst PFmaskvalue
 lda #PFmaskvalue
 else
 lda #0
 endif
 sta PF1L
     sta PF2


 ;sleep 3

 ;28 cycles to fix things
 ;minus 11=17

 ; lax temp4
 ; clc
 txa
 ifnconst vertical_reflect
 sbx #256-pfwidth
 else
 sbx #256-pfwidth/2
 endif

 bmi lastkernelline

 ifconst PFcolorandheight
 ifconst pfres
 ldy playfieldcolorandheight-131+pfres*pfwidth,x
 else
 ldy playfieldcolorandheight-87,x
 endif
 ifnconst backgroundchange
 sty COLUPF
 else
 sty COLUBK
 endif
 ifconst pfres
 lda playfieldcolorandheight-132+pfres*pfwidth,x
 else
 lda playfieldcolorandheight-88,x
 endif
 sta.w temp1
 endif
 ifconst PFheights
 lsr
 lsr
 tay
 lda (pfheighttable),y
 sta.w temp1
 endif
 ifconst PFcolors
 tay
 lda (pfcolortable),y
 ifnconst backgroundchange
 sta COLUPF
         else
 sta COLUBK
         endif
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
 lda #8
 else
 lda #(96/pfres) ; try to come close to the real size
 endif
 endif
 sta temp1
     endif
 ifnconst PFcolorandheight
 ifnconst PFcolors
 ifnconst PFheights
 ifnconst no_blank_lines
 ; read paddle 0
 ; lo-res paddle read
 ; bit INPT0
 ; bmi paddleskipread
 ; inc paddle0
 ;donepaddleskip
 sleep 10
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
 lda #8
 else
 lda #(96/pfres) ; try to come close to the real size
 endif
 endif
 sta temp1
                 endif
 endif
 endif
 endif


 lda ballheight
 dcp bally
 sbc temp4


 jmp goback


 ifnconst no_blank_lines
lastkernelline
 ifnconst PFcolors
 sleep 10
 else
 ldy #124
 lda (pfcolortable),y
 sta COLUPF
         endif

 ifconst PFheights
 ldx #1
 ;sleep 4
 sleep 3 ; REVENG - this was over 1 cycle
 else
 ldx playfieldpos
 ;sleep 3
 sleep 2 ; REVENG - this was over 1 cycle
 endif

 jmp enterlastkernel

 else
lastkernelline

 ifconst PFheights
 ldx #1
 ;sleep 5
 sleep 4 ; REVENG - this was over 1 cycle
 else
 ldx playfieldpos
 ;sleep 4
 sleep 3 ; REVENG - this was over 1 cycle
 endif

 cpx #0
 bne .enterfromNBL
 jmp no_blank_lines_bailout
 endif

 if ((<*)>$d5)
 align 256
 endif
 ; this is a kludge to prevent page wrapping - fix!!!

.skipDrawlastP1
 lda #0
 tay ; REVENG - added so we don't cross a page
 jmp .continuelastP1

.endkerloop ; enter at cycle 59??

 nop

.enterfromNBL
 ifconst pfres
 ldy.w playfield+pfres*pfwidth-4
 sty PF1L ;3
 ldy.w playfield+pfres*pfwidth-3-pfadjust
 sty PF2L ;3
 ldy.w playfield+pfres*pfwidth-1
 sty PF1R ; possibly too early?
 ldy.w playfield+pfres*pfwidth-2-pfadjust
 sty PF2R ;3
 else
 ldy.w playfield-48+pfwidth*12+44
 sty PF1L ;3
 ldy.w playfield-48+pfwidth*12+45-pfadjust
 sty PF2L ;3
 ldy.w playfield-48+pfwidth*12+47
 sty PF1R ; possibly too early?
 ldy.w playfield-48+pfwidth*12+46-pfadjust
 sty PF2R ;3
 endif

enterlastkernel
 lda ballheight

 ; tya
 dcp bally
 ; sleep 4

 ; sbc stack3
 rol
 rol
 sta ENABL 

      lda player1height ;3
 dcp player1y ;5
 bcc .skipDrawlastP1
 ldy player1y ;3
 lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
 ; so it doesn't cross a page boundary!

.continuelastP1
 sta GRP1 ;3

 ifnconst player1colors
 lda missile1height ;3
 dcp missile1y ;5
 else
 lda (player1color),y
 sta COLUP1
     endif

 dex
 ;dec temp4 ; might try putting this above PF writes
 beq endkernel


 ifconst pfres
 ldy.w playfield+pfres*pfwidth-4
 sty PF1L ;3
 ldy.w playfield+pfres*pfwidth-3-pfadjust
 sty PF2L ;3
 ldy.w playfield+pfres*pfwidth-1
 sty PF1R ; possibly too early?
 ldy.w playfield+pfres*pfwidth-2-pfadjust
 sty PF2R ;3
 else
 ldy.w playfield-48+pfwidth*12+44
 sty PF1L ;3
 ldy.w playfield-48+pfwidth*12+45-pfadjust
 sty PF2L ;3
 ldy.w playfield-48+pfwidth*12+47
 sty PF1R ; possibly too early?
 ldy.w playfield-48+pfwidth*12+46-pfadjust
 sty PF2R ;3
 endif

 ifnconst player1colors
 rol;2
 rol;2
 sta ENAM1 ;3
 else
 ifnconst playercolors
 sleep 7
 else
 lda.w player0colorstore
 sta COLUP0
         endif
 endif

 lda.w player0height
 dcp player0y
 bcc .skipDrawlastP0
 ldy player0y
 lda (player0pointer),y
.continuelastP0
 sta GRP0



     ifnconst no_blank_lines
 lda missile0height ;3
 dcp missile0y ;5
 sbc stack1
 sta ENAM0 ;3
 jmp .endkerloop
 else
 ifconst readpaddle
 ldy currentpaddle
 lda INPT0,y
 bpl noreadpaddle2
 inc paddle
 jmp .endkerloop
noreadpaddle2
 sleep 4
 jmp .endkerloop
 else ; no_blank_lines and no paddle reading
 pla
 pha ; 14 cycles in 4 bytes
 pla
 pha
 ; sleep 14
 jmp .endkerloop
 endif
 endif


 ; ifconst donepaddleskip
 ;paddleskipread
 ; this is kind of lame, since it requires 4 cycles from a page boundary crossing
 ; plus we get a lo-res paddle read
 ; bmi donepaddleskip
 ; endif

.skipDrawlastP0
 lda #0
 tay
 jmp .continuelastP0

 ifconst no_blank_lines
no_blank_lines_bailout
 ldx #0
 endif

endkernel
 ; 6 digit score routine
 stx PF1
 stx PF2
 stx PF0
 clc

 ifconst pfrowheight
 lda #pfrowheight+2
 else
 ifnconst pfres
 lda #10
 else
 lda #(96/pfres)+2 ; try to come close to the real size
 endif
 endif

 sbc playfieldpos
 sta playfieldpos
     txa

 ifconst shakescreen
 bit shakescreen
 bmi noshakescreen2
 ldx #$3D
noshakescreen2
 endif

 sta WSYNC,x

 ; STA WSYNC ;first one, need one more
 sta REFP0
     sta REFP1
 STA GRP0
     STA GRP1
 ; STA PF1
     ; STA PF2
 sta HMCLR
     sta ENAM0
 sta ENAM1
     sta ENABL

 lda temp2 ;restore variables that were obliterated by kernel
 sta player0y
      lda temp3
 sta player1y
     ifnconst player1colors
 lda temp6
 sta missile1y
     endif
 ifnconst playercolors
 ifnconst readpaddle
 lda temp5
 sta missile0y
         endif
 endif
 lda stack2
 sta bally

     ; REVENG - strangely, this isn't required any more. might have
 ; resulted from the no_blank_lines score bounce fix
 ;ifconst no_blank_lines
 ;sta WSYNC
     ;endif

 lda INTIM
 clc
 ifnconst vblank_time
 adc #43+12+87
 else
 adc #vblank_time+12+87

 endif
 ; sta WSYNC
     sta TIM64T

 ifconst minikernel
 jsr minikernel
 endif

 ; now reassign temp vars for score pointers

 ; score pointers contain:
 ; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
 ; swap lo2->temp1
 ; swap lo4->temp3
 ; swap lo6->temp5
 ifnconst noscore
 lda scorepointers+1
 ; ldy temp1
 sta temp1
         ; sty scorepointers+1

 lda scorepointers+3
 ; ldy temp3
 sta temp3
         ; sty scorepointers+3


 sta HMCLR
         tsx
 stx stack1
 ldx #$E0
 stx HMP0

 LDA scorecolor
 STA COLUP0
         STA COLUP1
 ifconst scorefade
 STA stack2
         endif
 ifconst pfscore
 lda pfscorecolor
 sta COLUPF
         endif
 sta WSYNC
         ldx #0
 STx GRP0
 STx GRP1 ; seems to be needed because of vdel

 lda scorepointers+5
 ; ldy temp5
 sta temp5,x
 ; sty scorepointers+5
 lda #>scoretable
 sta scorepointers+1
 sta scorepointers+3
 sta scorepointers+5
 sta temp2
         sta temp4
 sta temp6
         LDY #7
 STY VDELP0
 STA RESP0
         STA RESP1


 LDA #$03
 STA NUSIZ0
         STA NUSIZ1
 STA VDELP1
          LDA #$F0
 STA HMP1
          lda (scorepointers),y
 sta GRP0
         STA HMOVE ; cycle 73 ?
 jmp beginscore


 if ((<*)>$d4)
 align 256 ; kludge that potentially wastes space! should be fixed!
 endif

loop2
 lda (scorepointers),y ;+5 68 204
 sta GRP0 ;+3 71 213 D1 -- -- --
 ifconst pfscore
 lda.w pfscore1
 sta PF1
         else
 ifconst scorefade
 sleep 2
 dec stack2 ; decrement the temporary scorecolor
 else
 sleep 7
 endif
 endif
 ; cycle 0
beginscore
 lda (scorepointers+$8),y ;+5 5 15
 sta GRP1 ;+3 8 24 D1 D1 D2 --
 lda (scorepointers+$6),y ;+5 13 39
 sta GRP0 ;+3 16 48 D3 D1 D2 D2
 lax (scorepointers+$2),y ;+5 29 87
 txs
 lax (scorepointers+$4),y ;+5 36 108
 ifconst scorefade
 lda stack2
 else
 sleep 3
 endif

 ifconst pfscore
 lda pfscore2
 sta PF1
         else
 ifconst scorefade
 sta COLUP0
                 sta COLUP1
 else
 sleep 6
 endif
 endif

 lda (scorepointers+$A),y ;+5 21 63
 stx GRP1 ;+3 44 132 D3 D3 D4 D2!
 tsx
 stx GRP0 ;+3 47 141 D5 D3! D4 D4
 sta GRP1 ;+3 50 150 D5 D5 D6 D4!
 sty GRP0 ;+3 53 159 D4* D5! D6 D6
 dey
 bpl loop2 ;+2 60 180

 ldx stack1
 txs
 ; lda scorepointers+1
 ldy temp1
 ; sta temp1
         sty scorepointers+1

 LDA #0
 sta PF1
         STA GRP0
 STA GRP1
         STA VDELP0
 STA VDELP1;do we need these
 STA NUSIZ0
         STA NUSIZ1

 ; lda scorepointers+3
 ldy temp3
 ; sta temp3
         sty scorepointers+3

 ; lda scorepointers+5
 ldy temp5
 ; sta temp5
         sty scorepointers+5
 endif ;noscore
 LDA #%11000010
 sta WSYNC
     STA VBLANK
 RETURN

 ifconst shakescreen
doshakescreen
 bit shakescreen
 bmi noshakescreen
 sta WSYNC
noshakescreen
 ldx missile0height
 inx
 rts
 endif

start
 sei
 cld
 ldy #0
 lda $D0
 cmp #$2C ;check RAM location #1
 bne MachineIs2600
 lda $D1
 cmp #$A9 ;check RAM location #2
 bne MachineIs2600
 dey
MachineIs2600
 ldx #0
 txa
clearmem
 inx
 txs
 pha
 bne clearmem
 sty temp1
 ifnconst multisprite
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifconst pfres
 lda #(96/pfres)
 else
 lda #8
 endif
 endif
 sta playfieldpos
 endif
 ldx #5
initscore
 lda #<scoretable
 sta scorepointers,x
 dex
 bpl initscore
 lda #1
 sta CTRLPF
 ora INTIM
 sta rand

 ifconst multisprite
 jsr multisprite_setup
 endif

 ifnconst bankswitch
 jmp game
 else
 lda #>(game-1)
 pha
 lda #<(game-1)
 pha
 pha
 pha
 ldx #1
 jmp BS_jsr
 endif
; playfield drawing routines
; you get a 32x12 bitmapped display in a single color :)
; 0-31 and 0-11

pfclear ; clears playfield - or fill with pattern
 ifconst pfres
 ldx #pfres*pfwidth-1
 else
 ldx #47-(4-pfwidth)*12 ; will this work?
 endif
pfclear_loop
 ifnconst superchip
 sta playfield,x
 else
 sta playfield-128,x
 endif
 dex
 bpl pfclear_loop
 RETURN

setuppointers
 stx temp2 ; store on.off.flip value
 tax ; put x-value in x
 lsr
 lsr
 lsr ; divide x pos by 8
 sta temp1
 tya
 asl
 if pfwidth=4
 asl ; multiply y pos by 4
 endif ; else multiply by 2
 clc
 adc temp1 ; add them together to get actual memory location offset
 tay ; put the value in y
 lda temp2 ; restore on.off.flip value
 rts

pfread
;x=xvalue, y=yvalue
 jsr setuppointers
 lda setbyte,x
 and playfield,y
 eor setbyte,x
; beq readzero
; lda #1
; readzero
 RETURN

pfpixel
;x=xvalue, y=yvalue, a=0,1,2
 jsr setuppointers

 ifconst bankswitch
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon_r ; if "on" go to on
 lsr
 bcs pixeloff_r ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixelon_r
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixeloff_r
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN

 else
 jmp plotpoint
 endif

pfhline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 jmp noinc
keepgoing
 inx
 txa
 and #7
 bne noinc
 iny
noinc
 jsr plotpoint
 cpx temp3
 bmi keepgoing
 RETURN

pfvline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 sty temp1 ; store memory location offset
 inc temp3 ; increase final x by 1
 lda temp3
 asl
 if pfwidth=4
 asl ; multiply by 4
 endif ; else multiply by 2
 sta temp3 ; store it
 ; Thanks to Michael Rideout for fixing a bug in this code
 ; right now, temp1=y=starting memory location, temp3=final
 ; x should equal original x value
keepgoingy
 jsr plotpoint
 iny
 iny
 if pfwidth=4
 iny
 iny
 endif
 cpy temp3
 bmi keepgoingy
 RETURN

plotpoint
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon ; if "on" go to on
 lsr
 bcs pixeloff ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixelon
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixeloff
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts

setbyte
 ifnconst pfcenter
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 endif
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
pfscroll ;(a=0 left, 1 right, 2 up, 4 down, 6=upup, 12=downdown)
 bne notleft
;left
 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
leftloop
 lda playfield-1,x
 lsr

 ifconst superchip
 lda playfield-2,x
 rol
 sta playfield-130,x
 lda playfield-3,x
 ror
 sta playfield-131,x
 lda playfield-4,x
 rol
 sta playfield-132,x
 lda playfield-1,x
 ror
 sta playfield-129,x
 else
 rol playfield-2,x
 ror playfield-3,x
 rol playfield-4,x
 ror playfield-1,x
 endif

 txa
 sbx #4
 bne leftloop
 RETURN

notleft
 lsr
 bcc notright
;right

 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
rightloop
 lda playfield-4,x
 lsr
 ifconst superchip
 lda playfield-3,x
 rol
 sta playfield-131,x
 lda playfield-2,x
 ror
 sta playfield-130,x
 lda playfield-1,x
 rol
 sta playfield-129,x
 lda playfield-4,x
 ror
 sta playfield-132,x
 else
 rol playfield-3,x
 ror playfield-2,x
 rol playfield-1,x
 ror playfield-4,x
 endif
 txa
 sbx #4
 bne rightloop
 RETURN

notright
 lsr
 bcc notup
;up
 lsr
 bcc onedecup
 dec playfieldpos
onedecup
 dec playfieldpos
 beq shiftdown
 bpl noshiftdown2
shiftdown
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
 lda #8
 else
 lda #(96/pfres) ; try to come close to the real size
 endif
 endif

 sta playfieldpos
  lda playfield+3
 sta temp4
  lda playfield+2
 sta temp3
  lda playfield+1
 sta temp2
  lda playfield
 sta temp1
 ldx #0
up2
 lda playfield+4,x
 ifconst superchip
 sta playfield-128,x
 lda playfield+5,x
 sta playfield-127,x
 lda playfield+6,x
 sta playfield-126,x
 lda playfield+7,x
 sta playfield-125,x
 else
 sta playfield,x
 lda playfield+5,x
 sta playfield+1,x
 lda playfield+6,x
 sta playfield+2,x
 lda playfield+7,x
 sta playfield+3,x
 endif
 txa
 sbx #252
 ifconst pfres
 cpx #(pfres-1)*4
 else
 cpx #44
 endif
 bne up2

 lda temp4

 ifconst superchip
 ifconst pfres
 sta playfield+pfres*4-129
 lda temp3
 sta playfield+pfres*4-130
 lda temp2
 sta playfield+pfres*4-131
 lda temp1
 sta playfield+pfres*4-132
 else
 sta playfield+47-128
 lda temp3
 sta playfield+46-128
 lda temp2
 sta playfield+45-128
 lda temp1
 sta playfield+44-128
 endif
 else
 ifconst pfres
 sta playfield+pfres*4-1
 lda temp3
 sta playfield+pfres*4-2
 lda temp2
 sta playfield+pfres*4-3
 lda temp1
 sta playfield+pfres*4-4
 else
 sta playfield+47
 lda temp3
 sta playfield+46
 lda temp2
 sta playfield+45
 lda temp1
 sta playfield+44
 endif
 endif
noshiftdown2
 RETURN


notup
;down
 lsr
 bcs oneincup
 inc playfieldpos
oneincup
 inc playfieldpos
 lda playfieldpos

 ifconst pfrowheight
 cmp #pfrowheight+1
 else
 ifnconst pfres
 cmp #9
 else
 cmp #(96/pfres)+1 ; try to come close to the real size
 endif
 endif

 bcc noshiftdown
 lda #1
 sta playfieldpos

 ifconst pfres
 lda playfield+pfres*4-1
 sta temp4
  lda playfield+pfres*4-2
 sta temp3
  lda playfield+pfres*4-3
 sta temp2
  lda playfield+pfres*4-4
 else
 lda playfield+47
 sta temp4
  lda playfield+46
 sta temp3
  lda playfield+45
 sta temp2
  lda playfield+44
 endif

 sta temp1

 ifconst pfres
 ldx #(pfres-1)*4
 else
 ldx #44
 endif
down2
 lda playfield-1,x
 ifconst superchip
 sta playfield-125,x
 lda playfield-2,x
 sta playfield-126,x
 lda playfield-3,x
 sta playfield-127,x
 lda playfield-4,x
 sta playfield-128,x
 else
 sta playfield+3,x
 lda playfield-2,x
 sta playfield+2,x
 lda playfield-3,x
 sta playfield+1,x
 lda playfield-4,x
 sta playfield,x
 endif
 txa
 sbx #4
 bne down2

 lda temp4
 ifconst superchip
 sta playfield-125
 lda temp3
 sta playfield-126
 lda temp2
 sta playfield-127
 lda temp1
 sta playfield-128
 else
 sta playfield+3
 lda temp3
 sta playfield+2
 lda temp2
 sta playfield+1
 lda temp1
 sta playfield
 endif
noshiftdown
 RETURN
;standard routines needed for pretty much all games
; just the random number generator is left - maybe we should remove this asm file altogether?
; repositioning code and score pointer setup moved to overscan
; read switches, joysticks now compiler generated (more efficient)

randomize
 lda rand
 lsr
 ifconst rand16
 rol rand16
 endif
 bcc noeor
 eor #$B4
noeor
 sta rand
 ifconst rand16
 eor rand16
 endif
 RETURN
drawscreen
 ifconst debugscore
 ldx #14
 lda INTIM ; display # cycles left in the score

 ifconst mincycles
 lda mincycles
 cmp INTIM
 lda mincycles
 bcc nochange
 lda INTIM
 sta mincycles
nochange
 endif

 ; cmp #$2B
 ; bcs no_cycles_left
 bmi cycles_left
 ldx #64
 eor #$ff ;make negative
cycles_left
 stx scorecolor
 and #$7f ; clear sign bit
 tax
 lda scorebcd,x
 sta score+2
 lda scorebcd1,x
 sta score+1
 jmp done_debugscore
scorebcd
 .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
 .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
 .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
 .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
 .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
 .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
 .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
 .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
done_debugscore
 endif

 ifconst debugcycles
 lda INTIM ; if we go over, it mucks up the background color
 ; cmp #$2B
 ; BCC overscan
 bmi overscan
 sta COLUBK
         bcs doneoverscan
 endif

overscan
 ifconst interlaced
 PHP
 PLA
 EOR #4 ; flip interrupt bit
 PHA
 PLP
 AND #4 ; isolate the interrupt bit
 TAX ; save it for later
 endif

overscanloop
 lda INTIM ;wait for sync
 bmi overscanloop
doneoverscan

 ;do VSYNC

 ifconst interlaced
 CPX #4
 BNE oddframevsync
 endif

 lda #2
 sta WSYNC
     sta VSYNC
 STA WSYNC
     STA WSYNC
 lsr
 STA WSYNC
     STA VSYNC
 sta VBLANK
     ifnconst overscan_time
 lda #37+128
 else
 lda #overscan_time+128
 endif
 sta TIM64T

     ifconst interlaced
 jmp postsync

oddframevsync
 sta WSYNC

          LDA ($80,X) ; 11 waste
 LDA ($80,X) ; 11 waste
 LDA ($80,X) ; 11 waste

 lda #2
 sta VSYNC
         sta WSYNC
 sta WSYNC
         sta WSYNC

 LDA ($80,X) ; 11 waste
 LDA ($80,X) ; 11 waste
 LDA ($80,X) ; 11 waste

 lda #0
 sta VSYNC
         sta VBLANK
 ifnconst overscan_time
 lda #37+128
 else
 lda #overscan_time+128
 endif
 sta TIM64T

postsync
 endif

 ifconst legacy
 if legacy < 100
 ldx #4
adjustloop
 lda player0x,x
 sec
 sbc #14 ;?
 sta player0x,x
 dex
 bpl adjustloop
 endif
 endif
 if ((<*)>$e9)&&((<*)<$fa)
 repeat ($fa-(<*))
 nop
 repend
 endif
 sta WSYNC
     ldx #4
 SLEEP 3
HorPosLoop ; 5
 lda player0x,X ;+4 9
 sec ;+2 11
DivideLoop
 sbc #15
 bcs DivideLoop;+4 15
 sta temp1,X ;+4 19
 sta RESP0,X ;+4 23
 sta WSYNC
     dex
 bpl HorPosLoop;+5 5
 ; 4

 ldx #4
 ldy temp1,X
 lda repostable-256,Y
 sta HMP0,X ;+14 18

 dex
 ldy temp1,X
 lda repostable-256,Y
 sta HMP0,X ;+14 32

 dex
 ldy temp1,X
 lda repostable-256,Y
 sta HMP0,X ;+14 46

 dex
 ldy temp1,X
 lda repostable-256,Y
 sta HMP0,X ;+14 60

 dex
 ldy temp1,X
 lda repostable-256,Y
 sta HMP0,X ;+14 74

 sta WSYNC
     
     sta HMOVE ;+3 3


 ifconst legacy
 if legacy < 100
 ldx #4
adjustloop2
 lda player0x,x
 clc
 adc #14 ;?
 sta player0x,x
 dex
 bpl adjustloop2
 endif
 endif




 ;set score pointers
 lax score+2
 jsr scorepointerset
 sty scorepointers+5
 stx scorepointers+2
 lax score+1
 jsr scorepointerset
 sty scorepointers+4
 stx scorepointers+1
 lax score
 jsr scorepointerset
 sty scorepointers+3
 stx scorepointers

vblk
 ; run possible vblank bB code
 ifconst vblank_bB_code
 jsr vblank_bB_code
 endif
vblk2
 LDA INTIM
 bmi vblk2
 jmp kernel


 .byte $80,$70,$60,$50,$40,$30,$20,$10,$00
 .byte $F0,$E0,$D0,$C0,$B0,$A0,$90
repostable

scorepointerset
 and #$0F
 asl
 asl
 asl
 adc #<scoretable
 tay
 txa
 ; and #$F0
 ; lsr
 asr #$F0
 adc #<scoretable
 tax
 rts
;bB.asm
; bB.asm file is split here
 ifconst pfres
 if (<*) > (254-pfres*pfwidth)
 align 256
 endif
 if (<*) < (136-pfres*pfwidth)
 repeat ((136-pfres*pfwidth)-(<*))
 .byte 0
 repend
 endif
 else
 if (<*) > 206
 align 256
 endif
 if (<*) < 88
 repeat (88-(<*))
 .byte 0
 repend
 endif
 endif
pfcolorlabel13
 .byte $8A, $36,0,0
 .byte $8A, $36,0,0
 .byte $8A, $36,0,0
 .byte $8A, $36,0,0
 .byte $28, $82,0,0
 .byte $28, $82,0,0
 .byte $28, $82,0,0
 .byte $28, $38,0,0
 .byte $28, $38,0,0
 .byte $28, $38,0,0
 .byte $28, $38,0,0
 if (<*) > (<(*+3))
 repeat ($100-<*)
 .byte 0
 repend
 endif
playerL040_1
 .byte %00001010
 .byte %00001110
 .byte %00110011
 .byte %01110100
 if (<*) > (<(*+3))
 repeat ($100-<*)
 .byte 0
 repend
 endif
playerL044_1
 .byte %00001001
 .byte %00001110
 .byte %00110011
 .byte %01110100
 if (<*) > (<(*+3))
 repeat ($100-<*)
 .byte 0
 repend
 endif
playerL048_1
 .byte %00010001
 .byte %00001110
 .byte %00110011
 .byte %01110100
 if (<*) > (<(*+3))
 repeat ($100-<*)
 .byte 0
 repend
 endif
playerL052_1
 .byte %00010010
 .byte %00001110
 .byte %00110011
 .byte %01110100
 if (<*) > (<(*+14))
 repeat ($100-<*)
 .byte 0
 repend
 endif
playerL055_0
 .byte %00111100
 .byte %00111100
 .byte %00111100
 .byte %01111110
 .byte %00111100
 .byte %00111100
 .byte %00011000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 if ECHOFIRST
 echo " ",[(scoretable - *)]d , "bytes of ROM space left in bank 8")
 endif
ECHOFIRST = 1


; feel free to modify the score graphics - just keep each digit 8 high
; and keep the conditional compilation stuff intact
 ifconst ROM2k
 ORG $F7AC-8
 else
 ifconst bankswitch
 if bankswitch == 8
 ORG $2F94-bscode_length
 RORG $FF94-bscode_length
 endif
 if bankswitch == 16
 ORG $4F94-bscode_length
 RORG $FF94-bscode_length
 endif
 if bankswitch == 32
 ORG $8F94-bscode_length
 RORG $FF94-bscode_length
 endif
 if bankswitch == 64
 ORG $10F80-bscode_length
 RORG $1FF80-bscode_length
 endif
 else
 ORG $FF9C
 endif
 endif

; font equates
.21stcentury = 1
alarmclock = 2
handwritten = 3
interrupted = 4
retroputer = 5
whimsey = 6
tiny = 7

scoretable

 ifconst font
 if font == .21stcentury
 include "score_graphics.asm.21stcentury"
 endif
 if font == alarmclock
 include "score_graphics.asm.alarmclock"
 endif
 if font == handwritten
 include "score_graphics.asm.handwritten"
 endif
 if font == interrupted
 include "score_graphics.asm.interrupted"
 endif
 if font == retroputer
 include "score_graphics.asm.retroputer"
 endif
 if font == whimsey
 include "score_graphics.asm.whimsey"
 endif
 if font == tiny
 include "score_graphics.asm.tiny"
 endif
 else ; default font

 .byte %00111100
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %00111100

 .byte %01111110
 .byte %00011000
 .byte %00011000
 .byte %00011000
 .byte %00011000
 .byte %00111000
 .byte %00011000
 .byte %00001000

 .byte %01111110
 .byte %01100000
 .byte %01100000
 .byte %00111100
 .byte %00000110
 .byte %00000110
 .byte %01000110
 .byte %00111100

 .byte %00111100
 .byte %01000110
 .byte %00000110
 .byte %00000110
 .byte %00011100
 .byte %00000110
 .byte %01000110
 .byte %00111100

 .byte %00001100
 .byte %00001100
 .byte %01111110
 .byte %01001100
 .byte %01001100
 .byte %00101100
 .byte %00011100
 .byte %00001100

 .byte %00111100
 .byte %01000110
 .byte %00000110
 .byte %00000110
 .byte %00111100
 .byte %01100000
 .byte %01100000
 .byte %01111110

 .byte %00111100
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %01111100
 .byte %01100000
 .byte %01100010
 .byte %00111100

 .byte %00110000
 .byte %00110000
 .byte %00110000
 .byte %00011000
 .byte %00001100
 .byte %00000110
 .byte %01000010
 .byte %00111110

 .byte %00111100
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %00111100
 .byte %01100110
 .byte %01100110
 .byte %00111100

 .byte %00111100
 .byte %01000110
 .byte %00000110
 .byte %00111110
 .byte %01100110
 .byte %01100110
 .byte %01100110
 .byte %00111100

 ifnconst DPC_kernel_options

 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000

 endif

 endif

 ifconst ROM2k
 ORG $F7FC
 else
 ifconst bankswitch
 if bankswitch == 8
 ORG $2FF4-bscode_length
 RORG $FFF4-bscode_length
 endif
 if bankswitch == 16
 ORG $4FF4-bscode_length
 RORG $FFF4-bscode_length
 endif
 if bankswitch == 32
 ORG $8FF4-bscode_length
 RORG $FFF4-bscode_length
 endif
 if bankswitch == 64
 ORG $10FE0-bscode_length
 RORG $1FFE0-bscode_length
 endif
 else
 ORG $FFFC
 endif
 endif
; every bank has this stuff at the same place
; this code can switch to/from any bank at any entry point
; and can preserve register values
; note: lines not starting with a space are not placed in all banks
;
; line below tells the compiler how long this is - do not remove
;size=32

begin_bscode
 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif
 txs
 if bankswitch == 64
 lda #(((>(start-1)) & $0F) | $F0)
 else
 lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha

BS_return
 pha
 txa
 pha
 tsx

 if bankswitch != 64
 lda 4,x ; get high byte of return address

 rol
 rol
 rol
 rol
 and #bs_mask ;1 3 or 7 for F8/F6/F4
 tax
 inx
 else
 lda 4,x ; get high byte of return address
 tay
 ora #$10 ; change our bank nibble into a valid rom mirror
 sta 4,x
 tya
 lsr
 lsr
 lsr
 lsr
 tax
 inx
 endif

BS_jsr
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
 echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
 echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ifconst bankswitch
 if bankswitch == 8
 ORG $2FFC
 RORG $FFFC
 endif
 if bankswitch == 16
 ORG $4FFC
 RORG $FFFC
 endif
 if bankswitch == 32
 ORG $8FFC
 RORG $FFFC
 endif
 if bankswitch == 64
 ORG $10FF0
 RORG $1FFF0
 lda $ffe0 ; we use wasted space to assist stella with EF format auto-detection
 ORG $10FF8
 RORG $1FFF8
 ifconst superchip
 .byte "E","F","S","C"
 else
 .byte "E","F","E","F"
 endif
 ORG $10FFC
 RORG $1FFFC
 endif
 else
 ifconst ROM2k
 ORG $F7FC
 else
 ORG $FFFC
 endif
 endif
 .word start
 .word start
