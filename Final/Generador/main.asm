.ORG 0x0000
 jmp  setupADC
.ORG 0x002A
 jmp  convADC

.DSEG
 nums: .byte 512 ; defino espacio en memoria para almacenar 512 n�meros de un byte

.CSEG
convADC:
in r30, SREG ; guardo contexto
ldi r16, 0b01101111
sts ADCSRA, r16

cpi r31, 0x00 ; chequeo si la bandera est� en 0, entonces nunca fue le�da la seed

brne 2 ; si no es 0, ya le� una seed, salto al final de la interrupci�n (salteo dos l�neas)
lds r16, ADCL ; leo el byte inferior (0-255) para usarlo como seed
ldi r31, 0x01; levanto la bandera para no cambiar m�s la seed

out SREG, r30 ; recupero el contexto
reti

setupADC:
ldi  r16, 0b11101111
sts  ADCSRA, r16
 
ldi  r16, 0b01000000
sts  ADMUX, r16

ldi  r31, 0x00 ; uso como bandera para leer una sola seed para los n�meros random
ldi  r20, 0x00 ; valor para comparar cu�ndo salgo del bucle de generar n�meros

sei

setupPuntero:

start:
cpi r31, 0x00; mientras no haya le�do la seed, espero
breq start

ldi r18,low(511); cargo en este par de registros la cantidad de n�meros a generar
ldi r19,high(511)

ldi r17, 1 ; n�mero que voy a sumar para generar los n�meros aleatorios

bucleGenerador:
ldi r20, 0
ldi r18, LOW(nums)

loop1:
dec r18
ldi r19, HIGH(nums)
loop2:
dec r19
call  generaNumero
cpse r19, r20
rjmp Loop2
cpse r18, r20
rjmp Loop1

rjmp fin

generaNumero:
add r16, r16 ; lo agrego con s� mismo y guardo el m�dulo 255
rol r16 ; roto c�clicamente dos bit a la izquierda (multiplico por 2^2)
rol r16
adc r16, r17 ; sumo un valor constante
st X+, r16 ; guardo el n�mero generado en la direcci�n del puntero X e incremento el puntero
ret

fin:
rjmp fin