#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message ; external subroutines
extrn   Sinc_x

psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	goto	start
	
	; ******* Main programme ****************************************
start: 	
	movlw	low highword(Sinc_x)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(Sinc_x)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(Sinc_x)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	
	call	UART_Transmit_Message

	goto	$		; goto current line in code

