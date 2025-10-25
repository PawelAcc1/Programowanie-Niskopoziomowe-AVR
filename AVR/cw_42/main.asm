;*** Divide ***
/*PROGRAM PROCEEDS DIVISION OF TWO 16 BITS NUMBERS*/
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25

; inputs
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

/*DIVIDER SUBROUTINE*/
Divider:
    PUSH XL
    PUSH XH
    PUSH QCtrL
    PUSH QCtrH

    CLR QCtrL
    CLR QCtrH
loop:
;COMPARE DIVIDEND TO DIVISOR. DONE TILL YH:YL (DIVISOR) > XH:XL (DIVIDENT) => C=1
    CP XL, YL
    CPC XH, YH
    BRCS end
;IF TRUE SUBTRACT NUMBERS
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
    POP XH
    POP XL
    RET