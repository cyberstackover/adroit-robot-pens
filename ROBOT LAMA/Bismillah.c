/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/28/2014
Author  : tyery08
Company : embeeminded.blogspot.com
Comments: 


Chip type               : ATmega128A
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128a.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

#define buzzer  PORTE.2

#define motor1_en   PORTB.2  //A /G1
#define motor1_dir  PORTB.3  //B /A1
#define motor1_pwm  OCR0     //C /B1
#define motor2_en   PORTB.5  //D /G2
#define motor2_dir  PORTB.6  //E /A2
#define motor2_pwm  OCR2     //F /B2

#define sensor_en   PORTF.6
  
#define echo1 PIND.0
#define trig1 PORTD.1
#define echo2 PIND.2
#define trig2 PORTD.3
#define echo3 PIND.4
#define trig3 PORTD.5
#define echo4 PIND.6
#define trig4 PORTD.7

#define timer1  TCCR1B
#define timer1_ON    0x02
#define timer1_OFF   0x00

#define timer3  TCCR3B
#define timer3_ON    0x05
#define timer3_OFF   0x00

#define  servo1state PORTA.3
#define  servo2state PORTA.4
#define  servo3state PORTA.5
#define  servo4state PORTA.6

#define  lcdbl PORTA.7

//====================================//
#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 16
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Timer1 overflow interrupt service routine
unsigned char countxx,servo1,servo2;
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H=0xFFF0 >> 8;
    TCNT1L=0xFFF0 & 0xff;
    
    if (countxx<servo1){servo1state=1;}
    else {servo1state=0;}
    if (countxx<servo2){servo2state=1;}
    else {servo2state=0;}
    
    countxx++;
}

int IRQ6,IRQ7;
// External Interrupt 6 service routine
interrupt [EXT_INT6] void ext_int6_isr(void)
{
    IRQ6++;    
}

// External Interrupt 7 service routine
interrupt [EXT_INT7] void ext_int7_isr(void)
{
    IRQ7++;
}

int freq6,freq7,detik_count;
// Timer3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
// Reinitialize Timer3 value
TCNT3H=0xD23A >> 8;
TCNT3L=0xD23A & 0xff;
// Place your code here

    freq6=IRQ6;
    freq7=IRQ7;
    
    IRQ6=0;IRQ7=0;
    detik_count++;
}

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

unsigned count,timeout,us1,us2,us3,us;
void scan_kanan()
{
    trig1=1; delay_us(5);trig1=0;delay_us(5);trig1=1;
    timeout=0;
    while(!echo1&&timeout<=2000){timeout++;}
    count=0;
    while (echo1&&count<=8850){count++;}
    us=count/59;
    us=us1;    
}

void scan_kiri()
{    
    trig3=1; delay_us(5);trig3=0;delay_us(5);trig3=1;
    timeout=0;
    while(!echo3&&timeout<=2000){timeout++;}
    count=0;
    while (echo3&&count<=8850){count++;}
    us3=count/59;
    us=us3;        
}

// Declare your global variables here
unsigned char a,b,c,lcd_buff[16];
unsigned char sel[8]={0b000,0b001,0b010,0b011,0b100,0b101,0b110,0b111};
unsigned char sen_cal=50;

unsigned char notasi_bebas[5],notasi_buzzer[4],notasi_lcd[17],notasi_gripper[2],notasi_garis[4],notasi_obyek[5],notasi_delay[1];
unsigned char temp_char[3],xstring[16];
unsigned char i,j,k;
unsigned char flag_aksi,buzzer_state;

eeprom unsigned char var_kp,var_setpwm;
unsigned char setpwm,maxpwm=255,minpwm=0,sp;
int p,d,rate,last_error,mv,pv,kd,kp,error,var_kanan,var_kiri;

