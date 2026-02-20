#include <xc.inc>
#include "tblptr_macros.inc"  

    
    
extrn	MVMLoop	    ;Subroutines from other files
global	columnB, rowA, runningSum, matrix_l, matrixA, counter
    
psect	udata_acs
matrix_count:	ds 1 ;reserve one byte in access ram
counter:	ds 1
runningSum:	ds 0x02 ;reserve 2 bytes in bank 4 in ram for the 16bit result of an 8 bit multiplication
    
psect	udata_bank5
rowA:		ds 0x03 ;reserve 3 bytes in ram
columnB:	ds 0x03 ;reserve 3 bytes in ram

psect	data ;stores data in PM
matrixA:
    db	0x03, 0x02, 0x01
    db	0x02, 0x01, 0x02
    db	0x01, 0x02, 0x01
    matrix_l EQU 3
    align   2

psect	data ;stores data in PM
matrixB:
    db	0x01, 0x02, 0x03
    db	0x01, 0x01, 0x01
    db	0x01, 0x01, 0x01
    align   2
    
psect	data ;stores data in PM
matrixC:
    db	0x00, 0x00, 0x00
    db	0x00, 0x00, 0x00
    db	0x00, 0x00, 0x00
    align   2

psect code, abs  ;eerything that follows this psect will be stored as executable code in PM. The abs means that we will literally choose where to store this.
rst:	org 0x0
    goto    setup  ;So we place the command 'goto setup' in 0x0
    
	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	goto	start

	; This function writes whatever is in he TABLAT pointer to the FSR0 pointer. It writes the number of bits that we give counter
writeloop:			
	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0
	decfsz	counter, A
	bra	writeloop
	
	return

	; ******* Main programme *********************
start:	
	clrf	runningSum, A
	clrf	runningSum+1, A
	
	movlw	matrix_l	; 3 bytes to read
	movwf 	counter, A	; our counter register
	TBLPTR_POINT_TO matrixB
	lfsr	0, columnB	; load columnB onto FSR0
	call	writeloop	; write from matrixB in PM to column B in RAM
	
	
	;Point FSR0 to temporary matrixA row
	;Point FSR1 to vectorX in RAM
	;Length is defined as a global variable
	lfsr	0, rowA	; load columnB onto FSR0
	lfsr	1, columnB	; load columnB onto FSR0
	call	MVMLoop
	nop
	nop
	end rst
	
