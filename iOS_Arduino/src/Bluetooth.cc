#include "Bluetooth.h"


// constexpr int BLUETOOTH_SPEED = 57600;
constexpr int BLUETOOTH_SPEED = 9600;

void Bluetooth::setup() {
  this->serial = new SoftwareSerial(this->rx, this->tx);// {this->rx, this->tx}; // RX, TX
  this->serial->begin(BLUETOOTH_SPEED);
  delay(1000);
}

String Bluetooth::reset() {
  this->write("AT+RENEW");
  waitForResponse();
  this->write("AT+RESET");
  return waitForResponse();
}

void Bluetooth::write(String text) {
  this->serial->println(text);
}

String Bluetooth::writeAT(String text) {
  String message = text + "\n";
  this->serial->write(message.c_str());
  return this->read();
}

String Bluetooth::read() {
  return waitForResponse();
}

String Bluetooth::waitForResponse() {
  delay(1000);
  if (!this->serial->available()) {
    return "No Data";
  }
 
  return this->serial->readString();
}

