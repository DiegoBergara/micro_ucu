#define __SFR_OFFSET 0
#include "avr/io.h"
.global main
main:
SetUp:
    sbi DDRB, 5
    sbi DDRB, 4
    sbi DDRB, 3
    sbi DDRB, 2
    ;sbi DDRD, 3
    ldi r17, 0
    
TurnLedsOn:
    cbi PORTB, 5 
    ;cbi PORTD, 3
    call Delay
 
TurnLedsOff:
    sbi PORTB, 5 
    ;sbi PORTD, 3 
    call Delay
   
cbi PORTB, 4
call Delay
sbi PORTB, 4
call Delay

cbi PORTB, 3
call Delay
sbi PORTB, 3
call Delay
    
cbi PORTB, 2
call Delay
sbi PORTB, 2
call Delay

cbi PORTB, 3
call Delay
sbi PORTB, 3
call Delay
    
cbi PORTB, 4
call Delay
sbi PORTB, 4
call Delay
    
rjmp TurnLedsOn ; 2 cycle

Delay: ; ((((4n-2)*m+(5m-2))*l)+5l-2) + 1
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
ret