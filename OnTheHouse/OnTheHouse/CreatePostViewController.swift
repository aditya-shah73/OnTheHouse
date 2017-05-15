//
//  PostViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 4/26/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import FirebaseDatabase
import FirebaseStorage

class CreatePostViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var locationText: UITextField!
    var theCoordinates: CLLocationCoordinate2D?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary

        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.layer.cornerRadius = 70.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.masksToBounds = true
            imageView.image = image
        }
        else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://onthehouse-1c446.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpeg")
        
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
                }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "title" : self.titleText.text!,
                                "description": self.descriptionText.text!,
                                "postID" : key,
                                "location" : self.locationText.text] as [String : Any]
                    
                    let postFeed = ["\(key)" : feed]
                    ref.child("posts").updateChildValues(postFeed)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
 
        uploadTask.resume()
        
        
    }
    
    
    @IBAction func getLocation(_ sender: UIButton) {
        let location = self.locationText.text
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
