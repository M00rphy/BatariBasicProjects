 rem Generated 1/4/2010 1:48:01 PM by Visual bB Version 1.0.0.548
 rem **********************************
 rem *<Five Nights at Freddy's>       *
 rem *<Shoot Freddy before he         *
 rem *stuffs you in a Fazbear suit.>  *
 rem *<contact info>                  *
 rem *<license>                       *
 rem **********************************
 rem Create the title screen
  set smartbranching on


   rem  *****************************************************
   rem  *  Create aliases for variables
   rem  *****************************************************
   dim duration=a
   dim rand16=z


   rem  *****************************************************
   rem  *  Variable descriptions
   rem  *****************************************************
   rem  *  duration - how long each note plays
   rem  *  x - used for sdata
   rem  *  y - used for sdata
   rem  *  rand16 - makes better random numbers


   rem  *  Volume off
   AUDV0=0
   AUDV1=0


   rem  *  Initialize duration and set up music
   duration = 1
   

opening
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X....XXX..XXX.XXXXXX.XXXXXX....X
 X.XXXXXX.X.XX.XXXXX.X.XXXXX.XXXX
 X....XXX.XX.X.XXXX.XXX.XXXX....X
 X.XXXXXX.XXX..XXX.......XXX.XXXX
 X.XXXXXX.XXXX.XX.XXXXXXX.XX.XXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end 
 goto MusicSetup
 rem Loop the screen until the spacebar is pressed
title
   goto GetMusic
GotMusic

   

   

 COLUBK = $40
 COLUPF = $00
 drawscreen
 if joy0fire || joy1fire then goto skiptitle :AUDV0=0 :AUDV1=0
   
 goto title

 rem This function displays after the title is skipped
skiptitle
 
 rem Colors
 COLUPF = $00
 COLUBK = $04

 rem Player location
 player0x = 80 : player0y = 70
 player1x = 120 : player1y = 15

 rem Score setting and color
 score = 3 : scorecolor = 0

 rem Missle size and location
 missile0height=4:missile0y=255
 NUSIZ0 = 16

 rem Create a variable to keep up with lives
 a = 3

 rem Create the playfield
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXX....XXXXXXXXXXXXXXXXXX....XXX
 XX......XX..XXXXXXXX..XXX.....XX
 XX......XX..XXXXXXXX..XX......XX
 XX.....XXX............XXX.....XX
 XX............................XX
 XX............................XX
 XX.....XXX............XXX.....XX
 XX......XX............XX......XX
 XX......XX....XXXX....XX......XX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 rem This main function is what loops constantly
main


 rem This is the animation function
animate
 rem This frame variable slows down the animation
 v = v + 1 
 
 rem This code animates the sprites
 if v = 7 && w = 0 then ax
 if v = 7 && w = 1 then bx
 if v = 7 && w = 2 then cx
 if v = 7 && w = 3 then dx

 goto nextstep
 
 rem These four sprites are different stages of the animation
ax
 v = 0
 w = 1
 player1:
 %00000000
 %01111110
 %01000010
 %01111110
 %01111110
 %01011010
 %01111110
 %01100110
end
 goto nextstep
 
bx
 v = 0
 w = 2
 player1:
 %00000000
 %01111110
 %01000010
 %01000010
 %01111110
 %01011010
 %01111110
 %01100110
end
 goto nextstep

cx
 v = 0
 w = 3
 player1:
 %00000000
 %01111110
 %01000010
 %01111110
 %01111110
 %01011010
 %01111110
 %01100110
end
 goto nextstep
 
dx
 v = 0
 w = 0
 player1:
 %00000000
 %01111110
 %01000010
 %01000010
 %01111110
 %01011010
 %01111110
 %01100110
end
 goto nextstep

 rem Create nightwatch sprite
nextstep
 player0:
 %00000000
 %01111110
 %01000010
 %01011010
 %01111110
 %01011010
 %01111110
 %00000000
end

 rem check to see if a missile has already been fired
checkfire
 if missile0y>240 then goto skip
 missile0y = missile0y - 2 : goto draw

 rem if a missile hasn't been fired, then fire missile
skip
 if joy0fire then missile0y=player0y-2:missile0x=player0x+4

 rem Draw output to screen
draw
 drawscreen

 rem Fix player wraparound bug
 if player0x < 8 then player0x = 8
 if player0x > 150 then player0x = 150
 if player0y < 8 then player0y = 8
 if player0y > 84 then player0y = 84

 rem Have player 1 chase player 0
 if player1y < player0y then player1y = player1y + 1
 if player1y > player0y then player1y = player1y - 1
 if player1x < player0x then player1x = player1x + 1
 if player1x > player0x then player1x = player1x - 1
 player1x = player1x : player1y = player1y


 rem Detect missile collision with freddy
 if collision(missile0,player1) then score=score+1:player1x=rand/2:player1y=0:missile0y=255:goto pointsound
 rem Detect freddy collision with the nightwatch
 if collision(player0,player1) then score=score-1:player1x=rand/2:player1y=0:missile0y=255:a=a-1:goto deadsound
 if collision(playfield,player0) 

 rem joystick movements
 if joy0up then player0y = player0y-1 : goto skipmove
 if joy0down then player0y = player0y+1 : goto skipmove
 if joy0left then player0x = player0x-1 : goto skipmove
 if joy0right then player0x = player0x +1 : goto skipmove

 rem refresh the screen
