;**************************************************************************
;    Standard kernel configuration.
;
 set tv ntsc
 set kernel_options player1colors pfcolors no_blank_lines
 set romsize 32k



 ;*************************************************************************
 ;
 ;       Variable dimming.
 ;
 ;

 dim _Lives = a
 dim _Frame_sD_Anim = v



 rem Create the title screen
opening
 pfcolors:
 $8A
 $8A
 $8A
 $8A
 $8A
 $28
 $28
 $28
 $28
 $28
 $28
 $28
end
 playfield:
 ..X........X.....X...X.....X....
 ..XXX.....X.X...X.X..XX...XX....
 ..X..XX..X...X.X...X.X.X.X.X....
 ..X....X.X...X.X...X.X..X..X....
 ..X....X.X...X.X...X.X.....X....
 ..X....X.X...X.X...X.X.....X....
 ..X...X..X...X.X...X.X.....X....
 ..X..X...X...X.X...X.X.....X....
 ..X..X....X.X...X.X..X.....X....
 ..X.X......X.....X...X.....X....
 ..XX.......................X....
 ..X........................X....
end

 rem Loop the screen until the spacebar is pressed
title
 drawscreen
 if joy0fire || joy1fire then goto skiptitle
 goto title

 rem This function displays after the title is skipped
skiptitle

 rem Colors
 COLUPF = 0
 COLUBK = $08

 rem Player location
 player0x = 78 : player0y = 88
 player1x = 20 : player1y = 20

 rem Score setting and color
 score = 5 : scorecolor = 0

 rem Missle size and location
 ballheight=4:bally=255
 NUSIZ0 = 16

 rem Create a variable to keep up with lives
 _Lives = 5

 rem Create the playfield

 pfcolors:
 $36
 $36
 $36
 $36
 $36
 $82
 $82
 $82
 $38
 $38
 $38
 $38
end
 playfield:
 ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
 .......XXXXXXXXXXXXXXXXXX.......
 .........XXXXXXXXXXXXXX.........
 ...........XXXXXXXXXX...........
 .............XXXXXX.............
 .............XXXXXX.............
 .............XXXXXX.............
 ...........XXXXXXXXXX...........
 .........XXXXXXXXXXXXXX.........
 .......XXXXXXXXXXXXXXXXXX.......
 ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
end


 rem This main function is what loops constantly
main

 rem This is the animation function
animate
 rem This frame variable slows down the animation
 _Frame_sD_Anim = _Frame_sD_Anim + 1 
 
 rem This code animates the sprites
 if _Frame_sD_Anim = 7 && w = 0 then ax
 if _Frame_sD_Anim = 7 && w = 1 then bx
 if _Frame_sD_Anim = 7 && w = 2 then cx
 if _Frame_sD_Anim = 7 && w = 3 then dx

 goto nextstep
 
 rem These four sprites are different stages of the animation
ax
 _Frame_sD_Anim = 0
 w = 1
 player1:
 %00001010
 %00001110
 %00110011
 %01110100
end
 goto nextstep
 
bx
 _Frame_sD_Anim = 0
 w = 2
 player1:
 %00001001
 %00001110
 %00110011
 %01110100
end
 goto nextstep

cx
 _Frame_sD_Anim = 0
 w = 3
 player1:
 %00010001
 %00001110
 %00110011
 %01110100
end
 goto nextstep
 
dx
 _Frame_sD_Anim = 0
 w = 0
 player1:
 %00010010
 %00001110
 %00110011
 %01110100
end
 goto nextstep

 rem Create acorn sprite
nextstep
 player0:
 %00111100
 %00111100
 %00111100
 %01111110
 %00111100
 %00111100
 %00011000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 rem check to see if a missile has already been fired
checkfire
 if bally>240 then goto skip
 bally = bally - 2 : goto draw

 rem if a missile hasn't been fired, then fire missile
skip
 if joy0fire then bally=player0y-2:ballx=player0x+4

 rem Draw output to screen
draw
 drawscreen

 rem Fix player wraparound bug
 if player0x < 8 then player0x = 8
 if player0x > 150 then player0x = 150
 if player0y < 8 then player0y = 8
 if player0y > 88 then player0y = 88

 rem Have player 1 chase player 2
 if player1y < player0y then player1y = player1y + 1
 if player1y > player0y then player1y = player1y - 1
 if player1x < player0x then player1x = player1x + 1
 if player1x > player0x then player1x = player1x - 1
 player1x = player1x : player1y = player1y


 rem Detect missile collision with squirrel
 if collision(ball,player1) then score=score+1:player1x=rand/2:player1y=0:bally=255:goto pointsound
 rem Detect squirrel collision with the acorn
 if collision(player0,player1) then score=score-1:player1x=rand/2:player1y=0:bally=255:_Lives=_Lives-1:goto deadsound


 rem joystick movements
 ;if joy0up then player0y = player0y-1 : goto skipmove
 ;if joy0down then player0y = player0y+1 : goto skipmove
 if joy0left then player0x = player0x-1 : goto skipmove
 if joy0right then player0x = player0x +1 : goto skipmove

 rem refresh the screen
skipmove
 goto main

 rem Play point sound
pointsound
 AUDV0 = 5 : AUDC0 = 4 : AUDF0 = 10
 p = p + 1
 drawscreen
 if p < 2 then pointsound
 p = 0
 AUDV0 = 0 : AUDC0 = 0 : AUDF0 = 0
 goto main

 rem Play dead sound
deadsound
 AUDV1 = 10
 AUDC1 = 7
 AUDF1 = 12
 p = p + 1
 drawscreen
 if p < 10 then deadsound
 p = 0
 AUDV1 = 0 : AUDC1 = 0 : AUDF1 = 0
 if _Lives = 0 then goto opening
 goto main

;TODO: add the rest of the frames, create a counter for the frames which will replace the player0 movement
;from the Y axis (front and back), the counter will work like this if the joystick is moved up then it adds
; one to the counter if it's moved down it substracts one from the counter, which will work
; as a frame navigation system using a gosub "on "x" gosub _Fr_1 _Fr_2 _Fr_3 _Fr_4 _Fr_5" and once it
; reaches the limit of 5 it gets reseted; also add a sort of blocking so that if the counter is 0
; it doesn't change to 5.
;
; create the imp sprite and animate it, also find a way to trigger the second main sprite on a fire button
; press using another counter, dim the variables and the character names as well.