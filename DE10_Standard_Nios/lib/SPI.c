/*
    SPI.c

    Created on: 2023Äê5ÔÂ14ÈÕ
        Author: FuYuhao
*/

#include "terasic_includes.h"
#include "AD9910.h"

void SpiTX(alt_u64 data, int len)
{
	for(int i = 0; i < len; i++)
	{
		while(!(IORD(SPI_BASE, 2) & 0x40));
		IOWR(SPI_BASE, 1, (data >> ((len - i - 1) * 8)) & 0xFF);
	}
}
