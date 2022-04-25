#define __SFR_OFFSET 0
#include "avr/io.h"
.global main

.ORG 0x0000
jmp main
.ORG 0x001C
jmp _tmr0_int    

main:
ldi r16, 0b00111101
out DDRB, r16
out PORTB, r16
ldi r16, 0b00000000
out DDRC, r16
    
ldi r16, 0b00000010
out TCCR0A, r16
ldi r16, 0b00000101
out TCCR0B, r16
ldi r16, 124
out OCR0A, r16
ldi r16, 0b00000010
sts TIMSK0, r16

ldi r24, 0x00

comienzo:
sei
    
loop1:
nop
nop
nop
nop
ori r16, 0xFF
nop
nop
nop
brne loop1
    
loop2:
nop
nop
nop
    
fin:
rjmp loop2

_tmr0_int:
sbi PINB, 2
inc r24
    
_tmr0_out:
reti