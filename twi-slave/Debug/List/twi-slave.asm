
;CodeVisionAVR C Compiler V3.17 Evaluation
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
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
;Enhanced function parameter passing: Mode 2
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
	JMP  _twi_int_handler
	JMP  0x00
	JMP  0x00
	JMP  0x00

_status_msg:
	.DB  LOW(_0x0*2),HIGH(_0x0*2),LOW(_0x0*2+3),HIGH(_0x0*2+3),LOW(_0x0*2+19),HIGH(_0x0*2+19),LOW(_0x0*2+36),HIGH(_0x0*2+36)
	.DB  LOW(_0x0*2+46),HIGH(_0x0*2+46),LOW(_0x0*2+60),HIGH(_0x0*2+60),LOW(_0x0*2+72),HIGH(_0x0*2+72),LOW(_0x0*2+77),HIGH(_0x0*2+77)
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x4F,0x4B,0x0,0x42,0x75,0x66,0x66,0x65
	.DB  0x72,0x20,0x6F,0x76,0x65,0x72,0x66,0x6C
	.DB  0x6F,0x77,0x0,0x41,0x72,0x62,0x69,0x74
	.DB  0x72,0x61,0x74,0x69,0x6F,0x6E,0x20,0x6C
	.DB  0x6F,0x73,0x74,0x0,0x42,0x75,0x73,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x0,0x4E,0x41
	.DB  0x43,0x4B,0x20,0x72,0x65,0x63,0x65,0x69
	.DB  0x76,0x65,0x64,0x0,0x42,0x75,0x73,0x20
	.DB  0x74,0x69,0x6D,0x65,0x6F,0x75,0x74,0x0
	.DB  0x46,0x61,0x69,0x6C,0x0,0x55,0x6E,0x6B
	.DB  0x6E,0x6F,0x77,0x6E,0x20,0x65,0x72,0x72
	.DB  0x6F,0x72,0x0,0x52,0x65,0x63,0x65,0x69
	.DB  0x76,0x65,0x20,0x65,0x72,0x72,0x6F,0x72
	.DB  0x3A,0xA,0x0,0x44,0x61,0x74,0x61,0x20
	.DB  0x70,0x61,0x63,0x6B,0x65,0x74,0x20,0x72
	.DB  0x65,0x63,0x65,0x69,0x76,0x65,0x64,0x20
	.DB  0x4F,0x4B,0xA,0xD,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2060003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2060003*2

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
;CodeWizardAVR V3.17 Evaluation
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 31/12/2014
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <io.h>
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
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;// Declare your global variables here
;
;// TWI functions
;#include <twi.h>
;
;// TWI Slave receive buffer
;#define TWI_RX_BUFFER_SIZE 32
;unsigned char twi_rx_buffer[TWI_RX_BUFFER_SIZE];
;
;// TWI Slave transmit buffer
;#define TWI_TX_BUFFER_SIZE 32
;unsigned char twi_tx_buffer[TWI_TX_BUFFER_SIZE];
;// 7bit slave I2C address
;#define TWI_SLAVE_ADDR 0x50
;// flag that signals that the TWI slave reception was OK
;bit received_ok=false;
;
;flash char * flash status_msg[8]=
;{
;"OK",
;"Buffer overflow",
;"Arbitration lost",
;"Bus error",
;"NACK received",
;"Bus timeout",
;"Fail",
;"Unknown error"
;};
;
;
;
;
;// TWI Slave receive handler
;// This handler is called everytime a byte
;// is received by the TWI slave
;bool twi_rx_handler(bool rx_complete)
; 0000 0043 {

	.CSEG
_twi_rx_handler:
; .FSTART _twi_rx_handler
; 0000 0044     if (twi_result==TWI_RES_OK){
	ST   -Y,R17
	MOV  R17,R26
;	rx_complete -> R17
	LDS  R30,_twi_result
	CPI  R30,0
	BRNE _0x3
; 0000 0045      received_ok=true; // signal that data was received without errors
	SET
	BLD  R2,0
; 0000 0046     //  lcd_clear();
; 0000 0047    //lcd_putsf("OK");
; 0000 0048    //delay_ms(200);
; 0000 0049      }
; 0000 004A   else
	RJMP _0x4
_0x3:
; 0000 004B    {
; 0000 004C    // TWI receive error, display the twi_result value
; 0000 004D    lcd_clear();
	RCALL _lcd_clear
; 0000 004E    lcd_putsf("Receive error:\n");
	__POINTW2FN _0x0,91
	RCALL _lcd_putsf
; 0000 004F    lcd_putsf(status_msg[twi_result]);
	LDS  R30,_twi_result
	LDI  R26,LOW(_status_msg*2)
	LDI  R27,HIGH(_status_msg*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW2PF
	RCALL _lcd_putsf
; 0000 0050    delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0051    received_ok=false; // signal that data was received with errors
	CLT
	BLD  R2,0
; 0000 0052    return false; // stop reception
	LDI  R30,LOW(0)
	RJMP _0x20A0001
; 0000 0053    }
_0x4:
; 0000 0054 
; 0000 0055    if (rx_complete)
	CPI  R17,0
	BREQ _0x5
; 0000 0056     // the TWI master has finished transmitting data
; 0000 0057     return false; // no more bytes to receive
	LDI  R30,LOW(0)
	RJMP _0x20A0001
; 0000 0058 
; 0000 0059     // signal to the TWI master that the TWI slave is ready to accept more data
; 0000 005A     // as long as there is space in the receive buffer
; 0000 005B     return (twi_rx_index<sizeof(twi_rx_buffer));
_0x5:
	LDS  R26,_twi_rx_index
	LDI  R30,LOW(32)
	RCALL __LTB12U
	RJMP _0x20A0001
; 0000 005C }
; .FEND
;
;// TWI Slave transmission handler
;// This handler is called for the first time when the
;// transmission from the TWI slave to the master
;// is about to begin, returning the number of bytes
;// that need to be transmitted
;// The second time the handler is called when the
;// transmission has finished
;// In this case it must return 0
;unsigned char twi_tx_handler(bool tx_complete)
; 0000 0067 {
_twi_tx_handler:
; .FSTART _twi_tx_handler
; 0000 0068     unsigned char i;
; 0000 0069     if (tx_complete==false)
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	tx_complete -> R16
;	i -> R17
	CPI  R16,0
	BRNE _0x6
; 0000 006A        {
; 0000 006B        // transmission from slave to master is about to start
; 0000 006C        // copy the text to transmit to the TWI master in the transmission buffer
; 0000 006D        strcpyf(twi_tx_buffer,"Data packet received OK\n\r");
	RCALL SUBOPT_0x0
	__POINTW2FN _0x0,107
	RCALL _strcpyf
; 0000 006E        // # of bytes to transmit from the TWI slave to the TWI master
; 0000 006F        return strlen(twi_tx_buffer);
	LDI  R26,LOW(_twi_tx_buffer)
	LDI  R27,HIGH(_twi_tx_buffer)
	RCALL _strlen
	RJMP _0x20A0002
; 0000 0070        }
; 0000 0071         // transmission from slave to master has already started,
; 0000 0072         // no more bytes to send in this transaction
; 0000 0073      if (received_ok)
_0x6:
	SBRS R2,0
	RJMP _0x7
; 0000 0074      {
; 0000 0075        // no TWI receive error, display the received data on the LCD
; 0000 0076        lcd_clear();
	RCALL _lcd_clear
; 0000 0077        for (i=0;i<twi_rx_index;i++)
	LDI  R17,LOW(0)
_0x9:
	LDS  R30,_twi_rx_index
	CP   R17,R30
	BRSH _0xA
; 0000 0078          lcd_putchar(twi_rx_buffer[i]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_twi_rx_buffer)
	SBCI R31,HIGH(-_twi_rx_buffer)
	LD   R26,Z
	RCALL _lcd_putchar
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 0079 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 007A      }
; 0000 007B     return 0;
_0x7:
	LDI  R30,LOW(0)
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 007C }
; .FEND
;
;void main(void)
; 0000 007F {
_main:
; .FSTART _main
; 0000 0080     // Declare your local variables here
; 0000 0081 
; 0000 0082     // Input/Output Ports initialization
; 0000 0083     // Port A initialization
; 0000 0084     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0085     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0086     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0087     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0088 
; 0000 0089     // Port B initialization
; 0000 008A     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008B     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 008C     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008D     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 008E 
; 0000 008F     // Port C initialization
; 0000 0090     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0091     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0092     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0093     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0094 
; 0000 0095     // Port D initialization
; 0000 0096     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0097     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0098     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0099     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 009A 
; 0000 009B     // Timer/Counter 0 initialization
; 0000 009C     // Clock source: System Clock
; 0000 009D     // Clock value: Timer 0 Stopped
; 0000 009E     // Mode: Normal top=0xFF
; 0000 009F     // OC0 output: Disconnected
; 0000 00A0     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00A1     TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A2     OCR0=0x00;
	OUT  0x3C,R30
; 0000 00A3 
; 0000 00A4     // Timer/Counter 1 initialization
; 0000 00A5     // Clock source: System Clock
; 0000 00A6     // Clock value: Timer1 Stopped
; 0000 00A7     // Mode: Normal top=0xFFFF
; 0000 00A8     // OC1A output: Disconnected
; 0000 00A9     // OC1B output: Disconnected
; 0000 00AA     // Noise Canceler: Off
; 0000 00AB     // Input Capture on Falling Edge
; 0000 00AC     // Timer1 Overflow Interrupt: Off
; 0000 00AD     // Input Capture Interrupt: Off
; 0000 00AE     // Compare A Match Interrupt: Off
; 0000 00AF     // Compare B Match Interrupt: Off
; 0000 00B0     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00B1     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00B2     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B3     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B4     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00B5     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00B6     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00B7     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00B8     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00B9     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BA 
; 0000 00BB     // Timer/Counter 2 initialization
; 0000 00BC     // Clock source: System Clock
; 0000 00BD     // Clock value: Timer2 Stopped
; 0000 00BE     // Mode: Normal top=0xFF
; 0000 00BF     // OC2 output: Disconnected
; 0000 00C0     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00C1     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00C2     TCNT2=0x00;
	OUT  0x24,R30
; 0000 00C3     OCR2=0x00;
	OUT  0x23,R30
; 0000 00C4 
; 0000 00C5     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C6     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00C7 
; 0000 00C8     // External Interrupt(s) initialization
; 0000 00C9     // INT0: Off
; 0000 00CA     // INT1: Off
; 0000 00CB     // INT2: Off
; 0000 00CC     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00CD     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00CE 
; 0000 00CF     // USART initialization
; 0000 00D0     // USART disabled
; 0000 00D1     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00D2 
; 0000 00D3     // Analog Comparator initialization
; 0000 00D4     // Analog Comparator: Off
; 0000 00D5     // The Analog Comparator's positive input is
; 0000 00D6     // connected to the AIN0 pin
; 0000 00D7     // The Analog Comparator's negative input is
; 0000 00D8     // connected to the AIN1 pin
; 0000 00D9     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DA     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00DB 
; 0000 00DC     // ADC initialization
; 0000 00DD     // ADC disabled
; 0000 00DE     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00DF 
; 0000 00E0     // SPI initialization
; 0000 00E1     // SPI disabled
; 0000 00E2     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00E3 
; 0000 00E4     // TWI initialization
; 0000 00E5     // Mode: TWI Slave
; 0000 00E6     // Match Any Slave Address: On
; 0000 00E7     twi_slave_init(false,TWI_SLAVE_ADDR,twi_rx_buffer,sizeof(twi_rx_buffer),twi_tx_buffer,twi_rx_handler,twi_tx_handler) ...
	ST   -Y,R30
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R30,LOW(_twi_rx_buffer)
	LDI  R31,HIGH(_twi_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x0
	LDI  R30,LOW(_twi_rx_handler)
	LDI  R31,HIGH(_twi_rx_handler)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_twi_tx_handler)
	LDI  R27,HIGH(_twi_tx_handler)
	RCALL _twi_slave_init
; 0000 00E8 
; 0000 00E9     // Alphanumeric LCD initialization
; 0000 00EA     // Connections are specified in the
; 0000 00EB     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00EC     // RS - PORTA Bit 0
; 0000 00ED     // RD - PORTA Bit 1
; 0000 00EE     // EN - PORTA Bit 2
; 0000 00EF     // D4 - PORTA Bit 4
; 0000 00F0     // D5 - PORTA Bit 5
; 0000 00F1     // D6 - PORTA Bit 6
; 0000 00F2     // D7 - PORTA Bit 7
; 0000 00F3     // Characters/line: 16
; 0000 00F4     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00F5     lcd_clear();
	RCALL _lcd_clear
; 0000 00F6 
; 0000 00F7     // initialize the TWI slave
; 0000 00F8 
; 0000 00F9 
; 0000 00FA 
; 0000 00FB 
; 0000 00FC     // Global enable interrupts
; 0000 00FD     #asm("sei")
	sei
; 0000 00FE 
; 0000 00FF     while (1);
_0xB:
	RJMP _0xB
; 0000 0100 
; 0000 0101 }
_0xE:
	RJMP _0xE
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
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
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
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R5,R16
	MOV  R4,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x20A0001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20A0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x200000B:
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R7,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
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
_0x20A0001:
	LD   R17,Y+
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

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
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
_twi_slave_init:
; .FSTART _twi_slave_init
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
	SET
	BLD  R2,2
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	STS  _twi_rx_buffer_G103,R30
	STS  _twi_rx_buffer_G103+1,R31
	LDD  R30,Y+10
	STS  _twi_rx_buffer_size_G103,R30
	__PUTWMRN _twi_tx_buffer_G103,0,20,21
	__PUTWMRN _twi_slave_rx_handler_G103,0,18,19
	__PUTWMRN _twi_slave_tx_handler_G103,0,16,17
	SBI  0x15,1
	SBI  0x15,0
	LDD  R30,Y+14
	CPI  R30,0
	BREQ _0x2060012
	LDI  R30,LOW(1)
	RJMP _0x2060066
_0x2060012:
	LDD  R30,Y+13
	LSL  R30
_0x2060066:
	OUT  0x2,R30
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	OUT  0x36,R30
	RCALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
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
	RCALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G103
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G103
	LDS  R27,_twi_rx_buffer_G103+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2060017
	LDI  R18,LOW(0)
	RJMP _0x2060018
_0x2060017:
	CPI  R30,LOW(0x10)
	BRNE _0x2060019
_0x2060018:
	LDS  R30,_slave_address_G103
	RJMP _0x2060067
_0x2060019:
	CPI  R30,LOW(0x18)
	BREQ _0x206001D
	CPI  R30,LOW(0x28)
	BRNE _0x206001E
_0x206001D:
	CP   R16,R19
	BRSH _0x206001F
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G103
	LDS  R27,_twi_tx_buffer_G103+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2060067:
	OUT  0x3,R30
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2060020
_0x206001F:
	LDS  R30,_bytes_to_rx_G103
	CP   R17,R30
	BRSH _0x2060021
	LDS  R30,_slave_address_G103
	ORI  R30,1
	STS  _slave_address_G103,R30
	CLT
	BLD  R2,1
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	OUT  0x36,R30
	RJMP _0x2060016
_0x2060021:
	RJMP _0x2060022
_0x2060020:
	RJMP _0x2060016
_0x206001E:
	CPI  R30,LOW(0x50)
	BRNE _0x2060023
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2060024
_0x2060023:
	CPI  R30,LOW(0x40)
	BRNE _0x2060025
_0x2060024:
	LDS  R30,_bytes_to_rx_G103
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2060026
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2060068
_0x2060026:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2060068:
	OUT  0x36,R30
	RJMP _0x2060016
_0x2060025:
	CPI  R30,LOW(0x58)
	BRNE _0x2060028
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2060029
_0x2060028:
	CPI  R30,LOW(0x20)
	BRNE _0x206002A
_0x2060029:
	RJMP _0x206002B
_0x206002A:
	CPI  R30,LOW(0x30)
	BRNE _0x206002C
_0x206002B:
	RJMP _0x206002D
_0x206002C:
	CPI  R30,LOW(0x48)
	BRNE _0x206002E
_0x206002D:
	CPI  R18,0
	BRNE _0x206002F
	SBRS R2,1
	RJMP _0x2060030
	CP   R16,R19
	BRLO _0x2060032
	RJMP _0x2060033
_0x2060030:
	LDS  R30,_bytes_to_rx_G103
	CP   R17,R30
	BRSH _0x2060034
_0x2060032:
	LDI  R18,LOW(4)
_0x2060034:
_0x2060033:
_0x206002F:
_0x2060022:
	RJMP _0x2060069
_0x206002E:
	CPI  R30,LOW(0x38)
	BRNE _0x2060037
	LDI  R18,LOW(2)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x206006A
_0x2060037:
	CPI  R30,LOW(0x68)
	BREQ _0x206003A
	CPI  R30,LOW(0x78)
	BRNE _0x206003B
_0x206003A:
	LDI  R18,LOW(2)
	RJMP _0x206003C
_0x206003B:
	CPI  R30,LOW(0x60)
	BREQ _0x206003F
	CPI  R30,LOW(0x70)
	BRNE _0x2060040
_0x206003F:
	LDI  R18,LOW(0)
_0x206003C:
	LDI  R17,LOW(0)
	CLT
	BLD  R2,1
	LDS  R30,_twi_rx_buffer_size_G103
	CPI  R30,0
	BRNE _0x2060041
	LDI  R18,LOW(1)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x206006B
_0x2060041:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x206006B:
	OUT  0x36,R30
	RJMP _0x2060016
_0x2060040:
	CPI  R30,LOW(0x80)
	BREQ _0x2060044
	CPI  R30,LOW(0x90)
	BRNE _0x2060045
_0x2060044:
	SBRS R2,1
	RJMP _0x2060046
	LDI  R18,LOW(1)
	RJMP _0x2060047
_0x2060046:
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G103
	CP   R17,R30
	BRSH _0x2060048
	LDS  R30,_twi_slave_rx_handler_G103
	LDS  R31,_twi_slave_rx_handler_G103+1
	SBIW R30,0
	BRNE _0x2060049
	LDI  R18,LOW(6)
	RJMP _0x2060047
_0x2060049:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G103,0
	CPI  R30,0
	BREQ _0x206004A
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	RJMP _0x2060016
_0x206004A:
	RJMP _0x206004B
_0x2060048:
	SET
	BLD  R2,1
_0x206004B:
	RJMP _0x206004C
_0x2060045:
	CPI  R30,LOW(0x88)
	BRNE _0x206004D
_0x206004C:
	RJMP _0x206004E
_0x206004D:
	CPI  R30,LOW(0x98)
	BRNE _0x206004F
_0x206004E:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2060016
_0x206004F:
	CPI  R30,LOW(0xA0)
	BRNE _0x2060050
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	SET
	BLD  R2,2
	LDS  R30,_twi_slave_rx_handler_G103
	LDS  R31,_twi_slave_rx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060051
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G103,0
	RJMP _0x2060052
_0x2060051:
	LDI  R18,LOW(6)
_0x2060052:
	RJMP _0x2060016
_0x2060050:
	CPI  R30,LOW(0xB0)
	BRNE _0x2060053
	LDI  R18,LOW(2)
	RJMP _0x2060054
_0x2060053:
	CPI  R30,LOW(0xA8)
	BRNE _0x2060055
_0x2060054:
	LDS  R30,_twi_slave_tx_handler_G103
	LDS  R31,_twi_slave_tx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060056
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G103,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2060058
	LDI  R18,LOW(0)
	RJMP _0x2060059
_0x2060056:
_0x2060058:
	LDI  R18,LOW(6)
	RJMP _0x2060047
_0x2060059:
	LDI  R16,LOW(0)
	CLT
	BLD  R2,1
	RJMP _0x206005A
_0x2060055:
	CPI  R30,LOW(0xB8)
	BRNE _0x206005B
_0x206005A:
	SBRS R2,1
	RJMP _0x206005C
	LDI  R18,LOW(1)
	RJMP _0x2060047
_0x206005C:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G103
	LDS  R27,_twi_tx_buffer_G103+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x3,R30
	CP   R16,R19
	BRSH _0x206005D
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x206006C
_0x206005D:
	SET
	BLD  R2,1
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x206006C:
	OUT  0x36,R30
	RJMP _0x2060016
_0x206005B:
	CPI  R30,LOW(0xC0)
	BREQ _0x2060060
	CPI  R30,LOW(0xC8)
	BRNE _0x2060061
_0x2060060:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	LDS  R30,_twi_slave_tx_handler_G103
	LDS  R31,_twi_slave_tx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060062
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G103,0
_0x2060062:
	RJMP _0x2060035
_0x2060061:
	CPI  R30,0
	BRNE _0x2060016
	LDI  R18,LOW(3)
_0x2060047:
_0x2060069:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x206006A:
	OUT  0x36,R30
_0x2060035:
	SET
	BLD  R2,2
_0x2060016:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G103,R19
	RCALL __LOADLOCR6
	ADIW R28,6
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

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_twi_rx_buffer:
	.BYTE 0x20
_twi_tx_buffer:
	.BYTE 0x20
__base_y_G100:
	.BYTE 0x4
_slave_address_G103:
	.BYTE 0x1
_twi_tx_buffer_G103:
	.BYTE 0x2
_bytes_to_tx_G103:
	.BYTE 0x1
_twi_rx_buffer_G103:
	.BYTE 0x2
_bytes_to_rx_G103:
	.BYTE 0x1
_twi_rx_buffer_size_G103:
	.BYTE 0x1
_twi_slave_rx_handler_G103:
	.BYTE 0x2
_twi_slave_tx_handler_G103:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_twi_tx_buffer)
	LDI  R31,HIGH(_twi_tx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
