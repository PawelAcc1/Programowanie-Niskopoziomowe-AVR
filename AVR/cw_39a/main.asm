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
.macro SET_SEGMENT ;@(TEMP_REGISTER), @(VALUE)
    PUSH @0
    LDI @0, @1
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

/***DIGIT REGISTERS***/
LDI R20, 9
MOV DIGIT_0, R20

LDI R20, 7
MOV DIGIT_1, R20

LDI R20, 4
MOV DIGIT_2, R20

LDI R20, 8
MOV DIGIT_3, R20

/***PORT DIRECTION CONTROL***/
DIR_REG_PORTX R20, $1E, B
DIR_REG_PORTX R20, $7F, D

/***SET VALUE OF DELAY***/
LOAD_CONST R17, R16, 5

main:
    /*0*/
    PUSH R16
    MOV R16, DIGIT_0
    RCALL DigitTo7segCode
    DISPLAY_DIGIT R16
    SET_SEGMENT R20, $02
    POP R16
    RCALL DelayInMs

    /*1*/
    PUSH R16
    MOV R16, DIGIT_1
    RCALL DigitTo7segCode
    DISPLAY_DIGIT R16
    SET_SEGMENT R20, $04
    POP R16
    RCALL DelayInMs

    /*2*/
    PUSH R16
    MOV R16, DIGIT_2
    RCALL DigitTo7segCode
    DISPLAY_DIGIT R16
	SET_SEGMENT R20, $08
    POP R16
	RCALL DelayInMs

    /*3*/
    PUSH R16
    MOV R16, DIGIT_3
    RCALL DigitTo7segCode
    DISPLAY_DIGIT R16
	SET_SEGMENT R20, $10
    POP R16
	RCALL DelayInMs

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
    BRCC inc_skip
    INC R31
inc_skip:
    LPM R16, Z

    POP R31
    POP R30
    RET

/*DIGITS CODE TABLE*/
digit_code:
    .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F