; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
	
N_ELEMENTS					EQU 	16 ;halfword: 32
ELEMENT_SIZE				EQU		1

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

byte_array SPACE	N_ELEMENTS * ELEMENT_SIZE
			;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed
; while b=GO TO (notice)

; Register allecation in this lab
	; - R0 and up for values that are longer in use
	; - R7 and down for temp usage

	
	;Task 3.2
	; 1. read index from DS11-8, mask lower 4 bits, display (LED 15-8)
	; 	R1: index
	LDR 	R7, =ADDR_DIP_SWITCH_15_8
	LDRB 	R1,[R7] ;halfword: LDRH
	LDR 	R7, =BITMASK_LOWER_NIBBLE 
	ANDS 	R1, R1, R7
	LDR 	R7, =ADDR_LED_15_8
	STRB 	R1,[R7]
	
	; 2. read value from DS7-0, display (LED8-0)
	; 	R0: value
	LDR 	R7, =ADDR_DIP_SWITCH_7_0 
	LDRB 	R0,[R7]
	LDR 	R7, =ADDR_LED_7_0 
	STRB 	R0,[R7]
	
	;Task 3.3
	; 3. write value to array at index (byte_array[index] = value)
	;										R7		R1		R0
	LDR 	R7, =byte_array
	STRB 	R0,[R7, R1]
	
	;Task 3.4
	; 4. read value from DS27-24, mask lower 4 bits, display (LED27-24)
	LDR		R7, =ADDR_DIP_SWITCH_31_24
	LDRB	R0,[R7]
	LDR		R7,=BITMASK_LOWER_NIBBLE
	ANDS	R0, R0, R7
	LDR		R7,= ADDR_LED_31_24
	STRB	R0,[R7]
	
	;Task 3.5
	;5. read value from DS16-23, display (LED16-23)
	LDR		R7, =ADDR_LED_23_16
	STRB	R0, [R7]
	
	
	
; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
