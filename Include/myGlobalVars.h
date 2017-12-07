/*********************************************************
Project : ADROIT AVR Rev.3
Version : 1
Date    : 3/13/2014
Author  : Eko Henfri Binugroho
Company : ER2C

Code    : Global variables and Global Definitions  
*********************************************************/


#ifndef _MYGLOBALVARS_
    #define _MYGLOBALVARS_              1  
//  jika menggunakan CodeVision AVR
    #define uint8_t unsigned char
    #define int8_t  signed char
    #define uint16_t unsigned short int
    #define int16_t signed short int
    #define uint32_t unsigned long int
    #define int32_t signed long int
    
    
// sudut awal dari masing-masing motor servo (0-180 derajat)
    #define SudutAwalServo1     90
    #define SudutAwalServo2     90
    #define SudutAwalServo3     90
    #define SudutAwalServo4     90
    #define SudutAwalServo5     90
    #define SudutAwalServo6     90
    #define SudutAwalServo7     90 //LENGAN
    #define SudutAwalServo8     90 //CAPIT

// Pengaktifan fitur pada board kontroler, isi 1 jika diaktifkan, isi 0 jika tidak
    #define ModeBalancing               0           // 1, jika mode balancing robot diaktifkan
    
    // motor servo yang digenerate menggunakan emulasi PWM dari timer 3
    #define UseServo1                   0           // Mengaktifkan Servo 1 ?
    #define UseServo2                   0           // Mengaktifkan Servo 2 ?
    #define UseServo3                   0           // Mengaktifkan Servo 3 ?
    #define UseServo4                   0           // Mengaktifkan Servo 4 ?
    #define UseServo5                   0           // Mengaktifkan Servo 5 ?
    // servo 6, 7 dan 8 secara default aktif dengan PWM hardware dari board kontroler (OCR3x)
    
    
    #if ModeBalancing == 1
        #define UseIMU                  1           // mode ini membutuhkan IMU untuk diaktifkan 
        #define UsePIDmotor             0           // fitur PID untuk kendalai kecepatan roda untuk mode ini dinonaktifkan  
        extern int8_t TargetSpeedB;
        extern int16_t SteerB;
    #else
        #define UseIMU                  0           // apakah mengaktifkan fitur IMU? 
        #define UsePIDmotor             1           // fitur PID untuk kendalai kecepatan roda untuk mode ini dinonaktifkan
    #endif
    
    #if UseIMU == 1
        #define UseCompass              0
        // Pilih salah satu jenis filter yang diaktifkan
        #define KalmanFilter            1
        #define ComplementaryFilter     2
        #define MahonyFilter            3
        #define ImuFilter               KalmanFilter
        // Pilih salah satu posisi penempatan board pada robot
        #define TIDUR                   0           // posisi board tegak atau berdiri 
        #define TEGAK                   1           // Posisi board tidur
        #define PosisiBoard             TIDUR       // posisi board dalam robot 
        // Variabel yang digunakan
        extern volatile int16_t Ax, Ay, Az, Gx, Gy, Gz;    // data mentah dari gyroscope dan accelerometer    
        extern volatile float GxOffset, GyOffset, GzOffset;  // offset dari gyroscope
        extern volatile float Roll, Pitch, Yaw;  
     #endif
    
    /*
    #if UseServo5 == 1 
        extern unsigned char dServo5; 
    #endif
    #if UseServo1 == 1 
        extern unsigned char dServo1; 
    #endif
    #if UseServo2 == 1 
        extern unsigned char dServo2; 
    #endif
    #if UseServo3 == 1 
        extern unsigned char dServo3; 
    #endif
    #if UseServo4 == 1 
        extern unsigned char dServo4; 
    #endif  
    */
    
    #if UsePIDmotor == 1
        extern volatile int8_t  dMotor1, dMotor2; 
        extern bit              PIDMotorOn;
    #endif
    
    extern volatile int8_t      dSpeed1, dSpeed2;               // data kecepatan motor
    extern volatile uint8_t     dCounter1, dCounter2;           // data counter dari motor
    extern bit                  LaguOn, FlagSerial;

// konstanta konversi radian dan derajat
#define RAD2DEG     (float) 57.295779513082320876798154814105  
#define DEG2RAD     (float) 0.01745329251994329576923690768489 
        
// protokol untuk sensor garis terbagi atas:
// 4 bit identifikasi perintah (bit 4-7)
// 4 bit identifikasi alamat sensor (bit 0-3) --> Alamat Sensor bernilai antara 0-15

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
  
           
// Definisi Port LCD 
#define LCD_PORT        PORTA
#define LCD_RS          PORTA.0
#define LCD_RW          PORTA.1
#define LCD_EN          PORTA.2
#define LCD_BL          PORTA.3
bit     LCD_BackLight=0,ImuStart=0;

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

#define dServo6 OCR1A
#define dServo7 OCR1B
#define M1_CW   (DirM1 = 1)
#define M1_CCW  (DirM1 = 0)
#define M2_CCW  (DirM2 = 1)
#define M2_CW   (DirM2 = 0)
#define ByteL(a)    ((uint8_t) (a))
#define ByteH(a)    ((uint8_t) (((uint16_t) (a)) >> 8))

#define BacadServo8   peekw(&OCR1CL)
#define BacaPwmM1     peekw(&OCR3BL)
#define BacaPwmM2     peekw(&OCR3AL)

// Definisi Port Push Button
#define PB1             PINC.3
#define PB2             PINC.2
#define PB3             PINC.1
#define PB4             PINC.0

// Definisi Port Push Button External
#define PBEx1             PIND.4
#define PBEx2             PIND.5
#define PBEx3             PIND.6
#define PBEx4             PIND.7

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
#define _P_Enkoder1A    PORTE.6 //INT6
#define P_Enkoder1A     PINE.6 //INT6
#define P_Enkoder1B     PINB.0
#define _P_Enkoder2A    PORTE.7 //INT7
#define P_Enkoder2A     PINE.7 //INT7
#define P_Enkoder2B     PINB.2

// Definisi Port Mode
#define MODE            (PING & 0B00000111) | ((PING & 0B00010000)>>1) 
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

//===========================================//     
eeprom unsigned SetKP,SetKD;     

#endif