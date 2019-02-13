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

class HospitalInfo: UIViewController {

    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hourArrivalRateLabel: UILabel!
    @IBOutlet weak var averageProcessTimeLabel: UILabel!
    @IBOutlet weak var capacityUtilizationLabel: UILabel!
    @IBOutlet weak var availableBedsEDLabel: UILabel!
    @IBOutlet weak var availableBedsHLabel: UILabel!
    @IBOutlet weak var availableBedsCCLabel: UILabel!
    @IBOutlet weak var availableBedsORLabel: UILabel!
    @IBOutlet weak var emWindowRatingLabel: UILabel!
    
    var hospital: String = "SanFrancisco"
    var hod: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        hospitalNameLabel.text = hospital + " Hospital"
        calculateHospitalInfo()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func calculateHospitalInfo() {
        Alamofire.request("https://emwindow.herokuapp.com/hospitalInformation",
                          parameters: ["hospital": hospital, "hod": hod],
                          headers: ["Content-type": "application/x-www-form-urlencoded"])
            
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                let json = value as! NSDictionary
                
                self.hourArrivalRateLabel.text = json.object(forKey: "hourArrivalRate") as? String
                self.averageProcessTimeLabel.text = json.object(forKey: "averageProcessTime") as? String
                self.capacityUtilizationLabel.text = json.object(forKey: "capacityUtilization") as? String
                
                self.availableBedsEDLabel.text = json.object(forKey: "availableBeds") as? String
                self.availableBedsHLabel.text = json.object(forKey: "availableBeds") as? String
                self.availableBedsCCLabel.text = json.object(forKey: "availableBeds") as? String
                self.availableBedsORLabel.text = json.object(forKey: "availableBeds") as? String
                
                self.emWindowRatingLabel.text = json.object(forKey: "emWindowRating") as? String
                self.setEmWindowRatingBackground(emWindowRating: Int((json.object(forKey: "emWindowRating") as? String)!)!)
        }
    }
    
    func setEmWindowRatingBackground(emWindowRating: Int) {
        if (emWindowRating <= 50) {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.90, green:0.26, blue:0.26, alpha:1.0)
        } else if (emWindowRating <= 75) {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.90, green:0.83, blue:0.26, alpha:1.0)
        } else {
            self.emWindowRatingLabel.backgroundColor = UIColor(red:0.27, green:0.90, blue:0.29, alpha:1.0)
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        loadData()
    }
}

