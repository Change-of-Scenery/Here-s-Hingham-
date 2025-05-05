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
  @Environment(\.modelContext) private var modelContext
  @Published var region: MKCoordinateRegion = MKCoordinateRegion()
//  @Published var areas: [SchemaV1.Area] = []
  @Published var areas: [SchemaV1.Area] = [ SchemaV1.Area(name: "Hingham Square", shortName: "Square", desc:"This quaint and historic downtown is full of New England charm. including an assortment of boutiques, salons, and restaurants. The Old Ship church at the top of the square on Main St is the oldest wooden church in America still in use for its original purpose.", iconCoordinateLat: 42.24059, iconCoordinateLng: -70.88741, centerCoordinateLat: 42.24291, centerCoordinateLng: -70.88947, wikiName: "Old_Ship_Church"), SchemaV1.Area(name: "Hingham Shipyard", shortName: "Shipyard",desc:"Once a place where ships and landing craft were built during WWII, credited by General Eisenhower as responsible for making the D-Day invasion possible, and the war winnable. Today it you'll find modern rental apartments and townhouses, condos, a bustling restaurant and retail scene, along with the Hingham Terminal, which commuters rely on for their half hour ferry ride to and from  Boston.", iconCoordinateLat: 42.25111, iconCoordinateLng: -70.92055, centerCoordinateLat: 42.25081, centerCoordinateLng: -70.92255, wikiName: "Bethlehem_Hingham_Shipyard"), SchemaV1.Area(name: "Hingham Harbor", shortName: "Harbor",desc:"Recreational boating harbor that includes a large beach for swimming and the ever popular Beach House snack bar and Redeye Coffee Roasters which locals rave about! Right nearby is World's End, a 251 acre park that juts into Hingham Harbor that boasts sweeping lawns, tree-lined carriage paths, and superb Boston skyline views, once meant to be home of mansions or the headquarters of the United Nations.", iconCoordinateLat: 42.24642, iconCoordinateLng: -70.88214, centerCoordinateLat: 42.24482, centerCoordinateLng: -70.88484, wikiName: "World%27s_End_(Hingham)"), SchemaV1.Area(name: "Fearing Farm", shortName: "Fearing",desc:"Originally the farmland of M. Fearing, later developed with homes on large lots. You'll also find the irrestible Cottage St, which has graceful historic homes with romantic views overlooking Hingham Harbor.", iconCoordinateLat: 42.24259, iconCoordinateLng: -70.89757, centerCoordinateLat: 42.24477, centerCoordinateLng: -70.89339, wikiName: "Hingham,_Massachusetts"), SchemaV1.Area(name: "Crow Point", shortName: "Crow Point",desc:"Seaside community, originally built as summer cottages. Home of the Hingham Yacht Club and the Bouve Conservation Area featuring a short trail and the opportunity to walk along the rugged coast of Hewitt's Cove.", iconCoordinateLat: 42.24965, iconCoordinateLng: -70.90422, centerCoordinateLat: 42.24945, centerCoordinateLng: -70.90422, wikiName: "Hingham,_Massachusetts"), SchemaV1.Area(name: "Hingham South", shortName: "South",desc:"Besides the upscale Derby Street Shops, you'll find historic homes along Main St, the massive 3,526 acre Wompatuck State Park, golf courses, Scarlet Oak Tavern.", iconCoordinateLat: 42.18601, iconCoordinateLng: -70.89354, centerCoordinateLat: 42.18401, centerCoordinateLng: -70.8849, wikiName: "Wompatuck_State_Park") ]
  @Published var businesses: [SchemaV1.Business] = []
  @Published var mapArea: SchemaV1.Area {
    didSet {
      updateRegion(mapArea.coordinates)
    }
  }
  @Published var showAreasList:Bool = false
  @Published var sheetArea: SchemaV1.Area? = nil

  let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
  let closeInSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
  
  init() {
    mapArea = SchemaV1.Area()
    let coordinates = CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828)
    updateRegion(coordinates)
  }
  
  private func updateRegion(_ coordinates: CLLocationCoordinate2D) {
    withAnimation(.easeInOut) {
      region = MKCoordinateRegion(center: coordinates, span: span)
    }
  }
  
  public func toggleAreasList() {
    withAnimation(.easeInOut) {
      showAreasList = !showAreasList
    }
  }
  
  func showNextArea(_ area: SchemaV1.Area) {
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
