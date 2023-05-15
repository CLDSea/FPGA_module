/*
 * UART.c
 *
 *  Created on: 2023Äê5ÔÂ8ÈÕ
 *      Author: FuYuhao
 */

#include "terasic_includes.h"
#include "UART.h"

int ctrl_value=-1;

void UartIrqInit(long baud)
{
   IOWR(UART_BASE, 4,100000000/baud-1);

   IOWR(UART_BASE, 3, 0x80);
   IOWR(UART_BASE, 2, 0);
   alt_irq_register(UART_IRQ, NULL, (void *) UartIrq);
}

void UartIrq()
{
	IOWR(UART_BASE, 2, 0);

	ctrl_value=IORD(UART_BASE,0);

	printf("ctrl=%d\n",ctrl_value);
}

void UartTX(char str[])
{
	while(*str!='\0')
	{
		while(!(IORD(UART_BASE,2)&0x40));
		IOWR(UART_BASE,1,*str);
		str++;
	}
}
