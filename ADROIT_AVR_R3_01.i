
typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float ftrunc(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

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

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

extern volatile signed char  dMotor1, dMotor2; 
extern bit              PIDMotorOn;

extern volatile signed char      dSpeed1, dSpeed2;               
extern volatile unsigned char     dCounter1, dCounter2;           
extern bit                  LaguOn, FlagSerial;

bit     LCD_BackLight=0,ImuStart=0;

eeprom unsigned SetKP,SetKD;     

volatile signed char        dSpeed1, dSpeed2;
volatile signed char  dMotor1=0, dMotor2=0;
bit PIDMotorOn=0;

#pragma used+
unsigned char HitungSudut(unsigned short int sudut);  
unsigned short int HitungSudut2(unsigned short int sudut); 
void SetDataMotorPWM(signed short int Ka, signed short int Ki);
void StopPWM();
void SetDataMotorPID(signed char dmKa, signed char dmKi);
void PIDmotor1(void);
void PIDmotor2(void);
#pragma used-            

#pragma used+    
unsigned char HitungSudut(unsigned short int sudut)  
{   return ((sudut*8)/18 + 20);}

unsigned short int HitungSudut2(unsigned short int sudut) 
{   return ((sudut*200)/18 + 500);}

void SudutServo6(unsigned char posisi)
{   OCR1A = HitungSudut2(posisi);}

void SudutServo7(unsigned char posisi)
{   OCR1B = HitungSudut2(posisi);}

void SudutServo8(unsigned char posisi)
{ unsigned short int dServo8;
dServo8 = HitungSudut2(posisi);
(*(unsigned char *) 0x79) = ((unsigned char) (((unsigned short int) (dServo8)) >> 8));
(*(unsigned char *) 0x78) = ((unsigned char) (dServo8));
}    
#pragma used+    

#pragma used+

void SetDataMotorPWM(signed short int Ki, signed short int Ka)
{   
PIDMotorOn = 0;
if(Ki<0)    { (*(unsigned char *) 0x85) = ((unsigned char) (((unsigned short int) (-Ki)) >> 8));  (*(unsigned char *) 0x84) = ((unsigned char) (-Ki));    (PORTE.5 = 0);}
else        { (*(unsigned char *) 0x85) = ((unsigned char) (((unsigned short int) (Ki)) >> 8));   (*(unsigned char *) 0x84) = ((unsigned char) (Ki));     (PORTE.5 = 1);}
if(Ka<0)    { (*(unsigned char *) 0x87) = ((unsigned char) (((unsigned short int) (-Ka)) >> 8));  (*(unsigned char *) 0x86) = ((unsigned char) (-Ka));    (PORTE.2 = 0);}
else        { (*(unsigned char *) 0x87) = ((unsigned char) (((unsigned short int) (Ka)) >> 8));   (*(unsigned char *) 0x86) = ((unsigned char) (Ka));     (PORTE.2 = 1);}   
}

void StopPWM()
{   (*(unsigned char *) 0x87) = 0;  (*(unsigned char *) 0x86) =0; (*(unsigned char *) 0x85) = 0;  (*(unsigned char *) 0x84) =0;
}

#pragma used-

#pragma used+

void SetDataMotorPID(signed char dmKi, signed char dmKa)
{   if(dmKi<0)  { dMotor1 = -dmKi;  (PORTE.5 = 0);  }
else        { dMotor1 = dmKi;   (PORTE.5 = 1); }
if(dmKa<0)  { dMotor2 = -dmKa;  (PORTE.2 = 0); }
else        { dMotor2 = dmKa;   (PORTE.2 = 1);  }
PIDMotorOn = 1;
}

void PIDmotor2(void)
{ signed char Error2;
signed short int U;       
static signed char lErrorM2=0, iErrorM2=0;

if(dMotor2>0)
{   Error2 = (signed char)dMotor2-(signed char)dSpeed2;
U = (signed short int) 10 * (Error2);
iErrorM2+=(Error2+lErrorM2);
if(iErrorM2>80)      iErrorM2 = 80;
else if(iErrorM2<-80)iErrorM2 = -80;
U+= (signed short int) 5 * iErrorM2;
if (U>(signed short int)   400)
{   (*(unsigned char *) 0x87) = ((unsigned char) (((unsigned short int) ((signed short int)   400)) >> 8));  (*(unsigned char *) 0x86) = ((unsigned char) ((signed short int)   400));}
else if (U>0)  
{   (*(unsigned char *) 0x87) = ((unsigned char) (((unsigned short int) (U)) >> 8));  (*(unsigned char *) 0x86) = ((unsigned char) (U));}
else
{    (*(unsigned char *) 0x87) = 0; (*(unsigned char *) 0x86) = 0;}
lErrorM2 = Error2;       
}
else {(*(unsigned char *) 0x87) = 0; (*(unsigned char *) 0x86) = 0;    iErrorM2=0;}      
}

void PIDmotor1(void)
{ signed char Error1;
signed short int U;       
static signed char lErrorM1=0, iErrorM1=0;

if (dMotor1>0)
{   Error1 = (signed char)dMotor1-(signed char)dSpeed1;
U = (signed short int) 10 * (lErrorM1);
iErrorM1+=(Error1+lErrorM1);
if(iErrorM1>80)      iErrorM1 = 80;
else if(iErrorM1<-80)iErrorM1 = -80;
U+= (signed short int) 5 * iErrorM1;
if (U>(signed short int)   400)
{   (*(unsigned char *) 0x85) = ((unsigned char) (((unsigned short int) ((signed short int)   400)) >> 8));  (*(unsigned char *) 0x84) = ((unsigned char) ((signed short int)   400));}
else if (U>0)  
{   (*(unsigned char *) 0x85) = ((unsigned char) (((unsigned short int) (U)) >> 8));  (*(unsigned char *) 0x84) = ((unsigned char) (U));}
else
{    (*(unsigned char *) 0x85) = 0; (*(unsigned char *) 0x84) = 0;}
lErrorM1  = Error1;
}
else  {(*(unsigned char *) 0x85) = 0; (*(unsigned char *) 0x84) = 0; iErrorM1=0;}
}

#pragma used-

#pragma used+
void LCD_Init_Cmd(unsigned char xData)
{   PORTA =  0B00000100 | (xData & 0xF0);
delay_us(1);        PORTA.2 = 0;
}
void LCD_Perintah(unsigned char xData)
{   
PORTA.0=0;
PORTA =  0B00001100 | (xData & 0xF0);
delay_us(1);     PORTA.2 = 0;
delay_us(5);
PORTA =  0B00001100 | (xData << 4);
delay_us(1);     PORTA.2 = 0;
delay_us(700);  
PORTA.2 = 1;
}

void LCD_Data(unsigned char xData)
{   
PORTA.0=1;
PORTA =  0B00001101 | (xData & 0xF0);
delay_us(1);     PORTA.2 = 0;
delay_us(5);
PORTA =  0B00001101 | (xData << 4);
delay_us(1);     PORTA.2 = 0;
delay_us(40);
PORTA.2 = 1;
}

void LCD_Init(void)
{   delay_ms(50);   LCD_Init_Cmd(0x30);
delay_ms(5);    LCD_Init_Cmd(0x30);
delay_ms(1);    LCD_Init_Cmd(0x30);
delay_ms(1);    LCD_Init_Cmd(0x20);
LCD_Perintah(0x28);         
LCD_Perintah(0x10);         
LCD_Perintah(0x0c);         
LCD_Perintah(0x06);         
LCD_Perintah(0x01);         
}            

void LCD_GotoXY(unsigned char x, unsigned char y)
{   unsigned char baris;
if (y==0) LCD_Perintah(0x80 + x);          
else      LCD_Perintah(0x80 + x + 0x40);   
}

void LCD_TextF(unsigned char flash *text)        
{   while (*text!=0)
{ LCD_Data(*text);text++;}
}

void LCD_Text(unsigned char *text)        
{   while (*text!=0)
{ LCD_Data(*text);text++;}
}

void LCD_TulisF(unsigned char Baris, unsigned char flash *text)        
{   LCD_GotoXY(0,Baris);LCD_TextF(text); 
}

void LCD_Hapus(void)              
{   LCD_Perintah(0x01);
}

void LCD_HapusBaris(unsigned char Baris)             
{   unsigned char i;
LCD_GotoXY(0,Baris);
for(i=0;i<16;i++) LCD_Data(' ');
}

void LCD_HapusKiri(unsigned char Baris)     
{   unsigned char i;
LCD_GotoXY(0,Baris);
for(i=0;i<16;i++)   { LCD_Data(' '); delay_ms(50);}
}              

void LCD_HapusKanan(unsigned char Baris)    
{   signed char i,j;
j = 0x80 + 0x40*Baris;
for(i=15;i>-1;i--)
{ LCD_Perintah (j+i);   LCD_Data(' '); delay_ms(50);}
}                

void LCD_TulisKiri(unsigned char Baris, unsigned char flash *text)    
{   unsigned char i;
LCD_GotoXY(0,Baris);
for(i=0;i<16;i++)
{ LCD_Data(*(text+i)); delay_ms(50);}
}                                                                                           

void LCD_TulisKanan(unsigned char Baris, unsigned char flash *text)    
{   signed char i,j;
j = 0x80 + 0x40*Baris;
for(i=15;i>-1;i--)
{ LCD_Perintah (j+i);   LCD_Data(*(text+i)); delay_ms(50);}
}                

void LCD_TulisTengah(unsigned char Baris, unsigned char flash *text)    
{   signed char i,j;
j = 0x80 + 0x40*Baris;
for(i=7;i>-1;i--)
{   LCD_Perintah (j+i);     LCD_Data(*(text+i));    delay_ms(50);
LCD_Perintah (j-i+15);  LCD_Data(*(text-i+15)); delay_ms(50);
}
}                

void LCD_TulisPinggir(unsigned char Baris, unsigned char flash *text)    
{   signed char i,j;
j = 0x80 + 0x40*Baris;
for(i=0;i<8;i++)
{   LCD_Perintah (j+i);     LCD_Data(*(text+i));    delay_ms(50);
LCD_Perintah (j-i+15);  LCD_Data(*(text-i+15)); delay_ms(50);
}
}                

void LCD_Angka4(signed short int x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
LCD_Data(x/1000+0x30);          
LCD_Data((x%1000)/100+0x30);    
LCD_Data((x%100)/10+0x30);      
LCD_Data(x%10+0x30);            
}

void LCD_Angka3(signed short int x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
LCD_Data(x/100+0x30);           
LCD_Data((x%100)/10+0x30);      
LCD_Data(x%10+0x30);            
}

void LCD_sByte(signed char x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
LCD_Data(x/100+0x30);           
LCD_Data((x%100)/10+0x30);      
LCD_Data(x%10+0x30);            
}

void LCD_uByte(unsigned char x)
{   LCD_Data(x/100+0x30);           
LCD_Data((x%100)/10+0x30);      
LCD_Data(x%10+0x30);            
}

void LCD_Biner(unsigned char x)
{   unsigned char i;
for(i=0;i<8;i++)
{   if( (x&(1<<(7-i)))==0 ) 
{LCD_Data('0');}
else
{LCD_Data('1');}
}
}
#pragma used-                    

#pragma used+

extern void I2C_Init(void);

extern void I2C_Stop(void);

extern unsigned char I2C_Start(unsigned char address);

extern unsigned char I2C_Rep_Start(unsigned char address);

extern void I2C_Start_Wait(unsigned char address);

extern unsigned char I2C_Write(unsigned char data);

extern unsigned char I2C_ReadAck(void);

extern unsigned char I2C_ReadNak(void);
#pragma used-

void I2C_Init(void)
{

(*(unsigned char *) 0x71) = 0;                         
(*(unsigned char *) 0x70) = (((unsigned long int) 16000000          /(unsigned long int) 100000      )-16)/2;  
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

bit LaguOn=0;

#pragma used+
void BuzzerOff();
void FBuzzer(unsigned short int x);
void Buzzer(unsigned short int Frek, unsigned short int Tempo);
void Nada1(void);
void Nada2(void);
void Nada3(void);
void Nada4(void);

void BuzzerOff()
{ TCCR0=0x00; PORTB.4=0; ASSR=0x00; }

void FBuzzer(unsigned unsigned short int x)
{ 
if(x>=125 && x<=10000)
{     if (x>=2000)
{ TCCR0=0x1A; TCNT0=0;
OCR0 = 500000 / x; 
}
if (x>=1000)
{ TCCR0=0x1B; TCNT0=0;
OCR0 = 250000 / x; 
}
else if (x>=500)
{ TCCR0=0x1C; TCNT0=0;
OCR0 = 125000 / x; 
}  
else if (x>=250)
{ TCCR0=0x1D; TCNT0=0;
OCR0 = 67500 / x; 
}  
else
{ TCCR0=0x1E; TCNT0=0;
OCR0 = 33750 / x; 
}
}
else
{ BuzzerOff();
}
} 

void Buzzer(unsigned short int Frek, unsigned short int Tempo)
{  FBuzzer(Frek); delay_ms(Tempo);BuzzerOff();}

void Nada1(void)
{   Buzzer(1000,100);Buzzer(500,20);
Buzzer(3000,50);Buzzer(500,20);
Buzzer(3000,100);Buzzer(500,20);
Buzzer(2000,50);
}

void Nada2(void)
{   Buzzer(3000,100);Buzzer(500,20);
Buzzer(2500,150);Buzzer(500,20);
Buzzer(1000,50);Buzzer(500,20);
Buzzer(3000,50);
}

void Nada3(void)
{   Buzzer(3000,50);Buzzer(500,20);
Buzzer(1000,150);Buzzer(500,20);
Buzzer(3000,100);Buzzer(500,20);
Buzzer(2000,50);
}

void Nada4(void)
{   Buzzer(2000,150);Buzzer(500,20);
Buzzer(3000,50);Buzzer(500,20);
Buzzer(3500,50);Buzzer(500,20);
Buzzer(3000,100);
}
#pragma used-

unsigned short int flash Melodi[] = {
2639, 2639,  0, 2639, 0, 2093, 2639, 0, 3136,  0,  0,  0, 1568,  0,  0, 0, 
2093,  0,  0, 1568, 0,  0, 1318, 0,  0, 1760,  0, 1975,  0,1864, 1760, 0, 
1568, 2639, 3136, 3520, 0, 2793, 3136, 0, 2639,  0, 2093, 2349, 1975,  0,  0,
2093,  0,  0, 1568, 0,  0, 1318, 0,  0, 1760,  0, 1975,  0,1864, 1760, 0, 
1568, 2639, 3136, 3520, 0, 2793, 3136, 0, 2639,  0, 2093, 2349, 1975,  0,  0};  

unsigned char flash Tempo[] = {
30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30, 
30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30, 
35,35,35,24,30,30,30,30,30,30,30,30,30,30,30,
30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30, 
35,35,35,24,30,30,30,30,30,30,30,30,30,30,30};

bit FlagSerial=0;

char rx_buffer0[512];

unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;

bit rx_buffer_overflow0;

interrupt [19] void usart0_rx_isr(void)
{
char status0,data0;
status0=UCSR0A;
data0=UDR0;

if ((status0 & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer0[rx_wr_index0++]=data0;
if (rx_wr_index0 == 512) rx_wr_index0=0;
if (++rx_counter0 == 512)
{
rx_counter0=0;
rx_buffer_overflow0=1;
}
}

}

#pragma used+

char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
if (rx_rd_index0 == 512) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-

volatile signed char rx_buffer1[512];

volatile unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;

bit rx_buffer_overflow1;

interrupt [31] void usart1_rx_isr(void)
{
volatile signed char Pointer_X,Pointer_Y,Flag_Serial_Step;
volatile char status,;
volatile unsigned char data;

status=(*(unsigned char *) 0x9b);
data=(*(unsigned char *) 0x9c);
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer1[rx_wr_index1]=data;
if (++rx_wr_index1 == 512) rx_wr_index1=0;
if (++rx_counter1 == 512)
{
rx_counter1=0;
rx_buffer_overflow1=1;
};
};

}

#pragma used+

unsigned char BacaSerial1(unsigned short int TimeOut)
{   unsigned short int i;
unsigned char data;
FlagSerial = 0;
for(i=0;i<TimeOut;i++)
{   if (rx_counter1!=0) 
{   FlagSerial = 1;
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == 512) rx_rd_index1=0;
#asm("cli") --rx_counter1;  #asm("sei")
return data;
break;
}
delay_us(1);
}
return 0;
}

unsigned char getchar1(void)
{   unsigned char data;
while (rx_counter1==0); 
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == 512) rx_rd_index1=0;
#asm("cli") --rx_counter1;  #asm("sei")
return data;
}

