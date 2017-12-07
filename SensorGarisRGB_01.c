/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/19/2014
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>


// protokol untuk sensor garis terbagi atas:
// 4 bit identifikasi perintah (bit 4-7)
// 4 bit identifikasi alamat sensor (bit 0-3) --> Alamat Sensor bernilai antara 0-15

#define pBacaSensorRGB  (unsigned char) 0B01110000
#define pBacaSensorRG   (unsigned char) 0B01100000
#define pBacaSensorRB   (unsigned char) 0B01010000
#define pBacaSensorGB   (unsigned char) 0B00110000
#define pBacaSensorR    (unsigned char) 0B01000000
#define pBacaSensorG    (unsigned char) 0B00100000
#define pBacaSensorB    (unsigned char) 0B00010000
#define pKalibrasiRGB   (unsigned char) 0B11110000
#define pKalibrasiRB    (unsigned char) 0B11010000
#define pKalibrasiRG    (unsigned char) 0B11100000
#define pKalibrasiHPR   (unsigned char) 0B11000000
#define pKalibrasiHPG   (unsigned char) 0B10100000
#define pKalibrasiHPB   (unsigned char) 0B10010000
#define pError          (unsigned char) 0B00000000

/*
#define pBacaSensorRGB  (uint8_t) 0B01110000
#define pBacaSensorRG   (uint8_t) 0B01100000
#define pBacaSensorRB   (uint8_t) 0B01010000
#define pBacaSensorGB   (uint8_t) 0B00110000
#define pBacaSensorR    (uint8_t) 0B01000000
#define pBacaSensorG    (uint8_t) 0B00100000
#define pBacaSensorB    (uint8_t) 0B00010000
#define pKalibrasiRGB   (uint8_t) 0B11110000
#define pKalibrasiRB    (uint8_t) 0B11010000
#define pKalibrasiRG    (uint8_t) 0B11100000
#define pKalibrasiHPR   (uint8_t) 0B11000000
#define pKalibrasiHPG   (uint8_t) 0B10100000
#define pKalibrasiHPB   (uint8_t) 0B10010000
#define pError          (uint8_t) 0B00000000
 */

register unsigned char DeviceAddress;
unsigned char ThresholdR[8], ThresholdG[8], ThresholdB[8];
eeprom unsigned char _ThresholdR[8], _ThresholdG[8], _ThresholdB[8], _Mode, _DeviceAddress;


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

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
register unsigned char xData; 
unsigned char status;
status=UCSRA;
xData=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0  && ((xData & 0xF)==DeviceAddress) )
   {
   rx_buffer[rx_wr_index++]=xData & 0xF0;   // mengambil 4 bit nibble atas
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
unsigned char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// active Low
#define En0     PORTB.1
#define En1     PORTB.2
#define En2     PORTB.3
#define En3     PORTB.4
#define En4     PORTD.5                     
#define En5     PORTD.2
#define En6     PORTD.3
#define En7     PORTD.4
#define LED     PORTB.5


// active high
#define EnR     PORTD.7
#define EnB     PORTB.0
#define EnG     PORTD.6

// adc channel
#define Data0   6
#define Data1   7
#define Data2   1
#define Data3   0
#define Data4   2
#define Data5   3        
#define Data6   4
#define Data7   5

#define DelayOff    (delay_us(15))
#define DelayOn     (delay_us(25))

#define ADC_VREF_TYPE 0x20


// Read the 8 most significant bits
// of the AD conversion result
void StartADC(unsigned char adc_input)
{   ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    delay_us(10);   // Delay menunggu input tegangan stabil
    ADCSRA|=0x40;   // Start Konversi ADC
    delay_us(5);    // waktu Sample and Hold 
}

unsigned char BacaADC()
{   while ((ADCSRA & 0x10)==0);     // menunggu proses konversi
    ADCSRA|=0x10;                   // Stop konversi
    return ADCH;                    // mengembalikan data hasil konversi
}

unsigned char BacaSensorDebug(unsigned char * Threshold)
{       register unsigned char AdcGelap, AdcTerang;
        register unsigned char Sensor=0; 
        En0 = 1;    En1 = 1;    En2 = 1;    En3 = 1;
        En4 = 1;    En5 = 1;    En6 = 1;    En7 = 1;
        // Sensor 0
        DelayOff;   StartADC(Data0);    En0=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data0);    En0=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+0));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+0)) Sensor |=1; 
        }
        // Sensor 1
        DelayOff;   StartADC(Data1);    En1=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data1);    En1=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+1));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+1)) Sensor |=2; 
        }
        // Sensor 2
        DelayOff;   StartADC(Data2);    En2=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data2);    En2=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+2));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+2)) Sensor |=4; 
        }
        // Sensor 3
        DelayOff;   StartADC(Data3);    En3=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data3);    En3=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+3));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+3)) Sensor |=8; 
        }
        // Sensor 4
        DelayOff;   StartADC(Data4);    En4=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data4);    En4=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+4));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+4)) Sensor |=16; 
        }
        // Sensor 5
        DelayOff;   StartADC(Data5);    En5=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data5);    En5=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+5));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+5)) Sensor |=32; 
        }
        // Sensor 6
        DelayOff;   StartADC(Data6);    En6=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data6);    En6=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+6));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+6)) Sensor |=64; 
        }
        // Sensor 7
        DelayOff;   StartADC(Data7);    En7=0;  AdcGelap = BacaADC();      
        DelayOn;    StartADC(Data7);    En7=1;  AdcTerang = BacaADC();     
        putchar (AdcGelap);
        putchar (AdcTerang);
        putchar (*(Threshold+7));
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+7)) Sensor |=128; 
        }
        EnR = 0;    EnG = 0;   EnB = 0;                
        return (Sensor);
}

