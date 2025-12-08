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
  @Published var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic) {
    didSet {

    }
  }

  @Published var zoom: Double = 0.005
  @Published var areas: [SchemaV1.Area] = []
  @Published var previewArea = SchemaV1.Area()
  @Published var mapArea: SchemaV1.Area = SchemaV1.Area() {
    didSet {
      let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
      mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: mapArea.centerCoordinates, span: span))
      updateRegion(mapCameraPosition)
    }
  }
  @Published var previewImageUrl = ""
  @Published var showAreasList:Bool = false
  @Published var sheetArea: SchemaV1.Area? = nil
  @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
  @Published var showWatermark = true
  @Published var showExpandedImage = false
  @Published var visible = true
  @Published var firstScreenVisible = true
  @Published var distance: Double = 0.0
  @Published var imagePath = ""
  @Published var imageCount = 0

  @Published var filter: Int = 0 {
    didSet {
      let db = Firestore.firestore()
      
      for area in areas {
        db.collection("HinghamPlace").whereField("areaId", isEqualTo: area.areaId).whereField("type", in: [self.filter]).getDocuments { queryPlace, err in
          if queryPlace!.documents.count > 0 {
            switch self.filter {
            case 1:
              area.iconImage = "fork.knife.circle.fill"
            case 2, 3, 5, 9:
              area.iconImage = "handbag.circle.fill"
            case 6:
              area.iconImage = "house.circle.fill"
            case 7:
              area.iconImage = "cup.and.saucer.circle.fill"
            case 8:
              area.iconImage = "tree.circle.fill"
            case 11:
              area.iconImage = "bucket.circle.fill"
            default:
              area.iconImage = "map.circle.fill"
            }
          } else {
            area.iconImage = "map.circle.fill"
          }
        }
      }
    }
  }

  let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
  
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
//      self.mapArea = area
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
  
  func zoomIn(_ zoom:Double) {
    updateRegion(MapCameraPosition.region(MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))))
  }
  
  func setFilterZoomDistance(filter:Int, areaId:Int) {
    if filter > 0 {
      switch filter {
      case 1:
        if areaId == 0 {
          zoom = 0.005
          distance = 800
        }
        break
      case 2:
        if areaId == 0 {
          zoom = 0.005
          distance = 400
        }
        break
      case 3:
        if areaId == 0 {
          zoom = 0.005
          distance = 700
        }
        break
      case 5:
        if areaId == 0 {
          zoom = 0.007
          distance = 400
        }
        break
      case 6, 8:
        zoom = 0.02
        distance = 500
        break
      case 7:
        if areaId == 0 {
          zoom = 0.007
          distance = 400
        }
        break
      default:
        if areaId == 3 {
          zoom = 0.002
        } else {
          zoom = 0.01
        }
        break
      }
    } else {
      distance = 0.0
    }
  }
}
