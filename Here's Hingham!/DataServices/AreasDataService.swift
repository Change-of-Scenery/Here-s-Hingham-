//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit
import SwiftUI
import SwiftData

class AreasDataService {
  @Environment(\.modelContext) private var modelContext
  @Query public var areasQuery: [SchemaV1.Area]
  @Published var areas: [SchemaV1.Area] = []
  
  init() {
    areas = areasQuery
  }
}
