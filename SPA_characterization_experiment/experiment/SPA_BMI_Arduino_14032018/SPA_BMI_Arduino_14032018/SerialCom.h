//#include <SD.h>

/*
  AeroQuad v3.0.1 - February 2012
  www.AeroQuad.com
  Copyright (c) 2012 Ted Carancho.  All rights reserved.
  An Open Source Arduino based multicopter.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

// SerialCom.pde is responsible for the serial communication for commands and telemetry from the AeroQuad
// This comtains readSerialCommand() which listens for a serial command and it's arguments
// This also contains readSerialTelemetry() which listens for a telemetry request and responds with the requested data
// For more information on each command/telemetry look at: http://aeroquad.com/content.php?117

// Includes re-write / fixes from Aadamson and ala42, special thanks to those guys!
// http://aeroquad.com/showthread.php?1461-We-have-some-hidden-warnings&p=14618&viewfull=1#post14618

#ifndef _AQ_SERIAL_COMM_
#define _AQ_SERIAL_COMM_
/**
 * Serial communication global declaration
 */
#define SERIAL_PORT Serial 
#define SERIAL_PRINT      SERIAL_PORT.print
#define SERIAL_PRINTLN    SERIAL_PORT.println
#define SERIAL_AVAILABLE  SERIAL_PORT.available
#define SERIAL_READ       SERIAL_PORT.read
#define SERIAL_FLUSH      SERIAL_PORT.flush
#define SERIAL_BEGIN      SERIAL_PORT.begin
 
//HardwareSerial *binaryPort;

void readSerialCommand();
void sendSerialTelemetry();
void printInt(int data);
void PrintValueComma(float val);
float readFloatSerial();
long readIntegerSerial();
void sendBinaryFloat(float);
void sendBinaryuslong(unsigned long);
void fastTelemetry();
void comma();
void reportVehicleState();
//////////////////////////////////////////////////////
void serialAdd(int data);
void serialPrint();
String package="";

char queryType = 'X';
int Serial_Available_Count=0;//to keep count of amount of data sent in a go.
int    pwmChannel=0, pwmDutyCycle=50;
float  pwmFrequency=20;
int delayWave=100;     

//vibrotactile feedback for finger sensation
int Finger[5]={0,0,0,0,0}  ; 
#define INDEX 0
#define MIDDLE 1
#define THUMB 2

//PID variables from user
float PIDsetp=0, PIDfreq=10;


///////////////////////////
int pattern=0, delayMs=100, timeMs=0, pixel=-1;









void initCommunication() {
  // do nothing here for now
}

void serialAdd(int data)
{
package += String(data,DEC);
package += ",";
//Serial.print(package);
} 

void serialPrint()
{
 Serial.println(package);
 package="";
}

//***************************************************************************************************
//********************************** Serial Commands ************************************************
//***************************************************************************************************
void readValueSerial(char *data, byte size) {
  byte index = 0;
  byte timeout = 0;
  data[0] = '\0';

  do{
  
    data[index] = SERIAL_READ();
    timeout = 0;
    Serial_Available_Count--;
    index++;
    if(data[index-1]==';')
    break;
  } while ((Serial_Available_Count>0) && (index < size-1));
  //Old version with tock Aeroquad cannot work with 115200 baud in wireless telemetry
  /*do {
    if (SERIAL_AVAILABLE() == 0) {
      delay(1);
      timeout++;
    } else {
      data[index] = SERIAL_READ();
      timeout = 0;
      index++;
    }
  } while ((index == 0 || data[index-1] != ';') && (timeout < 10) && (index < size-1));*/

  data[index] = '\0';
//Stricly for debug purposes donot uncomment
   // Serial.print("Serial Read Data:");
   // Serial.println(data);
}


// Used to read floating point values from the serial port
float readFloatSerial() {
  char data[15] = "";

  readValueSerial(data, sizeof(data));
   // Serial.print("Float Value of Data:");
   // Serial.println(atof(data));
  return atof(data);
}

// Used to read integer values from the serial port
long readIntegerSerial() {
  char data[16] = "";

  readValueSerial(data, sizeof(data));
  return atol(data);
}