void putchar1(signed char c)
{   while (((*(unsigned char *) 0x9b) & (1<<5))==0);
(*(unsigned char *) 0x9c)=c;
}
#pragma used-

#pragma used+
void BacaSensor(unsigned char Alamat, unsigned char Protokol);
unsigned char TungguTombolKalibrasi(unsigned char Alamat, unsigned char Protokol);
void PesanKalibrasiBerhasil(void);
void PesanKalibrasiGagal(void);
signed char KalibrasiRGB(unsigned char Alamat);

void BacaSensor(unsigned char Alamat, unsigned char Protokol)
{   putchar1(Protokol | Alamat);
}

unsigned char TungguTombolKalibrasi(unsigned char Alamat, unsigned char Protokol)
{   unsigned char filter=0;
while (filter<=100)   
{ if(PINC.3)filter=0;
filter++;
}
if(!PINC.3)    {   putchar1(Protokol | Alamat); return 1;}
else        {   putchar1(0);                 return 0;}    
}

unsigned char TungguTombolKalibrasiEx(unsigned char Alamat, unsigned char Protokol)
{   unsigned char filter=0;
while (filter<=100)   
{ if(PINC.3)filter=0;
filter++;
}
if(!PINC.3)      {   putchar1(Protokol | Alamat); return 1;}
else            {   putchar1(0);                 return 0;}    
}

