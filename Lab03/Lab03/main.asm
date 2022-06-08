.ORG 0x0000
jmp start		; start direction (reset vector)
.ORG 0x0008		
jmp	button_int  ; button interruption
.ORG 0x001C
jmp _tmr0_int ; timer interruption

start:
; set leds output
ldi R16,0b00111100
out DDRB,R16

; turn leds
ldi R16,0b00000000
out PORTB,R16  

; counter var
ldi R23, 100

; set counter to OCR0A and back to 0, here makes interruption
ldi R16, 0b00000010
out TCCR0A, R16

; set TCCR0B
ldi R16, 0b00000101
out TCCR0B, R16 

; compare to 125
ldi R16, 125
out OCR0A, R16
ldi R16, 0b00000010 
sts TIMSK0, R16   

ldi R17,0b00000000
out DDRC,R17

ldi	R17, 0b00000010
sts PCICR, R17
ldi	R18, 0b00000110
sts	PCMSK1,	R18	

; stop secs check
ldi R25, 0b00000000
; stop comparator
ldi R26, 0b00000000
; comparator mask
ldi R18,0b11111111
; enable interruptions    

;second counter
ldi r19, 0

sei   
                     
main:
nop              
rjmp main              


_tmr0_int:
; save context
in R20,SREG
cpse R25, R26
dec R23          
brne _tmr0_out  
rjmp toggle_leds       
_tmr0_out:
; return context
out SREG,R20    
reti

toggle_leds:
cpse R25, R26
inc r19
EOR R16,R18            
out PORTB,R16
ldi R23, 100
out SREG,R20
reti

button_int:
in R21,SREG 
SBIS PINC, 1
rjmp  button1
sbis pinc,2
rjmp button2
out SREG,R21
reti

button1:
EOR R25, R18
out SREG,R21
reti

button2:
ldi r19, 0
out SREG,R21
reti