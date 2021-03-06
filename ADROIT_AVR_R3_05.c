/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.8d Professional
Automatic Program Generator
� Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho
Company : ER2C
Comments: 
Proc: ATMega128 @ 16MHz


Chip type           : ATmega128
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include <mem.h>
  
           
// Definisi Port LCD 
#define LCD_PORT        PORTA
#define LCD_RS          PORTA.0
#define LCD_RW          PORTA.1
#define LCD_EN          PORTA.2
#define LCD_BL          PORTA.3
bit LCD_BackLight;

// Definisi Port Servo
#define P_Servo1        PORTD.4
#define P_Servo2        PORTD.5
#define P_Servo3        PORTD.6
#define P_Servo4        PORTD.7
#define P_Servo1_4T     PORTD
#define P_Servo1_4B     PIND

#define P_Servo5        PORTB.3
#define P_Servo6        PORTB.5 // OCR1A
#define P_Servo7        PORTB.6 // OCR1B
#define P_Servo8        PORTB.7 // OCR1C  


// Definisi Port Push Button
#define PB1             PINC.3
#define PB2             PINC.2
#define PB3             PINC.1
#define PB4             PINC.0

// Definisi Port LED
#define LED1            PORTC.4
#define LED2            PORTC.5
#define LED3            PORTC.6
#define LED4            PORTC.7

// Definisi Port Motor
#define PwmM1H          OCR3BH
#define PwmM1L          OCR3BL
#define DirM1           PORTE.5
#define PwmM2H          OCR3AH
#define PwmM2L          OCR3AL
#define DirM2           PORTE.2

// Definisi Port Enkoder Motor
#define P_Enkoder1A     PINE.6 //INT6
#define P_Enkoder1B     PINB.0
#define P_Enkoder2A     PINE.7 //INT7
#define P_Enkoder2B     PINB.2

// Definisi Port Mode
#define MODE            PING
#define MODE1           ((PING & 16)==0 ? 0:1)
#define MODE2           ((PING & 4) ==0 ? 0:1)
#define MODE3           ((PING & 2) ==0 ? 0:1)
#define MODE4           ((PING & 1) ==0 ? 0:1)  

// Definisi Nada Buzzer
#define C4 261
#define CS4 277
#define D4 293
#define DS4 311
#define E4 329
#define F4 349
#define FS4 370
#define G4 392
#define GS4 415
#define A4 440
#define AS4 466
#define B4 494

#define C5 523
#define CS5 554
#define D5 587
#define DS5 622
#define E5 659
#define F5 698
#define FS5 740
#define G5 783
#define GS5 830
#define A5 880
#define AS5 932
#define B5 987

#define C6 1046
#define CS6 1109
#define D6 1174
#define DS6 1244
#define E6 1318
#define F6 1370
#define FS6 1480
#define G6 1568
#define GS6 1661
#define A6 1760
#define AS6 1864
#define B6 1975

#define C7 2093
#define CS7 2217
#define D7 2349
#define DS7 2489
#define E7 2639
#define F7 2793
#define FS7 2960
#define G7 3136
#define GS7 3322
#define A7 3520
#define AS7 3729
#define B7 3951 

//Super Mario --> 78 Nada
int flash Melodi[] = {
  E7, E7,  0, E7, 0, C7, E7, 0, G7,  0,  0,  0, G6,  0,  0, 0, 
  C7,  0,  0, G6, 0,  0, E6, 0,  0, A6,  0, B6,  0,AS6, A6, 0, 
  G6, E7, G7, A7, 0, F7, G7, 0, E7,  0, C7, D7, B6,  0,  0,
  C7,  0,  0, G6, 0,  0, E6, 0,  0, A6,  0, B6,  0,AS6, A6, 0, 
  G6, E7, G7, A7, 0, F7, G7, 0, E7,  0, C7, D7, B6,  0,  0};  

