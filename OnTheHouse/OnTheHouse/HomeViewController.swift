//
//  HomeViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 5/5/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
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
    
    var posts = [Post]()

    
    func fetchPosts(){

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
    
    @IBAction func postItemPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createPost")
        self.present(vc!, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of cells

        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        cell.myImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.myLabel.text = self.posts[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected : " , indexPath.row)
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

