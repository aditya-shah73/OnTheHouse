//
//  HomeViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 5/5/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class HomeViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        posts.removeAll()
        fetchPosts()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of cells
        return self.posts.count
    }
    
    @IBAction func postItemPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createPost")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        cell.myImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.myLabel.text = self.posts[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected : " , self.posts[indexPath.row])
        //sender is the post that is selected
        print(self.posts[indexPath.row])
        performSegue(withIdentifier: "postProfile", sender: self.posts[indexPath.row])
    }
    
    var posts = [Post]()

    func fetchPosts(){
        let ref = FIRDatabase.database().reference()
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
                        let postsSnap = snap.value as! [String: AnyObject]
                        //this gets all the posts and puts it in posts array
                        
                        for(_,post) in postsSnap {
                            if let uid = post["userID"] as? String{
                                    let thePost = Post()
                                    if let description = post["description"] as? String,
                                        let postID = post["postID"] as? String,
                                        let pathToImage = post["pathToImage"] as? String,
                                        let title = post["title"] as? String,
                                        let location = post["location"] as? String{
                                        
                                        thePost.theDescription = description
                                        thePost.postID = postID
                                        thePost.pathToImage = pathToImage
                                        thePost.title = title
                                        thePost.userID = uid
                                        thePost.location = location
                                        
                                        self.posts.append(thePost)
                                    }
                            self.collectionView.reloadData()
                        }
                    }
                })
              ref.removeAllObservers()
            }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostViewController{
            if let post = sender as? Post{
                //send the selected post to the PostViewVC
                destination.post = post
            }
        }
    }
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}



