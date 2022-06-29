 #include <avr/io.h>
 #include <avr/delay.h>

 extern void show_display ();
 unsigned char *pr16 = 0x10;

 // global variables
 int adcValue = 0;
 int voltaje = 0;
 double voltajeA = 0;
 int a = 0;
 int b = 0;
 int c = 0;
 int d = 0;

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
			 voltaje = (((ADC+1)*10) * 5) / 1024;
			 adcValue = ((ADC+1) * 5) / 1024;
			 voltajeA =  ((ADC+1) * 5) % 100;
			 a = ((ADC+1) * 5) / 100;
			 b = voltaje % 1000 / 100;
			 c = voltaje % 100 / 10;
			 d = voltaje % 10;
			 ADCSRA |= 0x40;
		 }
		 *pr16=adcValue;
		  show_display();
	 }
 }

 
