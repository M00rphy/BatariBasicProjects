
draw_bmp_48x1_2

	lda #0
	sta GRP0
	sta GRP1

	ldy #(bmp_48x1_2_window-1)

	;setup score pointers to point at my bitmap slices instead
	lda #<bmp_48x1_2_00
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+0
	lda #>bmp_48x1_2_00
	sta scorepointers+1


	lda #<bmp_48x1_2_01
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+2
	lda #>bmp_48x1_2_01
	sta scorepointers+3


	lda #<bmp_48x1_2_02
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+4
	lda #>bmp_48x1_2_02
	sta scorepointers+5


	lda #<bmp_48x1_2_03
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+6
	lda #>bmp_48x1_2_03
	sta scorepointers+7


	lda #<bmp_48x1_2_04
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+8
	lda #>bmp_48x1_2_04
	sta scorepointers+9


	lda #<bmp_48x1_2_05
	clc
	adc #(#bmp_48x1_2_height-#bmp_48x1_2_window)
 ifconst bmp_48x1_2_index
	sec
	sbc bmp_48x1_2_index
 endif
	sta scorepointers+10
	lda #>bmp_48x1_2_05
	sta scorepointers+11

	lda #1		;single line kernel
	sta aux3

        lda bmp_48x1_2_color
        sta COLUP0              ;3
        sta COLUP1              ;3
        sta HMCLR               ;3


 	jmp draw_bmp_48x1adv
	
