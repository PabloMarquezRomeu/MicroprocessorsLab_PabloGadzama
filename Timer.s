#include <xc.inc>
#include "tblptr_macros.inc" 
    
extrn	UART_Transmit_Byte
global timer0_int_hi, startTimer, sendTimerUART, counter_timer
    
psect	udata_acs ;Reserves UNDEFINED data in access ram (start of ram)
counter_timer:	ds 1
    
psect	uart_code,class=CODE
timer0_int_hi:
    btfss   TMR0IF
    retfie  f ;CHeck its timer0 interrupt, if not return
    
    incf    counter_timer, A ;When overflow, increase overall counter timer. One count here means 65536x64(microseconds) = approx 4.19seconds
    
    bcf	    TMR0IF ;Resent interrupt flag
    ;Maybe I should write here to reset the timer to 0?
    retfie  f
    
startTimer:
    clrf    counter_timer, A
    movlw   10000111B ;16bit mode, Prescaler 1:256 with internal clock: Timer tick 16microseconds, 16 bit overflow means approx 1.05 seconds.
    movwf   T0CON, A
    bsf	    TMR0IE ;Enable timer0 interrupts
    bsf	    GIE	;Globally enable all interrupts
    return
    
sendTimerUART:
    ;movlw   00000111B ;16bit mode, Prescaler 1:256 with internal clock: Timer tick 64microseconds, 16 bit overflow means approx 4.19 seconds.
    ;movwf   T0CON, A
    movf    TMR0L, W, A
    call    UART_Transmit_Byte
    movf    TMR0H, W, A
    call    UART_Transmit_Byte
    movf    counter_timer, W, A
    call    UART_Transmit_Byte
    return
    ;MYCODE
    

