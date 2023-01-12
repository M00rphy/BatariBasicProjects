
draw_bmp_48x2_3

	ldy #(bmp_48x2_3_window-1)

	lda #<(bmp_48x2_3_colors-1)
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta aux5+0
	lda #>(bmp_48x2_3_colors-1)
	sta aux5+1

	iny
	lda (aux5),y
	dey
        sta COLUP0              ;3
        sta COLUP1              ;3
        sta HMCLR               ;3

	;setup score pointers to point at my bitmap slices instead
	lda #<bmp_48x2_3_00
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+0
	lda #>bmp_48x2_3_00
	sta scorepointers+1


	lda #<bmp_48x2_3_01
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+2
	lda #>bmp_48x2_3_01
	sta scorepointers+3


	lda #<bmp_48x2_3_02
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+4
	lda #>bmp_48x2_3_02
	sta scorepointers+5


	lda #<bmp_48x2_3_03
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+6
	lda #>bmp_48x2_3_03
	sta scorepointers+7


	lda #<bmp_48x2_3_04
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+8
	lda #>bmp_48x2_3_04
	sta scorepointers+9


	lda #<bmp_48x2_3_05
	clc
	adc #(#bmp_48x2_3_height-#bmp_48x2_3_window)
 ifconst bmp_48x2_3_index
	sec
	sbc bmp_48x2_3_index
 endif
	sta scorepointers+10
	lda #>bmp_48x2_3_05
	sta scorepointers+11

        lda #0          ;two line kernel
        sta aux3

 	jmp draw_bmp_48x1adv
	
