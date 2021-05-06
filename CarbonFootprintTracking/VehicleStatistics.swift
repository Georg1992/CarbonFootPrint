//
//  VehicleStatistics.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import Foundation

struct Vehicle {
    let vehicleType: String?
    
    private(set) var dayArray = [DataSetStatistics]()
    
    init (_ vehicleType: String) {
        self.vehicleType = vehicleType
    }
    
    //pushes data to dayArray (dayArray is used to hold all data for lineChartView)
    mutating func pushDataDay(_ data: DataSetStatistics) {
        var duplicates = 0
        
        //dayArray.contains method was not working properly so checking for duplicates is handled here
        for element in dayArray {
            if (element.carbonFootprint == data.carbonFootprint && element.timeStamp == data.timeStamp && element.vehicleType == data.vehicleType) {
                duplicates += 1
            }
        }
        if(duplicates == 0) {
            dayArray.append(data)
        }
    }
    
    //currently unused
    mutating func emptyData() {
        dayArray.removeAll()
    }
}
