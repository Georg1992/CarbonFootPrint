//
//  MoprimStruct.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 29.4.2021.
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
    
    /*
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.co2 = try container.decode(Double.self, forKey: .co2)
      self.activity = try container.decode(String.self, forKey: .activity)
    }
     */
     /*
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.co2, forKey: .co2)
      try container.encode(self.activity, forKey: .activity)
    }
 */
}


