//
//  SignUpViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/25/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmpassword: UITextField!
    @IBOutlet var _username: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        if _email.text == "" {
            displayAlert(userMessage: "Please enter an email")
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: _email.text!, password: _password.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    self.displayAlert(userMessage: "Please complete the form correctly")
                }
            }
        }

    }


    
    func displayAlert(userMessage: String){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion:nil)
    }
    

    @IBAction func backToLoginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
