//
//  ViewController.swift
//  GroupPay
//
//  Created by Michael Hyun on 4/18/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {

    }



    @IBAction func LoginButton(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "homeSegue"{
//            if let nvc = segue.destination as? UINavigationController{
//                if let homeVC = nvc.visibleViewController as? HomeViewController{
//                    homeVC.username = _username.text
//                    homeVC.password = _password.text
//                }
//                
//            }
//        }
//        if segue.identifier == "SignUpSegue"{
//            if let signupvc = segue.destination as? SignUpViewController {
//                
//            }
//        }
    }
}




