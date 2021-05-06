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
    
    private(set) var weekArray = [DataSetStatistics]()
    
    private(set) var monthArray = [DataSetStatistics]()
    
    private(set) var yearArray = [DataSetStatistics]()
    
    init (_ vehicleType: String) {
        self.vehicleType = vehicleType
    }
    
    mutating func pushDataDay(_ data: DataSetStatistics) {
        var duplicates = 0
        for element in dayArray {
            if (element.carbonFootprint == data.carbonFootprint && element.timeStamp == data.timeStamp && element.vehicleType == data.vehicleType) {
                duplicates += 1
            }
        }
        if(duplicates == 0) {
            dayArray.append(data)
        }
    }
    
    mutating func emptyData() {
        dayArray.removeAll()
    }
    
    
}
