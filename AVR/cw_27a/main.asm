         LDI R24, LOW(5)
         LDI R25, HIGH(5)
         RCALL DelayInMs
         NOP

DelayInMs: 
mainloop:
         PUSH R25
         PUSH R24																								
         RCALL DelayOneMs         /*2 + (4+(4*(R25:R24) + 9)+4+2+2)*/
         POP R24
         POP R25
         SBIW R25:R24, 1
         BRNE mainloop
         RET

DelayOneMs:
         LDI R24, $99       
         LDI R25, $02
inloop:  
         SBIW R25:R24, 1  /*2 + 4*(R25:R24) + 7 = 4*(R25:R24) + 9*/
         BRCC inloop 
         RET