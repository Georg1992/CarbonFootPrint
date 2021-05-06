//
//  VehicleViewController.swift
//  CarbonFootprintTracking
//
//  Created by Patrik on 4.5.2021.
//

import UIKit
//controller for tableview
class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var label: UILabel!
    @IBOutlet var tableView: UITableView!
    
    // array where is vehicle and it co2 as g/km
    var vehicles: KeyValuePairs = ["Walk": 19, "Car": 192, "Bicycle": 40, "Motorcycle": 103, "Train": 41]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        print("this is tableview \(self.tableView)")
    }
    
    
    
    // variable for distance, which will be changed in MapViewController
    // when value change tableView.reloadData (not working)
    var distance: Double = 0.0 {
        didSet {
            print("arvo vaihtui")
            DispatchQueue.main.async {
                print("this is tableview \(self.tableView)")
                self.tableView?.reloadData()
                print("this is distance \(self.distance)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell is defined to be vehicleTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.identifier, for: indexPath) as! VehicleTableViewCell

        // Icon label takes vehicles.key, which is name for vehicle
        // Carbon label takes variable matka, which is distance(km) * vehicles.value which is co2 g/km
        let matka = distance * Double(vehicles[indexPath.row].value)
            cell.iconLabel?.text = vehicles[indexPath.row].key
            cell.carbonLabel?.text = String(matka)
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
