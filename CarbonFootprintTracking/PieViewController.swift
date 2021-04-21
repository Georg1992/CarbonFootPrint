//
//  PieViewController.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 20.4.2021.
//

import Charts
import UIKit

class PieViewController: UIViewController, ChartViewDelegate{
    
    @IBOutlet var pieChartView: PieChartView!
    
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        
        //data
        let set = PieChartDataSet(entries: [
            
            PieChartDataEntry(value: 1,
                              data: 1),
            
            PieChartDataEntry(value: 5,
                              data: 5),
            
            PieChartDataEntry(value: 9,
                              data: 8),
            
        ])
        
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
}
