//
//  LoginViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/25/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginButton: FBSDKLoginButton!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
        }
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        
                
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if self._email.text == "" || self._password.text == "" {
            
            displayAlert(userMessage: "Please fill out the form")
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self._email.text!, password: self._password.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged Out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        print("Successfully Logged In")
        
        
        let accessToken = FBSDKAccessToken.current()
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
            if err != nil{
                    print("FB User is wrong", err ?? "")
            }
            print("User successfully logged in to Firebase with: ", user ?? "")
            
            
        })
        
        
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil{
                print("Error", err ?? "")
                return
            }
            print(result ?? "")
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(vc!, animated: true, completion: nil)
    }

    func displayAlert(userMessage: String){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion:nil)
    }

}
