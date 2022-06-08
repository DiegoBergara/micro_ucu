; Registers
; R16 - sec counter
; r17 - dec sec counter
; R18 - min counter
; R19 - dec min counter
; R20 - context save timer int
; R21 - none
; R22 - display redirect
; R23 - interruptions to one sec
; R24 - none
; R25 - set 0xFF when button pressed
; R26 - display
; R27 - display
; R28 - display
; R29 - none
; R30 - none
; R31 - none

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

.ORG 0x0000
jmp start		; start direction (reset vector)
.ORG 0x0008
jmp	button_int  ; button interruption address
.ORG 0x001C
jmp _tmr0_int ; timer interruption address

start:
	; set leds output
	ldi R16, 0b00111101
	out DDRB, R16

	; turn leds
	ldi R16, 255
	out PORTB, R16  

	; counter var
	ldi R23, 200

	; set counter to OCR0A and back to 0, here makes interruption
	ldi R16, 0b00000010
	out TCCR0A, R16

	; set TCCR0B
	ldi R16, 0b00000101
	out TCCR0B, R16 

	; compare to 125
	ldi R16, 62
	out OCR0A, R16
	ldi R16, 0b00000010 
	sts TIMSK0, R16   

	ldi r16, 0b00000000
	out DDRC, r16

	ldi	r16, 0b00000010
	sts PCICR, r16
	ldi	r16, 0b00000110
	sts	PCMSK1,	r16	

	; stop secs check
	ldi R25, 0b00000000
	;second counter
	ldi r19, 0

	sei   

	ldi	r16, 0b00000000	
	out	DDRC, r16			;3 botones del shield son entradas
	ldi	r16, 0b10010000
	out	DDRD, r16			;configuro PD.4 y PD.7 como salidas
	cbi	PORTD, 7			;PD.7 a 0, es el reloj serial, inicializo a 0
	cbi	PORTD, 4			;PD.4 a 0, es el reloj del latch, inicializo a 0

	ldi R16, 0b00000000

	ldi r22, 0

	ldi r16, 0
	ldi r17, 0
	ldi r18, 0
	ldi r19, 0
                     
main:
	nop              
	rjmp main              


_tmr0_int:
	; save context
	in R20,	SREG
	call showInDisplay
	; stop comparator
	ldi R26, 0b00000000
	cpse R25, R26
	dec R23          
	brne _tmr0_out  
	call toggle_leds       
	_tmr0_out:
	; return context
	out SREG, R20    
	reti

toggle_leds:
	cpse R25, R26
	call add_seconds
	ret

button_int:
	in R20,	 SREG
	SBIS PINC, 1
	rjmp  button1
	sbis PINC, 2
	rjmp button2
	out SREG, R20
	reti

button1:
	; comparator mask
	ldi R24, 0b11111111
	EOR R25, R24
	out SREG, R20
	reti

button2:
	ldi r16, 0
	ldi r17, 0
	ldi r18, 0
	ldi r19, 0
	out SREG,	R20
	reti

sacanum: 
	call dato_serie
	mov	r26, r27
	call dato_serie
	sbi	PORTD, 4		;PD.4 a 1, es LCH el reloj del latch
	cbi	PORTD, 4		;PD.4 a 0, 
	ret
	;Voy a sacar un byte por el 7seg
dato_serie:
	ldi	r28, 0x08 ; lo utilizo para contar 8 (8 bits)
loop_dato1:
	cbi	PORTD, 7		;SCLK = 0 reloj en 0
	lsr	r26				;roto a la derecha r26 y el bit 0 se pone en el C
	brcs loop_dato2		;salta si C=1
	cbi	PORTB, 0		;SD = 0 escribo un 0 
	rjmp loop_dato3
loop_dato2:
	sbi	PORTB, 0		;SD = 1 escribo un 1
loop_dato3:
	sbi	PORTD, 7		;SCLK = 1 reloj en 1
	dec	r28
	brne loop_dato1; cuando r27 llega a 0 corta y vuelve
	ret

translate_num:
	cpi r26, 0
	breq translate_0
	cpi r26, 1
	breq translate_1
	cpi r26, 2
	breq translate_2
	cpi r26, 3
	breq translate_3
	cpi r26, 4
	breq translate_4
	cpi r26, 5
	breq translate_5
	cpi r26, 6
	breq translate_6
	cpi r26, 7
	breq translate_7
	cpi r26, 8
	breq translate_8
	cpi r26, 9
	breq translate_9
	ret

translate_0:
	ldi r26, ZERO
	ret

translate_1:
	ldi r26, ONE
	ret

translate_2:
	ldi r26, TWO
	ret

translate_3:
	ldi r26, THREE
	ret

translate_4:
	ldi r26, FOUR
	ret

translate_5:
	ldi r26, FIVE
	ret

translate_6:
	ldi r26, SIX
	ret

translate_7:
	ldi r26, SEVEN
	ret

translate_8:
	ldi r26, EIGHT
	ret

translate_9:
	ldi r26, NINE
	ret

showInDisplay:
	inc R22
	cpi R22, 1
	breq num1
	cpi R22, 2
	breq num2
	cpi R22, 3
	breq num3
	cpi R22, 4
	breq num4
	ret

num1:
	mov r26, r16 ;asigno a r26 el numero de salida
	call translate_num
	ldi r27, DIS_A ; asigno a r27 el segmento de salida
	call sacanum
	ret

num2:
	mov r26, r17 ;asigno a r26 el numero de salida
	call translate_num
	ldi r27, DIS_B ; asigno a r27 el segmento de salida
	call sacanum
	ret
num3:
	mov r26, r18 ;asigno a r26 el numero de salida
	call translate_num
	ldi r27, DIS_C ; asigno a r27 el segmento de salida
	call sacanum
	ret
num4:
	ldi r22, 0
	mov r26, r19 ;asigno a r26 el numero de salida
	call translate_num
	ldi r27, DIS_D ; asigno a r27 el segmento de salida
	call sacanum
	ret

add_seconds:
	ldi r23, 200
	inc r16
	cpi r16, 10
	breq add_dec_sec 
	ret

add_dec_sec:
	ldi r16, 0 
	inc r17
	cpi r17, 6
	breq add_min
	ret

add_min:
	ldi r17, 0
	inc r18
	cpi r18, 10
	breq add_dec_min
	ret

add_dec_min:
	ldi r18, 0
	inc r19
	cpi r19, 6
	breq clear_clock
	ret

clear_clock:
	ldi r16, 0
	ldi r17, 0
	ldi r18, 0
	ldi r19, 0
	ret
	