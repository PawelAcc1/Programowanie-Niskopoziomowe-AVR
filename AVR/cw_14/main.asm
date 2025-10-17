         LDI R20, 20
outloop: LDI R21, 25
inloop:  NOP
         DEC R21
         BRNE inloop
         DEC R20
         BRNE outloop
         RJMP 0