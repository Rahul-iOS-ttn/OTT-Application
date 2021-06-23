//
//  ViewController.swift
//  OTT-Applcation
//
//  Created by TTN on 23/06/21.
//

import UIKit
import SocialLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Validator.sayHello()
        print("This email id is: ", Validator.validEmail("rahul@rahul.com"))
    }

}

