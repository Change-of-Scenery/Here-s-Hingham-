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
  @State private var scrollViewID = UUID()
    
  let area: SchemaV1.Area
  let screenWidth = UIScreen.main.bounds.size.width
  
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 0) {
        imageSection
          .padding(.top, 2)
          .padding(.trailing, 19)
        viewDetailsButton
        directionsButton
      }
      .padding(10)
      .padding([.leading, .trailing], 5)
      .cornerRadius(10)
      HStack (alignment: .top) {
        titleSection
          .padding(.top, -20)
          .padding(.bottom, -5)
          .padding([.leading], 15)
          .padding([.trailing], 15)
      }
    }
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(colorScheme == .dark ? .black : .white)  // .ultraThinMaterial
        .offset(y: 40)
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
      Image(area.shortName + "/Area/1")
        .resizable()
        .cornerRadius(10)
        .frame(width: 100, height: 80)
        .onTapGesture {
//          areasViewModel.sheetArea = area
//          areasViewModel.mapArea = area
          withAnimation(.easeInOut) {
            let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta:  areasViewModel.zoom)
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
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let textHeight = placesViewModel.mapPlace.type == 6 ? 103.0 : 115.0
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold
    let bodySize = placesViewModel.mapPlace.type == 6 ? 12.0 : 14.0
    var name = areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.name : placesViewModel.mapPlace.name
    name += name.hasSuffix("Historic") ? " District" : ""
    let address = areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? "" : placesViewModel.mapPlace.address
    
    return VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(name)
          .font(.system(.title2, design: design, weight: weight))
          .foregroundColor(.primary)
          .scaledToFill()
          .minimumScaleFactor(0.5)
          .lineLimit(1)
          .onChange(of: placesViewModel.mapPlace) {
            scrollViewID = UUID()
          }
        Spacer()
        Text(address)
          .font(.system(.footnote, design: design, weight: .regular))
      }
      
      let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: areasViewModel.visible == true || placesViewModel.mapPlace.name == ""  ? area.desc : placesViewModel.mapPlace.notes)
      
      ScrollView(.vertical, showsIndicators: true) {
        Text(descText)
          .font(.system(size: bodySize, weight: .regular, design: design))
          .foregroundColor(.primary)
      }
      .id(self.scrollViewID)      
    }
    .frame(width: 380, height: textHeight)
    .padding(.trailing, 10)
    .padding(.top, screenWidth < 360 ? -5 : 10)
    .padding(.bottom, -20)
  }
  
  private var viewDetailsButton: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold

    return Button {
      if areasViewModel.visible == false {
        if areasViewModel.mapArea != area {
          areasViewModel.mapArea = area
        }
        placesViewModel.showPlace(area, placesViewModel.mapPlace)
        areasViewModel.visible = placesViewModel.mapPlace.name == ""
        showPlaceDetail = true
      } else {
        iconResizePercent = 0.0
        if (area.areaId == areasViewModel.mapArea.areaId) {
          withAnimation(.easeInOut) {
            areasViewModel.distance = 0.0
            areasViewModel.setFilterZoomDistance(filter: areasViewModel.filter, areaId: area.areaId)
            let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta: areasViewModel.zoom)
            areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
            areasViewModel.visible = false
          }
        } else {
          areasViewModel.mapArea = area
          placesViewModel.mapPlace = SchemaV1.Place()
          areasViewModel.showArea(area)
        }
        
        areasViewModel.firstScreenVisible = false
      }
    } label: {
      Text("View Details")
        .font(.system(.headline, design: design, weight: weight))
        .frame(width: screenWidth < 360 ? 75 : 105, height: 35)
        .foregroundColor(.white)
    }
    .buttonStyle(.borderedProminent)
    .cornerRadius(10.0)
    .padding([.trailing], screenWidth < 360 ? 18 : 26)
    .padding(.top, UIScreen.main.bounds.size.height < 800 ? 36.0 : 46.0)
  }
  
  private var directionsButton: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold

    return HStack {
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
          .font(.system(.subheadline, design: design, weight: weight))
          .frame(width: screenWidth < 360 ? 60 : 80, height: 35)
      }
      .buttonStyle(.bordered)
      .padding(.top, UIScreen.main.bounds.size.height < 800 ? 36.0 : 46.0)
      .padding(.trailing, 16)
      .frame(width: 75.0)
    }
    .padding(.leading, 5)
  }
}

//#Preview {
//  AreaPreviewView(area: AreasViewModel().areas.first!)
//}
