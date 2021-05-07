///
//  MoprimViewController.swift
//  CarbonFootprintTracking
//
//  Created by Георгий on 28.04.2021.
//

import UIKit
import MOPRIMTmdSdk
import CoreData

class MoprimViewController: UIViewController,  UITableViewDelegate,UITableViewDataSource, TMDDelegate, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var TMDswitch: UISwitch!
    @IBOutlet weak var TMDlabel: UILabel!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var bicycleButton: UIButton!
    @IBOutlet weak var getDataButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var fetchedResultsController:NSFetchedResultsController<Activity>?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = AppDelegate.viewContext
    
    let exampleLocation: CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 60.187750, longitude: 24.93041), altitude: 51, horizontalAccuracy: 1, verticalAccuracy: 1, course: 50, speed: 120, timestamp: Date())
    let exampleLocation2: CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 60.160781, longitude: 24.98040), altitude: 51, horizontalAccuracy: 5, verticalAccuracy: 1, course: 45, speed: 20, timestamp: Date())
    
    let exampleLocation3: CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 58.179714, longitude: 25.96044), altitude: 51, horizontalAccuracy: 5, verticalAccuracy: 2, course: 30, speed: 15, timestamp: Date())
    
    let origin: CLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 60.179714, longitude: 24.96044), altitude: 51, horizontalAccuracy: 5, verticalAccuracy: 2, course: 30, speed: 0, timestamp: Date())
    
    
    private let refreshControl = UIRefreshControl()
    private var timer: Timer = Timer()
    private var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchToResults()
        TMD.setAllowUploadOnCellularNetwork(true)
        TMD.setDelegate(self)
        NSLog(TMD.isOn() ? "TMD is ON" : "TMD is OFF")
        
        self.TMDswitch.setOn(!TMD.isOff(), animated: true)
        if (TMD.isOn()){ // TMD is already running, update the UI accordingly
           self.didStart()
       }
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)


        if (TMD.isInitialized()){
            appDelegate.moprimApi.updateContextForCurrentDate()
        }
        else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didInitTMD(notification:)), name: appDelegate.didInitializeTMD, object: nil)
        }
    }
    
    @objc func didInitTMD(notification: Notification){
        NSLog("didInitTMD")
        appDelegate.moprimApi.updateContextForCurrentDate()
        fetchToResults()
    }
    
    
    
    @IBAction func goByCar(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.car, origin: origin, destination: exampleLocation, controller: self)
    }
    @IBAction func goByBicycle(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.bicycle, origin: exampleLocation, destination: exampleLocation2, controller: self)
    }
   
    
    @IBAction func getData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
            appDelegate.moprimApi.updateContextForCurrentDate()
            fetchToResults()
        self.refreshControl.endRefreshing()
            
        }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        NSLog(sender.isOn ? "Switch On" : "Switch Off")
        if (sender.isOn) {
            TMD.start()
        }
        else {
            TMD.stop()
        }
    }
    
    @objc func updateTmdStatusLabel() {

        if TMD.isOff() {
            TMDlabel.text = "TMD is off"
        }
        else if TMD.isIdle() {
            TMDlabel.text = "TMD is idle"
        }
        else if TMD.isRunning() {
            TMDlabel.text = String(format: "TMD is running for %@",
                                   secondsToString(seconds: TMD.getRunningTime()))
        }
    }
    
    func didStart() {
        NSLog("TMD service started")
        updateSwitchState(true)
        if timer.isValid {
            timer.invalidate();
        }
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTmdStatusLabel),
                                     userInfo: nil, repeats: true)
    }
    
    func didStop() {
        NSLog("TMD service stopped")
        if timer.isValid {
            timer.invalidate();
        }
        updateSwitchState(false)
        updateTmdStatusLabel()
    }
    
    func didNotStartWithError(_ error: Error!) {
        NSLog("TMD service could not start with error %@", error.localizedDescription)
        updateSwitchState(false)
        updateTmdStatusLabel()
    }
    
    func didStopWithError(_ error: Error!) {
        NSLog("TMD service stopped with error %@", error.localizedDescription)
        updateSwitchState(false)
        updateTmdStatusLabel()
    }
    
    func updateSwitchState(_ enable:Bool) {
        if (enable && !self.TMDswitch.isOn) {
            self.TMDswitch.setOn(true, animated: true)
        }
        else if (!enable && self.TMDswitch.isOn) {
            self.TMDswitch.setOn(false, animated: true)
            self.tableView.reloadData()
        }
    }
    

    
    
    
    //TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[ section ].numberOfObjects
        } else {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModalityCell", for: indexPath)
        let activity = self.fetchedResultsController?.object(at: indexPath)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        dateFormatterGet.dateStyle = .short

        cell.textLabel?.text = String(format: "%@ (%@) - %@",
                                      String(activity?.date ?? "no date"),
                                      secondsToString(seconds: activity?.duration ?? 0),
                                      String(activity?.activity ?? "n.a.").uppercased())
        return cell
    }
    
    func fetchToResults(){
        
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        let sort = NSSortDescriptor(key:"date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController?.delegate = self
        DispatchQueue.main.async {
            do {
                
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
            } catch {
                print("fetchedResultsController not good")
            }
        }
        
    }
    
    @objc private func refreshTableData(_ sender: Any) {
        appDelegate.moprimApi.updateContextForCurrentDate()
        fetchToResults()
        self.refreshControl.endRefreshing()
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
    
    

}
