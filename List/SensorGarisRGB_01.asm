
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : No
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _DeviceAddress=R4
	.DEF _rx_wr_index=R3
	.DEF _rx_rd_index=R6
	.DEF _rx_counter=R5

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/19/2014
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;
;// protokol untuk sensor garis terbagi atas:
;// 4 bit identifikasi perintah (bit 4-7)
;// 4 bit identifikasi alamat sensor (bit 0-3) --> Alamat Sensor bernilai antara 0-15
;
;#define pBacaSensorRGB  (unsigned char) 0B01110000
;#define pBacaSensorRG   (unsigned char) 0B01100000
;#define pBacaSensorRB   (unsigned char) 0B01010000
;#define pBacaSensorGB   (unsigned char) 0B00110000
;#define pBacaSensorR    (unsigned char) 0B01000000
;#define pBacaSensorG    (unsigned char) 0B00100000
;#define pBacaSensorB    (unsigned char) 0B00010000
;#define pKalibrasiRGB   (unsigned char) 0B11110000
;#define pKalibrasiRB    (unsigned char) 0B11010000
;#define pKalibrasiRG    (unsigned char) 0B11100000
;#define pKalibrasiHPR   (unsigned char) 0B11000000
;#define pKalibrasiHPG   (unsigned char) 0B10100000
;#define pKalibrasiHPB   (unsigned char) 0B10010000
;#define pError          (unsigned char) 0B00000000
;
;/*
;#define pBacaSensorRGB  (uint8_t) 0B01110000
;#define pBacaSensorRG   (uint8_t) 0B01100000
;#define pBacaSensorRB   (uint8_t) 0B01010000
;#define pBacaSensorGB   (uint8_t) 0B00110000
;#define pBacaSensorR    (uint8_t) 0B01000000
;#define pBacaSensorG    (uint8_t) 0B00100000
;#define pBacaSensorB    (uint8_t) 0B00010000
;#define pKalibrasiRGB   (uint8_t) 0B11110000
;#define pKalibrasiRB    (uint8_t) 0B11010000
;#define pKalibrasiRG    (uint8_t) 0B11100000
;#define pKalibrasiHPR   (uint8_t) 0B11000000
;#define pKalibrasiHPG   (uint8_t) 0B10100000
;#define pKalibrasiHPB   (uint8_t) 0B10010000
;#define pError          (uint8_t) 0B00000000
; */
;
;register unsigned char DeviceAddress;
;unsigned char ThresholdR[8], ThresholdG[8], ThresholdB[8];
;eeprom unsigned char _ThresholdR[8], _ThresholdG[8], _ThresholdB[8], _Mode, _DeviceAddress;
;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0076 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077 register unsigned char xData;
; 0000 0078 unsigned char status;
; 0000 0079 status=UCSRA;
	RCALL __SAVELOCR2
;	xData -> R17
;	status -> R16
	IN   R16,11
; 0000 007A xData=UDR;
	IN   R17,12
; 0000 007B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0  && ((xData & 0xF)==DeviceAddress) )
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x4
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	CP   R4,R30
	BREQ _0x5
_0x4:
	RJMP _0x3
_0x5:
; 0000 007C    {
; 0000 007D    rx_buffer[rx_wr_index++]=xData & 0xF0;   // mengambil 4 bit nibble atas
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	MOVW R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	ST   X,R30
; 0000 007E #if RX_BUFFER_SIZE == 256
; 0000 007F    // special case for receiver buffer size=256
; 0000 0080    if (++rx_counter == 0)
; 0000 0081       {
; 0000 0082 #else
; 0000 0083    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x6
	CLR  R3
; 0000 0084    if (++rx_counter == RX_BUFFER_SIZE)
_0x6:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x7
; 0000 0085       {
; 0000 0086       rx_counter=0;
	CLR  R5
; 0000 0087 #endif
; 0000 0088       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0089       }
; 0000 008A    }
_0x7:
; 0000 008B }
_0x3:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0092 {
_getchar:
; 0000 0093 unsigned char data;
; 0000 0094 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R5
	BREQ _0x8
; 0000 0095 data=rx_buffer[rx_rd_index++];
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0096 #if RX_BUFFER_SIZE != 256
; 0000 0097 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0xB
	CLR  R6
; 0000 0098 #endif
; 0000 0099 #asm("cli")
_0xB:
	cli
; 0000 009A --rx_counter;
	DEC  R5
; 0000 009B #asm("sei")
	sei
; 0000 009C return data;
	MOV  R30,R17
	RJMP _0x2060005
; 0000 009D }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// active Low
;#define En0     PORTB.1
;#define En1     PORTB.2
;#define En2     PORTB.3
;#define En3     PORTB.4
;#define En4     PORTD.5
;#define En5     PORTD.2
;#define En6     PORTD.3
;#define En7     PORTD.4
;#define LED     PORTB.5
;
;
;// active high
;#define EnR     PORTD.7
;#define EnB     PORTB.0
;#define EnG     PORTD.6
;
;// adc channel
;#define Data0   6
;#define Data1   7
;#define Data2   1
;#define Data3   0
;#define Data4   2
;#define Data5   3
;#define Data6   4
;#define Data7   5
;
;#define DelayOff    (delay_us(15))
;#define DelayOn     (delay_us(25))
;
;#define ADC_VREF_TYPE 0x20
;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;void StartADC(unsigned char adc_input)
; 0000 00C8 {   ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
_StartADC:
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 00C9     delay_us(10);   // Delay menunggu input tegangan stabil
	__DELAY_USB 53
; 0000 00CA     ADCSRA|=0x40;   // Start Konversi ADC
	SBI  0x6,6
; 0000 00CB     delay_us(5);    // waktu Sample and Hold
	__DELAY_USB 27
; 0000 00CC }
	RJMP _0x2060001
