 
signal_l    EQU 1000
buffer_l    EQU 8
buffer_mask EQU 7 ;This mask allows us to do MOD8 on the counters by only taking the lowest three bits
	    
    
TBLPTR_POINT_TO macro label
    movlw   low highword(label)	; address of data in PM
    movwf   TBLPTRU, A	; load upper bits to TBLPTRU
    movlw   high(label)	; address of data in PM
    movwf   TBLPTRH, A	; load high byte to TBLPTRH
    movlw   low(label)	; address of data in PM
    movwf   TBLPTRL, A
endm

