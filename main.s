main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db	0x01,0x02,0x04,0x08,0x80,0x40,0x20,0x10,' ','a',' '
	db	'a',' ','a',' ','a',' ','a',' ','a',' '
	;myArray EQU 0x400	; Address in RAM for data
	counter EQU 0x20	; Address of counter variable
	align	2		; ensure alignment of subsequent instructions 
	; ******* Big Delay Loop *********************
bigdelay:
	movlw   0x00		; W=0
dloop:	decf	0x11, f, A	; no cary when 0x00 is 0xff
	subwfb  0x10, f, A	; no carry when 0x00 is 0xff
	nop
	nop
	nop
	nop
	bc dloop		; if carry loop again
	return			; carry not set so return
	; ******* Main programme *********************
start:	
	;lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	8		; 22 bytes to read
	movwf 	counter, A	; our counter register
	movlw   0x0		; initialising port J
	movwf   TRISJ, A	; setting port J as a output
	movlw   0x0		; initialising port D
	movwf   TRISD, A	; setting port D as a output
	movlw   0xFF
	movwf   PORTD, A
	
loop:
	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTJ	; move read data from TABLAT to (FSR0), increment FSR0
	movlw   0x00		; Controlling
	movwf   PORTD, A
	nop
	movlw   0xFF
	movwf   PORTD, A
	movlw	high(0xFFFF)	; load 16 bit number into address for big delay
	movwf	0x10, A		; FR 0x10
	movlw	low(0xFFFF)		
	movwf	0x11, A		; nd FR 0x11
	call	bigdelay	; call a long delay
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	end	main
