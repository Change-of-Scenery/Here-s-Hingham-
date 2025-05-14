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
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  
  var body: some View {
    ZStack {
      mapLayer
      
      VStack(spacing: 0) {
        header
          .padding()
        
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
    VStack {
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
  
  private var mapLayer: some View {
    Map(position: $areasViewModel.mapCameraPosition) {
      ForEach(areasViewModel.areas) { area in
        Annotation(area.name, coordinate: area.coordinates) {
          AreaAnnotationView()
            .scaleEffect(areasViewModel.mapArea == area ? 1.2 : 0.7)
            .shadow(radius: 10)
            .onTapGesture {
              areasViewModel.showNextArea(area)
            }
        }
        .annotationTitles(.visible)
      }
    }
    .ignoresSafeArea()
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
