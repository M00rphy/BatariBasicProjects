
 ; *** if you want to modify the bitmap color on the fly, just dim a
 ; *** variable in bB called 'bmp_48x1_3_color' , and use it to set the
 ; *** color.

 ;*** The height of the displayed data...
bmp_48x1_3_window = 22

 ;*** The height of the bitmap data. This can be larger than
 ;*** the displayed data height, if you are scrolling or animating
 ;*** the data...
bmp_48x1_3_height = 22

 ifnconst bmp_48x1_3_color
bmp_48x1_3_color
 endif
 ; *** this is the bitmap color. If you want to change it in a 
 ; *** variable instead, dim one in bB called bmp_48x1_3_color
	.byte $44


   if >. != >[.+bmp_48x1_3_height]
      align 256
   endif

bmp_48x1_3_00

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000001
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00001000
	BYTE %00001000
	BYTE %00001110
	BYTE %00001001
	BYTE %00001110
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x1_3_height)]
      align 256
   endif

bmp_48x1_3_01

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10001100
	BYTE %10010010
	BYTE %10010010
	BYTE %10010010
	BYTE %11001100
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01001011
	BYTE %01001010
	BYTE %01110011
	BYTE %01001010
	BYTE %01110011
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x1_3_height)]
      align 256
   endif

bmp_48x1_3_02

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00011100
	BYTE %00000010
	BYTE %00001100
	BYTE %00010000
	BYTE %00001110
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10111001
	BYTE %00000100
	BYTE %00011000
	BYTE %00100001
	BYTE %10011100
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x1_3_height)]
      align 256
   endif

bmp_48x1_3_03

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01001001
	BYTE %01001111
	BYTE %01001001
	BYTE %01000110
	BYTE %11100110
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %11000001
	BYTE %00100001
	BYTE %11000001
	BYTE %00000001
	BYTE %11100001
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x1_3_height)]
      align 256
   endif

bmp_48x1_3_04

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %01001001
	BYTE %01001001
	BYTE %01110001
	BYTE %01001001
	BYTE %01110011
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00010100
	BYTE %00010100
	BYTE %10010111
	BYTE %00010100
	BYTE %11010111
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000

   if >. != >[.+(bmp_48x1_3_height)]
      align 256
   endif

bmp_48x1_3_05

	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %10111000
	BYTE %10100000
	BYTE %00110000
	BYTE %10100000
	BYTE %00111000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
	BYTE %00000000
