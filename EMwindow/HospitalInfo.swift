//
//  ViewController.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 5/19/18.
//  Copyright © 2018 CareTrails. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts

class HospitalInfo: UIViewController {

    // LABELS
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourArrivalRateLabel: UILabel!
    @IBOutlet weak var averageProcessTimeLabel: UILabel!
    @IBOutlet weak var capacityUtilizationLabel: UILabel!
    @IBOutlet weak var availableBedsEDLabel: UILabel!
    @IBOutlet weak var emWindowRatingLabel: UILabel!
    @IBOutlet weak var timeSelecter: UISlider!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var clinicalLoadLabel: UILabel!
    
    // VARIABLES
    var day: Int = 1
    var month: Int = 8
    var year: Int = 2018
    var hour: Int = 9
    var minute: Int = 0
    var hospital: String = "Columbus General Hospital"
    var hospitalNoSpaces: String = ""
    var totalBeds: Int = 34
    var capacityUtilization: Double = 0
    var capacityUtilizationArrayGraph: [Double] = []                            // Had to add this in order to graph the capacity utilizations
    var arrivalRateArray: [Double] = []
    var arrivalRateArrayGraph: [Double] = []                                    // Had to add this in order to graph the arrival rates
    var processTimeArray: [Double] = []
    var processTimeArrayGraph: [Double] = []                                    // Had to add this in order to graph the process times
    var clinicalLoadArray: [Double] = []
    var clinicalLoadArrayGraph: [Double] = []                                   // Had to add this in order to graph the clinical load
    var ratingsArray: [Double] = []
    
    var timeUpdater = Timer()
    var defaultTimeInterval: Int = 2
    
    //
    // Purpose: Once view has loaded, start data stream
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        timeSelecter.isContinuous = false //Updates time when slider stops
        
        hospitalNoSpaces = hospital.replacingOccurrences(of: " ", with: "")
        
        startTimer(interval: defaultTimeInterval)
        
