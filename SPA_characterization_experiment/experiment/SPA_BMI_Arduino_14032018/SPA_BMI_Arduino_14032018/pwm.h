
/*

 *       APM_RC_APM2.cpp - Radio Control Library for Ardupilot Mega 2.0. Arduino

 *       Code by Jordi Muñoz and Jose Julio. DIYDrones.com

 *

 *       This library is free software; you can redistribute it and/or

 *   modify it under the terms of the GNU Lesser General Public

 *   License as published by the Free Software Foundation; either

 *   version 2.1 of the License, or (at your option) any later version.

 *

 *       RC Input : PPM signal on IC4 pin

 *       RC Output : 11 Servo outputs (standard 20ms frame)

 *

 *       Methods:

 *               Init() : Initialization of interrupts an Timers

 *               OutpuCh(ch,pwm) : Output value to servos (range : 900-2100us) ch=0..10

 *               InputCh(ch) : Read a channel input value.  ch=0..7

 *               GetState() : Returns the state of the input. 1 => New radio frame to process

 *                            Automatically resets when we call InputCh to read channels

 *

 */


//Out1=pin12
//Out2=pin11
//Out3=pin8
//Out4=pin7
//Out5=pin6
//Out6=pin3
//Out7=pin2
//Out8=pin5



#include <avr/interrupt.h>

#include "Arduino.h"







#define NUM_CHANNELS 16

#define MIN_PULSEWIDTH 10

#define MAX_PULSEWIDTH 65000

#define MIN_FREQ  0
#define MAX_FREQ  200

int pwmDutyCycleArr[16]={50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50};
float  pwmFrequencyArr[16]= {20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20};


// Variable definition for Input Capture interrupt

volatile uint16_t _PWM_RAW[NUM_CHANNELS] = {2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400};

volatile unsigned char _radio_status=0;

void Xfer(char ,int ch, int dutycycle, int frequency);
void Xfer(char query,int ch);
void enable_out(int ch);

// Constructors ////////////////////////////////////////////////////////////////





// Public Methods //////////////////////////////////////////////////////////////

void pwm_init()

