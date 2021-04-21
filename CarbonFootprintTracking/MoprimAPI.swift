//
//  MoprimAPI.swift
//  CarbonFootprintTracking
//
//  Created by Георгий on 21.04.2021.
//

import Foundation
import MOPRIMTmdSdk
import CoreMotion
import CoreLocation

class MoprimAPI : NSObject, CLLocationManagerDelegate{
    override init() {
        super.init()
        self.askLocationPermissions()
        self.askMotionPermissions()
        TMD.start()
    }
    
    var delegate:MoprimAPIDelegate?
    
    let locationManager = CLLocationManager()
    
    let motionActivityManager = CMMotionActivityManager()
    
    func askMotionPermissions() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                print("received motion activity")
                self.motionActivityManager.stopActivityUpdates()
            }
        }
    }
        
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
    
    
    
}

struct moprimData {
    
}

protocol MoprimAPIDelegate{
    func fetchMoprimData(data:moprimData)
    
}
