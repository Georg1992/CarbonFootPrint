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
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var getDataButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var fetchedResultsController:NSFetchedResultsController<Activity>?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = AppDelegate.viewContext
    private var exampleLocation: CLLocation = CLLocation(latitude: 60.187784, longitude: 24.96044)
    private let refreshControl = UIRefreshControl()
    private var timer: Timer = Timer()
    private var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchResults()
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
    }
    
    
    
    @IBAction func goByCar(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.car, destination: exampleLocation, controller: self)
    }
    @IBAction func goByBicycle(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.bicycle, destination: exampleLocation, controller: self)
    }
    @IBAction func walk(_ sender: Any) {
        appDelegate.moprimApi.uploadSyntheticData(transport: TMDSyntheticRequestType.bicycle, destination: exampleLocation, controller: self)
    }
    
    @IBAction func getData(_ sender: Any) {
        appDelegate.moprimApi.updateContextForCurrentDate()
        tableView.reloadData()
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
        print("fetching for table")
        let activity = self.fetchedResultsController?.object(at: indexPath)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        let ts = Double(activity?.timestampStart ?? 0) / 1000.0
        let date = dateFormatterGet.string(from: Date(timeIntervalSince1970: TimeInterval(ts)))
        cell.textLabel?.text = String(format: "%@ (%@) - %@",
                                      date,
                                      secondsToString(seconds: activity?.duration ?? 0),
                                      String(activity?.activity ?? "n.a.").uppercased())
        return cell
    }
    
    func fetchResults(){
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        //DELETE REQUEST FOR CLEANING THE CONTEXT
        let fetchDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        //let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchDeleteRequest)

        let sort = NSSortDescriptor(key:"date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            //try context.execute(deleteRequest)
            tableView.reloadData()
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
            print("CORE DATA FETCHED: \(fetchedResultsController?.fetchedObjects)")
        } catch {
            print("fetchedResultsController not good")
        }
    }
    
    @objc private func refreshTableData(_ sender: Any) {
        appDelegate.moprimApi.updateContextForCurrentDate()
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
