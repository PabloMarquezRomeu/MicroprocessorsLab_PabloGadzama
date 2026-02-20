#include <xc.inc>
#include "tblptr_macros.inc"
    ;This file contains a MVMLoop that will use the functions PMRAMCopy etc...

extrn	vectorX, rowA, runningSum, matrixA, counter
global  MVMLoop  
    
psect	uart_code, class=CODE
MVMLoop:
    ;For now only implement this loop once, then well loop it
    ;call WriteY
    ;repeat this until all rows done
   
    movlw   matrix_l	; 3 bytes to read
    movwf   counter, A	; our counter register
    TBLPTR_POINT_TO matrixA ;Points TBL to matrixA in PM memory
    lfsr    0, rowA ; Points FSR0 to the data space in RAM for the temporary row from matrix A
    call    PMRAMCopy	; copies the first row of matrix A onto RAM memory
    
    movlw   matrix_l	; Loads the number of bytes we have to multiply to our counter register for the MACloop
    movwf   counter, A	
    lfsr    0, rowA		; load row A onto FSR0
    lfsr    1, vectorX	; load columnB onto FSR1
    call MACOperation ;Multiplies the numbers pointed by FSR0 and FSR1, and adds this to the runningsum. These two loop through rowA and vectorX
    
    ;call WriteY We will have to somehow implement something that writes the running sum to the correct position in vectorY
    ;We will also need this to loop until all the vectorY is filled properly
    
    return
    
    
PMRAMCopy:
    tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
    movff   TABLAT, POSTINC0 
    decfsz  counter, A
    bra	    PMRAMCopy
    
    return
    
    
MACOperation:
    movf    POSTINC0, W, A	; move FSR0 to working
    mulwf   POSTINC1, A	; multiply workin with FSR1. 8bit multiplication in this case, so 16bit result
    movf    PRODL, W, A	; Move low result to working and add it to low runnin sum byte
    addwf   runningSum, F, A
    movf    PRODH, W, A	; Move high result to working and add it to high running sum byte
    addwfc  runningSum+1, F, A
    
    decfsz  counter, A	; count down to zero
    bra	    MACOperation	; keep going until finished
    
    return



