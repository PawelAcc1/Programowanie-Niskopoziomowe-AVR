         LDI R22, 8
mainloop:LDI R21, 14
outloop: LDI R20, 142
inloop:  NOP
         DEC R20
         BRNE inloop
         NOP
         DEC R21
         BRNE outloop
         NOP
         DEC R22
         BRNE mainloop
         RJMP 0

         /* 1 + 4*(R20-1) + 3  = 4*R20 = x
             1+ (x+4)*(R21-1) + x+3 = (x+4)*R21 = (4*R20 + 4)*R21* = 4*(R20+1)*R21 = y */
        /* 1 + (y+4)*(R22-1) + y+3 = (y+4)*R22 = (4*(R20+1)*R21 + 4)*R22 = 4*((R20+1)*R21+1)*R22 */
