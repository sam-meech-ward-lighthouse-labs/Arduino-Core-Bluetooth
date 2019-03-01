#include <Arduino.h>
#include <Servo.h>
#include "Bluetooth.h"

Bluetooth blue(11, 10);

Servo servo1;
Servo servo2;

void adjustState(String incomingData) {
  if (incomingData == "on") {
    digitalWrite(12, HIGH);
    Serial.println("turn on led");
  } else if (incomingData == "off") {
    digitalWrite(12, LOW);
    Serial.println("turn off led");
  } else if (incomingData == "right") {
    servo2.write(0);
    Serial.println("go right");
  } else if (incomingData == "left") {
    servo2.write(180);
    Serial.println("go left");
  } else if (incomingData == "up") {
    servo1.write(180);
    Serial.println("go up");
  } else if (incomingData == "down") {
    servo1.write(0);
    Serial.println("go down");
  }
}

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  Serial.println("Starting config");
  blue.setup();

  pinMode(12, OUTPUT);
  digitalWrite(12, LOW);

  // motion
  pinMode(2, INPUT); 

  servo1.attach(14);
  servo2.attach(15);
  servo1.write(10);
  servo2.write(10);
}
 
int i = 0;
void loop() {
  String sendMessage = "itteration " + String(i);
  blue.write(sendMessage);
  String incomingData = blue.read();
  Serial.println(incomingData);

  adjustState(incomingData);

  // Serial.println(digitalRead(2));

  i++;
}