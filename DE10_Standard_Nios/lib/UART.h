/*
    UART.h

    Created on: 2023Äê5ÔÂ8ÈÕ
        Author: FuYuhao
*/

#ifndef UART_H_
#define UART_H_

extern int ctrl_value;

void UartIrqInit(long baud);
void UartIrq();

void UartTX(char str[]);

#endif /* UART_H_ */