void comma() {
  SERIAL_PRINT(',');
}




void skipSerialValues(byte number) {
  for(byte i=0; i<number; i++) {
    readFloatSerial();
  }
}

void readSerialCommand() {
  // Check for serial message
  Serial_Available_Count=0;
  if (Serial_Available_Count=SERIAL_AVAILABLE()) {
    queryType = SERIAL_READ();
    Serial_Available_Count--;// Harshal:- Serial count is reduced by 1 every single time new data is read
   // Strictly for debug purposes do not uncomment
    //Serial.print("True :");
   // Serial.print(queryType);
   // Serial.print(", Serial.available=");
   // Serial.println(Serial_Available_Count+1);
       
    switch (queryType) {
    case 'A':     
     pwmChannel=readIntegerSerial();
     pwmDutyCycle=readIntegerSerial();
     pwmFrequency = readFloatSerial();
     pwmDutyCycle=constrain(pwmDutyCycle,0,100);
     pwmChannel=constrain(pwmChannel,0,NUM_CHANNELS);
     PrintValueComma(pwmChannel);
     PrintValueComma(pwmDutyCycle);
     SERIAL_PRINTLN(pwmFrequency);
     writeMotorCommand(pwmChannel,pwmDutyCycle,pwmFrequency) ;
     break;

    case 'B': // Pattern
    
      pattern=readIntegerSerial();
      pwmFrequency = readFloatSerial();
      delayMs=readIntegerSerial();
      pwmDutyCycle=50;      
      
      SERIAL_PRINTLN('B');
      break;

    case 'C': // Traveling wave
      pwmDutyCycle=readIntegerSerial();
      pwmFrequency = readFloatSerial();
     // delayWave=readIntegerSerial();
      
      for(byte k=0;k<30;k++)
      {
       for(byte i=0;i<4;i++)
         {  for(byte j=0;j<9;j++)
             if(i!=j)
             writeMotorCommand(j,100,pwmFrequency) ;
             else
             writeMotorCommand(i,pwmDutyCycle,pwmFrequency) ;
            delay(130);//50-100
         }  
       delay(500);  
    }
 /*   for(byte k=0;k<30;k++)
      {
       for(byte i=4;i>=0;i++)
         {  for(byte j=8;j>=0;j--)
             if(i!=j)
             writeMotorCommand(j,100,pwmFrequency) ;
             else
             writeMotorCommand(i,pwmDutyCycle,pwmFrequency) ;
            delay(130);//50-100
         }  
       delay(500);  
    } */
     delay(500);     
     SERIAL_PRINTLN('C');
      break;
    case 'D': // Altitude hold PID
        
      pwmDutyCycle=readIntegerSerial();
      pwmDutyCycle=readIntegerSerial();
      pwmFrequency = readFloatSerial();
      for(pwmChannel=0;pwmChannel<8;pwmChannel++)
      writeMotorCommand(pwmChannel,pwmDutyCycle,pwmFrequency) ;
     
   SERIAL_PRINTLN('D');
       break;
       
       case 'V': // Altitude hold PID
        
      Finger[INDEX] =readIntegerSerial();
      Finger[MIDDLE] =readIntegerSerial();
      Finger[THUMB] =readIntegerSerial();
      /*if(Finger[INDEX]==1)
      writeMotorCommand(INDEX,50,25) ;
      else
      writeMotorCommand(INDEX,100,25) ; 
      if(Finger[MIDDLE]==1)
      writeMotorCommand(MIDDLE,50,25) ;
      else
      writeMotorCommand(MIDDLE,100,25) ; 
      if(Finger[THUMB]==1)
      writeMotorCommand(THUMB,50,25) ;
      else
      writeMotorCommand(THUMB,100,25) ; 
      */
      if(Finger[INDEX]==1)
      enable_out(0);
      else
      disable_out(0);
      if(Finger[MIDDLE]==1)
      enable_out(1);
      else
      disable_out(1);
      if(Finger[THUMB]==1)
      enable_out(2);
      else
      disable_out(2);
      
    /*Serial.print(Finger[INDEX]);
    Serial.print(" ,");
    Serial.print(Finger[MIDDLE]);
    Serial.print(" ,");
    Serial.print(Finger[THUMB]);
    Serial.print(" ,"); */
   SERIAL_PRINTLN('V');
       break;
       
   case 'S': // Stop all commands
    for(pwmChannel=0;pwmChannel<16;pwmChannel++)
    disable_out(pwmChannel) ;
         SERIAL_PRINTLN('S');
       break;


      case 'R': // Stop all commands
      pattern=readIntegerSerial();
      pixel = readIntegerSerial();
      pwmFrequency = readFloatSerial();
      pwmDutyCycle=readIntegerSerial();
      delayMs=readIntegerSerial();
      
     pwmDutyCycle=constrain(pwmDutyCycle,0,100);
     pwmChannel=constrain(pwmChannel,0,NUM_CHANNELS);
     pixel = constrain(pixel,-1,16);
    


      writeMotorCommand(pixel, pwmDutyCycle, pwmFrequency);
      enable_out(pixel);
      SERIAL_PRINTLN('R');
    
      
      break;

   case 'P': // Stop all commands
      float tic= micros();
      pattern=readIntegerSerial();
      pixel = readIntegerSerial();
      pwmFrequency = readFloatSerial();
      pwmDutyCycle=readIntegerSerial();
      delayMs=readIntegerSerial();
      
     pwmDutyCycle=50;//constrain(pwmDutyCycle,0,100);
     pwmChannel=constrain(pwmChannel,0,NUM_CHANNELS);
     pwmFrequency=constrain(pwmFrequency,6,100);
     pixel = constrain(pixel,-1,16);
    
     for (int i = 0; i < 8; i++)
      { writeMotorCommand(i, pwmDutyCycle, pwmFrequency);
        disable_out(i);}


      
      if(pixel!=-1)
         enable_out(pixel);
      else
      {
        for (int i = 0; i < 16; i++)
        { writeMotorCommand(i, pwmDutyCycle, pwmFrequency);
          disable_out(i);}
      }
      //SERIAL_PRINTLN('P');
      SERIAL_PRINTLN( ((micros() -  tic)/1000));

      
      
      break;



   
       
       
      
  }
  }
} 

