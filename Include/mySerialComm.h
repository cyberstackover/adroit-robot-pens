/*********************************************************
Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho  
Company : ER2C

Code    : Communication routines through UART    
*********************************************************/

#ifndef _mySerialComm_
#define _mySerialComm_

#include <mega128.h>
#include <delay.h>

bit FlagSerial=0;
    

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

//====================BANK DATA======================//
//unsigned char Bank_Data[30][30];
//===================================================//

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 512
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
char status0,data0;
status0=UCSR0A;
data0=UDR0;

if ((status0 & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data0;
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

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 512
volatile int8_t rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1<256
volatile uint8_t rx_wr_index1,rx_rd_index1,rx_counter1;
#else
volatile uint8_t rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
volatile int8_t Pointer_X,Pointer_Y,Flag_Serial_Step;
volatile char status,;
volatile unsigned char data;

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
   
   //================================================================//
        //==============HEADER - FOOTER==============//
   /*             
   if(data==0xF0){Flag_Serial_Step=1;}          //STEP 1 MAIN HEADER Pertama
   if(data==0xF2 && Flag_Serial_Step==1)         //STEP 2 MAIN HEADER Kedua
   {
    Flag_Serial_Step=2;
    Pointer_X=0; Pointer_Y=0; //POINTER
   }
   if(data==0xFA && Flag_Serial_Step==2){Flag_Serial_Step=0;}    //STEP 4 FOOTER
        //===========================================//
   
   if(data==0xFF && Flag_Serial_Step==2){Pointer_X=0;Pointer_Y++;}      // STEP 3 HEADER PERINTAH 
   if(data<0xF0 && Flag_Serial_Step==2)
   {
    Bank_Data[Pointer_X][Pointer_Y-1]=data;
    Pointer_X++;
   }
   */
   //================================================================//
}

// Get a character from the USART1 Receiver buffer
#pragma used+

// rutin membaca data dari port serial 1 dilengkapi dengan fungsi time out
// data gagal diterima apa bila nilai FlagSerial = 0
uint8_t BacaSerial1(uint16_t TimeOut)
{   uint16_t i;
    uint8_t data;
    FlagSerial = 0;
    for(i=0;i<TimeOut;i++)
    {   if (rx_counter1!=0) 
        {   FlagSerial = 1;
            data=rx_buffer1[rx_rd_index1];
            if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
            #asm("cli") --rx_counter1;  #asm("sei")
            return data;
            break;
        }
        delay_us(1);
    }
    return 0;
}

uint8_t getchar1(void)
{   uint8_t data;
    while (rx_counter1==0); 
    data=rx_buffer1[rx_rd_index1];
    if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
    #asm("cli") --rx_counter1;  #asm("sei")
    return data;
}

// Write a character to the USART1 Transmitter
void putchar1(int8_t c)
{   while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
    UDR1=c;
}
#pragma used-
#endif
