#include <xc.inc>
#include "tblptr_macros.inc"
    ;This file contains a MVMLoop that will use the functions PMRAMCopy etc...

global  initMAC, computationMAC, vectorX, vectorY, coeffs, x_buffer


psect	udata_acs ;Reserves UNDEFINED data in access ram (start of ram)
buffer_address:	ds 1 ;circular pointer around the buffer to write new signal value
MAC_address:	ds 1 ;loops over the 8 values of the buffer for the MAC
vectorY_address:ds 1 ;Points to the vector y to write after the MAC operation
counter_signal:	ds 1 ; counter to loop over the entire signal
counter_MAC:	ds 1 ;counter to loop over the 8 multiplies for the MAC operation
copy_counter:	ds 1 ;counter to copy from PM to RAM
runningSum:	ds 0x02 ;reserve 2 bytes in ram for the 16bit result of an 8 bit multiplication
tmpW:		ds 1 ;Temp storage for the multiplication

psect	udata_bank5 ;Reserves UNDEFINED data specifically in RAM bank 5
x_buffer:	ds buffer_l ;fifo Circular buffer 
coeffs:		ds buffer_l ;reserve bytes in ram
vectorX:	ds signal_l
vectorY:	ds signal_l

psect	data ;stores data in PM
vectorX_PM:
    db	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E
vectorY_PM:
    db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
coeffs_PM:
    db	0x01, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00
    align   2


psect	uart_code, class=CODE
initMAC:
    TBLPTR_POINT_TO coeffs_PM
    movlw   buffer_l	;
    movwf   copy_counter, A	; our counter register
    lfsr    0, coeffs ; Points FSR0 to the data space in RAM for the coefficients
    call    PMRAMCopy	; copies the coefficients onto RAM memory
    
    TBLPTR_POINT_TO vectorX_PM
    movlw   signal_l	;
    movwf   copy_counter, A	; our counter register
    lfsr    0, vectorX ; Points FSR0 to the data space in RAM for the vector
    call    PMRAMCopy	; copies the vectorX onto RAM memory
    
    clrf    buffer_address, A
    clrf    vectorY_address, A
    
    lfsr    2, vectorX ;Points FSR2 to vectorX to load in the new signals
    movlw   signal_l
    movwf   counter_signal ;Sets up the whole signal counter for the next function
    
    return
    
    
computationMAC:
    lfsr    0, x_buffer ;These lines point FSR0 to x_buffer[buffer_address]---------------
    movf    buffer_address, W, A
    addwf   FSR0L, F, A
    movlw   0x00
    addwfc  FSR0H, F, A ;Since addresses are 16bit, we add with carry into the high byte of the address, if there is overflow the pointer stays correct-----
    
    movf    POSTINC2, W, A ;Move new signal value to Working
    movwf   INDF0, A	;Write new signal onto circular buffer
    
    incf    buffer_address, F, A ;These lines update the buffer_address and do a MOD8 operation on it to ensure circularity---------
    movlw   buffer_mask
    andwf   buffer_address, F, A ;--------------------------------------------------------------------------------------------------
    
    call    MACOperation

    lfsr    0, vectorY ;Point FSR0 now to the correct position in vectorY------------------------------------------------------------------------
    movf    vectorY_address, W, A
    addwf   FSR0L, F, A
    movlw   0x00
    addwfc  FSR0H, F, A;-----------------------------------------------------------------------------------------------------------------------
    
    movf    runningSum, W, A ;FOR NOW ONLY STORING THE LOW BYTE OF THE MULTIPLICATION, MUST CHANGE TO BOTH BYTES AFTER
    movwf   INDF0, A
    incf    vectorY_address, F, A ;Advance y_index

    decfsz  counter_signal, A	; count down to zero
    bra	    computationMAC	; keep going until finished with all the signal
    
    return


MACOperation:
    clrf    runningSum, A ;Important to clear as when ram is initialised it will have random numbers
    clrf    runningSum+1, A
    
    lfsr    1, coeffs ;FSR0 loops through coefficients
    
    movlw   buffer_l ;Setup counter to help us loop through the 8 numbers in the buffer
    movwf   counter_MAC, A
    
    clrf    MAC_address, A ;Initialises the counter to loop through the buffer from OLDEST to NEWEST

    
MACLoop:
    ; THIS LOOP IS GOING TO GO FROM NEWEST TO OLDEST IN THE BUFFER
    movf    buffer_address, W, A ; Compute x_index = (buffer_address - 1 - MAC_address)MOD8
    addlw   0xFF         ;These lines essentially find an x_index 
    movwf   tmpW, A           
    movf    MAC_address, W, A
    subwf   tmpW, W, A  ;Safe subtraction      
    andlw   buffer_mask ;------------------------------------------------------------------------------------------------------------------------------------------------         
    
    lfsr    0, x_buffer ;Point FSR0 to the new calculated address above x_index--------------
    addwf   FSR0L, F, A
    movlw   0x00
    addwfc  FSR0H, F, A;------------------------------------------------------------------------------------------------------------------------------------------------         
    
    call    Multiply ;This will multiply FSR1 and FSR0 and store it in runningSum

    incf    MAC_address, F, A ;Advance MAC_address to loop through the buffer
    decfsz  counter_MAC, A ; count down to zero to exit loop when weve done 8 operations
    bra	    MACLoop	; keep going until finished
    
    return

    
PMRAMCopy:
    tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
    movff   TABLAT, POSTINC0 
    decfsz  copy_counter, A
    bra	    PMRAMCopy
    
    return
    
Multiply:
    movf    INDF0, W, A   ; Move buffer value to working
    mulwf   POSTINC1, A   ; Multiplies FSR1 with Working, coefficient with buffer value
    movf    PRODL, W, A ;Stores the result into runningSum
    addwf   runningSum, F, A
    movf    PRODH, W, A
    addwfc  runningSum+1, F, A
    
    return
