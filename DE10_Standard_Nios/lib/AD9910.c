/*
 * AD9910.c
 *
 *  Created on: 2023Äê5ÔÂ13ÈÕ
 *      Author: FuYuhao
 */

#include "terasic_includes.h"
#include "AD9910.h"
#include "SPI.h"
#include <math.h>

void AD9910Init()
{
	//CFR2
	SpiTX(0x01,1);
	SpiTX(0x01800000,4);
	//CFR1
	SpiTX(0x00,1);
	SpiTX(0x00400000,4);
	//CFR3
	SpiTX(0x02,1);
	SpiTX(0x05084132,4);
}

void AD9910FrePhaseAmp(int fre,int phase,double amp)
{
	alt_u64 FTW=round(fre*4.294967296);//0-500_000_000
	alt_u64 POW=round(phase*182.044444444);//0-360
	alt_u64 ASF=round(amp*16383);//0-1

	SpiTX(0x0E,1);
	SpiTX((ASF<<48)|(POW<<32)|FTW,8);
}
