#define __SFR_OFFSET 0
#include "avr/io.h"
.global main
main:
setOutputs:
    sbi DDRB, 5
    sbi DDRB, 4
    sbi DDRB, 3
    sbi DDRB, 2
setLedsOn:
    cbi PORTB, 5
    cbi PORTB, 4
    cbi PORTB, 3
    cbi PORTB, 2   
turnLedsOff:
    sbi PORTB, 5
    sbi PORTB, 4
    sbi PORTB, 3
    sbi PORTB, 2
    rjmp setLedsOn
