#include <xc.inc>
    
global  Sinc_x, Sinc_x_l
    
psect data;const_data,class=CODE

Sinc_x:
    db 0xAA,0x55,0x7F,0x80,0x7F,0x80,0x7F
    align 2
    Sinc_x_l  EQU 7 ;2 longer than signal to send the initial marker aswell.
