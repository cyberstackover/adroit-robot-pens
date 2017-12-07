#define EchoKi PINF.7
#define TrigKi PORTF=0b01000000
#define EchoDpn PINF.5
#define TrigDpn PORTF=0b00010000
#define EchoKa PINF.3
#define TrigKa PORTF=0b00000100
    
void ScanDindingKi(int16_t TopSpeed,int16_t SetPoint)
{
    int16_t timeout,Kus,Dus,count;
                        
    int16_t MKi, MKa, Error, dError, u;   
    static int16_t LastErrorDKi;
    int8_t flagBelok;

    DDRF=0b01010100;
                            
    //DEPAN
    PORTF=0x00;delay_us(2);TrigDpn;delay_us(10);PORTF=0x000;    
    usCounter=0; while (!EchoDpn&&usCounter<40); //time out 1000uS
    usCounter=0; while (EchoDpn&&usCounter<1440); //time out 36000uS 
    Dus=(usCounter*0.43125);
                        
    delay_ms(10);
                        
    //KIRI
    PORTF=0x00;delay_us(2);TrigKi;delay_us(10);PORTF=0x000;    
    usCounter=0; while (!EchoKi&&usCounter<40); //time out 1000uS
    usCounter=0; while (EchoKi&&usCounter<1440); //time out 36000uS 
    Kus=(usCounter*0.43125);
                        
    delay_ms(10);
                        
    LCD_Hapus();
    LCD_GotoXY(0,0);    LCD_Angka3(Kus);
    LCD_GotoXY(8,0);    LCD_Angka3(Dus);
    //================================================//
                        
    if(Dus<=20){SetDataMotorPWM(200,-200);}
    else if(Kus>SetPoint+10){SetDataMotorPWM(50,200);}
    else
    {
        Error = SetPoint - Kus ;                           
        dError = Error-LastErrorDKi;                
        LastErrorDKi = Error;
                            
        u = ((SetKP * Error + SetKD*dError)); //Kp ---- Kd
                                            
        MKi = TopSpeed + u;
        MKa = TopSpeed - u;
        if (MKi>400) MKi = 400;
        else if (MKi<-400) MKi = 400;
        if (MKa>400) MKa = 400;
        else if (MKa<-400) MKa = 400;
        SetDataMotorPWM(MKi,MKa);
    }
}

void ScanDindingKa(int16_t TopSpeed,int16_t SetPoint)
{
    int16_t timeout,Kus,Dus,count;
                        
    int16_t MKi, MKa, Error, dError, u;   
    static int16_t LastErrorDKa;
    int8_t flagBelok;
    
    DDRF=0b01010100;
                        
    //DEPAN
    PORTF=0x00;delay_us(2);TrigDpn;delay_us(10);PORTF=0x000;    
    usCounter=0; while (!EchoDpn&&usCounter<40); //time out 1000uS
    usCounter=0; while (EchoDpn&&usCounter<1440); //time out 36000uS 
    Dus=(usCounter*0.43125);
                        
    delay_ms(10);
                        
    //JARAK KANAN
    PORTF=0x00;delay_us(2);TrigKa;delay_us(10);PORTF=0x000;    
    usCounter=0; while (!EchoKa&&usCounter<40); //time out 1000uS
    usCounter=0; while (EchoKa&&usCounter<1440); //time out 36000uS 
    Kus=(usCounter*0.43125);
                        
    delay_ms(10);
                        
    LCD_Hapus();
    LCD_GotoXY(0,0);    LCD_Angka3(Kus);
    LCD_GotoXY(8,0);    LCD_Angka3(Dus);
    LCD_GotoXY(8,1);    LCD_Angka3(FlagBelok);
    //================================================//
                        
    if(Dus<=20){SetDataMotorPWM(-200,200);}
    else if(Kus>SetPoint+10)
    {
        LED1=1;LED2=1;
        SetDataMotorPWM(200,50);
    }
    else
    {
        Error = SetPoint - Kus ;                               
        dError = Error-LastErrorDKa;                
        LastErrorDKa = Error;
                            
        u = ((SetKP * Error + SetKD*dError)); //Kp ---- Kd
                                            
        MKi = TopSpeed - u;
        MKa = TopSpeed + u;
        if (MKi>400) MKi = 400;
        else if (MKi<-400) MKi = 400;
        if (MKa>400) MKa = 400;
        else if (MKa<-400) MKa = 400;
        SetDataMotorPWM(MKi,MKa);
    }
}    

void GarisDindingKi(int16_t TopSpeed,int16_t SetPoint,unsigned char WarnaGaris)
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
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while (sensor==0B11111111); //((sensor|0B11000011)!=0B11000011);
    do{  ScanDindingKi(LastSpeed,SetPoint);
         sensor = BacaSensorWarna(0,WarnaGaris); 
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while(sensor!=0B11111111);//((sensor|0B11000011)==0B11000011);
    StopPWM();
    LastSpeed=TopSpeed;
}

void GarisDindingKa(int16_t TopSpeed,int16_t SetPoint,unsigned char WarnaGaris)
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
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while(sensor==0B11111111); //((sensor|0B11000011)!=0B11000011);
    do{  ScanDindingKa(LastSpeed,SetPoint);
         sensor = BacaSensorWarna(0,WarnaGaris); 
         //LCD_GotoXY(0,1);LCD_Biner(sensor);
    }while(sensor!=0B11111111); //((sensor|0B11000011)==0B11000011);
    StopPWM();
    LastSpeed=TopSpeed;
}

void WaktuDindingKi(int16_t TopSpeed,int16_t SetPoint,uint8_t Durasi)
{
    DTimeTick=0;DTime=0; //Reset Timer WallFollower
    
    while(DTime<= Durasi){ScanDindingKi(TopSpeed,SetPoint);}
    StopPWM();
}

void WaktuDindingKa(int16_t TopSpeed,int16_t SetPoint,uint8_t Durasi)
{
    DTimeTick=0;DTime=0; //Reset Timer WallFollower
    
    while(DTime<= Durasi){ScanDindingKa(TopSpeed,SetPoint);}
    StopPWM();
}
