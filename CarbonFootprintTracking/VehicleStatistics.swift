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
        dayArray.append(data)
        //weekArray.append(data)
        //monthArray.append(data)
        //yearArray.append(data)
    }
    
    mutating func pushDataWeek(_ data: DataSetStatistics) {
        
    }
    
    mutating func pushDataMonth(_ data: DataSetStatistics) {
        
    }
    
    mutating func pushDataYear(_ data: DataSetStatistics) {
        
    }
    
    
}
