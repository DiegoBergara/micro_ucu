
.global show_display;
.section .text     
#define __SFR_OFFSET 0
#include "avr/io.h"
//.include "./m328Pdef.inc"
; Constants
; Nums
#define EMPTY	0b11111111
#define ZERO	0b00000011
#define ONE		0b10011111
#define TWO		0b00100101
#define THREE	0b00001101
#define FOUR	0b10011001
#define FIVE	0b01001001
#define SIX		0b01000001
#define SEVEN	0b00011111
#define EIGHT	0b00000001
#define NINE	0b00001001
; Displays
#define DIS_A	0b00010000
#define DIS_B	0b00100000
#define DIS_C	0b01000000
#define DIS_D	0b10000000
//start: 
//	ldi r17,0xFF; cargo valor para delay0
//	ldi r18,0xFF; cargo valor para delay1
//	ldi r19,0x05; cargo valor para delay2
show_display:

call translate_num
ldi r17, DIS_A ; asigno a r17 el segmento de salida
call sacanum
ret

sacanum: 
	call dato_serie
	mov	r16, r17
	call dato_serie
	sbi	PORTD, 4		;PD.4 a 1, es LCH el reloj del latch
	cbi	PORTD, 4		;PD.4 a 0, 
	ret
	;Voy a sacar un byte por el 7seg
dato_serie:
	ldi	r18, 0x08 ; lo utilizo para contar 8 (8 bits)
loop_dato1:
	cbi	PORTD, 7		;SCLK = 0 reloj en 0
	lsr	r16				;roto a la derecha r16 y el bit 0 se pone en el C
	brcs loop_dato2		;salta si C=1
	cbi	PORTB, 0		;SD = 0 escribo un 0 
	rjmp loop_dato3
loop_dato2:
	sbi	PORTB, 0		;SD = 1 escribo un 1
loop_dato3:
	sbi	PORTD, 7		;SCLK = 1 reloj en 1
	dec	r18
	brne loop_dato1; cuando r17 llega a 0 corta y vuelve
	ret

translate_num:
	cpi 16, 0
	breq translate_0
	cpi r16, 1
	breq translate_1
	cpi r16, 2
	breq translate_2
	cpi r16, 3
	breq translate_3
	cpi r16, 4
	breq translate_4
	cpi r16, 5
	breq translate_5
	cpi r16, 6
	breq translate_6
	cpi r16, 7
	breq translate_7
	cpi r16, 8
	breq translate_8
	cpi r16, 9
	breq translate_9
	ret

translate_0:
	ldi r16, ZERO
	ret

translate_1:
	ldi r16, ONE
	ret

translate_2:
	ldi r16, TWO
	ret

translate_3:
	ldi r16, THREE
	ret

translate_4:
	ldi r16, FOUR
	ret

translate_5:
	ldi r16, FIVE
	ret

translate_6:
	ldi r16, SIX
	ret

translate_7:
	ldi r16, SEVEN
	ret

translate_8:
	ldi r16, EIGHT
	ret

translate_9:
	ldi r16, NINE
	ret