//***************************************************************************************************
//********************************* Serial Telemetry ************************************************
//***************************************************************************************************

void PrintValueComma(float val) {
  SERIAL_PRINT(val,4);
  comma();
}

void PrintValueComma(double val) {
  SERIAL_PRINT(val);
  comma();
}

void PrintValueComma(char val) {
  SERIAL_PRINT(val);
  comma();
}

void PrintValueComma(int val) {
  SERIAL_PRINT(val);
  comma();
}

void PrintValueComma(unsigned long val)
{
  SERIAL_PRINT(val);
  comma();
}

void PrintValueComma(byte val)
{
  SERIAL_PRINT(val);
  comma();
}

void PrintValueComma(long int val)
{
  SERIAL_PRINT(val);
  comma();
}


void PrintDummyValues(byte number) {
  for(byte i=0; i<number; i++) {
    PrintValueComma(0);
  }
}


float sens[3]={0,0,0};
long lon=0;
void sendSerialTelemetry() {
 switch (queryType) {
  case '=': // Reserved debug command to view any variable from Serial Monitor
    break;

  case 'a': // Send roll and pitch rate mode PID values
    //PrintValueComma('a');
    
  sens[0]=analogRead(A0);//*5/1023 -2.5 ;
  sens[0]=(sens[0]/1024)*5-2.5;
  sens[1]=analogRead(A1);//*5/1023 -2.5 ;
  sens[1]=(sens[1]/1024)*5-2.5;
  sens[2]=analogRead(A2);//*5/1023 -2.5 ;
  sens[2]=(sens[2]/1024)*5-2.5;
  for(int i=0; i<=2;i++){
  Serial.print(sens[i]);
  Serial.print(", ");
  }
//  SERIAL_PRINTLN(); 

    //queryType = 'X';
    break;

  case 'b': // Send roll and pitch attitude mode PID values
    
    SERIAL_PRINTLN('b');
    queryType = 'X';
    break;

  case 'c': 
  
    SERIAL_PRINTLN('c');
    queryType = 'X';
    break;

  case 'd': // Altitude Hold
    SERIAL_PRINTLN('d');
    queryType = 'X';
    break;

  case 'e': // miscellaneous config values
    SERIAL_PRINTLN('e');
    queryType = 'X';
    break;

  case 'f': // Send transmitter smoothing values
    PrintValueComma('f');
    SERIAL_PRINTLN();
    queryType = 'X';
    break;
  case 'x': // Stop sending messages
    break;

  case '!': // Send flight software version
    SERIAL_PRINTLN(3.2, 1);
    queryType = 'X';
    break;

  case '#': // Send configuration
    queryType = 'X';
    break;


  }
}


