         LDI R22, 12
mainloop:LDI R24, $CE
         LDI R25, $07
inloop:  SBIW R25:R24, 1
         BRCC inloop
         DEC R22
         BRNE mainloop
         RJMP 0

         /*1+1+1+4*(R25:R24)+2+1+1 = 1 + 6 + 4**/