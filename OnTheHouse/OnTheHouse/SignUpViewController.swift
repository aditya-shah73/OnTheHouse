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
                if error != nil {
                    self.displayAlert(userMessage: "Please complete the form correctly")
                    return
                }
                print("You have successfully signed up")
                guard let uid = user?.uid else {
                    return
                }
                let imageName = NSUUID().uuidString
                let storage = FIRStorage.storage().reference().child("ProfilePictures").child("\(imageName).png")
                
                if let uploadData = UIImagePNGRepresentation(self._profilepic.image!){
                    storage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error ?? "")
                            return
                        }
                        
                        if let profilePicture = metadata?.downloadURL()?.absoluteString{
                            let values = ["uid" : uid,
                                          "name": self._firstname.text!,
                                          "email": self._email.text!,
                                          "profilePicture": profilePicture] as [String : Any]
                            self.registerUserIntoDatabaseUsingUID(uid: uid, values: values)
                        }
                        
                        
                    })
                }

            }
            

        }

    }

    private func registerUserIntoDatabaseUsingUID(uid: String, values: [String: Any]){
        let ref = FIRDatabase.database().reference(fromURL: "https://onthehouse-1c446.firebaseio.com/")
        let userReference = ref.child("users").child(uid)


        userReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
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
    

    @IBAction func backToLoginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
