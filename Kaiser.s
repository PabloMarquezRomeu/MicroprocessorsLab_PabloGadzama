#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a KAISER window
 ;CAREFULLLL the kaiser window has a parameter B which we decide in order to change
 ;the tradeoff between stopband atteunation an transition width
 ; i chose a Beta of 2, so we have moderate ripple
 ; if we had a Beta of 0 it would be the Rectangle window
 ; -3db is at 1.15 when it should be at 1kHz
 ;just 
coeffs_PM:
    db 0x5C, 0x9F, 0xDB, 0xFF, 0xFF, 0xDB, 0x9F, 0x5C
    align 2



