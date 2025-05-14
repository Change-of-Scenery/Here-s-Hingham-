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
  @StateObject private var areasViewModel = AreasViewModel()
  @StateObject private var businessesViewModel = BusinessesViewModel()
  @Environment(\.modelContext) private var modelContext
  @Query var businessesSwiftData: [SchemaV1.Business]
  @Query var areasSwiftData: [SchemaV1.Area]
    
//  var sharedModelContainer: ModelContainer = {
//    let schema = Schema([
//      SchemaV1.Area.self,
//      SchemaV1.Business.self,
//      SchemaV1.CivicAsset.self,
//      SchemaV1.HistoricHouse.self
//    ])
//    
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//    do {
//      return try ModelContainer(for: schema, configurations: [modelConfiguration])
//    } catch {
//      fatalError("Could not create ModelContainer: \(error)")
//    }
//  }()

  var body: some Scene {
    WindowGroup {
//    ContentView()
      AreasView()
        .environmentObject(areasViewModel)
        .environmentObject(businessesViewModel)
    }
    .modelContainer(for: [SchemaV1.Business.self, SchemaV1.Area.self]) { result in
      do {
        let container = try result.get()
        // Check to see if we already have businesses.
        
        let nameDescriptor = FetchDescriptor<SchemaV1.Business>(predicate: #Predicate { $0.name == "holly & olive" })
        let results = try container.mainContext.fetch(nameDescriptor)
        
        for bus in results {
//          bus.website = "https://www.cycletownstudio.com"
//          bus.locationLng = -70.88959
//          bus.locationLat = 42.24142
          print(bus.locationLng)
          print(bus.locationLat)
        }
        
        try container.mainContext.save()
               
        let businessDescriptor = FetchDescriptor<SchemaV1.Business>()
        let areaDescriptor = FetchDescriptor<SchemaV1.Area>()
        let existingBusinesses = try container.mainContext.fetchCount(businessDescriptor)
        
        guard existingBusinesses > 0 else
        {
//          let loadedBusinesses = try container.mainContext.fetch(businessDescriptor)
//          
//          for loadedBusiness in loadedBusinesses {
//            businessesViewModel.businesses.append(loadedBusiness)
//          }
//          
//          var jsonString = "[\n"
//
//          for business in businessesViewModel.businesses {
//            let escDesc = business.desc.replacingOccurrences(of: "\"", with: "\\\"")
//            let escNotes = business.notes.replacingOccurrences(of: "\"", with: "\\\"").replacingOccurrences(of: "\n", with: " ")
//            jsonString += "  {\n"
//            jsonString += "    \"address\":\"\(business.address)\",\n"
//            jsonString += "    \"areaId\":0,\n"
//            jsonString += "    \"desc\":\"\(escDesc)\",\n"
//            jsonString += "    \"googleId\":\"\(business.googleId)\",\n"
//            jsonString += "    \"googleRating\":\(business.googleRating),\n"
//            jsonString += "    \"googleReviews\":\(business.googleReviews),\n"
//            jsonString += "    \"googleUrl\":\"\(business.googleUrl)\",\n"
//            jsonString += "    \"hours\":\"\(business.hours)\",\n"
//            jsonString += "    \"imageCount\":\(business.imageCount),\n"
//            jsonString += "    \"locationLat\":\(business.locationLat),\n"
//            jsonString += "    \"locationLng\":\(business.locationLng),\n"
//            jsonString += "    \"name\":\"\(business.name)\",\n"
//            jsonString += "    \"nickname\":\"\(business.nickname)\",\n"
//            jsonString += "    \"notes\":\"\(escNotes)\",\n"
//            jsonString += "    \"phone\":\"\(business.phone)\",\n"
//            jsonString += "    \"shortName\":\"\(business.shortName)\",\n"
//            jsonString += "    \"type\":\(business.type),\n"
//            jsonString += "    \"website\":\"\(business.website)\",\n"
//            jsonString += "    \"yelpCategory\":\"\(business.yelpCategory)\",\n"
//            jsonString += "    \"yelpId\":\"\(business.yelpId)\",\n"
//            jsonString += "    \"yelpPrice\":\"\(business.yelpPrice)\",\n"
//            jsonString += "    \"yelpRating\":\(business.yelpRating),\n"
//            jsonString += "    \"yelpReviews\":\(business.yelpReviews),\n"
//            jsonString += "    \"yelpUrl\":\"\(business.yelpUrl)\",\n"
//            jsonString += "  },\n"
//          }
          
//          jsonString += "]"
//
//          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//          let fileURL = documentsDirectory.appendingPathComponent("Businesses.json")
//          try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
          
          let existingAreas = try container.mainContext.fetchCount(areaDescriptor)
          
          guard existingAreas == 0 else
          {
//            for area in areasViewModel.areas {
//              container.mainContext.insert(area)
//            }
//            
//            try container.mainContext.save()
            
//            let businessDescriptor = FetchDescriptor<SchemaV1.Business>()
//            businessesViewModel.businesses = try container.mainContext.fetch(businessDescriptor)
//            let areaDescriptor = FetchDescriptor<SchemaV1.Area>()
//            areasViewModel.areas = try container.mainContext.fetch(areaDescriptor)
//            var jsonString = "[\n"
//            
//            for area in areasViewModel.areas  {
//              let escDesc = area.desc.replacingOccurrences(of: "\"", with: "\\\"")
//              jsonString += "  {\n"
//              jsonString += "    \"areaId\":\(area.areaId),\n"
//              jsonString += "    \"centerCoordinateLat\":\(area.centerCoordinateLat),\n"
//              jsonString += "    \"centerCoordinateLng\":\(area.centerCoordinateLng),\n"
//              jsonString += "    \"iconCoordinateLat\":\(area.iconCoordinateLat),\n"
//              jsonString += "    \"iconCoordinateLng\":\(area.iconCoordinateLng),\n"
//              jsonString += "    \"name\":\"\(area.name)\",\n"
//              jsonString += "    \"shortName\":\"\(area.shortName)\",\n"
//              jsonString += "    \"desc\":\"\(escDesc)\",\n"
//              jsonString += "    \"tilt\":\(area.tilt),\n"
//              jsonString += "    \"zoom\":\(area.zoom),\n"
//              jsonString += "  },\n"
//            }
//            
//            jsonString += "]"
//            
//            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let fileURL = documentsDirectory.appendingPathComponent("Areas.json")
//            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
//            
////
////            var data = try JSONEncoder().encode(areasViewModel.areas)
////            data = try JSONEncoder().encode(businessesViewModel.businesses)
////            fileURL = documentsDirectory.appendingPathComponent("Businesses.json")
////            try data.write(to: fileURL)
//            
            return
          }

          guard let url = Bundle.main.url(forResource: "Areas", withExtension: "json") else {
            fatalError("Failed to find Areas.json")
          }
          
          let data = try Data(contentsOf: url)
          let areas = try JSONDecoder().decode([SchemaV1.Area].self, from: data)
          
          for area in areas {
            container.mainContext.insert(area)
          }
          
          try container.mainContext.save()
          areasViewModel.areas = try container.mainContext.fetch(areaDescriptor)

          guard let url = Bundle.main.url(forResource: "Businesses", withExtension: "json") else {
            fatalError("Failed to find Businesses.json")
          }
          
          let dataBiz = try Data(contentsOf: url)
          let businesses = try JSONDecoder().decode([SchemaV1.Business].self, from: dataBiz)
          
          for business in businesses {
            container.mainContext.insert(business)
          }
          
          try container.mainContext.save()
          businessesViewModel.businesses = try container.mainContext.fetch(businessDescriptor)

          return
        }
        
        businessesViewModel.businesses = try container.mainContext.fetch(businessDescriptor)
        areasViewModel.areas = try container.mainContext.fetch(areaDescriptor)
        
      } catch {
        print("Failed to pre-seed database. \(error)")
      }
      
    }
  }
}

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}
