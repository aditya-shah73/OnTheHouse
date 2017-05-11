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

class AccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var _name: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        posts.removeAll()
        fetchUser()
        fetchUserPosts()


        
    }
    
    func fetchUser(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as?  [String: AnyObject]{
                self._name.text = dictionary["name"] as? String
                
                let databaseProfilePic = dictionary["profilePicture"] as? String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic!) as! URL)
                self.setProfilePicture(imageView: self.profileImage, imageToSet: UIImage(data:data! as Data)!)
            }
        }, withCancel: nil)
        ref.removeAllObservers()
    }
    
    var posts = [Post]()
    
    func fetchUserPosts(){
        let ref = FIRDatabase.database().reference()
        ref.child("posts").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let postSnap = snapshot.value as! [String: AnyObject]
            
            let postItem = Post()
            
            if let description = postSnap["description"] as? String,
                let pathToImage = postSnap["pathToImage"] as?  String,
                let postID = postSnap["postID"] as? String,
                let title = postSnap["title"] as? String,
                let userID = postSnap["userID"] as? String{
                postItem.description = description
                postItem.pathToImage = pathToImage
                postItem.postID = postID
                postItem.title = title
                postItem.userID = userID
            }
            self.posts.append(postItem)
            
            self.collectionView.reloadData()
        })
        
        ref.removeAllObservers()
    }
    
    internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        imageView.layer.cornerRadius = 70.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user_collection_cell", for: indexPath) as! CollectionViewCell
        cell.accountImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.accountLabel.text = self.posts[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }


}
