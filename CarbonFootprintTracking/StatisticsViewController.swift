//
//  StatisticsViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import UIKit
import Charts
import TinyConstraints //must have pod installed

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 20)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .gray
        yAxis.axisLineColor = .gray
        yAxis.labelPosition = .outsideChart
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .gray
        xAxis.axisLineColor = .gray
        xAxis.labelFont = .boldSystemFont(ofSize: 20)
        xAxis.setLabelCount(7, force: false)
        
        chartView.animate(xAxisDuration: 1.0)
        chartView.legend.font = .boldSystemFont(ofSize: 20)
        
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
        
        let carTripData = DataSetStatistics(timeStamp: "12345", carbonFootprint: 10.0, vehicleType: "Car")
        
        var myDummyCar = Vehicle("Car")
        var myDummyPlane = Vehicle("Plane")
        var myDummyTrain = Vehicle("Train")
        
        myDummyCar.pushData(carTripData)
        print(" dayArray data: \(myDummyCar.dayArray[0])")
        
        setData()
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    //sets data for the linechartview
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "CO2 footprint")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.red)
        set1.fill = Fill(color: .red)
        set1.fillAlpha = 0.65
        set1.drawFilledEnabled = true
        
        
        //set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .black
        set1.highlightLineWidth = 1.5
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        
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
