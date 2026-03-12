#include <xc.inc>

gloabl coeffs_PM

psect data 
; just a note, this is an 8 tap FIR generated from Matlab, 
 ; this is designed using a Remez exchange also known as Parks-McClellan
 ; there was an -Db cut off at 0.95 kHz, i specified the attenuation band to start at 1.6 kHz
coeffs_PM:
    db 0xFF, 0x6F, 0x7C, 0x83, 0x83, 0x73, 0x6F, 0xFF
    align 2


