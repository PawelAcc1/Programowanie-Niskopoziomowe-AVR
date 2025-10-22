/*ENCODE 7 SEG DIGITS*/
DigitTo7segCode:
    PUSH R30
    PUSH R31

    /*SET THE POINTER AT THE BEGINING OF TABLE*/
    LDI R31, HIGH(digit_code<<1)
    LDI R30, LOW(digit_code<<1)

    ADD R30, R16 
    BRCC inc_skip
    INC R31
inc_skip:
    LPM R16, Z

    POP R31
    POP R30
    RET

/*DIGITS CODE TABLE*/
digit_code:
    .db $3F, $06, $5B, $4F, $66, $6D, $7D, $03, $7F, $6F