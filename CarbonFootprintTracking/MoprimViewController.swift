//
//  MoprimViewController.swift
//  CarbonFootprintTracking
//
//  Created by Георгий on 28.04.2021.
//

import UIKit
import MOPRIMTmdSdk

class MoprimViewController: UIViewController, MoprimAPIDelegate{
    
    func fetchMoprimData(data: [TMDActivity]) {
        var str = ""
        for activity in data{
            let timestamp = Date(timeIntervalSince1970: TimeInterval(activity.timestampEnd))
            str.append("\nActivity:\(activity.activity()), Co2:\(activity.co2), Ended at:\(timestamp)")
        }
    
        moprimData.text = "there are \(data.count) activities. Last: \(data.last!.activity())"
    }
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var moprimData: UILabel!
    
    @IBOutlet weak var SendData: UIButton!
    @IBOutlet weak var GetData: UIButton!
    @IBOutlet weak var StopApi: UIButton!
    @IBOutlet weak var SendRealData: UIButton!
    
    private var exampleLocation: CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 60.187784, longitude: 24.96044), altitude: 500, horizontalAccuracy: kCLLocationAccuracyBestForNavigation, verticalAccuracy: kCLLocationAccuracyBestForNavigation, course: 90, courseAccuracy: kCLLocationAccuracyKilometer, speed: 15, speedAccuracy: kCLLocationAccuracyBestForNavigation, timestamp: Date())
    
    private var exampleTransport: [TMDSyntheticRequestType] = [TMDSyntheticRequestType.car, TMDSyntheticRequestType.bicycle]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.moprimApi.delegate = self
    }

    @IBAction func send(_ sender: Any) {
       // appDelegate.moprimApi.uploadData(controller: self)
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.bicycle, destination: exampleLocation, controller: self)
        
    }
    @IBAction func get(_ sender: Any) {
        appDelegate.moprimApi.updateViewForCurrentDate()
        
    
    }
    @IBAction func stop(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.car, destination: exampleLocation, controller: self)
    }
    @IBAction func sendRealData(_ sender: Any) {
        appDelegate.moprimApi.uploadData(controller: self)
    }
}
