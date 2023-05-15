#include "terasic_includes.h"
#include "SEG7.h"

#define SEG7_SET(index, seg_mask)   IOWR(SEG7_BASE,index,seg_mask)
#define SEG7_NUM    6

static    unsigned char szMap[] = {
        63, 6, 91, 79, 102, 109, 125, 7, 
        127, 111, 119, 124, 57, 94, 121, 113, 0, 64
    };  // 0,1,2,....9, a, b, c, d, e, f
    
void SEG7_Clear(void){
    int i;
    for(i=0;i<SEG7_NUM;i++){
        SEG7_SET(i, 0x00);
    }        
}
void SEG7_Full(void){
    int i;
    for(i=0;i<SEG7_NUM;i++){
        SEG7_SET(i, 0xFF);
    }        
}

void SEG7_Number(void){
    int i;
    for(i=0;i<SEG7_NUM;i++){
        SEG7_SET(i, szMap[i]);
    }        
}

void SEG7_Hex(alt_u32 Data, alt_u8 point_mask){
    alt_u8 mask = 0x01;
    alt_u8 seg_mask;
    int i;
    
    //
    seg_mask = 0;
    for(i=0;i<SEG7_NUM;i++){
        seg_mask = szMap[Data & 0x0F];
        Data >>= 4;
        if (point_mask & mask)
            seg_mask |= 0x80;
        mask <<= 1;     
        SEG7_SET(i, seg_mask);
    }        
}

void SEG7_Set(int index, int value)
{
	SEG7_SET(6-index, szMap[value]);
}

void SEG7_Decimal(int start, int end, int value)
{
    int i = 0;
    for(i = end; i >= start; i--)
    {
        SEG7_Set(i, value % 10);
        value = value / 10;
    }
}
