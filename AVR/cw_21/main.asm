MainLoop:
rcall DelayNCycles ;
rjmp MainLoop
DelayNCycles: ;zwyk�a etykieta
nop
nop
rcall function1
nop
ret ;powr�t do miejsca wywo�ania

function1:
nop
nop
ret