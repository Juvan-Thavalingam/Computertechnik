/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"
#include "reg_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed
#define OR_MASK 0xC0
#define AND_MASK 0xCF
#define BUTTONS_MASK 0x0F

#define BUTTON_0_M 0x01
#define BUTTON_1_M 0x02
#define BUTTON_2_M 0x04
#define BUTTON_3_M 0x08



/// END: To be programmed

int main(void)
{
   

    // add variables below
    /// STUDENTS: To be programmed

    /// END: To be programmed
	
		uint8_t switch_values = 0;
		uint8_t switch_last_state = read_byte(ADDR_BUTTONS) & 0x0F;
	
		uint8_t button1_counter = 0;
		uint8_t button1_push_events = 0;

		uint8_t buttons_changed = 0;
	
		uint8_t button_stash = 0;
	
	
	

    while (1) {
        // ---------- Task 3.1 ----------
     

			

        /// STUDENTS: To be programmed
				
				uint8_t result = read_byte(ADDR_DIP_SWITCH_7_0) | OR_MASK;
				result = result & AND_MASK;
			
		

        /// END: To be programmed

        write_byte(ADDR_LED_7_0, result);
			

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
			
				
				switch_values = read_byte(ADDR_BUTTONS) & BUTTONS_MASK;
			
				if ((switch_values & BUTTON_0_M) == 0x01) {
					button1_counter++;
				}
				write_byte(ADDR_LED_15_8, button1_counter);
				
				
				buttons_changed = (~switch_last_state & switch_values);
				
				if ((buttons_changed & BUTTON_0_M) == BUTTON_0_M) {
					button1_push_events++;
				}
				write_byte(ADDR_LED_31_24, button1_push_events);
				
				
				if ((buttons_changed & BUTTON_3_M) == BUTTON_3_M) {
					button_stash = read_byte(ADDR_DIP_SWITCH_7_0);
				}else if ((buttons_changed & BUTTON_2_M) == BUTTON_2_M) {
					button_stash = ~button_stash;
				} else if ((buttons_changed & BUTTON_1_M) == BUTTON_1_M) {
					button_stash <<= 1;
				} else if ((buttons_changed & BUTTON_0_M) == BUTTON_0_M) {
					button_stash >>= 1;
				}
				write_byte(ADDR_LED_23_16, button_stash);

				switch_last_state = switch_values;



        /// END: To be programmed
    }
}
