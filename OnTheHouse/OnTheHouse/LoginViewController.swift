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
import FirebaseDatabase

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
        var imageStringUrl : String?
        
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
            graphRequest?.start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print(error ?? "")
                }
                
                if let resultDic = result as? NSDictionary {
                    let data = resultDic["picture"] as? NSDictionary
                    let dataDict = data!["data"] as? NSDictionary
                    imageStringUrl = dataDict!["url"] as? String
                }
            })
        
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
            if err != nil{
                    print("FB User is wrong", err ?? "")
            }
            print("User successfully logged in to Firebase with: ", user ?? "")
            guard let uid = user?.uid else{
                return
            }
            let ref = FIRDatabase.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["uid": user?.uid,
                        "name": user?.displayName,
                          "email": user?.email,
                          "profilePicture": imageStringUrl]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                    return
                }
            })
            
            
        })
        
        
    
        
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
