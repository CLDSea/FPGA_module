/*
 * AD9910.c
 *
 *  Created on: 2023Äê5ÔÂ13ÈÕ
 *      Author: FuYuhao
 */

#include "terasic_includes.h"
#include "AD9958.h"
#include "SPI.h"
#include <math.h>

void AD9958Init()
{
	//CSR
	SpiTX(0x00,1);
	SpiTX(0x00,1);
	//FR1
	SpiTX(0x01,1);
	SpiTX(0xD00000,3);
	//CFR
	SpiTX(0x03,1);
	SpiTX(0x000300,3);
	IOWR(IO_UPDATE_OUT_BASE,0,0);
	IOWR(IO_UPDATE_OUT_BASE,0,1);
}

void AD9958FrePhaseAmp(int fre,int phase,double amp, int ch)
{
	alt_u32 CFTW0=round(fre*8.589934592);//0-250_000_000
	alt_u32 CPOW0=round(phase*45.511111111);//0-360
	alt_u32 ACR=round(amp*1023);//0-1
	ACR |= 0x001000;

	alt_u8 CSR=0;

	switch(ch)
	{
	case 0:
		CSR=0x40;
		break;
	case 1:
		CSR=0x80;
		break;
	case 2:
		CSR=0xC0;
		break;
	default:
		CSR=0x40;
		break;
	}

	//CSR
	SpiTX(0x00,1);
	SpiTX(CSR,1);
	//fre
	SpiTX(0x04,1);
	SpiTX(CFTW0,4);
	//phase
	SpiTX(0x05,1);
	SpiTX(CPOW0,2);
	//amp
	SpiTX(0x06,1);
	SpiTX(ACR,3);
	IOWR(IO_UPDATE_OUT_BASE,0,0);
	IOWR(IO_UPDATE_OUT_BASE,0,1);
}