unsigned char BacaSensor(unsigned char * Threshold)
{       register unsigned char AdcGelap, AdcTerang;
        register unsigned char Sensor=0; 
        En0 = 1;    En1 = 1;    En2 = 1;    En3 = 1;
        En4 = 1;    En5 = 1;    En6 = 1;    En7 = 1;
        // Sensor 0
        DelayOff;   StartADC(Data0);    En0=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data0);    En0=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+0)) Sensor |=1; 
        }
        // Sensor 1
        DelayOff;   StartADC(Data1);    En1=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data1);    En1=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+1)) Sensor |=2; 
        }
        // Sensor 2
        DelayOff;   StartADC(Data2);    En2=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data2);    En2=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+2)) Sensor |=4; 
        }
        // Sensor 3
        DelayOff;   StartADC(Data3);    En3=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data3);    En3=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+3)) Sensor |=8; 
        }
        // Sensor 4
        DelayOff;   StartADC(Data4);    En4=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data4);    En4=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+4)) Sensor |=16; 
        }
        // Sensor 5
        DelayOff;   StartADC(Data5);    En5=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data5);    En5=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+5)) Sensor |=32; 
        }
        // Sensor 6
        DelayOff;   StartADC(Data6);    En6=0;  AdcGelap = BacaADC();   
        DelayOn;    StartADC(Data6);    En6=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+6)) Sensor |=64; 
        }
        // Sensor 7
        DelayOff;   StartADC(Data7);    En7=0;  AdcGelap = BacaADC();      
        DelayOn;    StartADC(Data7);    En7=1;  AdcTerang = BacaADC();     
        if(AdcGelap<AdcTerang)
        {   if((AdcTerang-AdcGelap)>*(Threshold+7)) Sensor |=128; 
        }
        EnR = 0;    EnG = 0;   EnB = 0;                
        return (Sensor);
}

void ReloadThreshold()
{   unsigned char i;
    for(i=0;i<8;i++)   
    {   ThresholdR [i] = _ThresholdR [i];
        ThresholdG [i] = _ThresholdG [i];
        ThresholdB [i] = _ThresholdB [i];
    }    
}

