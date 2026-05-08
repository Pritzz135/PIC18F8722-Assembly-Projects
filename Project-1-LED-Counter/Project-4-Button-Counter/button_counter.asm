; =========================================================
; Author         : Prithvi Snehal
; Student ID     : 11691120
; Microcontroller: PIC18F8722
; File Name      : button_counter.asm
; Project Type   : Push Button Counter System
;
; Description:
; This project implements a push-button controlled
; counter system using the PIC18F8722 microcontroller.
; The counter increments periodically and displays
; values on LEDs until stopped by user input.
; =========================================================
processor 18F8722
radix dec
    
// Hardware Configuration of our PIC18F8722
CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF
// Defines
#include <xc.inc>
 
PSECT udata_acs 
global var_count_100us, var_count_5ms, count
var_count_100us: ds 1
var_count_5ms: ds 1
count: ds 1

    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start

PSECT start, class=CODE, reloc=2
;Set all TRIS
start:
    
    clrf TRISF, a
    bcf TRISA, 4, a
    
    movlw 00000001B
    movwf TRISB, a
    
    movlw 00100000B
    movwf TRISJ, a
    
    movlw 0x0F
    movwf ADCON1, a
    
    clrf LATF, a
    
L_Main:
    
    movlw 00010000B
    movwf LATA, a
    btfss PORTB, 0, a
    goto pb_pressed
    bra L_Main
    
    pb_pressed:
    movlw 0
    movwf count, a
    movf count, W, a
    movwf LATF, a
    loop1:
    btfss PORTJ, 5, a
    goto pb1_pressed
    call sub_5ms
    incf count, a
    movf count, W, a
    movwf LATF, a
    bra loop1
    
    pb1_pressed:
    bra pb1_pressed
    
loop:
bra start
    
sub_100us:
    movlw 35
    movwf var_count_100us, a
l_delay:
    nop
    nop
    nop
    nop
    decf var_count_100us, a
    bnz l_delay
    return
    
sub_5ms:
    movlw 49
    movwf var_count_5ms, a
l_delay2:
    call sub_100us
    decf var_count_5ms, a
    bnz l_delay2
    return
    
    end
