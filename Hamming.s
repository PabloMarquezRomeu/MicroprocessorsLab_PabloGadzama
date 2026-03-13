#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a Hamming window
 ; doesn't seem to give very good performance
 ; -3db is at 1.82 when it should be at 1kHz
 ;just 
coeffs_PM:
    db 0x11, 0x3D, 0xA6, 0xFF, 0xFF, 0xA6, 0x3D, 0x11
    align 2