unsigned char flash Tempo[] = {
  150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150, 
  150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150, 
  175,175,175,120,150,150,150,150,150,150,150,150,150,150,150,
  150,150,150,150,150,150,150,150,150,150,150,150,150,150,150,150, 
  175,175,175,120,150,150,150,150,150,150,150,150,150,150,150};

#define dServo6 OCR1A
#define dServo7 OCR1B
#define M1_CW   (DirM1 = 0)
#define M1_CCW  (DirM1 = 1)
#define M2_CCW  (DirM2 = 0)
#define M2_CW   (DirM2 = 1)
#define ByteL(a)    ((unsigned char) (a))
#define ByteH(a)    ((unsigned char) (((unsigned int) (a)) >> 8))

// Variabel Global
register unsigned int   ServoCounter;
register signed int     Enkoder1, Enkoder2;
unsigned char           dCounter1, dCounter2;
unsigned char           SysTick=0; 
unsigned char           dServo5, dServo1, dServo2, dServo3, dServo4, dSpeed1, dSpeed2;;
signed char             dMotor1, dMotor2;
bit LaguOn=0;
bit PIDMotorOn=0;

#define BacadServo8   peekw(&OCR1CL)
#define BacaPwmM1     peekw(&OCR3BL)
#define BacaPwmM2     peekw(&OCR3AL)

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 8
char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1<256
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
#else
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char status,data;

status=UCSR1A;
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer1[rx_wr_index1]=data;
   if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
   if (++rx_counter1 == RX_BUFFER_SIZE1)
      {
      rx_counter1=0;
      rx_buffer_overflow1=1;
      };
   };
}

