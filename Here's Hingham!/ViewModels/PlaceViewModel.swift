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

class PlaceViewModel: ObservableObject {
  @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
  @Published var places: [SchemaV1.Place] = []
  @Published var mapPlace: SchemaV1.Place {
    didSet {
      let coord = CLLocationCoordinate2D(latitude: mapPlace.coordinates.latitude - 0.0002, longitude: mapPlace.coordinates.longitude - 0.00005)
      updateRegion(coord)
    }
  }
  
  let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
  
  init() {
    mapPlace = SchemaV1.Place()
//    let coordinates = CLLocationCoordinate2D(latitude: 0,longitude: 0)
//    updateRegion(coordinates)
  }
  
  private func updateRegion(_ coordinates: CLLocationCoordinate2D) {
    withAnimation(.easeInOut) {
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: coordinates, span: span))
    }
  }
  
  func showNextPlace(_ area: SchemaV1.Area, _ place: SchemaV1.Place) {
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
