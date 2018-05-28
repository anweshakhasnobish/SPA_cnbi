#include <Wire.h>
#include "pwm.h"
#include "I2C.h"
#include "SerialCom.h"

// main loop time variable
unsigned long previousTime = 0;
unsigned long currentTime = 0;
unsigned long deltaTime = 0;
// main loop executive frame counter
unsigned long frameCounter = 0;

// sub loop time variable

unsigned long oneHZpreviousTime = 0;
unsigned long fiveHZpreviousTime = 0;
unsigned long tenHZpreviousTime = 0;
unsigned long lowPriorityTenHZpreviousTime = 0;
unsigned long lowPriorityTenHZpreviousTime2 = 0;
unsigned long fiftyHZpreviousTime = 0;
unsigned long hundredHZpreviousTime = 0;
unsigned long thousandHZpreviousTime = 0;

#define TASK_1000HZ 1
#define TASK_100HZ 10
#define TASK_50HZ 20
#define TASK_10HZ 100
#define TASK_5HZ 500
#define TASK_1HZ 1000
float G_Dt = 0.002, ground[4] = {512, 512, 512, 512};

void setup() {

  Master_init();
  pwm_init();
  Serial.begin(115200);
  for (int channel = 0; channel < 16; channel++)
  {
    writeMotorCommand(channel, 50, 25);
    disable_out(channel);
    Serial.println(channel);
  }
  Serial.println("Test Passed for All PWM channels:");
}


int x = 5, channel = 0, i = 0, channelCounter = 0,j=0;
/*******************************************************************
   1KHz task
 ******************************************************************/
void process1000HzTask() {


  G_Dt = (currentTime - thousandHZpreviousTime) / 1000000.0;
  thousandHZpreviousTime = currentTime;

  
}


/*******************************************************************
   100Hz task
 ******************************************************************/
void process100HzTask() {
  //Serial.println("100Hz");
  G_Dt = (currentTime - hundredHZpreviousTime) / 1000000.0;
  hundredHZpreviousTime = currentTime;

  /*for (i = 0; i < 16; i++)
  { Serial.print(buffer[i], 2);
    Serial.print(", ");
  }
  Serial.println(); */
} 

/*******************************************************************
   50Hz task
 ******************************************************************/
void process50HzTask() {
  G_Dt = (currentTime - fiftyHZpreviousTime) / 1000000.0;
  fiftyHZpreviousTime = currentTime;
  readSerialCommand();


}

/*******************************************************************
   10Hz task
 ******************************************************************/
void process10HzTask1() {

  G_Dt = (currentTime - tenHZpreviousTime) / 1000000.0;
  tenHZpreviousTime = currentTime;


}

/*******************************************************************
   low priority 10Hz task 2
 ******************************************************************/
void process10HzTask2() {
  G_Dt = (currentTime - lowPriorityTenHZpreviousTime) / 1000000.0;
  lowPriorityTenHZpreviousTime = currentTime;

  // Listen for configuration commands and reports telemetry
  // readSerialCommand();
  //  sendSerialTelemetry();

}

/*******************************************************************
   low priority 10Hz task 3
 ******************************************************************/
void process10HzTask3() {
  G_Dt = (currentTime - lowPriorityTenHZpreviousTime2) / 1000000.0;
  lowPriorityTenHZpreviousTime2 = currentTime;

}

/*******************************************************************
   5Hz task
 ******************************************************************/
void process5HzTask() {


  // User defined space
  G_Dt = (currentTime - fiveHZpreviousTime) / 1000000.0;
  fiveHZpreviousTime = currentTime;


}


/*******************************************************************
   1Hz task
 ******************************************************************/
void process1HzTask() {


  // User defined space
  G_Dt = (currentTime - oneHZpreviousTime) / 1000000.0;
  oneHZpreviousTime = currentTime;




}


void loop () {

  currentTime = micros();
  deltaTime = currentTime - previousTime;

  //if (deltaTime >= 100) {
  //
  //  }
  // ================================================================
  // 1000Hz task loop
  // ================================================================
  if (deltaTime >= 1000) {

    frameCounter++;

    process1000HzTask();

    // ================================================================
    // 100Hz task loop
    // ================================================================
    if (frameCounter % TASK_100HZ == 0) {  //  100 Hz tasks
      process100HzTask();
    }


    // ================================================================
    // 50Hz task loop
    // ================================================================
    if (frameCounter % TASK_50HZ == 0) {  //  50 Hz tasks
      process50HzTask();
    }


    // ================================================================
    // 10Hz task loop
    // ================================================================
    if (frameCounter % TASK_10HZ == 0) {  //   10 Hz tasks
      process10HzTask1();
    }
    else if ((currentTime - lowPriorityTenHZpreviousTime) > 100000) {
      process10HzTask2();
    }
    else if ((currentTime - lowPriorityTenHZpreviousTime2) > 100000) {
      process10HzTask3();
    }

    // ================================================================
    // 5Hz task loop
    // ================================================================
    if (frameCounter % TASK_5HZ == 0) {  //   5 Hz tasks
      process5HzTask();
    }
    // ================================================================
    // 1Hz task loop
    // ================================================================
    if (frameCounter % TASK_1HZ == 0) {  //   1 Hz tasks
      process1HzTask();
    }

    previousTime = currentTime;

  }
  if (frameCounter >= 2000) {
    frameCounter = 0;
  }
}










void Pixelwise(int delayms)
{

int tic= micros();
  if(pixel!=-1)
  {enable_out(pixel);}
  else
  {
   for (int i = 0; i < 16; i++)
     {writeMotorCommand(i, pwmDutyCycle, pwmFrequency);
      disable_out(i);}
     
  }

  SERIAL_PRINTLN( ((micros() - tic)/1000));

} 

