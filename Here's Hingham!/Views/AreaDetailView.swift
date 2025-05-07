//
//  AreaDetailView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI
import MapKit

struct AreaDetailView: View {
  
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var businessesViewModel: BusinessesViewModel
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @State private var closeInPosition = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.23227,longitude: -70.89828), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
  @State private var modelMode = "area"
  @State private var selectedBusiness = SchemaV1.Business()

  let area: SchemaV1.Area

  var body: some View {
    ScrollView {
      VStack {
        imageSection
          .shadow(color: .black.opacity(0.3), radius: 20, x:0, y:10)
        
        VStack(alignment: .leading, spacing: 16) {
          titleSection
          Divider()
          if modelMode == "business" {
            reviewSection
            Divider()
          }
          descSection
          Divider()
          mapLayer
        }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
      }
    }
    .ignoresSafeArea()
    .background(.ultraThinMaterial)
    .overlay(backButton, alignment: .topLeading)
  }

}

extension AreaDetailView {
    
  private var imageSection: some View {
    TabView {
      ForEach(0..<22) { index in
        Image("\(area.shortName)/Area\(index)")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width)
          .clipped()
      }
    }
    .frame(height: 400)
    .tabViewStyle(PageTabViewStyle())
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(area.name)
        .font(.largeTitle)
        .fontWeight(.semibold)
    }
  }

  private var descSection: some View {
      VStack(alignment: .leading, spacing: 16) {
          Text(area.desc)
              .font(.subheadline)
              .foregroundColor(.secondary)

        if area.wikiName.prefix(4) == "http" {
          if let url = URL(string: area.wikiName) {
            Link("Read more", destination: url)
              .font(.headline)
              .tint(.blue)
          }
        }
        else if let url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)"), modelMode == "area" {
          Link("Read more on Wikipedia", destination: url)
              .font(.headline)
              .tint(.blue)
        }
      }
  }
  
  private var reviewSection: some View {
    HStack {
      googleStars
    }
  }
  
  private var googleStars: some View {

    HStack {
      VStack {
        Image("Reviews/Google")
          .resizable()
          .scaledToFill()
          .frame(width: 88)
          .padding(.leading, 8)
          .padding(.trailing, 15)
          .padding(.bottom, -10)
        
        let halfStar = Image("Reviews/Half Star")
          .resizable()
          .scaledToFill()
          .frame(width: 6, height: 12)
          .padding([.top], 3)
        let star = Image("Reviews/Star")
          .resizable()
          .scaledToFill()
          .frame(width: 6, height: 12)
          .padding([.top], 3)
        
        let gRating = selectedBusiness.googleRating
        let gReviews = selectedBusiness.googleReviews
        
        HStack {
          if gRating > 0 {
            if gRating < 1 { halfStar } else if gRating >= 1 { star }
            if gRating > 1 && gRating < 2 { halfStar } else if gRating >= 2 { star }
            if gRating > 2 && gRating < 3 { halfStar } else if gRating >= 3 { star }
            if gRating > 3 && gRating < 4 { halfStar } else if gRating >= 4 { star }
            if gRating > 4 && gRating < 5 { halfStar } else if gRating >= 5 { star }
          }
          
          if gReviews > 0 {
            Text("(\(gReviews))")
              .padding([.top], 3)
          }
        }
      }
      .padding(.trailing, 10)
      
      VStack {
        Image("Reviews/Yelp")
          .resizable()
          .scaledToFill()
          .frame(width: 72)
          .padding(.bottom, -10)
        
        let halfStar = Image("Reviews/Half Star")
          .resizable()
          .scaledToFill()
          .frame(width: 6, height: 12)
          .padding([.top], 3)
        let star = Image("Reviews/Star")
          .resizable()
          .scaledToFill()
          .frame(width: 6, height: 12)
          .padding([.top], 3)
        
        let yRating = selectedBusiness.yelpRating
        let yReviews = selectedBusiness.yelpReviews
        
        HStack {
          if yRating > 0 {
            if yRating < 1 { halfStar } else if yRating >= 1 { star }
            if yRating > 1 && yRating < 2 { halfStar } else if yRating >= 2 { star }
            if yRating > 2 && yRating < 3 { halfStar } else if yRating >= 3 { star }
            if yRating > 3 && yRating < 4 { halfStar } else if yRating >= 4 { star }
            if yRating > 4 && yRating < 5 { halfStar } else if yRating >= 5 { star }
          }
          
          if yReviews > 0 {
            Text("(\(yReviews))")
              .padding([.top], 3)
          }
        }
      }
      .frame(width: nil, height: nil, alignment: .leading)
    }
    .frame(width: nil, height: 40)
  }
  
  private var mapLayer: some View {
    let position = MapCameraPosition.region(
      MKCoordinateRegion(center: area.centerCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
    
    let businesses = businessesViewModel.businesses.filter { $0.areaId == area.name}
       
    return Map(initialPosition: position) {
      ForEach(businesses) { business in
        Annotation("", coordinate: business.coordinates) {
          BusinessAnnotationView(areaName: area.shortName, businessName: business.name, shortName: business.shortName)
                  .shadow(radius: 10)
                  .onTapGesture {
                    selectedBusiness = business
                    modelMode = "business"
                  }
          }
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .cornerRadius(30)
    .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
  }
  
  private var backButton: some View {
    Button {
      areasViewModel.sheetArea = nil
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
        .padding(16)
        .foregroundColor(.primary)
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
        .padding()
    }
  }
  
}
  
#Preview {
  AreaDetailView(area: AreasViewModel().areas.first!)
    .environmentObject(AreasViewModel())
    .environmentObject(BusinessesViewModel())
}
