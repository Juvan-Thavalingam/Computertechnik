; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

BITMASK_KEY_T0          EQU     0x01

TEN_IN_HEX				EQU		0xA
MASK_LOWER_BITS         EQU     0x0f
BITMASK_BUTTON			EQU		0x01
BITMASK_ZEROS           EQU     0x00000001

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed	
			LDR		R7,=ADDR_DIP_SWITCH_7_0
			LDRB	R1,[R7]
		
			LDR		R7,=ADDR_DIP_SWITCH_15_8
			LDRB	R2,[R7]	

			MOVS	R3, R2
			LSLS	R3, R3, #4
			ADDS	R3, R3, R1
			LDR 	R7, =ADDR_LED_15_0
			STRB	R3,[R7]
		
		
			;PUSH    {R4, R5, R6}
			;LDR     R5, =ADDR_BUTTONS           ; laod base address of keys
			;LDR     R6, =BITMASK_KEY_T0         ; load key mask T0
		
			;LDRB    R4, [R5]                    ; load key values
		
		;check T0 Button pressed
			LDR		R7, =ADDR_BUTTONS
			LDRB	R5,[R7]
			LDR 	R6, =BITMASK_KEY_T0
			ANDS	R5, R5, R6 ;get T0 only
		
			BNE pressed
else		
			MOVS	R6, #10
			MULS	R6, R2, R6
			ADDS	R2, R6, R1
			LDR		R7, =ADDR_LED_15_0
			STRB	R2,[R7, #1]
			
			;setColor
			LDR 	R7, =LCD_BACKLIGHT_OFF
			LDR		R0, =ADDR_LCD_RED
			STRH	R7, [R0]
			LDR		R3, =LCD_BACKLIGHT_FULL
			LDR		R4, =ADDR_LCD_BLUE
			STRH	R3,[R4]
			B		endif

pressed		
			MOVS	R0, R2
			LSLS	R2, R2, #0
			ADDS	R0, R0, R2
			LSLS	R2,	R2, #3
			ADDS	R0, R0, R2
			ADDS	R0, R0, R1
		
			LDR 	R7, =ADDR_LED_15_0
			STRB	R0,[R7, #1]
			
			
			LDR 	R7, =LCD_BACKLIGHT_OFF
			LDR		R0, =ADDR_LCD_BLUE
			STRH	R7, [R0]
			LDR		R3, =LCD_BACKLIGHT_FULL
			LDR		R4, =ADDR_LCD_RED
			STRH	R3,[R4]
			
endif		
			


disco_lights
		; R0 = Total number of '1' bits in LED 8-15:
		MOVS    R0, #0                       ; R0 = Number of '1' bits in LEDS (= 0)
		LDR     R2, =ADDR_LED_15_0           ; R2 = address of LED 0-15
		LDRB    R2, [R2]                     ; R2 = value of LEDS 0-15
		LDR     R3, =BITMASK_ZEROS           ; R3 = address of bitmask lowest bit
		; FOR(R1 = 0; R1 < 8; R1 = R1 + 1):
		MOVS    R1, #0                          ; FOR-LOOP: init expression
		B       disco_lights_count_for_loop_condition
disco_lights_count_for_loop
		MOVS    R5, R3
		ANDS	R5, R2                          ; R5 = Masked value of R2 with bitmask from R3 (logical AND)
		CMP     R5, R3                          ; IF: Compare R4 with R5 and set flags
		BEQ    	disco_lights_count_increment_r0       ; THEN: jump to disco_lights_increment_r0
        B       disco_lights_count_right_shift_r2     ; ELSE: jump to disco_lights_right_shift_r2
 
disco_lights_count_increment_r0
		LSLS    R0, R0, #1                      ; Shift bits in R0 one position to the left 
		ADDS    R0, R0, #1                      ; Add 1 (= set last bit of R0 to 1)
 
disco_lights_count_right_shift_r2
        LSRS    R2, #1
		; FOR-LOOP: update expression
		ADDS    R1, #1
 
disco_lights_count_for_loop_condition
		CMP     R1, #8                          ; FOR-LOOP: test expression (= condition)
		BLT     disco_lights_count_for_loop
		; Write total number of '1' bits to LED 16-23
		LDR     R2, =ADDR_LED_31_16             ; R2 = address of LED 16-31
		STRB    R0, [R2]                        ; Write R0 to LED 16-31
 
		; FOR(R1 = 0; R1 < 16; R1 = R1 + 1):
		MOVS    R1, #0                          ; FOR-LOOP: init expression
		B       disco_lights_animate_for_loop_condition
disco_lights_animate_for_loop
		BL      pause                 ; Pause a bit to see the animation
		LDRH    R3, [R2]              ; R3 = write values of LED 16-31 to lower half word
		LSLS    R3, R3, #16           ; Shift left R3 one half word
		LDRH    R4, [R2]              ; R4 = write values of LED 16-31 to lower half word
		ORRS    R3, R3, R4            ; R3 = Set lower half word values to R4, effectively duplicating LED values (making them 32 bit)
		MOVS    R4, #1                ; R4 = n bits for rotation
		RORS    R3, R3, R4            ; Rotate values in R3 n-bits to the right
		STRH    R3, [R2]              ; Write lower half word to LED 16-31
		; FOR-LOOP: update expression
		ADDS    R1, #1
 
disco_lights_animate_for_loop_condition
		CMP     R1, #16                         ; FOR-LOOP: test expression (= condition)
		BLT     disco_lights_animate_for_loop
			

; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------
		
;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
