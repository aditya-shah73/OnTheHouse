
//  PostViewController.swift
//  OnTheHouse
//
//  Created by Marta Malapitan on 4/26/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//
import UIKit
import MapKit



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
    
    
    
}



