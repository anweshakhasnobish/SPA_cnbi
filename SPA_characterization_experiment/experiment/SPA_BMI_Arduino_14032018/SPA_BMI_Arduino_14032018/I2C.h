#include <Wire.h>
#include <string.h>
int ch, dutyCycle,frequency;

void receiveSlaveEvent(int howMany) {
  if (Wire.available()) { // loop through all
      
     switch (char query=Wire.read())
      {
      case 'R': { ch=Wire.read(); dutyCycle=Wire.read(); frequency=Wire.read();
                  writeMotorCommand(ch,dutyCycle,frequency);
                  Serial.print("R, ");
                  break;}
      case 'E': { ch=Wire.read();
                  enable_out(ch);
                  Serial.print("E, ");
                  break;}
      case 'D': { ch=Wire.read();
                  disable_out(ch);
                  Serial.print("D, ");
                  break;}       
      default:
      {while(Wire.available())
      Wire.read(); //flush the data if missed the start of string 'C'
      break;}
 
      }
      Serial.println(String(ch, DEC) + ", "+ String(dutyCycle, DEC) + ", " + String(frequency, DEC));         // print the character
      
}
}



void receiveMasterEvent(int howMany) {
  if (Wire.available()) { // loop through all
      while(Wire.available())
      Wire.read();  //not defined yet
    }
}


void Slave_init()
{

 Wire.begin(8);                // join i2c bus with address #8
 Wire.onReceive(receiveSlaveEvent); // register event

}

void Master_init()
{

 Wire.begin(3);                // join i2c bus with address #3
 Wire.onReceive(receiveMasterEvent); // register event


}


