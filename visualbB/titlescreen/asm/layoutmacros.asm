
 ; the macro's used in the "titlescreen_layout.asm" file

 MAC draw_96x2_1
mk_96x2_1_on = 1
 jsr draw_bmp_96x2_1
 ENDM

 MAC draw_96x2_2
mk_96x2_2_on = 1
 jsr draw_bmp_96x2_2
 ENDM

 MAC draw_96x2_3
mk_96x2_3_on = 1
 jsr draw_bmp_96x2_3
 ENDM

 MAC draw_48x1_1
mk_48x1_on = 1
mk_48x1_1_on = 1
 jsr draw_bmp_48x1_1
 ENDM

 MAC draw_48x1_2
mk_48x1_on = 1
mk_48x1_2_on = 1
 jsr draw_bmp_48x1_2
 ENDM

 MAC draw_48x1_3
mk_48x1_on = 1
mk_48x1_3_on = 1
 jsr draw_bmp_48x1_3
 ENDM

 MAC draw_48x2_1
mk_48x1_on = 1
mk_48x2_1_on = 1
 jsr draw_bmp_48x2_1
 ENDM

 MAC draw_48x2_2
mk_48x1_on = 1
mk_48x2_2_on = 1
 jsr draw_bmp_48x2_2
 ENDM

 MAC draw_48x2_3
mk_48x1_on = 1
mk_48x2_3_on = 1
 jsr draw_bmp_48x2_3
 ENDM

 MAC draw_score
mk_score_on = 1
 jsr draw_score_display
 ENDM

 MAC draw_gameselect
mk_gameselect_on = 1
 jsr draw_gameselect_display
 ENDM

 MAC draw_space 
 ldy #{1}
.loop
 sta WSYNC
 dey
 bne .loop
 ENDM 

