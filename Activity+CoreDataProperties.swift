//
//  Activity+CoreDataProperties.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 6.5.2021.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var activity: String?
    @NSManaged public var co2: Double
    @NSManaged public var date: String?
    @NSManaged public var duration: Double
    @NSManaged public var timestampStart: Int64
    @NSManaged public var dateWithHour: String?
    @NSManaged public var dateMonthYear: String?
    @NSManaged public var dateYear: String?

}

extension Activity : Identifiable {

}
