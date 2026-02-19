#include <xc.inc>

global	matrixA, matrixB, matrixC
    
psect	udata_acs
matrix_count:	ds 1 ;reserve on byte in access ram
counter:	ds 2

psect	udata_bank4 
runningSum:	ds 0x08 ;reserve 8 bytes in bank 4 in ram

psect	data ;stores data in PM
matrixA:
    db	0x01, 0x02, 0x01
    db	0x02, 0x01, 0x02
    db	0x01, 0x02, 0x01
    matrix_l EQU 3
    align   2

psect	data ;stores data in PM
matrixB:
    db	0x01, 0x01, 0x01
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

	; ******* Big Delay Loop *********************
bigdelay:
	movlw   0x00		; W=0
dloop:	decf	0x11, f, A	; no cary when 0x00 is 0xff
	subwfb  0x10, f, A	; no carry when 0x00 is 0xff
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bc dloop		; if carry loop again
	return			; carry not set so return
	; ******* Main programme *********************
start:	
	;lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(matrixA)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(matrixA)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(matrixA)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	9		; 9 bytes to read
	movwf 	counter, A	; our counter register
	movlw   0x00		; initialising port D
	movwf   TRISD, A	; setting port D as a output

	
loop:
	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTD	; move read data from TABLAT to (FSR0), increment FSR0

	movlw	high(0xFFFF)	; load 16 bit number into address for big delay
	movwf	0x10, A		; FR 0x10
	movlw	low(0xFFFF)		
	movwf	0x11, A		; nd FR 0x11
	call	bigdelay	; call a long delay
	call	bigdelay
	call    bigdelay
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	end	rst