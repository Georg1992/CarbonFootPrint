//
//  ViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 14.4.2021.
//

import UIKit
import CoreLocation
import CoreMotion


class ViewController: UIViewController, CLLocationManagerDelegate, MoprimAPIDelegate {
    
    @IBOutlet weak var TEST: UILabel!
    
    var moprimAPI = MoprimAPI()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    func fetchMoprimData(data: moprimData) {
        
    }


}