// Get a character from the USART1 Receiver buffer
#pragma used+
char getchar1(void)
{
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-
// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-


// Rotari Enkoder Motor 1
interrupt [EXT_INT6] void ext_int6_isr(void)
{ if(P_Enkoder1A)
  {  if(P_Enkoder1B) {#asm("cli")  Enkoder1--; #asm("sei")}
     else            {#asm("cli")  Enkoder1++; #asm("sei")}
  }
  else
  {  if(P_Enkoder1B) {#asm("cli")  Enkoder1++; #asm("sei")}
     else            {#asm("cli")  Enkoder1--; #asm("sei")}
  }
  dCounter1++;        
}

// Rotari Enkoder Motor 2
interrupt [EXT_INT7] void ext_int7_isr(void)
{ if(P_Enkoder2A)
  {  if(P_Enkoder2B) {#asm("cli")  Enkoder2--; #asm("sei")}
     else            {#asm("cli")  Enkoder2++; #asm("sei")}
  }
  else
  {  if(P_Enkoder2B) {#asm("cli")  Enkoder2++; #asm("sei")}
     else            {#asm("cli")  Enkoder2--; #asm("sei")}
  }
  dCounter2++;        
}


// Interupsi dengan frekwensi 40KHz -- Timer 3 output compare C interrupt service routine
interrupt [TIM3_COMPC] void timer3_compc_isr(void)
{  if (++ServoCounter<=80)
   {    if ((unsigned char)ServoCounter==dServo1) {P_Servo1=0;}
        if ((unsigned char)ServoCounter==dServo2) {P_Servo2=0;}
        if ((unsigned char)ServoCounter==dServo3) {P_Servo3=0;}
        if ((unsigned char)ServoCounter==dServo4) {P_Servo4=0;}
        if ((unsigned char)ServoCounter==dServo5) {P_Servo5=0;}
   }
   else if (ServoCounter>=800)
   {    ServoCounter = 0;
        //P_Servo1_4T = P_Servo1_4B | 0xF0; // 
        P_Servo1 = 1;    P_Servo2 = 1;    P_Servo3 = 1;    P_Servo4 = 1;
        P_Servo5 = 1;
   }
}

// Fungsi LCD
#pragma used+
void LCD_Init_Cmd(unsigned char xData)
{   LCD_PORT =  0B00000100 | (xData & 0xF0);
    delay_us(1);        LCD_EN = 0;
}
void LCD_Perintah(unsigned char xData)
{   //LCD_RS=0;   LCD_RW=0;   LCD_EN=1;       
    LCD_RS=0;
    LCD_PORT =  0B00001100 | (xData & 0xF0);
    delay_us(1);     LCD_EN = 0;
    delay_us(5);
    LCD_PORT =  0B00001100 | (xData << 4);
    delay_us(1);     LCD_EN = 0;
    delay_us(700);  
    LCD_EN = 1;
}
#pragma used-
#pragma used+
void LCD_Data(unsigned char xData)
{   //LCD_RS=1;   LCD_RW=0;   LCD_EN=1;
    LCD_RS=1;
    LCD_PORT =  0B00001101 | (xData & 0xF0);
    delay_us(1);     LCD_EN = 0;
    delay_us(5);
    LCD_PORT =  0B00001101 | (xData << 4);
    delay_us(1);     LCD_EN = 0;
    delay_us(40);
    LCD_EN = 1;
}
#pragma used-
#pragma used+
void LCD_Init(void)
{   delay_ms(50);   LCD_Init_Cmd(0x30);
    delay_ms(5);    LCD_Init_Cmd(0x30);
    delay_ms(1);    LCD_Init_Cmd(0x30);
    delay_ms(1);    LCD_Init_Cmd(0x20);
    LCD_Perintah(0x28);         //4-bit/2-line
    LCD_Perintah(0x10);         // Set cursor
    LCD_Perintah(0x0c);         // Display ON; Cursor off
    LCD_Perintah(0x06);         // Entry mode =increment, no shift
    LCD_Perintah(0x01);         // Hapus layar
}            
#pragma used-
#pragma used+
void LCD_GotoXY(unsigned char x, unsigned char y)
{   unsigned char baris;
    if (y==0) LCD_Perintah(0x80 + x);          // baris 1 --> y=0
    else      LCD_Perintah(0x80 + x + 0x40);   // baris 2 --> y=1 
}
#pragma used-
#pragma used+
void LCD_Tulis(unsigned char flash *text)        // menuliskan string ke LCD
{   while (*text!=0)
    { LCD_Data(*text);text++;}
}
#pragma used-
#pragma used+
void LCD_Tulis1(unsigned char flash *text)        // menuliskan string ke LCD
{   LCD_GotoXY(0,0);LCD_Tulis(text); 
}
#pragma used-
#pragma used+
void LCD_Tulis2(unsigned char flash *text)        // menuliskan string ke LCD
{   LCD_GotoXY(0,1);LCD_Tulis(text); 
}
#pragma used-
#pragma used+
void LCD_Hapus(void)              // menghapus seluruh layar
{   LCD_Perintah(0x01);
}
#pragma used-
#pragma used+
void LCD_Hapus1(void)             // menghapus baris pertama
{   unsigned char i;
    LCD_GotoXY(0,0);
    for(i=0;i<16;i++) LCD_Data(' ');
}
#pragma used-
#pragma used+
void LCD_Hapus2(void)             // menghapus baris ke dua
{   unsigned char i;
    LCD_GotoXY(0,1);
    for(i=0;i<16;i++) LCD_Data(' ');
}                   
#pragma used-
#pragma used+
void LCD_TulisKiri1(unsigned char flash *text)    // menuliskan string dari arah kiri dgn delay pada baris 1 
{   unsigned char i;
    LCD_GotoXY(0,0);
    for(i=0;i<16;i++)
    { LCD_Data(*(text+i)); delay_ms(100);}
}                                                                                           
#pragma used-
#pragma used+
void LCD_TulisKiri2(unsigned char flash *text)    // menuliskan string dari arah kiri dgn delay pada baris 2
{   unsigned char i;
    LCD_GotoXY(0,1);
    for(i=0;i<16;i++)
    { LCD_Data(*(text+i)); delay_ms(100);}
}              
#pragma used-
#pragma used+
void LCD_TulisKanan1(unsigned char flash *text)    // menuliskan string dari arah kanan dgn delay pada baris 1 
{   signed char i;
    LCD_GotoXY(0,0);
    for(i=15;i>-1;i--)
    { LCD_Perintah (0x80+i);   LCD_Data(*(text+i)); delay_ms(100);}
}                
#pragma used-
#pragma used+
void LCD_TulisKanan2(unsigned char flash *text)    // menuliskan string dari arah kanan dgn delay pada baris 2
{   signed char i;
    LCD_GotoXY(0,1);
    for(i=15;i>-1;i--)
    { LCD_Perintah (0xC0+i);   LCD_Data(*(text+i)); delay_ms(100);}
}
#pragma used-
#pragma used+
void LCD_Angka4(int x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
    LCD_Data(x/1000+0x30);          // menulis ribuan
    LCD_Data((x%1000)/100+0x30);    // menulis ratusan
    LCD_Data((x%100)/10+0x30);      // menulis puluhan
    LCD_Data(x%10+0x30);            // menulis satuan
}
#pragma used-
#pragma used+
void LCD_Angka3(int x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
    LCD_Data(x/100+0x30);           // menulis ratusan
    LCD_Data((x%100)/10+0x30);      // menulis puluhan
    LCD_Data(x%10+0x30);            // menulis satuan
}
#pragma used-                    
#pragma used+
void LCD_sByte(signed char x)
{   if(x<0){ x*=-1;  LCD_Data('-');} 
    LCD_Data(x/100+0x30);           // menulis ratusan
    LCD_Data((x%100)/10+0x30);      // menulis puluhan
    LCD_Data(x%10+0x30);            // menulis satuan
}
#pragma used-                    

// -----------------  Fungsi Buzzer ----------------------------
#pragma used+                    
void BuzzerOff()
{ TCCR0=0x00; PORTB.4=0; ASSR=0x00; }
#pragma used-                    
#pragma used+                    
void FBuzzer(unsigned int x)
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
#pragma used-                    

#pragma used+
void Nada(int Frek, unsigned char Tempo)
{  FBuzzer(Frek); delay_ms((char)(Tempo*10));}
#pragma used-

// -----------------  Fungsi Servo ----------------------------
#pragma used+
unsigned char SetSudut(unsigned int sudut)  // perubahan terkecil = 180/40 = 4,5 derajat
{   return ((sudut*4)/18 + 40);}
#pragma used-

#pragma used+
unsigned int SetSudut2(unsigned int sudut) // perubahan terkecil = 180/2000 = 0,09 derajat
{   return ((sudut*100)/9 + 2000);}
#pragma used-

#pragma used+
void SudutServo1(unsigned char posisi)
{   dServo1 = SetSudut(posisi);}
#pragma used-
#pragma used+
void SudutServo2(unsigned char posisi)
{   dServo2 = SetSudut(posisi);}
#pragma used-
#pragma used+
void SudutServo3(unsigned char posisi)
{   dServo3 = SetSudut(posisi);}
#pragma used-
#pragma used+
void SudutServo4(unsigned char posisi)
{   dServo4 = SetSudut(posisi);}
#pragma used-
#pragma used+
void SudutServo5(unsigned char posisi)
{   dServo5 = SetSudut(posisi);}
#pragma used-
#pragma used+
void SudutServo6(unsigned char posisi)
{   dServo6 = SetSudut2(posisi);}
#pragma used-
#pragma used+
void SudutServo7(unsigned char posisi)
{   dServo7 = SetSudut2(posisi);}
#pragma used-
#pragma used+
void SudutServo8(unsigned char posisi)
{ unsigned int dServo8;
  dServo8 = SetSudut2(posisi);
  OCR1CH = ByteH(dServo8);
  OCR1CL = ByteL(dServo8);
  //TulisdServo8;
}    
#pragma used-


signed char Error1, Error2;
#define MaxSpeed (signed int)   400
#define MaxIntegral             MaxSpeed
#define KPm (short int) 10
#define KDm (short int) 3
#define KIm (short int) 5

#pragma used+
void PIDmotor2(void)
{ signed int U;       
  static signed char lErrorM2=0, iErrorM2=0;
  // Menghitung PID Motor 2
  if(dMotor2>0)
  {   Error2 = (signed char)dMotor2-(signed char)dSpeed2;
      U = KPm * (Error2);//+lErrorM2);
      iErrorM2+=(Error2+lErrorM2);
      if(iErrorM2>80)      iErrorM2 = 80;
      else if(iErrorM2<-80)iErrorM2 = -80;
      U+= KIm * iErrorM2;
      if (U>MaxSpeed)
        {   PwmM2H = ByteH(MaxSpeed);  PwmM2L = ByteL(MaxSpeed);}
      else if (U>0)  
        {   PwmM2H = ByteH(U);  PwmM2L = ByteL(U);}
      else
        {    PwmM2H = 0; PwmM2L = 0;}
      lErrorM2 = Error2;       
   }
  else {PwmM2H = 0; PwmM2L = 0;    iErrorM2=0;}      
}
#pragma used-

#pragma used+
void PIDmotor1(void)
{ signed int U;       
  static signed char lErrorM1=0, iErrorM1=0;
  // Menghitung PID Motor 1
  if (dMotor1>0)
  {   Error1 = (signed char)dMotor1-(signed char)dSpeed1;
      U = KPm * (lErrorM1);//+Error1);
      iErrorM1+=(Error1+lErrorM1);
      if(iErrorM1>80)      iErrorM1 = 80;
      else if(iErrorM1<-80)iErrorM1 = -80;
      U+= KIm * iErrorM1;
      if (U>MaxSpeed)
        {   PwmM1H = ByteH(MaxSpeed);  PwmM1L = ByteL(MaxSpeed);}
      else if (U>0)  
        {   PwmM1H = ByteH(U);  PwmM1L = ByteL(U);}
      else
        {    PwmM1H = 0; PwmM1L = 0;}
      lErrorM1  = Error1;
  }
  else  {PwmM1H = 0; PwmM1L = 0; iErrorM1=0;}
}
#pragma used-

// Interupsi setiap 1 ms
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{   static unsigned char LaguTick=0, _dCounter1=0, _dCounter2=0;
    static unsigned char TempoTick=0, PIDTickMotor=0;
    SysTick++;
    if(++PIDTickMotor==4)
    {   if(dCounter1>_dCounter1)    dSpeed1 = dCounter1 - _dCounter1;
        else                        dSpeed1 = 0xFF - _dCounter1 + dCounter1 + 1;
        _dCounter1 = dCounter1;
    }
    else if (PIDTickMotor==5)       
    {   if(PIDMotorOn) PIDmotor1(); 
    }
    else if(PIDTickMotor==9)
    {   if(dCounter2>_dCounter2)    dSpeed2 = dCounter2 - _dCounter2;
        else                        dSpeed2 = 0xFF - _dCounter2 + dCounter2 + 1;
        _dCounter2 = dCounter2;
    }
    else if(PIDTickMotor>=10)
    {   if(PIDMotorOn) PIDmotor2();
        PIDTickMotor=0;  
    }   
    
    if(LaguOn)
    {   if(++TempoTick>=Tempo[LaguTick])
        {   TempoTick = 0;
            if (++LaguTick>78) LaguTick=0;
            FBuzzer(Melodi[LaguTick]);
        }        
    }
}


// ------------------- Fungsi Motor ------------------
#pragma used+
void SetDataMotor(signed char dmKa, signed char dmKi)
{   //dmKa*=2;    dmKi*=2;
    if(dmKa<0)  { dMotor2 = -dmKa;  M2_CCW; }
    else        { dMotor2 = dmKa;   M2_CW;  }
    if(dmKi<0)  { dMotor1 = -dmKi;  M1_CW; }
    else        { dMotor1 = dmKi;   M1_CCW;  }
}
#pragma used-
#pragma used+
void Maju(unsigned int Ka, unsigned int Ki)
{   PwmM2H = ByteH(Ka); PwmM2L = ByteL(Ka); M2_CW;
    PwmM1H = ByteH(Ki); PwmM1L = ByteL(Ki); M1_CCW;   
}
#pragma used-
#pragma used+
void Mundur(unsigned int Ka, unsigned int Ki)
{   PwmM2H = ByteH(Ka); PwmM2L = ByteL(Ka); M2_CCW;
    PwmM1H = ByteH(Ki); PwmM1L = ByteL(Ki); M1_CW;  
}
#pragma used-
#pragma used+
void PutarKanan(unsigned int Ka, unsigned int Ki)
{   PwmM2H = ByteH(Ka); PwmM2L = ByteL(Ka); M2_CW;
    PwmM1H = ByteH(Ki); PwmM1L = ByteL(Ki); M1_CW;   
}
#pragma used-
#pragma used+
void PutarKiri(unsigned int Ka, unsigned int Ki)
{   PwmM2H = ByteH(Ka); PwmM2L = ByteL(Ka); M2_CCW;
    PwmM1H = ByteH(Ki); PwmM1L = ByteL(Ki); M1_CCW;   
}
#pragma used-
#pragma used+
void Stop(void)
{   PwmM2H = 0; PwmM2L = 0;
    PwmM1H = 0; PwmM1L = 0;
}
#pragma used-



float  iError=0;
int KP,KI,KD;
signed char lError=0;

#pragma used+
void SetPID(int kp, int ki, int kd)
{ KP=kp;    KI=ki;  KD=kd;}
#pragma used-

#pragma used+
void ResetPID(void)
{ iError=0; lError=0; }
#pragma used-




#pragma used+
/*short int HitungPID(signed char Error)
{ float PIDTime, U; 
  PIDTime = (float)PIDTick/1000;
  PIDTick = 0;
  // Menghitung Nilai Kendali Derivatif
  U = (float)KD * (float)(Error-lError)/PIDTime;
  // Menghitung Nilai Integral Error
  iError += (float)((Error + lError)/2) * PIDTime; 
  // Membatasi Nilai Integral Error
  if((short int) iError > MaxIntegral) iError = MaxIntegral;
  else if((signed int) iError < -MaxIntegral) iError = -MaxIntegral;
  // Menambahkan Nilai Kendali Integral
  U+= (float)KI * iError;
  // Menambahkan Nilai Kendali Proporsional
  U+= (float)KP * (float)Error;
  lError = Error;
  LCD_GotoXY(0,0); LCD_Angka3(PIDTime*1000);
  return ((short int)U);
}
#pragma used-
*/
#pragma used+
void GerakRobot(short int Speed, short int U)
{ int PWMKi, PWMKa;
   // Menghitung Aktuasi Kendali pada Roda Kanan dan Kiri
  PWMKa = Speed + U;
  PWMKi = Speed - U;
  // Menghitung Kecepatan dan arah putaran Motor Roda Kanan
  if(PWMKa<0)   {PWMKa = -PWMKa; M2_CCW;}
  else          {M2_CW;}
  if (PWMKa<MaxSpeed) 
    {   PwmM2H = ByteH(PWMKa);      PwmM2L = ByteL(PWMKa);}
  else
    {   PwmM2H = ByteH(MaxSpeed);   PwmM2L = ByteL(MaxSpeed);}
  // Menghitung Kecepatan dan arah putaran Motor Roda Kiri
  if(PWMKi<0)   {PWMKi = -PWMKi; M1_CW;}
  else          {M1_CCW;}
  if (PWMKi<MaxSpeed) 
    {   PwmM1H = ByteH(PWMKi);      PwmM1L = ByteL(PWMKi);}
  else
    {   PwmM1H = ByteH(MaxSpeed);   PwmM1L = ByteL(MaxSpeed);}
   //LCD_GotoXY(0,0);    LCD_Angka3(PWMKa);
   //LCD_Data(' ');      LCD_Angka3(PWMKi);
}
#pragma used-


#pragma used+
void SystemInit(void)
{   
 //-------------- Inisialisasi Port -----------------------------------
    // Port A  = Koneksi ke LCD --> semua bit difungsikan sebagai output 
    PORTA=0x00; DDRA=0xFF;
    
    // Port B0   = Input Pull-Up (Enkoder1B)
    // Port B1   = Input (SCK - ISP programing)
    // Port B2   = Input Pull-Up (Enkoder2B)
    // Port B3   = Output (Servo 5)
    // Port B4   = Output (Buzzer)
    // Port B5-7 = Output (Servo 6-8)
    PORTB=0x05; DDRB=0xF8;

    // Port C0-3 = Output (LED Active High)
    // Port C4-7 = Input Pull-Up (Push Button Active Low)
    PORTC=0xFF; DDRC=0xF0;

    // Port D0,1 = Input (I2C)
    // Port D2,3 = Input (USART1)
    // Port D2,3 = Input (USART1)
    // Port D4-7 = Output(Servo1-4)
    PORTD=0x00; DDRD=0xF0;

    // Port E0,1 = Input (USART0, ISP programming)
    // Port E2   = Output (DirM2)
    // Port E3   = Output (PwmM2)
    // Port E4   = Output (PwmM1)
    // Port E5   = Output (DirM2)
    // Port E6,7 = Input Pull-Up (Enkoder1A,2A)
    PORTE=0xC0; DDRE=0x3C;

    // Port F  = Input (Input ADC)
    PORTF=0x00; DDRF=0x00;

    // Port G  = Input Pull-Up (Saklar Mode Active Low)
    PORTG=0x17;
    DDRG=0x00;
 
 //-------------- Inisialisasi Timer -----------------------------------
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 250,000 kHz
    // Mode: CTC top=OCR0
    // OC0 output: Toggle on compare match
    ASSR=0x00;
    TCCR0=0x00; // sementara dimatikan (diaktifkan ketika fungsi FBuzzer(Frek) dipanggil)
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 2000,000 kHz
    // Mode: Fast PWM top=ICR1
    // OC1A output: Non-Inv.
    // OC1B output: Non-Inv.
    // OC1C output: Non-Inv.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer 1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    // Compare C Match Interrupt: Off
    TCCR1A=0xAA;
    TCCR1B=0x1A;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x9c; // 40000
    ICR1L=0x40;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    OCR1CH=0x00;
    OCR1CL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 62,500 kHz
    // Mode: CTC top=OCR2
    // OC2 output: Disconnected
    //TCCR2=0x0C;       // 64,500 kHz        -- interupsi 4 ms
    TCCR2=0x0B;         // 250,000 kHz       -- interupsi 1 ms
    TCNT2=0x00;
    OCR2=0xFA;

    // Timer/Counter 3 initialization
    // Clock source: System Clock
    // Clock value: 16000,000 kHz
    // Mode: Ph. correct PWM top=ICR3
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // OC3A output: Inverted
    // OC3B output: Inverted
    // OC3C output: Discon.
    // Timer 3 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    // Compare C Match Interrupt: On
    TCCR3A=0xF2;
    TCCR3B=0x11;
    TCNT3H=0x00;
    TCNT3L=0x00;
    ICR3H=0x01;  // 400
    ICR3L=0x90;
    OCR3AH=0x00;
    OCR3AL=0x00;
    OCR3BH=0x00;
    OCR3BL=0x00;
    OCR3CH=0x00;
    OCR3CL=0xC8; // 200 
    
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
    
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: On
// INT6 Mode: Any change
// INT7: On
// INT7 Mode: Any change
    EICRA=0x00;
    EICRB=0x50;
    EIMSK=0xC0;
    EIFR=0xC0;    

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x80;
    ETIMSK=0x02;

// ------------------------ Inisialisasi USART1 ----------------------
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud rate: 9600
    UCSR1A=0x00;
    UCSR1B=0x98;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;  

// ------------  Inisialisasi Analog Comparator -----------------------
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;
                                                                       
// ------------ Inisialisasi Peripheral Board ------------------------

    LCD_Init(); // -------------------------------------- LCD Text 16x2
    
    SudutServo1(0); // -------------------------------Reset Sudut Servo
    SudutServo2(0);
    SudutServo3(0);
    SudutServo4(0);
    SudutServo5(0);
    SudutServo6(0);
    SudutServo7(0);
    SudutServo8(0);  
    
// -------------- Global enable interrupts ----------------------------
    #asm("sei") 
}
#pragma used-
           

void main(void)
{   unsigned int i; 
    SystemInit();
    //dServo1 = 20;
    //dServo2 = 80;
    Stop();
    SudutServo1(0);
    SudutServo2(45);
    SudutServo3(90);
    SudutServo4(135);
    SudutServo5(180); 
    SudutServo6(180); 
    SudutServo7(0); 
    SudutServo8(90); 
    LCD_GotoXY(0,0);    LCD_Angka3(dServo1);
    LCD_GotoXY(4,0);    LCD_Angka3(dServo2);
    LCD_GotoXY(8,0);    LCD_Angka3(dServo3);
    LCD_GotoXY(12,0);   LCD_Angka3(dServo4);
    LCD_GotoXY(0,1);    LCD_Angka3(dServo5);
    LCD_GotoXY(4,1);    LCD_Angka4(dServo6);
    LCD_GotoXY(8,1);    LCD_Angka4(dServo7);
    LCD_GotoXY(12,1);   LCD_Angka4(BacadServo8); 
    
    //i = OCR1CL + OCR1CH*256;
    //LCD_GotoXY(12,1);   LCD_Angka4(i);
    
    PIDMotorOn = 1;
    SetDataMotor(10,10);
               
    while (1)
      {
      // Place your code here
        
         LCD_BackLight = 1;  
         //LCD_Tulis1("1234567890123456");
         //LCD_Tulis2("1234567890123456");
         //LED1 = !PB1 ^ MODE1;
         LED2 = !PB2 ^ MODE2;
         LED3 = !PB3 ^ MODE3;
         LED4 = !PB4 ^ MODE4;
        
        /*LCD_GotoXY(0,1);
        LCD_Angka4(Enkoder1); 
        LCD_Data(' ');     
        LCD_GotoXY(6,1);
        LCD_Angka4(Enkoder2);      
        LCD_Data(' ');     
        *///PID(50,0);
        //Stop();  
        SetDataMotor(7,7);
        for(i=0;i<1000;i++)
        {   LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        SetDataMotor(1,1);
        for(i=0;i<1000;i++)
        {   LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        SetDataMotor(0,0);
        for(i=0;i<500;i++)
        {   LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        SetDataMotor(-1,-1);
        for(i=0;i<1000;i++)
        {   //PIDTick=0; while(PIDTick<10); 
            //PIDmotor();
            LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        SetDataMotor(-7,-7);
        for(i=0;i<1000;i++)
        {   //PIDTick=0; while(PIDTick<10); 
            //PIDmotor();
            LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        SetDataMotor(0,0);
        for(i=0;i<500;i++)
        {   //PIDTick=0; while(PIDTick<10); 
            //PIDmotor();
            LCD_GotoXY(0,0);  LCD_Angka4(Enkoder2);
            LCD_Data(' ');    LCD_sByte(Error2);    LCD_Data(' ');
            LCD_GotoXY(0,1);  LCD_Angka4(Enkoder1);
            LCD_Data(' ');    LCD_sByte(Error1);    LCD_Data(' ');
        }
        
        //LaguOn=1;  
       // for(i=0;i<100;i++)
     /*   LCD_GotoXY(0,1);
        LCD_sByte(dMotor1); 
        LCD_Data(' ');     
        LCD_GotoXY(6,1);
        LCD_sByte(dMotor2);      
        LCD_Data(' '); */    
      };
}
