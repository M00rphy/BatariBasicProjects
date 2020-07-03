 rem *******************************************************************
 rem ** Demo of playercolors+no_blank_lines kernel   
 rem ** 
 rem ** It provides 2xplayers with color and a ball. (no missiles)
 rem ** the trade-off is the middle playfield bytes are symmetrical
 rem *******************************************************************
 set kernel_options no_blank_lines player1colors

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

initialsetup

 playfield:
 XXXXXXXXX.X.X......X.X.XXXXXXXXX
 X......XXXXXXXXXXXXXXXXXX......X
 .......XXXXXXX....XXXXXXX......X
 X.......XXXXXX....XXXXXX.......X
 X...............................
 X..............................X
 XXXXXXXXXXXXX......XXXXXXXXXXXXX
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
