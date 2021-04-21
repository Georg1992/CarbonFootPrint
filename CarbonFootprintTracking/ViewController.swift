//
//  ViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 14.4.2021.
//

import UIKit
import CoreLocation
import MOPRIMTmdSdk

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
        
        func askLocationPermissions() {
            self.locationManager.delegate = self
            self.locationManager.requestAlwaysAuthorization()
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if #available(iOS 14.0, *) {
                let preciseLocationAuthorized = (manager.accuracyAuthorization == .fullAccuracy)
                if preciseLocationAuthorized == false {
                    manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "tmd.AccurateLocationPurpose")
                    // Note that this will only ask for TEMPORARY precise location.
                    // You should make sure to ask your user to keep the Precise Location turned on in the Settings.
                }
            } else {
                // No need to ask for precise location before iOS 14
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        TMD.start()
        // Do any additional setup after loading the view.
        
    }


}