;
;unsigned char BacaADC()
; 0000 00CF {   while ((ADCSRA & 0x10)==0);     // menunggu proses konversi
_BacaADC:
_0xC:
	SBIS 0x6,4
	RJMP _0xC
; 0000 00D0     ADCSRA|=0x10;                   // Stop konversi
	SBI  0x6,4
; 0000 00D1     return ADCH;                    // mengembalikan data hasil konversi
	IN   R30,0x5
	RET
; 0000 00D2 }
;
;unsigned char BacaSensorDebug(unsigned char * Threshold)
; 0000 00D5 {       register unsigned char AdcGelap, AdcTerang;
; 0000 00D6         register unsigned char Sensor=0;
; 0000 00D7         En0 = 1;    En1 = 1;    En2 = 1;    En3 = 1;
;	*Threshold -> Y+4
;	AdcGelap -> R17
;	AdcTerang -> R16
;	Sensor -> R19
; 0000 00D8         En4 = 1;    En5 = 1;    En6 = 1;    En7 = 1;
; 0000 00D9         // Sensor 0
; 0000 00DA         DelayOff;   StartADC(Data0);    En0=0;  AdcGelap = BacaADC();
; 0000 00DB         DelayOn;    StartADC(Data0);    En0=1;  AdcTerang = BacaADC();
; 0000 00DC         putchar (AdcGelap);
; 0000 00DD         putchar (AdcTerang);
; 0000 00DE         putchar (*(Threshold+0));
; 0000 00DF         if(AdcGelap<AdcTerang)
; 0000 00E0         {   if((AdcTerang-AdcGelap)>*(Threshold+0)) Sensor |=1;
; 0000 00E1         }
; 0000 00E2         // Sensor 1
; 0000 00E3         DelayOff;   StartADC(Data1);    En1=0;  AdcGelap = BacaADC();
; 0000 00E4         DelayOn;    StartADC(Data1);    En1=1;  AdcTerang = BacaADC();
; 0000 00E5         putchar (AdcGelap);
; 0000 00E6         putchar (AdcTerang);
; 0000 00E7         putchar (*(Threshold+1));
; 0000 00E8         if(AdcGelap<AdcTerang)
; 0000 00E9         {   if((AdcTerang-AdcGelap)>*(Threshold+1)) Sensor |=2;
; 0000 00EA         }
; 0000 00EB         // Sensor 2
; 0000 00EC         DelayOff;   StartADC(Data2);    En2=0;  AdcGelap = BacaADC();
; 0000 00ED         DelayOn;    StartADC(Data2);    En2=1;  AdcTerang = BacaADC();
; 0000 00EE         putchar (AdcGelap);
; 0000 00EF         putchar (AdcTerang);
; 0000 00F0         putchar (*(Threshold+2));
; 0000 00F1         if(AdcGelap<AdcTerang)
; 0000 00F2         {   if((AdcTerang-AdcGelap)>*(Threshold+2)) Sensor |=4;
; 0000 00F3         }
; 0000 00F4         // Sensor 3
; 0000 00F5         DelayOff;   StartADC(Data3);    En3=0;  AdcGelap = BacaADC();
; 0000 00F6         DelayOn;    StartADC(Data3);    En3=1;  AdcTerang = BacaADC();
; 0000 00F7         putchar (AdcGelap);
; 0000 00F8         putchar (AdcTerang);
; 0000 00F9         putchar (*(Threshold+3));
; 0000 00FA         if(AdcGelap<AdcTerang)
; 0000 00FB         {   if((AdcTerang-AdcGelap)>*(Threshold+3)) Sensor |=8;
; 0000 00FC         }
; 0000 00FD         // Sensor 4
; 0000 00FE         DelayOff;   StartADC(Data4);    En4=0;  AdcGelap = BacaADC();
; 0000 00FF         DelayOn;    StartADC(Data4);    En4=1;  AdcTerang = BacaADC();
; 0000 0100         putchar (AdcGelap);
; 0000 0101         putchar (AdcTerang);
; 0000 0102         putchar (*(Threshold+4));
; 0000 0103         if(AdcGelap<AdcTerang)
; 0000 0104         {   if((AdcTerang-AdcGelap)>*(Threshold+4)) Sensor |=16;
; 0000 0105         }
; 0000 0106         // Sensor 5
; 0000 0107         DelayOff;   StartADC(Data5);    En5=0;  AdcGelap = BacaADC();
; 0000 0108         DelayOn;    StartADC(Data5);    En5=1;  AdcTerang = BacaADC();
; 0000 0109         putchar (AdcGelap);
; 0000 010A         putchar (AdcTerang);
; 0000 010B         putchar (*(Threshold+5));
; 0000 010C         if(AdcGelap<AdcTerang)
; 0000 010D         {   if((AdcTerang-AdcGelap)>*(Threshold+5)) Sensor |=32;
; 0000 010E         }
; 0000 010F         // Sensor 6
; 0000 0110         DelayOff;   StartADC(Data6);    En6=0;  AdcGelap = BacaADC();
; 0000 0111         DelayOn;    StartADC(Data6);    En6=1;  AdcTerang = BacaADC();
; 0000 0112         putchar (AdcGelap);
; 0000 0113         putchar (AdcTerang);
; 0000 0114         putchar (*(Threshold+6));
; 0000 0115         if(AdcGelap<AdcTerang)
; 0000 0116         {   if((AdcTerang-AdcGelap)>*(Threshold+6)) Sensor |=64;
; 0000 0117         }
; 0000 0118         // Sensor 7
; 0000 0119         DelayOff;   StartADC(Data7);    En7=0;  AdcGelap = BacaADC();
; 0000 011A         DelayOn;    StartADC(Data7);    En7=1;  AdcTerang = BacaADC();
; 0000 011B         putchar (AdcGelap);
; 0000 011C         putchar (AdcTerang);
; 0000 011D         putchar (*(Threshold+7));
; 0000 011E         if(AdcGelap<AdcTerang)
; 0000 011F         {   if((AdcTerang-AdcGelap)>*(Threshold+7)) Sensor |=128;
; 0000 0120         }
; 0000 0121         EnR = 0;    EnG = 0;   EnB = 0;
; 0000 0122         return (Sensor);
; 0000 0123 }
;
;unsigned char BacaSensor(unsigned char * Threshold)
; 0000 0126 {       register unsigned char AdcGelap, AdcTerang;
_BacaSensor:
; 0000 0127         register unsigned char Sensor=0;
; 0000 0128         En0 = 1;    En1 = 1;    En2 = 1;    En3 = 1;
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR4
;	*Threshold -> Y+4
;	AdcGelap -> R17
;	AdcTerang -> R16
;	Sensor -> R19
	LDI  R19,0
	SBI  0x18,1
	SBI  0x18,2
	SBI  0x18,3
	SBI  0x18,4
; 0000 0129         En4 = 1;    En5 = 1;    En6 = 1;    En7 = 1;
	SBI  0x12,5
	SBI  0x12,2
	SBI  0x12,3
	SBI  0x12,4
; 0000 012A         // Sensor 0
; 0000 012B         DelayOff;   StartADC(Data0);    En0=0;  AdcGelap = BacaADC();
	__DELAY_USB 80
	LDI  R26,LOW(6)
	RCALL _StartADC
	CBI  0x18,1
	RCALL _BacaADC
	MOV  R17,R30
; 0000 012C         DelayOn;    StartADC(Data0);    En0=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(6)
	RCALL _StartADC
	SBI  0x18,1
	RCALL _BacaADC
	MOV  R16,R30
; 0000 012D         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x69
; 0000 012E         {   if((AdcTerang-AdcGelap)>*(Threshold+0)) Sensor |=1;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+0
	CP   R30,R26
	BRSH _0x6A
	ORI  R19,LOW(1)
; 0000 012F         }
_0x6A:
; 0000 0130         // Sensor 1
; 0000 0131         DelayOff;   StartADC(Data1);    En1=0;  AdcGelap = BacaADC();
_0x69:
	__DELAY_USB 80
	LDI  R26,LOW(7)
	RCALL _StartADC
	CBI  0x18,2
	RCALL _BacaADC
	MOV  R17,R30
; 0000 0132         DelayOn;    StartADC(Data1);    En1=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(7)
	RCALL _StartADC
	SBI  0x18,2
	RCALL _BacaADC
	MOV  R16,R30
; 0000 0133         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x6F
; 0000 0134         {   if((AdcTerang-AdcGelap)>*(Threshold+1)) Sensor |=2;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+1
	CP   R30,R26
	BRSH _0x70
	ORI  R19,LOW(2)
; 0000 0135         }
_0x70:
; 0000 0136         // Sensor 2
; 0000 0137         DelayOff;   StartADC(Data2);    En2=0;  AdcGelap = BacaADC();
_0x6F:
	__DELAY_USB 80
	LDI  R26,LOW(1)
	RCALL _StartADC
	CBI  0x18,3
	RCALL _BacaADC
	MOV  R17,R30
; 0000 0138         DelayOn;    StartADC(Data2);    En2=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(1)
	RCALL _StartADC
	SBI  0x18,3
	RCALL _BacaADC
	MOV  R16,R30
; 0000 0139         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x75
; 0000 013A         {   if((AdcTerang-AdcGelap)>*(Threshold+2)) Sensor |=4;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+2
	CP   R30,R26
	BRSH _0x76
	ORI  R19,LOW(4)
; 0000 013B         }
_0x76:
; 0000 013C         // Sensor 3
; 0000 013D         DelayOff;   StartADC(Data3);    En3=0;  AdcGelap = BacaADC();
_0x75:
	__DELAY_USB 80
	LDI  R26,LOW(0)
	RCALL _StartADC
	CBI  0x18,4
	RCALL _BacaADC
	MOV  R17,R30
; 0000 013E         DelayOn;    StartADC(Data3);    En3=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(0)
	RCALL _StartADC
	SBI  0x18,4
	RCALL _BacaADC
	MOV  R16,R30
; 0000 013F         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x7B
; 0000 0140         {   if((AdcTerang-AdcGelap)>*(Threshold+3)) Sensor |=8;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+3
	CP   R30,R26
	BRSH _0x7C
	ORI  R19,LOW(8)
; 0000 0141         }
_0x7C:
; 0000 0142         // Sensor 4
; 0000 0143         DelayOff;   StartADC(Data4);    En4=0;  AdcGelap = BacaADC();
_0x7B:
	__DELAY_USB 80
	LDI  R26,LOW(2)
	RCALL _StartADC
	CBI  0x12,5
	RCALL _BacaADC
	MOV  R17,R30
; 0000 0144         DelayOn;    StartADC(Data4);    En4=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(2)
	RCALL _StartADC
	SBI  0x12,5
	RCALL _BacaADC
	MOV  R16,R30
; 0000 0145         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x81
; 0000 0146         {   if((AdcTerang-AdcGelap)>*(Threshold+4)) Sensor |=16;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+4
	CP   R30,R26
	BRSH _0x82
	ORI  R19,LOW(16)
; 0000 0147         }
_0x82:
; 0000 0148         // Sensor 5
; 0000 0149         DelayOff;   StartADC(Data5);    En5=0;  AdcGelap = BacaADC();
_0x81:
	__DELAY_USB 80
	LDI  R26,LOW(3)
	RCALL _StartADC
	CBI  0x12,2
	RCALL _BacaADC
	MOV  R17,R30
; 0000 014A         DelayOn;    StartADC(Data5);    En5=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(3)
	RCALL _StartADC
	SBI  0x12,2
	RCALL _BacaADC
	MOV  R16,R30
; 0000 014B         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x87
; 0000 014C         {   if((AdcTerang-AdcGelap)>*(Threshold+5)) Sensor |=32;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+5
	CP   R30,R26
	BRSH _0x88
	ORI  R19,LOW(32)
; 0000 014D         }
_0x88:
; 0000 014E         // Sensor 6
; 0000 014F         DelayOff;   StartADC(Data6);    En6=0;  AdcGelap = BacaADC();
_0x87:
	__DELAY_USB 80
	LDI  R26,LOW(4)
	RCALL _StartADC
	CBI  0x12,3
	RCALL _BacaADC
	MOV  R17,R30
; 0000 0150         DelayOn;    StartADC(Data6);    En6=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(4)
	RCALL _StartADC
	SBI  0x12,3
	RCALL _BacaADC
	MOV  R16,R30
; 0000 0151         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x8D
; 0000 0152         {   if((AdcTerang-AdcGelap)>*(Threshold+6)) Sensor |=64;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	CP   R30,R26
	BRSH _0x8E
	ORI  R19,LOW(64)
; 0000 0153         }
_0x8E:
; 0000 0154         // Sensor 7
; 0000 0155         DelayOff;   StartADC(Data7);    En7=0;  AdcGelap = BacaADC();
_0x8D:
	__DELAY_USB 80
	LDI  R26,LOW(5)
	RCALL _StartADC
	CBI  0x12,4
	RCALL _BacaADC
	MOV  R17,R30
; 0000 0156         DelayOn;    StartADC(Data7);    En7=1;  AdcTerang = BacaADC();
	__DELAY_USB 133
	LDI  R26,LOW(5)
	RCALL _StartADC
	SBI  0x12,4
	RCALL _BacaADC
	MOV  R16,R30
; 0000 0157         if(AdcGelap<AdcTerang)
	CP   R17,R16
	BRSH _0x93
; 0000 0158         {   if((AdcTerang-AdcGelap)>*(Threshold+7)) Sensor |=128;
	MOV  R26,R16
	SUB  R26,R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	CP   R30,R26
	BRSH _0x94
	ORI  R19,LOW(128)
; 0000 0159         }
_0x94:
; 0000 015A         EnR = 0;    EnG = 0;   EnB = 0;
_0x93:
	CBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 015B         return (Sensor);
	MOV  R30,R19
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 015C }
;
;void ReloadThreshold()
; 0000 015F {   unsigned char i;
_ReloadThreshold:
; 0000 0160     for(i=0;i<8;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x9C:
	CPI  R17,8
	BRSH _0x9D
; 0000 0161     {   ThresholdR [i] = _ThresholdR [i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdR)
	SBCI R31,HIGH(-_ThresholdR)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdR)
	SBCI R27,HIGH(-__ThresholdR)
	RCALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0162         ThresholdG [i] = _ThresholdG [i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdG)
	SBCI R31,HIGH(-_ThresholdG)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdG)
	SBCI R27,HIGH(-__ThresholdG)
	RCALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0163         ThresholdB [i] = _ThresholdB [i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdB)
	SBCI R31,HIGH(-_ThresholdB)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdB)
	SBCI R27,HIGH(-__ThresholdB)
	RCALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0164     }
	SUBI R17,-1
	RJMP _0x9C
