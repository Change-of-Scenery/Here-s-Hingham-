//
//  HinghamArea.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import Foundation
import SwiftData
import MapKit

@Model
final class HinghamArea {
  var timestamp: Date
  var id = 0
  @Attribute(.unique) var name = ""
  var shortName = ""
  var centerCoordinate = Coordinate2D(latitude: 0.0, longitude: 0.0)
  var iconCoordinate = Coordinate2D(latitude: 0.0, longitude: 0.0)
  var tilt = 0
  var zoom = 0
  var hinghamBusinesses: [HinghamBusiness] = []
  
  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}
