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

class BusinessesViewModel: ObservableObject {
  @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
  
  @Published var businesses: [SchemaV1.Business] = []
  
  @Published var mapBusiness: SchemaV1.Business {
    didSet {
      let coord = CLLocationCoordinate2D(latitude: mapBusiness.coordinates.latitude - 0.0002, longitude: mapBusiness.coordinates.longitude - 0.00005)
      updateRegion(coord)
    }
  }
  
  let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
  
  init() {
    mapBusiness = SchemaV1.Business()
//    let coordinates = CLLocationCoordinate2D(latitude: 0,longitude: 0)
//    updateRegion(coordinates)
  }
  
  private func updateRegion(_ coordinates: CLLocationCoordinate2D) {
    withAnimation(.easeInOut) {
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: coordinates, span: span))
    }
  }
  
  func showNextBusiness(_ area: SchemaV1.Area, _ business: SchemaV1.Business) {    
    if business.imageCount == 0 {
      var imageCounter = 0
      while UIImage(named: ("\(area.shortName)/\(business.name)/\(imageCounter)")) != nil {
        imageCounter += 1
      }
      business.imageCount = imageCounter
    }
    
    withAnimation(.easeInOut) {
      mapBusiness = business
    }
  }

}
