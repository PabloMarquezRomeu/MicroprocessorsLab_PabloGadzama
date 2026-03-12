#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a blackman window
 ; doesn't work with 8 tap
 ; -3db is at 1.82 when it should be at 1kHz
coeffs_PM:
    db 0x00, 0x17, 0x7B, 0xFF, 0xFF, 0x7B, 0x17, 0x00
    align 2


