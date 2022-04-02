#define __SFR_OFFSET 0
#include "avr/io.h"
.global main
main:
SetUp:
    sbi DDRB, 5 ; 1 cycle
    ldi r17, 0 ; 1 cycle
    
TurnLedsOn:
    cbi PORTB, 5 ; 1 cycle
    
DelayA: ; ((((4n-2)*m+(5m-2))*l)+5l-2) + 1
ldi r18, 100
LoopA0:
    ldi r19, 99
    LoopA1:
	ldi r20, 100
	LoopA2:
	    dec r20
	    cpse r20, r17
	    rjmp LoopA2
	dec r19
	cpse r19, r17
	rjmp LoopA1
    dec r18
    cpse r18, r17
    rjmp LoopA0
 
TurnLedsOff:
    sbi PORTB, 5 ; 1 cycle
 
Delay2: ; ((((4n-2)*m+(5m-2))*l)+5l-2) + 1
ldi r18, 100 ; 1 cycle
LoopB0: ; (((4n-2)*m+(5m-2))*l)+5l-2
    ldi r19, 99 ; 1 cycle
    LoopB1: ; (4n-2)*m+(5m-2)
	ldi r20, 100 ; 1 cycle
	LoopB2: ; 4n-2
	    dec r20 ; 1 cycle
	    cpse r20, r17 ; 1 cycle
	    rjmp LoopB2 ; 2 cycle
	dec r19 ; 1 cycle
	cpse r19, r17 ; 1 cycle
	rjmp LoopB1 ; 2 cycle
    dec r18 ; 1 cycle
    cpse r18, r17 ; 1 cycle
    rjmp LoopB0 ; 2 cycle
    
rjmp TurnLedsOn ; 2 cycle
