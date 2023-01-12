
draw_gameselect_display

	lda #2
	sta NUSIZ0	;3=Player and Missile 2x medium spacing
	sta NUSIZ1	;3=Player and Missile 2x medium spacing
	ldx #0
	ldy #0
	sty aux5
	clc

	lda #1
	sta CTRLPF

	lda bmp_gameselect_color
 ifconst bmp_gameselect_fade
	and bmp_gameselect_fade
 endif
	sta COLUP0		;3
	sta COLUP1	  	;3
	sta HMCLR		;3

	;setup pointers for the game number
	lda gamenumber
	sta temp3 
	lda #0
	sta temp5
	ldx #8
	clc
	sed

converttobcd
	asl temp3

	lda temp5
	adc temp5
	sta temp5

	dex
	bne converttobcd
	cld

	lda temp5
	and #$0f
	asl
	asl
	asl
	clc
	adc #<font_gameselect_img
	sta temp3

	lda temp5
	and #$f0
	lsr
	clc
	adc #<font_gameselect_img
	sta temp1
	
	lda #>font_gameselect_img
	sta temp2
	sta temp4


pfgameselect_frame

	tsx
	stx stack1 ;save the stack pointer
	;postion P0 and P1
	sta WSYNC
	lda #%00100000
	sta HMP0
	lda #%00100000
	sta HMP1
	sta WSYNC
	sleep 37
	sta RESP0
	sta RESP1
	sta WSYNC
	sta HMOVE

	ldy #0
	ldx #0
	sty VDELBL
	sleep 10
	sta HMCLR

	sta WSYNC

	sleep (76-14+7)

	lda bmp_gameselect_img+0,x 	;4
	sta GRP0			;3
	sleep 4				;7
	jmp pfgameselect_line1

	if >. != >[.+$28]
	align 256
	endif

pfgameselect_line1

	;----------------- start on cycle 7
	lda bmp_gameselect_img+1,x
	sta GRP1

	sleep 24
	lda (temp1),y ;5

	sta GRP0			;3
	lda (temp3),y ;5
	sta GRP1			;3

	inx ;2
	inx ;2
	iny ;2


	lda bmp_gameselect_img+0,x 	;4+ 
	sta GRP0		;3

	sta WSYNC

	sleep 2

	cpy #5
	bne pfgameselect_line1		;2/3
pfgameselect_codeend
 ;echo "critical code in gameselect is ",(pfgameselect_codeend-pfgameselect_line1), " bytes long."

	lda #0
	sta GRP0
	sta GRP1
	sta ENABL
	sta ENAM0
	sta PF0
	sta PF1
	sta PF2

	ldx stack1 ;restore the stack pointer
	txs

	rts
