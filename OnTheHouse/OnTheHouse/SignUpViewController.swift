//
//  SignUpViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/25/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmpassword: UITextField!
    

    @IBAction func registerButtonTapped(_ sender: Any) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let userEmail = _email.text!
        let userPass = _password.text!
        let userPassConfirm = _confirmpassword.text!
        let userFirst = _firstname.text!
        
        if(identifier == "CreateUserSegue"){
            if ((userEmail.isEmpty)||(userPass.isEmpty)||(userFirst.isEmpty)||(userPassConfirm.isEmpty)){
                //display error message
                displayAlert(userMessage: "All fields are required")
                return false;
            }
            if(userPassConfirm != userPass){
                //display alert message
                displayAlert(userMessage: "Passwords do not match")
                return false
            }
            
        }
        return true
        
    }
    
    func displayAlert(userMessage: String){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion:nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
