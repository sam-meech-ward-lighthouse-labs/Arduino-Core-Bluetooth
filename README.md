# Arduino iOS


---

## Core Bluetooth


---

## Snippets

```swift
centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)


func startScanning() {
  centralManager.scanForPeripherals(withServices: nil, options: nil)
}
```


```swift
extension Central: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      startScanning()
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if (peripheral.name == "BT05") {
      self.peripheral = peripheral
      centralManager.stopScan()
      centralManager.connect(peripheral, options: nil)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.delegate = self
    peripheral.discoverServices([CBUUID(string: "FFE0"), CBUUID(string: "FFE1")])
  }
}
```

```swift
extension Central:CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if let error = error {
      print("error didDiscoverServices \(error)")
    }
    peripheral.services?.forEach { service in
      print("service \(service)")
    }
    guard let service = peripheral.services?.first else {
      print("Couldn't find service \(peripheral.services)")
      return
    }
    print("found service \(service)")
    peripheral.discoverCharacteristics(nil, for: service)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let error = error {
      print("error didDiscoverCharacteristicsFor \(error)")
    }
    service.characteristics?.forEach { characteristic in
      
      print("Characteristic \(characteristic.uuid)")
      
      peripheral.readValue(for: characteristic)
      peripheral.setNotifyValue(true, for: characteristic)
      
      if (characteristic.uuid.uuidString == "FFE1") {
        let message = ""
        let data = message.data(using: String.Encoding.utf8)!
  
        peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
      }
 
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("error didUpdateValueFor \(error)")
      return
    }
    guard let buffer = characteristic.value else {
      print("error couldnt get value")
      return
    }
    print("buffer \(String(data: buffer, encoding: .utf8)) \(characteristic.uuid)")
  }
  
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("error didWriteValueFor \(error)")
      return
    }
    guard let buffer = characteristic.value else {
      print("error couldnt get value")
      return
    }
    print("buffer \(String(data: buffer, encoding: .utf8)) \(characteristic.uuid)")
  }
}
```