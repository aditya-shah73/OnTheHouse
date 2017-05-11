//
//  AccountViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/26/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var _name: UILabel!
    
    
    override func viewDidLoad() {
        fetchUser()
        super.viewDidLoad()
        
    }
    
    func fetchUser(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as?  [String: AnyObject]{
                self._name.text = dictionary["name"] as? String
                
                let databaseProfilePic = dictionary["profilePicture"] as? String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic!) as! URL)
                self.setProfilePicture(imageView: self.profileImage, imageToSet: UIImage(data:data! as Data)!)
            }
        }, withCancel: nil)
    }
    
    internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }


}
