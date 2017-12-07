/*********************************************************
Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho  
Company : ER2C

Code    : Motor Access Routines, Equipped with optional PID controller  
*********************************************************/

#ifndef _myMotor_
#define _myMotor_

#include "myGlobalVars.h"

volatile int8_t        dSpeed1, dSpeed2;
#if UsePIDmotor == 1
    volatile int8_t  dMotor1=0, dMotor2=0;
    bit PIDMotorOn=0;
#endif
    
#pragma used+
uint8_t HitungSudut(uint16_t sudut);  // perubahan terkecil = 180/40 = 4,5 derajat
uint16_t HitungSudut2(uint16_t sudut); // perubahan terkecil = 180/2000 = 0,09 derajat
void SetDataMotorPWM(int16_t Ka, int16_t Ki);
void StopPWM();
#if UsePIDmotor == 1 
  void SetDataMotorPID(int8_t dmKa, int8_t dmKi);
  void PIDmotor1(void);
  void PIDmotor2(void);
#endif
#pragma used-            

// Deklarasi Motor Servo yang PWMnya di generate dengan menggunakan emulasi dari Timer 3 
// variable dServo1,2,3,4 dan 5 diusahakan untuk dialokasikan ke register 
// karena interupsi untuk membangkitkan PWMnya adalah 40KHz
    #if UseServo5 ==1   
        register uint8_t dServo5=0;
        void SudutServo5(uint8_t posisi)  { dServo5 = HitungSudut(posisi);}
    #endif
    #if UseServo1 ==1   
        register uint8_t dServo1=0; 
        void SudutServo1(uint8_t posisi)  { dServo1 = HitungSudut(posisi);}
    #endif
    #if UseServo2 ==1   
        register uint8_t dServo2=0; 
        void SudutServo2(uint8_t posisi)  { dServo2 = HitungSudut(posisi);}
    #endif
    #if UseServo3 ==1   
        register uint8_t dServo3=0; 
        void SudutServo3(uint8_t posisi)  { dServo3 = HitungSudut(posisi);}
    #endif
    #if UseServo4 ==1   
        register uint8_t dServo4=0; 
        void SudutServo4(uint8_t posisi)  { dServo4 = HitungSudut(posisi);}
    #endif   

#pragma used+    
    uint8_t HitungSudut(uint16_t sudut)  // perubahan terkecil = 180/40 = 4,5 derajat
    {   return ((sudut*8)/18 + 20);}

    // TCNT register dari timer 3 nilainya berkisar dari 0 s/d 5000
    // Mode PWM adalah phase correct PWM dengan nilai 5000 = 5 ms 
    // PWM berkisar antara 1ms s/d 2ms --> nilai 1000 s/d 2000
    // rumus perhitungan => x = sudut; y = nilai data OCR
    // (x-x1)/(x2-x1) = (y-y1)/(y2-yq)
    // (x-0)/(180-0) = (y-1000)/(2000-1000)
    // x/180 = (y-1000)/1000
    // y/1000 = x/180 + 1
    // y = x*1000/180 + 1000
    uint16_t HitungSudut2(uint16_t sudut) // perubahan terkecil = 180/1000 = 0,18 derajat
    {   return ((sudut*200)/18 + 500);}

    void SudutServo6(uint8_t posisi)
    {   dServo6 = HitungSudut2(posisi);}

    void SudutServo7(uint8_t posisi)
    {   dServo7 = HitungSudut2(posisi);}

    void SudutServo8(uint8_t posisi)
    { uint16_t dServo8;
      dServo8 = HitungSudut2(posisi);
      OCR1CH = ByteH(dServo8);
      OCR1CL = ByteL(dServo8);
    }    
#pragma used+    

//---------------  Fungsi untuk motor DC --> Motor Roda --------------------------------------
#pragma used+
    // Set data PWM dari Motor secara langsung
    // data berkisar antara -400 sampai dengan +400

    void SetDataMotorPWM(int16_t Ki, int16_t Ka)
    {   
        #if UsePIDmotor == 1 
        PIDMotorOn = 0;
        #endif 
        if(Ki<0)    { PwmM1H = ByteH(-Ki);  PwmM1L = ByteL(-Ki);    M1_CCW;}
        else        { PwmM1H = ByteH(Ki);   PwmM1L = ByteL(Ki);     M1_CW;}
        if(Ka<0)    { PwmM2H = ByteH(-Ka);  PwmM2L = ByteL(-Ka);    M2_CW;}
        else        { PwmM2H = ByteH(Ka);   PwmM2L = ByteL(Ka);     M2_CCW;}   
    }

    void StopPWM()
    {   PwmM2H = 0;  PwmM2L =0; PwmM1H = 0;  PwmM1L =0;
    }

#pragma used-

//---------------- Fungsi kendali motor saat PID motor diaktifkan -----------------------
#if UsePIDmotor == 1 

#define MaxSpeed        (int16_t)   400
#define MaxIntegral     MaxSpeed
#define KPm             (int16_t) 10
#define KDm             (int16_t) 3
#define KIm             (int16_t) 5


#pragma used+
    // Set data data kecepatan dan arah putaran Motor dengan menggunakan PID
    // data motor berkisar antara -20 sampai dengan +20
    void SetDataMotorPID(int8_t dmKi, int8_t dmKa)
    {   if(dmKi<0)  { dMotor1 = -dmKi;  M1_CCW;  }
        else        { dMotor1 = dmKi;   M1_CW; }
        if(dmKa<0)  { dMotor2 = -dmKa;  M2_CW; }
        else        { dMotor2 = dmKa;   M2_CCW;  }
        PIDMotorOn = 1;
    }

    void PIDmotor2(void)
    { int8_t Error2;
      int16_t U;       
      static int8_t lErrorM2=0, iErrorM2=0;
      // Menghitung PID Motor 2
      if(dMotor2>0)
      {   Error2 = (int8_t)dMotor2-(int8_t)dSpeed2;
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

    void PIDmotor1(void)
    { int8_t Error1;
      int16_t U;       
      static int8_t lErrorM1=0, iErrorM1=0;
      // Menghitung PID Motor 1
      if (dMotor1>0)
      {   Error1 = (int8_t)dMotor1-(int8_t)dSpeed1;
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

#endif
#endif
