DigitToSquare:
    PUSH R30
    PUSH R31

    /*SET THE POINTER AT THE BEGINING OF TABLE*/
    LDI R31, HIGH(squares<<1)
    LDI R30, LOW(squares<<1)

    ADD R30, R16 
    BRCC inc_skip
    INC R31
inc_skip:
    LPM R16, Z

    POP R31
    POP R30
    RET

squares:
    .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81