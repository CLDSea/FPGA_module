/*
    AD9910.c

    Created on: 2023年5月13日
        Author: FuYuhao
*/

#include "terasic_includes.h"
#include "AD9910.h"
#include "SPI.h"
#include <math.h>

//PCB中CS_N与IO_RESET相连，不能使用spi ip核中的CS_N管脚，使用IO_UPDATE管脚代替CS_N管脚，需要调节延时
void AD9910Init()
{
	while(!(IORD(SPI_BASE,2)&0x40));
	usleep(1);
	IOWR(IO_UPDATE_OUT_BASE, 0, 0);
	
	//CFR1
	SpiTX(0x00, 1);
	SpiTX(0x00400000, 4);
	//CFR3
	SpiTX(0x02, 1);
	SpiTX(0x050F4132, 4);
	//I/O_Update
	SpiTX(0x04, 1);
	SpiTX(0x000061A8, 4);
	//CFR2
	SpiTX(0x01, 1);
	SpiTX(0x01C00000, 4);

	while(!(IORD(SPI_BASE,2)&0x40));
	usleep(1);
	IOWR(IO_UPDATE_OUT_BASE, 0, 1);
}

void AD9910FrePhaseAmp(int fre, int phase, double amp)
{
	alt_u64 FTW = ((alt_u64)round(fre * 4.294967296))&0xFFFFFFFF; //0-500_000_000
	alt_u64 POW = ((alt_u64)round(phase * 182.044444444))&0xFFFF; //0-360
	alt_u64 ASF = ((alt_u64)round(amp * 16383.0))&0x3FFF; //0-1

	while(!(IORD(SPI_BASE,2)&0x40));
	usleep(1);
	IOWR(IO_UPDATE_OUT_BASE, 0, 0);

	SpiTX(0x15, 1);
	SpiTX((ASF << 48) | (POW << 32) | FTW, 8);

	while(!(IORD(SPI_BASE,2)&0x40));
	usleep(1);
	IOWR(IO_UPDATE_OUT_BASE, 0, 1);
}
