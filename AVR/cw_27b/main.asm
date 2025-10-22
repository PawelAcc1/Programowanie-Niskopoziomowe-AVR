         LDI R24, LOW(7)
         LDI R25, HIGH(7)
         MOV R16, R24
         MOV R17, R25
         RCALL DelayInMs
         NOP

DelayInMs: 
         MOV R24, R16
         MOV R25, R17
mainloop:																								
         RCALL DelayOneMs         /*4 + (2+(4+(4*(R25:R24) + 9)+4+2+2)*(R17:R16-1) + 2*/
         SBIW R25:R24, 1
         BRNE mainloop
         RET

DelayOneMs:
         PUSH R25
         PUSH R24
         LDI R24, $CA    
         LDI R25, $07
inloop:  
         SBIW R25:R24, 1  /*2 + 4*(R25:R24) + 7 = 4*(R25:R24) + 9*/
         BRCC inloop
         POP R24
         POP R25 
         RET