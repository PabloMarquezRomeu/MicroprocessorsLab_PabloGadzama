#include <xc.inc>
#include "tblptr_macros.inc"  

extrn	MVMLoop	    ;Subroutines from other files
global	vectorX, rowA, runningSum, matrixA, counter
    
psect	udata_acs ;Reserves UNDEFINED data in access ram (start of ram)
matrix_count:	ds 1 ;reserve one byte in access ram
counter:	ds 1
runningSum:	ds 0x02 ;reserve 2 bytes in ram for the 16bit result of an 8 bit multiplication

psect	udata_bank5 ;Reserves UNDEFINED data specifically in bank 5 of RAM
rowA:		ds 0x03 ;reserve 3 bytes in ram
vectorX:	ds 0x03 
vectorY:	ds 0x03 ;reserve 3 bytes in RAM for vector Y

psect	data ;stores data in PM
matrixA:
    db	0x03, 0x02, 0x01
    db	0x02, 0x01, 0x02
    db	0x01, 0x02, 0x01
    align   2

psect code, abs  ;eerything that follows this psect will be stored as executable code in PM. The abs means that we will literally choose where to store this.
rst:	org 0x0
    goto    setup  ;So we place the command 'goto setup' in 0x0
    
	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	goto	start

	; ******* Main programme *********************
start:	
	clrf	runningSum, A ;Important to clear as when ram is initialised it will have random numbers
	clrf	runningSum+1, A
	movlb   5; Point to bank 5. I have to do this for now, but hopefully this is where the data from the sensor will be stored
	movlw	0x01 
	movwf	vectorX, B
	movlw	0x02
	movwf	vectorX+1, B
	movlw	0x03
	movwf	vectorX+2, B
	

	;Length is defined as a global variable is the tblptr macros file for now. It should be processed from data
	lfsr	0, rowA	;Point FSR0 to temporary matrixA row
	lfsr	1, vectorX ;Point FSR1 to vectorX in RAM
	call	MVMLoop
	nop
	nop
	end rst
	
