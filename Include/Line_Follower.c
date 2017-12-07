//  --------------  DEKLARASI VARIABEL GLOBAL --------------------------

bit FlagBelok;

unsigned char BacaSensorWarna(unsigned char alamat, unsigned char warna)
{   BacaSensor(alamat,warna);
    if(BacaSerial1(5000)==warna)
    {   return BacaSerial1(5000);
    }
    else return 0;
}

unsigned char BacaSensorMerah(unsigned char alamat)
{   BacaSensor(alamat,pBacaSensorR);
    if(BacaSerial1(5000)==pBacaSensorR)
    {   return BacaSerial1(5000);
    }
    else return 0;
}

unsigned char BacaSensorBiru(unsigned char alamat)
{   BacaSensor(alamat,pBacaSensorB);
    if(BacaSerial1(5000)==pBacaSensorB)
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

void ScanGaris(int16_t TopSpeed, unsigned char WarnaGaris)
{   unsigned char sensor;
    int16_t MKi, MKa, Error, dError, u;   
    static int16_t LastError;
    //LCD_GotoXY(0,0);
    BacaSensor(0,WarnaGaris);
    if(BacaSerial1(5000)==WarnaGaris)
        {   sensor = BacaSerial1(5000);
            //LCD_Biner(sensor);
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
                //iError += (float)Error/5;
                
                //if(iError>300)iError=300;
                //else if (iError<-300)iError=-300;
                
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
                //LCD_GotoXY(0,1);        LCD_sByte(MKi);     LCD_Data(' ');
                //LCD_GotoXY(8,1);        LCD_sByte(MKa);     LCD_Data(' ');
                
                ////////////////=====================================////////////////////////
                
       }
}

#define Bit(x,y) (x & (1<<y))

void ScanPerempatan(int16_t TopSpeed, unsigned char WarnaGaris, unsigned char WarnaPerempatan)
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
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B11000011)!=0B11000011);
    do{  ScanGaris(LastSpeed, WarnaGaris);
         sensor = BacaSensorWarna(0,WarnaPerempatan); 
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B11000011)==0B11000011);
    StopPWM();
    LastSpeed=TopSpeed;
}

void Scan3Kanan(int16_t TopSpeed, unsigned char WarnaGaris, unsigned char Warna3)
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
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B11111000)!=0B11111000);
    do{  ScanGaris(LastSpeed, WarnaGaris);
         sensor = BacaSensorWarna(0,Warna3); 
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B11111000)==0B11111000);
    StopPWM();
    LastSpeed=TopSpeed;
}
void Scan3Kiri(int16_t TopSpeed, unsigned char WarnaGaris, unsigned char Warna3)
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
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B00011111)!=0B00011111);
    do{  ScanGaris(LastSpeed, WarnaGaris);
         sensor = BacaSensorWarna(0,Warna3); 
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while((sensor|0B00011111)==0B00011111);
    StopPWM();
    LastSpeed=TopSpeed;
}

void BelKaPWM(int16_t Ki,int16_t Ka,unsigned char WarnaAkhir)
{   unsigned char sensor;
    SetDataMotorPWM(Ki,Ka);
    FlagBelok=1;
    // menunggu sensor kanan ke 1 atau ke 2 keluar garis
    delay_ms(50);
    do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
      } while(Bit(sensor,0)==0 || Bit(sensor,1)==0 ); 
    // menunggu sensor kanan ke 1 atau ke 2 masuk garis
    delay_ms(50);
    do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
      } while(Bit(sensor,0)!=0 && Bit(sensor,1)!=0); 
    StopPWM();
}
void BelKiPWM(int16_t Ki,int16_t Ka,unsigned char WarnaAkhir)
{   unsigned char sensor;
    SetDataMotorPWM(Ki,Ka);
    FlagBelok=1;
    // menunggu sensor kanan ke 6 atau ke 7 keluar garis
    delay_ms(50);
    do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
      } while(Bit(sensor,7)==0 || Bit(sensor,6)==0 );
    // menunggu sensor kanan ke 6 atau ke 7 masuk garis
    delay_ms(50);
    do{ sensor = BacaSensorWarna(0,WarnaAkhir);   
      } while(Bit(sensor,7)!=0 && Bit(sensor,6)!=0); 
    StopPWM();
}