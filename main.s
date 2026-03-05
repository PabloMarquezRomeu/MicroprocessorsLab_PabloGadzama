	#include <xc.inc>
	
	extern myTable
	extern myTable_len
	
psect	code, abs
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
;psect flash_data, class = CODE, space=0
 
;myTable:
	;myTable:
	     ;table from pyhon, just taken fro  python crpt that gnerates this the old fashion way
	;db 252,3,0, 6, 249, 5, 0 ,250, 12, 242, 11, 0, 230, 127,127
	;db 230, 0, 11, 242, 12, 250, 0, 5, 249, 6, 253, 0 , 0, 252
	;myArray EQU 0x400	; Address in RAM for data
	;counter EQU 0x10	; Address of counter variable
	;align	2		; ensure alignment of subsequent instructions 
	; ******* Main programme *********************
start:	
	movlw  myTable_len
	movwf  counter
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	22		; 22 bytes to read
	movwf 	counter, A	; our counter register
loop:
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	end	main
