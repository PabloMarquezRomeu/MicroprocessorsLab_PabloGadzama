#include <xc.inc>
#include "tblptr_macros.inc"
    ;This file contains a MVMLoop that will use the functions PMRAMCopy etc...

global  MVMLoop, matrixA, vectorX, vectorY, rowA, runningSum, counter, matrix_count

    
psect	udata_acs ;Reserves UNDEFINED data in access ram (start of ram)
matrix_count:	ds 1 ;reserve one byte in access ram
counter:	ds 1
runningSum:	ds 0x02 ;reserve 2 bytes in ram for the 16bit result of an 8 bit multiplication

psect	udata_bank5 ;Reserves UNDEFINED data specifically in bank 5 of RAM
rowA:		ds matrix_l ;reserve 3 bytes in ram
vectorX:	ds matrix_l 
vectorY:	ds matrix_l ;reserve 3 bytes in RAM for vector Y
    
psect	data ;stores data in PM
matrixA:
    db	0x03, 0x02, 0x01
    db	0x02, 0x01, 0x02
    db	0x01, 0x02, 0x01
    align   2

    
psect	uart_code, class=CODE
MVMLoop:
    TBLPTR_POINT_TO matrixA ;Points TBL to matrixA in PM memory
    lfsr    2, vectorY ;Points FSR2 to vector Y
    movlw   matrix_l	; 3 bytes to read
    movwf   counter, A	; our counter register
    call    clearVariable ;Clear the entire vector Y
    lfsr    2, vectorY ;Points FSR2 to vector Y
    
rowLoop:
    clrf    runningSum, A ;Important to clear as when ram is initialised it will have random numbers
    clrf    runningSum+1, A
    
    movlw   matrix_l	; 3 bytes to read
    movwf   counter, A	; our counter register
    lfsr    0, rowA ; Points FSR0 to the data space in RAM for the temporary row from matrix A
    call    PMRAMCopy	; copies the first row of matrix A onto RAM memory
    
    movlw   matrix_l	; Loads the number of bytes we have to multiply to our counter register for the MACloop
    movwf   counter, A	
    lfsr    0, rowA	; load row A onto FSR0
    lfsr    1, vectorX	; load columnB onto FSR1
    call    MACOperation ;Multiplies the numbers pointed by FSR0 and FSR1, and adds this to the runningsum. These two loop through rowA and vectorX
    movff   runningSum, POSTINC2 ;Stores only the low byte for now in vector Y
    
    decfsz  matrix_count, A	; count down to zero
    bra	    rowLoop	; keep going until finished
    
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


clearVariable:
    clrf    POSTINC2, A
    decfsz  counter, A
    bra	    clearVariable

    return