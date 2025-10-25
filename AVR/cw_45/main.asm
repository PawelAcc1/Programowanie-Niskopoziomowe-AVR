.cseg ; segment pamiêci kodu programu

.org 0 rjmp main ; skok po resecie (do programu g³ównego)
.org OC1Aaddr rjmp _timer_isr ; skok do obs³ugi przerwania timera

_timer_isr: ; procedura obs³ugi przerwania timera

    inc R10 ; jakiœ kod
    reti ; powrót z procedury obs³ugi przerwania (reti zamiast ret)

/*LABELS FOR PORT REGISTERS*/
.equ DIGITS_P = 0x12 ; PORTD
.equ SEGMENTS_P	= 0x18 ; PORTB

///////////////////////////////////////////////////////////
/*                     DEFINITIONS                       */
///////////////////////////////////////////////////////////
/*DEFINITIONS FOR DIGIT REGISTERS*/
.def DIGIT_0 = R2
.def DIGIT_1 = R3
.def DIGIT_2 = R4
.def DIGIT_3 = R5

/*DEFINITIONS FOR NumberToDigits*/
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

/*DEFINITIONS FOR Divider SUBROUTINE*/
.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divisor
.def YH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25

/*DEFINITIONS FOR 16 BITS DECADE COUNTER*/
.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

/*DEFINITION FOR 16 BIST DECADE COUNTER COMPARE REGISTER R9:R8*/
.def DecCounterCompL=R8
.def DecCounterCompH=R9

/*DEFINITIONS OF AUXILIARY REGISTER TO INCREMENT DECADE COUNTER*/
.def DecIncrementAuxReg1=R6 ;VALUE OF INCREMENTATION (1)
.def DecIncrementAuxReg2=R7 ;=0 FOR SELF ADDITION

///////////////////////////////////////////////////////////
/*                     MACROS                            */
///////////////////////////////////////////////////////////
/*SET DIRECTION FOR PORT*/
.macro DIR_REG_PORTX ;@(TEMP_REGISTER), @(REG_STATE), @PORT
    PUSH @0
    LDI @0, @1
    OUT DDR@2, @0
    POP @0
.endmacro 

/*SET DISPLAY SEGMENT   */
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

///////////////////////////////////////////////////////////
/*                     MAIN PROGRAM                      */
///////////////////////////////////////////////////////////
main:
/***SET VALUE OF DIGIT REGISTERS***/
LDI R20, 0
MOV DIGIT_0, R20

LDI R20, 0
MOV DIGIT_1, R20

LDI R20, 0
MOV DIGIT_2, R20

LDI R20, 0
MOV DIGIT_3, R20

/***PORT DIRECTION CONTROL***/
DIR_REG_PORTX R20, $1E, B
DIR_REG_PORTX R20, $7F, D

/***SET VALUE OF DELAY***/
LOAD_CONST R17, R16, 2

;TEMP REGISTERS FOR INCREMENTING DECADE COUNTER
LDI R20, 1
MOV DecIncrementAuxReg1, R20 
LDI R20, 0
MOV DecIncrementAuxReg2, R20

;TEMP REGISTERS TO COMPARE DECADE COUNTER WITH
LDI R20, LOW(1000)
MOV DecCounterCompL, R20
LDI R20, HIGH(1000)
MOV DecCounterCompH, R20

mainloop:
    /*0*/
    SET_DIGIT 0

    /*1*/
    SET_DIGIT 1

    /*2*/
    SET_DIGIT 2

    /*3*/
    SET_DIGIT 3

    /*MOD 1000 COUNTER*/
    ADD PulseEdgeCtrL, DecIncrementAuxReg1
    ADC PulseEdgeCtrH, DecIncrementAuxReg2
    
    CP PulseEdgeCtrL, DecCounterCompL
    CPC PulseEdgeCtrH, DecCounterCompH
    BRNE update_display
    CLR PulseEdgeCtrL
    CLR PulseEdgeCtrH

update_display:
    PUSH R16
    PUSH R17
    MOV R16, PulseEdgeCtrL
    MOV R17, PulseEdgeCtrH
    RCALL NumberToDigits
    POP R17
    POP R16 

    ;COPY RESULT OF EXTRACTING DIGITS TO DISPLAY REGISTERS
    MOV DIGIT_0, Dig0
    MOV DIGIT_1, Dig1
    MOV DIGIT_2, Dig2
    MOV DIGIT_3, Dig3

    RJMP mainloop
///////////////////////////////////////////////////////////
/*                     SUBROUTINES                       */
///////////////////////////////////////////////////////////
/***COUNT DELAY***/
DelayInMs:
         PUSH R25
         PUSH R24 
         MOV R24, R16
         MOV R25, R17
delayloop:
         PUSH R25
         PUSH R24																								
         RCALL DelayOneMs         
         POP R24
         POP R25
         SBIW R25:R24, 1
         BRNE delayloop
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

/***EXTRACT DIGITS FROM NUMBER ROUTINE***/
NumberToDigits:
;LOAD DIVISOR FOR NUMBER OF THOUSANDS
    LDI R18, LOW(1000)
    LDI R19, HIGH(1000)
;DIVIDER SUBROUTINE CALL FOR EXTRACT NUMBER OF THOUSANDS
    RCALL Divider
    MOV Dig3, QL

;SAME ROUTINE FOR HOUNDREDS...
    LDI R18, LOW(100)
    LDI R19, HIGH(100)

    RCALL Divider
    MOV Dig2, QL

;SAME ROUTINE FOR TENS...
    LDI R18, LOW(10)
    LDI R19, HIGH(10)

    RCALL Divider
    MOV Dig1, QL

;COPY UNITS TO Dig0
    MOV Dig0, RL
    RET

/***DIVIDER SUBROUTINE***/
Divider:
    PUSH QCtrL
    PUSH QCtrH
;WRITE INITIAL VALUE (0) TO TEMPORARY QUOTATION REGISTERS
    CLR QCtrL
    CLR QCtrH
loop:
;COMPARE DIVIDEND TO DIVISOR. DONE TILL YH:YL (DIVISOR) > XH:XL (DIVIDENT) => C=1
    CP XL, YL
    CPC XH, YH
    BRCS end
;IF FALSE (C=0) SUBTRACT NUMBERS
    SUB XL, YL
    SBC XH, YH
;INCREMENT INTERNAL COUNTER RESPONSIBLE FOR QUOTIENT
    ADIW QCtrH:QCtrL, 1
    RJMP loop

end:
;COPY QUOTIENT FROM INTERNAL COUNTER(R25:R24)
    MOV QL, QCtrL
    MOV QH, QCtrH

    POP QCtrH
    POP QCtrL
    RET