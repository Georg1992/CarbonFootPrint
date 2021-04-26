//
//  PieViewController.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 20.4.2021.
//

import Charts
import UIKit

class PieViewController: UIViewController{
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transport = ["train", "metro", "car", "plane", "boat", "bike"]
        let carbon = [6, 8, 26, 30, 8, 10]
        
        setChart(dataPoints: transport, values: carbon.map{ Double($0) })
        
        budgetBar()
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
    
    func budgetBar() {
        // Start value
        progressView.progress = Float(budgetProgress())
        
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
    
    func budgetProgress() -> Double {
        let prog: Double = 0
        //test value
        let addTestCar: Double = 0.3
        let allProg = prog+addTestCar
        return allProg
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
