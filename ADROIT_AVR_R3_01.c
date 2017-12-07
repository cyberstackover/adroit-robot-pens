/*****************************************************
Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho
Company : ER2C

Chip type           : ATmega128
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*****************************************************/

#include <stdio.h>
#include <mem.h>
#include <math.h>
#include "Include/mySystem.h"
#include "Include/NOTASI.c"

//  --------------  DEKLARASI VARIABEL GLOBAL --------------------------

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
        
        while(!PB1)
        {
            delay_ms(100);
            while(!PB1){}
            
            while(1)
            {
                LCD_Hapus();
                LCD_TulisF(0,"GOOOOOO........."); 

                while(getchar()==0xFF)
                {
                    flag_aksi=getchar();
                    Buzzer(C6,20);
                    
                    ///////////==BEBAS==///////////
                    if(flag_aksi==0x00)
                    {
                        Bebas();                
                    }
                    
                    ///////////==TES GARIS==///////////
                    if(flag_aksi==0x01)
                    {
                        notasi_tes[0]=getchar();
                        if(notasi_tes[0]==0x00)
                        {
                            ScanPerempatan(150,pBacaSensorR,pBacaSensorR);
                        }
                        else if(notasi_tes[0]==0x01)
                        {
                            Scan3Kanan(150,pBacaSensorR,pBacaSensorR);
                        }
                        else if(notasi_tes[0]==0x02)
                        {
                            Scan3Kiri(150,pBacaSensorR,pBacaSensorR);
                        }
                        else if(notasi_tes[0]==0x03)
                        {
                            BelKaPWM(150,-150,pBacaSensorR);
                        }
                        else if(notasi_tes[0]==0x04)
                        {
                            BelKiPWM(-150,150,pBacaSensorR);
                        }                        
                                    
                    }
                    
                    ///////////==Dinding==///////////
                    if(flag_aksi==0x04)
                    {
                        Dinding();                                    
                    }
                    
                    ///////////==GARIS==///////////
                    if(flag_aksi==0x05)
                    {
                        Garis();                   
                    }
                    
                    ///////////==GRIPPER==///////////
                    if(flag_aksi==0x06)
                    {
                        Gripper();                   
                    }
                    
                    ///////////==BUZZER==///////////
                    if(flag_aksi==0x07)
                    {
                        Alarm();
                    }
                    
                    ////////////==LCD==////////////
                    if(flag_aksi==0x08)
                    {
                        Lcd();
                    }
                    
                    ///////////==DELAY==///////////
                    if(flag_aksi==0x09)
                    {
                        Tunda();                              
                    }
                }
            }
        }
        while(!PB2)
        {
            KalibrasiHitamPutihEx(0,pKalibrasiHPR);
        }
        while(!PB3)
        {
            LCD_Hapus();
            LCD_TulisF(0,"SET PID");
            LCD_TulisF(1,"1: KP   2: KD");
            delay_ms(500);
			
            while(1)
            {
                if(!PB1)
                {
                    while(PB4)
                    {
                        LCD_Hapus();
                        LCD_TulisF(0,"KP");
                        LCD_GotoXY(0,1);    LCD_Angka3(SetKP);
                        delay_ms(100);
                        
                        if(PB1==0)
                        {
                            delay_ms(100);
                            SetKP++;
                        }
                        else if (PB2==0)
                        {
                            delay_ms(100);
                            SetKP--;            
                        }                
                    }
                    
                    delay_ms(1000);
                }
                else if (!PB2)
                {
                    while(PB4)
                    {
                        LCD_Hapus();
                        LCD_TulisF(0,"KD");
                        LCD_GotoXY(0,1);    LCD_Angka3(SetKD);
                        delay_ms(100);
                        
                        if(PB1==0)
                        {
                            delay_ms(100);
                            SetKD++;
                        }
                        else if (PB2==0)
                        {
                            delay_ms(100);
                            SetKD--;            
                        }        
                    }
                    
                    delay_ms(1000);
                }
                else if (!PB4){LCD_Hapus();delay_ms(1000);break;}
            }
        }        
        while(!PB4)
        {            
            /*
            int16_t direction,speed;
            
            delay_ms(100);
            while(!PBEx4);
                
            LCD_Hapus();
            LCD_TulisF(0,"REMOT"); 
            delay_ms(500);
            
            while(PBEx4)
            {
                while(getchar()==0x55)
                {
                    speed=getchar()*40;
                    direction=getchar();
                    
                    LCD_GotoXY(0,0);
                    LCD_Angka3(speed/40);
                    LCD_Angka3(direction);
                    
                    if(direction>=0&&direction<=5||direction>31&&direction<=35)
                    {
                        SetDataMotorPWM(speed,speed);                        
                    }
                    else if(direction>5&&direction<=14)
                    {
                        SetDataMotorPWM(-speed,speed);                        
                    }
                    else if(direction>14&&direction<=23)
                    {
                        SetDataMotorPWM(-speed,-speed); 
                    }
                    else if(direction>23&&direction<=31)
                    {
                        SetDataMotorPWM(speed,-speed);
                    }
                    else
                    {
                        SetDataMotorPWM(0,0);
                    }
                }
            }
            
            SetDataMotorPWM(0,0);
            delay_ms(1000);            
            */
        }
    }
}