/*
 * TIMER.h
 *
 *  Created on: 2023��3��17��
 *      Author: FuYuhao
 */

#ifndef TIMER_H_
#define TIMER_H_

extern int timer_count;

void TimerIrqInit();
void TimerIrq();

#endif /* TIMER_H_ */
