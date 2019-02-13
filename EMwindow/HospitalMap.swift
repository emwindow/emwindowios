//
//  HospitalMap.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 7/20/18.
//  Copyright © 2018 CareTrails. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class HospitalMap: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var userLat: Double = 37.774027
    var userLong: Double = -122.460578
    
    // VARIABLES
    var hospital: String = "Columbus General Hospital"
    var hospitalNoSpaces: String = "ColumbusGeneralHospital"
    var totalBeds: Int = 34
    
    var timeUpdater = Timer()
    var defaultTimeInterval: Int = 2
    
    // Hospital 1: UCSF Medical Center
    var day1: Int = 1
    var month1: Int = 8
    var year1: Int = 2018
    var hour1: Int = 9
    var minute1: Int = 0
    var arrivalRateArray1: [Double] = []
    var processTimeArray1: [Double] = []
    
    // Hospital 2: UCSF Medical Center
    var day2: Int = 2
    var month2: Int = 8
    var year2: Int = 2018
    var hour2: Int = 9
    var minute2: Int = 0
    var arrivalRateArray2: [Double] = []
    var processTimeArray2: [Double] = []
    
    // Hospital 3: UCSF Medical Center
    var day3: Int = 3
    var month3: Int = 8
    var year3: Int = 2018
    var hour3: Int = 9
    var minute3: Int = 0
    var arrivalRateArray3: [Double] = []
    var processTimeArray3: [Double] = []
    
    
    
    
    
    //
    // Purpose: Call functions when view has loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        startTimer(interval: defaultTimeInterval)
        
        simulateUser()
        simulateHospitals()
        
        loadData(day: day1, month: month1, year: year1, hour: hour1, minute: minute1, hospital: 1)
        loadData(day: day2, month: month2, year: year2, hour: hour2, minute: minute2, hospital: 2)
        loadData(day: day3, month: month3, year: year3, hour: hour3, minute: minute3, hospital: 3)
        
        //centerOnUser()
    }
    
    //
    // Purpose: Center the map on the user when crosshairs button is tapped
    //
    func centerOnUser() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //
    // Purpose: Get user's location
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        userLat = location.coordinate.latitude
        userLong = location.coordinate.longitude
        
        //setHospitalLocations()
        
        locationManager.stopUpdatingLocation()
    }
    
    //
    // Purpose: To simulate user in San Francisco
    //
    func simulateUser() {
        // Place user in San Francisco
        let location: CLLocation = CLLocation(latitude: userLat, longitude: userLong)
        
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //
    // Purpose: To simulate map feature with 3 different hospitals displaying information
    //
    func simulateHospitals() {
        // Hospital 1
        let hospitalAnnotation1 = CustomAnnotation(title: "UCSF Medical Center",
                                                  locationName: "Main Campus" ,
                                                  discipline: "General Hospital",
                                                  rating: 0,
                                                  coordinate: CLLocationCoordinate2D(latitude: 37.763159, longitude: -122.457850))
        self.mapView.addAnnotation(hospitalAnnotation1)

        // Hospital 2
        let hospitalAnnotation2 = CustomAnnotation(title: "St. Mary's Medical Center",
                                                  locationName: "Main Campus" ,
                                                  discipline: "General Hospital",
                                                  rating: 0,
                                                  coordinate: CLLocationCoordinate2D(latitude: 37.7739108, longitude: -122.4544917))
        self.mapView.addAnnotation(hospitalAnnotation2)

        // Hospital 3
        let hospitalAnnotation3 = CustomAnnotation(title: "California Pacific Medical Center",
                                                  locationName: "California Campus" ,
                                                  discipline: "General Hospital",
                                                  rating: 0,
                                                  coordinate: CLLocationCoordinate2D(latitude: 37.786106, longitude: -122.455958))
        self.mapView.addAnnotation(hospitalAnnotation3)
    }
    
    //
    // Purpose: Start timer
    //
    public func startTimer(interval: Int) {
        timeUpdater = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(HospitalMap.updateTime), userInfo: nil, repeats: true)
    }
    
    //
    // Purpose: Increase time by 1 minute
    //
    @objc func updateTime() {
        // Hospital 1
        minute1 += 1
        
        if (minute1 == 60) {
            minute1 = 0
            hour1 += 1
            
            if (hour1 == 24) {
                hour1 = 0
                day1 += 1
            }
        }
        
        loadData(day: day1, month: month1, year: year1, hour: hour1, minute: minute1, hospital: 1)
        
        
        // Hospital 2
        minute2 += 1
        
        if (minute2 == 60) {
            minute2 = 0
            hour2 += 1
            
            if (hour2 == 24) {
                hour2 = 0
                day2 += 1
            }
        }
        
        loadData(day: day2, month: month2, year: year2, hour: hour2, minute: minute2, hospital: 2)
        
        
        
        // Hospital 3
        minute3 += 1
        
        if (minute3 == 60) {
            minute3 = 0
            hour3 += 1
            
            if (hour3 == 24) {
                hour3 = 0
                day3 += 1
            }
        }
        
        loadData(day: day3, month: month3, year: year3, hour: hour3, minute: minute3, hospital: 3)
    }
    
    
    
    
    
    
    
    /*
    *
    * For getting EMwindow ratings of each hospital
    *
    */
    
    
    
    
    
    
    
    
    
    
    
    //
    // Purpose: Load data
    //
    func loadData(day: Int, month: Int, year: Int, hour: Int, minute: Int, hospital: Int) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        getArrivalRateArray(day: day, month: month, year: year, hour: hour, minute: minute, hospital: hospital)
        getProcessTimeArray(day: day, month: month, year: year, hour: hour, minute: minute, hospital: hospital)
        getCapacityUtilization(day: day, month: month, year: year, hour: hour, minute: minute, hospital: hospital)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    //
    // Purpose: GET arrival rate array
    //
    func getArrivalRateArray(day: Int, month: Int, year: Int, hour: Int, minute: Int, hospital: Int) {
        
        Alamofire.request("https://emwindow.herokuapp.com/getArrivalRateArray",
                          parameters: ["hospital": hospitalNoSpaces, "month": month,
                                       "day": day, "year": year, "hour": hour, "minute": minute],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                if (hospital == 1) {
                    self.arrivalRateArray1 = (value as! NSArray) as! [Double]
                } else if (hospital == 2) {
                    self.arrivalRateArray2 = (value as! NSArray) as! [Double]
                } else {
                    self.arrivalRateArray3 = (value as! NSArray) as! [Double]
                }
        }
    }
    
    //
    // Purpose: GET Process Time Array
    //
    func getProcessTimeArray(day: Int, month: Int, year: Int, hour: Int, minute: Int, hospital: Int) {
        
        Alamofire.request("https://emwindow.herokuapp.com/getProcessTimeArray",
                          parameters: ["hospital": hospitalNoSpaces, "month": month,
                                       "day": day, "year": year, "hour": hour, "minute": minute],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                let timesArray = value as! NSArray
                
                // Reset array
                if (hospital == 1) {
                    self.processTimeArray1 = []
                } else if (hospital == 2) {
                    self.processTimeArray2 = []
                } else {
                    self.processTimeArray3 = []
                }
                
                for time in timesArray {
                    if let n = time as? NSNumber {
                        var time = n.doubleValue
                        
                        if (time < 0) {
                            time = time * -1
                        }
                        
                        if (hospital == 1) {
                            self.processTimeArray1.append(time)
                        } else if (hospital == 2) {
                            self.processTimeArray2.append(time)
                        } else {
                            self.processTimeArray3.append(time)
                        }
                    }
                }
        }
    }
    
    //
    // Purpose: GET Capacity Utilization
    //
    func getCapacityUtilization(day: Int, month: Int, year: Int, hour: Int, minute: Int, hospital: Int) {
        Alamofire.request("https://emwindow.herokuapp.com/getCapacityUtilization",
                          parameters: ["hospital": hospitalNoSpaces, "totalBeds": totalBeds, "month": month,
                                       "day": day, "year": year, "hour": hour, "minute": minute],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                let capacityUtilization = (value as! NSNumber) as! Double
                
                self.getEMwindowRating(hospital: hospital, capacityUtilization: capacityUtilization)
        }
    }
    
    //
    // Purpose: GET Rating
    //
    func getEMwindowRating(hospital: Int, capacityUtilization: Double) {
        
        var arrivalArray: [Double] = []
        var processArray: [Double] = []
        
        if (hospital == 1) {
            arrivalArray = self.arrivalRateArray1
            processArray = self.processTimeArray1
        } else if (hospital == 2) {
            arrivalArray = self.arrivalRateArray2
            processArray = self.processTimeArray2
        } else {
            arrivalArray = self.arrivalRateArray3
            processArray = self.processTimeArray3
        }
        
        Alamofire.request("https://emwindow.herokuapp.com/getEMwindowRating",
                          parameters: ["arrivalRateArray": JSON(arrivalArray), "processTimeArray": JSON(processArray), "capacityUtilization": capacityUtilization],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                var rating = value as! Double
                
                if (rating > 100) {
                    rating = 100;
                }
                
                
                // Update annotations with rating
                if (hospital == 1) {
                    
                } else if (hospital == 2) {
                    
                } else {
                    
                }
        }
    }
        
    //
    // Purpose: Truncate a double
    //
    func truncateDouble(decimalNum: Double) -> Double {
        return Double(floor(100 * decimalNum) / 100)
    }
    
        
        
    
    
    
    
    
    
    
    
    
    
    /*
     *
     * Done getting ratings
     *
     */
    
    
    

    
    
    
    
    
    
    

    
    
    
    
    //
    // Purpose: Get all hospitals around user and add annotations
    //
    func setHospitalLocations() {
        var latMin: Double = userLat - 0.05
        latMin = latMin.rounded(.down)
        var latMax: Double = userLat + 0.05
        latMax = latMax.rounded(.up)
        var longMin: Double = userLong - 0.05
        longMin = longMin.rounded(.down)
        var longMax: Double = userLong + 0.05
        longMax = longMax.rounded(.up)

        let locationRange: String = "LATITUDE%20%3E%3D%20\(latMin)%20AND%20LATITUDE%20%3C%3D%20\(latMax)%20AND%20LONGITUDE%20%3E%3D%20\(longMin)%20AND%20LONGITUDE%20%3C%3D%20\(longMax)"
        let outFields: String = "NAME,TYPE,LATITUDE,LONGITUDE"
        
        Alamofire.request("https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals/FeatureServer/0/query?where=\(locationRange)&outFields=\(outFields)&outSR=4326&f=json",
            headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                let json = JSON(value)
                let hospitalArray = json["features"]
                
                for hospital in hospitalArray {
                    let lat = Double(hospital.1["attributes"]["LATITUDE"].stringValue)
                    let long = Double(hospital.1["attributes"]["LONGITUDE"].stringValue)
                    var type = hospital.1["attributes"]["TYPE"].stringValue
                    type = type.lowercased()
                    type = type.capitalized
                    var name = hospital.1["attributes"]["NAME"].stringValue
                    var locationName = ""
                    name = name.lowercased()
                    name = name.capitalized
                    if name.range(of:" - ") != nil {
                        let nameArray = name.components(separatedBy: " - ")
                        name = nameArray[0]
                        locationName = nameArray[1]
                        locationName = "\(locationName) - "
                    }
                    
                    let hospitalAnnotation = CustomAnnotation(title: name,
                                          locationName: "\(locationName)\(type)" ,
                                          discipline: type,
                                          rating: 0,
                                          coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
                    self.mapView.addAnnotation(hospitalAnnotation)
                }
        }
    }
  
    @IBAction func refreshMap(_ sender: Any) {
        simulateUser()
        //centerOnUser()
    }
}

extension HospitalMap: MKMapViewDelegate {
    // Displays callout when user taps on annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "mapIcon"), for: UIControl.State())
            view.rightCalloutAccessoryView = mapsButton
        }
        
        view.glyphText = "H"
        view.markerTintColor = UIColor.red
        
        return view
    }
    
    // Takes user to Apple Maps app when user taps info button on callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! CustomAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
