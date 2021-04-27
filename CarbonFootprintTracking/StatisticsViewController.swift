//
//  StatisticsViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import UIKit
import DropDown //pod item
import Charts //pod item
import TinyConstraints //pod item

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var dayButtonOutlet: UIButton!
    
    @IBOutlet weak var weekButtonOutlet: UIButton!
    
    @IBOutlet weak var monthButtonOutlet: UIButton!
    
    @IBOutlet weak var yearButtonOutlet: UIButton!
    
   @IBOutlet weak var vehicleTextField: UITextField!
    var selectedVehicle: String?
    var vehicleTypes = ["Car", "Plane", "Train", "Bike", "Scooter", "Metro"]
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setting up pickerView to select vehicle
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
        
        
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
    
    func createAndSetupPickerView(){
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        self.vehicleTextField.inputView = pickerview
    }
    
    func dismissAndClosePickerView(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.vehicleTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissAction(){
        self.view.endEditing(true)
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
    
    let yValues2: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 5.0),
        ChartDataEntry(x: 1.0, y: 35.0),
        ChartDataEntry(x: 2.0, y: 45.0),
        ChartDataEntry(x: 3.0, y: 35.0),
        ChartDataEntry(x: 4.0, y: 20.0),
        ChartDataEntry(x: 5.0, y: 20.0),
        ChartDataEntry(x: 6.0, y: 20.0),
    ]
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        print("dayButtonPressed")
        setData()
    }
    
    @IBAction func weekButtonPressed(_ sender: UIButton) {
        print("weekButtonPressed")
        let set2 = LineChartDataSet(entries: yValues2, label: "CO2 footprint")
        set2.mode = .cubicBezier
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3
        set2.setColor(.red)
        set2.fill = Fill(color: .red)
        set2.fillAlpha = 0.65
        set2.drawFilledEnabled = true
        
        
        //set1.drawHorizontalHighlightIndicatorEnabled = false
        set2.highlightColor = .black
        set2.highlightLineWidth = 1.5
        
        let data2 = LineChartData(dataSet: set2)
        data2.setDrawValues(false)
        
        lineChartView.data = data2
    }
    
    @IBAction func monthButtonPressed(_ sender: UIButton) {
        print("monthButtonPressed")
    }
    
    @IBAction func yearButtonPressed(_ sender: UIButton) {
        print("yearButtonPressed")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.vehicleTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.vehicleTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedVehicle = self.vehicleTypes[row]
        print(self.selectedVehicle ?? "none")
        self.vehicleTextField.text = self.selectedVehicle
    }
}