_0x9D:
; 0000 0165 }
	RJMP _0x2060005
;
;void UpdateThresholdR()
; 0000 0168 {   unsigned char i;
_UpdateThresholdR:
; 0000 0169     for(i=0;i<8;i++)    _ThresholdR [i] = ThresholdR [i];
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x9F:
	CPI  R17,8
	BRSH _0xA0
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdR)
	SBCI R27,HIGH(-__ThresholdR)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdR)
	SBCI R31,HIGH(-_ThresholdR)
	LD   R30,Z
	RCALL __EEPROMWRB
	SUBI R17,-1
	RJMP _0x9F
_0xA0:
; 0000 016A }
	RJMP _0x2060005
;void UpdateThresholdG()
; 0000 016C {   unsigned char i;
_UpdateThresholdG:
; 0000 016D     for(i=0;i<8;i++)    _ThresholdG [i] = ThresholdG [i];
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0xA2:
	CPI  R17,8
	BRSH _0xA3
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdG)
	SBCI R27,HIGH(-__ThresholdG)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdG)
	SBCI R31,HIGH(-_ThresholdG)
	LD   R30,Z
	RCALL __EEPROMWRB
	SUBI R17,-1
	RJMP _0xA2
_0xA3:
; 0000 016E }
	RJMP _0x2060005
;
;void UpdateThresholdB()
; 0000 0171 {   unsigned char i;
_UpdateThresholdB:
; 0000 0172     for(i=0;i<8;i++)    _ThresholdB [i] = ThresholdB [i];
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0xA5:
	CPI  R17,8
	BRSH _0xA6
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-__ThresholdB)
	SBCI R27,HIGH(-__ThresholdB)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ThresholdB)
	SBCI R31,HIGH(-_ThresholdB)
	LD   R30,Z
	RCALL __EEPROMWRB
	SUBI R17,-1
	RJMP _0xA5
_0xA6:
; 0000 0173 }
_0x2060005:
	LD   R17,Y+
	RET
