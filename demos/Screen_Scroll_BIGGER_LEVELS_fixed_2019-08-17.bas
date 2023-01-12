 rem  example by lillapojkenpaon

 set smartbranching on
 set tv ntsc
 set kernel_options pfcolors no_blank_lines

 const scorefade=1
   dim _sc1 = score
   dim _sc2 = score+1
   dim _sc3 = score+2
 scorecolor=$0E


 rem https://www.atariarchives.org/mlb/chapter4.php
 rem Chapter 4: Addressing, Indirect Y, page 49
 rem https://www.atariarchives.org/mlb/chapter5.php
 rem Chapter 5: Arithmetic, Adding Numbers Larger Than 255, page 57

 rem http://atariage.com/forums/topic/263982-can-someone-explain-pointers-to-me/#entry3732833




 dim DataPtr = a.b 
                             

 rem  Pointers are easier than you think they are.  Memory addresses are 16-bit, and a pointer is two consecutive bytes that hold a memory address


 asm
    lda #<reallybigtable ; low byte of reallybigtable, <exp take LSB byte of a 16 bit expression
    sta DataPtr              ; store in first byte of pointer (a)
    lda #>reallybigtable ; high byte of reallybigtable, >exp take MSB byte of an expression
    sta DataPtr+1          ; store in second byte of pointer (b)
end

 dim  Page = DataPtr+1
 dim  Index = c 
 Index=0 




 rem   since the data for the left side and right side of the screen will end up occasionally being on different pages, making different pointers for both sides is probably the easiest way

 dim DataPtr2 = d.e 

 asm
    lda #<reallybigtable 
    sta DataPtr2              
    lda #>reallybigtable 
    sta DataPtr2+1          
end

 dim  Page2 = DataPtr2+1
 dim  Index2 = temp1



PopulateScreen
 rem make pfcolors black so we don't see the start of the level scroll in
  pfcolors:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
end
  gosub scrollleft
  drawscreen
 if Index<64 then PopulateScreen


 rem Now colorize and show
  pfcolors:
 $84
 $86
 $86
 $88
 $88
 $8A
 $8A
 $8C
 $8C
 $8E
 $8E
end

 rem  what pages the table ends up on changes depending where you put it or when adding or removing code, this saves you the trouble of updating the numbers
 const _after_last_page = #(>reallybigtable+5) 
 const _before_first_page = #(>reallybigtable-1) 





 Page2=Page-1

GameLoop

 Index2=Index-66



 if Page2=_before_first_page && Index2=254  then _skip ; skip if at the beginning of the really big table 
 if joy0left then goto scrollright
_skip

 if Page=_after_last_page && Index=0  then _skip2 ; skip if at the end of the really big table 
 if joy0right  then gosub scrollleft
_skip2 

_scrollright_return



   temp4 = Page2

   _sc1 = 0 : _sc2 = _sc2 & 15
   if temp4 >= 100 then _sc1 = _sc1 + 16 : temp4 = temp4 - 100
   if temp4 >= 100 then _sc1 = _sc1 + 16 : temp4 = temp4 - 100
   if temp4 >= 50 then _sc1 = _sc1 + 5 : temp4 = temp4 - 50
   if temp4 >= 30 then _sc1 = _sc1 + 3 : temp4 = temp4 - 30
   if temp4 >= 20 then _sc1 = _sc1 + 2 : temp4 = temp4 - 20
   if temp4 >= 10 then _sc1 = _sc1 + 1 : temp4 = temp4 - 10
   _sc2 = (temp4 * 4 * 4) | _sc2

 rem    temp4 = Index2
 rem    temp4 = Index
   temp4 = Page

   _sc2 = _sc2 & 240 : _sc3 = 0
   if temp4 >= 100 then _sc2 = _sc2 + 1 : temp4 = temp4 - 100
   if temp4 >= 100 then _sc2 = _sc2 + 1 : temp4 = temp4 - 100
   if temp4 >= 50 then _sc3 = _sc3 + 80 : temp4 = temp4 - 50
   if temp4 >= 30 then _sc3 = _sc3 + 48 : temp4 = temp4 - 30
   if temp4 >= 20 then _sc3 = _sc3 + 32 : temp4 = temp4 - 20
   if temp4 >= 10 then _sc3 = _sc3 + 16 : temp4 = temp4 - 10
   _sc3 = _sc3 | temp4

 drawscreen
 goto GameLoop







scrollleft
 pfscroll left


 asm
 ldy Index
 lda (DataPtr),y
 sta temp2
end


 asm
 iny
end


 asm
 lda (DataPtr),y
 sta temp3
end

 asm
 cpy #255 ; compare y with 255 (Index=254)
 bne _nope ; branch if not equal 
 inc Page ; increment Page if equal 
