//
//  UserAnnotation.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 2/16/19.
//  Copyright © 2019 CareTrails. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class UserAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var imageName: String? {
        return "userLocation"
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}