;
;
;unsigned char BacaSensorMerah(void)
; 0000 0177 {       EnR = 1;    EnG = 0;   EnB = 0;
_BacaSensorMerah:
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 0178         return (BacaSensor(&ThresholdR[0]));
	LDI  R26,LOW(_ThresholdR)
	LDI  R27,HIGH(_ThresholdR)
	RJMP _0x2060004
; 0000 0179 }
;
;unsigned char BacaSensorHijau(void)
; 0000 017C {       EnR = 0;    EnG = 1;   EnB = 0;
_BacaSensorHijau:
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 017D         return (BacaSensor(&ThresholdG[0]));
	LDI  R26,LOW(_ThresholdG)
	LDI  R27,HIGH(_ThresholdG)
	RJMP _0x2060004
; 0000 017E }
;
;unsigned char BacaSensorBiru(void)
; 0000 0181 {       EnR = 0;    EnG = 0;   EnB = 1;
_BacaSensorBiru:
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 0182         return (BacaSensor(&ThresholdB[0]));
	LDI  R26,LOW(_ThresholdB)
	LDI  R27,HIGH(_ThresholdB)
_0x2060004:
	RCALL _BacaSensor
	RET
; 0000 0183 }
;
;void KalibrasiDebug(unsigned char * x, unsigned char counter)
; 0000 0186 {   unsigned char i;
; 0000 0187     unsigned int DataKalibrasi[8];
; 0000 0188     for (i=0;i<8;i++) DataKalibrasi[i]=0;
;	*x -> Y+18
;	counter -> Y+17
;	i -> R17
;	DataKalibrasi -> Y+1
; 0000 0189 for (i=0;i<10;i++)
; 0000 018A     {   DelayOff;   StartADC(Data0);    En0=0;  DataKalibrasi[0]-= BacaADC();   // LED 0 OFF
; 0000 018B         DelayOn;    StartADC(Data0);    En0=1;  DataKalibrasi[0]+= BacaADC();   // LED 0 ON
; 0000 018C         DelayOff;   StartADC(Data1);    En1=0;  DataKalibrasi[1]-= BacaADC();   // LED 1 OFF
; 0000 018D         DelayOn;    StartADC(Data1);    En1=1;  DataKalibrasi[1]+= BacaADC();   // LED 1 ON
; 0000 018E         DelayOff;   StartADC(Data2);    En2=0;  DataKalibrasi[2]-= BacaADC();   // LED 2 OFF
; 0000 018F         DelayOn;    StartADC(Data2);    En2=1;  DataKalibrasi[2]+= BacaADC();   // LED 2 ON
; 0000 0190         DelayOff;   StartADC(Data3);    En3=0;  DataKalibrasi[3]-= BacaADC();   // LED 3 OFF
; 0000 0191         DelayOn;    StartADC(Data3);    En3=1;  DataKalibrasi[3]+= BacaADC();   // LED 3 ON
; 0000 0192         DelayOff;   StartADC(Data4);    En4=0;  DataKalibrasi[4]-= BacaADC();   // LED 4 OFF
; 0000 0193         DelayOn;    StartADC(Data4);    En4=1;  DataKalibrasi[4]+= BacaADC();   // LED 4 ON
; 0000 0194         DelayOff;   StartADC(Data5);    En5=0;  DataKalibrasi[5]-= BacaADC();   // LED 5 OFF
; 0000 0195         DelayOn;    StartADC(Data5);    En5=1;  DataKalibrasi[5]+= BacaADC();   // LED 5 ON
; 0000 0196         DelayOff;   StartADC(Data6);    En6=0;  DataKalibrasi[6]-= BacaADC();   // LED 6 OFF
; 0000 0197         DelayOn;    StartADC(Data6);    En6=1;  DataKalibrasi[6]+= BacaADC();   // LED 6 ON
; 0000 0198         DelayOff;   StartADC(Data7);    En7=0;  DataKalibrasi[7]-= BacaADC();   // LED 7 OFF
; 0000 0199         DelayOn;    StartADC(Data7);    En7=1;  DataKalibrasi[7]+= BacaADC();   // LED 7 ON
; 0000 019A     }
; 0000 019B     //EnR = 0;    EnG = 0;   EnB = 0;
; 0000 019C     putchar (counter);
; 0000 019D     for (i=0;i<8;i++)
; 0000 019E     {   putchar (*(x+i));
; 0000 019F         putchar ((DataKalibrasi[i]/10));
; 0000 01A0         x[i]= (int)(((int) (*(x+i))*(counter-1)) + (DataKalibrasi[i]/10))/counter;
; 0000 01A1         putchar (x[i]);
; 0000 01A2     }
; 0000 01A3 
; 0000 01A4 }
;
;void Kalibrasi(unsigned char * x, unsigned char counter)
; 0000 01A7 {   unsigned char i;
_Kalibrasi:
; 0000 01A8     unsigned int DataKalibrasi[8];
; 0000 01A9     for (i=0;i<8;i++) DataKalibrasi[i]=0;
	ST   -Y,R26
	SBIW R28,16
	ST   -Y,R17
;	*x -> Y+18
;	counter -> Y+17
;	i -> R17
;	DataKalibrasi -> Y+1
	LDI  R17,LOW(0)
_0xE3:
	CPI  R17,8
	BRSH _0xE4
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	SUBI R17,-1
	RJMP _0xE3
_0xE4:
; 0000 01AA for (i=0;i<10;i++)
	LDI  R17,LOW(0)
_0xE6:
	CPI  R17,10
	BRLO PC+2
	RJMP _0xE7
; 0000 01AB     {   DelayOff;   StartADC(Data0);    En0=0;  DataKalibrasi[0]-= BacaADC();   // LED 0 OFF
	__DELAY_USB 80
	LDI  R26,LOW(6)
	RCALL _StartADC
	CBI  0x18,1
	RCALL _BacaADC
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+1,R26
	STD  Y+1+1,R27
; 0000 01AC         DelayOn;    StartADC(Data0);    En0=1;  DataKalibrasi[0]+= BacaADC();   // LED 0 ON
	__DELAY_USB 133
	LDI  R26,LOW(6)
	RCALL _StartADC
	SBI  0x18,1
	RCALL _BacaADC
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 01AD         DelayOff;   StartADC(Data1);    En1=0;  DataKalibrasi[1]-= BacaADC();   // LED 1 OFF
	__DELAY_USB 80
	LDI  R26,LOW(7)
	RCALL _StartADC
	CBI  0x18,2
	RCALL _BacaADC
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+3,R26
	STD  Y+3+1,R27
; 0000 01AE         DelayOn;    StartADC(Data1);    En1=1;  DataKalibrasi[1]+= BacaADC();   // LED 1 ON
	__DELAY_USB 133
	LDI  R26,LOW(7)
	RCALL _StartADC
	SBI  0x18,2
	RCALL _BacaADC
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 01AF         DelayOff;   StartADC(Data2);    En2=0;  DataKalibrasi[2]-= BacaADC();   // LED 2 OFF
	__DELAY_USB 80
	LDI  R26,LOW(1)
	RCALL _StartADC
	CBI  0x18,3
	RCALL _BacaADC
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+5,R26
	STD  Y+5+1,R27
; 0000 01B0         DelayOn;    StartADC(Data2);    En2=1;  DataKalibrasi[2]+= BacaADC();   // LED 2 ON
	__DELAY_USB 133
	LDI  R26,LOW(1)
	RCALL _StartADC
	SBI  0x18,3
	RCALL _BacaADC
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+5,R30
	STD  Y+5+1,R31
; 0000 01B1         DelayOff;   StartADC(Data3);    En3=0;  DataKalibrasi[3]-= BacaADC();   // LED 3 OFF
	__DELAY_USB 80
	LDI  R26,LOW(0)
	RCALL _StartADC
	CBI  0x18,4
	RCALL _BacaADC
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+7,R26
	STD  Y+7+1,R27
; 0000 01B2         DelayOn;    StartADC(Data3);    En3=1;  DataKalibrasi[3]+= BacaADC();   // LED 3 ON
	__DELAY_USB 133
	LDI  R26,LOW(0)
	RCALL _StartADC
	SBI  0x18,4
	RCALL _BacaADC
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+7,R30
	STD  Y+7+1,R31
; 0000 01B3         DelayOff;   StartADC(Data4);    En4=0;  DataKalibrasi[4]-= BacaADC();   // LED 4 OFF
	__DELAY_USB 80
	LDI  R26,LOW(2)
	RCALL _StartADC
	CBI  0x12,5
	RCALL _BacaADC
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+9,R26
	STD  Y+9+1,R27
; 0000 01B4         DelayOn;    StartADC(Data4);    En4=1;  DataKalibrasi[4]+= BacaADC();   // LED 4 ON
	__DELAY_USB 133
	LDI  R26,LOW(2)
	RCALL _StartADC
	SBI  0x12,5
	RCALL _BacaADC
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 01B5         DelayOff;   StartADC(Data5);    En5=0;  DataKalibrasi[5]-= BacaADC();   // LED 5 OFF
	__DELAY_USB 80
	LDI  R26,LOW(3)
	RCALL _StartADC
	CBI  0x12,2
	RCALL _BacaADC
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+11,R26
	STD  Y+11+1,R27
; 0000 01B6         DelayOn;    StartADC(Data5);    En5=1;  DataKalibrasi[5]+= BacaADC();   // LED 5 ON
	__DELAY_USB 133
	LDI  R26,LOW(3)
	RCALL _StartADC
	SBI  0x12,2
	RCALL _BacaADC
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 01B7         DelayOff;   StartADC(Data6);    En6=0;  DataKalibrasi[6]-= BacaADC();   // LED 6 OFF
	__DELAY_USB 80
	LDI  R26,LOW(4)
	RCALL _StartADC
	CBI  0x12,3
	RCALL _BacaADC
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
; 0000 01B8         DelayOn;    StartADC(Data6);    En6=1;  DataKalibrasi[6]+= BacaADC();   // LED 6 ON
	__DELAY_USB 133
	LDI  R26,LOW(4)
	RCALL _StartADC
	SBI  0x12,3
	RCALL _BacaADC
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 01B9         DelayOff;   StartADC(Data7);    En7=0;  DataKalibrasi[7]-= BacaADC();   // LED 7 OFF
	__DELAY_USB 80
	LDI  R26,LOW(5)
	RCALL _StartADC
	CBI  0x12,4
	RCALL _BacaADC
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+15,R26
	STD  Y+15+1,R27
; 0000 01BA         DelayOn;    StartADC(Data7);    En7=1;  DataKalibrasi[7]+= BacaADC();   // LED 7 ON
	__DELAY_USB 133
	LDI  R26,LOW(5)
	RCALL _StartADC
	SBI  0x12,4
	RCALL _BacaADC
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 01BB     }
	SUBI R17,-1
	RJMP _0xE6
_0xE7:
; 0000 01BC     //EnR = 0;    EnG = 0;   EnB = 0;
; 0000 01BD     //putchar (counter);
; 0000 01BE     for (i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x109:
	CPI  R17,8
	BRSH _0x10A
; 0000 01BF     {   //putchar (*(x+i));
; 0000 01C0         //putchar ((DataKalibrasi[i]/10));
; 0000 01C1         x[i]= (int)(((int) (*(x+i))*(counter-1)) + (DataKalibrasi[i]/10))/counter;
	MOV  R30,R17
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	CLR  R27
	LDD  R30,Y+17
	SUBI R30,LOW(1)
	LDI  R31,0
	RCALL __MULW12
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+17
	LDI  R31,0
	RCALL __DIVW21
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01C2         //putchar (x[i]);
; 0000 01C3     }
	SUBI R17,-1
	RJMP _0x109
_0x10A:
; 0000 01C4 
; 0000 01C5 }
	LDD  R17,Y+0
	ADIW R28,20
	RET
;
;char KalibrasiRGB()
; 0000 01C8 {   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan biru
; 0000 01C9         Threshold Sensor Hijau diambil antara data di atas warna hijau dan hitam
; 0000 01CA         Threshold Sensor Biru diambil antara data di atas warna biru dan hijau
; 0000 01CB     */
_KalibrasiRGB:
; 0000 01CC     // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
; 0000 01CD     if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xF0)
	BREQ PC+2
	RJMP _0x10B
; 0000 01CE     {    EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 01CF         Kalibrasi(ThresholdR,1);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 01D0         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
; 0000 01D1         if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xF0)
	BRNE _0x112
; 0000 01D2         {   // Kalibrasi di atas warna hijau dilakukan untuk sensor biru dan hijau
; 0000 01D3             EnR = 0;    EnG = 1;   EnB = 0;
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 01D4             Kalibrasi(ThresholdG,1);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 01D5             EnR = 0;    EnG = 0;   EnB = 1;
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 01D6             Kalibrasi(ThresholdB,1);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 01D7             // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna biru
; 0000 01D8             if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xF0)
	BRNE _0x11F
; 0000 01D9             {   // Kalibrasi di atas warna biru dilakukan untuk sensor merah dan biru
; 0000 01DA                 EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 01DB                 Kalibrasi(ThresholdR,2);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 01DC                 EnR = 0;    EnG = 0;   EnB = 1;
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 01DD                 Kalibrasi(ThresholdB,2);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 01DE                 // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 01DF                 if (getchar()== pKalibrasiRGB) // jika protokol bukan kalibrasi RGB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xF0)
	BRNE _0x12C
; 0000 01E0                 {   // Kalibrasi di atas warna hitam dilakukan untuk sensor hijau saja
; 0000 01E1                     EnR = 0;    EnG = 1;   EnB = 0;
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 01E2                     Kalibrasi(ThresholdG,2);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 01E3                     UpdateThresholdR();         // menyimpan data kalibrasi sensor merah ke EEPROM
	RCALL _UpdateThresholdR
; 0000 01E4                     UpdateThresholdG();         // menyimpan data kalibrasi sensor hijau ke EEPROM
	RCALL _UpdateThresholdG
; 0000 01E5                     UpdateThresholdB();         // menyimpan data kalibrasi sensor biru ke EEPROM
	RCALL _UpdateThresholdB
; 0000 01E6                     _Mode = pKalibrasiRGB;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(240)
	RJMP _0x2060003
; 0000 01E7                     return 1;
; 0000 01E8                 }
; 0000 01E9             }
_0x12C:
; 0000 01EA         }
_0x11F:
; 0000 01EB     } return 0;
_0x112:
_0x10B:
	RJMP _0x2060002
