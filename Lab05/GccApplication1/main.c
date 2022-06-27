 #include <avr/io.h>
 #include <avr/delay.h>

 extern void show_display ();
 unsigned char *pr16 = 0x10;

 // global variables
 int adcValue = 0;

 int ADC_O_1;
 int ADC_O_2;

 void ADC_init(void)
 {
	 ADMUX = 0x40;
	 ADCSRA = 0xC7;
	 ADCSRB = 0x00;
 }
 
 void display_init(void)
 {
	DDRB = 0x01;
	PORTB = 0b00111101;
	DDRD = 0b10010000;
	PORTD &= (0<PORTD4) & (0<PORTD7); 
 }

 int main(void){
	 ADC_init();
	 display_init();
	 while (1)
	 {
		 if ( (ADCSRA & 0x40) == 0)
		 {
			 adcValue = (ADC * 5) / 1024;
			 ADCSRA |= 0x40;
		 }
		 *pr16=adcValue;
		  show_display();
	 }
 }

 
