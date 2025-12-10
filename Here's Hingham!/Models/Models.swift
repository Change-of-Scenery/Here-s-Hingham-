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
    [Place.self, Area.self]
  }
  
  static var versionIdentifier = Schema.Version(1, 0, 0)
  
  @Model
  final class Place: Codable, ObservableObject {
    enum CodingKeys: CodingKey {
      case documentID
      case address
      case archStyle
      case areaId
      case areaName
      case desc
      case estimatedValue
      case googleId
      case googleRating
      case googleReviews
      case googleUrl
      case hinghamRatings
      case hinghamReviews
      case hours
      case iconSize
      case imageCount
      case likes
      case locationLat
      case locationLng
      case lotSize
      case menuUrl
      case name
      case nickname
      case notes
      case phone
      case shortName
      case squareFeet
      case type
      case website
      case yearBuilt
      case yelpCategory
      case yelpId
      case yelpRating
      case yelpReviews
      case yelpPrice
      case yelpUrl
      case instagram
    }
    
    var documentID = ""
    var address = ""
    var archStyle = ""
    var areaId = 0
    var areaName = ""
    var desc = ""
    var googleId = ""
    var googleRating = 0.0
    var googleReviews = 0
    var googleUrl = ""
    var hinghamRatings = ""
    var hinghamReviews = 0.0
    var hours = ""
    var iconSize = 0.0
    var imageCount = 0
    var likes = 0
    var locationLat = 0.0
    var locationLng = 0.0
    var menuUrl = ""
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
    var yelpPrice = ""
    var yelpUrl = ""
    var estimatedValue = ""
    var lotSize = 0.0
    var squareFeet = 0
    var yearBuilt = 0
    var instagram = ""

    @Transient var placeMarkerAnnotationView: PlaceMarkerAnnotationView?
    @Transient var sizeHeight: Double?
    @Transient var sizeWidth: Double?
    @Transient var hasSpecial = false
    @Transient var selected = false
    
    var coordinates: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: locationLat, longitude: locationLng)
    }

    init() {
      self.timestamp = Date.now
    }
    
    init(timestamp: Date) {
      self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.documentID = try container.decode(String.self, forKey: .documentID)
      self.address = try container.decode(String.self, forKey: .address)
      self.areaId = try container.decode(Int.self, forKey: .areaId)
      self.areaName = try container.decode(String.self, forKey: .areaName)
      self.desc = try container.decode(String.self, forKey: .desc)
      self.googleId = try container.decode(String.self, forKey: .googleId)
      self.googleRating = try container.decode(Double.self, forKey: .googleRating)
      self.googleReviews = try container.decode(Int.self, forKey: .googleReviews)
      self.hinghamRatings = try container.decode(String.self, forKey: .hinghamRatings)
      self.hinghamReviews = try container.decode(Double.self, forKey: .hinghamReviews)
      self.hours = try container.decode(String.self, forKey: .hours)
      self.iconSize = try container.decode(CGFloat.self, forKey: .iconSize)
      self.imageCount = try container.decode(Int.self, forKey: .imageCount)
      self.likes = try container.decode(Int.self, forKey: .likes)
      self.locationLat = try container.decode(Double.self, forKey: .locationLat)
      self.locationLng = try container.decode(Double.self, forKey: .locationLng)
      self.menuUrl = try container.decode(String.self, forKey: .menuUrl)
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
      self.yelpPrice = try container.decode(String.self, forKey: .yelpPrice)
      self.yelpUrl = try container.decode(String.self, forKey: .yelpUrl)
      self.archStyle = try container.decode(String.self, forKey: .archStyle)
      self.estimatedValue = try container.decode(String.self, forKey: .estimatedValue)
      self.lotSize = try container.decode(Double.self, forKey: .lotSize)
      self.squareFeet = try container.decode(Int.self, forKey: .squareFeet)
      self.yearBuilt = try container.decode(Int.self, forKey: .yearBuilt)
      self.instagram = try container.decode(String.self, forKey: .instagram)
      self.timestamp = Date.now
    }
    
    func updateHinghamRating() {
      if hinghamRatings != "" {
        let ratings = hinghamRatings.components(separatedBy: ";")
        var ratingTotal = 0.0
        
        for rating in ratings {
          ratingTotal += Double(rating)!
        }
        
        let averageRating = ratingTotal / Double(ratings.count)
        
        if averageRating >= 1.0 && averageRating < 1.5 {
          hinghamReviews = 1.0
        } else if averageRating >= 1.5 && averageRating < 2.0 {
          hinghamReviews = 1.5
        } else if averageRating >= 2.0 && averageRating < 2.5 {
          hinghamReviews = 2.0
        } else if averageRating >= 2.5 && averageRating < 3.0 {
          hinghamReviews = 2.5
        } else if averageRating >= 3.0 && averageRating < 3.5 {
          hinghamReviews = 3.0
        } else if averageRating >= 3.5 && averageRating < 4.0 {
          hinghamReviews = 3.5
        } else if averageRating >= 4.0 && averageRating < 4.5 {
          hinghamReviews = 4.0
        } else if averageRating >= 4.5 && averageRating < 5.0 {
          hinghamReviews = 4.5
        } else {
          hinghamReviews = 5.0
        }
      }
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
    }
  }

  @Model
  final class Area: Identifiable, Codable, Equatable {
    enum CodingKeys: CodingKey {
      case documentID
      case areaId
      case centerCoordinateLat
      case centerCoordinateLng
      case iconCoordinateLat
      case iconCoordinateLng
      case name
      case shortName
      case tilt
      case timestamp
      case wikiName
      case imageCount
      case desc
      case attributedDesc
    }
    var documentID = ""
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
    var wikiName = ""
    var imageCount = 0
    var fontStyle = "<style>html { font-family: Helvetica, Arial, sans-serif; font-size: 16px; color: gray; } a:link { color: red; text-decoration: none; }</style>"
    var iconImage = "map.circle.fill"
    
    var centerCoordinates: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: centerCoordinateLat, longitude: centerCoordinateLng)
    }
    var coordinates: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: iconCoordinateLat, longitude: iconCoordinateLng)
    }
    
    @Transient var mapHeight = 0.0
    @Transient var mapY = 0.0
    @Transient var mapX = 0.0

    @Relationship() var businesses: [SchemaV1.Place] = []
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.documentID = try container.decode(String.self, forKey: .documentID)
      self.areaId = try container.decode(Int.self, forKey: .areaId)
      self.desc = try container.decode(String.self, forKey: .desc)
      self.centerCoordinateLat = try container.decode(Double.self, forKey: .centerCoordinateLat)
      self.centerCoordinateLng = try container.decode(Double.self, forKey: .centerCoordinateLng)
      self.iconCoordinateLat = try container.decode(Double.self, forKey: .iconCoordinateLat)
      self.iconCoordinateLng = try container.decode(Double.self, forKey: .iconCoordinateLng)
      self.name = try container.decode(String.self, forKey: .name)
      self.shortName = try container.decode(String.self, forKey: .shortName)
      self.tilt = try container.decode(Int.self, forKey: .tilt)
      self.timestamp = Date.now
      self.imageCount = try container.decode(Int.self, forKey: .imageCount)
    }
    
    init(areaId: Int, centerCoordinateLat: Double, centerCoordinateLng: Double, desc: String, iconCoordinateLat: Double, iconCoordinateLng: Double, name: String, shortName: String, tilt: Int) {
      self.areaId = areaId
      self.desc = desc
      self.centerCoordinateLat = centerCoordinateLat
      self.centerCoordinateLng = centerCoordinateLng
      self.iconCoordinateLat = iconCoordinateLat
      self.iconCoordinateLng = iconCoordinateLng
      self.name = name
      self.shortName = shortName
      self.tilt = tilt
      self.timestamp = Date.now
    }
    
    init() {
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
