//
//  ContentView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var businesses: [SchemaV1.Business]

    var body: some View {
        NavigationStack {
            List {
                ForEach(businesses) { business in
                    NavigationLink {
                      Text("\(business.name) at \(business.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                      Text(business.address)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
           // let newItem = HinghamArea(timestamp: Date())
           // modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
      withAnimation {
        let idxs = IndexSet([0]) // , 1, 2, 3, 4, 5, 6, 7, 8, 9
        do {
          for index in idxs {
            modelContext.delete(businesses[index])
          }
          try modelContext.save()
        } catch {
          print(error)
        }
      }
    }
}

#Preview {
    ContentView()
    .modelContainer(for: [SchemaV1.Area.self, SchemaV1.Business.self, SchemaV1.CivicBuilding.self, SchemaV1.HistoricHouse.self], inMemory: true)
}
