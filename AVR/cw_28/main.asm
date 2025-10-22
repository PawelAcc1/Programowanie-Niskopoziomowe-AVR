/*SET DIRECTION FOR PORT*/
.macro DIR_REG_PORTB ;@(TEMP_REGISTER), @(REG_STATE), @PORT
    LDI @0, @1
    OUT DDR@2, @0
.endmacro 

DIR_REG_PORTB R18, 30, B
loop:
    LDI R19, 30
    OUT PORTB, R19
    CLR R19
    OUT PORTB, R19
    RJMP loop
    