_nope
end


 rem   if  Index=254   then Page = Page + 1 ; It's easy to multiply double-byte numbers by decimal 256 by just adding one to the MSB. This would be a quick way of moving through the "pages" in memory.
  if  Index2=254   then Page2 = Page2 + 1 


 if temp2{0} then var3 = var3 | 128 else var3 = var3 & 127
 if temp2{1} then var7 = var7 | 128 else var7 = var7 & 127
 if temp2{2} then var11 = var11 | 128 else var11 = var11 & 127
 if temp2{3} then var15 = var15 | 128 else var15 = var15 & 127
 if temp2{4} then var19 = var19 | 128 else var19 = var19 & 127
 if temp2{5} then var23 = var23 | 128 else var23 = var23 & 127
 if temp2{6} then var27 = var27 | 128 else var27 = var27 & 127
 if temp2{7} then var31 = var31 | 128 else var31 = var31 & 127

 if temp3{0} then var35 = var35 | 128 else var35 = var35 & 127
 if temp3{1} then var39 = var39 | 128 else var39 = var39 & 127
 if temp3{2} then var43 = var43 | 128 else var43 = var43 & 127

 Index=Index+2
 return





scrollright
 pfscroll right


 asm
 ldy Index2
 lda (DataPtr2),y ; The value in the parentheses must be $00-$ff, which is known as zero page memory.
 sta temp2
end


 asm
 iny
end


 asm
 lda (DataPtr2),y
 sta temp3
end

 asm
 cpy #1 ; compare y with 1 (Index2=0)
 bne _nope2 ; branch if not equal 
 dec Page2 ; decrement Page2 if equal 
_nope2
end

 rem   if  Index2=0   then Page2 = Page2 - 1 ; It's easy to multiply double-byte numbers by decimal 256 by just adding one to the MSB. This would be a quick way of moving through the "pages" in memory.
  if  Index=0   then Page = Page - 1 


 if temp2{0} then var0 = var0 | 128 else var0 = var0 & 127
 if temp2{1} then var4 = var4 | 128 else var4 = var4 & 127
 if temp2{2} then var8 = var8 | 128 else var8 = var8 & 127
 if temp2{3} then var12 = var12 | 128 else var12 = var12 & 127
 if temp2{4} then var16 = var16 | 128 else var16 = var16 & 127
 if temp2{5} then var20 = var20 | 128 else var20 = var20 & 127
 if temp2{6} then var24 = var24 | 128 else var24 = var24 & 127
 if temp2{7} then var28 = var28 | 128 else var28 = var28 & 127

 if temp3{0} then var32 = var32 | 128 else var32 = var32 & 127
 if temp3{1} then var36 = var36 | 128 else var36 = var36 & 127
 if temp3{2} then var40 = var40 | 128 else var40 = var40 & 127

 Index=Index-2 
 goto _scrollright_return




 asm
 align 256
end

 rem level data table 
 data reallybigtable ; 5 pages
 255,7,0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,12,0,12,0,12
 0,12,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,28,0,28,0,28,0,28,0,28,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,12,0,12
 0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,8,0,8,0,8,0,8,0,0,0,0,0,0,0,8,0,12,0,12,0,12,0,4,0,4
 0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4

 0,6,0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,14,0,14,0,14
 0,14,0,6,0,6,0,6,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,6,0,6,0,6,0,30,0,30,0,30,0,30,0,30,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,14,0,14
 0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,8,0,8,0,8,0,8,0,0,0,0,0,0,0,8,0,14,0,14,0,14,0,6,0,6
 0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6

 0,7,0,7,0,7,0,7,0,15,0,15,0,15,0,15,0,7,0,15,0,15,0,15,0,15,0,7,0,15,0,15,0,15,0,15,0,7,0,15,0,15,0,15,0,15,0,15,0,15,0,7,0,7,0,7,0,7,0,15,0,15,0,15
 0,15,0,7,0,7,0,7,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,7,0,7,0,7,0,31,0,31,0,31,0,31,0,31,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,15,0,15
 0,15,0,15,0,15,0,15,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,8,0,8,0,8,0,8,0,0,0,0,0,0,0,8,0,15,0,15,0,15,0,7,0,7
 0,7,0,7,0,7,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7

 0,6,0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,14,0,14,0,14
 0,14,0,6,0,6,0,6,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,6,0,6,0,6,0,30,0,30,0,30,0,30,0,30,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,14,0,14
 0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,8,0,8,0,8,0,8,0,0,0,0,0,0,0,8,0,14,0,14,0,14,0,6,0,6
 0,6,0,6,0,6,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,14,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6

 0,4,0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,12,0,12,0,12
 0,12,0,4,0,4,0,4,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,4,0,4,0,28,0,28,0,28,0,28,0,28,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,12,0,12
 0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,8,0,8,0,8,0,8,0,0,0,0,0,0,0,8,0,12,0,12,0,12,0,4,0,4
 0,4,0,4,0,4,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,12,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,0,4,255,7
end
