 ; *** If you want to modify the bitmap color on the fly, just dim a
 ; *** variable in bB called "bmp_48x1_1_color", and use it to set the
 ; *** color.
 ;
 ; *** Otherwise you can hardcode it here...

 ifnconst bmp_gameselect_color
bmp_gameselect_color
 endif
	.byte $0f

 if >. != >[.+5]
 	align 256
 endif

bmp_gameselect_img
        .byte %01110111,%10001011
        .byte %10000101,%11011010
        .byte %10110111,%10101011
        .byte %10010101,%10001010
        .byte %01110101,%10001011
bmp_gameselect_imgend

 if >. != >[.+80]
 	align 256
 endif

font_gameselect_img
	.byte %00111100
	.byte %01100110
	.byte %01100110
	.byte %01100110
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %00111000
	.byte %00011000
	.byte %00011000
	.byte %00011000
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %01111100
	.byte %00000110
	.byte %00111100
	.byte %01100000
	.byte %01111110
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %01111100
	.byte %00000110
	.byte %00011100
	.byte %00000110
	.byte %01111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %01100110
	.byte %01100110
	.byte %01111110
	.byte %00000110
	.byte %00000110
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %01111110
	.byte %01100000
	.byte %01111100
	.byte %00000110
	.byte %01111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %00111100
	.byte %01100000
	.byte %01111100
	.byte %01100110
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %01111110
	.byte %00000110
	.byte %00001100
	.byte %00011000
	.byte %00011000
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %00111100
	.byte %01100110
	.byte %00111100
	.byte %01100110
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %00111100
	.byte %01100110
	.byte %00111110
	.byte %00000110
	.byte %00111100
	.byte %00000000
	.byte %00000000
	.byte %00000000
font_gameselect_imgend

 ifnconst gamenumber
gamenumber
 endif
	.byte 0

