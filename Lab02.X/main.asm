#define __SFR_OFFSET 0
#include "avr/io.h"
.global main
main:
setOutputs:
    sbi DDRB, 5
    ldi r17, 0
setLedsOn:
    cbi PORTB, 5
    
Delay:
ldi r18, 255
Loop0:
    ldi r19, 255
    Loop1:
	ldi r20, 255
	Loop2:
	    dec r20
	    cpse r20, r17
	    brne Loop2
	dec r19
	brne Loop1
    dec r18
    brne Loop0
    
turnLedsOff:
    sbi PORTB, 5
    rjmp setLedsOn
