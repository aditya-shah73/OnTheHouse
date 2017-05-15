
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
    @IBOutlet weak var messageButton: UIButton!
    var theCoordinates: CLLocationCoordinate2D?
    
    //The current post that is being displayed
    var post = Post()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillPostInfo()
        fillUserInfo()
        fillMapInfo()
    }
    
    @IBAction func messageUserPressed(_ sender: Any) {
        performSegue(withIdentifier: "message", sender: self.user)
    }
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    func fillPostInfo(){
            postTitle.text! = post.title!
            postDescription.text! = post.theDescription!
            postPicture.downloadImage(from: post.pathToImage)
    }

    var user = User()

    func fillCategoryPicker(){
        categoryPicker.numberOfRows(inComponent: 5)
        
        categoryPicker.rowSize(forComponent: 50)
    }
    func fillMapInfo(){
        let location = post.location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location! as String) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    let location = MKPlacemark(placemark: placemarks.first!).location
                    self.theCoordinates = location!.coordinate
                    
                    self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.theCoordinates!, 2000, 2000), animated: true)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func fillUserInfo(){
        let uid = post.userID!
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as?  [String: AnyObject]{
                self.user.email = dictionary["email"] as? String
                self.user.name = dictionary["name"] as? String
                self.user.uid = dictionary["uid"] as? String
                self.user.profilePicture = dictionary["profilePicture"] as? String

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageCollectionViewController{
            destination.toUser = user
        }
    }
    
    
    
    
}



