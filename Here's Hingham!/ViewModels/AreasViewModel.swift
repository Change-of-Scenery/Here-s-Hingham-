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
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AreasViewModel: ObservableObject {
  @Published var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))

  @Published var areas: [SchemaV1.Area] = []
  @Published var previewArea = SchemaV1.Area()
  @Published var mapArea: SchemaV1.Area {
    didSet {
      let span = MKCoordinateSpan(latitudeDelta: mapArea.zoom, longitudeDelta:  mapArea.zoom) //  mapArea.areaId == 0 || mapArea.areaId == 6 ? mapArea.zoomInSpan : mapArea.zoomSpan
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: mapArea.centerCoordinates, span: span))
//      if let latitude = mapCameraPosition.region?.center.latitude {
//        if latitude == 42.23227 {
//          let span = mapArea.areaId == 0 || mapArea.areaId == 6 ? mapArea.zoomInSpan : mapArea.zoomSpan
//          mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: mapArea.centerCoordinates, span: span))
//        }
//      }
      updateRegion(mapCameraPosition)
    }
  }
  @Published var showAreasList:Bool = false
  @Published var sheetArea: SchemaV1.Area? = nil
  @Published var centerCoordinate: CLLocationCoordinate2D

  let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
  
  init() {
    mapArea = SchemaV1.Area()
    centerCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // , span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
//    updateRegion(MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
  }
  
  public func addArea(_ area: SchemaV1.Area) {
    areas.append(area)
  }
  
  private func updateRegion(_ mapCameraPosition: MapCameraPosition) {
    withAnimation(.easeInOut) {
      self.mapCameraPosition = mapCameraPosition
    }
  }
  
  public func toggleAreasList() {
    withAnimation(.easeInOut) {
      showAreasList = !showAreasList
    }
  }
  
  func showArea(_ area: SchemaV1.Area) {
    if area.imageCount == 0 {
      var imageCounter = 0
      while UIImage(named: ("\(area.shortName)/Area/\(imageCounter)")) != nil {
        imageCounter += 1
      }
      area.imageCount = imageCounter
    }

    withAnimation(.easeInOut) {
      self.mapArea = area
      self.showAreasList = false
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
      showArea(firstArea)
      return
    }
    
    let nextArea = areas[nextIndex]
    showArea(nextArea)
  }
  
  func zoomOut() {
    let mapCameraPosition: MapCameraPosition
    
    if centerCoordinate.latitude == 0.0 {
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapArea.centerCoordinateLat - 0.0002, longitude: mapArea.centerCoordinateLng - 0.00005), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)))
    } else {
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)))
    }
    
    updateRegion(mapCameraPosition)
  }
  
  func zoomIn() {
    updateRegion(MapCameraPosition.region(MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))))
  }
}