void UpdateThresholdR()
{   unsigned char i;
    for(i=0;i<8;i++)    _ThresholdR [i] = ThresholdR [i];
}
void UpdateThresholdG()
{   unsigned char i;
    for(i=0;i<8;i++)    _ThresholdG [i] = ThresholdG [i];
}

void UpdateThresholdB()
{   unsigned char i;
    for(i=0;i<8;i++)    _ThresholdB [i] = ThresholdB [i];
}


unsigned char BacaSensorMerah(void)
{       EnR = 1;    EnG = 0;   EnB = 0;                
        return (BacaSensor(&ThresholdR[0]));
} 

unsigned char BacaSensorHijau(void)
{       EnR = 0;    EnG = 1;   EnB = 0;                
        return (BacaSensor(&ThresholdG[0]));
}    

unsigned char BacaSensorBiru(void)
{       EnR = 0;    EnG = 0;   EnB = 1;                
        return (BacaSensor(&ThresholdB[0]));
}

void KalibrasiDebug(unsigned char * x, unsigned char counter)
{   unsigned char i;
    unsigned int DataKalibrasi[8];
    for (i=0;i<8;i++) DataKalibrasi[i]=0; 
    for (i=0;i<10;i++)
    {   DelayOff;   StartADC(Data0);    En0=0;  DataKalibrasi[0]-= BacaADC();   // LED 0 OFF
        DelayOn;    StartADC(Data0);    En0=1;  DataKalibrasi[0]+= BacaADC();   // LED 0 ON     
        DelayOff;   StartADC(Data1);    En1=0;  DataKalibrasi[1]-= BacaADC();   // LED 1 OFF
        DelayOn;    StartADC(Data1);    En1=1;  DataKalibrasi[1]+= BacaADC();   // LED 1 ON  
        DelayOff;   StartADC(Data2);    En2=0;  DataKalibrasi[2]-= BacaADC();   // LED 2 OFF
        DelayOn;    StartADC(Data2);    En2=1;  DataKalibrasi[2]+= BacaADC();   // LED 2 ON  
        DelayOff;   StartADC(Data3);    En3=0;  DataKalibrasi[3]-= BacaADC();   // LED 3 OFF
        DelayOn;    StartADC(Data3);    En3=1;  DataKalibrasi[3]+= BacaADC();   // LED 3 ON  
        DelayOff;   StartADC(Data4);    En4=0;  DataKalibrasi[4]-= BacaADC();   // LED 4 OFF
        DelayOn;    StartADC(Data4);    En4=1;  DataKalibrasi[4]+= BacaADC();   // LED 4 ON  
        DelayOff;   StartADC(Data5);    En5=0;  DataKalibrasi[5]-= BacaADC();   // LED 5 OFF
        DelayOn;    StartADC(Data5);    En5=1;  DataKalibrasi[5]+= BacaADC();   // LED 5 ON  
        DelayOff;   StartADC(Data6);    En6=0;  DataKalibrasi[6]-= BacaADC();   // LED 6 OFF
        DelayOn;    StartADC(Data6);    En6=1;  DataKalibrasi[6]+= BacaADC();   // LED 6 ON  
        DelayOff;   StartADC(Data7);    En7=0;  DataKalibrasi[7]-= BacaADC();   // LED 7 OFF     
        DelayOn;    StartADC(Data7);    En7=1;  DataKalibrasi[7]+= BacaADC();   // LED 7 ON
    }   
    //EnR = 0;    EnG = 0;   EnB = 0;
    putchar (counter);
    for (i=0;i<8;i++) 
    {   putchar (*(x+i));
        putchar ((DataKalibrasi[i]/10));
        x[i]= (int)(((int) (*(x+i))*(counter-1)) + (DataKalibrasi[i]/10))/counter;  
        putchar (x[i]);
    }
    
}

