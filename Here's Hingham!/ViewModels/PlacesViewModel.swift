//
//  BusinessesViewModel.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/7/25.
//

import Foundation
import MapKit
import SwiftUI
import SwiftData

class PlacesViewModel: ObservableObject {
  @Published var places: [SchemaV1.Place] = []
  @Published var mapPlace: SchemaV1.Place
  
  init() {
    mapPlace = SchemaV1.Place()
  }
  
  public func addPlace(_ place: SchemaV1.Place) {
    places.append(place)
  }
    
  func showPlace(_ area: SchemaV1.Area, _ place: SchemaV1.Place) {
    if mapPlace == place && (mapPlace.selected == true || place.selected == true) {
      place.selected = false
    } else {
      mapPlace.selected = false
      place.selected = true
    }
    
    if place.imageCount == 0 {
      var imageCounter = 0
      while UIImage(named: ("\(area.shortName)/\(place.name)/\(imageCounter)")) != nil {
        imageCounter += 1
      }
      place.imageCount = imageCounter
    }
    
    withAnimation(.easeInOut) {
      mapPlace = place
    }
  }
}

