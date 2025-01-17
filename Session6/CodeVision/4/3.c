/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/24/2021
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
#include <headers.h>


// Declare your global variables here
long int data,help_data=0;
int i=0; 
float mat=0;
float pat=0;
float myocr,duty_cycle=0;
//char* stringdata=" "; 
char stringdata[8]; 
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
unsigned int predata[8] = {0};
unsigned int read_adc(unsigned char adc_input)
{
int j = 0;
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
j = 0;
while(j < 1000)
    j++;
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

    data = read_adc(0);
    duty_cycle = ((data*90)/1024) + 5;
    myocr = (2.55 * duty_cycle) + 0.5;
    OCR0 = floor(myocr);
}  

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
    int j = 0 , k = 0;
    static unsigned char input_index=0;  
    float more,less= 0;
    data,help_data = 0;
    pat,mat = 0;  
    lcd_clear();
    // Read the AD conversion result
    adc_data[input_index]=ADCW;
    // Select next ADC input   
    if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
       input_index=0;
    ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
    // Delay needed for the stabilization of the ADC input voltage
    j = 0;
    while(j<1000)
        j++;
    //************************************  
    data = adc_data[i];
    help_data = data;
    pat = ((data * 5)/100);
    more = data + pat;
    less = data - pat;  
    if (more < predata[i] || less > predata[i]){
        lcd_clear();  
        predata[i] = help_data;
        lcd_gotoxy(0,0);
        lcd_puts("Q2 started!");
        mat = ((data * 5)/1023)*1000;
        data = floor(mat);
        sprintf(stringdata,"ADC(%d): %dmv",i,data);
        lcd_gotoxy(0,1);
        lcd_puts("                            ");
        lcd_gotoxy(0,1);       
        lcd_puts(stringdata);
        while(j < 10000){
            j++;
            k = 0;
            while(k<90)
                k++;
        }
    }   
    i++;
    if (i > 7){
     i = 0;
     }
    
    //***********************************
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
}
// Read the AD conversion result

void main(void)
{
// Declare your local variables here




// Global enable interrupts
//#asm("sei")

    init_board();
    timer_q3();
    adc_q3();
    question3();
    question1(); 
    adc_q2();  
    question2();
while (1)
      {
      // Place your code here
      }
}
