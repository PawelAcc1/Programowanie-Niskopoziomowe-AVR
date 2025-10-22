MainLoop:
rcall DelayNCycles ;
rjmp MainLoop
DelayNCycles: ;zwyk³a etykieta
nop
nop
rcall function1
nop
ret ;powrót do miejsca wywo³ania

function1:
nop
nop
ret