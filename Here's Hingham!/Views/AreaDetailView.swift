//
//  AreaDetailView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI
import MapKit

struct AreaDetailView: View {
  
  @EnvironmentObject private var vm: AreasViewModel
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @State private var closeInPosition = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
  let area: SchemaV1.Area
  
  var body: some View {
    ScrollView {
      VStack {
        imageSection
          .shadow(color: .black.opacity(0.3), radius: 20, x:0, y:10)
        
        VStack(alignment: .leading, spacing: 16) {
          titleSection
          Divider()
          descSection
          Divider()
          mapLayer
        }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
      }
    }
    .ignoresSafeArea()
    .background(.ultraThinMaterial)
    .overlay(backButton, alignment: .topLeading)
  }

}
//private var descSection: some View {
//  Text(area.desc)
//    .font(.body)
//    .foregroundColor(.secondary)
//}

extension AreaDetailView {
    
  private var imageSection: some View {
    TabView {
      ForEach(0..<22) { index in
        Image("\(area.shortName)/Area\(index)")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width)
          .clipped()
      }
    }
    .frame(height: 400)
    .tabViewStyle(PageTabViewStyle())
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(area.name)
        .font(.largeTitle)
        .fontWeight(.semibold)
    }
  }

  private var descSection: some View {
      VStack(alignment: .leading, spacing: 16) {
          Text(area.desc)
              .font(.subheadline)
              .foregroundColor(.secondary)

        if let url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)" ) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
      }
  }
  
  private var mapLayer: some View {
    let position = MapCameraPosition.region(
      MKCoordinateRegion(center: area.centerCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
       
    return Map(initialPosition: position) {
      Annotation(area.name, coordinate: area.centerCoordinates) {
        AreaAnnotationView()
          .shadow(radius: 10)
      }
    }
    .allowsHitTesting(false)
    .aspectRatio(1, contentMode: .fit)
    .cornerRadius(30)
    .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
  }
  
  private var backButton: some View {
    Button {
      vm.sheetArea = nil
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
        .padding(16)
        .foregroundColor(.primary)
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
        .padding()
    }
  }
  
}
  
#Preview {
  AreaDetailView(area: AreasViewModel().areas.first!)
    .environmentObject(AreasViewModel())
}
