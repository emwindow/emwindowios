//
//  CustomAnnotation.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 8/8/18.
//  Copyright © 2018 CareTrails. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class HospitalAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    var rating: Int
    var availableBeds: Int
    let coordinate: CLLocationCoordinate2D
    var imageName: String? {
        return "hospitalAnnotation"
    }
    
    init(title: String, locationName: String, discipline: String, rating: Int, availableBeds: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.rating = rating
        self.availableBeds = availableBeds
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return "EMwindow Rating: \(rating) \n Available Beds: \(availableBeds)"
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