void Kalibrasi(unsigned char * x, unsigned char counter)
{   unsigned char i;
    unsigned int DataKalibrasi[8];
    for (i=0;i<8;i++) DataKalibrasi[i]=0; 
    for (i=0;i<10;i++)
    {   DelayOff;   StartADC(Data0);    En0=0;  DataKalibrasi[0]-= BacaADC();   // LED 0 OFF
        DelayOn;    StartADC(Data0);    En0=1;  DataKalibrasi[0]+= BacaADC();   // LED 0 ON     
        DelayOff;   StartADC(Data1);    En1=0;  DataKalibrasi[1]-= BacaADC();   // LED 1 OFF
        DelayOn;    StartADC(Data1);    En1=1;  DataKalibrasi[1]+= BacaADC();   // LED 1 ON  
        DelayOff;   StartADC(Data2);    En2=0;  DataKalibrasi[2]-= BacaADC();   // LED 2 OFF
        DelayOn;    StartADC(Data2);    En2=1;  DataKalibrasi[2]+= BacaADC();   // LED 2 ON  
        DelayOff;   StartADC(Data3);    En3=0;  DataKalibrasi[3]-= BacaADC();   // LED 3 OFF
        DelayOn;    StartADC(Data3);    En3=1;  DataKalibrasi[3]+= BacaADC();   // LED 3 ON  
        DelayOff;   StartADC(Data4);    En4=0;  DataKalibrasi[4]-= BacaADC();   // LED 4 OFF
        DelayOn;    StartADC(Data4);    En4=1;  DataKalibrasi[4]+= BacaADC();   // LED 4 ON  
        DelayOff;   StartADC(Data5);    En5=0;  DataKalibrasi[5]-= BacaADC();   // LED 5 OFF
        DelayOn;    StartADC(Data5);    En5=1;  DataKalibrasi[5]+= BacaADC();   // LED 5 ON  
        DelayOff;   StartADC(Data6);    En6=0;  DataKalibrasi[6]-= BacaADC();   // LED 6 OFF
        DelayOn;    StartADC(Data6);    En6=1;  DataKalibrasi[6]+= BacaADC();   // LED 6 ON  
        DelayOff;   StartADC(Data7);    En7=0;  DataKalibrasi[7]-= BacaADC();   // LED 7 OFF     
        DelayOn;    StartADC(Data7);    En7=1;  DataKalibrasi[7]+= BacaADC();   // LED 7 ON
    }   
    //EnR = 0;    EnG = 0;   EnB = 0;
    //putchar (counter);
    for (i=0;i<8;i++) 
    {   //putchar (*(x+i));
        //putchar ((DataKalibrasi[i]/10));
        x[i]= (int)(((int) (*(x+i))*(counter-1)) + (DataKalibrasi[i]/10))/counter;  
        //putchar (x[i]);
    }
    
}

char KalibrasiRGB()
{   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan biru
        Threshold Sensor Hijau diambil antara data di atas warna hijau dan hitam
        Threshold Sensor Biru diambil antara data di atas warna biru dan hijau
    */  
    // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
    if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
    {    EnR = 1;    EnG = 0;   EnB = 0;
        Kalibrasi(ThresholdR,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
        if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna hijau dilakukan untuk sensor biru dan hijau
            EnR = 0;    EnG = 1;   EnB = 0;
            Kalibrasi(ThresholdG,1);
            EnR = 0;    EnG = 0;   EnB = 1;
            Kalibrasi(ThresholdB,1);
            // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna biru
            if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
            {   // Kalibrasi di atas warna biru dilakukan untuk sensor merah dan biru
                EnR = 1;    EnG = 0;   EnB = 0;
                Kalibrasi(ThresholdR,2);
                EnR = 0;    EnG = 0;   EnB = 1;
                Kalibrasi(ThresholdB,2);
                // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
                if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
                {   // Kalibrasi di atas warna hitam dilakukan untuk sensor hijau saja
                    EnR = 0;    EnG = 1;   EnB = 0;
                    Kalibrasi(ThresholdG,2);
                    UpdateThresholdR();         // menyimpan data kalibrasi sensor merah ke EEPROM
                    UpdateThresholdG();         // menyimpan data kalibrasi sensor hijau ke EEPROM
                    UpdateThresholdB();         // menyimpan data kalibrasi sensor biru ke EEPROM
                    _Mode = pKalibrasiRGB;
                    return 1;
                }   
            }
        }
    } return 0;  
}