void PesanKalibrasiBerhasil(void)
{   LCD_Perintah(0x01);         

LCD_TulisF      (0, "Kalibrasi Sensor");
LCD_TulisKiri   (1, "Selesai >>>>>>>>");
}

void PesanKalibrasiGagal(void)
{   LCD_Perintah(0x01);         

LCD_TulisF      (0, "Kalibrasi Sensor");
LCD_TulisKiri   (1, "Dihentikan >>>>>");
}

signed char KalibrasiRGB(unsigned char Alamat)
{   LCD_Perintah(0x01);         

LCD_TulisF      (0, "Kalibrasi Sensor");
LCD_TulisF      (1, "Merah-Hijau-Biru");
Buzzer(3000,500);
delay_ms(1000);
LCD_Perintah(0x01);         
putchar1((unsigned char) 0B11110000 | Alamat);
LCD_TulisKiri   (0, "1.Warna Merah >>");
LCD_TulisKanan  (1, "Tekan Tombol 1<<");
if(TungguTombolKalibrasi(Alamat, (unsigned char) 0B11110000))
{   Buzzer(3000,200);
LCD_HapusKanan(0);
LCD_TulisKiri   (0, "2.Warna Hijau >>");
if(TungguTombolKalibrasi(Alamat, (unsigned char) 0B11110000))
{   Buzzer(3000,200);
LCD_HapusKanan(0);
LCD_TulisKiri  (0, "3.Warna Biru >>>");  
if(TungguTombolKalibrasi(Alamat, (unsigned char) 0B11110000))
{   Buzzer(3000,200);
LCD_HapusKanan(0);
LCD_TulisKiri  (0, "4.Warna Hitam >>");
if(TungguTombolKalibrasi(Alamat, (unsigned char) 0B11110000))
{   Buzzer(3000,200);
if(BacaSerial1(5000)==(unsigned char) 0B11110000)
{  PesanKalibrasiBerhasil(); 
return(1); 
}
}      
}
}
}
PesanKalibrasiGagal();
return(0);
}         

signed char KalibrasiHitamPutih(unsigned char Alamat, unsigned char Protocol)
{   LCD_Perintah(0x01);         

LCD_TulisF      (0, "Kalibrasi Sensor");
if (Protocol==(unsigned char) 0B11000000)
{ LCD_TulisF      (1, "HitamPutih-Merah"); }
else if (Protocol==(unsigned char) 0B10100000)
{ LCD_TulisF      (1, "HitamPutih-Hijau"); }
else if (Protocol==(unsigned char) 0B10010000)
{ LCD_TulisF      (1, "HitamPutih-Biru "); }
else
{   PesanKalibrasiGagal();
return 0;
}
Buzzer(3000,500);
delay_ms(1000);
LCD_Perintah(0x01);         
putchar1(Protocol | Alamat);
LCD_TulisKiri   (0, "1.Warna Putih >>");
LCD_TulisKanan  (1, "Tekan Tombol 1<<");
if(TungguTombolKalibrasi(Alamat, Protocol))
{   Buzzer(3000,200);
LCD_HapusKanan(0);
LCD_TulisKiri   (0, "2.Warna Hitam >>");
if(TungguTombolKalibrasi(Alamat, Protocol))
{   Buzzer(3000,200);
if(BacaSerial1(5000)==Protocol)
{  PesanKalibrasiBerhasil(); 
return(1); 
}
}
}
PesanKalibrasiGagal();
return(0);
}         

signed char KalibrasiHitamPutihEx(unsigned char Alamat, unsigned char Protocol)
{   LCD_Perintah(0x01);         

LCD_TulisF      (0, "Kalibrasi Sensor");
if (Protocol==(unsigned char) 0B11000000)
{ LCD_TulisF      (1, "HitamPutih-Merah"); }
else if (Protocol==(unsigned char) 0B10100000)
{ LCD_TulisF      (1, "HitamPutih-Hijau"); }
else if (Protocol==(unsigned char) 0B10010000)
{ LCD_TulisF      (1, "HitamPutih-Biru "); }
else
{   PesanKalibrasiGagal();
return 0;
}
Buzzer(3000,500);
delay_ms(1000);
LCD_Perintah(0x01);         
putchar1(Protocol | Alamat);
LCD_TulisKiri   (0, "1.Warna Putih >>");
LCD_TulisKanan  (1, "Tekan Tombol 1<<");
if(TungguTombolKalibrasiEx(Alamat, Protocol))
{   Buzzer(3000,200);
LCD_HapusKanan(0);
LCD_TulisKiri   (0, "2.Warna Hitam >>");
if(TungguTombolKalibrasiEx(Alamat, Protocol))
{   Buzzer(3000,200);
if(BacaSerial1(5000)==Protocol)
{  PesanKalibrasiBerhasil(); 
return(1); 
}
}
}
PesanKalibrasiGagal();
return(0);
}

#pragma used-

register signed int     Enkoder1=0, Enkoder2=0;     
register unsigned char  SysTick = 0;                
volatile unsigned char  dCounter1=0, dCounter2=0;   
volatile unsigned char  WaktuEksekusi;              

