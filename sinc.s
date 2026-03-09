#include <xc.inc>
    
global  Sinc_x, Sinc_x_l
    
psect data;const_data,class=CODE

Sinc_x:
    db 0xAA,0x55,0x01,0x02,0x03,0x04,0x05
    align 2
    Sinc_x_l  EQU 7