{

   // --------------------- TIMER0: INPUT1 and INPUT2 -----------------------
 pinMode(13,INPUT); // OUT1 (PB7/OC0A)
   
    
    
    
    // --------------------- TIMER1: OUT1 and OUT2 -----------------------

    digitalWrite(12,HIGH);  // pulling high before changing to output avoids a momentary drop of the pin to low because the ESCs have a pull-down resistor it seems

    digitalWrite(11,HIGH);

    pinMode(12,OUTPUT); // OUT1 (PB6/OC1B)

    pinMode(11,OUTPUT); // OUT2 (PB5/OC1A)

    digitalWrite(12,HIGH);  // pulling high before changing to output avoids a momentary drop of the pin to low because the ESCs have a pull-down resistor it seems

    digitalWrite(11,HIGH);



    // WGM: 1 1 1 0. Clear Timer on Compare, TOP is ICR1.

    // CS11,CS10: prescale by 64 => 4us tick

    TCCR1A =((1<<WGM11));
    TCCR1B = (1<<WGM13)|(1<<WGM12)|(1<<CS11)|(1<<CS10);

    ICR1 = 1000000/(4*20); // 4us tick => 20hz freq

    OCR1A = 0xFFFF; // Init OCR registers to nil output signal

    OCR1B = 0xFFFF;



    // --------------- TIMER4: OUT3, OUT4, and OUT5 ---------------------

    digitalWrite(8,HIGH);

    digitalWrite(7,HIGH);

    digitalWrite(6,HIGH);

    pinMode(8,OUTPUT); // OUT3 (PH5/OC4C)

    pinMode(7,OUTPUT); // OUT4 (PH4/OC4B)

    pinMode(6,OUTPUT); // OUT5 (PH3/OC4A)

    digitalWrite(8,HIGH);

    digitalWrite(7,HIGH);

    digitalWrite(6,HIGH);



    // WGM: 1 1 1 0. Clear Timer on Compare, TOP is ICR4.

    // CS41,CS40: prescale by 64 => 4us tick

    TCCR4A =((1<<WGM41));

    TCCR4B = (1<<WGM43)|(1<<WGM42)|(1<<CS41)|(1<<CS40);

    OCR4A = 0xFFFF; // Init OCR registers to nil output signal

    OCR4B = 0xFFFF;

    OCR4C = 0xFFFF;

    ICR4 = 1000000/(4*20); // 4us tick => 20hz freq



    //--------------- TIMER3: OUT6, OUT7, and OUT8 ----------------------

    digitalWrite(3,HIGH);

    digitalWrite(2,HIGH);

    digitalWrite(5,HIGH);

    pinMode(3,OUTPUT); // OUT6 (PE5/OC3C)

    pinMode(2,OUTPUT); // OUT7 (PE4/OC3B)

    pinMode(5,OUTPUT); // OUT8 (PE3/OC3A)

    digitalWrite(3,HIGH);

    digitalWrite(2,HIGH);

    digitalWrite(5,HIGH);




    // WGM: 1 1 1 0. Clear timer on Compare, TOP is ICR3

    // CS31,CS30: prescale by 64 => 4us tick

    TCCR3A =((1<<WGM31));

    TCCR3B = (1<<WGM33)|(1<<WGM32)|(1<<CS31)|(1<<CS30);

    OCR3A = 0xFFFF; // Init OCR registers to nil output signal

    OCR3B = 0xFFFF;

    OCR3C = 0xFFFF;

    ICR3 = 1000000/(4*20); // 4us tick => 20hz freq



    //--------------- TIMER5: PPM INPUT, OUT10, and OUT11 ---------------

    // Init PPM input on Timer 5

  /*
    digitalWrite(45,HIGH);

    digitalWrite(44,HIGH);

    pinMode(45, OUTPUT); // OUT10 (PL4/OC5B)

    pinMode(44, OUTPUT); // OUT11 (PL5/OC5C)

    digitalWrite(45,HIGH);

    digitalWrite(44,HIGH);



    // WGM: 1 1 1 1. Fast PWM, TOP is OCR5A®

    // COM all disabled.

    // CS51,CS50: prescale by 64 => 4us tick

    // ICES5: Input Capture on rising edge

    TCCR5A =((1<<WGM50)|(1<<WGM51));

    // Input Capture rising edge

    TCCR5B = ((1<<WGM53)|(1<<WGM52)|(1<<CS51)|(1<<CS50)|(1<<ICES5));

    OCR5A = 1000000/(4*20); // 4us tick => 20hz freq. The input capture routine

                   // assumes this 40000 for TOP.



    // Enable Input Capture interrupt

    TIMSK5 |= (1<<ICIE5);

   */

   

}



void writeMotorCommand(int ch, int dutyCycle, int frequency)

{   uint16_t pwm=dutyCycle/(100*frequency*8E-6);
      pwmDutyCycleArr[ch]=dutyCycle;
      
    frequency=constrain(frequency,MIN_FREQ,MAX_FREQ);
      pwmFrequencyArr[ch]=frequency;
    pwm=constrain(pwm,MIN_PULSEWIDTH,MAX_PULSEWIDTH);
   // Serial.println(pwm);
    pwm<<=1; // pwm*2;
   if (ch<8)
   {enable_out(ch);} //Harshal:Enable output just before giving command to motors to increase security

   switch(ch)

    {

    case 0:  OCR1B=pwm; ICR1 =1000000/(4*frequency); break;  // out1
    
    case 1:  OCR1A=pwm; ICR1 =1000000/(4*frequency); break;  // out2

    case 2:  OCR4C=pwm; ICR4 = 1000000/(4*frequency); break;  // out3

    case 3:  OCR4B=pwm; ICR4 = 1000000/(4*frequency); break;  // out4

    case 4:  OCR4A=pwm; ICR4 = 1000000/(4*frequency); break;  // out5

    case 5:  OCR3C=pwm; ICR3 = 1000000/(4*frequency); break;  // out6

    case 6:  OCR3B=pwm; ICR3 = 1000000/(4*frequency); break;  // out7

    case 7:  OCR3A=pwm; ICR3 = 1000000/(4*frequency);  break;  // out8

    case 8:   Xfer('R',8,dutyCycle,frequency);  break;  // out8

    case 9:   Xfer('R',9,dutyCycle,frequency);  break;  // out9

    case 10:   Xfer('R',10,dutyCycle,frequency);  break;  // out10

    case 11:   Xfer('R',11,dutyCycle,frequency);  break;  // out11

    case 12:   Xfer('R',12,dutyCycle,frequency);  break;  // out12

    case 13:   Xfer('R',13,dutyCycle,frequency); break;  // out13

    case 14:   Xfer('R',14,dutyCycle,frequency);  break;  // out14

    case 15:   Xfer('R',15,dutyCycle,frequency);  break;  // out15

 

    }

}



