
//  PostViewController.swift
//  OnTheHouse
//
//  Created by Marta Malapitan on 4/26/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//
import UIKit
import MapKit
import Firebase
import FirebaseDatabase


class PostViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postPicture: UIImageView!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    
    //The current post that is being displayed
    var post = Post()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillPostInfo()
        fillUserInfo()
        
        //MapView
        let distanceSpan:CLLocationDegrees = 2000
        let sjsuLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.3351874, -121.88107150000002)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(sjsuLocation, distanceSpan, distanceSpan), animated: true)
        
        let sjsuPin = Annotations(title: "San Jose State University", subtitle: "Subtitle", coordinate: sjsuLocation)
        mapView.addAnnotation(sjsuPin)
    }
    
    
    func fillPostInfo(){
            postTitle.text! = post.title!
            postDescription.text! = post.theDescription!
            postPicture.downloadImage(from: post.pathToImage)
    }
    
    
    func fillUserInfo(){
        let uid = post.userID!
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as?  [String: AnyObject]{
                self.userName.text = dictionary["name"] as? String
                
                let databaseProfilePic = dictionary["profilePicture"] as? String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic!) as! URL)
                self.setProfilePicture(imageView: self.userPicture, imageToSet: UIImage(data:data! as Data)!)
                
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
    
    
    
}



