//
//  MoprimStruct.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 29.4.2021.
//

import Foundation

struct MoprimStruct: Codable {
    var features: [Feature]
}

struct Feature: Codable {
    var properties: Properties
}

struct Properties: Codable {
    var co2: Double
    var activity: String
    
    enum CodingKeys: String, CodingKey {
        case co2 = "CO_2"
        case activity
    }
}


