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
    
delay:
    ldi r17, 0
    ldi r18, 255
    ldi r19, 255
    ldi r20, 255
    ldi r21, 255
L1: 
    dec r21
    cpse r21, r17
    brne L1
    cpse r20, r17
    dec r20
    cpse r20, r17
    brne L1
    cpse r19, r17
    dec r19
    cpse r19, r17
    brne L1
    cpse r18, r17
    dec r18
    cpse r18, r17
    brne L1 
    
turnLedsOff:
    sbi PORTB, 5
    sbi PORTB, 4
    sbi PORTB, 3
    sbi PORTB, 2
    
delay2:
    ldi r17, 0
    ldi r18, 255
    ldi r19, 255
    ldi r20, 255
    ldi r21, 255
L2: 
    cpse r21, r17
    dec r21
    cpse r21, r17
    brne L2
    cpse r20, r17
    dec r20
    cpse r20, r17
    brne L2
    cpse r19, r17
    dec r19
    cpse r19, r17
    brne L2
    cpse r18, r17
    dec r18
    cpse r18, r17
    brne L2
    
    rjmp setLedsOn
