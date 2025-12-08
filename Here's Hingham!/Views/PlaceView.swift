//
//  PlaceView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 8/22/25.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct PlaceView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.colorScheme) var colorScheme
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.21427,longitude: -70.89328), span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)))
  @State private var annotationOpacity: Double = 1.0
  @State private var iconResizePercent: Double = 0.0
  @State private var paths: [String] = []
  @ObservedObject var location: LocationManager = LocationManager()
  
  var body: some View {
    NavigationStack(path: $paths) {
      ZStack {
        AreaDetailView(area: areasViewModel.mapArea)
      }
      .toolbar {
//        ToolbarItem(placement: .navigationBarLeading) {
//          Button { } label: { Image("AppToolbar").resizable().scaledToFill().frame(width: 35, height: 35).padding(.trailing, -12)  .padding(.leading, -8)}
//        }
        ToolbarItem(placement: .navigationBarLeading) {
          
        }
        ToolbarItem(placement: .automatic) {
          Button { areasViewModel.filter = 1 } label: { Image(systemName: "fork.knife")}.background(areasViewModel.filter == 1 ? Color("AccentTabColor") : Color.clear)
        }
        ToolbarItem(placement: .automatic) {
          Button { areasViewModel.filter = 7 } label: { Image(systemName: "cup.and.saucer")}.background(areasViewModel.filter == 7 ? Color("AccentTabColor") : Color.clear)
        }
        ToolbarItem(placement: .automatic) {
          Button { areasViewModel.filter = 2 } label: { Image(systemName: "handbag")}.background(areasViewModel.filter == 2 ? Color("AccentTabColor") : Color.clear)
        }
        //        ToolbarItem(placement: .automatic) {
        //          Button { areasViewModel.filter = 9 } label: { Image(systemName: "scissors")}.background(areasViewModel.filter == 9 ? Color.secondary : Color.clear)
        //        }
//        ToolbarItem(placement: .automatic) {
//          Button { areasViewModel.filter = 3 } label: { Image(systemName: "tshirt")}.background(areasViewModel.filter == 3 ? Color.tabSelect : Color.clear)
//        }
//        ToolbarItem(placement: .automatic) {
//          Button { areasViewModel.filter = 5 } label: { Image(systemName: "pill")}.background(areasViewModel.filter == 5 ? Color.tabSelect : Color.clear)
//        }
        ToolbarItem(placement: .automatic) {
          Button { areasViewModel.filter = 6 } label: { Image(systemName: "house")}.background(areasViewModel.filter == 6 ? Color("AccentTabColor") : Color.clear)
        }
        ToolbarItem(placement: .automatic) {
          Button { areasViewModel.filter = 8 } label: { Image(systemName: "tree")}.background(areasViewModel.filter == 8 ? Color("AccentTabColor") : Color.clear)
        }
        //        ToolbarItem(placement: .topBarTrailing) {
        //          Button { areasViewModel.filter = 0 } label: { Image(systemName: "map").foregroundColor(colorScheme == .dark ? darkFColor : lightFColor) }.padding(.bottom, 10).background(areasViewModel.filter == 0 ? selectColor : unselectColor)
        //        }
        //        .sheet(item: $areasViewModel.sheetArea) { area in
        //          if area.imageCount == 0 {
        //            var imageCounter = 0
        //            while UIImage(named: ("\(area.shortName)/Area/\(imageCounter)")) != nil {
        //              imageCounter += 1
        //            }
        //            area.imageCount = imageCounter
        //          }
        //
        //          AreaDetailView(area: area)
        //        }
      }
    }
    .toolbarTitleMenu {
      Button("Area Details") {
        paths.append("Area Details")
      }
      Button("Place Details") {
        paths.append("Place Details")
      }
    }
    .navigationDestination(for: String.self) { value in
      if value == "Area Details" {
        AreaDetailView(area: areasViewModel.mapArea)
      } else if value == "Place Details" {
        Text(value)
      }
    }
  }
}
  
//struct AreasView_Previews: PreviewProvider {
//  static var previews: some View {
//    AreasView()
//      .environmentObject(AreasViewModel())
//  }
//}