; 0000 01EC }
;
;char KalibrasiMerahBiru(void)
; 0000 01EF {   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan biru
; 0000 01F0         Threshold Sensor Biru diambil antara data di atas warna biru dan hitam
; 0000 01F1     */
_KalibrasiMerahBiru:
; 0000 01F2     // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
; 0000 01F3     if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xD0)
	BRNE _0x133
; 0000 01F4     {   EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 01F5         Kalibrasi(ThresholdR,1);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 01F6         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
; 0000 01F7         if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xD0)
	BRNE _0x13A
; 0000 01F8         {   // Kalibrasi di atas warna biru dilakukan untuk sensor merah dan biru
; 0000 01F9             EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 01FA             Kalibrasi(ThresholdR,2);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 01FB             EnR = 0;    EnG = 0;   EnB = 1;
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 01FC             Kalibrasi(ThresholdB,1);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 01FD             // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 01FE             if (getchar()== pKalibrasiRB) // jika protokol bukan kalibrasi RB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xD0)
	BRNE _0x147
; 0000 01FF             {   // Kalibrasi di atas warna hitam dilakukan untuk sensor biru saja
; 0000 0200                 EnR = 0;    EnG = 0;   EnB = 1;
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 0201                 Kalibrasi(ThresholdB,2);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 0202                 UpdateThresholdR();     // menyimpan data kalibrasi sensor merah ke EEPROM
	RCALL _UpdateThresholdR
; 0000 0203                 UpdateThresholdB();     // menyimpan data kalibrasi sensor biru ke EEPROM
	RCALL _UpdateThresholdB
; 0000 0204                 _Mode = pKalibrasiRB;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(208)
	RJMP _0x2060003
; 0000 0205                 return 1;
; 0000 0206             }
; 0000 0207         }
_0x147:
; 0000 0208     } return 0;
_0x13A:
_0x133:
	RJMP _0x2060002
