//
//  HospitalInfoSettings.swift
//  EMwindow
//
//  Created by Sam Hollingsworth on 11/4/18.
//  Copyright © 2018 CareTrails. All rights reserved.
//

import UIKit

class HospitalInfoSettings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timeIntervalPicker: UIPickerView!
    
    let pickerData = ["1", "5", "10", "15", "30", "45", "60"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeIntervalPicker.delegate = self
        timeIntervalPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        let newTimeInterval = Int(pickerData[row])!
        
        HospitalInfo().stopTimer()
        HospitalInfo().startTimer(interval: newTimeInterval)
    }
    
}
