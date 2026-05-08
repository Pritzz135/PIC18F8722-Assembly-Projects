; =========================================================
; Author        : Prithvi Snehal
; Student ID    : 11691120
; Microcontroller: PIC18F8722
; Project Type  : Arithmetic and Input Processing System
; Description   : Reads input data from ports, performs
;                 arithmetic operations, and displays
;                 results on LEDs.
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
// Creating relocatable variables
PSECT udata_acs
global right, left
right: ds 1
left: ds 1
    
// Code
PSECT ResetVector, class=CODE, reloc=2
ResetVector:
 GOTO L_MainProgram

PSECT Start, class=CODE, reloc=2
// Starting point of the program
L_MainProgram:
    // Setting all TRIS values to either input or output according to each function needed
    ; setting RF0-7 as output
    clrf TRISF, a
    ; setting RH4-7 as input and RH0-1 as output
    movlw 11111111B
    movwf TRISH, a
    ; setting RH4-7 as digital input
    movlw 00001111B
    movwf ADCON1, a
    ; setting RB0-7 as input
    setf TRISB, a
    ; setting RC0-7 as input
    setf TRISC, a
    ; setting RA0-7 as output
    clrf TRISA, a
// Starting point of the main loop enabling simultaneous display
L_Loop:
    movf PORTC, W, a
    movwf right, a
    rrncf right, a
    rrncf right, W, a
    andlw 00001111B
    movwf right, a
    
    movf PORTH, W, a
    andlw 11110000B
    iorwf right, a
    
    btfss PORTB, 0, a
    bra rsub1
    bra radd1
    
rsub1:
    movlw 00010000B
    movwf LATA, a
    
    movlw 1
    subwf right, W, a
    
    movwf LATF, a
    
    clrf LATA, a
    
    bra L_Loop
    
radd1:
    movlw 00010000B
    movwf LATA, a
    
    movlw 1
    addwf right, W, a
    
    movwf LATF, a
    
    clrf LATA, a
    
    bra L_Loop
    
end
