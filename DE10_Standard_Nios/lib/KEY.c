/*
    KEY.c

    Created on: 2023Äê3ÔÂ17ÈÕ
        Author: FuYuhao
*/

#include "terasic_includes.h"
#include "KEY.h"

int key_value = -1;

void KeyIrqInit()
{
	IOWR(KEY_BASE, 2, 0x0F);
	IOWR(KEY_BASE, 3, 0);
	alt_irq_register(KEY_IRQ, NULL, (void*) KeyIrq);
}

void KeyIrq()
{
	IOWR(KEY_BASE, 3, 0);
	switch(IORD(KEY_BASE, 0))
	{
		case 0x07://0111
			key_value = 3;
			break;
		case 0x0B://1011
			key_value = 2;
			break;
		case 0x0D://1101
			key_value = 1;
			break;
		case 0x0E://1110
			key_value = 0;
			break;
		default:
			break;
	}
	//	printf("key=%d\n",key_value);
}
