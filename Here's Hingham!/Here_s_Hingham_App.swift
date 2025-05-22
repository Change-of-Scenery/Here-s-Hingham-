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
  @StateObject private var placesViewModel = PlacesViewModel()
  @Environment(\.modelContext) private var modelContext
    
//  var sharedModelContainer: ModelContainer = {
//    let schema = Schema([
//      SchemaV1.Area.self,
//      SchemaV1.Place.self,
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
        .environmentObject(placesViewModel)
    }
    .modelContainer(for: [SchemaV1.Place.self, SchemaV1.Area.self]) { result in
      do {
        let container = try result.get()
        // Check to see if we already have places.
        
//        let nameDescriptor = FetchDescriptor<SchemaV1.Place>(predicate: #Predicate { $0.name == "Ruth Joy" })
//        let results = try container.mainContext.fetch(nameDescriptor)
////        
//        for bus in results {
////          bus.website = "https://www.cycletownstudio.com"
////          bus.locationLng = -70.88788
////          bus.locationLat = 42.24164
////          bus.archStyle = "Colonial"
//          print(bus.locationLng)
//          print(bus.locationLat)
//        }
        
//        try container.mainContext.save()
               
        let placeDescriptor = FetchDescriptor<SchemaV1.Place>()
        let areaDescriptor = FetchDescriptor<SchemaV1.Area>()
        areasViewModel.areas = try container.mainContext.fetch(areaDescriptor)
        placesViewModel.places = try container.mainContext.fetch(placeDescriptor)
        
        let existingplaces = try container.mainContext.fetchCount(placeDescriptor)
        
        guard existingplaces > 0 else
        {
//          let loadedplaces = try container.mainContext.fetch(placeDescriptor)
//
//          for loadedPlace in loadedplaces {
//            placesViewModel.places.append(loadedPlace)
//          }
//          
//          var jsonString = "[\n"
//
//          for place in placesViewModel.places {
//            let escDesc = place.desc.replacingOccurrences(of: "\"", with: "\\\"")
//            let escNotes = place.notes.replacingOccurrences(of: "\"", with: "\\\"").replacingOccurrences(of: "\n", with: " ")
//            jsonString += "  {\n"
//            jsonString += "    \"address\":\"\(place.address)\",\n"
//            jsonString += "    \"areaId\":0,\n"
//            jsonString += "    \"desc\":\"\(escDesc)\",\n"
//            jsonString += "    \"googleId\":\"\(place.googleId)\",\n"
//            jsonString += "    \"googleRating\":\(place.googleRating),\n"
//            jsonString += "    \"googleReviews\":\(place.googleReviews),\n"
//            jsonString += "    \"googleUrl\":\"\(place.googleUrl)\",\n"
//            jsonString += "    \"hours\":\"\(place.hours)\",\n"
//            jsonString += "    \"imageCount\":\(place.imageCount),\n"
//            jsonString += "    \"locationLat\":\(place.locationLat),\n"
//            jsonString += "    \"locationLng\":\(place.locationLng),\n"
//            jsonString += "    \"name\":\"\(place.name)\",\n"
//            jsonString += "    \"nickname\":\"\(place.nickname)\",\n"
//            jsonString += "    \"notes\":\"\(escNotes)\",\n"
//            jsonString += "    \"phone\":\"\(place.phone)\",\n"
//            jsonString += "    \"shortName\":\"\(place.shortName)\",\n"
//            jsonString += "    \"type\":\(place.type),\n"
//            jsonString += "    \"website\":\"\(place.website)\",\n"
//            jsonString += "    \"yelpCategory\":\"\(place.yelpCategory)\",\n"
//            jsonString += "    \"yelpId\":\"\(place.yelpId)\",\n"
//            jsonString += "    \"yelpPrice\":\"\(place.yelpPrice)\",\n"
//            jsonString += "    \"yelpRating\":\(place.yelpRating),\n"
//            jsonString += "    \"yelpReviews\":\(place.yelpReviews),\n"
//            jsonString += "    \"yelpUrl\":\"\(place.yelpUrl)\",\n"
//            jsonString += "  },\n"
//          }
          
//          jsonString += "]"
//
//          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//          let fileURL = documentsDirectory.appendingPathComponent("places.json")
//          try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
          
          let existingAreas = try container.mainContext.fetchCount(areaDescriptor)
          
          guard existingAreas == 0 else
          {
//            for area in areasViewModel.areas {
//              container.mainContext.insert(area)
//            }
//            
//            try container.mainContext.save()
            
//            let placeDescriptor = FetchDescriptor<SchemaV1.Place>()
//            placesViewModel.places = try container.mainContext.fetch(placeDescriptor)
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
////            data = try JSONEncoder().encode(placesViewModel.places)
////            fileURL = documentsDirectory.appendingPathComponent("places.json")
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

          guard let url = Bundle.main.url(forResource: "Places", withExtension: "json") else {
            fatalError("Failed to find places.json")
          }
          
          let dataPlaces = try Data(contentsOf: url)
          let places = try JSONDecoder().decode([SchemaV1.Place].self, from: dataPlaces)
          
          for place in places {
            container.mainContext.insert(place)
          }
          
          try container.mainContext.save()
          placesViewModel.places = try container.mainContext.fetch(placeDescriptor)

          return
        }
        
        placesViewModel.places = try container.mainContext.fetch(placeDescriptor)
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
