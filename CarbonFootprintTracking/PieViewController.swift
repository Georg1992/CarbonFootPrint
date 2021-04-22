//
//  PieViewController.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 20.4.2021.
//

import Charts
import UIKit

class PieViewController: UIViewController{
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transport = ["train", "metro", "car", "plane", "boat", "bike"]
        let carbon = [6, 8, 26, 30, 8, 10]
        
        setChart(dataPoints: transport, values: carbon.map{ Double($0) })
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataSet
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
}
