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
        TMD.start()
        self.askLocationPermissions()
        self.askMotionPermissions()
        
    }
    
    var delegate:MoprimAPIDelegate?
    let locationManager = CLLocationManager()
    let motionActivityManager = CMMotionActivityManager()
    let apiKey = "V8G_ZWvdUkAcrIeo8sJGwnSX3p9A5EY9R4pKJF3KfeA"
    
    
    
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
    
    func fetchData(){
        let date = Date()
        TMDCloudApi.fetchData(date, minutesOffset: 0).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
            
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                }
                return
            }
        }
        TMDCloudApi.fetchMetadata().continueWith{(task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error{
                    NSLog(error.localizedDescription)
                }else if let metadata = task.result{
                    self.delegate?.fetchMoprimData(data: metadata)
                    NSLog("metadata %@", metadata)
                }
                return
            }
        }
    }
    
    func test(){
        guard let origin = locationManager.location else{return}
        let destination = CLLocation(latitude: 60.18784, longitude: 24.96250)
        
        TMDCloudApi.generateSyntheticData(withOriginLocation: origin, destination: destination, requestType: TMDSyntheticRequestType.bicycle, hereApiKey: apiKey)
        
    }
    
    func stop(){
        TMD.stop()
    }
    


    
    
    
    
}
//TODO: MAKE A STRUCT FOR CORE DATA
//struct moprimData {}

protocol MoprimAPIDelegate{
    func fetchMoprimData(data:TMDCloudMetadata)
    
}
