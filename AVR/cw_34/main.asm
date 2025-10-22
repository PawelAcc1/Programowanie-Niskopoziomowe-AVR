.equ DIGITS_P = 0x12 ; PORTD
.equ SEGMENTS_P	= 0x18 ; PORTB

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

/*DIGITS REGISTERS*/
LDI R20, $3F
MOV R2, R20
LDI R20, $06
MOV R3, R20
LDI R20, $5B
MOV R4, R20
LDI R20, $4F
MOV R5, R20 

DIR_REG_PORTX R20, $1E, B
DIR_REG_PORTX R20, $7F, D

DISPLAY_DIGIT R20, $3F

/*SET VALUE OF DELAY*/
LOAD_CONST R17, R16, 5

main:
    /*0*/
    DISPLAY_DIGIT R2
    SET_SEGMENT R20, $02
    RCALL DelayInMs

    /*1*/
    DISPLAY_DIGIT R3
    SET_SEGMENT R20, $04
    RCALL DelayInMs

    /*2*/
    DISPLAY_DIGIT R4
	SET_SEGMENT R20, $08
	RCALL DelayInMs

    /*3*/
    DISPLAY_DIGIT R5
	SET_SEGMENT R20, $10
	RCALL DelayInMs

    RJMP main

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