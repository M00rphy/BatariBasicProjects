; 48x1_kernel.asm
;	this is jumped to by any used 48x1adv minikernel, after the sprite
;	pointers have been setup and y has been set to the height of the image 

draw_bmp_48x1adv

	lda #3
	sta NUSIZ0	;3=Player and Missile are drawn twice 32 clocks apart 
	sta NUSIZ1	;3=Player and Missile are drawn twice 32 clocks apart 
	ldx #0
	stx GRP0
	stx GRP1
	clc

	lda titlescreencolor
	sta COLUPF
	lda #%11111111
	sta PF1
	lda #1
	sta CTRLPF

	tsx
	stx stack1 ;save the stack pointer

	;postion P0 and P1, Ball and Missile0
	sta WSYNC
	lda #%00100000
	sta HMP0
	lda #%00110000
	sta HMP1
	lda #0
	sta HMBL
	lda #%00100000
	sta HMM0

	sta WSYNC
	sleep 37
	sta RESP0
	sta RESP1
	sta WSYNC
	sleep 29
	sta RESM0
	sleep 7
	sta RESBL
	sta WSYNC

	sta HMOVE 	;3

	lda #3		;2
	sta VDELP0	;3
	sta VDELP1	;3

	;lda #2		;2
	;sta ENAM0	;3
	;sta ENABL	;3
	lda #5		;2
	sta CTRLPF	;3
	lda #0		;2
	sta VDELBL	;3

	;enough cycles have passed for the HMOV, so we can clear HMCLR
	sta HMCLR
	sta WSYNC

	sleep (59-8)		;59

	lda #2
	sta ENABL
	sta ENAM0

	jmp pf48x1_loop 	;3

      if >. != >[.+$5e]
      align 256
      endif

pf48x1_loop
	sleep 6
pf48x1_loop_line1

	lda (scorepointers+0),y 	;5
	sta GRP0		;3

	;fix the lost bit0 in the first character
	rol 		;2
	eor #2		;2
	sta ENABL 	;3

	lda (scorepointers+2),y 	;5
	sta GRP1		; 3

	lax (scorepointers+10),y	; 5
	txs			; 2	
	lax (scorepointers+8),y	; 5

	lda (scorepointers+4),y	; 5
	sta GRP0
	lda (scorepointers+6),y	; 5
	sta GRP1

	stx GRP0
	tsx
	stx GRP1
	sty GRP0

	lda aux3 		;3
	beq pf48x1_loop_line2 	;2/3
	sleep 2

	dey
	cpy #255
	bne pf48x1_loop_line1		;2/3

	jmp pf48x1_codeend

pf48x1_loop_line2

	lda (scorepointers+0),y 	;5
	sta GRP0		;3

	lda (aux5),y 	;5
	sta missile0y	;3

	sleep 7

	lda (scorepointers+2),y 	;5
	sta GRP1		; 3

	lax (scorepointers+10),y	; 5
	txs			; 2	
	lax (scorepointers+8),y	; 5

	lda (scorepointers+4),y	; 5
	sta GRP0
	lda (scorepointers+6),y	; 5
	sta GRP1
	stx GRP0
	tsx
	stx GRP1
	sty GRP0

	lda missile0y
	sta COLUP0
	sta COLUP1

	;sleep 6
	dey
	;cmp #255
	bpl pf48x1_loop_line1		;2/3

pf48x1_codeend
 ;echo "critical code in 48x1 is ",(pf48x1_codeend-pf48x1_loop), " bytes long."

	lda #0
	sta GRP0
	sta GRP1
	sta ENABL
	sta ENAM0
	sta VDELP0
	sta VDELP1
	sta PF0
	sta PF1
	sta PF2

	ldx stack1 ;restore the stack pointer
	txs
	rts
