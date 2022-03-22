#define __SFR_OFFSET 0
#define TURNLED 0
#include "avr/io.h"
.global main
main:
   
    sbi DDRB, 5
    cbi PORTB, 5
    sbi DDRB, 4
    cbi PORTB, 4
    sbi DDRB, 3
    cbi PORTB, 3
    sbi DDRB, 2
    cbi PORTB, 2
    rjmp main