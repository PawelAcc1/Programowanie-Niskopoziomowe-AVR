         LDI R22, 5
         RCALL DelayInMs
         NOP

DelayInMs: 
mainloop:LDI R24, $CC
         LDI R25, $07
         RCALL DelayOneMs
         DEC R24
         BRNE mainloop
         RET

DelayOneMs:
inloop:  SBIW R25:R24, 1
         BRCC inloop
         RET