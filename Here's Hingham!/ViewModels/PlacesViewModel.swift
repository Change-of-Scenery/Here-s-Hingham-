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
  @Published var visible = false
  
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
      place.selected = place.name != ""
    }
    
    if place.imageCount == 0 {
      var imageCounter = 0
      let placeName = place.name == "" ? "Area" : place.name
      while UIImage(named: ("\(area.shortName)/\(placeName)/\(imageCounter)")) != nil {
        imageCounter += 1
      }
      if placeName == "Area" {
        area.imageCount = imageCounter
        visible = false
      } else {
        place.imageCount = imageCounter
        visible = true
      }
    } else {      
      visible = true
    }
    
    withAnimation(.easeInOut) {
      mapPlace = place
    }
  }
}