; 0000 0209 }
;
;char KalibrasiMerahHijau(void)
; 0000 020C {   /*  Threshold Sensor Merah diambil antara data di atas warna merah dan Hijau
; 0000 020D         Threshold Sensor Hijau diambil antara data di atas warna biru dan hitam
; 0000 020E     */
_KalibrasiMerahHijau:
; 0000 020F     if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xE0)
	BRNE _0x14E
; 0000 0210     {   // Kalibrasi Di atas warna merah hanya dilakukan untuk sensor merah saja
; 0000 0211         EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 0212         Kalibrasi(ThresholdR,1);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 0213         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hijau
; 0000 0214         if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xE0)
	BRNE _0x155
; 0000 0215         {   // Kalibrasi di atas warna hijau dilakukan untuk sensor merah dan hijau
; 0000 0216             EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 0217             Kalibrasi(ThresholdR,2);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 0218             EnR = 0;    EnG = 1;   EnB = 0;
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 0219             Kalibrasi(ThresholdG,1);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 021A             // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 021B             if (getchar()== pKalibrasiRG) // jika protokol bukan kalibrasi RG, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xE0)
	BRNE _0x162
; 0000 021C             {   // Kalibrasi di atas warna hitam dilakukan untuk sensor hijau saja
; 0000 021D                 EnR = 0;    EnG = 1;   EnB = 0;
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 021E                 Kalibrasi(ThresholdG,2);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 021F                 UpdateThresholdR();     // menyimpan data kalibrasi sensor merah ke EEPROM
	RCALL _UpdateThresholdR
; 0000 0220                 UpdateThresholdG();     // menyimpan data kalibrasi sensor hijau ke EEPROM
	RCALL _UpdateThresholdG
; 0000 0221                 _Mode = pKalibrasiRG;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(224)
	RJMP _0x2060003
; 0000 0222                 return 1;
; 0000 0223             }
; 0000 0224         }
_0x162:
; 0000 0225     } return 0;
_0x155:
_0x14E:
	RJMP _0x2060002
