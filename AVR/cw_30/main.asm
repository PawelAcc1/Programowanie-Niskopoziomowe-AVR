/*SET DIRECTION FOR PORT*/
.macro DIR_REG_PORTX ;@(TEMP_REGISTER), @(REG_STATE), @PORT
    PUSH @0
    LDI @0, @1
    OUT DDR@2, @0
    POP @0
.endmacro 

/*SET PORT VALUE*/
.macro STATE_REG_PORTX ;@(TEMP_REGISTER), @(REG_STATE), @PORT
    PUSH @0
    LDI @0, @1
    OUT PORT@2, @0
    POP @0 
.endmacro

/*WRITE NUMBER OF MS FOR DelayInMs*/
.macro LOAD_CONST
    LDI @0, HIGH(@2)
    LDI @1, LOW(@2)
.endmacro

DIR_REG_PORTX R20, $1E, B
DIR_REG_PORTX R20, $7F, D

STATE_REG_PORTX R20, $3F, D

LOAD_CONST R17, R16, 250

main:
    STATE_REG_PORTX R20, $02, B
    RCALL DelayInMs
    STATE_REG_PORTX R20, $04, B
    RCALL DelayInMs
	STATE_REG_PORTX R20, $08, B
	RCALL DelayInMs
	STATE_REG_PORTX R20, $10, B
	RCALL DelayInMs
    RJMP main

DelayInMs: 
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
         RET

DelayOneMs:
         LDI R24, $CA    
         LDI R25, $07
inloop:  
         SBIW R25:R24, 1  
         BRCC inloop 
         RET