// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

#ifndef DEBUG_H_
#define DEBUG_H_

//#define ENABLE_UART_DEBUG


int myprintf(char *format, ...);
int myprintf_hex_array(unsigned char *pHex, int len);
int  myprintf_dword_array(unsigned int *pArray, int nElementCount);



//============== debug config ===================

#define DEBUG(x)               {myprintf x;}  // standard in/out, specifed in project (it could be uart, jtag, or lcd)
#define DEBUG_DWORD_ARRAY(x)   {myprintf_dword_array x;}

#define DEBUG_APP
#define xDEBUG_FAT           
#define DEBUG_ENET          
#define DEBUG_I2C
#define DEBUG_AUDIO
#define DEBUG_FLASH
#define xDEBUG_SDCARD
#define xDEBUG_USB_ISR
#define xDEBUG_USB_PORT
#define xDEBUG_USB_PTD
#define xDEBUG_USB_HAL4D13
#define xDEBUG_USB_REG
#define DEBUG_USB_LB     // USB LOOPBACK TEST
#define xDEBUG_USB_BUF
#define xDEBUG_USB_DEVICE
#define xDEBUG_USB_MOUSEHC   // mouse host control

#endif /*DEBUG_H_*/
