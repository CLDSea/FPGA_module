/*
    UART.h

    Created on: 2023��5��8��
        Author: FuYuhao
*/

#ifndef UART_H_
#define UART_H_

extern int ctrl_value;

void UartIrqInit(long baud);
void UartIrq();

void UartTX(char str[]);

#endif /* UART_H_ */