void bebas()
{
    lcd_clear();
                
    notasi_bebas[0]=getchar();
    notasi_bebas[1]=getchar();
    notasi_bebas[2]=getchar();
    notasi_bebas[3]=getchar();
    notasi_bebas[4]=getchar();
                
    /////--Maju--/////
    if(notasi_bebas[0]==0x00)
    {
        motor1_en=0;
        motor1_dir=1;
        motor2_en=0;
        motor2_dir=1;
                        
        if(notasi_bebas[1]==0x00) //Waktu
        {
            lcd_gotoxy(0,0);
            lcd_putsf("MAJU-WAKTU");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
                        
            lcd_puts(xstring);
                        
            motor1_pwm=notasi_bebas[3];
            motor2_pwm=notasi_bebas[4];
                        
            delay_ms(notasi_bebas[2]*1000);
            motor1_en=1;
            motor2_en=1;                           
        }
        else if(notasi_bebas[1]==0x01) //Jarak
        {
            lcd_gotoxy(0,0);
            lcd_putsf("MAJU-JARAK");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
        }
    }
                
    /////--Mundur--/////
    else if(notasi_bebas[0]==0x01)
    {
        motor1_en=0;
        motor1_dir=0;
        motor2_en=0;
        motor2_dir=0;    
                    
        if(notasi_bebas[1]==0x00) //Waktu
        {
            lcd_gotoxy(0,0);
            lcd_putsf("MUNDUR-WAKTU");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
                        
            motor1_pwm=notasi_bebas[3];
            motor2_pwm=notasi_bebas[4];
                        
            delay_ms(notasi_bebas[2]*1000);
            motor1_en=1;
            motor2_en=1;                           
        }
        else if(notasi_bebas[1]==0x01) //Jarak
        {
            lcd_gotoxy(0,0);
            lcd_putsf("MUNDUR-JARAK");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
        }
    }
                
    /////--Kanan--/////
    else if(notasi_bebas[0]==0x02)
    {
        motor1_en=0;
        motor1_dir=1;
        motor2_en=0;
        motor2_dir=0;
                        
        if(notasi_bebas[1]==0x00) //Waktu
        {
            lcd_gotoxy(0,0);
            lcd_putsf("KANAN-WAKTU");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
                        
            motor1_pwm=notasi_bebas[3];
            motor2_pwm=notasi_bebas[4];
                        
            delay_ms(notasi_bebas[2]*1000);
            motor1_en=1;
            motor2_en=1;
        }
        else if(notasi_bebas[1]==0x01) //Jarak
        {
            lcd_gotoxy(0,0);
            lcd_putsf("KANAN-JARAK");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
        }
    }
                
    /////--Kiri--/////
    else if(notasi_bebas[0]==0x03)
    {
        motor1_en=0;
        motor1_dir=0;
        motor2_en=0;
        motor2_dir=1;
                        
        if(notasi_bebas[1]==0x00) //Waktu
        {
            lcd_gotoxy(0,0);
            lcd_putsf("KIRI-WAKTU");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
                        
            motor1_pwm=notasi_bebas[3];
            motor2_pwm=notasi_bebas[4];
                        
            delay_ms(notasi_bebas[2]*1000);
            motor1_en=1;
            motor2_en=1;
        }
                    
        else if(notasi_bebas[1]==0x01) // Jarak
        {
            lcd_gotoxy(0,0);
            lcd_putsf("KIRI-JARAK");
            lcd_gotoxy(0,1);
            sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);
            lcd_puts(xstring);
        }
    }
}

void wall()
{    
    motor1_en=0;
    motor1_dir=1;
    motor2_en=0;
    motor2_dir=1;
                    
    while(detik_count<=notasi_obyek[2])
    {
        scan_kiri();
        pv=us;
            
        //======PID======//
        error=sp-pv;
        p=kp*error;
            
        rate=error-last_error;
        d=rate*kd;
        
        mv=p+d;
        //===============//
        if(mv==0)
        {
            motor1_pwm=setpwm;
            motor2_pwm=setpwm;
        }
        else 
        {
            var_kanan=setpwm - mv;
            var_kiri=setpwm + mv;
                
            if(var_kanan>255){var_kanan=255;}
            else if(var_kanan<0){var_kanan=0;}
            if(var_kiri>255){var_kiri=255;}
            else if(var_kiri<0){var_kiri=0;}
                
            motor1_pwm=var_kiri;
            motor2_pwm=var_kanan;
        }
    }
        
    motor1_en=1;
    motor1_dir=1;
    motor2_en=1;
    motor2_dir=1;
        
    /*
    sprintf(xstring,"%3d",us1);                
    lcd_gotoxy(0,0);
    lcd_puts(xstring);
        
    sprintf(xstring,"%3d  %3d",motor1_pwm,motor2_pwm);                
    lcd_gotoxy(0,1);
    lcd_puts(xstring);
        
    delay_ms(1);
    */
}
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTA=0b00000000;
DDRA =0b11111111;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=In Func5=Out Func4=In Func3=Out Func2=In Func1=Out Func0=In 
// State7=0 State6=P State5=0 State4=P State3=0 State2=P State1=0 State0=P 
PORTD=0x55;
DDRD=0xAA;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=T State0=T 
PORTE=0x00;
DDRE=0x04;

