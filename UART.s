#include <xc.inc>
    
global  UART_Setup, UART_Transmit_Message, UART_counter ;Tells the compiler that it needs to help other files find here these are stored
extrn   Sinc_x_l_high, Sinc_x_l_low
    
psect	udata_acs   ; reserve data space in access ram
UART_counter: ds    2	    ; reserve 1 byte for variable UART_counter

psect	uart_code,class=CODE
UART_Setup:
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bcf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bcf	    BRG16	; 8-bit generator only
    movlw   103		; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RC6 pin
					; must set TRISC6 to 1
    return

UART_Transmit_Message:	    ; Message stored at FSR2, length stored in W
    movlw   Sinc_x_l_high
    movwf   UART_counter, A
    movlw   Sinc_x_l_low
    movwf   UART_counter+1, A
    
UART_Loop_message:
    tblrd*+
    movf    TABLAT, W, A
    call    UART_Transmit_Byte
    
    decfsz  UART_counter, F, A
    bra	    UART_Loop_message
    decfsz  UART_counter+1, F, A
    bra	    UART_Loop_message
    return

UART_Transmit_Byte:	    ; Transmits byte stored in W
    btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
    bra	    UART_Transmit_Byte
    movwf   TXREG1, A
    return


