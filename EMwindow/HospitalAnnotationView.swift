//
//  HospitalAnnotationView.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 3/13/19.
//  Copyright © 2019 CareTrails. All rights reserved.
//

import Foundation
import MapKit

class HospitalAnnotationView: MKAnnotationView {
    // data
    weak var customCalloutView: HospitalDetailMapView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
    }
    
    // MARK: - callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected { // 2
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadHospitalDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView as HospitalDetailMapView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    self.customCalloutView!.alpha = 1.0
                }
            }
        } else { // 3
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    self.customCalloutView!.alpha = 0.0
                    self.customCalloutView!.removeFromSuperview()
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadHospitalDetailMapView() -> HospitalDetailMapView? { // 4
        if let views = Bundle.main.loadNibNamed("HospitalDetailMapView", owner: self, options: nil) as? [HospitalDetailMapView], views.count > 0 {
            let hospitalDetailMapView = views.first!
            return hospitalDetailMapView
        }
        return nil
    }
    
    override func prepareForReuse() { // 5
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