char KalibrasiMerahBiru(void)
{   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan biru
        Threshold Sensor Biru diambil antara data di atas warna biru dan hitam
    */  
    // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
    if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
    {   EnR = 1;    EnG = 0;   EnB = 0;
        Kalibrasi(ThresholdR,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
        if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna biru dilakukan untuk sensor merah dan biru
            EnR = 1;    EnG = 0;   EnB = 0;
            Kalibrasi(ThresholdR,2);
            EnR = 0;    EnG = 0;   EnB = 1;
            Kalibrasi(ThresholdB,1);
            // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
            if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
            {   // Kalibrasi di atas warna hitam dilakukan untuk sensor biru saja
                EnR = 0;    EnG = 0;   EnB = 1;
                Kalibrasi(ThresholdB,2);
                UpdateThresholdR();     // menyimpan data kalibrasi sensor merah ke EEPROM
                UpdateThresholdB();     // menyimpan data kalibrasi sensor biru ke EEPROM
                _Mode = pKalibrasiRB;
                return 1;
            }
        }
    } return 0;
}

char KalibrasiMerahHijau(void)
{   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan Hijau
        Threshold Sensor Hijau diambil antara data di atas warna biru dan hitam
    */  
    if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
    {   // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
        EnR = 1;    EnG = 0;   EnB = 0;
        Kalibrasi(ThresholdR,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
        if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna hijau dilakukan untuk sensor merah dan hijau
            EnR = 1;    EnG = 0;   EnB = 0;
            Kalibrasi(ThresholdR,2);
            EnR = 0;    EnG = 1;   EnB = 0;
            Kalibrasi(ThresholdG,1);
            // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
            if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
            {   // Kalibrasi di atas warna hitam dilakukan untuk sensor hijau saja
                EnR = 0;    EnG = 1;   EnB = 0;
                Kalibrasi(ThresholdG,2);
                UpdateThresholdR();     // menyimpan data kalibrasi sensor merah ke EEPROM
                UpdateThresholdG();     // menyimpan data kalibrasi sensor hijau ke EEPROM
                _Mode = pKalibrasiRG;
                return 1;
            }
        }
    } return 0;
}


char KalibrasiHitamPutihMerah(void)
{   /*  Threshold Sensor Merah diambil antara data di atas warna Hitam dan Putih
    */  
    if (getchar()== pKalibrasiHPR) // jika protokol bukan kalibrasi HPR, maka proses kalibrasi dihentikan
    {   // Kalibrasi Di atas warna Putih
        EnR = 1;    EnG = 0;   EnB = 0;
        Kalibrasi(ThresholdR,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
        if (getchar()== pKalibrasiHPR) // jika protokol bukan kalibrasi HPR, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna hitam
            Kalibrasi(ThresholdR,2);
            UpdateThresholdR();         // menyimpan data kalibrasi sensor merah ke EEPROM
            _Mode = pKalibrasiHPR;
            return 1;   
        }
    } return 0;
}

char KalibrasiHitamPutihBiru(void)
{   /*  Threshold Sensor Biru diambil antara data di atas warna Hitam dan Putih
    */  
    if (getchar()== pKalibrasiHPB) // jika protokol bukan kalibrasi HPB, maka proses kalibrasi dihentikan
    {   // Kalibrasi Di atas warna Putih
        EnR = 0;    EnG = 0;   EnB = 1;
        Kalibrasi(ThresholdB,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
        if (getchar()== pKalibrasiHPB) // jika protokol bukan kalibrasi HPB, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna hitam
            Kalibrasi(ThresholdB,2);
            UpdateThresholdB();         // menyimpan data kalibrasi sensor biru ke EEPROM
            _Mode = pKalibrasiHPB;
            return 1;   
        }
    }return 0;
}