#ifdef BinaryWrite
void printInt(int data) {
  byte msb, lsb;

  msb = data >> 8;
  lsb = data & 0xff;

  binaryPort->write(msb);
  binaryPort->write(lsb);
}

void sendBinaryFloat(float data) {
  union binaryFloatType {
    byte floatByte[4];
    float floatVal;
  } binaryFloat;

  binaryFloat.floatVal = data;
  binaryPort->write(binaryFloat.floatByte[3]);
  binaryPort->write(binaryFloat.floatByte[2]);
  binaryPort->write(binaryFloat.floatByte[1]);
  binaryPort->write(binaryFloat.floatByte[0]);
}

void sendBinaryuslong(unsigned long data) {
  union binaryuslongType {
    byte uslongByte[4];
    unsigned long uslongVal;
  } binaryuslong;

  binaryuslong.uslongVal = data;
  binaryPort->write(binaryuslong.uslongByte[3]);
  binaryPort->write(binaryuslong.uslongByte[2]);
  binaryPort->write(binaryuslong.uslongByte[1]);
  binaryPort->write(binaryuslong.uslongByte[0]);
}


void fastTelemetry()
{
  // **************************************************************
  // ***************** Fast Transfer Of Sensor Data ***************
  // **************************************************************
  // AeroQuad.h defines the output rate to be 10ms
  // Since writing to UART is done by hardware, unable to measure data rate directly
  // Through analysis:  115200 baud = 115200 bits/second = 14400 bytes/second
  // If float = 4 bytes, then 3600 floats/second
  // If 10 ms output rate, then 36 floats/10ms
  // Number of floats written using sendBinaryFloat is 15

  if (motorArmed == ON) {
    #ifdef OpenlogBinaryWrite
       printInt(21845); // Start word of 0x5555
       sendBinaryuslong(currentTime);
        printInt((int)flightMode);
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(gyroRate[axis]);
       }
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(meterPerSecSec[axis]);
       }
       sendBinaryFloat(accelOneG);
       #ifdef HeadingMagHold
          sendBinaryFloat(hdgX);
          sendBinaryFloat(hdgY);
		  for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
		       #if defined(HeadingMagHold)
			      sendBinaryFloat(getMagnetometerData(axis));
		       #endif
          }
       #else
         sendBinaryFloat(0.0);
         sendBinaryFloat(0.0);
         sendBinaryFloat(0.0);
       #endif
        for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
          sendBinaryFloat(kinematicsAngle[axis]);
        }
        printInt(32767); // Stop word of 0x7FFF
    #else
       printInt(21845); // Start word of 0x5555
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(gyroRate[axis]);
       }
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(meterPerSecSec[axis]);
       }
       for (byte axis = XAXIS; axis <= ZAXIS; axis++)
       #if defined(HeadingMagHold)
         sendBinaryFloat(getMagnetometerData(axis));
       #else
         sendBinaryFloat(0);
       #endif
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(getGyroUnbias(axis));
       }
       for (byte axis = XAXIS; axis <= ZAXIS; axis++) {
         sendBinaryFloat(kinematicsAngle[axis]);
       }
       printInt(32767); // Stop word of 0x7FFF
    #endif
  }
}
#endif // BinaryWrite



