//
//  HomeViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 5/5/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of cells
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! CollectionViewCell
        
        //set images here
        cell.myImage.image = #imageLiteral(resourceName: "Couch2")
        cell.myLabel.text = "Almost New Couch"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected : " , indexPath.row)
    }
}
