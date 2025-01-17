
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x20000:
	.DB  0x51,0x73,0x74,0x31,0x3A,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x20,0x2E,0x2E,0x2E,0x0
	.DB  0x46,0x61,0x72,0x7A,0x61,0x6E,0x65,0x68
	.DB  0x0,0x39,0x37,0x33,0x33,0x35,0x30,0x33
	.DB  0x0
_0x40003:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x20
	.DB  0x74,0x6F,0x20,0x74,0x68,0x65,0x20,0x6F
	.DB  0x6E,0x6C,0x69,0x6E,0x65,0x20,0x6C,0x61
	.DB  0x62,0x20,0x63,0x6C,0x61,0x73,0x73,0x65
	.DB  0x73,0x20,0x64,0x75,0x65,0x20,0x74,0x6F
	.DB  0x20,0x43,0x6F,0x72,0x6F,0x6E,0x61,0x20
	.DB  0x64,0x69,0x73,0x65,0x61,0x73,0x65,0x2E
	.DB  0x0
_0x40000:
	.DB  0x51,0x73,0x74,0x32,0x3A,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x20,0x2E,0x2E,0x2E,0x0
_0x60000:
	.DB  0x51,0x73,0x74,0x33,0x3A,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x20,0x2E,0x2E,0x2E,0x0
_0x80000:
	.DB  0x51,0x73,0x74,0x34,0x3A,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x2E,0x2E,0x2E,0x0
