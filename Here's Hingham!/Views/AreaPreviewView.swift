//
//  AreaPreviewView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/30/25.
//

import SwiftUI
import MapKit

struct AreaPreviewView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var location: LocationManager = LocationManager()
  @Binding var iconResizePercent: Double
  @Binding var showPlaceDetail: Bool
  
  let area: SchemaV1.Area
  let screenWidth = UIScreen.main.bounds.size.width
  
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 0) {
        imageSection
        zoomInButton
        directionsButton
      }
      .padding(10)
      .padding([.leading, .trailing], 10)
      .cornerRadius(10)
      HStack (alignment: .top) {
        titleSection
          .padding(.top, -10)
          .padding(.bottom, 15)
          .padding([.leading], 20)
          .padding([.trailing], 15)
          .frame(height: 100)
      }
    }
    .frame(height: 200)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(colorScheme == .dark ? .black : .white)  // .ultraThinMaterial
        .offset(y: 22)
    )
  }
}

//struct AreaPreviewView_Previews: PreviewProvider {
//  static var previews: some View {
//    ZStack {
//      Color.green.ignoresSafeArea()
//      AreaPreviewView(iconResizePercent: 0.0, area: AreasViewModel().previewArea)
//        .padding()
//    }
//    .environmentObject(AreasViewModel())
//  }
//}

//let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
//let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
//
//ForEach(0..<imageCount, id: \.self) { index in
//  if UIImage(named: "\(path)/\(index)") != nil {
//    Image("\(path)/\(index)")
//      .resizable()
//      .scaledToFit()
//      .cornerRadius(25)
//  }
//}
//

extension AreaPreviewView {  
  private var imageSection: some View {
    ZStack {
      Image(areasViewModel.visible == true ? area.shortName + "/Area/0" : placesViewModel.mapPlace.name == "" ? area.shortName + "/Area/1" :  "\(area.shortName)/\(placesViewModel.mapPlace.name)/0")
        .resizable()
        .scaledToFill()
        .cornerRadius(10)
        .onTapGesture {
//          areasViewModel.sheetArea = area
//          areasViewModel.mapArea = area
          withAnimation(.easeInOut) {
            let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
            areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
            areasViewModel.visible = false
          }
        }
    }
    .padding(6)
    .background(.accent.opacity(0.75))
    .cornerRadius(10)
    .shadow(color: .black.opacity(0.75), radius: 4, x: 3, y: 3)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.name : placesViewModel.mapPlace.name)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.primary)
        .scaledToFill()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      
      let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: areasViewModel.visible == true || placesViewModel.mapPlace.name == ""  ? area.desc : placesViewModel.mapPlace.notes)
      
      ScrollView {
        Text(descText)
          .font(.system(size: 14))
          .foregroundColor(.primary)
      }
    }
    .frame(width: screenWidth * 0.9, height: 100)
    .padding(.trailing, 10)
    .padding(.top, screenWidth < 360 ? -5 : 10)
  }
  
  private var zoomInButton: some View {
    Button {
      if areasViewModel.visible == false {
        if areasViewModel.mapArea != area {
          areasViewModel.mapArea = area
        }
        placesViewModel.showPlace(area, placesViewModel.mapPlace)
        showPlaceDetail = true
      } else {
        withAnimation(.easeInOut) {
          areasViewModel.distance = 0.0
          areasViewModel.setFilterZoomDistance(filter: areasViewModel.filter, areaId: area.areaId)
          let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta: areasViewModel.zoom)
          areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
          areasViewModel.visible = false
        }
      }
    } label: {
      Text("View Details")
        .font(.headline)
        .frame(width: screenWidth < 360 ? 90 : 120, height: 35)
        .foregroundColor(.white)
    }
    .buttonStyle(.borderedProminent)
    .cornerRadius(10.0)
    .padding([.leading, .trailing], screenWidth < 360 ? 7 : 15)
    .padding(.top, UIScreen.main.bounds.size.height < 900 ? 32.0 : 42.0)
    .opacity(areasViewModel.visible == true || placesViewModel.visible == true ? 1.0 : 0.0)    
  }
  
  private var directionsButton: some View {
    HStack {
      Button {
        location.startUpdating()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
          if let userLocation = location.userLocation {
            var targetLat = area.centerCoordinateLat
            var targetLng = area.centerCoordinateLng
            
            if placesViewModel.mapPlace.name != "" {
              targetLat = placesViewModel.mapPlace.locationLat
              targetLng = placesViewModel.mapPlace.locationLng
            }
            
            let urlString = "http://maps.apple.com/?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(targetLat),\(targetLng)"
            if let url = URL(string: urlString) {
              if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
            }
          }
        }
      } label: {
        Text("Directions")
          .font(.subheadline)
          .fontWeight(.bold)
          .frame(width: screenWidth < 360 ? 60 : 80, height: 35)
      }
      .buttonStyle(.bordered)
      .padding(.top, UIScreen.main.bounds.size.height < 900 ? 32.0 : 42.0)
      .frame(width: 75.0)
      .opacity(areasViewModel.visible == true || placesViewModel.visible == true ? 1.0 : 0.0)
    }
    .padding([.leading, .trailing], 10)
  }  
}

//#Preview {
//  AreaPreviewView(area: AreasViewModel().areas.first!)
//}
