/* ----------------------------------------------------------------------------
 * --  _____       ______  _____                                              -
 * -- |_   _|     |  ____|/ ____|                                             -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems              -
 * --   | | | '_ \|  __|  \___ \   Zurich University of                       -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                           -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland               -
 * ------------------------------------------------------------------------- */
/**
 *  \brief  CT Board periphery test.
 * 
 *  $Id$
 * ------------------------------------------------------------------------- */


/* Standard includes */
#include <stdint.h>

/* User includes */
#include "utils_ctboard.h"


/* -- Macros
 * ------------------------------------------------------------------------- */
 
#define DipSwitch0Bis7 		0x60000200 //read
#define DipSwitch8Bis15 	0x60000201
#define DipSwitch16Bis23 	0x60000202
#define DipSwitch24Bis31 	0x60000203

#define LED0Bis7 					0x60000100 //write
#define LED8Bis15 				0x60000101
#define LED16Bis23 				0x60000102
#define LED24Bis31 				0x60000103

#define P11RotarySwitch   0x60000211 //read
#define DSN0Display				0x60000110 //write

static const uint8_t rotaryAddress[16] = {
															0xC0, //11000000 (bei 0 leuchtet er, ausser . und g leuchtet alles!)
															0xF9,
															0xA4,
															0xB0,
															0x99,
															0x92,
															0x82,
															0xF8,
															0x80, 
															0x98, 
															0x88, 
															0x83, 
															0xC6, 
															0xA1, 
															0x86, 
															0x8E};

/* -- Local function declarations
 * ------------------------------------------------------------------------- */



/* -- M A I N --------------------------------------------------------------
 * ------------------------------------------------------------------------- */


int main(void)
{   
    while(1){
			//Aufgabe 4.2
			write_byte(LED0Bis7, read_byte(DipSwitch0Bis7));
			
			//Aufgabe 5.1
			write_byte(LED8Bis15, read_byte(DipSwitch8Bis15));
			write_byte(LED16Bis23, read_byte(DipSwitch16Bis23));
			write_byte(LED24Bis31, read_byte(DipSwitch24Bis31));
			
			//Aufgabe 6
			write_byte(DSN0Display, rotaryAddress[read_byte(P11RotarySwitch) & 0x0F]);
		}
}