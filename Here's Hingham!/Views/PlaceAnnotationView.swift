//
//  AreaAnnotationView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI

struct PlaceAnnotationView: View {
  let areaName: String
  let placeName: String
  let shortName: String
  let type: Int
  // let accentColor = Color("AccentColor")
  
  var body: some View {
    var size: Double
    
    if shortName == "Bank" {
      size = 156.0
    } else if shortName == "Church" {
      size = 121.0
    } else if shortName == "Old Derby" || shortName == "Paint" {
      size = 110.0
    } else if placeName == "La Petite Maison" || placeName == "Square Cafe" || shortName == "Lawyer" {
      size = 86.0
    } else if type == 6 {
      size = 82.0
    } else {
      size = 64.0
    }
    
    return VStack(spacing: 0) {
      Image("\(areaName)/\(placeName)/icon")
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
      
//      Text(businessName)
//        .font(.caption2)
//        .foregroundColor(.black)
    }
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    PlaceAnnotationView(areaName: "Square", placeName: "The Snug", shortName: "Pub", type: 2)
  }
}
