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
import UIKit

class MoprimAPI : NSObject, CLLocationManagerDelegate{
    override init() {
        super.init()
        self.dateFormater.dateStyle = .short
        self.askLocationPermissions()
        self.askMotionPermissions()
        TMD.setAllowUploadOnCellularNetwork(true)
        }
    var fetchedDayActivities: [TMDActivity] = []
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
    
<<<<<<< HEAD
    func fetchData(){
        
        let isoDate = "2021-04-25T10:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        
        TMDCloudApi.fetchData(date, minutesOffset: 0).continueWith { (task) -> Any? in
=======
    func updateContextForCurrentDate() {
        if (TMD.isInitialized() == false) {
            print("TMD NOT INITIALIZED")
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
                if(cachedActivities.count != self.fetchedDayActivities.count){
                DispatchQueue.main.async{
                    self.fetchedDayActivities.removeAll()
                    if let arr = task.result {
                        for activity in (arr as! [TMDActivity]) {
                            self.fetchedDayActivities.append(activity)
                        }
                    }
                    else if task.error != nil {
                        for activity in cachedActivities {
                            self.fetchedDayActivities.append(activity)
                        }
                    }
                    
                    NSLog("We got %d activities for date: \(self.dateFormater.string(from: self.currentDate))", self.fetchedDayActivities.count )
                    
                    self.feedMoprimStruct()
                    
                }
                }else{
                    print("No Activities To Fetch")
                }
                return task;
            }
        }
        
    }
    
    func feedMoprimStruct(){
        print("feeding moprim struct")
        var moprimData:[MoprimData] = []
        for activity in self.fetchedDayActivities{
            let data = MoprimData(activity: activity.activity(), co2: activity.co2, date: self.dateFormater.string(from: self.currentDate), duration: activity.duration(), timestampStart: activity.timestampStart)
            moprimData.append(data)
            print("MoprimData array: \(moprimData)")
            }
       self.delegate?.fetchMoprimData(data: moprimData)
    }
    
    
    func uploadData(controller: UIViewController) {
        NSLog("Uploading data")
        TMDCloudApi.uploadData().continueWith { (task) -> Any? in
>>>>>>> main
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
        print("Location: \(String(describing: locationManager.location))")
        TMDCloudApi.generateSyntheticData(withOriginLocation:CLLocation(latitude: 60.184584, longitude: 24.92444) , destination: destination, requestType: transport, hereApiKey: apiKey).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                let alert : UIAlertController
                if let error = task.error {
                    NSLog("Error while uploading: %@", error.localizedDescription)
                    alert = UIAlertController.init(title: "Upload Error", message: error.localizedDescription, preferredStyle: .alert)
                }
                else if let metadata = task.result {
                   alert = UIAlertController.init(title: "Upload success", message: nil, preferredStyle: .alert)
                        NSLog("Uploading: %@", metadata)
                    
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
    
    
    
}
//TODO: MAKE A STRUCT FOR CORE DATA
struct MoprimData {
    var activity:String
    var co2:Double
    var date:String
    var duration: Double
    var timestampStart:Int64
}

protocol MoprimAPIDelegate{
    func fetchMoprimData(data:[MoprimData])
    
}
