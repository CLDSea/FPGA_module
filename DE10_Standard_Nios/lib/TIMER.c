/*
    TIMER.c

    Created on: 2023Äê3ÔÂ17ÈÕ
        Author: FuYuhao
*/

#include "terasic_includes.h"
#include "TIMER.h"

int timer_count = 0;

void TimerIrqInit()
{
	IOWR(TIMER_BASE, 1, 0x03);
	IOWR(TIMER_BASE, 0, 0);
	alt_irq_register(TIMER_IRQ, NULL, (void*) TimerIrq);
}

void TimerIrq()//10Hz
{
	IOWR(TIMER_BASE, 0, 0);
	if(timer_count % 10 == 0)
	{
		//		printf("%d\n",timer_count/10);
	}
	timer_count = (timer_count + 1) % 100;
}
