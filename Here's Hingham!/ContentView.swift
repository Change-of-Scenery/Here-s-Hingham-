//
//  ContentView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
//  @Query private var businesses: [SchemaV1.Business]
  @Query private var areas: [SchemaV1.Area]
//  @State private var position = MapCameraPosition.region(
//    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//  @State private var selectedArea: SchemaV1.Area?
//  @State private var annotations: [SchemaV1.Area]
//  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

  var body: some View {
    Text("Areas?")
  }
}


//    private func addItem() {
//        withAnimation {
//           // let newItem = HinghamArea(timestamp: Date())
//           // modelContext.insert(newItem)
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//      withAnimation {
//        let idxs = IndexSet([0]) // , 1, 2, 3, 4, 5, 6, 7, 8, 9
//        do {
//          for index in idxs {
//            modelContext.delete(businesses[index])
//          }
//          try modelContext.save()
//        } catch {
//          print(error)
//        }
//      }
//    }
// }
//
//#Preview {
//  ContentView(annotations: [SchemaV1.Area])
//    .modelContainer(for: [SchemaV1.Area.self, SchemaV1.Business.self, SchemaV1.CivicAsset.self, SchemaV1.HistoricHouse.self], inMemory: true)
//}