uint16_t currentMotorCommand(int ch)

{

    uint16_t pwm=0;

    switch(ch) {

    case 0:  pwm=OCR1B; break;      // out1

    case 1:  pwm=OCR1A; break;      // out2

    case 2:  pwm=OCR4C; break;      // out3

    case 3:  pwm=OCR4B; break;      // out4

    case 4:  pwm=OCR4A; break;      // out5

    case 5:  pwm=OCR3C; break;      // out6

    case 6:  pwm=OCR3B; break;      // out7

    case 7:  pwm=OCR3A; break;      // out8

    }

    return pwm>>1;

}



void enable_out(int ch)

{

    switch(ch) {

    case 0: TCCR1A |= (1<<COM1B1); break; // CH_1 : OC1B

    case 1: TCCR1A |= (1<<COM1A1); break; // CH_2 : OC1A

    case 2: TCCR4A |= (1<<COM4C1); break; // CH_3 : OC4C

    case 3: TCCR4A |= (1<<COM4B1); break; // CH_4 : OC4B

    case 4: TCCR4A |= (1<<COM4A1); break; // CH_5 : OC4A

    case 5: TCCR3A |= (1<<COM3C1); break; // CH_6 : OC3C

    case 6: TCCR3A |= (1<<COM3B1); break; // CH_7 : OC3B

    case 7: TCCR3A |= (1<<COM3A1); break; // CH_8 : OC3A

    case 8:   Xfer('E',8);  break;  // out8

    case 9:   Xfer('E',9);  break;  // out9

    case 10:   Xfer('E',10);  break;  // out10

    case 11:   Xfer('E',11);  break;  // out11

    case 12:   Xfer('E',12);  break;  // out12

    case 13:   Xfer('E',13);  break;  // out13

    case 14:   Xfer('E',14);  break;  // out14

    case 15:   Xfer('E',15);  break;  // out15  

    }

}



void disable_out(int ch)

{

    switch(ch) {

    case 0: TCCR1A &= ~(1<<COM1B1); break; // CH_1 : OC1B

    case 1: TCCR1A &= ~(1<<COM1A1); break; // CH_2 : OC1A

   case 2: TCCR4A &= ~(1<<COM4C1); break; // CH_3 : OC4C

   case 3: TCCR4A &= ~(1<<COM4B1); break; // CH_4 : OC4B

    case 4: TCCR4A &= ~(1<<COM4A1); break; // CH_5 : OC4A

    case 5: TCCR3A &= ~(1<<COM3C1); break; // CH_6 : OC3C

    case 6: TCCR3A &= ~(1<<COM3B1); break; // CH_7 : OC3B

    case 7: TCCR3A &= ~(1<<COM3A1); break; // CH_8 : OC3A

    case 8:   Xfer('D',8);  break;  // out8

    case 9:   Xfer('D',9);  break;  // out9

    case 10:   Xfer('D',10);  break;  // out10

    case 11:   Xfer('D',11);  break;  // out11

    case 12:   Xfer('D',12);  break;  // out12

    case 13:   Xfer('D',13);  break;  // out13

    case 14:   Xfer('D',14);  break;  // out14

    case 15:   Xfer('D',15);  break;  // out15  
    }

}


void Xfer(char query,int ch, int dutycycle, int frequency)
{
  Wire.beginTransmission(8); // transmit to device #8
  Wire.write(query);    //start of channel
  Wire.write(ch-8);        // possible values 8-15 
  Wire.write(dutycycle); // sends one byte: 0-255, possible values 0:1:100
  Wire.write(frequency); // sends one byte: 0-255, possible values 0:1:255
  Wire.endTransmission();    // stop transmitting 
}  

void Xfer(char query,int ch)
{
  Wire.beginTransmission(8); // transmit to device #8
  Wire.write(query);    //start of channel
  Wire.write(ch-8);        // possible values 8-15 
  Wire.endTransmission();    // stop transmitting 
}  




