/* ###################################################################
 **     Filename    : main.c
 **     Project     : brazo3
 **     Processor   : MK64FN1M0VLL12
 **     Version     : Driver 01.01
 **     Compiler    : GNU C Compiler
 **     Date/Time   : 2016-11-19, 18:31, # CodeGen: 0
 **     Abstract    :
 **         Main module.
 **         This module contains user's application code.
 **     Settings    :
 **     Contents    :
 **         No public methods
 **
 ** ###################################################################*/
/*!
 ** @file main.c
 ** @version 01.01
 ** @brief
 **         Main module.
 **         This module contains user's application code.
 */
/*!
 **  @addtogroup main_module main module documentation
 **  @{
 */
/* MODULE main */

/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "Pins1.h"
#include "Term1.h"
#include "Inhr1.h"
#include "ASerialLdd1.h"
#include "PWM1.h"
#include "PwmLdd1.h"
#include "TU1.h"
#include "PWM2.h"
#include "PwmLdd2.h"
#include "PWM3.h"
#include "PwmLdd3.h"
#include "PWM4.h"
#include "PwmLdd4.h"
#include "TI1.h"
#include "TimerIntLdd1.h"
#include "TU2.h"
/* Including shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include "PDD_Includes.h"
#include "Init_Config.h"
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "GPIO.h"
/* User includes (#include below this line is not maintained by Processor Expert) */

/*lint -save  -e970 Disable MISRA rule (6.3) checking. */


uint16_t string2num(char* pch){

static char str[4];

	str[0] = *(pch + 2);
	str[1] = *(pch + 3);
	str[2] = *(pch + 4);

	return atoi(str);

}


char s0[] = { "WEEE!\r\n" };
char s1[] = { "Llego algo" };
char s2[64];
char s3[] = { "Enviaste: " };

char s4[] = { "Seteaste el ancho de pulso en: " };
int main(void)
/*lint -restore Enable MISRA rule (6.3) checking. */
{
	/* Write your local variable definition here */

	/*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
	PE_low_level_init();
	/*** End of Processor Expert internal initialization.                    ***/

	/* Write your code here */
	/* For example: for(;;) { } */

	/* 's' -> Set low pulse width
	 * PWM1 -> PTC4
	 *
	 *
	 */

	Term1_SendStr(s0);
	uint16_t pulseWidth_ef;
	uint16_t pulseWidth_se;
	uint16_t pulseWidth_ps;
	uint16_t pulseWidth_base;

	GPIO_clockGating(GPIOC);

	GPIO_pinControlRegisterType hBridgeA_sel_1 = GPIO_MUX1;
	GPIO_pinControlRegisterType hBridgeA_sel_2 = GPIO_MUX1;
	GPIO_pinControlRegisterType hBridgeB_sel_1 = GPIO_MUX1;
	GPIO_pinControlRegisterType hBridgeB_sel_2 = GPIO_MUX1;

	GPIO_pinControlRegister(GPIOC, BIT14, &hBridgeA_sel_1);
	GPIO_pinControlRegister(GPIOC, BIT15, &hBridgeB_sel_1);
	GPIO_pinControlRegister(GPIOC, BIT16, &hBridgeA_sel_2);
	GPIO_pinControlRegister(GPIOC, BIT17, &hBridgeB_sel_2);

	GPIO_dataDirectionPIN(GPIOC, GPIO_OUTPUT, BIT14);
	GPIO_dataDirectionPIN(GPIOC, GPIO_OUTPUT, BIT15);
	GPIO_dataDirectionPIN(GPIOC, GPIO_OUTPUT, BIT16);
	GPIO_dataDirectionPIN(GPIOC, GPIO_OUTPUT, BIT17);

	anchosdePulso.ba_Dir = 0;
	anchosdePulso.ef_Dir = 1;
	anchosdePulso.pe_Dir = 0;
	anchosdePulso.se_Dir = 1;

	anchosdePulso.pw_EF = 100;
	anchosdePulso.pw_SE = 100;
	anchosdePulso.pw_PE = 100;
	anchosdePulso.pw_BA = 100;


	char sub_ef[] ="ef";
	char sub_se[] ="es";
	char sub_pe[] ="pe";
	char sub_ba[] ="ba";
	char sub_dir[] = "dir";
	char subSTR[4];
	char* pch;

	for (;;) {

		Term1_ReadLine(&s2);
		pch = strstr(s2, sub_ef);
		anchosdePulso.pw_EF = string2num(pch);
		pch = strstr(s2, sub_se);
		anchosdePulso.pw_SE = string2num(pch);
		pch = strstr(s2, sub_pe);
		anchosdePulso.pw_PE = string2num(pch);
		pch = strstr(s2, sub_ba);
		anchosdePulso.pw_BA = string2num(pch);
		pch = strstr(s2, sub_dir);
		anchosdePulso.ef_Dir = pch[3] - 0x30;
		anchosdePulso.se_Dir = pch[4] - 0x30;
		anchosdePulso.pe_Dir = pch[5] - 0x30;
		anchosdePulso.ba_Dir = pch[6] - 0x30;

		//Term1_SendStr(&s2);
		s2[0] = '\0';
		PWM1_SetDutyUS(anchosdePulso.pw_EF);
		PWM2_SetDutyUS(anchosdePulso.pw_SE);
		PWM3_SetDutyUS(anchosdePulso.pw_PE);
		PWM4_SetDutyUS(anchosdePulso.pw_BA);

		if (anchosdePulso.ef_Dir)
			GPIO_setPIN(GPIOC, BIT14);
		else
			GPIO_clearPIN(GPIOC, BIT14);

		if (anchosdePulso.se_Dir)
			GPIO_setPIN(GPIOC, BIT15);
		else
			GPIO_clearPIN(GPIOC, BIT15);

		if (anchosdePulso.pe_Dir)
			GPIO_setPIN(GPIOC, BIT16);
		else
			GPIO_clearPIN(GPIOC, BIT16);

		if (anchosdePulso.ba_Dir)
			GPIO_setPIN(GPIOC, BIT17);
		else
			GPIO_clearPIN(GPIOC, BIT17);

		Term1_SendStr(&s4);
		Term1_SendNum((int32_t) anchosdePulso.pw_EF);
		Term1_CRLF();
		Term1_SendNum((int32_t) anchosdePulso.pw_SE);
		Term1_CRLF();
		Term1_SendNum((int32_t) anchosdePulso.pw_PE);
		Term1_CRLF();
		Term1_SendNum((int32_t) anchosdePulso.pw_BA);
		Term1_CRLF();
		Term1_SendStr("Direcciones: ");
		Term1_CRLF();
		Term1_SendStr("Efector Final: ");
		Term1_CRLF();
		Term1_SendNum((uint32_t) anchosdePulso.ef_Dir);
		Term1_CRLF();
		Term1_SendStr("Segundo eslabon: ");
		Term1_CRLF();
		Term1_SendNum((uint32_t) anchosdePulso.se_Dir);
		Term1_CRLF();
		Term1_SendStr("Primer eslabon: ");
		Term1_CRLF();
		Term1_SendNum((uint32_t) anchosdePulso.pe_Dir);
		Term1_CRLF();
		Term1_SendStr("Base: ");
		Term1_CRLF();
		Term1_SendNum((uint32_t) anchosdePulso.ba_Dir);
		Term1_CRLF();

	}

	/*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
 ** @}
 */
/*
 ** ###################################################################
 **
 **     This file was created by Processor Expert 10.5 [05.21]
 **     for the Freescale Kinetis series of microcontrollers.
 **
 ** ###################################################################
 */
