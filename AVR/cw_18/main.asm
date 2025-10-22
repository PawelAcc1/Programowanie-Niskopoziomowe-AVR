         LDI R22, 5
mainloop:LDI R18, 1
         LDI R21, $F8
         LDI R20, $31
inloop:  ADD R20, R18
         ADC R21, R19
         BRCC inloop
         DEC R22
         BRNE mainloop
         RJMP 0

         