        displayTime()
        loadData()
    }
    
    //
    // Purpose: Start timer
    //
    public func startTimer(interval: Int) {
        timeUpdater = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(HospitalInfo.updateTime), userInfo: nil, repeats: true)
    }
    
    //
    // Purpose: Stop timer
    //
    public func stopTimer() {
        timeUpdater.invalidate()
        day = 1
        month = 8
        year = 2018
        hour = 9
        minute = 0
    }
    
    //
    // Purpose: Increase time by 1 minute
    //
    @objc func updateTime() {
        minute += 1
        
        if (minute == 60) {
            minute = 0
            hour += 1
            timeSelecter.value += 1
            
            if (hour == 24) {
                hour = 0
                day += 1
            }
        }
        
        displayTime()
        loadData()
    }
    
    //
    // Purpose: Print the time on the screen
    //
    func displayTime() {
        var minuteLabel = ""
        if (minute < 10) {
            minuteLabel = "0\(minute)"
        } else {
            minuteLabel = "\(minute)"
        }
        
        timeLabel.text = "\(month)/\(day)/\(year) \(hour):\(minuteLabel)"
    }
    
    //
    // Purpose: Update time from slider
    //
    @IBAction func selectTime(_ sender: UISlider) {
        let selectedTime = Int(sender.value)
        let plusHour = selectedTime % 24
        let plusDay = selectedTime / 24
        
        if (9 + plusHour) > 23 {
            day = 2 + plusDay
            hour = (9 + plusHour) % 24
        } else {
            day = 1 + plusDay
            hour = 9 + plusHour
        }
        minute = 0
        
        displayTime()
        loadData()
    }
    
    //
    // Purpose: To return to the home page
    //
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    // Purpose: Load data
    //
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
        getArrivalRateArray()
        getProcessTimeArray()
        getCapacityUtilization()
        getClinicalLoadArray()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //
    // Purpose: GET arrival rate array
    //
    func getArrivalRateArray() {
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
                
                self.arrivalRateArray = (value as! NSArray) as! [Double]
                self.arrivalRateArrayGraph.append(self.arrivalRateArray[0])
                self.hourArrivalRateLabel.text = "\(String(self.arrivalRateArray[0])) per hour"
        }
    }
    
    //
    // Purpose: GET Process Time Array
    //
    func getProcessTimeArray() {
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
                
                // reset array since times are appended to list
                self.processTimeArray = []
                
                for time in timesArray {
                    if let n = time as? NSNumber {
                        var time = n.doubleValue
                        
                        if (time < 0) {
                            print(time)
                            time = time * -1
                            print(time)
                        }
                        
                        self.processTimeArray.append(time)
                    }
                    
                }
                
                let truncated = self.truncateDouble(decimalNum: self.processTimeArray[0])
                self.processTimeArrayGraph.append(truncated)
                self.averageProcessTimeLabel.text = "\(String(truncated)) hours"
        }
    }
    
    //
    // Purpose: GET Capacity Utilization
    //
    func getCapacityUtilization() {
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
                
                self.capacityUtilization = (value as! NSNumber) as! Double
                let truncated = self.truncateDouble(decimalNum: (self.capacityUtilization * 100))
                self.capacityUtilizationLabel.text = "\(String(truncated)) %"
                self.capacityUtilizationArrayGraph.append(truncated)
                
                self.getAvailableBeds()
        }
    }
    
    //
    // Purpose: GET number of Available Beds
    //
    func getAvailableBeds() {
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
                
                self.availableBedsEDLabel.text = String(Int(round(availableBeds)))
        }
    }
    
    //
    // Purpose: GET arrival rate array
    //
    func getClinicalLoadArray() {
        Alamofire.request("https://emwindow.herokuapp.com/getClinicalLoadArray",
                          parameters: ["hospital": hospitalNoSpaces, "month": month,
                                       "day": day, "year": year, "hour": hour, "minute": minute],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                                
                self.clinicalLoadArray = (value as! NSArray) as! [Double]
                self.clinicalLoadArrayGraph.append(self.clinicalLoadArray[0])
                let truncated = self.truncateDouble(decimalNum: (self.clinicalLoadArray[0]))
                self.clinicalLoadLabel.text = "\(String(truncated)) %"
                
                print("Clinical Load: \(self.clinicalLoadArray[0])")
                self.getEMwindowRating()
        }
    }
    
    //
    // Purpose: GET Rating
    //
    func getEMwindowRating() {
        Alamofire.request("https://emwindow.herokuapp.com/getEMwindowRating",
                          parameters: ["arrivalRateArray": JSON(arrivalRateArray), "processTimeArray": JSON(processTimeArray), "capacityUtilization": capacityUtilization, "clinicalLoadArray": JSON(clinicalLoadArray)],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                var rating = value as! Double
                //rating = floor(rating)
                
                if (rating > 100) {
                    rating = 100;
                }
                
                self.ratingsArray.append(rating)
                
                self.emWindowRatingLabel.text = String(rating)
                self.emWindowRatingLabel.text = String(format: "%.0f", rating)
                //self.setEmWindowRatingBackground(emWindowRating: rating)
                self.updateGraph()
        }
    }
    
    //
    // Purpose: Set color of Rating background
    //
    func setEmWindowRatingBackground(emWindowRating: Double) {
        if (emWindowRating <= 50) {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.27, green:0.90, blue:0.29, alpha:1.0)
        } else if (emWindowRating <= 75) {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.90, green:0.83, blue:0.26, alpha:1.0)
        } else {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.90, green:0.26, blue:0.26, alpha:1.0)
        }
    }
    
    //
    // Purpose: Truncate a double
    //
    func truncateDouble(decimalNum: Double) -> Double {
        return Double(floor(100 * decimalNum) / 100)
    }
    
    //
    // Purpose: Update the graph of the Ratings
    //
    func updateGraph() {
        
        // Create first line for ratings
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<ratingsArray.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: ratingsArray[i]))
        }

        let line1 = LineChartDataSet(values: yVals1, label: "Rating")
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.1
        line1.lineWidth = 3.0
        line1.drawCirclesEnabled = false
        line1.fillColor = NSUIColor.blue
        line1.drawFilledEnabled = false
        
        line1.colors = [NSUIColor.blue]
        lineChart.noDataText = "No data is currently available"
        
        // Create second line for arrival rates
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<arrivalRateArrayGraph.count {
            yVals2.append(ChartDataEntry(x: Double(i), y: arrivalRateArrayGraph[i]))
        }
        
        let line2 = LineChartDataSet(values: yVals2, label: "Rating")
        line2.mode = .cubicBezier
        line2.cubicIntensity = 0.1
        line2.lineWidth = 3.0
        line2.drawCirclesEnabled = false
        line2.fillColor = NSUIColor.red
        line2.drawFilledEnabled = false
        
        line2.colors = [NSUIColor.red]
        lineChart.noDataText = "No data is currently available"
       
        // Create third line for process time
        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<processTimeArrayGraph.count {
            yVals3.append(ChartDataEntry(x: Double(i), y: processTimeArrayGraph[i]))
        }
        
        let line3 = LineChartDataSet(values: yVals3, label: "Rating")
        line3.mode = .cubicBezier
        line3.cubicIntensity = 0.1
        line3.lineWidth = 3.0
        line3.drawCirclesEnabled = false
        line3.fillColor = NSUIColor.yellow
        line3.drawFilledEnabled = false
        
        line3.colors = [NSUIColor.yellow]
        lineChart.noDataText = "No data is currently available"
        
        // Create fourth line for capacity utilization
        var yVals4 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<capacityUtilizationArrayGraph.count {
            yVals4.append(ChartDataEntry(x: Double(i), y: capacityUtilizationArrayGraph[i]))
        }
        
        let line4 = LineChartDataSet(values: yVals4, label: "Rating")
        line4.mode = .cubicBezier
        line4.cubicIntensity = 0.1
        line4.lineWidth = 3.0
        line4.drawCirclesEnabled = false
        line4.fillColor = NSUIColor.blue
        line4.drawFilledEnabled = false
        
        line4.colors = [NSUIColor.green]
        lineChart.noDataText = "No data is currently available"

        // Create fifth line for clinical Load
        var yVals5 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0..<clinicalLoadArrayGraph.count {
            yVals5.append(ChartDataEntry(x: Double(i), y: clinicalLoadArrayGraph[i]))
        }
        
        let line5 = LineChartDataSet(values: yVals5, label: "Rating")
        line5.mode = .cubicBezier
        line5.cubicIntensity = 0.1
        line5.lineWidth = 3.0
        line5.drawCirclesEnabled = false
        line5.fillColor = NSUIColor.blue
        line5.drawFilledEnabled = false
        
        line5.colors = [NSUIColor.magenta]
        lineChart.noDataText = "No data is currently available"
        
        
        //Create object that will be added to lineChart
        let data = LineChartData()
        // Add line1 to data
        data.addDataSet(line1)
        data.addDataSet(line2)
        data.addDataSet(line3)
        data.addDataSet(line4)
        data.addDataSet(line5)
        // Add data to lineChart
        lineChart.data = data
        
        // Set restrictions on chart
        lineChart.data?.setDrawValues(false)
        lineChart.setVisibleXRangeMaximum(60)
        lineChart.moveViewToX(90)
        //lineChart.setVisibleYRange(minYRange: 0.0, maxYRange: 105.0, axis: YAxis.AxisDependency.left)
        lineChart.xAxis.labelPosition = .bottom
        lineChart.legend.enabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        
