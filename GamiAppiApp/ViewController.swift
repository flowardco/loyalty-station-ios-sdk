//
//  ViewController.swift
//  GamiAppiApp
//
//  Created by Abdallah on 3/16/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import Gamibot
class ViewController: UIViewController {

    @IBOutlet weak var views: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button  = GamiphyBotButton(frame: CGRect.zero)
        views.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: views.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: views.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: views.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: views.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    @IBAction func open(_ sender: Any) {
        
                
                GamiphySDK.shared.open(on: self)
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    GamiphySDK.shared.authUser(user: GamiphyUser(name: "John Smith", email: "john@smith.com"))
    }
}

}