interrupt [8] void ext_int6_isr(void)
{ 
if(PINE.6 )
{  if(PINB.0) {#asm("cli")  Enkoder1--; #asm("sei")}
else            {#asm("cli")  Enkoder1++; #asm("sei")}
}
else
{  if(PINB.0) {#asm("cli")  Enkoder1++; #asm("sei")}
else            {#asm("cli")  Enkoder1--; #asm("sei")}
}
dCounter1++;        
}

interrupt [9] void ext_int7_isr(void)
{ if(PINE.7 )
{  if(PINB.2) {#asm("cli")  Enkoder2++; #asm("sei")}
else            {#asm("cli")  Enkoder2--; #asm("sei")}
}
else
{  if(PINB.2) {#asm("cli")  Enkoder2--; #asm("sei")}
else            {#asm("cli")  Enkoder2++; #asm("sei")}
}
dCounter2++;        
}

unsigned int usCounter;
interrupt [29] void timer3_compc_isr(void)
{  
static unsigned int ServoCounter=0;
usCounter++; 
if (++ServoCounter<=80)      
{    
}
else if (ServoCounter>800)
{    ServoCounter = 0;

}
}

interrupt [12] void timer1_capt_isr(void)
{

static unsigned char ServoCounter=0, LaguTick=0, TempoTick=0;
#asm("sei");                                        
if(++ServoCounter>4)
{ ServoCounter = 0;

TCCR1A=0xAA;      
}
else 
{ TCCR1A=0x02;      
PORTB.5  = 0;     
PORTB.6  = 0;     
PORTB.7  = 0;     
}

if(LaguOn)                      
{   if(++TempoTick>=Tempo[LaguTick])            
{   TempoTick = 0;                          
FBuzzer(Melodi[LaguTick]);              
if (++LaguTick>=78) LaguTick=0; 
}        
}
}

unsigned short int DTime;unsigned char DTimeTick;
interrupt [15] void timer1_ovf_isr(void)
{

DTimeTick++;
if(DTimeTick>200){DTimeTick=0;DTime++;} 

}

interrupt [10] void timer2_comp_isr(void)
{   static unsigned char _dCounter1=0, _dCounter2=0, Timer2Tick=0;
SysTick++;
#asm("sei");                    
if(++Timer2Tick==4)             
{   if(dCounter1>_dCounter1)    dSpeed1 = dCounter1 - _dCounter1;               
else                        dSpeed1 = 0xFF - _dCounter1 + dCounter1 + 1;    
_dCounter1 = dCounter1;
}
else if (Timer2Tick==5)       
{   
if(PIDMotorOn) PIDmotor1(); 
}
else if(Timer2Tick==9)          
{   if(dCounter2>_dCounter2)    dSpeed2 = dCounter2 - _dCounter2;               
else                        dSpeed2 = 0xFF - _dCounter2 + dCounter2 + 1;    
_dCounter2 = dCounter2;
}
else if (Timer2Tick>=10)
{   
if(PIDMotorOn) PIDmotor2(); 
Timer2Tick=0;
}  
}

#pragma used+
void SystemInit(void)
{   

PORTA=0x00; DDRA=0xFF;

PORTB=0x05; DDRB=0xF8;

PORTC=0x0F; DDRC=0xF0;

PORTD=0xF0; DDRD=0x00;

PORTE=0xC0; DDRE=0x3C;

(*(unsigned char *) 0x62)=0x00; (*(unsigned char *) 0x61)=0x04;

(*(unsigned char *) 0x65)=0x17;
(*(unsigned char *) 0x64)=0x00;

ASSR=0x00;
TCCR0=0x00; 
TCNT0=0x00;
OCR0=0x00;

TCCR1A=0xAA;
TCCR1B=0x12;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x27; ICR1L=0x10; 
ICR1H=0x13; ICR1L=0x88; 
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
(*(unsigned char *) 0x79)=0x00;
(*(unsigned char *) 0x78)=0x00;

TCCR2=0x0B;         
TCNT2=0x00;
OCR2=0xFA;

(*(unsigned char *) 0x8b)=0xF2;
(*(unsigned char *) 0x8a)=0x11;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x81)=0x01;  
(*(unsigned char *) 0x80)=0x90;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x83)=0x00;
(*(unsigned char *) 0x82)=0xC8; 

(*(unsigned char *) 0x6a)=0x00;
EICRB=0x50;
EIMSK=0xC0;
EIFR=0xC0;

TIMSK=0xA4;     
(*(unsigned char *) 0x7d)=0x02;    

UCSR0A=0x00;
UCSR0B=0x90;
(*(unsigned char *) 0x95)=0x06;
(*(unsigned char *) 0x90)=0x00;
UBRR0L=0x67;

(*(unsigned char *) 0x9b)=0x00;
(*(unsigned char *) 0x9a)=0x98;
(*(unsigned char *) 0x9d)=0x06;
(*(unsigned char *) 0x98)=0x00;
(*(unsigned char *) 0x99)=0x67;  

ACSR=0x80;
SFIOR=0x00;

LCD_Init(); 
StopPWM();     

SudutServo6(90);
SudutServo7(90 );
SudutServo8(90 );
#asm("cli");

I2C_Init();

#asm("sei");

#asm("sei") 
}
#pragma used-

bit FlagBelok;

unsigned char BacaSensorWarna(unsigned char alamat, unsigned char warna)
{   BacaSensor(alamat,warna);
if(BacaSerial1(5000)==warna)
{   return BacaSerial1(5000);
}
else return 0;
}

unsigned char BacaSensorMerah(unsigned char alamat)
{   BacaSensor(alamat,(unsigned char) 0B01000000);
if(BacaSerial1(5000)==(unsigned char) 0B01000000)
{   return BacaSerial1(5000);
}
else return 0;
}

unsigned char BacaSensorBiru(unsigned char alamat)
{   BacaSensor(alamat,(unsigned char) 0B00010000);
if(BacaSerial1(5000)==(unsigned char) 0B00010000)
{   return BacaSerial1(5000);
}
else return 0;
}

void ExitStart(unsigned char Warna)
{   unsigned char sensor;
do{  SetDataMotorPWM(100,100);
sensor = BacaSensorWarna(0,Warna); 
LCD_GotoXY(0,1);
LCD_Biner(sensor);
}while((sensor|0B11000011)!=0B11000011);
do{  SetDataMotorPWM(100,100);
sensor = BacaSensorWarna(0,Warna); 
LCD_GotoXY(0,1);
LCD_Biner(sensor);

}while((sensor|0B11000011)==0B11000011);
}

void ScanGaris(signed short int TopSpeed, unsigned char WarnaGaris)
{   unsigned char sensor;
signed short int MKi, MKa, Error, dError, u;   
static signed short int LastError;

BacaSensor(0,WarnaGaris);
if(BacaSerial1(5000)==WarnaGaris)
{   sensor = BacaSerial1(5000);

switch (sensor)
{   case    0B01111111: Error = -7;    break;
case    0B00111111: Error = -6;    break;
case    0B10111111: Error = -5;    break;
case    0B10011111: Error = -4;    break;
case    0B11011111: Error = -3;    break;
case    0B11001111: Error = -2;    break;
case    0B11101111: Error = -1;    break;
case    0B11100111: Error = -0;    break;
case    0B11110111: Error = 1;      break;
case    0B11110011: Error = 2;      break;
case    0B11111011: Error = 3;      break;
case    0B11111001: Error = 4;      break;
case    0B11111101: Error = 5;      break;
case    0B11111100: Error = 6;      break;
case    0B11111110: Error = 7;      break;
case    0B11111111: Error=LastError;break;
default:            Error=LastError;break;
}    
dError = Error-LastError;

LastError = Error;
if (TopSpeed>=300)
u = ((20 * Error + 150*dError));
else
u = ((20 * Error + 120*dError));

MKi = TopSpeed + u;
MKa = TopSpeed - u;
if (MKi>400) MKi = 400;
else if (MKi<-400) MKi = -400;
if (MKa>400) MKa = 400;
else if (MKa<-400) MKa = -400;
SetDataMotorPWM(MKi,MKa);

}
}

void ScanPerempatan(signed short int TopSpeed, unsigned char WarnaGaris, unsigned char WarnaPerempatan)
{   unsigned char sensor;
static int LastSpeed=100;
unsigned char Counter;
if((LastSpeed>TopSpeed) | FlagBelok==1) LastSpeed = 100;
FlagBelok=0;
Counter = 0; 
do{  if(Counter<255)Counter++;
if((LastSpeed<TopSpeed))LastSpeed+=7;
ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,WarnaPerempatan); 

}while((sensor|0B11000011)!=0B11000011);
do{  ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,WarnaPerempatan); 

}while((sensor|0B11000011)==0B11000011);
StopPWM();
LastSpeed=TopSpeed;
}

void Scan3Kanan(signed short int TopSpeed, unsigned char WarnaGaris, unsigned char Warna3)
{   unsigned char sensor;
static int LastSpeed=50;
unsigned char Counter;
if( LastSpeed>TopSpeed) LastSpeed = TopSpeed;
if( FlagBelok==1) LastSpeed = 50;
FlagBelok=0;
Counter = 0; 
do{  if(Counter<255)Counter++;
if((LastSpeed<TopSpeed))LastSpeed+=10;
ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,Warna3); 

}while((sensor|0B11111000)!=0B11111000);
do{  ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,Warna3); 

}while((sensor|0B11111000)==0B11111000);
StopPWM();
LastSpeed=TopSpeed;
}
void Scan3Kiri(signed short int TopSpeed, unsigned char WarnaGaris, unsigned char Warna3)
{   unsigned char sensor;
static int LastSpeed=50;
unsigned char Counter;
if( LastSpeed>TopSpeed) LastSpeed = TopSpeed;
if( FlagBelok==1) LastSpeed = 50;
FlagBelok=0;
Counter = 0; 
do{  if(Counter<255)Counter++;
if((LastSpeed<TopSpeed))LastSpeed+=10;
ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,Warna3); 

}while((sensor|0B00011111)!=0B00011111);
do{  ScanGaris(LastSpeed, WarnaGaris);
sensor = BacaSensorWarna(0,Warna3); 

}while((sensor|0B00011111)==0B00011111);
StopPWM();
LastSpeed=TopSpeed;
}

void BelKaPWM(signed short int Ki,signed short int Ka,unsigned char WarnaAkhir)
{   unsigned char sensor;
SetDataMotorPWM(Ki,Ka);
FlagBelok=1;

delay_ms(50);
do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
} while((sensor & (1<<0))==0 || (sensor & (1<<1))==0 ); 

delay_ms(50);
do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
} while((sensor & (1<<0))!=0 && (sensor & (1<<1))!=0); 
StopPWM();
}
void BelKiPWM(signed short int Ki,signed short int Ka,unsigned char WarnaAkhir)
{   unsigned char sensor;
SetDataMotorPWM(Ki,Ka);
FlagBelok=1;

delay_ms(50);
do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
} while((sensor & (1<<7))==0 || (sensor & (1<<6))==0 );

