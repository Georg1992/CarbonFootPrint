//
//  VehicleViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 4.5.2021.
//

import UIKit

class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func getDistance(matka: Double) {
        distance = matka
        self.tableView.reloadData()
        print("we got the distance \(matka)")
    }
    
    
    
    
    @IBOutlet var label: UILabel!
    @IBOutlet var tableView: UITableView!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.identifier, for: indexPath) as! VehicleTableViewCell

        let matka = distance * Double(vehicles[indexPath.row].value)
            cell.iconLabel?.text = vehicles[indexPath.row].key
            cell.carbonLabel?.text = String(matka)
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