#ifdef SlowTelemetry
  struct __attribute__((packed)) telemetryPacket {
    unsigned short  id;
    long  latitude;
    long  longitude;
    short altitude;
    short course;
    short heading;
    byte  speed;
    byte  rssi;
    byte  voltage;
    byte  current;
    unsigned short capacity;
    unsigned short gpsinfo;
    byte  ecc[8];
  };

  union telemetryBuffer {
    struct telemetryPacket data;
    byte   bytes[32];
  } telemetryBuffer;

  #define TELEMETRY_MSGSIZE 24
  #define TELEMETRY_MSGSIZE_ECC (TELEMETRY_MSGSIZE + 8)

  byte slowTelemetryByte = 255;

  void initSlowTelemetry() {
#ifdef SoftModem
    softmodemInit();
#else
    Serial2.begin(1200);
#endif
    slowTelemetryByte = 255;
  }

  /* 100Hz task, sends data out byte by byte */
  void updateSlowTelemetry100Hz() {

    if (slowTelemetryByte < TELEMETRY_MSGSIZE_ECC ) {
      #ifdef SoftModem
        if (softmodemFreeToSend()) {
	  softmodemSendByte(telemetryBuffer.bytes[slowTelemetryByte]);
	  slowTelemetryByte++;
        }
      #else
        Serial2.write(telemetryBuffer.bytes[slowTelemetryByte]);
        slowTelemetryByte++;
      #endif
    }
    else {
      slowTelemetryByte=255;
    }
  }

  void updateSlowTelemetry10Hz() {

    if (slowTelemetryByte==255) {
      telemetryBuffer.data.id        = 0x5141; // "AQ"
      #ifdef UseGPS
        telemetryBuffer.data.latitude  = currentPosition.latitude;  // degrees/10000000
        telemetryBuffer.data.longitude = currentPosition.longitude; // degrees/10000000
        telemetryBuffer.data.course    = getCourse()/10; // degrees
        telemetryBuffer.data.speed     = getGpsSpeed()*36/1000;              // km/h
        telemetryBuffer.data.heading   = (short)(trueNorthHeading*RAD2DEG); // degrees
        telemetryBuffer.data.gpsinfo   = 0;
        telemetryBuffer.data.gpsinfo  |= (((unsigned short)((gpsData.sats<15)?gpsData.sats:15)) << 12);
      #else
        telemetryBuffer.data.latitude  = 0;
        telemetryBuffer.data.longitude = 0;
        telemetryBuffer.data.course    = 0;
        telemetryBuffer.data.speed     = 0;
        telemetryBuffer.data.heading   = 0;
        telemetryBuffer.data.gpsinfo   = 0;
      #endif

      #ifdef AltitudeHoldBaro
        telemetryBuffer.data.altitude  = (short)(getBaroAltitude()*10.0); // 0.1m
      #else
        telemetryBuffer.data.altitude  = 0;
      #endif

      #ifdef UseRSSIFaileSafe
        #ifdef RSSI_RAWVAL
          telemetryBuffer.data.rssi      = rssiRawValue/10; // scale to 0-100
        #else
          telemetryBuffer.data.rssi      = rssiRawValue;
        #endif
      #else
        telemetryBuffer.data.rssi      = 100;
      #endif

      #ifdef BattMonitor
        telemetryBuffer.data.voltage   = batteryData[0].voltage/10;  // to 0.1V
        telemetryBuffer.data.current   = batteryData[0].current/100; // to A
        telemetryBuffer.data.capacity  = batteryData[0].usedCapacity/1000; // mAh
      #else
        telemetryBuffer.data.voltage   = 0;
        telemetryBuffer.data.current   = 0;
        telemetryBuffer.data.capacity  = 0;
      #endif

       /* add ECC */
      encode_data(telemetryBuffer.bytes,24);

      /* trigger send */
      slowTelemetryByte=0;
    }
  }
  

  
#endif // SlowTelemetry

#endif // _AQ_SERIAL_COMM_

