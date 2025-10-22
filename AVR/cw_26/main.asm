         LDI R23, 5
         RCALL DelayInMs
         NOP

DelayInMs: 
mainloop:
         LDI R24, $99       /*4 + (6 + 3 + [12*(R25:R24) + 15] + 1 + 2)*(R23-1) + (6 + 3 + [12*(R25:R24) + 15] + 1 + 4 = 6 + (27 + 12*(R25:R24)) * R23 */
         LDI R25, $02																								/**/
         STS $60, R24
         STS $61, R25
         RCALL DelayOneMs
         DEC R23
         BRNE mainloop
         RET

DelayOneMs:
inloop:  
         LDS R24, $60         /*x = 12*(R25:R24) + 15*/
         LDS R25, $61
         SBIW R25:R24, 1
         STS $60, R24
         STS $61, R25
         BRCC inloop 
         RET