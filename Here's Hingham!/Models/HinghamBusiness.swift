//
//  HinghamBusiness.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import Foundation
import SwiftData
import MapKit

@Model
final class HinghamBusiness {
  var timestamp: Date
  var areaID = 0
  var name = ""
  var shortName = ""
  var address = ""
  var coordinate = Coordinate2D(latitude: 0.0, longitude: 0.0)
  var desc = ""
  var notes = ""
  var website = ""
  var hours = ""
  var phone = ""
  var price = ""
  var imageCount = 0
  var googlePlaceId = ""
  var yelpPlaceId = ""
  var googleRating = ""
  var googleReviews = 0
  var yelpRating = 0.0
  var yelpReviews = 0
  var yelpCategory = ""
  var yelpUrl = ""
  var size = CGSize()
  var hasSpecial = false
  var backgroundColor = ""
          
  init(timestamp: Date) {
      self.timestamp = timestamp
  }
}