_0xA0000:
	.DB  0x51,0x73,0x74,0x35,0x3A,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x20,0x2E,0x2E,0x2E,0x0
	.DB  0x53,0x70,0x65,0x65,0x64,0x3A,0x3F,0x3F
	.DB  0x28,0x30,0x30,0x2D,0x35,0x30,0x72,0x29
	.DB  0x0,0x49,0x6E,0x70,0x75,0x74,0x3A,0x20
	.DB  0x0,0x45,0x52,0x52,0x4F,0x52,0x21,0x0
	.DB  0x54,0x69,0x6D,0x65,0x3A,0x3F,0x3F,0x28
	.DB  0x30,0x30,0x2D,0x39,0x39,0x73,0x29,0x0
	.DB  0x57,0x65,0x69,0x67,0x74,0x3A,0x3F,0x3F
	.DB  0x28,0x30,0x30,0x2D,0x39,0x39,0x46,0x29
	.DB  0x0,0x54,0x65,0x6D,0x70,0x3A,0x3F,0x3F
	.DB  0x28,0x32,0x30,0x2D,0x38,0x30,0x43,0x29
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _key_pad
	.DW  _0x3*2

	.DW  0x10
	.DW  _0x20003
	.DW  _0x20000*2

	.DW  0x09
	.DW  _0x20003+16
	.DW  _0x20000*2+16

	.DW  0x08
	.DW  _0x20003+25
	.DW  _0x20000*2+25

	.DW  0x10
	.DW  _0x40004
	.DW  _0x40000*2

	.DW  0x10
	.DW  _0x60003
	.DW  _0x60000*2

	.DW  0x0F
	.DW  _0x80003
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0xA0003
	.DW  _0xA0000*2

	.DW  0x11
	.DW  _0xA0003+16
	.DW  _0xA0000*2+16

	.DW  0x08
	.DW  _0xA0003+33
	.DW  _0xA0000*2+33

	.DW  0x07
	.DW  _0xA0003+41
	.DW  _0xA0000*2+41

	.DW  0x10
	.DW  _0xA0003+48
	.DW  _0xA0000*2+48

	.DW  0x08
	.DW  _0xA0003+64
	.DW  _0xA0000*2+33

	.DW  0x07
	.DW  _0xA0003+72
	.DW  _0xA0000*2+41

	.DW  0x11
	.DW  _0xA0003+79
	.DW  _0xA0000*2+64

	.DW  0x08
	.DW  _0xA0003+96
	.DW  _0xA0000*2+33

	.DW  0x07
	.DW  _0xA0003+104
	.DW  _0xA0000*2+41

	.DW  0x10
	.DW  _0xA0003+111
	.DW  _0xA0000*2+81

	.DW  0x08
	.DW  _0xA0003+127
	.DW  _0xA0000*2+33

	.DW  0x07
	.DW  _0xA0003+135
	.DW  _0xA0000*2+41

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/17/2021
;Author  : Farzaneh Koohestani
;Company : IUT
;Comments:
;Session: 3
;Question: 6
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Declare your global variables here
;
;unsigned char key_pad[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

	.DSEG
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0022 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0023 // Place your code here
; 0000 0024     DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0025     PORTB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 0026     keypad();
	CALL _keypad
; 0000 0027 
; 0000 0028 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 002B {
_main:
; .FSTART _main
; 0000 002C // Declare your local variables here
; 0000 002D 
; 0000 002E  init();
	CALL _init
; 0000 002F  func6();
	CALL _func6
; 0000 0030 // Global enable interrupts
; 0000 0031 
; 0000 0032 while (1)
_0x4:
; 0000 0033       {
; 0000 0034       // Place your code here
; 0000 0035 
; 0000 0036       }
	RJMP _0x4
; 0000 0037 }
_0x7:
	RJMP _0x7
; .FEND
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func1(void){
; 0001 0003 void func1(void){

	.CSEG
_func1:
; .FSTART _func1
; 0001 0004     lcd_clear();
	CALL _lcd_clear
; 0001 0005     lcd_puts("Qst1: Start ...");
	__POINTW2MN _0x20003,0
	CALL SUBOPT_0x0
; 0001 0006     delay_ms(1000);
; 0001 0007     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0001 0008     lcd_clear();
	CALL _lcd_clear
; 0001 0009     lcd_puts("Farzaneh");
	__POINTW2MN _0x20003,16
	CALL SUBOPT_0x1
; 0001 000A     lcd_gotoxy(0,1);
; 0001 000B     lcd_puts("9733503");
	__POINTW2MN _0x20003,25
	CALL SUBOPT_0x0
; 0001 000C     delay_ms(1000);
; 0001 000D     return;
	RET
; 0001 000E }
; .FEND

	.DSEG
_0x20003:
	.BYTE 0x21
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func2(void){
; 0002 0003 void func2(void){

	.CSEG
_func2:
; .FSTART _func2
; 0002 0004     int i = 0, j;
; 0002 0005     char temp[17];
; 0002 0006     char arr[]="Welcome to the online lab classes due to Corona disease.";
; 0002 0007     char len = strlen(arr);
; 0002 0008       lcd_clear();
	SBIW R28,63
	SBIW R28,11
	LDI  R24,57
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x40003*2)
	LDI  R31,HIGH(_0x40003*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	temp -> Y+63
;	arr -> Y+6
;	len -> R21
	__GETWRN 16,17,0
	MOVW R26,R28
	ADIW R26,6
	CALL _strlen
	MOV  R21,R30
	CALL _lcd_clear
; 0002 0009     lcd_puts("Qst2: Start ...");
	__POINTW2MN _0x40004,0
	CALL SUBOPT_0x0
; 0002 000A     delay_ms(1000);
; 0002 000B     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0002 000C     lcd_clear();
	CALL _lcd_clear
; 0002 000D     while(i != len){
_0x40005:
	MOV  R30,R21
	MOVW R26,R16
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x40007
; 0002 000E         for(j = 0; j < 16; j = j + 1){
	__GETWRN 18,19,0
_0x40009:
	__CPWRN 18,19,16
	BRGE _0x4000A
; 0002 000F             if(arr[i] == '\0')
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x4000A
; 0002 0010                 break;
; 0002 0011             temp[j] = arr[i+j];
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,63
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R18
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0002 0012         }
	__ADDWRN 18,19,1
	RJMP _0x40009
_0x4000A:
; 0002 0013         temp[16]='\0';
	LDI  R30,LOW(0)
	__PUTB1SX 79
; 0002 0014         i = i + 1;
	__ADDWRN 16,17,1
; 0002 0015         lcd_clear();
	CALL _lcd_clear
; 0002 0016         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2
; 0002 0017         lcd_puts(temp);
	MOVW R26,R28
	ADIW R26,63
	CALL _lcd_puts
; 0002 0018         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0002 0019     }
	RJMP _0x40005
_0x40007:
; 0002 001A     lcd_clear();
	CALL _lcd_clear
; 0002 001B     return;
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,17
	RET
; 0002 001C }
; .FEND

	.DSEG
_0x40004:
	.BYTE 0x10
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func3(void){
; 0003 0003 void func3(void){

	.CSEG
_func3:
; .FSTART _func3
; 0003 0004     int key = 16;
; 0003 0005     DDRB = 0xF0;
	CALL SUBOPT_0x3
;	key -> R16,R17
; 0003 0006     PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0003 0007     lcd_clear();
	CALL _lcd_clear
; 0003 0008     lcd_puts("Qst3: Start ...")  ;
	__POINTW2MN _0x60003,0
	CALL SUBOPT_0x0
; 0003 0009     delay_ms(1000);
; 0003 000A     lcd_clear();
	CALL _lcd_clear
; 0003 000B 
; 0003 000C     do{
_0x60005:
; 0003 000D         PORTB.4=1; PORTB.5=0; PORTB.6=0; PORTB.7=0;
	SBI  0x18,4
	CBI  0x18,5
	CBI  0x18,6
	CBI  0x18,7
; 0003 000E         if(PINB.0) { key = 1;  continue;}
	SBIS 0x16,0
	RJMP _0x6000F
	__GETWRN 16,17,1
	RJMP _0x60004
; 0003 000F         if(PINB.1) {key = 2;  continue;}
_0x6000F:
	SBIS 0x16,1
	RJMP _0x60010
	__GETWRN 16,17,2
	RJMP _0x60004
; 0003 0010         if(PINB.2) {key = 3;  continue;}
_0x60010:
	SBIS 0x16,2
	RJMP _0x60011
	__GETWRN 16,17,3
	RJMP _0x60004
; 0003 0011         if(PINB.3) {key =10;   continue;}
_0x60011:
	SBIS 0x16,3
	RJMP _0x60012
	__GETWRN 16,17,10
	RJMP _0x60004
; 0003 0012         delay_ms(10);
_0x60012:
	CALL SUBOPT_0x4
; 0003 0013         PORTB.4=0; PORTB.5=1; PORTB.6=0; PORTB.7=0;
	SBI  0x18,5
	CBI  0x18,6
	CBI  0x18,7
; 0003 0014         if(PINB.0) {key = 4;  continue;}
	SBIS 0x16,0
	RJMP _0x6001B
	__GETWRN 16,17,4
	RJMP _0x60004
; 0003 0015         if(PINB.1) {key =  5; continue;}
_0x6001B:
	SBIS 0x16,1
	RJMP _0x6001C
	__GETWRN 16,17,5
	RJMP _0x60004
; 0003 0016         if(PINB.2) {key =  6;  continue;}
_0x6001C:
	SBIS 0x16,2
	RJMP _0x6001D
	__GETWRN 16,17,6
	RJMP _0x60004
; 0003 0017         if(PINB.3) {key =  11; continue;}
_0x6001D:
	SBIS 0x16,3
	RJMP _0x6001E
	__GETWRN 16,17,11
	RJMP _0x60004
; 0003 0018         delay_ms(10);
_0x6001E:
	CALL SUBOPT_0x4
; 0003 0019         PORTB.4=0; PORTB.5=0; PORTB.6=1; PORTB.7=0;
	CBI  0x18,5
	SBI  0x18,6
	CBI  0x18,7
; 0003 001A         if(PINB.0) {key =  7;   continue;}
	SBIS 0x16,0
	RJMP _0x60027
	__GETWRN 16,17,7
	RJMP _0x60004
; 0003 001B         if(PINB.1) {key =  8;   continue;}
_0x60027:
	SBIS 0x16,1
	RJMP _0x60028
	__GETWRN 16,17,8
	RJMP _0x60004
; 0003 001C         if(PINB.2) {key =  9;   continue;}
_0x60028:
	SBIS 0x16,2
	RJMP _0x60029
	__GETWRN 16,17,9
	RJMP _0x60004
; 0003 001D         if(PINB.3) {key =  12; continue;}
_0x60029:
	SBIS 0x16,3
	RJMP _0x6002A
	__GETWRN 16,17,12
	RJMP _0x60004
; 0003 001E         delay_ms(10);
_0x6002A:
	CALL SUBOPT_0x4
; 0003 001F         PORTB.4=0; PORTB.5=0; PORTB.6=0; PORTB.7=1;
	CBI  0x18,5
	CBI  0x18,6
	SBI  0x18,7
; 0003 0020         if(PINB.0) {key =  15;   continue;}
	SBIS 0x16,0
	RJMP _0x60033
	__GETWRN 16,17,15
	RJMP _0x60004
; 0003 0021         if(PINB.1) {key =  0;     continue;}
_0x60033:
	SBIS 0x16,1
	RJMP _0x60034
	__GETWRN 16,17,0
	RJMP _0x60004
; 0003 0022         if(PINB.2) {key =  14;   continue;}
_0x60034:
	SBIS 0x16,2
	RJMP _0x60035
	__GETWRN 16,17,14
	RJMP _0x60004
; 0003 0023         if(PINB.3) {key =  13;   continue;}
_0x60035:
	SBIS 0x16,3
	RJMP _0x60036
	__GETWRN 16,17,13
	RJMP _0x60004
; 0003 0024         delay_ms(10);
_0x60036:
	CALL SUBOPT_0x5
; 0003 0025         key = 16;
	__GETWRN 16,17,16
; 0003 0026     } while(key == 16);
_0x60004:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x60006
	RJMP _0x60005
_0x60006:
; 0003 0027 
; 0003 0028      lcd_putchar(key_pad[key]);
	CALL SUBOPT_0x6
; 0003 0029      delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL SUBOPT_0x7
; 0003 002A      lcd_clear();
; 0003 002B      return;
	JMP  _0x2040002
; 0003 002C 
; 0003 002D 
; 0003 002E }
; .FEND

	.DSEG
_0x60003:
	.BYTE 0x10
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func4(){
; 0004 0003 void func4(){

	.CSEG
_func4:
; .FSTART _func4
; 0004 0004     lcd_clear();
	CALL _lcd_clear
; 0004 0005     DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0004 0006     PORTB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0004 0007 
; 0004 0008     lcd_puts("Qst4: Start...");
	__POINTW2MN _0x80003,0
	CALL SUBOPT_0x0
; 0004 0009     delay_ms(1000);
; 0004 000A     lcd_clear();
	CALL _lcd_clear
; 0004 000B 
; 0004 000C     #asm("sei")
	sei
; 0004 000D 
; 0004 000E    while(1){
_0x80004:
; 0004 000F          PORTB.0=1; PORTB.1=0; PORTB.2=0; PORTB.3=0;
	SBI  0x18,0
	CBI  0x18,1
	CBI  0x18,2
	CBI  0x18,3
; 0004 0010         delay_ms(10);
	CALL SUBOPT_0x5
; 0004 0011         PORTB.0=0; PORTB.1=1; PORTB.2=0; PORTB.3=0;
	CBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
	CBI  0x18,3
; 0004 0012         delay_ms(10);
	CALL SUBOPT_0x5
; 0004 0013         PORTB.0=0; PORTB.1=0; PORTB.2=1; PORTB.3=0;
	CBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
	CBI  0x18,3
; 0004 0014         delay_ms(10);
	CALL SUBOPT_0x5
; 0004 0015         PORTB.0=0; PORTB.1=0; PORTB.2=0; PORTB.3=1;
	CBI  0x18,0
	CBI  0x18,1
	CBI  0x18,2
	SBI  0x18,3
; 0004 0016         delay_ms(10);
	CALL SUBOPT_0x5
; 0004 0017          }
	RJMP _0x80004
; 0004 0018 }
; .FEND

	.DSEG
_0x80003:
	.BYTE 0xF
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func5(void){
; 0005 0003 void func5(void){

	.CSEG
_func5:
; .FSTART _func5
; 0005 0004     unsigned char dig1, dig2;
; 0005 0005     lcd_clear();
	ST   -Y,R17
	ST   -Y,R16
;	dig1 -> R17
;	dig2 -> R16
	CALL _lcd_clear
; 0005 0006     lcd_puts("Qst5: Start ...");
	__POINTW2MN _0xA0003,0
	CALL SUBOPT_0x0
; 0005 0007     delay_ms(1000);
; 0005 0008     lcd_clear();
	CALL _lcd_clear
; 0005 0009 
; 0005 000A    while(1){
_0xA0004:
; 0005 000B         lcd_clear();
	CALL _lcd_clear
; 0005 000C         lcd_puts("Speed:??(00-50r)");
	__POINTW2MN _0xA0003,16
	CALL SUBOPT_0x1
; 0005 000D         lcd_gotoxy(0,1);
; 0005 000E         lcd_puts("Input: ");
	__POINTW2MN _0xA0003,33
	CALL SUBOPT_0x8
; 0005 000F         dig1 = keypad();
; 0005 0010         dig2 = keypad();
; 0005 0011 
; 0005 0012         if(dig1>5 || dig2>9||(dig1 == 5 && dig2 != 0)){
	CPI  R17,6
	BRSH _0xA0008
	CPI  R16,10
	BRSH _0xA0008
	CPI  R17,5
	BRNE _0xA0009
	CPI  R16,0
	BRNE _0xA0008
_0xA0009:
	RJMP _0xA0007
_0xA0008:
; 0005 0013              lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0005 0014              lcd_putchar('E');
	CALL SUBOPT_0x9
; 0005 0015              lcd_gotoxy(7,0);
; 0005 0016              lcd_putchar('E');
	CALL SUBOPT_0xA
; 0005 0017              lcd_gotoxy(1,0);
; 0005 0018              delay_ms(1000);
	CALL SUBOPT_0xB
; 0005 0019              lcd_clear();
; 0005 001A              lcd_puts("ERROR!");
	__POINTW2MN _0xA0003,41
	CALL SUBOPT_0x0
; 0005 001B              delay_ms(1000);
; 0005 001C         }
; 0005 001D         else{
	RJMP _0xA000C
_0xA0007:
; 0005 001E              lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0005 001F              lcd_putchar(key_pad[dig1]);
	CALL SUBOPT_0xC
; 0005 0020              lcd_gotoxy(6,0);
; 0005 0021              lcd_putchar(key_pad[dig2]);
	CALL SUBOPT_0xD
; 0005 0022              delay_ms(1000);
; 0005 0023              break;
	RJMP _0xA0006
; 0005 0024         }
_0xA000C:
; 0005 0025         }
	RJMP _0xA0004
_0xA0006:
; 0005 0026    while(1){
_0xA000D:
; 0005 0027         lcd_clear();
	CALL _lcd_clear
; 0005 0028         lcd_puts("Time:??(00-99s)");
	__POINTW2MN _0xA0003,48
	CALL SUBOPT_0x1
; 0005 0029         lcd_gotoxy(0,1);
; 0005 002A         lcd_puts("Input: ");
	__POINTW2MN _0xA0003,64
	CALL SUBOPT_0x8
; 0005 002B         dig1 = keypad();
; 0005 002C         dig2 = keypad();
; 0005 002D 
; 0005 002E         if(dig1>9 || dig2>9){
	CPI  R17,10
	BRSH _0xA0011
	CPI  R16,10
	BRLO _0xA0010
_0xA0011:
; 0005 002F              lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0005 0030              lcd_putchar('E');
	CALL SUBOPT_0xE
; 0005 0031              lcd_gotoxy(6,0);
; 0005 0032              lcd_putchar('E');
	CALL SUBOPT_0xA
; 0005 0033              lcd_gotoxy(1,0);
; 0005 0034              delay_ms(1000);
	CALL SUBOPT_0xB
; 0005 0035              lcd_clear();
; 0005 0036              lcd_puts("ERROR!");
	__POINTW2MN _0xA0003,72
	CALL SUBOPT_0x0
; 0005 0037              delay_ms(1000);
; 0005 0038         }
; 0005 0039         else{
	RJMP _0xA0013
_0xA0010:
; 0005 003A              lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0005 003B              lcd_putchar(key_pad[dig1]);
	CALL SUBOPT_0xC
; 0005 003C              lcd_gotoxy(6,0);
; 0005 003D              lcd_putchar(key_pad[dig2]);
	CALL SUBOPT_0xD
; 0005 003E              delay_ms(1000);
; 0005 003F              break;
	RJMP _0xA000F
; 0005 0040         }
_0xA0013:
; 0005 0041    }
	RJMP _0xA000D
_0xA000F:
; 0005 0042    while(1){
_0xA0014:
; 0005 0043             lcd_clear();
	CALL _lcd_clear
; 0005 0044             lcd_puts("Weigt:??(00-99F)");
	__POINTW2MN _0xA0003,79
	CALL SUBOPT_0x1
; 0005 0045             lcd_gotoxy(0,1);
; 0005 0046             lcd_puts("Input: ");
	__POINTW2MN _0xA0003,96
	CALL SUBOPT_0x8
; 0005 0047             dig1 = keypad();
; 0005 0048             dig2 = keypad();
; 0005 0049 
; 0005 004A             if(dig1>9 || dig2>9){
	CPI  R17,10
	BRSH _0xA0018
	CPI  R16,10
	BRLO _0xA0017
_0xA0018:
; 0005 004B                  lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0005 004C                  lcd_putchar('E');
	CALL SUBOPT_0x9
; 0005 004D                  lcd_gotoxy(7,0);
; 0005 004E                  lcd_putchar('E');
	CALL SUBOPT_0xA
; 0005 004F                  lcd_gotoxy(1,0);
; 0005 0050                  delay_ms(1000);
	CALL SUBOPT_0xB
; 0005 0051                  lcd_clear();
; 0005 0052                  lcd_puts("ERROR!");
	__POINTW2MN _0xA0003,104
	CALL SUBOPT_0x0
; 0005 0053                  delay_ms(1000);
; 0005 0054             }
; 0005 0055             else{
	RJMP _0xA001A
_0xA0017:
; 0005 0056                  lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0005 0057                  lcd_putchar(key_pad[dig1]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_key_pad)
	SBCI R31,HIGH(-_key_pad)
	LD   R26,Z
	CALL _lcd_putchar
; 0005 0058                  lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2
; 0005 0059                  lcd_putchar(key_pad[dig2]);
	CALL SUBOPT_0xD
; 0005 005A                  delay_ms(1000);
; 0005 005B                  break;
	RJMP _0xA0016
; 0005 005C             }
_0xA001A:
; 0005 005D         }
	RJMP _0xA0014
_0xA0016:
; 0005 005E    while(1){
_0xA001B:
; 0005 005F         lcd_clear();
	CALL _lcd_clear
; 0005 0060         lcd_puts("Temp:??(20-80C)");
	__POINTW2MN _0xA0003,111
	CALL SUBOPT_0x1
; 0005 0061         lcd_gotoxy(0,1);
; 0005 0062         lcd_puts("Input: ");
	__POINTW2MN _0xA0003,127
	CALL SUBOPT_0x8
; 0005 0063         dig1 = keypad();
; 0005 0064         dig2 = keypad();
; 0005 0065 
; 0005 0066         if(dig1>8 || dig1<2 || dig2>9||(dig1 == 8 && dig2 != 0)){
	CPI  R17,9
	BRSH _0xA001F
	CPI  R17,2
	BRLO _0xA001F
	CPI  R16,10
	BRSH _0xA001F
	CPI  R17,8
	BRNE _0xA0020
	CPI  R16,0
	BRNE _0xA001F
_0xA0020:
	RJMP _0xA001E
_0xA001F:
; 0005 0067              lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0005 0068              lcd_putchar('E');
	CALL SUBOPT_0xE
; 0005 0069              lcd_gotoxy(6,0);
; 0005 006A              lcd_putchar('E');
	CALL SUBOPT_0xA
; 0005 006B              lcd_gotoxy(1,0);
; 0005 006C              delay_ms(1000);
	CALL SUBOPT_0xB
; 0005 006D              lcd_clear();
; 0005 006E              lcd_puts("ERROR!");
	__POINTW2MN _0xA0003,135
	CALL SUBOPT_0x0
; 0005 006F              delay_ms(1000);
; 0005 0070         }
; 0005 0071         else{
	RJMP _0xA0023
_0xA001E:
; 0005 0072              lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0005 0073              lcd_putchar(key_pad[dig1]);
	CALL SUBOPT_0xC
; 0005 0074              lcd_gotoxy(6,0);
; 0005 0075              lcd_putchar(key_pad[dig2]);
	CALL SUBOPT_0xD
; 0005 0076              delay_ms(1000);
; 0005 0077              break;
	RJMP _0xA001D
; 0005 0078         }
_0xA0023:
; 0005 0079 
; 0005 007A     }
	RJMP _0xA001B
_0xA001D:
; 0005 007B }
	RJMP _0x2040002
; .FEND

	.DSEG
_0xA0003:
	.BYTE 0x8E
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;unsigned char keypad(void){
; 0006 0003 unsigned char keypad(void){

	.CSEG
_keypad:
; .FSTART _keypad
; 0006 0004     int key = 16;
; 0006 0005     DDRB = 0xF0;
	CALL SUBOPT_0x3
;	key -> R16,R17
; 0006 0006     PORTB = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0006 0007 
; 0006 0008     //lcd_clear();
; 0006 0009 
; 0006 000A     do{
_0xC0004:
; 0006 000B         PORTB.4=1; PORTB.5=0; PORTB.6=0; PORTB.7=0;
	SBI  0x18,4
	CBI  0x18,5
	CBI  0x18,6
	CBI  0x18,7
; 0006 000C         if(PINB.0) { key = 0;  continue;}
	SBIS 0x16,0
	RJMP _0xC000E
	__GETWRN 16,17,0
	RJMP _0xC0003
; 0006 000D         if(PINB.1) {key = 1;  continue;}
_0xC000E:
	SBIS 0x16,1
	RJMP _0xC000F
	__GETWRN 16,17,1
	RJMP _0xC0003
; 0006 000E         if(PINB.2) {key = 2;  continue;}
_0xC000F:
	SBIS 0x16,2
	RJMP _0xC0010
	__GETWRN 16,17,2
	RJMP _0xC0003
; 0006 000F         if(PINB.3) {key =3;   continue;}
_0xC0010:
	SBIS 0x16,3
	RJMP _0xC0011
	__GETWRN 16,17,3
	RJMP _0xC0003
; 0006 0010         delay_ms(10);
_0xC0011:
	CALL SUBOPT_0x4
; 0006 0011         PORTB.4=0; PORTB.5=1; PORTB.6=0; PORTB.7=0;
	SBI  0x18,5
	CBI  0x18,6
	CBI  0x18,7
; 0006 0012         if(PINB.0) {key = 4;  continue;}
	SBIS 0x16,0
	RJMP _0xC001A
	__GETWRN 16,17,4
	RJMP _0xC0003
; 0006 0013         if(PINB.1) {key =  5; continue;}
_0xC001A:
	SBIS 0x16,1
	RJMP _0xC001B
	__GETWRN 16,17,5
	RJMP _0xC0003
; 0006 0014         if(PINB.2) {key =  6;  continue;}
_0xC001B:
	SBIS 0x16,2
	RJMP _0xC001C
	__GETWRN 16,17,6
	RJMP _0xC0003
; 0006 0015         if(PINB.3) {key =  7; continue;}
_0xC001C:
	SBIS 0x16,3
	RJMP _0xC001D
	__GETWRN 16,17,7
	RJMP _0xC0003
; 0006 0016         delay_ms(10);
_0xC001D:
	CALL SUBOPT_0x4
; 0006 0017         PORTB.4=0; PORTB.5=0; PORTB.6=1; PORTB.7=0;
	CBI  0x18,5
	SBI  0x18,6
	CBI  0x18,7
; 0006 0018         if(PINB.0) {key =  8;   continue;}
	SBIS 0x16,0
	RJMP _0xC0026
	__GETWRN 16,17,8
	RJMP _0xC0003
; 0006 0019         if(PINB.1) {key =  9;   continue;}
_0xC0026:
	SBIS 0x16,1
	RJMP _0xC0027
	__GETWRN 16,17,9
	RJMP _0xC0003
; 0006 001A         if(PINB.2) {key =  10;   continue;}
_0xC0027:
	SBIS 0x16,2
	RJMP _0xC0028
	__GETWRN 16,17,10
	RJMP _0xC0003
; 0006 001B         if(PINB.3) {key =  11; continue;}
_0xC0028:
	SBIS 0x16,3
	RJMP _0xC0029
	__GETWRN 16,17,11
	RJMP _0xC0003
; 0006 001C         delay_ms(10);
_0xC0029:
	CALL SUBOPT_0x4
; 0006 001D         PORTB.4=0; PORTB.5=0; PORTB.6=0; PORTB.7=1;
	CBI  0x18,5
	CBI  0x18,6
	SBI  0x18,7
; 0006 001E         if(PINB.0) {key =  12;   continue;}
	SBIS 0x16,0
	RJMP _0xC0032
	__GETWRN 16,17,12
	RJMP _0xC0003
; 0006 001F         if(PINB.1) {key =  13;     continue;}
_0xC0032:
	SBIS 0x16,1
	RJMP _0xC0033
	__GETWRN 16,17,13
	RJMP _0xC0003
; 0006 0020         if(PINB.2) {key =  14;   continue;}
_0xC0033:
	SBIS 0x16,2
	RJMP _0xC0034
	__GETWRN 16,17,14
	RJMP _0xC0003
; 0006 0021         if(PINB.3) {key =  15;   continue;}
_0xC0034:
	SBIS 0x16,3
	RJMP _0xC0035
	__GETWRN 16,17,15
	RJMP _0xC0003
; 0006 0022         delay_ms(10);
_0xC0035:
	CALL SUBOPT_0x5
; 0006 0023         key = 16;
	__GETWRN 16,17,16
; 0006 0024     } while(key == 16);
_0xC0003:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xC0005
	RJMP _0xC0004
_0xC0005:
; 0006 0025 
; 0006 0026      lcd_putchar(key_pad[key]);
	CALL SUBOPT_0x6
; 0006 0027      delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0006 0028      return key;
	MOV  R30,R16
_0x2040002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0006 0029 
; 0006 002A 
; 0006 002B }
; .FEND
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void func6(void){
; 0007 0003 void func6(void){

	.CSEG
_func6:
; .FSTART _func6
; 0007 0004 
; 0007 0005     func1();
	CALL _func1
; 0007 0006     func2();
	CALL _func2
; 0007 0007     func3();
	CALL _func3
; 0007 0008     func5();
	CALL _func5
; 0007 0009     func4();
	CALL _func4
; 0007 000A     return;
	RET
; 0007 000B 
; 0007 000C }
; .FEND
;#include <header.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void init(void){
; 0008 0003 void init(void){

	.CSEG
_init:
; .FSTART _init
; 0008 0004     // Input/Output Ports initialization
; 0008 0005     // Port A initialization
; 0008 0006     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0008 0007     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0008 0008     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0008 0009     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0008 000A 
; 0008 000B     // Port B initialization
; 0008 000C     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0008 000D     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0008 000E     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0008 000F     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0008 0010 
; 0008 0011     // Port C initialization
; 0008 0012     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0008 0013     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0008 0014     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0008 0015     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0008 0016 
; 0008 0017     // Port D initialization
; 0008 0018     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0008 0019     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0008 001A     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0008 001B     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0008 001C 
; 0008 001D     // Timer/Counter 0 initialization
; 0008 001E     // Clock source: System Clock
; 0008 001F     // Clock value: Timer 0 Stopped
; 0008 0020     // Mode: Normal top=0xFF
; 0008 0021     // OC0 output: Disconnected
; 0008 0022     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0008 0023     TCNT0=0x00;
	OUT  0x32,R30
; 0008 0024     OCR0=0x00;
	OUT  0x3C,R30
; 0008 0025 
; 0008 0026     // Timer/Counter 1 initialization
; 0008 0027     // Clock source: System Clock
; 0008 0028     // Clock value: Timer1 Stopped
; 0008 0029     // Mode: Normal top=0xFFFF
; 0008 002A     // OC1A output: Disconnected
; 0008 002B     // OC1B output: Disconnected
; 0008 002C     // Noise Canceler: Off
; 0008 002D     // Input Capture on Falling Edge
; 0008 002E     // Timer1 Overflow Interrupt: Off
; 0008 002F     // Input Capture Interrupt: Off
; 0008 0030     // Compare A Match Interrupt: Off
; 0008 0031     // Compare B Match Interrupt: Off
; 0008 0032     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0008 0033     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0008 0034     TCNT1H=0x00;
	OUT  0x2D,R30
; 0008 0035     TCNT1L=0x00;
	OUT  0x2C,R30
; 0008 0036     ICR1H=0x00;
	OUT  0x27,R30
; 0008 0037     ICR1L=0x00;
	OUT  0x26,R30
; 0008 0038     OCR1AH=0x00;
	OUT  0x2B,R30
; 0008 0039     OCR1AL=0x00;
	OUT  0x2A,R30
; 0008 003A     OCR1BH=0x00;
	OUT  0x29,R30
; 0008 003B     OCR1BL=0x00;
	OUT  0x28,R30
; 0008 003C 
; 0008 003D     // Timer/Counter 2 initialization
; 0008 003E     // Clock source: System Clock
; 0008 003F     // Clock value: Timer2 Stopped
; 0008 0040     // Mode: Normal top=0xFF
; 0008 0041     // OC2 output: Disconnected
; 0008 0042     ASSR=0<<AS2;
	OUT  0x22,R30
; 0008 0043     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0008 0044     TCNT2=0x00;
	OUT  0x24,R30
; 0008 0045     OCR2=0x00;
	OUT  0x23,R30
; 0008 0046 
; 0008 0047     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0008 0048     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0008 0049 
; 0008 004A     // External Interrupt(s) initialization
; 0008 004B     // INT0: Off
; 0008 004C     // INT1: On
; 0008 004D     // INT1 Mode: Rising Edge
; 0008 004E     // INT2: Off
; 0008 004F     GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0008 0050     MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0008 0051     MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0008 0052     GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0008 0053 
; 0008 0054     // USART initialization
; 0008 0055     // USART disabled
; 0008 0056     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0008 0057 
; 0008 0058     // Analog Comparator initialization
; 0008 0059     // Analog Comparator: Off
; 0008 005A     // The Analog Comparator's positive input is
; 0008 005B     // connected to the AIN0 pin
; 0008 005C     // The Analog Comparator's negative input is
; 0008 005D     // connected to the AIN1 pin
; 0008 005E     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0008 005F     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0008 0060 
; 0008 0061     // ADC initialization
; 0008 0062     // ADC disabled
; 0008 0063     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0008 0064 
; 0008 0065     // SPI initialization
; 0008 0066     // SPI disabled
; 0008 0067     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0008 0068 
; 0008 0069     // TWI initialization
; 0008 006A     // TWI disabled
; 0008 006B     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0008 006C 
; 0008 006D     // Alphanumeric LCD initialization
; 0008 006E     // Connections are specified in the
; 0008 006F     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0008 0070     // RS - PORTA Bit 0
; 0008 0071     // RD - PORTA Bit 1
; 0008 0072     // EN - PORTA Bit 2
; 0008 0073     // D4 - PORTA Bit 4
; 0008 0074     // D5 - PORTA Bit 5
; 0008 0075     // D6 - PORTA Bit 6
; 0008 0076     // D7 - PORTA Bit 7
; 0008 0077     // Characters/line: 16
; 0008 0078     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0008 0079 }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xF
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2040001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2040001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND

	.DSEG
_key_pad:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x0:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,16
	LDI  R30,LOW(240)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_key_pad)
	LDI  R27,HIGH(_key_pad)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	CALL _lcd_puts
	CALL _keypad
	MOV  R17,R30
	CALL _keypad
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(69)
	CALL _lcd_putchar
	LDI  R30,LOW(7)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(69)
	CALL _lcd_putchar
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_key_pad)
	SBCI R31,HIGH(-_key_pad)
	LD   R26,Z
	CALL _lcd_putchar
	LDI  R30,LOW(6)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xD:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_key_pad)
	SBCI R31,HIGH(-_key_pad)
	LD   R26,Z
	CALL _lcd_putchar
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(69)
	CALL _lcd_putchar
	LDI  R30,LOW(6)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
