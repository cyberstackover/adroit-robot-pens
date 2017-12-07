
#pragma used+
sfrb PINF=0;
sfrb PINE=1;
sfrb DDRE=2;
sfrb PORTE=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRR0L=9;
sfrb UCSR0B=0xa;
sfrb UCSR0A=0xb;
sfrb UDR0=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb SFIOR=0x20;
sfrb WDTCR=0x21;
sfrb OCDR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb ASSR=0x30;
sfrb OCR0=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x36;
sfrb TIMSK=0x37;
sfrb EIFR=0x38;
sfrb EIMSK=0x39;
sfrb EICRB=0x3a;
sfrb RAMPZ=0x3b;
sfrb XDIV=0x3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

extern void I2C_Init(void);

extern void I2C_Stop(void);

extern unsigned char I2C_Start(unsigned char address);

#pragma used+
extern unsigned char I2C_Rep_Start(unsigned char address);
#pragma used-

#pragma used+
extern void I2C_Start_Wait(unsigned char address);
#pragma used-

extern unsigned char I2C_Write(unsigned char data);

extern unsigned char I2C_ReadAck(void);

extern unsigned char I2C_ReadNak(void);

void I2C_Init(void)
{

(*(unsigned char *) 0x71) = 0;                         
(*(unsigned char *) 0x70) = (((unsigned long) 16000000          /(unsigned long) 200000      )-16)/2;  
}

unsigned char I2C_Start(unsigned char address)
{   unsigned char   twst;

(*(unsigned char *) 0x74) = (1<<7) | (1<<5) | (1<<2);

while(!((*(unsigned char *) 0x74) & (1<<7)));

twst = ((*(unsigned char *) 0x71) & 0B11111000 ) & 0xF8;
if ( (twst != 0x08) && (twst != 0x10)) return 1;

(*(unsigned char *) 0x73) = address;
(*(unsigned char *) 0x74) = (1<<7) | (1<<2);

while(!((*(unsigned char *) 0x74) & (1<<7)));

twst = ((*(unsigned char *) 0x71) & 0B11111000 ) & 0xF8;
if ( (twst != 0x18) && (twst != 0x40) ) return 1;
return 0;
}

#pragma used+

void I2C_Start_Wait(unsigned char address)
{
unsigned char   twst;
while ( 1 )
{  
(*(unsigned char *) 0x74) = (1<<7) | (1<<5) | (1<<2);

while(!((*(unsigned char *) 0x74) & (1<<7)));

twst = ((*(unsigned char *) 0x71) & 0B11111000 ) & 0xF8;
if ( (twst != 0x08) && (twst != 0x10)) continue;

(*(unsigned char *) 0x73) = address;
(*(unsigned char *) 0x74) = (1<<7) | (1<<2);

while(!((*(unsigned char *) 0x74) & (1<<7)));

twst = ((*(unsigned char *) 0x71) & 0B11111000 ) & 0xF8;
if ( (twst == 0x20 )||(twst ==0x58) ) 
{           

(*(unsigned char *) 0x74) = (1<<7) | (1<<2) | (1<<4);

while((*(unsigned char *) 0x74) & (1<<4));
continue;
}

break;
}
}
#pragma used-

#pragma used+

unsigned char I2C_Rep_Start(unsigned char address)
{
return I2C_Start( address );
}
#pragma used-

void I2C_Stop(void)
{

(*(unsigned char *) 0x74) = (1<<7) | (1<<2) | (1<<4);

while((*(unsigned char *) 0x74) & (1<<4));
}

unsigned char I2C_Write( unsigned char data )
{       
unsigned char   twst;

(*(unsigned char *) 0x73) = data;
(*(unsigned char *) 0x74) = (1<<7) | (1<<2);

while(!((*(unsigned char *) 0x74) & (1<<7)));

twst = ((*(unsigned char *) 0x71) & 0B11111000 ) & 0xF8;
if( twst != 0x28) return 1;
return 0;

}

unsigned char I2C_ReadAck(void)
{
(*(unsigned char *) 0x74) = (1<<7) | (1<<2) | (1<<6);
while(!((*(unsigned char *) 0x74) & (1<<7)));    

return (*(unsigned char *) 0x73);

}

unsigned char I2C_ReadNak(void)
{
(*(unsigned char *) 0x74) = (1<<7) | (1<<2);
while(!((*(unsigned char *) 0x74) & (1<<7)));

return (*(unsigned char *) 0x73);

}

