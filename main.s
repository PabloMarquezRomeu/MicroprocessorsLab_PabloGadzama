#include <xc.inc>
#include "tblptr_macros.inc"  

extrn	initMAC, computationMAC, UART_Setup, timer0_int_hi, startTimer, sendTimerUART	    ;Subroutines from other files
    

psect code, abs  ;eerything that follows this psect will be stored as executable code in PM. The abs means that we will literally choose where to store this.
rst:	org 0x0
    goto    setup  ;So we place the command 'goto setup' in 0x0
    
int_hi: org 0x0008
    goto    timer0_int_hi
    
	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup
	call	initMAC 
	
	movlw	0x00
	movwf	TRISD, A
	
	goto	start

	; ******* Main programme *********************
start:	
	call	startTimer
	call	computationMAC ;This function will result in the whole filtered vector sent through uart to the pc.
	call	sendTimerUART
	nop
	nop
	goto	$
	end rst
	
