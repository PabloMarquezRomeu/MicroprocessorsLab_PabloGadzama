#include <xc.inc>

; ================================
; Program code section
; ================================
    
psect code, abs
main:
    org 0x0
    goto setup
    org 0x100

setup:
    bcf CFGS       
    bsf EEPGD
    goto start
    
; ================================
; Program memory data section
; ================================
psect flash_data,class=CODE,space=0

myTable:
    ;table from pyhon
    db 12,14,18,21,25,30,36,40
    db

myTable_l EQU 8
    

; ===== MAIN PROGRAM =====
start:

    ; Point TBLPTR to start of table
    movlw low highword(myTable)
    movwf TBLPTRU

    movlw high(myTable)
    movwf TBLPTRH

    movlw low(myTable)
    movwf TBLPTRL

loop:
    tblrd*+             ; read byte from Flash ? TABLAT
    movf TABLAT, W      ; sample now in WREG
                        ; (use it here for DSP / DAC / UART)
    bra loop            ; continue forever

    goto 0 


end main    


