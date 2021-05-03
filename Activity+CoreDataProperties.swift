//
//  Activity+CoreDataProperties.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 30.4.2021.
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

}

extension Activity : Identifiable {

}