char KalibrasiHitamPutihHijau(void)
{   /*  Threshold Sensor Hijau diambil antara data di atas warna Hitam dan Putih
    */  
    if (getchar()== pKalibrasiHPG) // jika protokol bukan kalibrasi HPG, maka proses kalibrasi dihentikan
    {   // Kalibrasi Di atas warna Putih
        EnR = 0;    EnG = 1;   EnB = 0;
        Kalibrasi(ThresholdG,1);
        // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
        if (getchar()== pKalibrasiHPG) // jika protokol bukan kalibrasi HPG, maka proses kalibrasi dihentikan
        {   // Kalibrasi di atas warna hitam
            Kalibrasi(ThresholdG,2);
            UpdateThresholdG();         // menyimpan data kalibrasi sensor hijau ke EEPROM
            _Mode = pKalibrasiHPG;
            return 1;   
        }
    } return 0;
}

void main(void)
{
// Declare your local variables here
unsigned char sData;


// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=1 State4=1 State3=1 State2=1 State1=1 State0=0 
PORTB=0x3E;
DDRB=0x3F;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=T State4=1 State3=1 State2=1 State1=T State0=T 
PORTD=0x1C;
DDRD=0xFC;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x85;        // 500kHz
//ADCSRA=0x8C;        // 1Mhz

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
                  
if (_DeviceAddress==0xFF) _DeviceAddress = 0;   // // nilai antara 0-15
DeviceAddress = _DeviceAddress;
ReloadThreshold();

#asm("sei")

while (1)
 { sData=getchar();
   if((sData & 0x0F)==_DeviceAddress)
   { switch (sData)
     {  case    pBacaSensorRGB:
        {       //ResetThreshold();
                EnR = 1;    EnG = 0;   EnB = 0;
                putchar(pBacaSensorRGB|DeviceAddress);
                putchar(BacaSensorMerah());
                putchar(BacaSensorHijau());  
                putchar(BacaSensorBiru());
                break;
        }
        case    pBacaSensorRG:
        {       putchar(pBacaSensorRG|DeviceAddress);
                putchar(BacaSensorMerah());
                putchar(BacaSensorHijau());  
                break;
        }
        case    pBacaSensorRB:
        {       putchar(pBacaSensorRB|DeviceAddress);
                putchar(BacaSensorMerah());
                putchar(BacaSensorBiru());
                break;
        }
        case    pBacaSensorGB:
        {       putchar(pBacaSensorGB|DeviceAddress);
                putchar(BacaSensorHijau());  
                putchar(BacaSensorBiru());
                break;
        }
        case    pBacaSensorR:
        {       putchar(pBacaSensorR|DeviceAddress);
                putchar(BacaSensorMerah());    
                break;
        }
        case    pBacaSensorG:
        {       putchar(pBacaSensorG|DeviceAddress);
                putchar(BacaSensorHijau());     break;
        }
        case    pBacaSensorB:
        {       putchar(pBacaSensorB|DeviceAddress);
                putchar(BacaSensorBiru());      break;
        }
        case    pKalibrasiRGB:
        {       if(KalibrasiRGB())              putchar(pKalibrasiRGB);
                else                            putchar(pError);
                break;
        }
        case    pKalibrasiRB:
        {       if(KalibrasiMerahBiru())        putchar(pKalibrasiRB);
                else                            putchar(pError);
                break;
        }
        case    pKalibrasiRG:
        {       if(KalibrasiMerahHijau())       putchar(pKalibrasiRG);
                else                            putchar(pError);
                break;
        }
        case    pKalibrasiHPR:
        {       if(KalibrasiHitamPutihMerah())  putchar(pKalibrasiHPR);
                else                            putchar(pError);
                break;
        }
        case    pKalibrasiHPB:
        {       if(KalibrasiHitamPutihBiru())   putchar(pKalibrasiHPB);
                else                            putchar(pError);
                break;
        }
        case    pKalibrasiHPG:
        {       if(KalibrasiHitamPutihHijau())  putchar(pKalibrasiHPG);
                else                            putchar(pError);
                break;
        }
        default:
        {       putchar(pError);
        }
     }
   }                   
 }     
}
