; =========================================================
; Author        : Prithvi Snehal
; Student ID    : 11691120
; Microcontroller: PIC18F8722
; Project Type  : LED Counter with Push Button Control
; =========================================================


processor 18F8722    
radix dec
// Hardware Configuration of our PIC18F8722
CONFIG OSC=HS, FCMEN=OFF, IESO=OFF
CONFIG BORV=3
CONFIG WDT=OFF, WDTPS=1
CONFIG MODE=MC, ADDRBW=ADDR20BIT, DATABW=DATA16BIT, WAIT=OFF
CONFIG CCP2MX=PORTC, LPT1OSC=OFF, MCLRE=ON
CONFIG STVREN=ON, LVP=OFF, XINST=OFF
CONFIG CP0=OFF, CP1=OFF, CP2=OFF, CP3=OFF
CONFIG CPB=OFF, CPD=OFF
CONFIG WRT0=OFF, WRT0=OFF, WRT0=OFF, WRT0=OFF
CONFIG WRTC=OFF
CONFIG EBTR0=OFF, EBTR1=OFF, EBTR2=OFF, EBTR3=OFF
CONFIG EBTRB=OFF
// Defines
#include <xc.inc>
// Relocatable variables
PSECT udata_acs
global var_count_50ms, var_count_32ms, led, var_count_360ms ;assigning all the variables required to create the subroutine 
var_count_50ms: ds 1
var_count_32ms: ds 1
led: ds 1
var_count_360ms: ds 1
// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
 GOTO Start
PSECT Start, class=CODE, reloc=2
Start:
// setting all TRIS registers, for specific inputs and outputs
    clrf LATF, a
 
    clrf TRISF, a
 
    clrf TRISA, a
 
    setf TRISH, a
   
    movlw 00001111B
    movwf ADCON1, a
   
    setf TRISJ, a

L_Main:
    btfss PORTH, 7, a        ;testng switch 7 if set as 1 executes next instruction if it doesnt then doesnt execute 
    bra Start
    movlw 255            ;setting the number as 255
    movwf led, a

L_LED:
    movf led, W, a       ;displaying the number 255 on the seven segment and decreasing it value by 1 after each iteration 
    movwf LATF, a
    bsf LATA, 4, a        ;turning on the led 
    call sub_360ms        ;calling a delay of 360ms
    decf led, a
    bz over            ; if the branch is equalt to 0 display 0 on the keds 
    btfss PORTJ, 5, a
    bra freeze
    bra L_LED

freeze:
    btfsc PORTJ, 5, a    ;stopping the display when the push button 1 is pressed for a small time until it is released 
    bra L_LED
    bra freeze
   
over:
    clrf LATF, a    
    bra over

sub_600us:  ;creating a subroutine for 600us
    movlb 0x2
    movlw 186
    movwf 0x02, b
delay_sub:
    nop
    nop
    nop
    nop
    nop        
    decf 0x02, b    ; 186*3.2=595.2
    bnz delay_sub
    return

sub_50ms:    ;creating a subroutine for 50ms
    movlw 83
    movwf var_count_50ms, a
delay_sub_50ms:
    call sub_600us
    decf var_count_50ms, a
    bnz delay_sub_50ms
    return
   
sub_32ms:    ;creating a subroutine for 32ms
    movlw 60
    movwf var_count_32ms, a
delay_sub_32ms:
    call sub_600us
    decf var_count_32ms, a
    bnz delay_sub_32ms
    return
   
sub_360ms:        ;creating a subroutine for 360ms
    movlw 10
    movwf var_count_360ms, a
delay_360ms:
    call sub_32ms
    decf var_count_360ms, a
    bnz delay_360ms
    return

end
