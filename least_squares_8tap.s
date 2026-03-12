#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a least squares sampling method
 ;seems to have good performance,
 ; the -3Db seems to be around 0.99 kHZ
 ; i put the stop band to be at  1.5 kHz
coeffs_PM:
    db 0xAC, 0xD3, 0xF0, 0xFF, 0xFF, 0xF0, 0xD3, 0xAC
    align 2


