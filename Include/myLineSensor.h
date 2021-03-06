/*********************************************************
Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho  
Company : ER2C

Code    : Line Sensor Access and Callibration Routines
*********************************************************/

#ifndef _myLineSensor_
#define _myLineSensor_

#include "myLCD.h"
#include "myBuzzer.h"
#include "mySerialComm.h"

#pragma used+
void BacaSensor(uint8_t Alamat, uint8_t Protokol);
uint8_t TungguTombolKalibrasi(uint8_t Alamat, uint8_t Protokol);
void PesanKalibrasiBerhasil(void);
void PesanKalibrasiGagal(void);
int8_t KalibrasiRGB(uint8_t Alamat);


// Fungsi Baca Sensor lewat komunikasi Serial
void BacaSensor(uint8_t Alamat, uint8_t Protokol)
{   putchar1(Protokol | Alamat);
}

uint8_t TungguTombolKalibrasi(uint8_t Alamat, uint8_t Protokol)
{   uint8_t filter=0;
    while (filter<=100)   //Menunggu penekanan Tombol 1
    { if(PB1)filter=0;
      filter++;
    }
    if(!PB1)    {   putchar1(Protokol | Alamat); return 1;}
    else        {   putchar1(0);                 return 0;}    // jika tombol 4 ditekan, berarti proses dihentikan                            
}

uint8_t TungguTombolKalibrasiEx(uint8_t Alamat, uint8_t Protokol)
{   uint8_t filter=0;
    while (filter<=100)   //Menunggu penekanan Tombol 1
    { if(PB1)filter=0;
      filter++;
    }
    if(!PB1)      {   putchar1(Protokol | Alamat); return 1;}
    else            {   putchar1(0);                 return 0;}    // jika tombol 4 ditekan, berarti proses dihentikan                            
}

void PesanKalibrasiBerhasil(void)
{   LCD_Perintah(0x01);         // Hapus layar
    //              (   "0123456789012345")
    LCD_TulisF      (0, "Kalibrasi Sensor");
    LCD_TulisKiri   (1, "Selesai >>>>>>>>");
}

void PesanKalibrasiGagal(void)
{   LCD_Perintah(0x01);         // Hapus layar
    //              ("0123456789012345")
    LCD_TulisF      (0, "Kalibrasi Sensor");
    LCD_TulisKiri   (1, "Dihentikan >>>>>");
}

int8_t KalibrasiRGB(uint8_t Alamat)
{   LCD_Perintah(0x01);         // Hapus layar
    //              (   "0123456789012345")
    LCD_TulisF      (0, "Kalibrasi Sensor");
    LCD_TulisF      (1, "Merah-Hijau-Biru");
    Buzzer(3000,500);
    delay_ms(1000);
    LCD_Perintah(0x01);         // Hapus layar
    putchar1(pKalibrasiRGB | Alamat);
    LCD_TulisKiri   (0, "1.Warna Merah >>");
    LCD_TulisKanan  (1, "Tekan Tombol 1<<");
    if(TungguTombolKalibrasi(Alamat, pKalibrasiRGB))
    {   Buzzer(3000,200);
        LCD_HapusKanan(0);
        LCD_TulisKiri   (0, "2.Warna Hijau >>");
        if(TungguTombolKalibrasi(Alamat, pKalibrasiRGB))
        {   Buzzer(3000,200);
            LCD_HapusKanan(0);
            LCD_TulisKiri  (0, "3.Warna Biru >>>");  
            if(TungguTombolKalibrasi(Alamat, pKalibrasiRGB))
            {   Buzzer(3000,200);
                LCD_HapusKanan(0);
                LCD_TulisKiri  (0, "4.Warna Hitam >>");
                if(TungguTombolKalibrasi(Alamat, pKalibrasiRGB))
                {   Buzzer(3000,200);
                    if(BacaSerial1(5000)==pKalibrasiRGB)
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

int8_t KalibrasiHitamPutih(uint8_t Alamat, unsigned char Protocol)
{   LCD_Perintah(0x01);         // Hapus layar
    //              (   "0123456789012345")
    LCD_TulisF      (0, "Kalibrasi Sensor");
    if (Protocol==pKalibrasiHPR)
    { LCD_TulisF      (1, "HitamPutih-Merah"); }
    else if (Protocol==pKalibrasiHPG)
    { LCD_TulisF      (1, "HitamPutih-Hijau"); }
    else if (Protocol==pKalibrasiHPB)
    { LCD_TulisF      (1, "HitamPutih-Biru "); }
    else
    {   PesanKalibrasiGagal();
        return 0;
    }
    Buzzer(3000,500);
    delay_ms(1000);
    LCD_Perintah(0x01);         // Hapus layar
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

int8_t KalibrasiHitamPutihEx(uint8_t Alamat, unsigned char Protocol)
{   LCD_Perintah(0x01);         // Hapus layar
    //              (   "0123456789012345")
    LCD_TulisF      (0, "Kalibrasi Sensor");
    if (Protocol==pKalibrasiHPR)
    { LCD_TulisF      (1, "HitamPutih-Merah"); }
    else if (Protocol==pKalibrasiHPG)
    { LCD_TulisF      (1, "HitamPutih-Hijau"); }
    else if (Protocol==pKalibrasiHPB)
    { LCD_TulisF      (1, "HitamPutih-Biru "); }
    else
    {   PesanKalibrasiGagal();
        return 0;
    }
    Buzzer(3000,500);
    delay_ms(1000);
    LCD_Perintah(0x01);         // Hapus layar
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
#endif