delay_ms(50);
do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
} while((sensor & (1<<7))!=0 && (sensor & (1<<6))!=0); 
StopPWM();
}

void ScanDindingKi(signed short int TopSpeed,signed short int SetPoint)
{
signed short int timeout,Kus,Dus,count;

signed short int MKi, MKa, Error, dError, u;   
static signed short int LastErrorDKi;
signed char flagBelok;

(*(unsigned char *) 0x61)=0b01010100;

(*(unsigned char *) 0x62)=0x00;delay_us(2);(*(unsigned char *) 0x62)=0b00010000;delay_us(10);(*(unsigned char *) 0x62)=0x000;    
usCounter=0; while (!PINF.5&&usCounter<40); 
usCounter=0; while (PINF.5&&usCounter<1440); 
Dus=(usCounter*0.43125);

delay_ms(10);

(*(unsigned char *) 0x62)=0x00;delay_us(2);(*(unsigned char *) 0x62)=0b01000000;delay_us(10);(*(unsigned char *) 0x62)=0x000;    
usCounter=0; while (!PINF.7&&usCounter<40); 
usCounter=0; while (PINF.7&&usCounter<1440); 
Kus=(usCounter*0.43125);

delay_ms(10);

LCD_Hapus();
LCD_GotoXY(0,0);    LCD_Angka3(Kus);
LCD_GotoXY(8,0);    LCD_Angka3(Dus);

if(Dus<=20){SetDataMotorPWM(200,-200);}
else if(Kus>SetPoint+10){SetDataMotorPWM(50,200);}
else
{
Error = SetPoint - Kus ;                           
dError = Error-LastErrorDKi;                
LastErrorDKi = Error;

u = ((SetKP * Error + SetKD*dError)); 

MKi = TopSpeed + u;
MKa = TopSpeed - u;
if (MKi>400) MKi = 400;
else if (MKi<-400) MKi = 400;
if (MKa>400) MKa = 400;
else if (MKa<-400) MKa = 400;
SetDataMotorPWM(MKi,MKa);
}
}

void ScanDindingKa(signed short int TopSpeed,signed short int SetPoint)
{
signed short int timeout,Kus,Dus,count;

signed short int MKi, MKa, Error, dError, u;   
static signed short int LastErrorDKa;
signed char flagBelok;

(*(unsigned char *) 0x61)=0b01010100;

(*(unsigned char *) 0x62)=0x00;delay_us(2);(*(unsigned char *) 0x62)=0b00010000;delay_us(10);(*(unsigned char *) 0x62)=0x000;    
usCounter=0; while (!PINF.5&&usCounter<40); 
usCounter=0; while (PINF.5&&usCounter<1440); 
Dus=(usCounter*0.43125);

delay_ms(10);

(*(unsigned char *) 0x62)=0x00;delay_us(2);(*(unsigned char *) 0x62)=0b00000100;delay_us(10);(*(unsigned char *) 0x62)=0x000;    
usCounter=0; while (!PINF.3&&usCounter<40); 
usCounter=0; while (PINF.3&&usCounter<1440); 
Kus=(usCounter*0.43125);

delay_ms(10);

LCD_Hapus();
LCD_GotoXY(0,0);    LCD_Angka3(Kus);
LCD_GotoXY(8,0);    LCD_Angka3(Dus);
LCD_GotoXY(8,1);    LCD_Angka3(FlagBelok);

if(Dus<=20){SetDataMotorPWM(-200,200);}
else if(Kus>SetPoint+10)
{
PORTC.4=1;PORTC.5=1;
SetDataMotorPWM(200,50);
}
else
{
Error = SetPoint - Kus ;                               
dError = Error-LastErrorDKa;                
LastErrorDKa = Error;

u = ((SetKP * Error + SetKD*dError)); 

MKi = TopSpeed - u;
MKa = TopSpeed + u;
if (MKi>400) MKi = 400;
else if (MKi<-400) MKi = 400;
if (MKa>400) MKa = 400;
else if (MKa<-400) MKa = 400;
SetDataMotorPWM(MKi,MKa);
}
}    

