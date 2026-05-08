; =========================================================
; Author         : Prithvi Snehal
; Student ID     : 11691120
; Microcontroller: PIC18F8722
; File Name      : blink_control.asm
; Project Type   : Timing and LED Blink Control
;
; Description:
; This project controls LED blinking using push buttons
; and timing delay subroutines. Different delay intervals
; are implemented using nested software delay loops.
; =========================================================

processor 18F8722
radix dec

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF
    
; Defines
#include <xc.inc>
    
PSECT udata_acs
global var_count_200us, var_count_40ms, var_count_400ms
var_count_200us: ds 1
var_count_40ms: ds 1
var_count_400ms:ds 1
    
; PSECTS should be unindented
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; Inline comments should be separated by 1 or 2 tabs.
; This is optional but helps with readability

; PSECTS should be unindented
PSECT start, class=CODE, reloc=2
; Labels again are unindented
start:
;Set all TRIS
    clrf TRISF, a ;To set for LEDS
    bcf TRISA, 4, a ;Set RA4 as output for Q3
    
    setf TRISB, a
    setf TRISJ, a
    
    btfss PORTJ, 5, a
	bra PB1_pressed
    btfsc PORTB, 0, a
	bra start
    movlw 00000001B
    movwf LATF, a
    bsf LATA, 4, a
    call sub_40ms
    movlw 00000000B
    movwf LATF, a
    bsf LATA, 4, a
    call sub_40ms
    
loop:
bra start
    
    ;Basic subroutines
sub_200us:
    movlw 71
    movwf var_count_200us, a
l_delay:
    nop
    nop
    nop
    nop
    decf var_count_200us, a
    bnz l_delay
    return
    
sub_40ms:
    movlw 199
    movwf var_count_40ms, a
innerloop_delay:
    call sub_200us
    decf var_count_40ms, a
    bnz innerloop_delay
    return

sub_400ms:
    movlw 9 
    movwf var_count_400ms, a
innerloop_delay_2:
    call sub_40ms
    decf var_count_400ms, a
    bnz innerloop_delay_2
    return
    
PB1_pressed:
    movlw 00000001B
    movwf LATF, a
    bsf LATA, 4, a
    call sub_400ms
    movlw 00000000B
    movwf LATF, a
    bsf LATA, 4, a
    call sub_400ms
    
    bra start
end
