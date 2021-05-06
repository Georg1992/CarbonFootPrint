//
//  Activity+CoreDataClass.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 30.4.2021.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    class func createOneActivityObject (_ oneActivity: MoprimData) {
        
        let request:NSFetchRequest<Activity> = Activity.fetchRequest()
        request.predicate = NSPredicate(format: "co2 = %d", oneActivity.co2)
        
        // for testing
        //let array = ["car", "train", "plane", "walk", "bike", "bus", "metro", "run"]
        
        // Creates Date
        let date = Date()
        // Creates Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        
        let today = dateFormatter.string(from: date)
        
        let context = AppDelegate.viewContext
        
        if let matchingActivity = try? context.fetch(request) {
            
            if (matchingActivity.count == 0) {
            let newActivity = Activity(context: context)
            
            let shortTransportation: String?
            
            switch oneActivity.activity {
            case "motorized/road/car":
                shortTransportation = "car"
            case "non-motorized/pedestrian/walk":
                shortTransportation = "walk"
            case "motorized/rail/train":
                shortTransportation = "train"
            case "motorized/rail/metro":
                shortTransportation = "metro"
            case "motorized/road/bus":
                shortTransportation = "bus"
            case "non-motorized/pedestrian/run":
                shortTransportation = "run"
            case "motorized/air/plane":
                shortTransportation = "plane"
            case "non-motorized/bicycle":
                shortTransportation = "bicycle"
            case "motorized/rail/tram":
                shortTransportation = "tram"
            default:
                shortTransportation = "no transport"
            }
            
            newActivity.co2 = Double(oneActivity.co2)
            newActivity.activity = shortTransportation
            newActivity.date = today
            
            // these create dummy data for charts
            //newActivity.co2 = Double(Int.random(in: 1..<10000000))
            //newActivity.activity = array.randomElement()!
            //print("create object: \(newActivity)")
            }
        }
    }
}

