//
//  Activity+CoreDataClass.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 30.4.2021.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    class func createOneActivityObject (_ oneActivity: MoprimStruct) {
        
        let request:NSFetchRequest<Activity> = Activity.fetchRequest()
        //request.predicate = NSPredicate(format: "co2 = %d", oneActivity.features(Properties.init(co2: Int(co2), activity: activity!)))
        
        // for testing
        let array = ["car", "train", "plane", "walk", "bike", "bus", "metro", "run"]
        
        // Creates Date
        let date = Date()
        // Creates Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        
        let today = dateFormatter.string(from: date)
        
        let context = AppDelegate.viewContext
        
        if let matchingActivity = try? context.fetch(request) {
            
            // these create dummy data for charts
            
            //if (matchingActivity.count == 0) {
            let newActivity = Activity(context: context)
            newActivity.co2 = Double(Int.random(in: 1..<10000000))
            //newActivity.co2 = Double(oneActivity.co2)
            newActivity.activity = array.randomElement()!
            newActivity.date = today
            //print("create object: \(newActivity)")
            //}
        }
    }
}
