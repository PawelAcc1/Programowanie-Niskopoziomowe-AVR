      LDI R20, 10
loop: DEC R20
      BRNE loop 
      RJMP 0

/* 1 + 4*3 + 2 = 3 + 4*3 --> Cycles = (R20-1)*3 + 3 */