//        if (capacityUtilization > 80) {
//            lineChart.setVisibleYRange(minYRange: 0.0, maxYRange: 100.0, axis: YAxis.AxisDependency.left)
//        } else if (capacityUtilization > 60) {
//            lineChart.setVisibleYRange(minYRange: 0.0, maxYRange: 80.0, axis: YAxis.AxisDependency.left)
//        } else if (capacityUtilization > 40) {
//            lineChart.setVisibleYRange(minYRange: 0.0, maxYRange: 60.0, axis: YAxis.AxisDependency.left)
//        } else {
//            lineChart.setVisibleYRange(minYRange: 0.0, maxYRange: 40.0, axis: YAxis.AxisDependency.left)
//        }
        
        if (ratingsArray.count < 60) {
            lineChart.moveViewToX(0.0)
        } else {
            lineChart.moveViewToX(Double(ratingsArray.count - 60))
        }
      
        
    }

    
    
    
    
    
    
    
    
    
    
    
//
// Purpose: To get the number of hospital beds in a hospital
//
//    func getTotalHospitalBeds() {
//        var hospitalRequestName: String = "NAME%20like%20%27%25"
//        hospitalRequestName = hospitalRequestName + hospital.replacingOccurrences(of: " ", with: "%20")
//        hospitalRequestName =  hospitalRequestName + "%25%27"
//
//        let outFields: String = "BEDS"
//
//        Alamofire.request("https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals/FeatureServer/0/query?where=\(hospitalRequestName)&outFields=\(outFields)&outSR=4326&f=json",
//            headers: ["Content-type": "application/x-www-form-urlencoded"])
//
//            .responseJSON { response in
//                guard response.result.isSuccess,
//                    let value = response.result.value else {
//                        print("Error while fetching tags: \(String(describing: response.result.error))")
//                        return
//                }
//
//                let json = JSON(value)
//                self.totalBeds = Int((json["features"][0]["attributes"]["BEDS"]).stringValue)!
//        }
//    }
    
}