void GarisDindingKi(signed short int TopSpeed,signed short int SetPoint,unsigned char WarnaGaris)
{
unsigned char sensor;
static int LastSpeed=100;
unsigned char Counter;
if((LastSpeed>TopSpeed) | FlagBelok==1) LastSpeed = 100;
FlagBelok=0;
Counter = 0; 
do{  if(Counter<255)Counter++;
if((LastSpeed<TopSpeed))LastSpeed+=7;
ScanDindingKi(LastSpeed,SetPoint);
sensor = BacaSensorWarna(0,WarnaGaris); 

}while (sensor==0B11111111); 
do{  ScanDindingKi(LastSpeed,SetPoint);
sensor = BacaSensorWarna(0,WarnaGaris); 

}while(sensor!=0B11111111);
StopPWM();
LastSpeed=TopSpeed;
}

void GarisDindingKa(signed short int TopSpeed,signed short int SetPoint,unsigned char WarnaGaris)
{
unsigned char sensor;
static int LastSpeed=100;
unsigned char Counter;
if((LastSpeed>TopSpeed) | FlagBelok==1) LastSpeed = 100;
FlagBelok=0;
Counter = 0; 
do{  if(Counter<255)Counter++;
if((LastSpeed<TopSpeed))LastSpeed+=7;
ScanDindingKa(LastSpeed,SetPoint);
sensor = BacaSensorWarna(0,WarnaGaris); 

}while(sensor==0B11111111); 
do{  ScanDindingKa(LastSpeed,SetPoint);
sensor = BacaSensorWarna(0,WarnaGaris); 

}while(sensor!=0B11111111); 
StopPWM();
LastSpeed=TopSpeed;
}

void WaktuDindingKi(signed short int TopSpeed,signed short int SetPoint,unsigned char Durasi)
{
DTimeTick=0;DTime=0; 

while(DTime<= Durasi){ScanDindingKi(TopSpeed,SetPoint);}
StopPWM();
}

void WaktuDindingKa(signed short int TopSpeed,signed short int SetPoint,unsigned char Durasi)
{
DTimeTick=0;DTime=0; 

while(DTime<= Durasi){ScanDindingKa(TopSpeed,SetPoint);}
StopPWM();
}

unsigned char notasi_bebas[5],notasi_dinding[5],notasi_buzzer[4],notasi_lcd[17],notasi_gripper[3],notasi_garis[4],notasi_obyek[5],notasi_delay[1],notasi_tes[5];
unsigned char temp_char[3],xstring[16];
unsigned char i,j,k;
unsigned char flag_aksi;

signed short int pwmki,pwmka;

void Greeting()
{
SudutServo6(160); 
SudutServo7(90);
SudutServo8 (90);
delay_ms(500);    

SudutServo6(160);
SudutServo7(90);
SudutServo8 (160);
for(i=0;i<3;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}

SudutServo6(160);
SudutServo7(20);
SudutServo8(160);
for(i=3;i<5;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}

SudutServo6(70);
SudutServo7(20);
SudutServo8(160);
for(i=5;i<8;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}

SudutServo6(70);
SudutServo7(90);
SudutServo8(90);
for(i=8;i<12;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}

SudutServo6(160);
SudutServo7(90);
SudutServo8(90);
for(i=12;i<16;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}

LCD_Hapus();
LCD_GotoXY(0,0);
LCD_TulisTengah(0,"   -=WELCOME=-  "); 
delay_ms(1000);
LCD_TulisTengah(0,"                "); 
LCD_TulisTengah(0,"  -=ROBOVIPER=- ");
delay_ms(500);
LCD_TulisKiri(1,"  READY........ ");
delay_ms(1000);
}

void Bebas()
{
LCD_Hapus();

notasi_bebas[0]=getchar();
notasi_bebas[1]=getchar();
notasi_bebas[2]=getchar();
notasi_bebas[3]=getchar();

if(notasi_bebas[0]==0x00)
{                        
if(notasi_bebas[1]==0x00) 
{
notasi_bebas[4]=getchar();

LCD_TulisF(0,"MAJU-WAKTU");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(0,1);    LCD_Angka3(notasi_bebas[3]);                        
LCD_GotoXY(8,1);    LCD_Angka3(notasi_bebas[4]);                        

SetDataMotorPID(notasi_bebas[3],notasi_bebas[4]);

delay_ms(notasi_bebas[2]*1000);

SetDataMotorPID(0,0); 
}
else if(notasi_bebas[1]==0x01) 
{
signed short int Enkoder_t=0;    
Enkoder1=0;Enkoder2=0;

LCD_TulisF(0,"MAJU-JARAK");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(13,0);    LCD_Angka3(notasi_bebas[2]);                        
LCD_GotoXY(13,1);    LCD_Angka3(notasi_bebas[2]*283/(3.141592654*6.4  ));                        

SetDataMotorPID(notasi_bebas[3],notasi_bebas[3]);

while(Enkoder_t <= notasi_bebas[2]*283/(3.141592654*6.4  ))
{
Enkoder_t = (Enkoder1+Enkoder2)/2;
LCD_GotoXY(0,1);    LCD_Angka4(Enkoder1);   LCD_Data(' ');
LCD_GotoXY(6,1);    LCD_Angka4(Enkoder2);   LCD_Data(' ');
}

SetDataMotorPID(0,0); 
}
}

else if(notasi_bebas[0]==0x01)
{            
signed short int tempki,tempka;
if(notasi_bebas[1]==0x00) 
{
notasi_bebas[4]=getchar();

LCD_TulisF(0,"MUNDUR-WAKTU");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(0,1);    LCD_Angka3(notasi_bebas[3]);                        
LCD_GotoXY(8,1);    LCD_Angka3(notasi_bebas[4]);

tempki=notasi_bebas[3];
tempka=notasi_bebas[4];

SetDataMotorPID(tempki*-1,tempka*-1);

delay_ms(notasi_bebas[2]*1000);

SetDataMotorPID(0,0); 
}
else if(notasi_bebas[1]==0x01) 
{
signed short int Enkoder_t=0;    
Enkoder1=0;Enkoder2=0;

LCD_TulisF(0,"MUNDUR-JARAK");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(13,0);    LCD_Angka3(notasi_bebas[2]);                        
LCD_GotoXY(13,1);    LCD_Angka3(notasi_bebas[2]*283/(3.141592654*6.4  ));                                              

tempki=notasi_bebas[3];
tempka=notasi_bebas[3];

SetDataMotorPID(tempki*-1,tempka*-1);

while(Enkoder_t <= notasi_bebas[2]*283/(3.141592654*6.4  ))
{
Enkoder_t = ((Enkoder1+Enkoder2)/2)*-1;
LCD_GotoXY(0,1);    LCD_Angka4(Enkoder1);   LCD_Data(' ');
LCD_GotoXY(6,1);    LCD_Angka4(Enkoder2);   LCD_Data(' ');
}

SetDataMotorPID(0,0); 
}
}

else if(notasi_bebas[0]==0x02)
{                        
signed short int tempka;
if(notasi_bebas[1]==0x00) 
{
notasi_bebas[4]=getchar();

LCD_TulisF(0,"KANAN-WAKTU");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

tempka=notasi_bebas[4];

LCD_GotoXY(0,1);    LCD_Angka3(notasi_bebas[3]);                        
LCD_GotoXY(8,1);    LCD_Angka3(notasi_bebas[4]);

SetDataMotorPID(notasi_bebas[3],(tempka*-1));

delay_ms(notasi_bebas[2]*1000);

SetDataMotorPID(0,0); 
}
else if(notasi_bebas[1]==0x01) 
{
signed short int Enkoder_t=0;
float wL,wR,heading=0,teta=0;    
Enkoder1=0;Enkoder2=0;

LCD_TulisF(0,"KANAN-DERAJAT");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(13,1);    LCD_Angka3(notasi_bebas[2]);                        

tempka=notasi_bebas[3];

SetDataMotorPID(0,0); 
delay_ms(500);

SetDataMotorPID(notasi_bebas[3],(tempka*-1));

while(heading <= notasi_bebas[2])
{
Enkoder_t = ((Enkoder1+(Enkoder2*-1))/2);

wL=Enkoder1*(3.141592654*6.4  )/283;
wR=Enkoder2*(3.141592654*6.4  )/283;

teta=(wL-wR)/15.5 ;
heading=teta*(float) 57.295779513082320876798154814105  ;

LCD_GotoXY(0,1);    LCD_Angka4(teta);      LCD_Data(' ');
LCD_GotoXY(6,1);    LCD_Angka4(heading);   LCD_Data(' ');
}

SetDataMotorPID(0,0); 
}
}

else if(notasi_bebas[0]==0x03)
{                        
signed short int tempki;
if(notasi_bebas[1]==0x00) 
{
notasi_bebas[4]=getchar();

LCD_TulisF(0,"KIRI-WAKTU");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

tempki=notasi_bebas[3];

LCD_GotoXY(0,1);    LCD_Angka3(notasi_bebas[3]);                        
LCD_GotoXY(8,1);    LCD_Angka3(notasi_bebas[4]);

SetDataMotorPID((tempki*-1),notasi_bebas[4]);

delay_ms(notasi_bebas[2]*1000);

SetDataMotorPID(0,0); 
}

else if(notasi_bebas[1]==0x01) 
{
signed short int Enkoder_t=0;
float wL,wR,heading=0,teta=0;    
Enkoder1=0;Enkoder2=0;

LCD_TulisF(0,"KIRI-DERAJAT");
sprintf(xstring,"%d %d %d",notasi_bebas[2],notasi_bebas[3],notasi_bebas[4]);

LCD_GotoXY(13,1);    LCD_Angka3(notasi_bebas[2]);                        

SetDataMotorPID(0,0); 
delay_ms(500);

tempki=notasi_bebas[3];

SetDataMotorPID((tempki*-1),notasi_bebas[3]);

while(heading <= notasi_bebas[2])
{
Enkoder_t = ((Enkoder1+(Enkoder2*-1))/2);

wL=Enkoder1*(3.141592654*6.4  )/283;
wR=Enkoder2*(3.141592654*6.4  )/283;

teta=((wL-wR)/15.5 )*-1;
heading=teta*(float) 57.295779513082320876798154814105  ;

LCD_GotoXY(0,1);    LCD_Angka4(teta);      LCD_Data(' ');
LCD_GotoXY(6,1);    LCD_Angka4(heading);   LCD_Data(' ');
}

SetDataMotorPID(0,0); 
}
}
}

