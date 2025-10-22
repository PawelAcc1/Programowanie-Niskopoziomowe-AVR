         LDI R24, 5
         RCALL DelayInMs
         NOP

DelayInMs: 
mainloop:STS $60, R24
         LDI R24, $CB
         LDI R25, $07
         RCALL DelayOneMs
         LDS R24, $60
         DEC R24
         BRNE mainloop
         RET

DelayOneMs:
inloop:  SBIW R25:R24, 1
         BRCC inloop
         RET