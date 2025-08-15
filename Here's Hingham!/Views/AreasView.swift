//
//  AreasView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/28/25.
//

import SwiftUI
import SwiftData
import MapKit

struct AreasView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @State private var annotationOpacity: Double = 1.0
  @ObservedObject var location: LocationManager = LocationManager()

  var showAppBanner = true
  
  var body: some View {
    ZStack {
      if areasViewModel.visible == true {
        areaMapLayer
      } else {
        placeMapLayer
      }
      
      VStack(spacing: 0) {
        Spacer()
        areasPreviewStack
      }
    }
    .sheet(item: $areasViewModel.sheetArea) { area in
      if area.imageCount == 0 {
        var imageCounter = 0
        while UIImage(named: ("\(area.shortName)/Area/\(imageCounter)")) != nil {
          imageCounter += 1
        }
        area.imageCount = imageCounter
      }
      
      return AreaDetailView(area: area)
    }
  }
}

struct AreasView_Previews: PreviewProvider {
  static var previews: some View {
    AreasView()
      .environmentObject(AreasViewModel())
  }
}

extension AreasView {
  
  private var header: some View {
    HStack {
      Button(action: areasViewModel.toggleAreasList) {
        Text(areasViewModel.mapArea.name)
          .font(.title2)
          .fontWeight(.black)
          .foregroundColor(.primary)
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .animation(.none, value: areasViewModel.mapArea)
          .overlay(alignment: .leading) {
            Image(systemName: "arrow.down")
              .font(.headline)
              .foregroundColor(.primary)
              .padding()
              .rotationEffect(Angle(degrees: areasViewModel.showAreasList ? 180 : 0))
          }
      }
      
      if areasViewModel.showAreasList {
        AreasListView()
      }
      
    }
    .background(.thickMaterial)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
  }
  
  private var areaMapLayer: some View {
    Map(initialPosition: position) {
      ForEach(areasViewModel.areas) { area in
        Annotation(area.name, coordinate: area.coordinates) {
          AreaAnnotationView(title: area.name, selected: areasViewModel.mapArea == area, opacity: annotationOpacity)
            .scaleEffect(areasViewModel.mapArea == area ? 1.2 : 0.7)
            .shadow(radius: 10)
            .onTapGesture {
              areasViewModel.showArea(area)
            }
        }
        .annotationTitles(.hidden)
      }
    }
    .ignoresSafeArea()
    .onMapCameraChange(frequency: .continuous, {
      annotationOpacity = 0.3
    })
    .onMapCameraChange(frequency: .onEnd) { context in
      annotationOpacity = 1.0
    }
  }
  
  private var placeMapLayer: some View {
    let area = areasViewModel.mapArea
    let places = placesViewModel.places.filter { $0.areaId == area.areaId }
    
    return Map(position: $areasViewModel.mapCameraPosition, interactionModes: [.pan, .zoom]) {
      ForEach(places) { place in
        Annotation("", coordinate: place.coordinates) {
          withAnimation(.easeInOut) {
            PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, iconSize: place.iconSize, selected: place.selected, opacity: annotationOpacity)
              .shadow(radius: 10)
              .onTapGesture {
                withAnimation(.easeInOut) {
                  placesViewModel.showPlace(area, place)
                  areasViewModel.zoomIn()
                }
              }
          }
        }
        .annotationTitles(.visible)
      }
      
      UserAnnotation()
    }
    .ignoresSafeArea()
    .onMapCameraChange(frequency: .continuous) { context in
      areasViewModel.centerCoordinate = context.region.center

      if areasViewModel.mapCameraPosition.region == nil {
        areasViewModel.mapCameraPosition = MapCameraPosition.region(context.region)
      }
    }
    .background(.white)
    .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
    .mapControls {
      Button {
        let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
        areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.userLocation?.coordinate.latitude ?? 0.0, longitude: location.userLocation?.coordinate.longitude ?? 0.0), span: span))
      } label: {
        Image(systemName: "location.fill")
      }
    }
    .overlay {
      ZStack {
        VStack {
          HStack {
            Spacer(minLength: 0)
            Button {
              areasViewModel.showArea(area)
            } label: {
              Image(systemName: "return")
                .padding([.top, .trailing], 10)
                .foregroundColor(.black)
            }
          }
          Spacer(minLength: 0)
        }
      }
    }
  }

  
  private var appBanner: some View {
    Image("AppBanner")
  }
  
  private var areasPreviewStack: some View {
    ZStack {
      ForEach(areasViewModel.areas) { area in
        if areasViewModel.mapArea == area {
          AreaPreviewView(area: area)
            .shadow(color: .black.opacity(0.3), radius: 20)
            .padding()
            .transition(.asymmetric(insertion: .move(edge: .trailing) , removal: .move(edge: .leading)))
        }
      }
    }
  }
}

