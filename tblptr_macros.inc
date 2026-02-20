 
matrix_l    EQU 3
    
TBLPTR_POINT_TO macro label
    movlw   low highword(label)	; address of data in PM
    movwf   TBLPTRU, A	; load upper bits to TBLPTRU
    movlw   high(label)	; address of data in PM
    movwf   TBLPTRH, A	; load high byte to TBLPTRH
    movlw   low(label)	; address of data in PM
    movwf   TBLPTRL, A
endm

