//
//  DummyData.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 29.4.2021.
//

import Foundation
import CoreData
import UIKit

// for chart testing.
class DummyData {
    
    func fetchDummyData() {
        
        guard let url = URL(string: "https://users.metropolia.fi/~teemutr/test.json") else { fatalError("failed to create URL") }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Client error \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                //handle server error
                return
            }
            
            for result in [data] {
                print("data print test: \(result)")
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let activityInfo = try JSONDecoder().decode([MoprimStruct]?.self, from: data)
                
                print("dummydata count test: \(activityInfo?.count ?? 0)")
                
                //print("dummydata test: \(activityInfo?[1].features())")
                
                for result in [activityInfo] {
                    print("dummydata test: \(result ?? [])")
                }
                
                let context = AppDelegate.viewContext
                
                for oneActivity in activityInfo ?? [] {
                    context.perform {
                        Activity.createOneActivityObject(oneActivity)
                        try? context.save()
                        //print("dummydata saved to coredata: \(oneActivity)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

