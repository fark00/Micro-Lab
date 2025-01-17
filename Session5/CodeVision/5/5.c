/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/14/2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <header.h>

// Declare your global variables here
int duty_cycle = 10;
int temp_counter = 1;
int rpm_counter = 0;
int direction = 1;               
int speed = 0;
char temp_str[17];
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    routin1();
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    // Reinitialize Timer2 value
    TCNT2=0xB2;
    // Place your code here
    routin2();

}

void main(void)
{
// Declare your local variables here


// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")
    init_ports();
    init_timer();
    while (1)
      {
      // Place your code here

      }
}
