//
//  MyCentral.swift
//  LaserBLE
//
//  Created by Sam Meech-Ward on 2019-02-28.
//  Copyright © 2019 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

class MyCentral: NSObject {
  
  var centralManager: CBCentralManager!
  var peripheral: CBPeripheral!
  var characteristic: CBCharacteristic!
  
  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func send(message: String) {
    let data = message.data(using: String.Encoding.utf8)!
    
    peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
  }

}

extension MyCentral: CBCentralManagerDelegate {
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      central.scanForPeripherals(withServices: nil, options: nil)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(advertisementData)
    print(peripheral.name ?? "")
    
    if peripheral.name == "BT05" {
      self.peripheral = peripheral
      centralManager.stopScan()
      centralManager.connect(peripheral, options: nil)
    }
  }
  
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    self.peripheral = peripheral
    peripheral.delegate = self
    peripheral.discoverServices([CBUUID(string: "FFE1"), CBUUID(string: "FFE0")])
  }
  
}

extension MyCentral: CBPeripheralDelegate {
  
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
        self.characteristic = characteristic
        let message = ""
        let data = message.data(using: String.Encoding.utf8)!
        
        peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
      }
      
    }
  }
  
}
