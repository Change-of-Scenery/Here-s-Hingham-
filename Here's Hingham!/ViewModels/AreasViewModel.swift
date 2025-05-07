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
  @Published var areas: [SchemaV1.Area] = [
    SchemaV1.Area(name: "Hingham Square", shortName: "Square", desc:"This quaint and historic downtown is full of New England charm. including an assortment of boutiques, salons, and restaurants. The Old Ship church at the top of the square on Main St is the oldest wooden church in America still in use for its original purpose.", iconCoordinateLat: 42.24059, iconCoordinateLng: -70.88741, centerCoordinateLat: 42.24225, centerCoordinateLng: -70.88927, wikiName: "Old_Ship_Church"),
    SchemaV1.Area(name: "Fearing Farm", shortName: "Fearing",desc:"Originally the farmland of M. Fearing, later developed with homes on large lots. You'll also find the irrestible Cottage St, which has graceful historic homes with romantic views overlooking Hingham Harbor.", iconCoordinateLat: 42.24259, iconCoordinateLng: -70.89757, centerCoordinateLat: 42.24477, centerCoordinateLng: -70.89339, wikiName: "Hingham,_Massachusetts"),
    SchemaV1.Area(name: "Hingham Shipyard", shortName: "Shipyard",desc:"Once a place where ships and landing craft were built during WWII, credited by General Eisenhower as responsible for making the D-Day invasion possible, and the war winnable. Today it you'll find modern rental apartments and townhouses, condos, a bustling restaurant and retail scene, along with the Hingham Terminal, which commuters rely on for their half hour ferry ride to and from  Boston.", iconCoordinateLat: 42.25111, iconCoordinateLng: -70.92055, centerCoordinateLat: 42.25081, centerCoordinateLng: -70.92255, wikiName: "Bethlehem_Hingham_Shipyard"),
    SchemaV1.Area(name: "Hingham Harbor", shortName: "Harbor",desc:"Recreational boating harbor that includes a large beach for swimming and the ever popular Beach House snack bar and Redeye Coffee Roasters which locals rave about! Right nearby is World's End, a 251 acre park that juts into Hingham Harbor that boasts sweeping lawns, tree-lined carriage paths, and superb Boston skyline views, once meant to be home of mansions or the headquarters of the United Nations.", iconCoordinateLat: 42.24642, iconCoordinateLng: -70.88214, centerCoordinateLat: 42.24482, centerCoordinateLng: -70.88484, wikiName: "World%27s_End_(Hingham)"),
    SchemaV1.Area(name: "Hingham Center", shortName: "Center",desc:"Almost a town of its own, Hingham Center has boutiques, a coffee shop that closes at 2:00 PM, a Mom & Pop drug store the way they used to be, and the Buttonwood Tree, a sycamore that is the 2nd largest in the state of Masschussets. Down Middle St, which becomes Union St, is the Hingham High School", iconCoordinateLat: 42.23357, iconCoordinateLng: -70.879757, centerCoordinateLat: 42.23312, centerCoordinateLng: -70.87957, wikiName: "Hingham_High_School"),
    SchemaV1.Area(name: "Crow Point", shortName: "Crow Point",desc:"Seaside community, originally built as summer cottages. Home of the Hingham Yacht Club and the Bouve Conservation Area featuring a short trail and the opportunity to walk along the rugged coast of Hewitt's Cove.", iconCoordinateLat: 42.24965, iconCoordinateLng: -70.90422, centerCoordinateLat: 42.24945, centerCoordinateLng: -70.90422, wikiName: "Hingham,_Massachusetts"),
    SchemaV1.Area(name: "Hingham South", shortName: "South",desc:"Besides the upscale Derby Street Shops, you'll find historic homes along Main St, the massive 3,526 acre Wompatuck State Park, golf courses, Scarlet Oak Tavern.", iconCoordinateLat: 42.18601, iconCoordinateLng: -70.89354, centerCoordinateLat: 42.18401, centerCoordinateLng: -70.8849, wikiName: "Wompatuck_State_Park"),
    SchemaV1.Area(name: "Hingham East", shortName: "East",desc:"Hingham East is the home of the Hingham Public Library, which features a \"library of things,\" where you can borrow everything from artwork to photo equipment. Near the library is the Weir River Farm that has regular events for the public, and Turkey Hill where you can enjoy a fine view of Boston in a bucolic setting. East Street was once called Cohasset Street, since it leads directly to Cohasset Village.", iconCoordinateLat: 42.23611, iconCoordinateLng: -70.86601, centerCoordinateLat: 42.23611, centerCoordinateLng: -70.87101, wikiName: "Weir_River_Farm"),
    SchemaV1.Area(name: "Hingham West", shortName: "West",desc:"Just west of Hingham Square is where you'll find the homes of General Benjamin Lincoln, the revolutionary war general who accepted the British surrender at Yorktown, Robert Lincoln, and Samuel Lincoln, the first ancestor of Abraham Lincoln in the New World.", iconCoordinateLat: 42.23522, iconCoordinateLng: -70.90811, centerCoordinateLat: 42.23882, centerCoordinateLng: -70.90073, wikiName: "Benjamin_Lincoln"),
    SchemaV1.Area(name: "Hingham High St", shortName: "High St",desc:"Along Main St and especially below the intersection with High St are some of the oldest and most beautiful historic homes you will see in America. Go east on High St to reach the main entrance of Wompatuck State Park. \"The Barrel,\" at 613 Main St, is a general store established in 1850 under the name \"Cracker Barrel\" before the more famous chain of that name came into existance. To avoid confusion, it was renamed. The Barrel is a family magnet, with picnic tables and a bean bag toss game outside.", iconCoordinateLat: 42.21801, iconCoordinateLng: -70.8849, centerCoordinateLat: 42.21801, centerCoordinateLng: -70.8849, wikiName: "https://www.hinghamanchor.com/from-cracker-barrel-to-the-barrel-new-trial-sign-name-but-nothing-else-has-changed/")
    ]
    
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
