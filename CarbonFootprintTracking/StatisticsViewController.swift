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
    
    @IBOutlet weak var containerChart: UIView!
    
   @IBOutlet weak var vehicleTextField: UITextField!
    
    var myNonMotorized = Vehicle("nonmotorized")
    var myCar = Vehicle("car")
    var myBus = Vehicle("bus")
    var myTram = Vehicle("tram")
    var myTrain = Vehicle("train")
    var myMetro = Vehicle("metro")
    var myPlane = Vehicle("plane")
    
    var selectedVehicle: String?
    var vehicleTypes = ["all", "nonmotorized", "car", "bus", "tram", "train", "metro", "plane"]
    var currentVehicle: Vehicle?
    
    //Setting up lineChartView with some UI elements
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
        xAxis.setLabelCount(12, force: true)
        
        chartView.animate(xAxisDuration: 1.0)
        chartView.legend.font = .boldSystemFont(ofSize: 20)
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // dummy data
//        let newDummy = DummyData()
//        newDummy.fetchDummyData()
        
        //setting up pickerView to select vehicle
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
        
        //making lineChartView a subView of containerChart for easy constraints
        containerChart.addSubview(lineChartView)
        
        //setting width and height of lineChartView according to the width of the superview
        lineChartView.width(to: containerChart)
        lineChartView.heightToWidth(of: containerChart)
        lineChartView.topToSuperview()
        
        //currently just dummy data for testing
        let carTripData = DataSetStatistics(timeStamp: "12345", carbonFootprint: 10.0, vehicleType: "Car")
        
        var myDummyCar = Vehicle("Car")
        var myDummyPlane = Vehicle("Plane")
        var myDummyTrain = Vehicle("Train")
        
        myDummyCar.pushDataDay(carTripData)
        //print(" dayArray data: \(myDummyCar.dayArray[0])")
        
        currentVehicle = myCar
        
        setData(timePeriod: dayValues, labelCount: 12, forced: false)
    }
    
    //creating and setting up pickerView for vehicle selection
    func createAndSetupPickerView(){
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        self.vehicleTextField.inputView = pickerview
    }
    
    //Closes and dismisses pickerView
    func dismissAndClosePickerView(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.vehicleTextField.inputAccessoryView = toolBar
    }
    
    //dismisses pickerView when "Done" button is clicked
    @objc func dismissAction(){
        self.view.endEditing(true)
    }

    //when user clicks on statistics chart, user can see the exact value
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    //sets data for lineChartView
    func setData(timePeriod: [ChartDataEntry], labelCount: Int, forced: Bool) {
        //sets values (entries) for the data set and some front end stuff for the red line in the chart
        let set1 = LineChartDataSet(entries: timePeriod, label: "CO2 footprint")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.red)
        set1.fill = Fill(color: .red)
        set1.fillAlpha = 0.65
        set1.drawFilledEnabled = true
        
        //highlight can be seen when any point of chart is clicked.
        set1.highlightColor = .black
        set1.highlightLineWidth = 1.5
        
        let data = LineChartData(dataSet: set1)
        
        //prevents the chart from displaying the data in numbers on top of the peak of a line
        data.setDrawValues(false)
        
        //changes the amount of x-values in the line chart to match days. There are 12 data marks instead of 24 to save space in the x-axis.
        lineChartView.xAxis.setLabelCount(labelCount, force: forced)
        
        //sets the data for lineChartView
        lineChartView.data = data
    }
    
    //values for each day (intervals every hour)
    let dayValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 22.0),
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
        ChartDataEntry(x: 12.0, y: 10.0),
        ChartDataEntry(x: 13.0, y: 15.0),
        ChartDataEntry(x: 14.0, y: 17.0),
        ChartDataEntry(x: 15.0, y: 6.0),
        ChartDataEntry(x: 16.0, y: 2.0),
        ChartDataEntry(x: 17.0, y: 20.0),
        ChartDataEntry(x: 18.0, y: 7.0),
        ChartDataEntry(x: 19.0, y: 10.0),
        ChartDataEntry(x: 20.0, y: 10.0),
        ChartDataEntry(x: 21.0, y: 11.0),
        ChartDataEntry(x: 22.0, y: 24.0),
        ChartDataEntry(x: 23.0, y: 3.0),
    ]
    
    //data for week (shows the sum of CO2 of each day mon - sun)
    let weekValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 5.0),
        ChartDataEntry(x: 1.0, y: 35.0),
        ChartDataEntry(x: 2.0, y: 45.0),
        ChartDataEntry(x: 3.0, y: 35.0),
        ChartDataEntry(x: 4.0, y: 20.0),
        ChartDataEntry(x: 5.0, y: 20.0),
        ChartDataEntry(x: 6.0, y: 20.0),
    ]
    
    //data for month (sum of CO2 for every day of the month)
    let monthValues: [ChartDataEntry] = [
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
        ChartDataEntry(x: 12.0, y: 10.0),
        ChartDataEntry(x: 13.0, y: 15.0),
        ChartDataEntry(x: 14.0, y: 17.0),
        ChartDataEntry(x: 15.0, y: 6.0),
        ChartDataEntry(x: 16.0, y: 2.0),
        ChartDataEntry(x: 17.0, y: 20.0),
        ChartDataEntry(x: 18.0, y: 7.0),
        ChartDataEntry(x: 19.0, y: 10.0),
        ChartDataEntry(x: 20.0, y: 10.0),
        ChartDataEntry(x: 21.0, y: 11.0),
        ChartDataEntry(x: 22.0, y: 24.0),
        ChartDataEntry(x: 23.0, y: 3.0),
        ChartDataEntry(x: 24.0, y: 20.0),
        ChartDataEntry(x: 25.0, y: 7.0),
        ChartDataEntry(x: 26.0, y: 10.0),
        ChartDataEntry(x: 27.0, y: 10.0),
        ChartDataEntry(x: 28.0, y: 11.0),
        ChartDataEntry(x: 29.0, y: 24.0),
        ChartDataEntry(x: 30.0, y: 3.0),
        ChartDataEntry(x: 31.0, y: 3.0),
    ]
    
    //data for every month of the year (sum of CO2 for every month of the year)
    let yearValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 22.0),
        ChartDataEntry(x: 1.0, y: 35.0),
        ChartDataEntry(x: 2.0, y: 45.0),
        ChartDataEntry(x: 3.0, y: 35.0),
        ChartDataEntry(x: 4.0, y: 20.0),
        ChartDataEntry(x: 5.0, y: 20.0),
        ChartDataEntry(x: 6.0, y: 20.0),
        ChartDataEntry(x: 7.0, y: 45.0),
        ChartDataEntry(x: 8.0, y: 35.0),
        ChartDataEntry(x: 9.0, y: 20.0),
        ChartDataEntry(x: 10.0, y: 20.0),
        ChartDataEntry(x: 11.0, y: 20.0),
    ]
    
    //sets data for day when day button is pressed
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        print("dayButtonPressed")
        setData(timePeriod: dayValues, labelCount: 12, forced: false)
    }
    
    //sets data for week when week button is pressed
    @IBAction func weekButtonPressed(_ sender: UIButton) {
        print("weekButtonPressed")
        setData(timePeriod: weekValues, labelCount: 7, forced: true)
    }
    
    //sets data for month when month button is pressed
    @IBAction func monthButtonPressed(_ sender: UIButton) {
        print("monthButtonPressed")
        setData(timePeriod: monthValues, labelCount: 10, forced: false)
    }
    
    //sets data for year when year button is pressed
    @IBAction func yearButtonPressed(_ sender: UIButton) {
        print("yearButtonPressed")
        setData(timePeriod: yearValues, labelCount: 12, forced: true)
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

//An extension to make a pickerView to select vehicles
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
        
        //sets the current vehicle used
        if(self.selectedVehicle?.lowercased() == "nonmotorized") {self.currentVehicle = myNonMotorized}
        if(self.selectedVehicle?.lowercased() == "car") {self.currentVehicle = myCar}
        if(self.selectedVehicle?.lowercased() == "bus") {self.currentVehicle = myBus}
        if(self.selectedVehicle?.lowercased() == "tram") {self.currentVehicle = myTram}
        if(self.selectedVehicle?.lowercased() == "metro") {self.currentVehicle = myMetro}
        if(self.selectedVehicle?.lowercased() == "plane") {self.currentVehicle = myPlane}
        print("my current vehicle: \(currentVehicle?.vehicleType ?? "all")")
        print("currentVehicle: \(currentVehicle?.vehicleType ?? "all") first hour: ")
        //let isIndexValid = currentVehicle?.dayArray.indices.contains(0)
        
    }
}

