//
//  Models.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/24/25.
//

import Foundation
import SwiftData
import MapKit

enum SchemaV1: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [Business.self, Area.self, HistoricHouse.self, CivicBuilding.self]
  }
  
  static var versionIdentifier = Schema.Version(1, 0, 0)
  
  @Model
  final class Business: Codable {
    enum CodingKeys: CodingKey {
      case address
      case areaId
      case backgroundColor
      case desc
      case googlePlaceId
      case googleRating
      case googleReviews
      case hours
      case imageCount
      case likes
      case locationLat
      case locationLng
      case name
      case nickname
      case notes
      case phone
      case shortName
      case type
      case website
      case yelpCategory
      case yelpId
      case yelpRating
      case yelpReviews
      case yelpUrl
    }
    
    var address = ""
    var areaId = 0
    var backgroundColor = ""
    var desc = ""
    var googlePlaceId = ""
    var googleRating = 0.0
    var googleReviews = 0
    var hours = ""
    var imageCount = 0
    var likes = 0
    var locationLat = 0.0
    var locationLng = 0.0
    @Attribute(.unique) var name = ""
    var nickname = ""
    var notes = ""
    var phone = ""
    var shortName = ""
    var type = 0
    var timestamp: Date
    var website = ""
    var yelpCategory = ""
    var yelpId = ""
    var yelpRating = 0.0
    var yelpReviews = 0
    var yelpUrl = ""
    
    @Transient var placeMarkerAnnotationView: PlaceMarkerAnnotationView?
    @Transient var sizeHeight: Double?
    @Transient var sizeWidth: Double?
    @Transient var hasSpecial = false
    
    init(timestamp: Date) {
      self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.address = try container.decode(String.self, forKey: .address)
      self.areaId = try container.decode(Int.self, forKey: .areaId)
      self.backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
      self.desc = try container.decode(String.self, forKey: .desc)
      self.googlePlaceId = try container.decode(String.self, forKey: .googlePlaceId)
      self.googleRating = try container.decode(Double.self, forKey: .googleRating)
      self.googleReviews = try container.decode(Int.self, forKey: .googleReviews)
      self.hours = try container.decode(String.self, forKey: .hours)
      self.imageCount = try container.decode(Int.self, forKey: .imageCount)
      self.likes = try container.decode(Int.self, forKey: .likes)
      self.locationLat = try container.decode(Double.self, forKey: .locationLat)
      self.locationLng = try container.decode(Double.self, forKey: .locationLng)
      self.name = try container.decode(String.self, forKey: .name)
      self.nickname = try container.decode(String.self, forKey: .nickname)
      self.notes = try container.decode(String.self, forKey: .notes)
      self.phone = try container.decode(String.self, forKey: .phone)
      self.shortName = try container.decode(String.self, forKey: .shortName)
      self.type = try container.decode(Int.self, forKey: .type)
      self.website = try container.decode(String.self, forKey: .website)
      self.yelpCategory = try container.decode(String.self, forKey: .yelpCategory)
      self.yelpId = try container.decode(String.self, forKey: .yelpId)
      self.yelpRating = try container.decode(Double.self, forKey: .yelpRating)
      self.yelpReviews = try container.decode(Int.self, forKey: .yelpReviews)
      self.yelpUrl = try container.decode(String.self, forKey: .yelpUrl)
      self.timestamp = Date.now
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
    }
  }
  
  @Model
  final class Area: Identifiable, Codable, Equatable {
    enum CodingKeys: CodingKey {
      case id
      case areaId
      case centerCoordinateLat
      case centerCoordinateLng
      case iconCoordinateLat
      case iconCoordinateLng
      case name
      case shortName
      case tilt
      case timestamp
      case zoom
      case wikiName
    }
    var id: String { name + "Hingham" }
    var areaId = 0
    var centerCoordinateLat = 0.0
    var centerCoordinateLng = 0.0
    var iconCoordinateLat = 0.0
    var iconCoordinateLng = 0.0
    @Attribute(.unique) var name = ""
    var shortName = ""
    var desc = ""
    var tilt = 0
    var timestamp: Date
    var zoom = 0.0
    var wikiName = ""
    
    var centerCoordinates: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: centerCoordinateLat, longitude: centerCoordinateLng)
    }
    var iconCoordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: iconCoordinateLat, longitude: iconCoordinateLng)
    }
    var coordinates: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: iconCoordinateLat, longitude: iconCoordinateLng)
    }

    @Relationship() var businesses: [SchemaV1.Business] = []
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.areaId = try container.decode(Int.self, forKey: .areaId)
      self.centerCoordinateLat = try container.decode(Double.self, forKey: .centerCoordinateLat)
      self.centerCoordinateLng = try container.decode(Double.self, forKey: .centerCoordinateLng)
      self.iconCoordinateLat = try container.decode(Double.self, forKey: .iconCoordinateLat)
      self.iconCoordinateLng = try container.decode(Double.self, forKey: .iconCoordinateLng)
      self.name = try container.decode(String.self, forKey: .name)
      self.shortName = try container.decode(String.self, forKey: .shortName)
      self.tilt = try container.decode(Int.self, forKey: .tilt)
      self.timestamp = Date.now
      self.zoom = try container.decode(Double.self, forKey: .zoom)
    }
    
    init() {
      self.name = "Hingham Square"
      self.timestamp = Date.now
    }
    
    init(name: String, shortName: String, desc: String, iconCoordinateLat: Double, iconCoordinateLng: Double, centerCoordinateLat: Double, centerCoordinateLng: Double, wikiName: String) {
      self.name = name
      self.shortName = shortName
      self.desc = desc
      self.iconCoordinateLat = iconCoordinateLat
      self.iconCoordinateLng = iconCoordinateLng
      self.centerCoordinateLat = centerCoordinateLat
      self.centerCoordinateLng = centerCoordinateLng
      self.wikiName = wikiName
      self.timestamp = Date.now
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
    }
    
    static func == (lhs: Area, rhs: Area) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  @Model
  final class HistoricHouse: Codable {
    enum CodingKeys: CodingKey {
      case name
    }
    var timestamp: Date
    var areaId = 0
    @Attribute(.unique) var name = ""
    var shortName = ""
    var address = ""
    var locationLat = 0.0
    var locationLng = 0.0
    var desc = ""
    var notes = ""
    var website = ""
    var imageCount = 0
    var sizeHeight = 0.0
    var sizeWidth = 0.0
    var estimatedValue = ""
    var lotSize = 0.0
    var squareFeet = 0
    var yearBuilt = ""
    var archStyle = ""
    var nickname = ""
    
    @Transient var placeMarkerAnnotationView: PlaceMarkerAnnotationView?
    
    init(name: String) {
      self.name = name
      self.timestamp = Date.now
    }
    
    init(timestamp: Date) {
      self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)
      self.timestamp = Date.now
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
    }
  }
  
  @Model
  final class CivicBuilding: Codable {
    enum CodingKeys: CodingKey {
      case name
    }
    var timestamp: Date
    var areaID = 0
    var name = ""
    var shortName = ""
    var address = ""
    var locationLat = 0.0
    var locationLng = 0.0
    var desc = ""
    var notes = ""
    var website = ""
    var imageCount = 0
    
    @Transient var placeMarkerAnnotationView: PlaceMarkerAnnotationView?
    
    init(name: String) {
      self.name = name
      self.timestamp = Date.now
    }
    
    init(timestamp: Date) {
      self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)
      self.timestamp = Date.now
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
    }
  }
}



//enum ModelMigrationPlan: SchemaMigrationPlan {
//  static var schemas: [any VersionedSchema.Type] {
//      [SchemaV1.self, ModelSchemaV200.self]
//  }
//  
//  static var stages: [MigrationStage] {
//      [migrateV1toV2]
//  }
//
//  //there is also .lightweight(..) migration, read the link above
//  static let migrateV1toV2 = MigrationStage.custom(
//      fromVersion: SchemaV1.self,
//      toVersion: ModelSchemaV200.self,
//      willMigrate: { context in
//          let businesses = try context.fetch(FetchDescriptor<SchemaV1.Business>())
//                    
//          // Do your update here, like giving a default age
//          for business in businesses {
//            context.insert(business)
//          }
//                  
//          try? context.save()
//      }, didMigrate: nil
//  )
//}
