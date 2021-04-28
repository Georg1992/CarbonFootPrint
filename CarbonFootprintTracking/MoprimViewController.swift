//
//  MoprimViewController.swift
//  CarbonFootprintTracking
//
//  Created by Георгий on 28.04.2021.
//

import UIKit
import MOPRIMTmdSdk

class MoprimViewController: UIViewController, MoprimAPIDelegate {
    
    
    
    func fetchMoprimData(data: TMDCloudMetadata) {
        moprimData.text = data.description
    }
    

    @IBOutlet weak var moprimData: UILabel!
    
    @IBOutlet weak var SendData: UIButton!
    @IBOutlet weak var GetData: UIButton!
    @IBOutlet weak var StopApi: UIButton!
    
    let moprimApi = MoprimAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moprimApi.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func send(_ sender: Any) {
        moprimApi.test()
    }
    @IBAction func get(_ sender: Any) {
        moprimApi.fetchData()
    }
    @IBAction func stop(_ sender: Any) {
        moprimApi.stop()
    }
}