; 0000 0226 }
;
;
;char KalibrasiHitamPutihMerah(void)
; 0000 022A {   /*  Threshold Sensor Merah diambil antara data di atas warna Hitam dan Putih
; 0000 022B     */
_KalibrasiHitamPutihMerah:
; 0000 022C     if (getchar()== pKalibrasiHPR) // jika protokol bukan kalibrasi HPR, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xC0)
	BRNE _0x169
; 0000 022D     {   // Kalibrasi Di atas warna Putih
; 0000 022E         EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 022F         Kalibrasi(ThresholdR,1);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 0230         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 0231         if (getchar()== pKalibrasiHPR) // jika protokol bukan kalibrasi HPR, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xC0)
	BRNE _0x170
; 0000 0232         {   // Kalibrasi di atas warna hitam
; 0000 0233             Kalibrasi(ThresholdR,2);
	LDI  R30,LOW(_ThresholdR)
	LDI  R31,HIGH(_ThresholdR)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 0234             UpdateThresholdR();         // menyimpan data kalibrasi sensor merah ke EEPROM
	RCALL _UpdateThresholdR
; 0000 0235             _Mode = pKalibrasiHPR;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(192)
	RJMP _0x2060003
; 0000 0236             return 1;
; 0000 0237         }
; 0000 0238     } return 0;
_0x170:
_0x169:
	RJMP _0x2060002
; 0000 0239 }
;
;char KalibrasiHitamPutihBiru(void)
; 0000 023C {   /*  Threshold Sensor Biru diambil antara data di atas warna Hitam dan Putih
; 0000 023D     */
_KalibrasiHitamPutihBiru:
; 0000 023E     if (getchar()== pKalibrasiHPB) // jika protokol bukan kalibrasi HPB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0x90)
	BRNE _0x171
; 0000 023F     {   // Kalibrasi Di atas warna Putih
; 0000 0240         EnR = 0;    EnG = 0;   EnB = 1;
	CBI  0x12,7
	CBI  0x12,6
	SBI  0x18,0
; 0000 0241         Kalibrasi(ThresholdB,1);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 0242         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 0243         if (getchar()== pKalibrasiHPB) // jika protokol bukan kalibrasi HPB, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0x90)
	BRNE _0x178
; 0000 0244         {   // Kalibrasi di atas warna hitam
; 0000 0245             Kalibrasi(ThresholdB,2);
	LDI  R30,LOW(_ThresholdB)
	LDI  R31,HIGH(_ThresholdB)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 0246             UpdateThresholdB();         // menyimpan data kalibrasi sensor biru ke EEPROM
	RCALL _UpdateThresholdB
; 0000 0247             _Mode = pKalibrasiHPB;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(144)
	RJMP _0x2060003
; 0000 0248             return 1;
; 0000 0249         }
; 0000 024A     }return 0;
_0x178:
_0x171:
	RJMP _0x2060002
; 0000 024B }
;
;char KalibrasiHitamPutihHijau(void)
; 0000 024E {   /*  Threshold Sensor Hijau diambil antara data di atas warna Hitam dan Putih
; 0000 024F     */
_KalibrasiHitamPutihHijau:
; 0000 0250     if (getchar()== pKalibrasiHPG) // jika protokol bukan kalibrasi HPG, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xA0)
	BRNE _0x179
; 0000 0251     {   // Kalibrasi Di atas warna Putih
; 0000 0252         EnR = 0;    EnG = 1;   EnB = 0;
	CBI  0x12,7
	SBI  0x12,6
	CBI  0x18,0
; 0000 0253         Kalibrasi(ThresholdG,1);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Kalibrasi
; 0000 0254         // menunggu perintah dari master untuk melanjutkan kalibrasi diatas warna hitam
; 0000 0255         if (getchar()== pKalibrasiHPG) // jika protokol bukan kalibrasi HPG, maka proses kalibrasi dihentikan
	RCALL _getchar
	CPI  R30,LOW(0xA0)
	BRNE _0x180
; 0000 0256         {   // Kalibrasi di atas warna hitam
; 0000 0257             Kalibrasi(ThresholdG,2);
	LDI  R30,LOW(_ThresholdG)
	LDI  R31,HIGH(_ThresholdG)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Kalibrasi
; 0000 0258             UpdateThresholdG();         // menyimpan data kalibrasi sensor hijau ke EEPROM
	RCALL _UpdateThresholdG
; 0000 0259             _Mode = pKalibrasiHPG;
	LDI  R26,LOW(__Mode)
	LDI  R27,HIGH(__Mode)
	LDI  R30,LOW(160)
_0x2060003:
	RCALL __EEPROMWRB
; 0000 025A             return 1;
	LDI  R30,LOW(1)
	RET
; 0000 025B         }
; 0000 025C     } return 0;
_0x180:
_0x179:
_0x2060002:
	LDI  R30,LOW(0)
	RET
; 0000 025D }
;
;void main(void)
; 0000 0260 {
_main:
; 0000 0261 // Declare your local variables here
; 0000 0262 unsigned char sData;
; 0000 0263 
; 0000 0264 
; 0000 0265 // Input/Output Ports initialization
; 0000 0266 // Port B initialization
; 0000 0267 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0268 // State7=T State6=T State5=1 State4=1 State3=1 State2=1 State1=1 State0=0
; 0000 0269 PORTB=0x3E;
;	sData -> R17
	LDI  R30,LOW(62)
	OUT  0x18,R30
; 0000 026A DDRB=0x3F;
	LDI  R30,LOW(63)
	OUT  0x17,R30
; 0000 026B 
; 0000 026C // Port C initialization
; 0000 026D // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 026E // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 026F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0270 DDRC=0x00;
	OUT  0x14,R30
; 0000 0271 
; 0000 0272 // Port D initialization
; 0000 0273 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 0274 // State7=0 State6=0 State5=T State4=1 State3=1 State2=1 State1=T State0=T
; 0000 0275 PORTD=0x1C;
	LDI  R30,LOW(28)
	OUT  0x12,R30
; 0000 0276 DDRD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 0277 // Timer/Counter 0 initialization
; 0000 0278 // Clock source: System Clock
; 0000 0279 // Clock value: Timer 0 Stopped
; 0000 027A TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 027B TCNT0=0x00;
	OUT  0x32,R30
; 0000 027C 
; 0000 027D // Timer/Counter 1 initialization
; 0000 027E // Clock source: System Clock
; 0000 027F // Clock value: Timer1 Stopped
; 0000 0280 // Mode: Normal top=0xFFFF
; 0000 0281 // OC1A output: Discon.
; 0000 0282 // OC1B output: Discon.
; 0000 0283 // Noise Canceler: Off
; 0000 0284 // Input Capture on Falling Edge
; 0000 0285 // Timer1 Overflow Interrupt: Off
; 0000 0286 // Input Capture Interrupt: Off
; 0000 0287 // Compare A Match Interrupt: Off
; 0000 0288 // Compare B Match Interrupt: Off
; 0000 0289 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 028A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 028B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 028C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 028D ICR1H=0x00;
	OUT  0x27,R30
; 0000 028E ICR1L=0x00;
	OUT  0x26,R30
; 0000 028F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0290 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0291 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0292 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0293 
; 0000 0294 // Timer/Counter 2 initialization
; 0000 0295 // Clock source: System Clock
; 0000 0296 // Clock value: Timer2 Stopped
; 0000 0297 // Mode: Normal top=0xFF
; 0000 0298 // OC2 output: Disconnected
; 0000 0299 ASSR=0x00;
	OUT  0x22,R30
; 0000 029A TCCR2=0x00;
	OUT  0x25,R30
; 0000 029B TCNT2=0x00;
	OUT  0x24,R30
; 0000 029C OCR2=0x00;
	OUT  0x23,R30
; 0000 029D 
; 0000 029E // External Interrupt(s) initialization
; 0000 029F // INT0: Off
; 0000 02A0 // INT1: Off
; 0000 02A1 MCUCR=0x00;
	OUT  0x35,R30
; 0000 02A2 
; 0000 02A3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02A4 TIMSK=0x00;
	OUT  0x39,R30
; 0000 02A5 
; 0000 02A6 // USART initialization
; 0000 02A7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02A8 // USART Receiver: On
; 0000 02A9 // USART Transmitter: On
; 0000 02AA // USART Mode: Asynchronous
; 0000 02AB // USART Baud Rate: 9600
; 0000 02AC UCSRA=0x00;
	OUT  0xB,R30
; 0000 02AD UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 02AE UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02AF UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02B0 UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 02B1 
; 0000 02B2 // Analog Comparator initialization
; 0000 02B3 // Analog Comparator: Off
; 0000 02B4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02B5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02B6 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02B7 
; 0000 02B8 // ADC initialization
; 0000 02B9 // ADC Clock frequency: 500,000 kHz
; 0000 02BA // ADC Voltage Reference: AREF pin
; 0000 02BB // Only the 8 most significant bits of
; 0000 02BC // the AD conversion result are used
; 0000 02BD ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 02BE ADCSRA=0x85;        // 500kHz
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 02BF //ADCSRA=0x8C;        // 1Mhz
; 0000 02C0 
; 0000 02C1 // SPI initialization
; 0000 02C2 // SPI disabled
; 0000 02C3 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 02C4 
; 0000 02C5 // TWI initialization
; 0000 02C6 // TWI disabled
; 0000 02C7 TWCR=0x00;
	OUT  0x36,R30
; 0000 02C8 
; 0000 02C9 // Global enable interrupts
; 0000 02CA 
; 0000 02CB if (_DeviceAddress==0xFF) _DeviceAddress = 0;   // // nilai antara 0-15
	LDI  R26,LOW(__DeviceAddress)
	LDI  R27,HIGH(__DeviceAddress)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	BRNE _0x181
	LDI  R26,LOW(__DeviceAddress)
	LDI  R27,HIGH(__DeviceAddress)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 02CC DeviceAddress = _DeviceAddress;
_0x181:
	LDI  R26,LOW(__DeviceAddress)
	LDI  R27,HIGH(__DeviceAddress)
	RCALL __EEPROMRDB
	MOV  R4,R30
; 0000 02CD ReloadThreshold();
	RCALL _ReloadThreshold
; 0000 02CE 
; 0000 02CF #asm("sei")
	sei
; 0000 02D0 
; 0000 02D1 while (1)
_0x182:
; 0000 02D2  { sData=getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 02D3    if((sData & 0x0F)==_DeviceAddress)
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R0,R30
	LDI  R26,LOW(__DeviceAddress)
	LDI  R27,HIGH(__DeviceAddress)
	RCALL __EEPROMRDB
	CP   R30,R0
	BREQ PC+2
	RJMP _0x185
; 0000 02D4    { switch (sData)
	MOV  R30,R17
; 0000 02D5      {  case    pBacaSensorRGB:
	CPI  R30,LOW(0x70)
	BRNE _0x189
; 0000 02D6         {       //ResetThreshold();
; 0000 02D7                 EnR = 1;    EnG = 0;   EnB = 0;
	SBI  0x12,7
	CBI  0x12,6
	CBI  0x18,0
; 0000 02D8                 putchar(pBacaSensorRGB|DeviceAddress);
	MOV  R30,R4
	ORI  R30,LOW(0x70)
	MOV  R26,R30
	RCALL _putchar
; 0000 02D9                 putchar(BacaSensorMerah());
	RCALL _BacaSensorMerah
	MOV  R26,R30
	RCALL _putchar
; 0000 02DA                 putchar(BacaSensorHijau());
	RCALL _BacaSensorHijau
	MOV  R26,R30
	RCALL _putchar
; 0000 02DB                 putchar(BacaSensorBiru());
	RCALL _BacaSensorBiru
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02DC                 break;
; 0000 02DD         }
; 0000 02DE         case    pBacaSensorRG:
_0x189:
	CPI  R30,LOW(0x60)
	BRNE _0x190
; 0000 02DF         {       putchar(pBacaSensorRG|DeviceAddress);
	MOV  R30,R4
	ORI  R30,LOW(0x60)
	MOV  R26,R30
	RCALL _putchar
; 0000 02E0                 putchar(BacaSensorMerah());
	RCALL _BacaSensorMerah
	MOV  R26,R30
	RCALL _putchar
; 0000 02E1                 putchar(BacaSensorHijau());
	RCALL _BacaSensorHijau
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02E2                 break;
; 0000 02E3         }
; 0000 02E4         case    pBacaSensorRB:
_0x190:
	CPI  R30,LOW(0x50)
	BRNE _0x191
; 0000 02E5         {       putchar(pBacaSensorRB|DeviceAddress);
	MOV  R30,R4
	ORI  R30,LOW(0x50)
	MOV  R26,R30
	RCALL _putchar
; 0000 02E6                 putchar(BacaSensorMerah());
	RCALL _BacaSensorMerah
	MOV  R26,R30
	RCALL _putchar
; 0000 02E7                 putchar(BacaSensorBiru());
	RCALL _BacaSensorBiru
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02E8                 break;
; 0000 02E9         }
; 0000 02EA         case    pBacaSensorGB:
_0x191:
	CPI  R30,LOW(0x30)
	BRNE _0x192
; 0000 02EB         {       putchar(pBacaSensorGB|DeviceAddress);
	MOV  R30,R4
	ORI  R30,LOW(0x30)
	MOV  R26,R30
	RCALL _putchar
; 0000 02EC                 putchar(BacaSensorHijau());
	RCALL _BacaSensorHijau
	MOV  R26,R30
	RCALL _putchar
; 0000 02ED                 putchar(BacaSensorBiru());
	RCALL _BacaSensorBiru
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02EE                 break;
; 0000 02EF         }
; 0000 02F0         case    pBacaSensorR:
_0x192:
	CPI  R30,LOW(0x40)
	BRNE _0x193
; 0000 02F1         {       putchar(pBacaSensorR|DeviceAddress);
	MOV  R30,R4
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _putchar
; 0000 02F2                 putchar(BacaSensorMerah());
	RCALL _BacaSensorMerah
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02F3                 break;
; 0000 02F4         }
; 0000 02F5         case    pBacaSensorG:
_0x193:
	CPI  R30,LOW(0x20)
	BRNE _0x194
; 0000 02F6         {       putchar(pBacaSensorG|DeviceAddress);
	MOV  R30,R4
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _putchar
; 0000 02F7                 putchar(BacaSensorHijau());     break;
	RCALL _BacaSensorHijau
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02F8         }
; 0000 02F9         case    pBacaSensorB:
_0x194:
	CPI  R30,LOW(0x10)
	BRNE _0x195
; 0000 02FA         {       putchar(pBacaSensorB|DeviceAddress);
	MOV  R30,R4
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _putchar
; 0000 02FB                 putchar(BacaSensorBiru());      break;
	RCALL _BacaSensorBiru
	MOV  R26,R30
	RJMP _0x1AA
; 0000 02FC         }
; 0000 02FD         case    pKalibrasiRGB:
_0x195:
	CPI  R30,LOW(0xF0)
	BRNE _0x196
; 0000 02FE         {       if(KalibrasiRGB())              putchar(pKalibrasiRGB);
	RCALL _KalibrasiRGB
	CPI  R30,0
	BREQ _0x197
	LDI  R26,LOW(240)
	RJMP _0x1AB
; 0000 02FF                 else                            putchar(pError);
_0x197:
	LDI  R26,LOW(0)
_0x1AB:
	RCALL _putchar
; 0000 0300                 break;
	RJMP _0x188
; 0000 0301         }
; 0000 0302         case    pKalibrasiRB:
_0x196:
	CPI  R30,LOW(0xD0)
	BRNE _0x199
; 0000 0303         {       if(KalibrasiMerahBiru())        putchar(pKalibrasiRB);
	RCALL _KalibrasiMerahBiru
	CPI  R30,0
	BREQ _0x19A
	LDI  R26,LOW(208)
	RJMP _0x1AC
; 0000 0304                 else                            putchar(pError);
_0x19A:
	LDI  R26,LOW(0)
_0x1AC:
	RCALL _putchar
; 0000 0305                 break;
	RJMP _0x188
; 0000 0306         }
; 0000 0307         case    pKalibrasiRG:
_0x199:
	CPI  R30,LOW(0xE0)
	BRNE _0x19C
; 0000 0308         {       if(KalibrasiMerahHijau())       putchar(pKalibrasiRG);
	RCALL _KalibrasiMerahHijau
	CPI  R30,0
	BREQ _0x19D
	LDI  R26,LOW(224)
	RJMP _0x1AD
; 0000 0309                 else                            putchar(pError);
_0x19D:
	LDI  R26,LOW(0)
_0x1AD:
	RCALL _putchar
; 0000 030A                 break;
	RJMP _0x188
; 0000 030B         }
; 0000 030C         case    pKalibrasiHPR:
_0x19C:
	CPI  R30,LOW(0xC0)
	BRNE _0x19F
; 0000 030D         {       if(KalibrasiHitamPutihMerah())  putchar(pKalibrasiHPR);
	RCALL _KalibrasiHitamPutihMerah
	CPI  R30,0
	BREQ _0x1A0
	LDI  R26,LOW(192)
	RJMP _0x1AE
; 0000 030E                 else                            putchar(pError);
_0x1A0:
	LDI  R26,LOW(0)
_0x1AE:
	RCALL _putchar
; 0000 030F                 break;
	RJMP _0x188
; 0000 0310         }
; 0000 0311         case    pKalibrasiHPB:
_0x19F:
	CPI  R30,LOW(0x90)
	BRNE _0x1A2
; 0000 0312         {       if(KalibrasiHitamPutihBiru())   putchar(pKalibrasiHPB);
	RCALL _KalibrasiHitamPutihBiru
	CPI  R30,0
	BREQ _0x1A3
	LDI  R26,LOW(144)
	RJMP _0x1AF
; 0000 0313                 else                            putchar(pError);
_0x1A3:
	LDI  R26,LOW(0)
_0x1AF:
	RCALL _putchar
; 0000 0314                 break;
	RJMP _0x188
; 0000 0315         }
; 0000 0316         case    pKalibrasiHPG:
_0x1A2:
	CPI  R30,LOW(0xA0)
	BRNE _0x1A8
; 0000 0317         {       if(KalibrasiHitamPutihHijau())  putchar(pKalibrasiHPG);
	RCALL _KalibrasiHitamPutihHijau
	CPI  R30,0
	BREQ _0x1A6
	LDI  R26,LOW(160)
	RJMP _0x1B0
; 0000 0318                 else                            putchar(pError);
_0x1A6:
	LDI  R26,LOW(0)
_0x1B0:
	RCALL _putchar
; 0000 0319                 break;
	RJMP _0x188
; 0000 031A         }
; 0000 031B         default:
_0x1A8:
; 0000 031C         {       putchar(pError);
	LDI  R26,LOW(0)
_0x1AA:
	RCALL _putchar
; 0000 031D         }
; 0000 031E      }
_0x188:
; 0000 031F    }
; 0000 0320  }
_0x185:
	RJMP _0x182
; 0000 0321 }
_0x1A9:
	RJMP _0x1A9
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_ThresholdR:
	.BYTE 0x8
_ThresholdG:
	.BYTE 0x8
_ThresholdB:
	.BYTE 0x8

	.ESEG
__ThresholdR:
	.BYTE 0x8
__ThresholdG:
	.BYTE 0x8
__ThresholdB:
	.BYTE 0x8
__Mode:
	.BYTE 0x1
__DeviceAddress:
	.BYTE 0x1

	.DSEG
_rx_buffer:
	.BYTE 0x8

	.CSEG

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
