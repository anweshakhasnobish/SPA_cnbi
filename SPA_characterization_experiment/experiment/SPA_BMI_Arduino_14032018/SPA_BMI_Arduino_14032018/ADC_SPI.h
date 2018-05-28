
/*
  DigitalReadSerial
  Reads a digital input on pin 2, prints the result to the serial monitor

  This example code is in the public domain.
*/
#include <SPI.h>
boolean R_Cbar_state = true, busybar_state = true ;
const int  R_Cbar = 48, busybar = 46;
float buffer[16];

//Multi channel selection
const int S0 = 10;
const int S1 = 9;
const int S2 = 4;
const int S3 = 14;


// the setup routine runs once when you press reset:
void ADC_SPI_MUX_init() {
  SPI.begin();
  // make the pushbutton's pin an input:
  pinMode(busybar, INPUT);
  pinMode(R_Cbar, OUTPUT);
  pinMode(S3, OUTPUT); pinMode(S2, OUTPUT); pinMode(S1, OUTPUT); pinMode(S0, OUTPUT);
  pinMode(44,OUTPUT); //BYTE_bar for parallel mode
  digitalWrite(44,LOW);//0-> higher 8 bits and 1->lower 8 bits
}


float ADS8517_Read()
{
  // read the input pin:
  SPI.beginTransaction(SPISettings(9000000, MSBFIRST, SPI_MODE1));  // gain control of SPI bus
  digitalWrite(R_Cbar, HIGH);
  digitalWrite(R_Cbar, LOW);
  digitalWrite(R_Cbar, HIGH);
  while (digitalRead(busybar) != 1);
  byte b1 = SPI.transfer(0);
  byte b2 = SPI.transfer(0);

  SPI.endTransaction();// release the SPI bus

  //Serial.print(b1,BIN);
  // Serial.print(b2,BIN);
  // Serial.print(", ");
  uint16_t Voltage = (b1 << 8) + b2;
  return ((float) ((Voltage - 32768) * 20) / 63536); //0000H-> -10 V, 8000H -> 0 V, FFFFH -> +10 V

}


word ADS8517_Read_raw()
{

  // read the input pin:

  SPI.beginTransaction(SPISettings(9000000, MSBFIRST, SPI_MODE1));  // gain control of SPI bus

  digitalWrite(R_Cbar, HIGH);
  digitalWrite(R_Cbar, LOW);
  digitalWrite(R_Cbar, HIGH);
  while (digitalRead(busybar) != 1);

  byte b1 = SPI.transfer(0);
  byte b2 = SPI.transfer(0);

  SPI.endTransaction();// release the SPI bus

  word Voltage = (b1 * 256) + b2;
  // Serial.print(Voltage);
  // Serial.print(b1,BIN);
  // Serial.print(b2,BIN);
  // Serial.print(", ");
  return (Voltage);  //0000H-> -10 V, 8000H -> 0 V, FFFFH -> +10 V

}




void readChMux(int channel)
{
  switch (channel) {
    case 0:
      digitalWrite(S3, LOW); digitalWrite(S2, LOW); digitalWrite(S1, LOW); digitalWrite(S0, LOW);
      break;
    case 1:
      digitalWrite(S3, LOW); digitalWrite(S2, LOW); digitalWrite(S1, LOW); digitalWrite(S0, HIGH);
      break;
    case 2:
      digitalWrite(S3, LOW); digitalWrite(S2, LOW); digitalWrite(S1, HIGH); digitalWrite(S0, LOW);
      break;
    case 3://will choose channel 0 to avoid internal short in the IC
      digitalWrite(S3, LOW); digitalWrite(S2, LOW); digitalWrite(S1, HIGH); digitalWrite(S0, HIGH);
      break;
    case 4:
      digitalWrite(S3, LOW); digitalWrite(S2, HIGH); digitalWrite(S1, LOW); digitalWrite(S0, LOW);
      break;
    case 5:
      digitalWrite(S3, LOW); digitalWrite(S2, HIGH); digitalWrite(S1, LOW); digitalWrite(S0, HIGH);
      break;
    case 6:
      digitalWrite(S3, LOW); digitalWrite(S2, HIGH); digitalWrite(S1, HIGH); digitalWrite(S0, LOW);
      break;
    case 7:
      digitalWrite(S3, LOW); digitalWrite(S2, HIGH); digitalWrite(S1, HIGH); digitalWrite(S0, HIGH);
      break;
    case 8:
      digitalWrite(S3, HIGH); digitalWrite(S2, LOW); digitalWrite(S1, LOW); digitalWrite(S0, LOW);
      break;
    case 9:
      digitalWrite(S3, HIGH); digitalWrite(S2, LOW); digitalWrite(S1, LOW); digitalWrite(S0, HIGH);
      break;
    case 10:
      digitalWrite(S3, HIGH); digitalWrite(S2, LOW); digitalWrite(S1, HIGH); digitalWrite(S0, LOW);
      break;
    case 11:
      digitalWrite(S3, HIGH); digitalWrite(S2, LOW); digitalWrite(S1, HIGH); digitalWrite(S0, HIGH);
      break;
    case 12:
      digitalWrite(S3, HIGH); digitalWrite(S2, HIGH); digitalWrite(S1, LOW); digitalWrite(S0, LOW);
      break;
    case 13:
      digitalWrite(S3, HIGH); digitalWrite(S2, HIGH); digitalWrite(S1, LOW); digitalWrite(S0, HIGH);
      break;
    case 14:
      digitalWrite(S3, HIGH); digitalWrite(S2, HIGH); digitalWrite(S1, HIGH); digitalWrite(S0, LOW);
      break;
    case 15:
      digitalWrite(S3, HIGH); digitalWrite(S2, HIGH); digitalWrite(S1, HIGH); digitalWrite(S0, HIGH);
      break;

    default:
      digitalWrite(S3, LOW); digitalWrite(S2, LOW); digitalWrite(S1, LOW); digitalWrite(S0, LOW);
      break;
  }

}



