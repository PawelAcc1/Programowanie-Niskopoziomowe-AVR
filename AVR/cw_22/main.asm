         LDI R22, 5
         RCALL DelayInMs
         NOP

DelayInMs: 
mainloop:LDI R24, $CE
         LDI R25, $07
inloop:  SBIW R25:R24, 1
         BRCC inloop
         DEC R22
         BRNE mainloop
         RET

