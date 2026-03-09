#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message ; external subroutines
extrn   Sinc_x, Sinc_x_l_high, Sinc_x_l_low
global myArray

psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 7 ;0x80 ; reserve 128 bytes for message data


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

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst