#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a Rectangle window
 ; -3db is at 1.15 when it should be at 1kHz
 ;just 
coeffs_PM:
    db 0xCF, 0xE6, 0xF7, 0xFF, 0xFF, 0xF7, 0xE6, 0xCF
    align 2



