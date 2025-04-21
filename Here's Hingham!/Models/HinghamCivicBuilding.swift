//
//  HinghamCivicBuilding.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import Foundation
import SwiftData
import MapKit

@Model
final class HinghamCivicBuilding {
  var timestamp: Date
  var areaID = 0
  var name = ""
  var shortName = ""
  var address = ""
  var coordinate = Coordinate2D(latitude: 0.0, longitude: 0.0)
  var desc = ""
  var notes = ""
  var website = ""
  var imageCount = 0
  
  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}
