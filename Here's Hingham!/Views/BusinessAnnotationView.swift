//
//  AreaAnnotationView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI

struct BusinessAnnotationView: View {
  let areaName: String
  let businessName: String
  let shortName: String
  // let accentColor = Color("AccentColor")
  
  var body: some View {
    var size: Double
    
    if shortName == "Bank" {
      size = 156.0
    } else if shortName == "Church" {
      size = 121.0
    } else if shortName == "Old Derby" {
      size = 110.0
    } else if businessName == "La Petite Maison" || businessName == "Square Cafe" || shortName == "Lawyer" {
      size = 86.0
    } else {
      size = 64.0
    }
    
    return VStack(spacing: 0) {
      Image("\(areaName)/\(businessName)/icon")
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
    BusinessAnnotationView(areaName: "Square", businessName: "The Snug", shortName: "Pub")
  }
}