void Dinding()
{
LCD_Hapus();

notasi_dinding[0]=getchar(); 
notasi_dinding[1]=getchar(); 
notasi_dinding[2]=getchar(); 
notasi_dinding[3]=getchar(); 
notasi_dinding[4]=getchar(); 

if(notasi_dinding[0]==0x00)
{                        
signed short int SpeedWall = notasi_dinding[4]*4;

if(notasi_dinding[1]==0x00) 
{
LCD_Hapus();
LCD_TulisF(0,"GARIS-KIRI");

for(i=notasi_dinding[2];i>0;i--)
{
GarisDindingKi(SpeedWall,notasi_dinding[3],(unsigned char) 0B01000000);
Buzzer(1046,20);
}                       
}
else if(notasi_dinding[1]==0x01) 
{
LCD_Hapus();
LCD_TulisF(0,"WAKTU-KIRI");
WaktuDindingKi(SpeedWall,notasi_dinding[3],notasi_dinding[2]);
Buzzer(1046,20);                      
}
}

else if(notasi_dinding[0]==0x01)
{            
signed short int SpeedWall = notasi_dinding[4]*4;

if(notasi_dinding[1]==0x00) 
{
LCD_Hapus();
LCD_TulisF(0,"GARIS-KANAN");

for(i=notasi_dinding[2];i>0;i--)
{
GarisDindingKa(SpeedWall,notasi_dinding[3],(unsigned char) 0B01000000);
Buzzer(1046,20);               
}
}
else if(notasi_dinding[1]==0x01) 
{
LCD_Hapus();
LCD_TulisF(0,"WAKTU-KANAN");

WaktuDindingKa(SpeedWall,notasi_dinding[3],notasi_dinding[2]);
Buzzer(1046,20);           
}
}    
}

void Garis()
{
LCD_Hapus();

notasi_garis[0]=getchar();
notasi_garis[1]=getchar();
notasi_garis[2]=getchar();

if(notasi_garis[0]==0x00)
{                        
if(notasi_garis[1]==0x00) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"3KANAN-KANAN");

LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;

Scan3Kanan(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
LCD_GotoXY(8,1);    LCD_Angka3(1);
Buzzer(1046,20);

BelKaPWM(SpeedGaris,-SpeedGaris,(unsigned char) 0B01000000);
LCD_GotoXY(8,1);    LCD_Angka3(2);
Buzzer(1046,20);   
}
else if(notasi_garis[1]==0x01) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"3KANAN-LURUS");

LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;

Scan3Kanan(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
LCD_GotoXY(8,1);    LCD_Angka3(1);

Buzzer(1046,20);            
}
}

else if(notasi_garis[0]==0x01)
{            
if(notasi_garis[1]==0x00) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"3KIRI-KIRI");

LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;
Buzzer(1046,20);

Scan3Kiri(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
BelKiPWM(-SpeedGaris,SpeedGaris,(unsigned char) 0B01000000);
Buzzer(1046,20);            
}
else if(notasi_garis[1]==0x01) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"3KIRI-LURUS");
LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;

Scan3Kiri(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
Buzzer(1046,20);            
}
}

else if(notasi_garis[0]==0x02)
{
if(notasi_garis[1]==0x00) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"PEREMPATAN-KANAN");

LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;
Buzzer(1046,20);

ScanPerempatan(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
BelKaPWM(SpeedGaris,-SpeedGaris,(unsigned char) 0B01000000);
Buzzer(1046,20);   
}
else if(notasi_garis[1]==0x01) 
{
signed short int SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"PEREMPATAN-KIRI");

LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;
Buzzer(1046,20);

ScanPerempatan(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
BelKiPWM(-SpeedGaris,SpeedGaris,(unsigned char) 0B01000000);
Buzzer(1046,20);            
}
else if(notasi_garis[1]==0x02) 
{
signed short int SpeedGaris,Enkoder_t=0;    
Enkoder1=0;Enkoder2=0;

LCD_Hapus();
LCD_TulisF(0,"PEREMPATAN-LURUS");
LCD_GotoXY(0,1);    LCD_Angka3(notasi_garis[2]);

SpeedGaris = notasi_garis[2]*4;
Buzzer(1046,20);

ScanPerempatan(SpeedGaris,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
SetDataMotorPWM(SpeedGaris,SpeedGaris);
while(Enkoder_t <= 2*283/(3.141592654*6.4  ))
{
Enkoder_t = (Enkoder1+Enkoder2)/2;
LCD_GotoXY(0,1);    LCD_Angka4(Enkoder1);   LCD_Data(' ');
LCD_GotoXY(6,1);    LCD_Angka4(Enkoder2);   LCD_Data(' ');
}
SetDataMotorPWM(0,0);

Buzzer(1046,20);            
}        
}

else if(notasi_garis[0]==0x03)
{
unsigned short int i,TimeJalanBebas,SpeedGaris;
LCD_Hapus();
LCD_TulisF(0,"JALAN BEBAS");   

TimeJalanBebas=notasi_garis[1];
SpeedGaris = notasi_garis[2]*4;

for(i=0;i<TimeJalanBebas;i++)
{
usCounter=0;
while(usCounter<=40000) 
{
ScanGaris(SpeedGaris,(unsigned char) 0B01000000);
}
}

SetDataMotorPWM(0,0);
Buzzer(1046,20);
}
}

