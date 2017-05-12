//
//  AccountViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/26/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
    
    func fetchUserPosts() {
        let ref = FIRDatabase.database().reference()
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let uid = post["userID"] as? String{
                    if uid == FIRAuth.auth()?.currentUser?.uid{
                        let postItem = Post()
                        if let description = post["description"] as? String,
                            let postID = post["postID"] as? String,
                            let pathToImage = post["pathToImage"] as? String,
                            let title = post["title"] as? String {
                            
                            postItem.theDescription = description
                            postItem.postID = postID
                            postItem.pathToImage = pathToImage
                            postItem.title = title
                            postItem.userID = uid
                        
                            self.posts.append(postItem)
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
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
