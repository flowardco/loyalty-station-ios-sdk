//
//  ViewController.swift
//  GamiAppiApp
//
//  Created by Abdallah on 3/16/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import LoyaltyStation

class ViewController: UIViewController {

    @IBOutlet weak var views: UIView!
    
    @IBAction func open(_ sender: Any) {
        LoyaltyStation.open(on: self)
    }
}
