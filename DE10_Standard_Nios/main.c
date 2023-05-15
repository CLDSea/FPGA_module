#include "lib/terasic_includes.h"
#include "lib/LED.h"
#include "lib/SEG7.h"
#include "lib/TIMER.h"
#include "lib/KEY.h"
#include "lib/UART.h"
#include "lib/SPI.h"
#include "lib/AD9958.h"
#include "lib/AD9910.h"


#include <math.h>

#ifdef DEBUG_APP
    #define APP_DEBUG(x)    DEBUG(x)
#else
    #define APP_DEBUG(x)
#endif

void Init()
{
	TimerIrqInit();
	KeyIrqInit();

	UartIrqInit(921600);

	//AD9910Init();
	//AD9958Init();
}

int main()
{
    printf("Hello Nios\n");

    Init();

    printf("Inited\n");

    while(1)
    {
//    	if(key_value!=-1)
//    	{
//    		key_value=-1;+
//    	}
//
//    	if(ctrl_value!=-1)
//    	{
//    		ctrl_value=-1;
//    	}
    }
}