void Alarm()
{
unsigned short int Freq_Alarm = 1046;

LCD_Hapus();
notasi_buzzer[0]=getchar();

if(notasi_buzzer[0]==0)
{
notasi_buzzer[1]=getchar();
LCD_TulisF(0,"Buzzer Status:");
LCD_TulisF(1,"ON");

Buzzer(Freq_Alarm,notasi_buzzer[1]*1000);

LCD_Hapus();
LCD_TulisF(0,"Buzzer Status:");
LCD_TulisF(1,"OFF");    
}

if(notasi_buzzer[0]==1)
{
notasi_buzzer[1]=getchar();
notasi_buzzer[2]=getchar();
notasi_buzzer[3]=getchar();

for(i=0;i<notasi_buzzer[3];i++)
{
LCD_Hapus();
LCD_TulisF(0,"Buzzer Status:");
LCD_TulisF(1,"ON");
LCD_GotoXY(14,1);
LCD_Data(i+48);

Buzzer(Freq_Alarm,notasi_buzzer[1]*1000);

LCD_Hapus();
LCD_TulisF(0,"Buzzer Status:");
LCD_TulisF(1,"OFF");
LCD_GotoXY(14,1);
LCD_Data(i+49);

delay_ms(notasi_buzzer[2]*1000);
}     
}

if(notasi_buzzer[0]==2)
{
LCD_Hapus();
LCD_TulisF(0," -=Buzzer Nada=-");

for(i=0;i<78;i++)
{
Buzzer(Melodi[i],Tempo[i]*13);
}        
}    
}

void Lcd()
{
if(flag_aksi==0x08)
{
LCD_Hapus();
LCD_TulisF(0,"PESAN :");

notasi_lcd[0]=getchar();
for(i=0;i<notasi_lcd[0];i++)
{
notasi_lcd[i+1]=getchar();
LCD_GotoXY(i,1);
LCD_Data(notasi_lcd[i+1]);                        
}                               
}
}

void Tunda()
{
LCD_Hapus();
LCD_TulisF(0,"DELAY");

notasi_delay[0]=getchar();                        
for(i=notasi_delay[0];i>0;i--)
{
LCD_GotoXY(0,1);
LCD_Angka3(i-1);                        
delay_ms(1000);   
}

}

void Gripper()
{
LCD_Hapus();

notasi_gripper[0]=getchar();
notasi_gripper[1]=getchar();

if(notasi_gripper[0]==0)
{
if(notasi_gripper[1]==0)
{
LCD_TulisF(0,"GRIPPER:");
LCD_TulisF(1,"BUKA ");
SudutServo7(60);
SudutServo8 (120);  
}
else if(notasi_gripper[1]==1)
{
LCD_TulisF(0,"GRIPPER:");
LCD_TulisF(1,"TUTUP");
SudutServo7(120);
SudutServo8 (60);              
}
else if(notasi_gripper[1]==2)
{
notasi_gripper[2]=getchar();  

LCD_TulisF(0,"GRIPPER:");
LCD_TulisF(1,"VARIATIF : ");
LCD_Angka3(notasi_gripper[2]);
SudutServo7(notasi_gripper[2]);  
}
}

if(notasi_gripper[0]==1)
{
if(notasi_gripper[1]==0)
{
LCD_TulisF(0,"LENGAN:");
LCD_TulisF(1,"NAIK");
SudutServo6(70);  
}
else if(notasi_gripper[1]==1)
{
LCD_TulisF(0,"LENGAN:");
LCD_TulisF(1,"TURUN");
SudutServo6(160);  
}
else if(notasi_gripper[1]==2)
{
notasi_gripper[2]=getchar();  

LCD_TulisF(0,"LENGAN:");
LCD_TulisF(1,"SUDUT : ");
LCD_Angka3(notasi_gripper[2]);
SudutServo6(notasi_gripper[2]);  
}
}

if(notasi_gripper[0]==2)
{
if(notasi_gripper[1]==0)
{
LCD_TulisF(0,"POLA:");
LCD_TulisF(1,"ANGKAT");

delay_ms(1000);

SudutServo6(160);         
SudutServo7(20);        
SudutServo8 (160);

delay_ms(500);
SetDataMotorPID(1,1);delay_ms(500);SetDataMotorPID(0,0); 
SudutServo7(120);        
SudutServo8 (60);
delay_ms(500);

for(i=160;i>70;i--)
{
SudutServo6(i);
delay_ms(15);
}

delay_ms(500);    
}
else if(notasi_gripper[1]==1)
{
LCD_TulisF(0,"POLA:");
LCD_TulisF(1,"TARUH");

for(i=70;i<160;i++)
{
SudutServo6(i);
delay_ms(15);
}
delay_ms(500);
SudutServo7(20);        
SudutServo8 (160);
delay_ms(500);
SetDataMotorPID(-1,-1);delay_ms(500);SetDataMotorPID(0,0); 
SudutServo7(120);        
SudutServo8 (60);
delay_ms(500);
}
}
}

void main(void)
{   
delay_ms(1000);

SystemInit();
SetDataMotorPID(0,0);

Greeting();

while(1)
{                
LCD_Hapus();
LCD_TulisF(0,"StandBy.........."); 
delay_ms(500);

while(!PINC.3)
{
delay_ms(100);
while(!PINC.3){}

while(1)
{
LCD_Hapus();
LCD_TulisF(0,"GOOOOOO........."); 

while(getchar()==0xFF)
{
flag_aksi=getchar();
Buzzer(1046,20);

if(flag_aksi==0x00)
{
Bebas();                
}

if(flag_aksi==0x01)
{
notasi_tes[0]=getchar();
if(notasi_tes[0]==0x00)
{
ScanPerempatan(150,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
}
else if(notasi_tes[0]==0x01)
{
Scan3Kanan(150,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
}
else if(notasi_tes[0]==0x02)
{
Scan3Kiri(150,(unsigned char) 0B01000000,(unsigned char) 0B01000000);
}
else if(notasi_tes[0]==0x03)
{
BelKaPWM(150,-150,(unsigned char) 0B01000000);
}
else if(notasi_tes[0]==0x04)
{
BelKiPWM(-150,150,(unsigned char) 0B01000000);
}                        

}

if(flag_aksi==0x04)
{
Dinding();                                    
}

if(flag_aksi==0x05)
{
Garis();                   
}

if(flag_aksi==0x06)
{
Gripper();                   
}

if(flag_aksi==0x07)
{
Alarm();
}

if(flag_aksi==0x08)
{
Lcd();
}

if(flag_aksi==0x09)
{
Tunda();                              
}
}
}
}
while(!PINC.2)
{
KalibrasiHitamPutihEx(0,(unsigned char) 0B11000000);
}
while(!PINC.1)
{
LCD_Hapus();
LCD_TulisF(0,"SET PID");
LCD_TulisF(1,"1: KP   2: KD");
delay_ms(500);

while(1)
{
if(!PINC.3)
{
while(PINC.0)
{
LCD_Hapus();
LCD_TulisF(0,"KP");
LCD_GotoXY(0,1);    LCD_Angka3(SetKP);
delay_ms(100);

if(PINC.3==0)
{
delay_ms(100);
SetKP++;
}
else if (PINC.2==0)
{
delay_ms(100);
SetKP--;            
}                
}

delay_ms(1000);
}
else if (!PINC.2)
{
while(PINC.0)
{
LCD_Hapus();
LCD_TulisF(0,"KD");
LCD_GotoXY(0,1);    LCD_Angka3(SetKD);
delay_ms(100);

if(PINC.3==0)
{
delay_ms(100);
SetKD++;
}
else if (PINC.2==0)
{
delay_ms(100);
SetKD--;            
}        
}

delay_ms(1000);
}
else if (!PINC.0){LCD_Hapus();delay_ms(1000);break;}
}
}        
while(!PINC.0)
{            

}
}
}
