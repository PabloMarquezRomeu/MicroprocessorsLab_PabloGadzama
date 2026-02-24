#include <xc.inc>
#include "tblptr_macros.inc"  

extrn	MVMLoop, matrixA, vectorX, vectorY, rowA, runningSum, counter, matrix_count	    ;Subroutines from other files
    

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
	movlb   5; Point to bank 5. I have to do this for now, but hopefully this is where the data from the sensor will be stored
	movlw	0x01 
	movwf	vectorX, B
	movlw	0x02
	movwf	vectorX+1, B
	movlw	0x03
	movwf	vectorX+2, B
	
	movlw   matrix_l	; 3 bytes to read
	movwf   matrix_count, A
	call	MVMLoop ;This function will use FSR0, 1, 2 to multiply the matrix A stored in PM with the vector X stored in RAM, and will output the result in RAM
	nop
	nop
	end rst
	
