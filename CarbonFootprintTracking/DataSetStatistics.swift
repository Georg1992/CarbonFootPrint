//
//  DataSetStatistics.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import Foundation

struct DataSetStatistics {
    private(set) var timeStamp: String?
    private(set) var carbonFootprint: Double?
    private(set) var vehicleType: String?
    
    init(timeStamp: String, carbonFootprint: Double, vehicleType: String) {
        self.timeStamp = timeStamp
        self.carbonFootprint = carbonFootprint
        self.vehicleType = vehicleType
    }
}
