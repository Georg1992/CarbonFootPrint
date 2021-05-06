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
import CoreData

class StatisticsViewController: UIViewController, ChartViewDelegate, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController:NSFetchedResultsController<Activity>?
    
    var activityInfo:Activity?
    
    @IBOutlet weak var dayButtonOutlet: UIButton!
    
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
    
    var tripTimeStamp: String?
    var tripTimeStampNoHour: String?
    var tripTimeStampThisMonth: String?
    var tripTimeStampThisYear: String?
    var tripCarbonFootprint: Double?
    var tripVehicleType: String?
    
    var today: String?
    var todayNoHour: String?
    var thisMonth: String?
    var thisYear: String?
    
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
        
        // Creates Date
        let date = Date()
        // Creates Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format for today
        dateFormatter.dateFormat = "YY/MM/dd/hh"
        
        let dateFormatterNoHour = DateFormatter()
        // Set Date Format for today with no hour
        dateFormatterNoHour.dateFormat = "YY/MM/dd"
        
        let dateFormatterMonth = DateFormatter()
        // Set Date Format for this month
        dateFormatterMonth.dateFormat = "YY/MM"
        
        let dateFormatterYear = DateFormatter()
        // Set Date Format for this year
        dateFormatterYear.dateFormat = "YY"
        
        today = dateFormatter.string(from: date)
        todayNoHour = dateFormatterNoHour.string(from: date)
        thisMonth = dateFormatterMonth.string(from: date)
        thisYear = dateFormatterYear.string(from: date)
        
        var carCarbon: Double = 0
        var trainCarbon: Double = 0
        var bicycleCarbon: Double = 0
        var planeCarbon: Double = 0
        var walkCarbon: Double = 0
        var busCarbon: Double = 0
        var metroCarbon: Double = 0
        var runCarbon: Double = 0
        var tramCarbon: Double = 0
        
        let request:NSFetchRequest<Activity> = Activity.fetchRequest()
        
        let context = AppDelegate.viewContext
        
        //do {
        let activities =  try? context.fetch(request)
        //print("pie coredata:  \(activities?.count ?? 0)")
        
        // checks if date is same as today. If it is, then value is added
        for oneActivity in activities ?? [] {
            
            if oneActivity.activity == "car" && oneActivity.date == today {
                carCarbon = carCarbon + Double(oneActivity.co2)
            }
            if oneActivity.activity == "train" && oneActivity.date == today {
                trainCarbon = trainCarbon + Double(oneActivity.co2)
            }
            if oneActivity.activity == "bicycle" && oneActivity.date == today {
                bicycleCarbon = bicycleCarbon + Double(oneActivity.co2)
            }
            if oneActivity.activity == "plane" && oneActivity.date == today {
                planeCarbon = planeCarbon + Double(oneActivity.co2)
            }
            if oneActivity.activity == "walk" && oneActivity.date == today {
                walkCarbon = walkCarbon + Double(oneActivity.co2)
                //print("walk carbon: \(walkCarbon)")
            }
            if oneActivity.activity == "bus" && oneActivity.date == today {
                busCarbon = busCarbon + Double(oneActivity.co2)
                //print("bus carbon: \(busCarbon)")
            }
            if oneActivity.activity == "metro" && oneActivity.date == today {
                metroCarbon = metroCarbon + Double(oneActivity.co2)
                //print("metro carbon: \(metroCarbon)")
            }
            if oneActivity.activity == "run" && oneActivity.date == today {
                runCarbon = runCarbon + Double(oneActivity.co2)
                //print("run carbon: \(runCarbon)")
            }
            if oneActivity.activity == "tram" && oneActivity.date == today {
                tramCarbon = tramCarbon + Double(oneActivity.co2)
            }
            
            print("oneActivity everything: \(oneActivity)")
            print("Statistics coredata co2:  \(oneActivity.co2)")
            print("Statistics coredata transport:  \(oneActivity.activity ?? "nothing")")
            print("Statistics coredata date:  \(oneActivity.date ?? "no date")")
        }
        
        
        //setting current vehicle as train by default
        currentVehicle = myTrain
        
        print("today: \(today), todayNoHour: \(todayNoHour)")
        
        //setting data for the current vehicle
        setTripData("20/11/18/03", "20/11/18", "20/11", "20", 50, currentVehicle?.vehicleType ?? "none")
        print("tripData 1: \(tripTimeStamp), \(tripTimeStampNoHour), \(tripTimeStampThisMonth), \(tripTimeStampThisYear), \(tripCarbonFootprint), \(tripVehicleType)")
        currentVehicle?.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        //print(myCar.dayArray)
        
        setTripData("21/05/03/07", "21/05/03", "21/05", "21", 25, currentVehicle?.vehicleType ?? "none")
        print("tripData 2: \(tripTimeStamp), \(tripTimeStampNoHour), \(tripTimeStampThisMonth), \(tripTimeStampThisYear), \(tripCarbonFootprint), \(tripVehicleType)")
        currentVehicle?.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        //print(myCar.dayArray)
        
        setTripData("21/05/04/02", "21/05/04", "21/05", "21", 37, currentVehicle?.vehicleType ?? "none")
        print("tripData 3: \(tripTimeStamp), \(tripTimeStampNoHour), \(tripTimeStampThisMonth), \(tripTimeStampThisYear), \(tripCarbonFootprint), \(tripVehicleType ?? "all")")
        currentVehicle?.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        //print(myCar.dayArray)
        
        setTripData("21/05/05/01", "21/05/05", "21/05", "21", 180, currentVehicle?.vehicleType ?? "none")
        print("tripData 4: \(tripTimeStamp), \(tripTimeStampNoHour), \(tripTimeStampThisMonth), \(tripTimeStampThisYear), \(tripCarbonFootprint), \(tripVehicleType)")
        currentVehicle?.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        //print(myCar.dayArray)
        
        setTripData("21/05/05/05", "21/05/05", "21/05", "21", 15, currentVehicle?.vehicleType ?? "none")
        print("tripData 5: \(tripTimeStamp), \(tripTimeStampNoHour), \(tripTimeStampThisMonth), \(tripTimeStampThisYear), \(tripCarbonFootprint), \(tripVehicleType)")
        currentVehicle?.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        print("first dayArray: \(currentVehicle?.vehicleType ?? "none")")
        print("first myTrain dayArray: \(myTrain.dayArray)")
        
        print("gatherHourData: \(gatherHourData())")
        print("gatherDayData: \(gatherDayData())")
        print("gatherMonthData: \(gatherMonthData())")
        
        //setting up pickerView to select vehicle
        self.createAndSetupPickerView()
        self.dismissAndClosePickerView()
        
        //making lineChartView a subView of containerChart for easy constraints
        containerChart.addSubview(lineChartView)
        
        //setting width and height of lineChartView according to the width of the superview
        lineChartView.width(to: containerChart)
        lineChartView.heightToWidth(of: containerChart)
        lineChartView.topToSuperview()
        
        //sets lineChartView data to day when view is loaded
        setData(timePeriod: getDayValues(), labelCount: 12, forced: false)
    }
    
    //sets the trip data set
    func setDataSet(_ timeStamp: String, _ timeStampNoHour: String, _ timeStampThisMonth: String, _ timeStampThisYear: String, _ carbonFootPrint: Double, _ vehicleType: String) -> DataSetStatistics {
        let newData = DataSetStatistics(timeStamp: timeStamp, timeStampNoHour: timeStampNoHour, timeStampThisMonth: timeStampThisMonth, timeStampThisYear: timeStampThisYear, carbonFootprint: carbonFootPrint, vehicleType: vehicleType)
        return newData
    }
    
    //sets trip data
    func setTripData(_ tS: String, _ tSNH: String, _ tSTM: String, _ tSTY: String, _ cFP: Double, _ vT: String) {
        tripTimeStamp = tS
        tripTimeStampNoHour = tSNH
        tripTimeStampThisMonth = tSTM
        tripTimeStampThisYear = tSTY
        tripCarbonFootprint = cFP
        tripVehicleType = vT
        
        
        print("setTripData vt: \(vT) and other vt: \(tripVehicleType ?? "none") typeof vT : \(type(of: vT))")
        
        //because currentVehicle does not save data to the actual vehicle of which type it is, the data must be set here to be saved
        switch vT {
        case "nonmotorized":
            myNonMotorized.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "car":
            myCar.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "bus":
            myBus.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "tram":
            myTram.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "train":
            print("setTripData Train called")
            myTrain.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "metro":
            myMetro.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        case "plane":
            myPlane.pushDataDay(setDataSet(tripTimeStamp ?? "0", tripTimeStampNoHour ?? "0", tripTimeStampThisMonth ?? "0", tripTimeStampThisYear ?? "0", tripCarbonFootprint ?? 0.0, tripVehicleType ?? "all"))
        default:
            print("no types switch case")
        }
    }
    
    //gets data for every hour of a day
    func gatherHourData() -> (Double, [DataSetStatistics]){
        var hourCarbonFootprint = 0.0
        var noHourArray = [DataSetStatistics]()
        for element in currentVehicle!.dayArray {
            if(element.timeStamp == today) {
            hourCarbonFootprint += element.carbonFootprint ?? 0.0
            }
            if(element.timeStampNoHour == todayNoHour) {
                noHourArray.append(element)
            }
        }
        return (hourCarbonFootprint, noHourArray)
    }
    
    //gets data for every day of a month
    func gatherDayData() -> (Double, [DataSetStatistics]){
        var dayCarbonFootprint = 0.0
        var noDayArray = [DataSetStatistics]()
        for element in currentVehicle!.dayArray {
            if(element.timeStampThisMonth == thisMonth) {
                noDayArray.append(element)
            }
        }
        print("gatherDayData noDayArray: \(noDayArray)")
        return (dayCarbonFootprint, noDayArray)
    }
    
    //gets data for every month of a year
    func gatherMonthData() -> (Double, [DataSetStatistics]){
        var monthCarbonFootprint: Double = 0.0
        var noMonthArray = [DataSetStatistics]()
        for element in currentVehicle!.dayArray {
            if(element.timeStampThisMonth == thisMonth) {
            monthCarbonFootprint += element.carbonFootprint ?? 0.0
            }
            if(element.timeStampThisYear == thisYear) {
                noMonthArray.append(element)
            }
        }
        return (monthCarbonFootprint, noMonthArray)
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
    func getDayValues() -> [ChartDataEntry]{
        let allFromHour = gatherHourData()
        //let totalCarbon = allFromHour.0
        
        //these variables are used to set data from every hour of a day to dayValues
        var carbon0 = 0.0
        var carbon1 = 0.0
        var carbon2 = 0.0
        var carbon3 = 0.0
        var carbon4 = 0.0
        var carbon5 = 0.0
        var carbon6 = 0.0
        var carbon7 = 0.0
        var carbon8 = 0.0
        var carbon9 = 0.0
        var carbon10 = 0.0
        var carbon11 = 0.0
        var carbon12 = 0.0
        var carbon13 = 0.0
        var carbon14 = 0.0
        var carbon15 = 0.0
        var carbon16 = 0.0
        var carbon17 = 0.0
        var carbon18 = 0.0
        var carbon19 = 0.0
        var carbon20 = 0.0
        var carbon21 = 0.0
        var carbon22 = 0.0
        var carbon23 = 0.0
        
        //this statement figures out what values to give to the variables above. It is done by going through all elements in allFromHour.1 (which is a list of all items inside dayArray) and comparing dates
        for element in allFromHour.1 {
            print("gatherDayValues timestamp: \(element.timeStamp ?? "0")")
            for n in 0...9 {
                print("blergh: \(element.timeStampNoHour ?? "0") + /0\(String(n))")
            if(element.timeStamp == ((element.timeStampNoHour ?? "0") + "/0" + String(n))) {
                print("got to switch: \(n)")
                switch n {
                case 0:
                    carbon0 = element.carbonFootprint ?? 0.0
                case 1:
                    carbon1 = element.carbonFootprint ?? 0.0
                case 2:
                    carbon2 = element.carbonFootprint ?? 0.0
                case 3:
                    carbon3 = element.carbonFootprint ?? 0.0
                case 4:
                    carbon4 = element.carbonFootprint ?? 0.0
                case 5:
                    carbon5 = element.carbonFootprint ?? 0.0
                case 6:
                    carbon6 = element.carbonFootprint ?? 0.0
                case 7:
                    carbon7 = element.carbonFootprint ?? 0.0
                case 8:
                    carbon8 = element.carbonFootprint ?? 0.0
                case 9:
                    carbon9 = element.carbonFootprint ?? 0.0
                default:
                    print("going through hours went wrong in for-statement 0...9")
                }
            }
            }
            for n in 10...23 {
                print("blergh2: \(element.timeStampNoHour ?? "0") + /\(String(n))")
                if(element.timeStamp == ((element.timeStampNoHour ?? "0") + "/0" + String(n))) {
                    switch n {
                    case 10:
                        carbon10 = element.carbonFootprint ?? 0.0
                    case 11:
                        carbon11 = element.carbonFootprint ?? 0.0
                    case 12:
                        carbon12 = element.carbonFootprint ?? 0.0
                    case 13:
                        carbon13 = element.carbonFootprint ?? 0.0
                    case 14:
                        carbon14 = element.carbonFootprint ?? 0.0
                    case 15:
                        carbon15 = element.carbonFootprint ?? 0.0
                    case 16:
                        carbon16 = element.carbonFootprint ?? 0.0
                    case 17:
                        carbon17 = element.carbonFootprint ?? 0.0
                    case 18:
                        carbon18 = element.carbonFootprint ?? 0.0
                    case 19:
                        carbon19 = element.carbonFootprint ?? 0.0
                    case 20:
                        carbon20 = element.carbonFootprint ?? 0.0
                    case 21:
                        carbon21 = element.carbonFootprint ?? 0.0
                    case 22:
                        carbon22 = element.carbonFootprint ?? 0.0
                    case 23:
                        carbon23 = element.carbonFootprint ?? 0.0
                    default:
                        print("going through hours went wrong in for-statement 10...23")
                    }
                }
            }
        }
        
    //these are the values shown in lineChart
    let dayValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: carbon0),
        ChartDataEntry(x: 1.0, y: carbon1),
        ChartDataEntry(x: 2.0, y: carbon2),
        ChartDataEntry(x: 3.0, y: carbon3),
        ChartDataEntry(x: 4.0, y: carbon4),
        ChartDataEntry(x: 5.0, y: carbon5),
        ChartDataEntry(x: 6.0, y: carbon6),
        ChartDataEntry(x: 7.0, y: carbon7),
        ChartDataEntry(x: 8.0, y: carbon8),
        ChartDataEntry(x: 9.0, y: carbon9),
        ChartDataEntry(x: 10.0, y: carbon10),
        ChartDataEntry(x: 11.0, y: carbon11),
        ChartDataEntry(x: 12.0, y: carbon12),
        ChartDataEntry(x: 13.0, y: carbon13),
        ChartDataEntry(x: 14.0, y: carbon14),
        ChartDataEntry(x: 15.0, y: carbon15),
        ChartDataEntry(x: 16.0, y: carbon16),
        ChartDataEntry(x: 17.0, y: carbon17),
        ChartDataEntry(x: 18.0, y: carbon18),
        ChartDataEntry(x: 19.0, y: carbon19),
        ChartDataEntry(x: 20.0, y: carbon20),
        ChartDataEntry(x: 21.0, y: carbon21),
        ChartDataEntry(x: 22.0, y: carbon22),
        ChartDataEntry(x: 23.0, y: carbon23),
    ]; return dayValues}
    
    func getMonthValues() -> [ChartDataEntry]{
        let allFromDay = gatherDayData()
        
        //these variables are used to set data from every hour of a day to dayValues
        var carbon0 = 0.0
        var carbon1 = 0.0
        var carbon2 = 0.0
        var carbon3 = 0.0
        var carbon4 = 0.0
        var carbon5 = 0.0
        var carbon6 = 0.0
        var carbon7 = 0.0
        var carbon8 = 0.0
        var carbon9 = 0.0
        var carbon10 = 0.0
        var carbon11 = 0.0
        var carbon12 = 0.0
        var carbon13 = 0.0
        var carbon14 = 0.0
        var carbon15 = 0.0
        var carbon16 = 0.0
        var carbon17 = 0.0
        var carbon18 = 0.0
        var carbon19 = 0.0
        var carbon20 = 0.0
        var carbon21 = 0.0
        var carbon22 = 0.0
        var carbon23 = 0.0
        var carbon24 = 0.0
        var carbon25 = 0.0
        var carbon26 = 0.0
        var carbon27 = 0.0
        var carbon28 = 0.0
        var carbon29 = 0.0
        var carbon30 = 0.0
        
        
        //this statement figures out what values to give to the variables above. It is done by going through all elements in allFromDay.1 (which is a list of all items inside dayArray) and comparing dates
        for element in allFromDay.1 {
            print("gatherMonthValues timestamp: \(element.timeStamp ?? "0")")
            for n in 0...9 {
                print("blerghMonth: \(element.timeStampThisMonth ?? "0") + /0\(String(n))")
            if(element.timeStampNoHour == ((element.timeStampThisMonth ?? "0") + "/0" + String(n))) {
                print("got to switch: \(n)")
                switch n {
                case 0:
                    carbon0 += element.carbonFootprint ?? 0.0
                case 1:
                    carbon1 += element.carbonFootprint ?? 0.0
                case 2:
                    carbon2 += element.carbonFootprint ?? 0.0
                case 3:
                    carbon3 += element.carbonFootprint ?? 0.0
                case 4:
                    carbon4 += element.carbonFootprint ?? 0.0
                case 5:
                    carbon5 += element.carbonFootprint ?? 0.0
                case 6:
                    carbon6 += element.carbonFootprint ?? 0.0
                case 7:
                    carbon7 += element.carbonFootprint ?? 0.0
                case 8:
                    carbon8 += element.carbonFootprint ?? 0.0
                case 9:
                    carbon9 += element.carbonFootprint ?? 0.0
                default:
                    print("going through hours went wrong in for-statement 0...9")
                }
            }
            }
            for n in 10...30 {
                print("blerghMonth2: \(element.timeStampThisMonth ?? "0") + /\(String(n))")
                if(element.timeStampNoHour == ((element.timeStampThisMonth ?? "0") + "/0" + String(n))) {
                    switch n {
                    case 10:
                        carbon10 += element.carbonFootprint ?? 0.0
                    case 11:
                        carbon11 += element.carbonFootprint ?? 0.0
                    case 12:
                        carbon12 += element.carbonFootprint ?? 0.0
                    case 13:
                        carbon13 += element.carbonFootprint ?? 0.0
                    case 14:
                        carbon14 += element.carbonFootprint ?? 0.0
                    case 15:
                        carbon15 += element.carbonFootprint ?? 0.0
                    case 16:
                        carbon16 += element.carbonFootprint ?? 0.0
                    case 17:
                        carbon17 += element.carbonFootprint ?? 0.0
                    case 18:
                        carbon18 += element.carbonFootprint ?? 0.0
                    case 19:
                        carbon19 += element.carbonFootprint ?? 0.0
                    case 20:
                        carbon20 += element.carbonFootprint ?? 0.0
                    case 21:
                        carbon21 += element.carbonFootprint ?? 0.0
                    case 22:
                        carbon22 += element.carbonFootprint ?? 0.0
                    case 23:
                        carbon23 += element.carbonFootprint ?? 0.0
                    case 24:
                        carbon24 += element.carbonFootprint ?? 0.0
                    case 25:
                        carbon25 += element.carbonFootprint ?? 0.0
                    case 26:
                        carbon26 += element.carbonFootprint ?? 0.0
                    case 27:
                        carbon27 += element.carbonFootprint ?? 0.0
                    case 28:
                        carbon28 += element.carbonFootprint ?? 0.0
                    case 29:
                        carbon29 += element.carbonFootprint ?? 0.0
                    case 30:
                        carbon30 += element.carbonFootprint ?? 0.0
                    default:
                        print("going through hours went wrong in for-statement 10...30")
                    }
                }
            }
        }
        
    //data for month (sum of CO2 for every day of the month)
    let monthValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: carbon0),
        ChartDataEntry(x: 1.0, y: carbon1),
        ChartDataEntry(x: 2.0, y: carbon2),
        ChartDataEntry(x: 3.0, y: carbon3),
        ChartDataEntry(x: 4.0, y: carbon4),
        ChartDataEntry(x: 5.0, y: carbon5),
        ChartDataEntry(x: 6.0, y: carbon6),
        ChartDataEntry(x: 7.0, y: carbon7),
        ChartDataEntry(x: 8.0, y: carbon8),
        ChartDataEntry(x: 9.0, y: carbon9),
        ChartDataEntry(x: 10.0, y: carbon10),
        ChartDataEntry(x: 11.0, y: carbon11),
        ChartDataEntry(x: 12.0, y: carbon12),
        ChartDataEntry(x: 13.0, y: carbon13),
        ChartDataEntry(x: 14.0, y: carbon14),
        ChartDataEntry(x: 15.0, y: carbon15),
        ChartDataEntry(x: 16.0, y: carbon16),
        ChartDataEntry(x: 17.0, y: carbon17),
        ChartDataEntry(x: 18.0, y: carbon18),
        ChartDataEntry(x: 19.0, y: carbon19),
        ChartDataEntry(x: 20.0, y: carbon20),
        ChartDataEntry(x: 21.0, y: carbon21),
        ChartDataEntry(x: 22.0, y: carbon22),
        ChartDataEntry(x: 23.0, y: carbon23),
        ChartDataEntry(x: 24.0, y: carbon24),
        ChartDataEntry(x: 25.0, y: carbon25),
        ChartDataEntry(x: 26.0, y: carbon26),
        ChartDataEntry(x: 27.0, y: carbon27),
        ChartDataEntry(x: 28.0, y: carbon28),
        ChartDataEntry(x: 29.0, y: carbon29),
        ChartDataEntry(x: 30.0, y: carbon30),
    ]; return monthValues}
    
    func getYearValues() -> [ChartDataEntry]{
        let allFromMonth = gatherMonthData()
        
        //these variables are used to set data from every hour of a day to dayValues
        var carbon0 = 0.0
        var carbon1 = 0.0
        var carbon2 = 0.0
        var carbon3 = 0.0
        var carbon4 = 0.0
        var carbon5 = 0.0
        var carbon6 = 0.0
        var carbon7 = 0.0
        var carbon8 = 0.0
        var carbon9 = 0.0
        var carbon10 = 0.0
        var carbon11 = 0.0
        
        //this statement figures out what values to give to the variables above. It is done by going through all elements in allFromMonth.1 (which is a list of all items inside dayArray) and comparing dates
        for element in allFromMonth.1 {
            print("gatherYearValues timestamp: \(element.timeStamp ?? "0")")
            for n in 0...9 {
                print("blerghYear: \(element.timeStampThisYear ?? "0") + /0\(String(n))")
            if(element.timeStampThisMonth == ((element.timeStampThisYear ?? "0") + "/0" + String(n))) {
                print("got to switch: \(n)")
                switch n {
                case 0:
                    carbon0 += element.carbonFootprint ?? 0.0
                case 1:
                    carbon1 += element.carbonFootprint ?? 0.0
                case 2:
                    carbon2 += element.carbonFootprint ?? 0.0
                case 3:
                    carbon3 += element.carbonFootprint ?? 0.0
                case 4:
                    carbon4 += element.carbonFootprint ?? 0.0
                case 5:
                    carbon5 += element.carbonFootprint ?? 0.0
                case 6:
                    carbon6 += element.carbonFootprint ?? 0.0
                case 7:
                    carbon7 += element.carbonFootprint ?? 0.0
                case 8:
                    carbon8 += element.carbonFootprint ?? 0.0
                case 9:
                    carbon9 += element.carbonFootprint ?? 0.0
                default:
                    print("going through hours went wrong in for-statement 0...9")
                }
            }
            }
            for n in 10...11 {
                print("blerghYear2: \(element.timeStampThisMonth ?? "0") + /\(String(n))")
                if(element.timeStampThisMonth == ((element.timeStampThisYear ?? "0") + "/0" + String(n))) {
                    switch n {
                    case 10:
                        carbon10 += element.carbonFootprint ?? 0.0
                    case 11:
                        carbon11 += element.carbonFootprint ?? 0.0
                    default:
                        print("going through hours went wrong in for-statement 10...11")
                    }
                }
            }
        }
        
    //data for every month of the year (sum of CO2 for every month of the year)
    let yearValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: carbon0),
        ChartDataEntry(x: 1.0, y: carbon1),
        ChartDataEntry(x: 2.0, y: carbon2),
        ChartDataEntry(x: 3.0, y: carbon3),
        ChartDataEntry(x: 4.0, y: carbon4),
        ChartDataEntry(x: 5.0, y: carbon5),
        ChartDataEntry(x: 6.0, y: carbon6),
        ChartDataEntry(x: 7.0, y: carbon7),
        ChartDataEntry(x: 8.0, y: carbon8),
        ChartDataEntry(x: 9.0, y: carbon9),
        ChartDataEntry(x: 10.0, y: carbon10),
        ChartDataEntry(x: 11.0, y: carbon11),
    ]; return yearValues}
    
    //sets data for day when day button is pressed
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        print("dayButtonPressed")
        setData(timePeriod: getDayValues(), labelCount: 12, forced: false)
    }
    
    //sets data for week when week button is pressed
    
    //sets data for month when month button is pressed
    @IBAction func monthButtonPressed(_ sender: UIButton) {
        print("monthButtonPressed")
        setData(timePeriod: getMonthValues(), labelCount: 10, forced: false)
    }
    
    //sets data for year when year button is pressed
    @IBAction func yearButtonPressed(_ sender: UIButton) {
        print("yearButtonPressed")
        setData(timePeriod: getYearValues(), labelCount: 12, forced: true)
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
        if(self.selectedVehicle?.lowercased() == "train") {self.currentVehicle = myTrain
            print("myTrain stats: \(myTrain.dayArray)")
            print("currentVehicle: \(self.currentVehicle ?? myTrain) stats: \(currentVehicle?.dayArray)")
        }
        if(self.selectedVehicle?.lowercased() == "metro") {self.currentVehicle = myMetro}
        if(self.selectedVehicle?.lowercased() == "plane") {self.currentVehicle = myPlane}
        print("my current vehicle: \(self.currentVehicle?.vehicleType ?? "all")")
        print("currentVehicle: \(self.currentVehicle?.vehicleType ?? "all") first hour: ")
        //let isIndexValid = currentVehicle?.dayArray.indices.contains(0)
        
    }
}

