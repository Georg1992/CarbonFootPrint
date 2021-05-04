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

class MoprimAPI : NSObject, CLLocationManagerDelegate, TMDDelegate{
    override init() {
        super.init()
        self.dateFormater.dateStyle = .short
        self.askLocationPermissions()
        self.askMotionPermissions()

        TMD.setDelegate(self)
        TMD.setAllowUploadOnCellularNetwork(true)
        TMD.start()
    }
    private var activities: [TMDActivity] = []
    private let transportTypes = ["stationary",
                              "non-motorized/pedestrian/walk",
                              "non-motorized/pedestrian/run",
                              "non-motorized/bicycle",
                              "motorized/road/bus",
                              "motorized/road/car",
                              "motorized/rail/metro",
                              "motorized/rail/tram",
                              "motorized/rail/train",
                              "motorized/water/ferry",
                              "motorized/air/plane"]
    let dateFormater = DateFormatter()
    private let currentDate:Date = Date()
    private var timer: Timer = Timer()
    
    
    var delegate:MoprimAPIDelegate?
    let locationManager = CLLocationManager()
    let motionActivityManager = CMMotionActivityManager()
    
    //Used for synthetic activities
    let apiKey = "V8G_ZWvdUkAcrIeo8sJGwnSX3p9A5EY9R4pKJF3KfeA"
    
    func askMotionPermissions() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                //print("received motion activity")
                self.motionActivityManager.stopActivityUpdates()
            }
        }
    }
    func askLocationPermissions() {
            self.locationManager.delegate = self
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
                let preciseLocationAuthorized = (manager.accuracyAuthorization == .fullAccuracy)
                if preciseLocationAuthorized == false {
                    manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "tmd.AccurateLocationPurpose")
                }
            } else {
                // No need to ask for precise location before iOS 14
            }
        }
    
    func updateViewForCurrentDate() {
        if (TMD.isInitialized() == false) {
            return
        }
        var cachedActivities: [TMDActivity] = [];
        TMDCloudApi.fetchDataFromCache(self.currentDate, minutesOffset: 0.0).continueOnSuccessWith { (cacheTask) -> Any? in
            NSLog("Fetched cached activities")
            if let arr = cacheTask.result {
                cachedActivities = (arr as! [TMDActivity])
            }
            return cacheTask;
            }.continueOnSuccessWith { (task) -> Any? in
                TMDCloudApi.fetchData(self.currentDate, minutesOffset: 0.0).continueWith { (task) -> Any? in
                    DispatchQueue.main.async{
                        self.activities.removeAll()
                        if let arr = task.result {
                            for activity in (arr as! [TMDActivity]) {
                                self.activities.append(activity)
                            }
                        }
                        else if task.error != nil {
                            for activity in cachedActivities {
                                self.activities.append(activity)
                            }
                        }
                        
                        NSLog("We got %d activities for date: \(self.dateFormater.string(from: self.currentDate))", self.activities.count )
                       self.delegate?.fetchMoprimData(data: self.activities)
            
                    }
                    return task;
                }
        }
        
    }
    
    
    func uploadData(controller: UIViewController) {
        NSLog("Uploading data")
        TMDCloudApi.uploadData().continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                let alert : UIAlertController
                if let error = task.error {
                    NSLog("Error while uploading: %@", error.localizedDescription)
                    alert = UIAlertController.init(title: "Upload Error", message: error.localizedDescription, preferredStyle: .alert)
                }
                else if let metadata = task.result {
                    if (metadata.nbLocations + metadata.nbTmdSequences == 0) {
                        NSLog("Nothing to upload")
                        alert = UIAlertController.init(title: "Nothing to upload", message: nil, preferredStyle: .alert)
                    }
                    else {
                        alert = UIAlertController.init(title: "Upload success", message: nil, preferredStyle: .alert)
                        NSLog("Successfully uploading: %@", metadata.description())
                    }
                }
                else {
                    alert = UIAlertController.init(title: "Upload Error", message: "No metadata was returned", preferredStyle: .alert)
                }
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }
            return nil;
        }
    }
    
    func uploadSyntheticData(transport: TMDSyntheticRequestType, destination: CLLocation, controller: UIViewController) {
        NSLog("Uploading data")
        guard let currentLoaction = locationManager.location else{
            print("Cant find location")
            return
            }
        TMDCloudApi.generateSyntheticData(withOriginLocation:currentLoaction , destination: destination, requestType: transport, hereApiKey: apiKey).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                let alert : UIAlertController
                if let error = task.error {
                    NSLog("Error while uploading: %@", error.localizedDescription)
                    alert = UIAlertController.init(title: "Upload Error", message: error.localizedDescription, preferredStyle: .alert)
                }
                else if let metadata = task.result {
                   alert = UIAlertController.init(title: "Upload success", message: nil, preferredStyle: .alert)
                        NSLog("Successfully uploading: %@", metadata)
                }
                else {
                    alert = UIAlertController.init(title: "Upload Error", message: "No metadata was returned", preferredStyle: .alert)
                }
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }
            return nil;
        }
    }
    
    
    @objc func updateTmdStatusLabel(label: UILabel) {
        if TMD.isOff() {
            label.text = "TMD is off"
        }
        else if TMD.isIdle() {
            label.text = "TMD is idle"
        }
        else if TMD.isRunning() {
            label.text = String(format: "TMD is running for %@",
                                         secondsToString(seconds: TMD.getRunningTime()))
        }
    }
    
    func secondsToString(seconds: Double) -> String {
        
        if (seconds.isNaN) {
            return "Nan"
        }
        let isNegative = seconds < 0;
        
        let s = Int(seconds.rounded()) % 60;
        var m = Int(seconds.rounded()) / 60;
        let h = m / 60;
        m = m % 60;
        if (h != 0) {
            return String.init(format: "%@%dh%02dm%02ds", isNegative ? "-" : "", h, m, s);
        } else if (m != 0) {
            return String.init(format: "%@%dm%02ds", isNegative ? "-" : "", m, s);
        } else {
            return String.init(format: "%@%ds", isNegative ? "-" : "", s);
        }
    }
    
    func stopTMD(){
        TMD.stop()
    }
    


    
    
    
    
}
//TODO: MAKE A STRUCT FOR CORE DATA
//struct moprimData {}

protocol MoprimAPIDelegate{
    func fetchMoprimData(data:[TMDActivity])
    
}
