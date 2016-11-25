/**
	\file
	\brief
		This is the source file for the GPIO device driver for Kinetis K64.
		It contains all the implementation for configuration functions and runtime functions.
		i.e., this is the application programming interface (API) for the GPIO peripheral.
	\author J. Luis Pizano Escalante, luispizano@iteso.mx
	\date	7/09/2014
	\todo
	    Interrupts are not implemented in this API implementation.
 */
#include "MK64F12.h"
#include "GPIO.h"
#include "DataTypeDefinitions.h"

void GPIO_clearInterrupt(GPIO_portNameType portName)
{
	static uint32 * const PORTx_ISFR[5] = {&PORTA_ISFR, &PORTB_ISFR, &PORTC_ISFR, &PORTD_ISFR, &PORTE_ISFR};
	*PORTx_ISFR[portName] = 0xFFFFFFFF;
	return;
}
void GPIO_clockGating(GPIO_portNameType portName)
{
	static const uint32 GPIO_CLOCK_GATING_PORTx[5] = {GPIO_CLOCK_GATING_PORTA, GPIO_CLOCK_GATING_PORTB,
													  GPIO_CLOCK_GATING_PORTC, GPIO_CLOCK_GATING_PORTD,
													  GPIO_CLOCK_GATING_PORTE};
	SIM_SCGC5 |= GPIO_CLOCK_GATING_PORTx[portName];

	return;
}// end function

uint8 GPIO_pinControlRegister(GPIO_portNameType portName,uint8 pin,const GPIO_pinControlRegisterType*  pinControlRegister)
{

	switch(portName)
		{
		case GPIOA:/** GPIO A is selected*/
			PORTA_PCR(pin)= *pinControlRegister;
			break;
		case GPIOB:/** GPIO B is selected*/
			PORTB_PCR(pin)= *pinControlRegister;
			break;
		case GPIOC:/** GPIO C is selected*/
			PORTC_PCR(pin)= *pinControlRegister;
			break;
		case GPIOD:/** GPIO D is selected*/
			PORTD_PCR(pin)= *pinControlRegister;
			break;
		case GPIOE: /** GPIO E is selected*/
			PORTE_PCR(pin)= *pinControlRegister;
		default:/**If doesn't exist the option*/
			return(FALSE);
		break;
		}
	/**Successful configuration*/
	return(TRUE);
}

void GPIO_writePORT(GPIO_portNameType portName, uint32 Data ){
	 static uint32 * const GPIOx_PDOR[5] = {&GPIOA_PDOR, &GPIOB_PDOR, &GPIOC_PDOR, &GPIOD_PDOR, &GPIOE_PDOR};
	 *GPIOx_PDOR[portName] = Data;

}
uint32 GPIO_readPORT(GPIO_portNameType portName){
	uint32 Data;
	static uint32 * const GPIOx_PDIR[5] = {&GPIOA_PDIR, &GPIOB_PDIR, &GPIOC_PDIR, &GPIOD_PDIR, &GPIOE_PDIR};
	Data = *GPIOx_PDIR[portName];
	return Data;
}
uint8 GPIO_readPIN(GPIO_portNameType portName, uint8 pin){
	uint32 REG = GPIO_readPORT(portName);
	uint32 mask = 2^pin;
		if(REG & mask)
			return 1;
		else
			return 0;
}
void GPIO_setPIN(GPIO_portNameType portName, uint8 pin){
	static uint32 * const GPIOx_PSOR[5] = {&GPIOA_PSOR, &GPIOB_PSOR, &GPIOC_PSOR, &GPIOD_PSOR, &GPIOE_PSOR};
	*GPIOx_PSOR[portName] = 1 << pin;

}
void GPIO_clearPIN(GPIO_portNameType portName, uint8 pin){
	static uint32 * const GPIOx_PCOR[5] = {&GPIOA_PCOR, &GPIOB_PCOR, &GPIOC_PCOR, &GPIOD_PCOR, &GPIOE_PCOR};
	*GPIOx_PCOR[portName] = 1 << pin;

}

void GPIO_togglePIN(GPIO_portNameType portName, uint8 pin){
	static uint32 * const GPIOx_PTOR[5] = {&GPIOA_PTOR, &GPIOB_PTOR, &GPIOC_PTOR, &GPIOD_PTOR, &GPIOE_PTOR};
	*GPIOx_PTOR[portName] =  1<<pin;

}
void GPIO_dataDirectionPORT(GPIO_portNameType portName ,uint32 direction){
	static uint32 * const  GPIOx_PDDR[5] = {&GPIOA_PDDR, &GPIOB_PDDR, &GPIOC_PDDR, &GPIOD_PDDR, &GPIOE_PDDR};
	*GPIOx_PDDR[portName] = direction;
}
void GPIO_dataDirectionPIN(GPIO_portNameType portName, uint8 State, uint8 pin){
	static uint32 * const GPIOx_PDDR[5] = {&GPIOA_PDDR, &GPIOB_PDDR, &GPIOC_PDDR, &GPIOD_PDDR, &GPIOE_PDDR};
	*GPIOx_PDDR[portName] |= State << pin;
}




