; =========================================================
; Author         : Prithvi Snehal
; Student ID     : 11691120
; Microcontroller: PIC18F8722
; File Name      : blink_timing_control.asm
; Project Type   : LED Blink Timing Control
;
; Description:
; This project controls LED blinking speed using
; push-button inputs and software timing delays.
; Fast and slow blinking modes are implemented
; using nested delay subroutines.
; =========================================================
processor 18F8722
radix dec

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF
    
; Defines
#include <xc.inc>
    
PSECT udata_acs
global var_count_40ms, var_count_400ms
var_count_40ms: ds 1
var_count_400ms:ds 1

PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start 
    
PSECT start, class=CODE, reloc=2
start:
;Set all TRIS
    clrf TRISF, a ;To set for LEDS
    bcf TRISA, 4, a ;Set RA4 as output for Q3
    
    setf TRISB, a
    setf TRISJ, a
    
    movlw 00000001B
    movwf LATF, a
Loop_Main:
    btfss PORTJ, 5, a
    bra Loop_400ms
    
    btfsc PORTB, 0, a
    bra Loop_Main
    
    bsf LATA, 4, a
    call sub_40ms
    bcf LATA, 4, a
    call sub_40ms
    bra Loop_Main

Loop_400ms:
    bsf LATA, 4, a
    call sub_400ms
    bcf LATA, 4, a
    call sub_400ms
    bra Loop_Main

sub_196us: 
    movlb 0x4
    movlw 71
    movwf 0x00, b
delay_196us:
    nop 
    nop
    nop
    nop
    decf 0x00, b 
    bnz delay_196us
    return

sub_40ms:
    movlw 199
    movwf var_count_40ms, a
delay_40ms:
    call sub_196us
    decf var_count_40ms, a
    bnz delay_40ms
    return
    
sub_400ms:
    movlw 10
    movwf var_count_400ms, a
delay_400ms:
    call sub_40ms
    decf var_count_400ms, a
    bnz delay_400ms
    return

end
