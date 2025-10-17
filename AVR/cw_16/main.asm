         LDI R20, 10
outloop: LDI R21, 199
inloop:  NOP
         DEC R21
         BRNE inloop
         NOP
         DEC R20
         BRNE outloop
         RJMP 0

         /* 1 + 4*(R21-1) + 3  = 4*R21 = x
             1+ (x+4)*(R20-1) + x+3 = (x+4)*R20 = (4*R21 + 4)*R20* = 4*(R21+1)*R20 
             10000 = 1,25
                 x = 1*/