skipmove
 goto main

 rem Play point sound
pointsound
 AUDV0 = 8 : AUDC0 = 4 : AUDF0 = 11
 p = p + 1
 drawscreen
 if p < 2 then pointsound
 p = 0
 AUDV0 = 0 : AUDC0 = 0 : AUDF0 = 0
 goto main

 rem  *****************************************************
   rem  *
   rem  *  Music Starter using sdata
   rem  *
   rem  *  Based on code posted in the Ballblazer thread at AtariAge:
   rem  *  http://www.atariage.com/forums/index.php?s=&showtopic=130990&view=findpost&p=1615280
   rem  *
   rem  *  Code adapted by Duane Alan Hahn (Random Terrain)
   rem  *
   rem  *  Explanation:
   rem  *  The 256-byte limitation is removed when using sdata.
   rem  *  You can fill a whole 4k bank with music if you want.
   rem  *
   rem  *****************************************************


  



   rem  *****************************************************
   rem  *
   rem  *  Main game loop starts here.
   rem  *
   rem  *****************************************************


 



   rem  *****************************************************
   rem  *  Music
   rem  *****************************************************
GetMusic

   rem  *  Check for end of current note
   duration = duration - 1
   if duration>0 then GotMusic


   rem  *  Retrieve channel 0 data
   temp4 = sread(musicData)
   temp5 = sread(musicData)
   temp6 = sread(musicData)


   rem  *  Check for end of data
   if temp4=255 then duration = 1 : goto MusicSetup


   rem  *  Play channel 0
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6


   rem  *  Retrieve channel 1 data
   temp4 = sread(musicData)
   temp5 = sread(musicData)
   temp6 = sread(musicData)


   rem  *  Play channel 1
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6


   rem  *  Set duration
   duration = sread(musicData)
   goto GotMusic




   rem  *****************************************************
   rem  *  Music Data Block
   rem  *****************************************************
   rem  *  Format:
   rem  *  v,c,f (channel 0)
   rem  *  v,c,f (channel 1) 
   rem  *  d
   rem  *
   rem  *  Explanation:
   rem  *  v - volume (0 to 15)
   rem  *  c - control [a.k.a. tone, voice, and distortion] (0 to 15)
   rem  *  f - frequency (0 to 31)
   rem  *  d - duration

MusicSetup
   sdata musicData=x


  8,4,9
  0,0,0
  6
  8,4,9
  0,0,0
  6
  8,4,11
  0,0,0
  6
  8,4,14
  0,0,0
  6
  8,4,14
  0,0,0
  6
  8,4,9
  0,0,0
  6
  8,4,11
  0,0,0
  6
  8,4,11
  0,0,0
  6
  8,4,14
  0,0,0
  6
  8,4,15
  0,0,0
  6
  8,4,15
  0,0,0
  6
  8,4,9
  0,0,0
  6
  8,4,11
  0,0,0
  6
  8,4,14
  0,0,0
  6
  8,4,15
  0,0,0
  6
  8,4,15
  0,0,0
  11
  8,4,11
  0,0,0
  6
  8,4,14
  0,0,0
  6
  8,4,15
  0,0,0
  6
  8,4,9
  0,0,0
  6
  8,4,9
  0,0,0
  6
  8,12,5
  0,0,0
  6
  8,12,4
  0,0,0
  6
  8,12,7
  0,0,0
  6
  8,12,8
  0,0,0
  6
  8,12,6
  0,0,0
  6
  8,12,2
  0,0,0
  6
  8,12,11
  0,0,0
  6
  8,12,6
  0,0,0
  6
  8,12,9
  0,0,0
  6
  8,14,6
  0,0,0
  6
  8,14,10
  0,0,0
  0
  8,7,27
  0,0,0
  6
  8,7,25
  0,0,0
  6
  8,7,28
  0,0,0
  6
  8,7,30
  0,0,0
  6
  8,7,21
  0,0,0
  6
  8,7,20
  0,0,0
  6
  8,7,13
  0,0,0
  6
  8,7,12
  0,0,0
  6
  8,7,10
  0,0,0
  6
  8,7,6
  0,0,0
  6
  8,6,13
  0,0,0
  6
  8,6,20
  0,0,0
  6
  8,6,21
  0,0,0
  6
  8,6,22
  0,0,0
  6
  8,6,24
  0,0,0
  6
  8,6,25
  0,0,0
  6
  8,6,27
  0,0,0
  6
  8,6,28
  0,0,0
  6
  8,6,30
  0,0,0
  6
  8,1,23
  0,0,0
  6
  8,1,22
  0,0,0
  6
  8,1,19
  0,0,0
  6
  8,1,17
  0,0,0
  0
  8,1,18
  0,0,0
  6
  8,1,16
  0,0,0
  6
  8,1,15
  0,0,0
  6
  8,1,14
  0,0,0
  6
  8,1,13
  0,0,0
  6
  8,1,28
  0,0,0
  6
  8,1,29
  0,0,0
  6
  8,1,31
  0,0,0
  6


  255
end
   goto GotMusic


 rem Play dead sound
deadsound
 AUDV1 = 8
 AUDC1 = 6
 AUDF1 = 15
 p = p + 1
 drawscreen
 if p < 10 then deadsound
 p = 0
 AUDV1 = 0 : AUDC1 = 0 : AUDF1 = 0
 if a = 0 then goto opening
 goto main








