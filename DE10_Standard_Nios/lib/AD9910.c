/*
    AD9910.c

    Created on: 2023��5��13��
        Author: FuYuhao
*/

#include "terasic_includes.h"
#include "AD9910.h"
#include "SPI.h"
#include <math.h>

//PCB��CS_N��IO_RESET����������ʹ��spi ip���е�CS_N�ܽţ�ʹ��IO_UPDATE�ܽŴ���CS_N�ܽ�
void AD9910Init()
{
	IOWR(IO_UPDATE_OUT_BASE, 0, 0);
	
	//CFR1
	SpiTX(0x00, 1);
	SpiTX(0x00400000, 4);
	//CFR3
	SpiTX(0x02, 1);
	SpiTX(0x05084132, 4);
	//I/O_Update
	SpiTX(0x04, 1);
	SpiTX(0x00000004, 4);
	//CFR2
	SpiTX(0x01, 1);
	SpiTX(0x01C00000, 4);

	IOWR(IO_UPDATE_OUT_BASE, 0, 1);
}

void AD9910FrePhaseAmp(int fre, int phase, double amp)
{
	alt_u64 FTW = round(fre * 4.294967296); //0-500_000_000
	alt_u64 POW = round(phase * 182.044444444); //0-360
	alt_u64 ASF = round(amp * 16383); //0-1

	IOWR(IO_UPDATE_OUT_BASE, 0, 0);

	SpiTX(0x15, 1);
	SpiTX((ASF << 48) | (POW << 32) | FTW, 8);

	IOWR(IO_UPDATE_OUT_BASE, 0, 1);
}
