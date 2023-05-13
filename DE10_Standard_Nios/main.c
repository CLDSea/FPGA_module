#include "terasic_includes.h"
#include "LED.h"
#include "SEG7.h"
#include "TIMER.h"
#include "KEY.h"
#include "UART.h"

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
//    		key_value=-1;
//    	}
//
//    	if(ctrl_value!=-1)
//    	{
//    		ctrl_value=-1;
//    	}
    }
}
