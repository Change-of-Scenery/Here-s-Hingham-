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
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @State private var closeInPosition = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
  @State private var modelMode = "area"
  @State var imageCount:Int = 10

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
            reviewsSection
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

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
}

extension AreaDetailView {
    
  private var imageSection: some View {
    TabView {
      let path = modelMode == "business" ? "\(area.shortName)/\(businessesViewModel.mapBusiness.name)" : "\(area.shortName)/Area"
      let imageCount = modelMode == "business" ? businessesViewModel.mapBusiness.imageCount : area.imageCount
      
      ForEach(0..<imageCount, id: \.self) { index in
        Image("\(path)/\(index)")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width, height: 300)
          .clipped()
      }
    }
    .frame(height: 300)
    .tabViewStyle(PageTabViewStyle())
  }
  
  private var titleSection: some View {
    
    var name = area.name
    var url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)")!
    
    if modelMode == "business" {
      name = businessesViewModel.mapBusiness.name
      url = URL(string: businessesViewModel.mapBusiness.website)!
    }
    
    return HStack {
      VStack(alignment: .leading) {
        Link(name, destination: url)
          .font(name.count > 15 ? .title3 : .title)
          .fontWeight(.semibold)
          .frame(width: nil, height: 20)
        if modelMode == "business" {
          Text(businessesViewModel.mapBusiness.desc)
            .font(.system(size: 14))
            .padding([.top, .leading], 2)
        }
      }
      Spacer()
      VStack(alignment: .trailing) {
        if modelMode == "business" {
          Spacer()
          Text(businessesViewModel.mapBusiness.address)
            .font(.system(size: 14))
        }
      }
    }
    .padding(.bottom, -10)
  }

  private var descSection: some View {
       
    VStack(alignment: .leading, spacing: 16) {
      Text(modelMode == "area" ? area.desc : businessesViewModel.mapBusiness.notes)
        .font(.subheadline)
        .foregroundColor(.secondary)

      if area.wikiName.prefix(4) == "http" {
        if let url = URL(string: area.wikiName) {
          Link("Read more", destination: url)
            .font(.headline)
            .tint(.blue)
        }
      }
//      else if let url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)"), modelMode == "area" {
//        Link("Read more on Wikipedia", destination: url)
//            .font(.headline)
//            .tint(.blue)
//      }
    }
    .frame(width: nil, height: 110)
    .padding([.top], -15)
  }
  
  private var reviewsSection: some View {

    HStack {
      VStack {
        if let url = URL(string: businessesViewModel.mapBusiness.yelpUrl) {
          Link(destination: url) {
            Image("Reviews/Google")
              .resizable()
              .scaledToFill()
              .frame(width: 56)
          }
        } else {
          Image("Reviews/Google")
            .resizable()
            .scaledToFill()
            .frame(width: 56)
        }

        let halfStar = Image("Reviews/Half Star")
          .resizable()
          .scaledToFill()
          .frame(width: 2, height: 8)
        let star = Image("Reviews/Star")
          .resizable()
          .scaledToFill()
          .frame(width: 2, height: 8)
        
        let gRating = businessesViewModel.mapBusiness.googleRating
        let gReviews = businessesViewModel.mapBusiness.googleReviews
        
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
              .font(.system(size: 10))
          } else {
            Text("No reviews")
              .font(.system(size: 10))
          }
        }
        .padding(.leading, 16)
      }
      .position(x: 30, y: 6)
      
      VStack(alignment: .trailing) {
        VStack(alignment: .leading) {
          HStack {
            if let url = URL(string: businessesViewModel.mapBusiness.yelpUrl) {
              Link(destination: url) {
                Image("Reviews/Yelp")
                  .resizable()
                  .scaledToFit()
                  .frame(height: 28)
              }
            } else {
              Image("Reviews/Yelp")
                .resizable()
                .scaledToFill()
                .frame(width: 20)
            }
            
            Text(businessesViewModel.mapBusiness.yelpPrice)
              .font(.system(size: 14))
          }
        }
        .padding(.bottom, -3)
        
        let halfStar = Image("Reviews/Half Star")
          .resizable()
          .scaledToFill()
          .frame(width: 2, height: 8)
        let star = Image("Reviews/Star")
          .resizable()
          .scaledToFill()
          .frame(width: 2, height: 8)
        
        let yRating = businessesViewModel.mapBusiness.yelpRating
        let yReviews = businessesViewModel.mapBusiness.yelpReviews
        
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
              .font(.system(size: 12))
          } else {
            Text("No reviews")
              .font(.system(size: 12))
          }
        }
        .padding(.trailing, 7)
        .padding(.bottom, 8)
      }
      .position(x: 30, y: 10)
      
      VStack(alignment: .trailing) {
        Link(destination: URL(string: "tel:" + businessesViewModel.mapBusiness.phone)!) {
          Text(businessesViewModel.mapBusiness.phone)
            .font(.system(size: 14))
            .frame(width: 160, alignment: .trailing)
        }
        
        Text(getHoursOpen(hours: businessesViewModel.mapBusiness.hours))
          .font(.system(size: 14))
          .frame(width: 160, alignment: .trailing)
        
      }
      .frame(width: 160)
      .padding(.bottom, 12)
      
    }
    .frame(width: nil, height: 20)
  }
  
  private var mapLayer: some View {
    let businesses = businessesViewModel.businesses.filter { $0.areaId == area.areaId}

    if let latitude = businessesViewModel.mapCameraPosition.region?.center.latitude {
      if latitude == 0.0 {
        let position = MapCameraPosition.region(
          MKCoordinateRegion(center: area.centerCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
        
        return Map(initialPosition: position) {
          ForEach(businesses) { business in
            Annotation("", coordinate: business.coordinates) {
              BusinessAnnotationView(areaName: area.shortName, businessName: business.name, shortName: business.shortName)
                .shadow(radius: 10)
                .onTapGesture {
                  withAnimation(.easeInOut) {
                    businessesViewModel.showNextBusiness(area, business)
                    modelMode = "business"
                  }
                }
            }
          }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
        .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
      } else {
        return Map(position: $businessesViewModel.mapCameraPosition) {
          ForEach(businesses) { business in
            Annotation("", coordinate: business.coordinates) {
              BusinessAnnotationView(areaName: area.shortName, businessName: business.name, shortName: business.shortName)
                .shadow(radius: 10)
                .onTapGesture {
                  withAnimation(.easeInOut) {
                    businessesViewModel.showNextBusiness(area, business)
                    modelMode = "business"
                  }
                }
            }
          }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
        .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
      }
    } else {
      return Map(position: $businessesViewModel.mapCameraPosition) {
        ForEach(businesses) { business in
          Annotation("", coordinate: business.coordinates) {
            BusinessAnnotationView(areaName: area.shortName, businessName: business.name, shortName: business.shortName)
              .shadow(radius: 10)
              .onTapGesture {
                withAnimation(.easeInOut) {
                  businessesViewModel.showNextBusiness(area, business)
                  modelMode = "business"
                }
              }
          }
        }
      }
      .aspectRatio(1, contentMode: .fit)
      .cornerRadius(30)
      .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
    }
  }
  
  private var backButton: some View {
    Button {
      if modelMode == "business" {
        modelMode = "area"
      } else {
        areasViewModel.sheetArea = nil
      }
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
        .padding(8)
        .foregroundColor(.primary)
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
        .padding()
    }
  }
  
  private func getHoursOpen(hours: String) -> String {
    let daysHours = hours.components(separatedBy: ";")
    
    for dayHours in daysHours {
      let hoursInfo = dayHours.components(separatedBy: ",")
      if hoursInfo[0] == String(Date().dayNumberOfWeek()) {
        return hoursInfo[1]
      }
    }
    
    return ""
  }
  
}

#Preview {
  AreaDetailView(area: AreasViewModel().areas.first!)
    .environmentObject(AreasViewModel())
    .environmentObject(BusinessesViewModel())
}
