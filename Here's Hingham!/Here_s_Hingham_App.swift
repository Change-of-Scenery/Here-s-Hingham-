//
//  Here_s_Hingham_App.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import SwiftUI
import SwiftData

@main
struct Here_s_Hingham_App: App {
  @Environment(\.modelContext) private var modelContext
  @Query private var areas: [SchemaV1.Area]
  @StateObject private var vm = AreasViewModel()
    
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      SchemaV1.Area.self,
      SchemaV1.Business.self,
      SchemaV1.CivicBuilding.self,
      SchemaV1.HistoricHouse.self
    ])
    
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
//    ContentView()
      AreasView()
        .modelContext(modelContext)
        .environmentObject(vm)
    }
    .modelContainer(for: [SchemaV1.Business.self, SchemaV1.Area.self]) { result in
      do {
        let container = try result.get()
        // Check to see if we already have businesses.
        let businessDescriptor = FetchDescriptor<SchemaV1.Business>()
        let existingBusinesses = try container.mainContext.fetchCount(businessDescriptor)
        guard existingBusinesses == 0 else
        {
          let areaDescriptor = FetchDescriptor<SchemaV1.Area>()
          let existingAreas = try container.mainContext.fetchCount(areaDescriptor)
          guard existingAreas == 0 else
          {
            // vm.areas = try container.mainContext.fetch(areaDescriptor)
            let businessDescriptor = FetchDescriptor<SchemaV1.Business>()
            vm.businesses = try container.mainContext.fetch(businessDescriptor)
            return
          }

          guard let url = Bundle.main.url(forResource: "Areas", withExtension: "json") else {
            fatalError("Failed to find Areas.json")
          }
          
//          let data = try Data(contentsOf: url)
//          let areas = try JSONDecoder().decode([SchemaV1.Area].self, from: data)
          
          for area in vm.areas {
            container.mainContext.insert(area)
          }

          return
        }
        
        guard let url = Bundle.main.url(forResource: "Businesses", withExtension: "json") else {
          fatalError("Failed to find Businesses.json")
        }
        
        let data = try Data(contentsOf: url)
        let businesses = try JSONDecoder().decode([SchemaV1.Business].self, from: data)
        
        for business in businesses {
          container.mainContext.insert(business)
        }
        
      } catch {
        print("Failed to pre-seed database.")
      }
    }
  }
}
