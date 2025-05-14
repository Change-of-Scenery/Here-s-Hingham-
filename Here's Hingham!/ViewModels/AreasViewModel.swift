//
//  AreasViewModel.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/28/25.
//

import Foundation
import MapKit
import SwiftUI
import SwiftData

class AreasViewModel: ObservableObject {
  @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @Published var areas: [SchemaV1.Area] = []
    
  @Published var mapArea: SchemaV1.Area {
    didSet {
      updateRegion(mapArea.coordinates)
    }
  }
  @Published var showAreasList:Bool = false
  @Published var sheetArea: SchemaV1.Area? = nil

  let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
  let closeInSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
  
  init() {
    mapArea = SchemaV1.Area()
    let coordinates = CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828)
    updateRegion(coordinates)
  }
  
  private func updateRegion(_ coordinates: CLLocationCoordinate2D) {
    withAnimation(.easeInOut) {
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: coordinates, span: span))
    }
  }
  
  public func toggleAreasList() {
    withAnimation(.easeInOut) {
      showAreasList = !showAreasList
    }
  }
  
  func showNextArea(_ area: SchemaV1.Area) {
    if area.imageCount == 0 {
      var imageCounter = 0
      while UIImage(named: ("\(area.shortName)/Area/\(imageCounter)")) != nil {
        imageCounter += 1
      }
      area.imageCount = imageCounter
    }
      
    withAnimation(.easeInOut) {
      mapArea = area
      showAreasList = false
    }
  }
  
  func nextButtonPressed() {
    guard let currentIndex = areas.firstIndex(where: { $0 == mapArea}) else {
      print("Could not find index in areas area.")
      return
    }
    
    let nextIndex = currentIndex + 1
    guard areas.indices.contains(nextIndex) else {
      guard let firstArea = areas.first else { return }
      showNextArea(firstArea)
      return
    }
    
    let nextArea = areas[nextIndex]
    showNextArea(nextArea)
  }
}
