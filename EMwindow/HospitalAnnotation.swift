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
    var availableMedSurgBeds: Int
    var availableOperationRoomBeds: Int
    var availableIntensiveCareUnitBeds: Int
    var availableEmergencyDepartmentBeds: Int
    let coordinate: CLLocationCoordinate2D
    var imageName: String? {
        return "hospitalAnnotation"
    }
    
    init(title: String, locationName: String, discipline: String, rating: Int,
         availableMedSurgBeds: Int,
         availableOperationRoomBeds: Int,
         availableIntensiveCareUnitBeds: Int,
         availableEmergencyDepartmentBeds: Int,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.rating = rating
        self.availableMedSurgBeds = availableMedSurgBeds
        self.availableOperationRoomBeds = availableOperationRoomBeds
        self.availableIntensiveCareUnitBeds = availableIntensiveCareUnitBeds
        self.availableEmergencyDepartmentBeds = availableEmergencyDepartmentBeds
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return "ED Congestion: \(rating), MS: \(availableMedSurgBeds), OR: \(availableOperationRoomBeds), ICU: \(availableIntensiveCareUnitBeds), ED: \(availableEmergencyDepartmentBeds)"
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
