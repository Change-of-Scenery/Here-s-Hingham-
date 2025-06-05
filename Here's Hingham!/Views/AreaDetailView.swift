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
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
  @State private var closeInPosition = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
  @State var imageCount:Int = 10
  @State var modelMode = "area"
  @State var showEnlarged = ""
  @State var mapPosition = CGPoint(x: 10, y: 10)
  @State var expandMapTop = 0.0

  let area: SchemaV1.Area

  var body: some View {
    if showEnlarged == "map" {
      ZStack {
        mapLayer
          .overlay(contractButton.padding(.top, 15), alignment: .top)
          .overlay(expandedTitleSection, alignment: .top)
      }
    } else if showEnlarged == "desc" {
      VStack {
        expandedTitleSection
          .overlay(contractButton, alignment: .top)
        Divider()
        expandedDescSection
      }
    } else {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          imageSection
          titleSection
          if modelMode == "place" {
            if placesViewModel.mapPlace.type == 6 {
              historicHouseSection
            } else {
              reviewsSection
            }
            Divider()
              .padding(.top, -5)
          }
          descSection
          mapLayer
        }
      }
      .padding([.leading, .trailing], 15)
      .padding(.top, 15)
      .background(Color(red: 0.99, green: 0.99,  blue: 0.9))
      .overlay(closeButton, alignment: .top)
      .overlay(expandMapButton, alignment: .top)
      .overlay(expandDescButton, alignment: .top)
    }
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
      let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
      let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount
      
      ForEach(0..<imageCount, id: \.self) { index in
        Image("\(path)/\(index)")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width, height: 300)
          .clipped()
      }
    }
    .frame(height: 250)
    .tabViewStyle(PageTabViewStyle())
    .cornerRadius(15)
  }
  
  private var titleSection: some View {
    
    var name = area.name
    var url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)")!
    var dividerTopPadding = 0.0
    
    if modelMode == "place" {
      name = placesViewModel.mapPlace.type == 6 ? placesViewModel.mapPlace.name + " House" : placesViewModel.mapPlace.name
      url = URL(string: placesViewModel.mapPlace.website)!
    } else {
      dividerTopPadding = 10.0
    }
    
    return VStack(alignment: .leading) {
      HStack {
        Link(name, destination: url)
          .font(.title2)
          .fontWeight(.bold)
          .frame(width: nil, height: 20)
          .padding(.top, -5)
        Spacer()
        if modelMode == "place" {
          Text(placesViewModel.mapPlace.desc)
            .font(.system(size: 12))
        }
      }
      HStack {
        if modelMode == "place" {
          Text(placesViewModel.mapPlace.address)
            .font(.system(size: 12))
          Spacer()
          Text(getHoursOpen(hours: placesViewModel.mapPlace.hours))
            .font(.system(size: 12))
            .frame(width: 100, alignment: .trailing)
          Spacer()
          Link(destination: URL(string: "tel:" + placesViewModel.mapPlace.phone)!) {
            Text(placesViewModel.mapPlace.phone)
              .font(.system(size: 12))
              .frame(width: 90, alignment: .trailing)
          }
        }
      }
      Divider()
        .padding(.top, dividerTopPadding)
    }
  }
  
  private var expandedTitleSection: some View {
    
    var name = area.name
    var url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)")!

    if modelMode == "place" {
      name = placesViewModel.mapPlace.type == 6 ? placesViewModel.mapPlace.name + " House" : placesViewModel.mapPlace.name
      url = URL(string: placesViewModel.mapPlace.website)!
    }

    return VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Link(name, destination: url)
          .font(name.count > 30 ? .title3 : .title)
          .fontWeight(.semibold)
          .frame(width: nil, height: 20)
        if modelMode == "place" {
          Text(placesViewModel.mapPlace.desc)
            .font(.system(size: 14))
            .padding([.top, .leading], 2)
        }
      }
    }
    .padding(.top, 25)
  }

  private var descSection: some View {
       
    VStack(alignment: .leading) {
      Text(modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
        .font(.system(size: 13))
        .foregroundColor(.secondary)
      
      if area.wikiName.prefix(4) == "http" {
        if let url = URL(string: area.wikiName) {
          Link("Read more", destination: url)
            .font(.headline)
            .tint(.blue)
        }
      }
      Divider()
        .padding(.bottom, 14)
    }
    .frame(width: nil, height: modelMode == "area" ? 100 : 90)
    .padding(.top, -12)
    .padding(.bottom, -5)
  }
  
  private var expandedDescSection: some View {
       
    HStack(alignment: .top) {
      Text(modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
        .font(.system(size: 16))
        .foregroundColor(.primary)
      
      if area.wikiName.prefix(4) == "http" {
        if let url = URL(string: area.wikiName) {
          Link("Read more", destination: url)
            .font(.headline)
            .tint(.blue)
        }
      }
    }
    .frame(width: nil, height: UIScreen.main.bounds.size.height - 200)
    .padding()
    .padding(.top, -15)
    .padding(.bottom, -15)
  }
  
  private var historicHouseSection: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Year built")
          .font(.subheadline)
        Text("\(placesViewModel.mapPlace.yearBuilt)".replacingOccurrences(of: ",", with: ""))
          .font(.subheadline)
          .foregroundColor(.secondary)
        Spacer()
        Text("Style")
          .font(.subheadline)
        Text(placesViewModel.mapPlace.archStyle)
          .font(.subheadline)
          .foregroundColor(.secondary)
        Spacer()
        Text("Lot size")
          .font(.subheadline)
        Text("\(placesViewModel.mapPlace.lotSize == 0 ? "unknown" : String(placesViewModel.mapPlace.lotSize))")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      HStack {
        Text("Square feet")
          .font(.subheadline)
        Text("\(placesViewModel.mapPlace.squareFeet == 0 ? "unknown" : String(placesViewModel.mapPlace.squareFeet))")
          .font(.subheadline)
          .foregroundColor(.secondary)
        Spacer()
        Text("Estimated value")
          .font(.subheadline)
        Text("$\(placesViewModel.mapPlace.estimatedValue)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        Spacer()
      }
    }
  }
  
  private var reviewsSection: some View {
    
    let halfStar = Image("Reviews/Half Star")
      .resizable()
      .scaledToFill()
      .frame(width: 1.5, height: 8)
    let star = Image("Reviews/Star")
      .resizable()
      .scaledToFill()
      .frame(width: 1.5, height: 8)
    
    return HStack {
      if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
        Link(destination: url) {
          Image("Reviews/Google")
            .resizable()
            .scaledToFill()
            .frame(width: 48)
            .padding(.top, -4)
        }
      } else {
        Image("Reviews/Google")
          .resizable()
          .scaledToFill()
          .frame(width: 48)
          .padding(.top, -4)
      }
      
      let gRating = placesViewModel.mapPlace.googleRating
      let gReviews = placesViewModel.mapPlace.googleReviews
      
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
      
      if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
        Link(destination: url) {
          Image("Reviews/Yelp")
            .resizable()
            .scaledToFill()
            .frame(width: 42)
            .padding(.top, -4)
        }
      } else {
        Image("Reviews/Yelp")
          .resizable()
          .scaledToFill()
          .frame(width: 42)
          .padding(.top, -4)
      }
      
      let yRating = placesViewModel.mapPlace.yelpRating
      let yReviews = placesViewModel.mapPlace.yelpReviews
      
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
      
      Text(placesViewModel.mapPlace.yelpPrice)
        .font(.system(size: 14))
      
    }
    .frame(width: UIScreen.main.bounds.size.width - 32, height: 10)
    .padding(.leading, -40)
  }
  
  private var mapLayer: some View {
    let places = placesViewModel.places.filter { $0.areaId == area.areaId}
    let mapHeight = modelMode == "area" ? 530.0 : 720.0
    let mapX = 182.0
    let mapY = 162.0

    if let latitude = placesViewModel.mapCameraPosition.region?.center.latitude {
      if latitude == 0.0 {
        let span = area.areaId == 1 || area.areaId == 2 || area.areaId == 3 ? area.zoomSpan : area.zoomInSpan
        let position = MapCameraPosition.region(
          MKCoordinateRegion(center: area.centerCoordinates, span: span))
        
        return Map(initialPosition: position) {
          ForEach(places) { place in
            Annotation("", coordinate: place.coordinates) {
              withAnimation(.easeInOut) {
                PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, selected: place.selected)
                  .shadow(radius: 10)
                  .onTapGesture {
                    withAnimation(.easeInOut) {
                      placesViewModel.showNextPlace(area, place)
                      modelMode = "place"
                    }
                  }
              }
            }
            .annotationTitles(.visible)
          }
        }
        .background(.white)
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.size.width - 32, height: UIScreen.main.bounds.size.height - mapHeight)
        .ignoresSafeArea()
        .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking,          .police, .restroom, .university, .publicTransport])))
        .position(x:mapX, y:mapY)
      } else {
        return Map(position: $placesViewModel.mapCameraPosition) {
          ForEach(places) { place in
            Annotation("", coordinate: place.coordinates) {
              withAnimation(.easeInOut) {
                PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, selected: place.selected)
                  .shadow(radius: 10)
                  .onTapGesture {
                    withAnimation(.easeInOut) {
                      placesViewModel.showNextPlace(area, place)
                      modelMode = "place"
                    }
                  }
              }
            }
            .annotationTitles(.visible)
          }
        }
        .background(.white)
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.size.width - 32, height: UIScreen.main.bounds.size.height - mapHeight)
        .ignoresSafeArea()
        .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
        .position(x:mapX, y:mapY)
      }
    } else {
      return Map(position: $placesViewModel.mapCameraPosition) {
        ForEach(places) { place in
          Annotation("", coordinate: place.coordinates) {
            PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, selected: place.selected)
              .shadow(radius: 10)
              .onTapGesture {
                withAnimation(.easeInOut) {
                  expandMapTop = 40.0
                  placesViewModel.showNextPlace(area, place)
                  modelMode = "place"
                }
              }
          }
          .annotationTitles(.visible)
        }
      }
      .background(.white)
      .aspectRatio(1, contentMode: .fill)
      .cornerRadius(15)
      .frame(width: UIScreen.main.bounds.size.width - 32, height: UIScreen.main.bounds.size.height - mapHeight)
      .ignoresSafeArea()
      .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
      .position(x:mapX, y:mapY)
    }
  }
  
  private var closeButton: some View {
    Button {
      if modelMode == "place" {
        modelMode = "area"
        expandMapTop = 0
      } else {
        areasViewModel.sheetArea = nil
      }
    } label: {
      Image(systemName: "x.square.fill")
        .font(.system(size: 20))
        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.65))
    }
    .position(x: 35, y: 35)
  }
  
  private var expandMapButton: some View {
    let topPadding = modelMode == "place" ? 380.0 : 440.0

    return Button {
      withAnimation(.easeInOut) {
        self.showEnlarged = "map"
        placesViewModel.zoomOut(areasViewModel.mapArea)
      }
    } label: {
      Image(systemName: "arrow.down.left.and.arrow.up.right.square.fill")
        .font(.system(size: 20))
        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.65))
        .padding(.leading, 35)
        .padding(.top, expandMapTop)
    }
    .padding(.leading, UIScreen.main.bounds.size.width - 110)
    .padding(.top, UIScreen.main.bounds.size.height - topPadding)
  }
  
  private var expandDescButton: some View {
    let topPadding = modelMode == "place" ? 522.0 : 577.0

    return Button {
      withAnimation(.easeInOut) {
        self.showEnlarged = "desc"
//        placesViewModel.zoomOut(areasViewModel.mapArea)
      }
    } label: {
      Image(systemName: "arrow.down.left.and.arrow.up.right.square.fill")
        .font(.system(size: 20))
        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.65))
        .padding(.leading, 20)
    }
    .padding(.leading, UIScreen.main.bounds.size.width - 90)
    .padding(.top, UIScreen.main.bounds.size.height - topPadding)
  }
  
  private var contractButton: some View {
    Button {
      withAnimation(.easeInOut) {
        if self.showEnlarged == "map" {
          placesViewModel.zoomIn(areasViewModel.mapArea)
        }
        
        self.showEnlarged = ""
      }
    } label: {
      Image(systemName: "arrow.up.right.and.arrow.down.left.square.fill")
        .font(.system(size: 20))
        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
        .padding(0)
        .padding(.leading, 18)
        .padding(.bottom, -5)
    }
    .padding(.leading, UIScreen.main.bounds.size.width - 70)
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
  AreaDetailView(area: AreasViewModel().previewArea)
    .environmentObject(AreasViewModel())
    .environmentObject(PlacesViewModel())
}