// Port F initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0b01000000;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1500.000 kHz
// Mode: Phase correct PWM top=0xFF
// OC0 output: Non-Inverted PWM
ASSR=0x00;
TCCR0=0x62;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1500.000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0xFF;
TCNT1L=0xF0;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1500.000 kHz
// Mode: Phase correct PWM top=0xFF
// OC2 output: Non-Inverted PWM
TCCR2=0x62;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x05;
TCNT3H=0xD2;
TCNT3L=0x3A;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: On
// INT6 Mode: Falling Edge
// INT7: On
// INT7 Mode: Falling Edge
EICRA=0x00;
EICRB=0xA0;
EIMSK=0xC0;
EIFR=0xC0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;

ETIMSK=0x04;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0x98;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x4D;

// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 750.000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 5
// RD - PORTC Bit 6
// EN - PORTC Bit 7
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 8
lcd_init(16);

// Global enable interrupts
#asm("sei")

lcdbl=1;
        
while (1)
      {                                                       
        while(getchar()==0xFF)
        {
            flag_aksi=getchar();

            ///////////==BEBAS==///////////
            if(flag_aksi==0x00)
            {
                bebas();                
            }
            
            ///////////==OBYEK==///////////
            if(flag_aksi==0x04)
            {
                lcd_clear();
                
                notasi_obyek[0]=getchar();
                notasi_obyek[1]=getchar();
                notasi_obyek[2]=getchar();
                notasi_obyek[3]=getchar();
                notasi_obyek[4]=getchar();
                
                /////--Kiri--/////
                if(notasi_obyek[0]==0x00)
                {
                    if(notasi_obyek[1]==0x00)
                    {
                        lcd_gotoxy(0,0);
                        lcd_putsf("OBYEK-KIRI-GARIS");
                        lcd_gotoxy(0,1);
                        sprintf(xstring,"%d %d",notasi_obyek[2],notasi_obyek[3]);
                        lcd_puts(xstring);                           
                    }
                    else if(notasi_obyek[1]==0x01)
                    {
                        lcd_gotoxy(0,0);
                        lcd_putsf("OBYEK-KIRI-WAKTU");
                        lcd_gotoxy(0,1);
                        sprintf(xstring,"%d %d",notasi_obyek[2],notasi_obyek[3]);
                        lcd_puts(xstring);
                        delay_ms(1000);
                                                
                        detik_count=0;
                        kp=10;
                        kd=5;
                        sp=notasi_obyek[3];
                        setpwm=notasi_obyek[4];

                        detik_count=0;//set timer
                        wall();                                                     
                    }
                }
                
                /////--Kanan--/////
                if(notasi_obyek[0]==0x01)
                {
                    if(notasi_obyek[1]==0x00)
                    {
                        lcd_gotoxy(0,0);
                        lcd_putsf("OBJ-KANAN-GARIS");
                        lcd_gotoxy(0,1);
                        sprintf(xstring,"%d %d",notasi_obyek[2],notasi_obyek[3]);
                        lcd_puts(xstring);                           
                    }
                    else if(notasi_obyek[1]==0x01)
                    {
                        lcd_gotoxy(0,0);
                        lcd_putsf("OBJ-KANAN-WAKTU");
                        lcd_gotoxy(0,1);
                        sprintf(xstring,"%d %d",notasi_obyek[2],notasi_obyek[3]);
                        lcd_puts(xstring);                           
                    }
                }
            }
            
            ///////////==GRIPPER==///////////
            if(flag_aksi==0x06)
            {
                lcd_clear();
                notasi_gripper[0]=getchar();
                notasi_gripper[1]=getchar();
                
                /////--Toggle--/////
                if(notasi_gripper[0]==0)
                {
                    if(notasi_gripper[1]==0)
                    {
                        lcd_gotoxy(0,0);lcd_putsf("GRIPPER:");
                        lcd_gotoxy(0,1);lcd_putsf("OPEN");
                        servo1=10;  
                    }
                    else if(notasi_gripper[1]==1)
                    {
                        lcd_gotoxy(0,0);lcd_putsf("GRIPPER:");
                        lcd_gotoxy(0,1);lcd_putsf("CLOSE");
                        servo1=120;  
                    }
                }
                
                /////--LENGAN--/////
                if(notasi_gripper[0]==1)
                {
                    if(notasi_gripper[1]==0)
                    {
                        lcd_gotoxy(0,0);lcd_putsf("LENGAN:");
                        lcd_gotoxy(0,1);lcd_putsf("NAIK");
                        servo2=10;  
                    }
                    else if(notasi_gripper[1]==1)
                    {
                        lcd_gotoxy(0,0);lcd_putsf("LENGAN:");
                        lcd_gotoxy(0,1);lcd_putsf("TURUN");
                        servo2=50;  
                    }
                }                   
            }
            
            ///////////==BUZZER==///////////
            if(flag_aksi==0x07)
            {
                lcd_clear();
                notasi_buzzer[0]=getchar();
                
                /////--Monostable--/////
                if(notasi_buzzer[0]==0)
                {
                    notasi_buzzer[1]=getchar();
                    lcd_gotoxy(0,0);lcd_putsf("Buzzer Status:");
                    lcd_gotoxy(0,1);lcd_putsf("ON");
                    
                    buzzer=1;
                    delay_ms(notasi_buzzer[1]*1000);
                    
                    lcd_clear();
                    lcd_gotoxy(0,0);lcd_putsf("Buzzer Status:");
                    lcd_gotoxy(0,1);lcd_putsf("OFF");
                    buzzer=0;     
                }
                
                /////--Astable--/////
                if(notasi_buzzer[0]==1)
                {
                    notasi_buzzer[1]=getchar();
                    notasi_buzzer[2]=getchar();
                    notasi_buzzer[3]=getchar();
                    
                    for(i=0;i<notasi_buzzer[3];i++)
                    {
                        lcd_clear();
                        lcd_gotoxy(0,0);lcd_putsf("Buzzer Status:");
                        lcd_gotoxy(0,1);lcd_putsf("ON");
                        sprintf(xstring,"%d",i);
                        lcd_gotoxy(14,1);lcd_puts(xstring);
                        
                        buzzer=1;
                        delay_ms(notasi_buzzer[1]*1000);
                        
                        lcd_gotoxy(0,0);lcd_putsf("Buzzer Status:");
                        lcd_gotoxy(0,1);lcd_putsf("OFF");
                        
                        buzzer=0;
                        delay_ms(notasi_buzzer[2]*1000);
                    }     
                }
            }
            
            ////////////==LCD==////////////
            if(flag_aksi==0x08)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("PESAN:");                        
                
                notasi_lcd[0]=getchar();
                for(i=0;i<notasi_lcd[0];i++)
                {
                    notasi_lcd[i+1]=getchar();
                    lcd_gotoxy(i,1);
                    sprintf(xstring,"%c",notasi_lcd[i+1]);
                    lcd_puts(xstring);                        
                }                               
            }
            
            ///////////==DELAY==///////////
            if(flag_aksi==0x09)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("DELAY:");                        
                
                notasi_delay[0]=getchar();
                
                lcd_gotoxy(0,1);
                sprintf(xstring,"%d",notasi_delay[0]);
                lcd_puts(xstring);
                
                delay_ms(notasi_delay[0]*1000);                              
            }
            
            ///////////==TEST==///////////
            if(flag_aksi==0x0A)
            {
                lcd_clear();
                
                motor1_en=0;
                motor1_dir=1;
                motor2_en=0;
                motor2_dir=1;
                
                motor1_pwm=getchar();
                motor2_pwm=getchar();
                while(1)
                {
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    sprintf(xstring,"%d %d",freq6,freq7);
                    lcd_puts(xstring);
                    
                    delay_ms(500);    
                }
                                                                       
            }
        }
      }
}