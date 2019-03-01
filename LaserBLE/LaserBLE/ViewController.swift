//
//  ViewController.swift
//  LaserBLE
//
//  Created by Sam Meech-Ward on 2019-02-28.
//  Copyright © 2019 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let central = MyCentral()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func on(_ sender: Any) {
    central.send(message: "on")
  }
  @IBAction func off(_ sender: Any) {
    central.send(message: "off")
  }
  
  @IBAction func up(_ sender: Any) {
    central.send(message: "up")
  }
  @IBAction func down(_ sender: Any) {
    central.send(message: "down")
  }
  @IBAction func left(_ sender: Any) {
    central.send(message: "left")
  }
  @IBAction func right(_ sender: Any) {
    central.send(message: "right")
  }
}


