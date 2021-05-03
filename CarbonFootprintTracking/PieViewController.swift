//
//  PieViewController.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 20.4.2021.
//

import Charts
import UIKit
import CoreData
import Foundation

class PieViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController:NSFetchedResultsController<Activity>?
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var activityInfo:Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates Date
        let date = Date()
        // Creates Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        let today = dateFormatter.string(from: date)
        
        // only month
        dateFormatter.dateFormat = "YY/MM"
        let monthToday = dateFormatter.string(from: date)
        //print("month today: \(monthToday)")
        
        // values for pie chart
        var transport = [String]()
        var carbon = [Double]()
        
        // value to budget bar
        var budgetValue: Double = 0
        
        var carCarbon: Double = 0
        var trainCarbon: Double = 0
        var bikeCarbon: Double = 0
        var planeCarbon: Double = 0
        var walkCarbon: Double = 0
        var busCarbon: Double = 0
        var metroCarbon: Double = 0
        var runCarbon: Double = 0
        
        let request:NSFetchRequest<Activity> = Activity.fetchRequest()
        
        let context = AppDelegate.viewContext
        
        do {
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
                if oneActivity.activity == "bike" && oneActivity.date == today {
                    bikeCarbon = bikeCarbon + Double(oneActivity.co2)
                }
                if oneActivity.activity == "plane" && oneActivity.date == today {
                    planeCarbon = planeCarbon + Double(oneActivity.co2)
                }
                if oneActivity.activity == "plane" && oneActivity.date == today {
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
                
                // checks if month is still same
                if oneActivity.date?.contains(monthToday) == true {
                    budgetValue = budgetValue + Double(oneActivity.co2)/100000000
                }
                
                print("pie coredata co2:  \(oneActivity.co2)")
                print("pie coredata transport:  \(oneActivity.activity ?? "nothing")")
                print("pie coredata date:  \(oneActivity.date ?? "no date")")
            }
        }
        catch let error as NSError {
            print("no!: \(error.localizedDescription)")
        }
        if carCarbon >= 1 {
            carbon.append(carCarbon)
            transport.append("car")
        }
        if walkCarbon >= 1 {
            carbon.append(walkCarbon)
            transport.append("walk")
        }
        if planeCarbon >= 1 {
            carbon.append(planeCarbon)
            transport.append("plane")
        }
        if trainCarbon >= 1 {
            carbon.append(trainCarbon)
            transport.append("train")
        }
        if bikeCarbon >= 1 {
            carbon.append(bikeCarbon)
            transport.append("bike")
        }
        if busCarbon >= 1 {
            carbon.append(busCarbon)
            transport.append("bus")
        }
        if metroCarbon >= 1 {
            carbon.append(metroCarbon)
            transport.append("metro")
        }
        if runCarbon >= 1 {
            carbon.append(runCarbon)
            transport.append("run")
        }
        
        //let transport = ["train", "metro", "car", "plane", "boat", "bike"]
        //let carbon = [88, 8, 26, 30, 8, 10]
        
        setChart(dataPoints: transport, values: carbon.map{ Double($0) })
        
        budgetBar(budgetValue)
        
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // Set  ChartDataSet
        let set = PieChartDataSet(entries: dataEntries)
        set.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        //set.colors = ChartColorTemplates.pastel()
        pieChartView.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width)
        //pieChartView.center = view.center
        
        // Set ChartData
        let data = PieChartData(dataSet: set)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        data.setValueFormatter(formatter)
        
        // Assign it to the chart’s data
        pieChartView.data = data
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
            pieChartView.backgroundColor = UIColor.white
        }
        return colors
    }
    
    func budgetBar(_ addedValues: Double) {
        //full is 1.2 tonnes per year -> 0.1 ton or 100kg in month
        
        let StartValue: Double = 0
        let fullProgress = StartValue+addedValues
        // Start value
        progressView.progress = Float(fullProgress)
        
        // Style
        progressView.progressTintColor = UIColor.green
        //progressView.backgroundColor = UIColor.systemBackground
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 5
        progressView.subviews[1].clipsToBounds = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
        updateProgressView()
    }
    
    @objc func updateProgressView(){
        progressView.progress += 0.1
        progressView.setProgress(progressView.progress, animated: true)
        
        if(progressView.progress >= 0.0) {
            textLabel.text = "used 0%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.1) {
            textLabel.text = "used 10%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.2) {
            textLabel.text = "used 20%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.3) {
            textLabel.text = "used 30%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.4) {
            textLabel.text = "used 40%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.5) {
            textLabel.text = "used 50%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.6) {
            textLabel.text = "used 60%"
            progressView.progressTintColor = UIColor.green
        }
        if(progressView.progress >= 0.7) {
            textLabel.text = "used 70%"
            progressView.progressTintColor = UIColor.orange
        }
        if(progressView.progress >= 0.8) {
            textLabel.text = "used 80%"
            progressView.progressTintColor = UIColor.orange
        }
        if(progressView.progress >= 0.9) {
            textLabel.text = "used 90%"
            progressView.progressTintColor = UIColor.orange
        }
        if (progressView.progress == 1.0) {
            textLabel.text = "used 100%"
            print("full")
            progressView.progressTintColor = UIColor.red
        }
    }
}
