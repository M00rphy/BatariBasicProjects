   ;***************************************************************
   ;  Converts 6 digit score to 3 sets of two digits.
   ;  _sc1 holds the 100 thousands and 10 thousands
   ;  digits of the score. _sc2 holds the thousands and
   ;  hundreds digits of the score. _sc3 holds the tens
   ;  and ones digits of the score.
   ;
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2


   ;***************************************************************
   ;  How to check the digits:
   ;
   ;  100 thousands digit .. _sc1 & $F0 (X0 00 00)
   ;  10 thousands digit ... _sc1 & $0F (0X 00 00)
   ;
   ;  Thousands digit ...... _sc2 & $F0 (00 X0 00)
   ;  Hundreds digit ....... _sc2 & $0F (00 0X 00)
   ;
   ;  Tens digit ........... _sc3 & $F0 (00 00 X0)
   ;  Ones digit ........... _sc3 & $0F (00 00 0X)


   scorecolor = $FA


__Main_Loop


   ;***************************************************************
   ;
   ;  Fire button check.
   ;
   ;
   if !joy0fire then goto __Skip_FireB

   ;```````````````````````````````````````````````````````````````
   ;  Remembers the thousands digit.
   ;
   temp5 = _sc2 & $F0

   ;```````````````````````````````````````````````````````````````
   ;  Add points to score.
   ;
   score = score + 10

   ;```````````````````````````````````````````````````````````````
   ;  Grabs the thousands digit.
   ;
   temp6 = _sc2 & $F0

   ;```````````````````````````````````````````````````````````````
   ;  Skips this part if thousands digit has NOT changed.
   ;  
   if temp5 = temp6 then goto __Skip_FireB

   COLUBK = $B4 : c = 45

__Skip_FireB


   if c then c = c - 1 : if !c then COLUBK = 0


   drawscreen


   goto __Main_Loop