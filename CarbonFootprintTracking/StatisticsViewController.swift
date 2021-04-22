//
//  StatisticsViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import UIKit
import Charts //must have pod installed
import TinyConstraints //must have pod installed

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        return chartView
    }()
    
    //set of vehicle types
    var vehicleTypes: Set = ["Car", "Plane", "Train"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // adding the linechartview to our view
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        
        //setting width and height of linechartview according to the width of the screen
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        let carTripData = DataSetStatistics(timeStamp: "12345", carbonFootprint: 10, vehicleType: "Car")
        
        var myDummyCar = Vehicle("Car")
        var myDummyPlane = Vehicle("Plane")
        var myDummyTrain = Vehicle("Train")
        
        myDummyCar.pushData(carTripData)
        
        setData()
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    //sets data for the linechartview
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "CO2 footprint")
        let data = LineChartData(dataSet: set1)
        
        lineChartView.data = data
    }
    
    //Dummy data for chart
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 15.0),
        ChartDataEntry(x: 2.0, y: 17.0),
        ChartDataEntry(x: 3.0, y: 6.0),
        ChartDataEntry(x: 4.0, y: 2.0),
        ChartDataEntry(x: 5.0, y: 20.0),
        ChartDataEntry(x: 6.0, y: 7.0),
        ChartDataEntry(x: 7.0, y: 10.0),
        ChartDataEntry(x: 8.0, y: 10.0),
        ChartDataEntry(x: 9.0, y: 11.0),
        ChartDataEntry(x: 10.0, y: 24.0),
        ChartDataEntry(x: 11.0, y: 3.0),
    ]
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
