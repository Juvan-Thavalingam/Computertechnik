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
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4
	
; student constant
ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

BITMASK_KEY_T0          EQU     0x01


; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed	
		
		;check T0 Button pressed
			BL 		adc_get_value
		
			LDR		R7, =ADDR_BUTTONS
			LDRB	R5,[R7]
			LDR 	R6, =BITMASK_KEY_T0
			ANDS	R5, R5, R6 ;get T0 only
		
			BNE pressed

else
			LDR		R7, =ADDR_DIP_SWITCH_7_0
			LDRB	R1, [R7]
			
			SUBS	R1, R1, R0
			LDR		R7, =ADDR_7_SEG_BIN_DS3_0
			STRH	R1, [R7] ;sevensegment
			
			BGE 	case_blue ; diff >= 0 : Z ==1 or N!=V
			B		case_red
			;B		main_loop
			
pressed			
			BL 		adc_get_value
			
			LDR		R7, =ADDR_7_SEG_BIN_DS3_0
			STRH	R0, [R7] ;sevensegment
			
			LSRS	R0, R0, #3 ;8 dividieren
			
			LDR		R6, =0xFFFFFFFF ;alle bits gesetzt
			LSLS	R6, R6, R0 ;linksshift um bits zu haben, die man setzten muss
		
			MVNS	R6, R6 ;invertieren
		
			LDR		R7, =ADDR_LED_31_0
			STR		R6, [R7]

			LDR 	R7, =LCD_BACKLIGHT_OFF
			LDR		R0, =ADDR_LCD_BLUE
			STRH	R7, [R0]
			
			LDR		R0, =ADDR_LCD_RED
			STRH	R7, [R0]
			
			LDR		R7, =LCD_BACKLIGHT_FULL
			LDR		R0, =ADDR_LCD_GREEN
			STRH	R7,[R0]
			
			B 		main_loop

case_blue		
			LDR 	R7, =LCD_BACKLIGHT_OFF
			LDR		R0, =ADDR_LCD_GREEN
			STRH	R7, [R0]
			
			LDR		R0, =ADDR_LCD_RED
			STRH	R7, [R0]
			
			LDR		R7, =LCD_BACKLIGHT_FULL
			LDR		R0, =ADDR_LCD_BLUE
			STRH	R7,[R0]
			
			MOV		R8, R1
			MOVS	R4, #4
			CMP		R8, R4
			BLT		bit_2 ;diff < 4
			
			MOVS	R4, #16
			CMP		R8, R4
			BLT		bit_4 ;diff < 16
			
			LDR 	R2, =DISPLAY_8_BIT ;;Display_8_BIT = 8
			B		write_bit	
		
			
write_bit_val	
			LDR R3, =ADDR_LCD_ASCII
			LDR R2,[R2] ; Bit value loaded by address, because it is 1 byte and with LDR we can not load 1 byte by label
			STRB R2,[R3]
			BL write_bit_ascii
			B main_loop
			
bit_2   	
			LDR 	R2, =DISPLAY_2_BIT ;;Display_4_BIT = 2
			B 		write_bit_val

bit_4   	
			LDR 	R2, =DISPLAY_4_BIT ;Display_4_BIT = 4
			B 		write_bit_val

write_bit
			LDR R3, =ADDR_LCD_ASCII
			LDR R2,[R2] ; Bit value loaded by address, because it is 1 byte and with LDR we can not load 1 byte by label
			STRB R2,[R3]
			BL write_bit_ascii
			B main_loop
			
case_red 		
			LDR 	R7, =LCD_BACKLIGHT_OFF
			LDR		R0, =ADDR_LCD_GREEN
			STRH	R7, [R0]
			
			LDR		R0, =ADDR_LCD_BLUE
			STRH	R7, [R0]
			
			LDR		R7, =LCD_BACKLIGHT_FULL
			LDR		R0, =ADDR_LCD_RED
			STRH	R7,[R0]
		
		
			MOVS 	R2,#0x0	
zero_loop 
			LSRS 	R1,#1
			BHS 	zero_loop ;wenn übertragungsbit nicht gesetzt!, 
			BEQ 	zero_show ;wenn r1 = 0
			ADDS 	R2,#1
			B 		zero_loop
zero_show	
			LDR 	R7, =ADDR_LCD_ASCII_2ND_LINE
			LDR 	R5, =ASCII_DIGIT_OFFSET
			ADD		R2, R5
			STRB 	R2, [R7]
			B  		main_loop

; END: To be programmed
        B          main_loop
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
