;* ----------------------------------------------------------------------------
;* --  _____       ______  _____                                              -
;* -- |_   _|     |  ____|/ ____|                                             -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems              -
;* --   | | | '_ \|  __|  \___ \   Zurich University of                       -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                           -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland               -
;* ----------------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 12
;* -- Description : Reading the User-Button as Interrupt source
;* -- 				 
;* -- $Id: main.s 5082 2020-05-14 13:56:07Z akdi $
;* -- 		
;* ----------------------------------------------------------------------------


                IMPORT init_measurement
                IMPORT clear_IRQ_EXTI0
                IMPORT clear_IRQ_TIM2
				 

; -----------------------------------------------------------------------------
; -- Constants
; -----------------------------------------------------------------------------

                AREA myCode, CODE, READONLY

                THUMB

REG_GPIOA_IDR       EQU  0x40020010
LED_15_0            EQU  0x60000100
LED_16_31           EQU  0x60000102
REG_CT_7SEG         EQU  0x60000114
REG_SETENA0         EQU  0xe000e100


; -----------------------------------------------------------------------------
; -- Main
; -----------------------------------------------------------------------------             
main            PROC
                EXPORT main


                BL   init_measurement    

                ; Configure NVIC (enable interrupt channel)
                ; STUDENTS: To be programmed
				
				LDR	 r0, =REG_SETENA0
				;MOVS r1, #0x40 ; IRQ6 by 7. bit
				LDR r1, =0x10000040 ; IRQ28 by 29. bit & IRQ6 by 7. bit
				;0x0100 0000 = 0x40 cause 7. bit and 1 for 2s
				STR	 r1, [r0]
				
                ; END: To be programmed 

                ; Initialize variables
                ; STUDENTS: To be programmed	
				
				LDR	 r0, =irq28_buffer		; address
				MOVS r1, #0
				STR	 r1, [r0]

                ; END: To be programmed

loop
                ; Output counter on 7-seg
                ; STUDENTS: To be programmed
				
				;LDR	 r0, =irq6_counter		; address
				LDR	 r0, =irq28_buffer		; address
				LDR  r1, [r0]				; value
				LDR	 r0, =REG_CT_7SEG		; address
				STR	 r1, [r0]				; store

                ; END: To be programmed

                B    loop

                ENDP

; -----------------------------------------------------------------------------
; Handler for EXTI0 interrupt
; -----------------------------------------------------------------------------
                 ; STUDENTS: To be programmed
EXTI0_IRQHandler 	PROC
					EXPORT EXTI0_IRQHandler 
						
						PUSH {LR}	
					
						LDR	 r0, =irq6_counter		; address
						LDR  r1, [r0]				; value
						ADDS r1, #1		
						STR  r1, [r0]
					
						BL	 clear_IRQ_EXTI0				
				
						POP  {PC}
						
					
					ENDP

                 ; END: To be programmed

 
; -----------------------------------------------------------------------------                   
; Handler for TIM2 interrupt
; -----------------------------------------------------------------------------
                ; STUDENTS: To be programmed
TIM2_IRQHandler PROC
				EXPORT TIM2_IRQHandler
					
				PUSH {LR}	
					
				LDR	 r0, =LED_16_31			; address
				LDR  r1, [r0]				; value
				MVNS r1, r1					; invert value	
				STR	 r1, [r0]
				
				LDR	 r0, =irq6_counter		; address
				LDR  r1, [r0]				; value
				LDR	 r2, =irq28_buffer		; address
				STR	 r1, [r2]
				MOVS r1, #0
				STR  r1, [r0]
					
				BL	 clear_IRQ_TIM2				
				
				POP  {PC}
				BX   LR

				ENDP

                ; END: To be programmed
                ALIGN

; -----------------------------------------------------------------------------
; -- Variables
; -----------------------------------------------------------------------------

                AREA myVars, DATA, READWRITE

                ; STUDENTS: To be programmed
irq6_counter	DCD	0
irq28_buffer	DCD	0

                ; END: To be programmed


; -----------------------------------------------------------------------------
; -- End of file
; -----------------------------------------------------------------------------
                END
