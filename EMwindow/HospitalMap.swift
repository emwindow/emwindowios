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
    
    // Map Variables
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var userLat: Double = 37.774027
    var userLong: Double = -122.460578
    
    // Hospital Variables
    var hospital: String = "Columbus General Hospital"
    var hospitalNoSpaces: String = "ColumbusGeneralHospital"
    var totalBeds: Int = 34
    
    // Timer variables
    var timeUpdater = Timer()
    var defaultTimeInterval: Int = 2
    
    // City score variables
    @IBOutlet weak var cityScoreView: UIView!
    @IBOutlet weak var cityScoreLabel: UILabel!
    @IBOutlet weak var cityAvailableMedSurgBeds: UILabel!
    @IBOutlet weak var cityAvailableOperationRoomBeds: UILabel!
    @IBOutlet weak var cityAvailableIntensiveCareUnitBeds: UILabel!
    @IBOutlet weak var cityAvailableEmergencyDepartmentBeds: UILabel!
    
    // Whichever annotation the user has selected
    var selectedAnnotation: HospitalAnnotation = HospitalAnnotation(title: "Other",
                                                                    locationName: "Other" ,
                                                                    discipline: "Other",
                                                                    rating: 0,
                                                                    availableMedSurgBeds: 120,
                                                                    availableOperationRoomBeds: 10,
                                                                    availableIntensiveCareUnitBeds: 20,
                                                                    availableEmergencyDepartmentBeds: 15,
                                                                    coordinate: CLLocationCoordinate2D(latitude: 37.773957, longitude: -122.453568))
    
    // Hospital 1: UCSF Medical Center
    var day1: Int = 1
    var month1: Int = 8
    var year1: Int = 2018
    var hour1: Int = 9
    var minute1: Int = 0
    var availableBeds1: Int = 34
    var totalMedSurgBeds1: Int = 400
    var availableMedSurgBeds1: Int = 0
    var totalOperationRoomBeds1: Int = 40
    var availableOperationRoomBeds1: Int = 0
    var totalIntensiveCareUnitBeds1: Int = 70
    var availableIntensiveCareUnitBeds1: Int = 0
    var totalEmergencyDepartmentBeds1: Int = 50
    var openEmergencyDepartmentBeds1: Int = 0
    var arrivalRateArray1: [Double] = []
    var processTimeArray1: [Double] = []
    var hospitalAnnotation1: HospitalAnnotation = HospitalAnnotation(title: "UCSF Medical Center",
                                                               locationName: "Main Campus" ,
                                                               discipline: "General Hospital",
                                                               rating: 0,
                                                               availableMedSurgBeds: 400,
                                                               availableOperationRoomBeds: 40,
                                                               availableIntensiveCareUnitBeds: 70,
                                                               availableEmergencyDepartmentBeds: 50,
                                                               coordinate: CLLocationCoordinate2D(latitude: 37.763078, longitude: -122.457724))
    
    // Hospital 2: St. Mary's Medical Center
    var day2: Int = 2
    var month2: Int = 8
    var year2: Int = 2018
    var hour2: Int = 9
    var minute2: Int = 0
    var availableBeds2: Int = 34
    var totalMedSurgBeds2: Int = 120
    var availableMedSurgBeds2: Int = 0
    var totalOperationRoomBeds2: Int = 10
    var availableOperationRoomBeds2: Int = 0
    var totalIntensiveCareUnitBeds2: Int = 20
    var availableIntensiveCareUnitBeds2: Int = 0
    var totalEmergencyDepartmentBeds2: Int = 15
    var availableEmergencyDepartmentBeds2: Int = 0
    var arrivalRateArray2: [Double] = []
    var processTimeArray2: [Double] = []
    var hospitalAnnotation2: HospitalAnnotation = HospitalAnnotation(title: "St. Mary's Medical Center",
                                                                                     locationName: "Main Campus" ,
                                                                                     discipline: "General Hospital",
                                                                                     rating: 0,
                                                                                     availableMedSurgBeds: 120,
                                                                                     availableOperationRoomBeds: 10,
                                                                                     availableIntensiveCareUnitBeds: 20,
                                                                                     availableEmergencyDepartmentBeds: 15,
                                                                                     coordinate: CLLocationCoordinate2D(latitude: 37.773957, longitude: -122.453568))
    
    // Hospital 3: California Pacific Medical Center
    var day3: Int = 3
    var month3: Int = 8
    var year3: Int = 2018
    var hour3: Int = 9
    var minute3: Int = 0
    var availableBeds3: Int = 34
    var totalMedSurgBeds3: Int = 250
    var availableMedSurgBeds3: Int = 0
    var totalOperationRoomBeds3: Int = 20
    var availableOperationRoomBeds3: Int = 0
    var totalIntensiveCareUnitBeds3: Int = 40
    var availableIntensiveCareUnitBeds3: Int = 0
    var totalEmergencyDepartmentBeds3: Int = 30
    var availableEmergencyDepartmentBeds3: Int = 0
    var arrivalRateArray3: [Double] = []
    var processTimeArray3: [Double] = []
    var hospitalAnnotation3: HospitalAnnotation = HospitalAnnotation(title: "California Pacific Medical Center",
                                                                                     locationName: "California Campus" ,
                                                                                     discipline: "General Hospital",
                                                                                     rating: 0,
                                                                                     availableMedSurgBeds: 250,
                                                                                     availableOperationRoomBeds: 20,
                                                                                     availableIntensiveCareUnitBeds: 40,
                                                                                     availableEmergencyDepartmentBeds: 30,
                                                                                     coordinate: CLLocationCoordinate2D(latitude: 37.786613, longitude: -122.456148))
    
    
    
    
    
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
        
        simulateUser()
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
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 3000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        userLat = location.coordinate.latitude
        userLong = location.coordinate.longitude
        
        //setHospitalLocations()
        
        locationManager.stopUpdatingLocation()
    }
    
    //
    // Purpose: To return to the homepage
    //
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    // Purpose: To hide the city score view
    //
    @IBAction func cancelCityScoreView(_ sender: Any) {
        cityScoreView.isHidden = true
    }
    
    //
    // Purpose: To show city score view
    //
    @IBAction func showCityScoreView(_ sender: Any) {
        cityScoreView.isHidden = false
    }
    
    //
    // Purpose: To simulate user in San Francisco
    //
    func simulateUser() {
        // Place user in San Francisco
        let location: CLLocation = CLLocation(latitude: userLat, longitude: userLong)
        
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
//        let userAnnotation: UserAnnotation = UserAnnotation(title: "",
//                                                            coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
        
        //self.mapView.addAnnotation(userAnnotation)
    }
    
    //
    // Purpose: To simulate map feature with 3 different hospitals displaying information
    //
    func simulateHospitals() {
        // Add hospital annotations
        self.mapView.addAnnotation(hospitalAnnotation1)
        self.mapView.addAnnotation(hospitalAnnotation2)
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
    * Code is ugly but solely for demonstration purposes
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
                
                self.getAvailableBeds(hospital: hospital, capacityUtilization: capacityUtilization)
        }
    }
    
    //
    // Purpose: GET number of Available Beds
    //
    func getAvailableBeds(hospital: Int, capacityUtilization: Double) {
        Alamofire.request("https://emwindow.herokuapp.com/getAvailableBeds",
                          parameters: ["capacityUtilization": capacityUtilization, "totalBeds": totalBeds],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                let availableBeds = value as! Double
                
                if (hospital == 1) {
                    self.availableBeds1 = Int(round(availableBeds))
                } else if (hospital == 2) {
                    self.availableBeds2 = Int(round(availableBeds))
                } else {
                    self.availableBeds3 = Int(round(availableBeds))
                }
                
                self.getEMwindowRating(hospital: hospital, capacityUtilization: capacityUtilization)
                self.updateCityAvailableBeds()
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
                } else if (rating < 1) {
                    rating = 1
                }
                
                // Update annotations with rating
                if (hospital == 1) {
                    if (self.selectedAnnotation != self.hospitalAnnotation1) {
                        let temp: HospitalAnnotation = HospitalAnnotation(title: "UCSF Medical Center",
                                                                          locationName: "Main Campus" ,
                                                                          discipline: "General Hospital",
                                                                          rating: Int(rating),
                                                                          availableMedSurgBeds: Int(Double(self.totalMedSurgBeds1) * (1 - capacityUtilization)),
                                                                          availableOperationRoomBeds: Int(Double(self.totalOperationRoomBeds1) * (1 - capacityUtilization)),
                                                                          availableIntensiveCareUnitBeds: Int(Double(self.totalIntensiveCareUnitBeds1) * (1 - capacityUtilization)),
                                                                          availableEmergencyDepartmentBeds: Int(Double(self.totalEmergencyDepartmentBeds1) * (1 - capacityUtilization)),
                                                                          coordinate: CLLocationCoordinate2D(latitude: 37.763078, longitude: -122.457724))
                        
                        self.mapView.addAnnotation(temp)
                        self.mapView.removeAnnotation(self.hospitalAnnotation1)
                        self.hospitalAnnotation1 = temp
                    } else {
                        self.hospitalAnnotation1.rating = Int(rating)
                    }
                } else if (hospital == 2) {
                    if (self.selectedAnnotation != self.hospitalAnnotation2) {
                        let temp: HospitalAnnotation = HospitalAnnotation(title: "St. Mary's Medical Center",
                                                                                         locationName: "Main Campus" ,
                                                                                         discipline: "General Hospital",
                                                                                         rating: Int(rating),
                                                                                         availableMedSurgBeds: Int(Double(self.totalMedSurgBeds2) * (1 - capacityUtilization)),
                                                                                         availableOperationRoomBeds: Int(Double(self.totalOperationRoomBeds2) * (1 - capacityUtilization)),
                                                                                         availableIntensiveCareUnitBeds: Int(Double(self.totalIntensiveCareUnitBeds2) * (1 - capacityUtilization)),
                                                                                         availableEmergencyDepartmentBeds: Int(Double(self.totalEmergencyDepartmentBeds2) * (1 - capacityUtilization)),
                                                                                         coordinate: CLLocationCoordinate2D(latitude: 37.773957, longitude: -122.453568))
                        
                        self.mapView.addAnnotation(temp)
                        self.mapView.removeAnnotation(self.hospitalAnnotation2)
                        self.hospitalAnnotation2 = temp
                    } else {
                        self.hospitalAnnotation2.rating = Int(rating)
                    }
                } else {
                    self.hospitalAnnotation3.rating = Int(rating)
                    
                    if (self.selectedAnnotation != self.hospitalAnnotation3) {
                        let temp: HospitalAnnotation = HospitalAnnotation(title: "California Pacific Medical Center",
                                                                                         locationName: "California Campus" ,
                                                                                         discipline: "General Hospital",
                                                                                         rating: Int(rating),
                                                                                         availableMedSurgBeds: Int(Double(self.totalMedSurgBeds3) * (1 - capacityUtilization)),
                                                                                         availableOperationRoomBeds: Int(Double(self.totalOperationRoomBeds3) * (1 - capacityUtilization)),
                                                                                         availableIntensiveCareUnitBeds: Int(Double(self.totalIntensiveCareUnitBeds3) * (1 - capacityUtilization)),
                                                                                         availableEmergencyDepartmentBeds: Int(Double(self.totalEmergencyDepartmentBeds3) * (1 - capacityUtilization)),
                                                                                         coordinate: CLLocationCoordinate2D(latitude: 37.786613, longitude: -122.456148))
                        
                        self.mapView.addAnnotation(temp)
                        self.mapView.removeAnnotation(self.hospitalAnnotation3)
                        self.hospitalAnnotation3 = temp
                    } else {
                        self.hospitalAnnotation3.rating = Int(rating)
                    }
                }
                
                self.updateCityScore()
        }
    }
    
    //
    // Purpose: To figure out what hospitals are currently visible by the user
    //
    func hospitalVisible(hospital: Int) -> Bool {
        
        let mRect = self.mapView.visibleMapRect
        
        let neMapPoint = MKMapPoint(x: mRect.maxX, y: mRect.minY)
        let swMapPoint = MKMapPoint(x: mRect.minX, y: mRect.maxY)
        
        let neCoordinate = neMapPoint.coordinate
        let swCoordinate = swMapPoint.coordinate
        
        let maxLat = neCoordinate.latitude
        let maxLong = neCoordinate.longitude
        let minLat = swCoordinate.latitude
        let minLong = swCoordinate.longitude
        
        var lat: CLLocationDegrees
        var long: CLLocationDegrees
        
        if (hospital == 1) {
            lat = hospitalAnnotation1.coordinate.latitude
            long = hospitalAnnotation1.coordinate.longitude
        } else if (hospital == 2) {
            lat = hospitalAnnotation2.coordinate.latitude
            long = hospitalAnnotation2.coordinate.longitude
        } else {
            lat = hospitalAnnotation3.coordinate.latitude
            long = hospitalAnnotation3.coordinate.longitude
        }
        
        return (lat >= minLat && lat <= maxLat && long >= minLong && long <= maxLong)
    }
    
    //
    // Purpose: To calculate the city score
    //
    func updateCityAvailableBeds() {
        
        var totalMedSurgBeds = 0
        var totalOperationRoomBeds = 0
        var totalIntensiveCareUnitBeds = 0
        var totalEmergencyDepartmentBeds = 0
        
        
        if (hospitalVisible(hospital: 1)) {
            totalMedSurgBeds += hospitalAnnotation1.availableMedSurgBeds
            totalOperationRoomBeds += hospitalAnnotation1.availableOperationRoomBeds
            totalIntensiveCareUnitBeds += hospitalAnnotation1.availableIntensiveCareUnitBeds
            totalEmergencyDepartmentBeds += hospitalAnnotation1.availableEmergencyDepartmentBeds
        }
        
        if (hospitalVisible(hospital: 2)) {
            totalMedSurgBeds += hospitalAnnotation2.availableMedSurgBeds
            totalOperationRoomBeds += hospitalAnnotation2.availableOperationRoomBeds
            totalIntensiveCareUnitBeds += hospitalAnnotation2.availableIntensiveCareUnitBeds
            totalEmergencyDepartmentBeds += hospitalAnnotation2.availableEmergencyDepartmentBeds
        }
        
        if (hospitalVisible(hospital: 3)) {
            totalMedSurgBeds += hospitalAnnotation3.availableMedSurgBeds
            totalOperationRoomBeds += hospitalAnnotation3.availableOperationRoomBeds
            totalIntensiveCareUnitBeds += hospitalAnnotation3.availableIntensiveCareUnitBeds
            totalEmergencyDepartmentBeds += hospitalAnnotation3.availableEmergencyDepartmentBeds
        }
        
        cityAvailableMedSurgBeds.text = String(totalMedSurgBeds)
        cityAvailableOperationRoomBeds.text = String(totalOperationRoomBeds)
        cityAvailableIntensiveCareUnitBeds.text = String(totalIntensiveCareUnitBeds)
        cityAvailableEmergencyDepartmentBeds.text = String(totalEmergencyDepartmentBeds)
    }
    
    //
    // Purpose: To calculate the city score
    //
    func updateCityScore() {
        var sum = 0
        var count = 0
        
        if (hospitalVisible(hospital: 1)) {
            sum += hospitalAnnotation1.rating
            count += 1
        }
        
        if (hospitalVisible(hospital: 2)) {
            sum += hospitalAnnotation2.rating
            count += 1
        }
        
        if (hospitalVisible(hospital: 3)) {
            sum += hospitalAnnotation3.rating
            count += 1
        }
        
        var average = 0
        
        if (count != 0) {
            average = sum / count
        }
        
        cityScoreLabel.text = String(average)
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
                    
                    let hospitalAnnotation = HospitalAnnotation(title: name,
                                          locationName: "\(locationName)\(type)" ,
                                          discipline: type,
                                          rating: 0,
                                          availableMedSurgBeds: 0,
                                          availableOperationRoomBeds: 0,
                                          availableIntensiveCareUnitBeds: 0,
                                          availableEmergencyDepartmentBeds: 0,
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
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        // Set users simulated location with custom annotation
        if ((annotation as? UserAnnotation) != nil) {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.markerTintColor = UIColor.blue
            view.glyphImage = UIImage(named: "user")

            return view
        }
        
        guard let annotation = annotation as? HospitalAnnotation else { return nil }

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
        view.subtitleVisibility = MKFeatureVisibility.visible
        
        return view
    }
    
    // Know which callout user has selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // If user is selected than set selected annotation as another hospital so all hospitals refresh ratings
        let otherHospitalAnnotation: HospitalAnnotation = HospitalAnnotation(title: "Other",
                                                                             locationName: "Other" ,
                                                                             discipline: "Other",
                                                                             rating: 0,
                                                                             availableMedSurgBeds: 0,
                                                                             availableOperationRoomBeds: 0,
                                                                             availableIntensiveCareUnitBeds: 0,
                                                                             availableEmergencyDepartmentBeds: 0,
                                                                             coordinate: CLLocationCoordinate2D(latitude: 30, longitude: -120))
        
        
        self.selectedAnnotation = view.annotation as? HospitalAnnotation ?? otherHospitalAnnotation
    }
    
    // Takes user to Apple Maps app when user taps info button on callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! HospitalAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
