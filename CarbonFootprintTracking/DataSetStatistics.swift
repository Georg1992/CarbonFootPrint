//
//  DataSetStatistics.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 22.4.2021.
//

import Foundation

//This struct is used as a way to conveniently "package" all needed information for lineChartView inside StatisticsViewController
struct DataSetStatistics {
    private(set) var timeStamp: String?
    private(set) var timeStampNoHour: String?
    private(set) var timeStampThisMonth: String?
    private(set) var timeStampThisYear: String?
    private(set) var carbonFootprint: Double?
    private(set) var vehicleType: String?
    
    init(timeStamp: String, timeStampNoHour: String, timeStampThisMonth: String, timeStampThisYear: String, carbonFootprint: Double, vehicleType: String) {
        self.timeStamp = timeStamp
        self.timeStampNoHour = timeStampNoHour
        self.timeStampThisMonth = timeStampThisMonth
        self.timeStampThisYear = timeStampThisYear
        self.carbonFootprint = carbonFootprint
        self.vehicleType = vehicleType
    }
}
