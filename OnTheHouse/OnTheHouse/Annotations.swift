
//
//  Annotations.swift
//  OnTheHouse
//
//  Created by Marta Malapitan on 4/30/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//
import MapKit

class Annotations: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
