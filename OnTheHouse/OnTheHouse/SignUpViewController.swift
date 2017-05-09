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

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmpassword: UITextField!
    @IBOutlet weak var _profilepic: UIImageView!
    let storage = FIRStorage.storage().reference(forURL: "gs://onthehouse-1c446.appspot.com")
    let ref = FIRDatabase.database().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func importButtonPressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            _profilepic.image = image
            
        }
        else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func registerTapped(_ sender: Any) {
        if _email.text == "" {
            displayAlert(userMessage: "Please enter an email")
            
        } else {
            if(_password.text! != _confirmpassword.text){
                self.displayAlert(userMessage: "Passwords do not match")
                return
            }
            if(_email.text == nil){
                self.displayAlert(userMessage: "Please enter email address")
                return
            }
            FIRAuth.auth()?.createUser(withEmail: _email.text!, password: _password.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    
                let uid = FIRAuth.auth()!.currentUser!.uid
                let imageRef = self.storage.child("users").child("\(user!.uid).jpg")
                let data = UIImageJPEGRepresentation(self._profilepic.image!, 0.5)
                let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                    }
                    imageRef.downloadURL(completion: { (url, err) in
                        if err != nil{
                            print(err!)
                        }
                        if let url = url {
                            let values = ["uid" : user?.uid,
                                          "name": self._firstname.text!,
                                          "email": self._email.text!,
                                          "image": url.absoluteString]
                            self.ref.child("users").child(uid).setValue(values)
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                            self.present(vc!, animated: true, completion: nil)
                           
                        }
                    })
                })
                uploadTask.resume()
                }
                else{
                        self.displayAlert(userMessage: "Please complete the form correctly")
                        return
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
