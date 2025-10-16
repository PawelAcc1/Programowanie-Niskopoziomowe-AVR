      LDI R20, 10
loop: DEC R20
      NOP
      NOP
      BRNE loop
      RJMP 0

/* 1 + 4*5 + 2 + 2 = 5 + 4*5 --> Cycles = (R20-1)*5 + 5 = 5*R20 */


