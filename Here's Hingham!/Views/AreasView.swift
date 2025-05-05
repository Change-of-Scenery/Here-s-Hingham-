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
  @EnvironmentObject private var vm: AreasViewModel
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
    .sheet(item: $vm.sheetArea) { area in
      AreaDetailView(area: area)
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
      Button(action: vm.toggleAreasList) {
        Text(vm.mapArea.name)
          .font(.title2)
          .fontWeight(.black)
          .foregroundColor(.primary)
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .animation(.none, value: vm.mapArea)
          .overlay(alignment: .leading) {
            Image(systemName: "arrow.down")
              .font(.headline)
              .foregroundColor(.primary)
              .padding()
              .rotationEffect(Angle(degrees: vm.showAreasList ? 180 : 0))
          }
      }
      
      if vm.showAreasList {
        AreasListView()
      }
    }
    .background(.thickMaterial)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
  }
  
  private var mapLayer: some View {
    Map(position: $position) {
      ForEach(vm.areas) { area in
        Annotation(area.name, coordinate: area.coordinates) {
          AreaAnnotationView()
            .scaleEffect(vm.mapArea == area ? 1 : 0.7)
            .shadow(radius: 10)
            .onTapGesture {
              vm.showNextArea(area)
            }
        }
      }
    }
    .ignoresSafeArea()
  }
  
  private var areasPreviewStack: some View {
    ZStack {
      ForEach(vm.areas) { area in
        if vm.mapArea == area {
          AreaPreviewView(area: area)
            .shadow(color: .black.opacity(0.3), radius: 20)
            .padding()
            .transition(.asymmetric(insertion: .move(edge: .trailing) , removal: .move(edge: .leading)))
        }
      }
    }
  }
}
