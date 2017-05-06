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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        
                
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
        
        performSegue(withIdentifier: "login", sender: self)
    }


}
