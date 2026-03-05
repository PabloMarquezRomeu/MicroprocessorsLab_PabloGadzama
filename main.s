#include <xc.inc>
#include "tblptr_macros.inc"  

extrn	initMAC, computationMAC	    ;Subroutines from other files
    

psect code, abs  ;eerything that follows this psect will be stored as executable code in PM. The abs means that we will literally choose where to store this.
rst:	org 0x0
    goto    setup  ;So we place the command 'goto setup' in 0x0
    
	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	initMAC 
	goto	start

	; ******* Main programme *********************
start:	
	call	computationMAC ;This function will result in the whole filtered vector in vectorY in RAM.
	nop
	nop
	end rst
	
