#ifndef __bluetooth_setup_h__
#define __bluetooth_setup_h__

#include <SoftwareSerial.h>
#include <Arduino.h>

class Bluetooth {
  public:
    /// the tx and rx or the bluetooth adapter
    Bluetooth(byte t, byte r) : tx(t), rx(r) {}
    void setup();
    void write(String text);
    String writeAT(String text);
    String read();
    String reset();

  private: 
    byte tx;
    byte rx;
    SoftwareSerial *serial;

    String waitForResponse();
};


#endif