
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MapView
        let distanceSpan:CLLocationDegrees = 2000
        let sjsuLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.3351874, -121.88107150000002)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(sjsuLocation, distanceSpan, distanceSpan), animated: true)
        
        let sjsuPin = Annotations(title: "San Jose State University", subtitle: "Subtitle", coordinate: sjsuLocation)
        mapView.addAnnotation(sjsuPin)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
