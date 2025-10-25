/*LABELS FOR PORT REEGISTERS*/
.equ DIGITS_P = 0x12 ; PORTD
.equ SEGMENTS_P	= 0x18 ; PORTB

/*NAME DEFINITIONS FOR DIGIT REGISTERS*/
.def DIGIT_0 = R2
.def DIGIT_1 = R3
.def DIGIT_2 = R4
.def DIGIT_3 = R5

/*SET DIRECTION FOR PORT*/
.macro DIR_REG_PORTX ;@(TEMP_REGISTER), @(REG_STATE), @PORT
    PUSH @0
    LDI @0, @1
    OUT DDR@2, @0
    POP @0
.endmacro 

/*SET DISPLAY SEGMENT*/
.macro SET_SEGMENT ;@(TEMP_REGISTER), @(SEGMENT_CODE_REGISTER)
    PUSH @0
    MOV @0, @1
    OUT SEGMENTS_P, @0
    POP @0 
.endmacro

/*SET DIGIT TO DIPLAY*/
.macro DISPLAY_DIGIT ;@(DIGIT_REGISTER), 
    OUT DIGITS_P, @0 
.endmacro

/*WRITE NUMBER OF MS FOR DelayInMs*/
.macro LOAD_CONST
    LDI @0, HIGH(@2)
    LDI @1, LOW(@2)
.endmacro

/*REFRESH DISPLAY*/
.macro SET_DIGIT
    PUSH R16
    MOV R16, DIGIT_@0
    RCALL DigitTo7segCode
    DISPLAY_DIGIT R16

    LDI R16, @0
    RCALL GetSegmentCode
    SET_SEGMENT R20, R16
    POP R16
    RCALL DelayInMs
.endmacro

/***SET VALUE OF DIGIT REGISTERS***/
LDI R20, 5
MOV DIGIT_0, R20

LDI R20, 3
MOV DIGIT_1, R20

LDI R20, 0
MOV DIGIT_2, R20

LDI R20, 6
MOV DIGIT_3, R20

/***PORT DIRECTION CONTROL***/
DIR_REG_PORTX R20, $1E, B
DIR_REG_PORTX R20, $7F, D

/***SET VALUE OF DELAY***/
LOAD_CONST R17, R16, 5

main:
    /*0*/
    SET_DIGIT 0

    /*1*/
    SET_DIGIT 1

    /*2*/
    SET_DIGIT 2

    /*3*/
    SET_DIGIT 3

    RJMP main

/***COUNT DELAY***/
DelayInMs:
         PUSH R25
         PUSH R24 
         MOV R24, R16
         MOV R25, R17
mainloop:
         PUSH R25
         PUSH R24																								
         RCALL DelayOneMs         
         POP R24
         POP R25
         SBIW R25:R24, 1
         BRNE mainloop
         POP R24
         POP R25
         RET

DelayOneMs:
         LDI R24, $C9    
         LDI R25, $07
inloop:  
         SBIW R25:R24, 1  
         BRCC inloop 
         RET

/***ENCODE 7 SEG DIGITS***/
DigitTo7segCode:
    PUSH R30
    PUSH R31

    /*SET THE POINTER AT THE BEGINING OF TABLE*/
    LDI R31, HIGH(digit_code<<1)
    LDI R30, LOW(digit_code<<1)

    ADD R30, R16 
    BRCC inc_skip1
    INC R31
inc_skip1:
    LPM R16, Z

    POP R31
    POP R30
    RET

/*DIGITS CODE TABLE*/
digit_code:
    .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F

/***DISPLAY SEGMENT CODE***/
GetSegmentCode:
    PUSH R30
    PUSH R31

    /*SET THE POINTER AT THE BEGINING OF TABLE*/
    LDI R31, HIGH(segment_code<<1)
    LDI R30, LOW(segment_code<<1)

    ADD R30, R16 
    BRCC inc_skip2
    INC R31
inc_skip2:
    LPM R16, Z

    POP R31
    POP R30
    RET
/*SEGMNET CODE TABLE*/
segment_code:
    .db $02, $04, $08, $10