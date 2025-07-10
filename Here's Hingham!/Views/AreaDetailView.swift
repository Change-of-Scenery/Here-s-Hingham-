//
//  AreaDetailView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI
import MapKit
import UIKit

struct AreaDetailView: View {
  
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @State var imageCount:Int = 10
  @State var modelMode = "area"
  @State var showEnlarged = ""
  @State var showRatingSelector = false
  @State var mapPosition = CGPoint(x: 10, y: 10)
  @State var placeBrewedAwakenings = SchemaV1.Place()
  @State var placeNonas = SchemaV1.Place()
  @State var placeHalabyLawGroup = SchemaV1.Place()
  @State var placeHinghamHistoricalSociety = SchemaV1.Place()
  @State var placeMaggies = SchemaV1.Place()
  @State var selectedRating = 0.0
  @State private var showMessage = false
  @State private var tabSelection = 0
 
  let area: SchemaV1.Area
  
  var body: some View {
    if showEnlarged == "map" {
      VStack {
        menuSection
        mapLayer
          .padding(.leading, -19)
      }
      .padding([.leading, .trailing], 15)
      .padding(.top, 16)
      .background(Color(red: 0.99, green: 0.99,  blue: 0.9))
    } else if showEnlarged == "desc" {
      VStack {
        menuSection
        expandedTitleSection
        Divider()
        expandedDescSection
      }
      .padding([.leading, .trailing], 15)
      .padding(.top, 16)
      .background(Color(red: 0.99, green: 0.99,  blue: 0.9))
    } else {
      VStack(alignment: .leading, spacing: 18) {
        menuSection
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
        if showMessage {
          messageLayer
        }
      }
      .padding([.leading, .trailing], 15)
      .padding(.top, 16)
      .background(Color(red: 0.99, green: 0.99,  blue: 0.9))
    }
  }
}

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
}

extension AreaDetailView {
  private var menuSection: some View {
    HStack {
      Button {
        if showEnlarged == "map" {
          let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
          print("span lat for menuSection \(span.latitudeDelta)")
          areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
          showEnlarged = ""
        } else if showEnlarged == "desc" {
          showEnlarged = ""
        } else if modelMode == "place" {
          tabSelection = 0
          withAnimation(.easeInOut) {
            modelMode = "area"
          }
        } else {
          areasViewModel.sheetArea = nil
        }
      } label: {
        Image(systemName: "x.square.fill")
          .font(.system(size: 20))
          .tint(.black)
      }
      Spacer()
      Button {
        withAnimation(.easeInOut) {
          self.showEnlarged = "desc"
        }
      } label: {
        Image(systemName: "text.page")
          .font(.system(size: 20))
          .tint(.black)
      }
      Spacer()
      Button {
        areasViewModel.zoomOut()
        self.showEnlarged = "map"
      } label: {
        Image(systemName: "map")
          .font(.system(size: 20))
          .tint(.black)
      }
      Spacer()
      Menu {
        Button("Expand Map", action: {
          withAnimation(.easeInOut) {
            self.showEnlarged = "map"
            areasViewModel.zoomOut()
          }
        })
        
        Button("Expand Notes", action: {
          withAnimation(.easeInOut) {
            self.showEnlarged = "desc"
          }
        })
      } label: {
        Image(systemName: "ellipsis.circle")
          .font(.system(size: 20))
          .tint(.black)
      }
    }
    .padding(.bottom, -8)
  }
    
  private var imageSection: some View {
    TabView(selection:$tabSelection) {
      let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
      let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
      
      ForEach(0..<imageCount, id: \.self) { index in
        if UIImage(named: "\(path)/\(index)") != nil {
          Image("\(path)/\(index)")
            .resizable()
            .scaledToFill()
        }
      }
      
      if modelMode == "place" {
        ForEach(10..<15, id: \.self) { index in
          if UIImage(named: "\(path)/\(index)") != nil {
            ZStack(alignment: .bottomLeading) {
              Image("\(path)/\(index)")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .clipped()
              
              Text("Photo by Hammer. Go to findagrave.com")
                .font(.system(size: 8))
                .foregroundColor(.white)
                .padding(5) // Add some padding around the text
                .background(Color.black.opacity(0.4)) // Optional: Add a semi-transparent background for better readability
                .cornerRadius(5) // Optional: Round the corners of the background
                .padding([.bottom, .leading], 30) // Further padding from the image edge
            }
          }
        }
      }
    }
    .frame(width: 400, height: 250)
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
          Text(placesViewModel.mapPlace.yelpPrice)
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
    return VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Text(placesViewModel.mapPlace.name)
          .font(.system(size: 24))
          .fontWeight(.bold)
          .padding([.top, .leading], 2)
      }
    }
    .padding(.top, 15)
  }

  private var descSection: some View {
       
    return VStack(alignment: .leading) {
      Text(modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
        .font(.system(size: 13))
        .foregroundColor(.primary)
        .frame(height: modelMode == "area" ? 95 : 50)
      
      Divider()
        .padding(.bottom, 14)
    }
    .frame(width: nil, height: 120, alignment: .topLeading)   // modelMode == "area" ? 100 : 90
    .padding(.top, -15)
    .padding(.bottom, -5)
  }
  
  private var expandedDescSection: some View {
// Markdown: "*Italics*", "**Bold**", "~Strikethrough~", "`Code`", "[Link](https://apple.com)"
       
    HStack(alignment: .top) {
      let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
      Text(descText)
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
        Text("\(placesViewModel.mapPlace.lotSize == 0 ? "unknown" : String(placesViewModel.mapPlace.lotSize) + " sq ft")")
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
          .padding(.trailing, 10)
        Text("$\(placesViewModel.mapPlace.estimatedValue)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        Spacer()
      }
    }
    .frame(height: 30)
  }
  
  private var reviewsSection: some View {
    
    let halfStar = Image("Reviews/Half Star")
      .resizable()
      .scaledToFill()
      .frame(width: 5, height: 10)
    let star = Image("Reviews/Star")
      .resizable()
      .scaledToFill()
      .frame(width: 5, height: 10)
    
    let height = UIScreen.main.bounds.size.height
    var paddingLeading = 0.0
    
    if height == 956.0 {
      paddingLeading = -11.0
    } else if height == 874.0 {
      paddingLeading = 24.0
    } else {
      paddingLeading = 34.0
    }

    return VStack {
      if showRatingSelector == false {
        HStack {
          if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
            Link(destination: url) {
              Image("Reviews/Google")
                .resizable()
                .scaledToFill()
                .frame(width: 56)
                .padding(.top, -4)
                .padding(.leading, paddingLeading)
            }
          } else {
            Image("Reviews/Google")
              .resizable()
              .scaledToFill()
              .frame(width: 56)
              .padding(.top, -4)
              .padding(.leading, paddingLeading)
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
              .font(.system(size: 12))
          } else {
            Text("No reviews")
              .font(.system(size: 12))
          }
          
          if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
            Link(destination: url) {
              Image("Reviews/Yelp")
                .resizable()
                .scaledToFill()
                .frame(width: 56)
                .padding(.bottom, 5)
            }
          } else {
            Image("Reviews/Yelp")
              .resizable()
              .scaledToFill()
              .frame(width: 56)
              .padding(.bottom, 5)
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
          
          Button {
            let defaults = UserDefaults.standard
            if let _ = defaults.string(forKey: "Rated:\(placesViewModel.mapPlace.documentID)") {
              showMessage = true
            } else {
              showRatingSelector = true
            }
          } label: {
            Image("Reviews/Bucket\(placesViewModel.mapPlace.hinghamRating)Star").resizable().scaledToFit().frame(width: 58, height: 40)
              .padding(.top, -6)
              .padding(.trailing, -10)
          }
          
          Text("(\(placesViewModel.mapPlace.hinghamReviews))")
            .font(.system(size: 12))
          
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 20)
        .padding(.leading, -40)
        
      } else {
        HStack {
          RatingsView(place: $placesViewModel.mapPlace, showRatingSelector: $showRatingSelector)
        }
      }
    }
  }
  
  private var messageLayer: some View {
    Text("You've already rated this place.")
      .padding()
      .background(.blue)
      .foregroundColor(.white)
      .cornerRadius(10)
      .transition(.opacity)
      .font(.system(size: 16).weight(.bold))
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            showMessage = false
        }
      }
  }
  
  private var mapLayer: some View {
    var places = placesViewModel.places.filter { $0.areaId == area.areaId}
    if places.count == 0 {
      loadPreviewPlaces()
      places.append(placeBrewedAwakenings)
      places.append(placeNonas)
      places.append(placeHalabyLawGroup)
      places.append(placeMaggies)
    }
    let height = UIScreen.main.bounds.size.height
    var mapHeight = 0.0
    var mapY = 0.0
    var mapX = height == 956.0 ? 203.0 : height == 932 ? 197.0 : height == 874.0 ? 187: 180
   
    if showEnlarged != "map" {
//      if modelMode == "area" {
        if height == 956.0 { // iPhone 16 Pro Max
          mapHeight = modelMode == "area" ? 490.0 : 520.0
          mapY = 215.0
        } else if height == 932.0 { // iPhone 15 Plus & Pro Max
          mapHeight = modelMode == "area" ? 550 : 580.0
          mapY = modelMode == "area" ? 170.0 : 110.0
        } else if height == 874.0 {
          mapHeight = modelMode == "place" ? 300.0 : 500.0
          mapY = 176
        } else if height == 852 {
          mapHeight = 497.0
          mapY = 158
        } else {
          mapHeight = 490.0
          mapY = 170.0
        }
//      } else {
//        if height == 956.0 {
//          mapHeight = 540.0
//          mapY = 190.0
//        } else if height == 932.0 { // iPhone 15 Plus
//          mapHeight = 530.0
//          mapY = 180.0
//        } else if height == 874.0 {
//          mapHeight = 540.0
//          mapY = 150
//        } else if height == 852.0 {
//          mapHeight = 540.0
//          mapY = 136
//        } else {
//          mapHeight = 540.0
//          mapY = 138.0
//        }
//      }
    } else {
      mapY = 400.0
      mapX = 220.0
      mapHeight = 160
    }
    
    return Map(position: $areasViewModel.mapCameraPosition, interactionModes: [.pan, .zoom]) {
      ForEach(places) { place in
        Annotation("", coordinate: place.coordinates) {
          withAnimation(.easeInOut) {
            PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, iconSize: place.iconSize, selected: place.selected)
              .shadow(radius: 10)
              .onTapGesture {
                withAnimation(.easeInOut) {
                  placesViewModel.showPlace(area, place)
                  modelMode = "place"
                  if showEnlarged == "map" {
                    areasViewModel.zoomIn()
                  }
                  showEnlarged = ""
                }
              }
          }
        }
        .annotationTitles(.visible)
      }
    }
    .onMapCameraChange(frequency: .continuous) { context in
      areasViewModel.centerCoordinate = context.region.center
    }
    .background(.white)
    .cornerRadius(45)
    .frame(height: UIScreen.main.bounds.size.height - mapHeight)
    .ignoresSafeArea()
    .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
    .position(x:mapX, y:mapY)
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
  
  private func loadPreviewPlaces() {
    placeBrewedAwakenings.address = "19 Main St"
    placeBrewedAwakenings.areaId = 0
    placeBrewedAwakenings.desc = "Café"
    placeBrewedAwakenings.googleId = "ChIJn_MZU0lh44kRfIeIV-uPKXA"
    placeBrewedAwakenings.googleRating = 4.3
    placeBrewedAwakenings.googleReviews = 236
    placeBrewedAwakenings.googleUrl = "https://maps.app.goo.gl/xyGuPUdxMorPv3Eq9"
    placeBrewedAwakenings.hours = "05:30AM-8PM;15:30AM-8PM;25:30AM-8PM;35:30AM-8PM;45:30AM-8PM;55:30AM-8PM;65:30AM-8PM"
    placeBrewedAwakenings.imageCount = 1
    placeBrewedAwakenings.likes = 0
    placeBrewedAwakenings.locationLat = 42.24192
    placeBrewedAwakenings.locationLng = -70.88921
    placeBrewedAwakenings.name = "Brewed Awakenings"
    placeBrewedAwakenings.nickname = ""
    placeBrewedAwakenings.notes = "Welcome to the fresh and flavorful world of Brewed Awakenings located in the heart of charming Hingham Center!\n\nFor over 15 years we have taken pride in being a place where friends, family, neighbors & coworkers meet to enjoy our cozy atmosphere, delicious coffee, tea, baked goods, soups, salads, sandwiches and wraps."
    placeBrewedAwakenings.phone = "(781) 741-5331"
    placeBrewedAwakenings.shortName = "Café"
    placeBrewedAwakenings.type = 1
    placeBrewedAwakenings.website = "http://www.hinghambrewed.com/"
    placeBrewedAwakenings.yelpCategory = "Coffee & Tea"
    placeBrewedAwakenings.yelpId = "brewed-awakenings-hingham"
    placeBrewedAwakenings.yelpPrice = "$$"
    placeBrewedAwakenings.yelpRating = 2.9
    placeBrewedAwakenings.yelpReviews = 94
    placeBrewedAwakenings.yelpUrl = "https://www.yelp.com/biz/brewed-awakenings-hingham"

    placeNonas.address = "19 Main St"
    placeNonas.areaId = 0
    placeNonas.desc = "Ice Cream"
    placeNonas.googleId = "ChIJn_MZU0lh44kRMalvJ7oxslc"
    placeNonas.googleRating = 4.8
    placeNonas.googleReviews = 278
    placeNonas.googleUrl = "https://maps.app.goo.gl/L8HACNp6qaDLv6AA7"
    placeNonas.hours = "0,11AM-10PM;1,11AM-10PM;2,11AM-10PM;3,11AM-10PM;4,11AM-10PM;5,11AM-10PM;6,11AM-10PM"
    placeNonas.imageCount = 1
    placeNonas.likes = 0
    placeNonas.locationLat = 42.24184
    placeNonas.locationLng = -70.88909
    placeNonas.name = "Nona's"
    placeNonas.nickname = ""
    placeNonas.notes = "Superb ice cream and home made apple pies!   Hours   Sunday:11:00AM - 9:00PM Monday:11:00AM - 9:00PM Tuesday:11:00AM - 9:00PM Wednesday:11:00AM - 9:00PM Thursday:11:00AM - 9:00PM Friday::11:00AM - 10:00PM Saturday:11:00AM - 10:00PM "
    placeNonas.phone = "(781) 749-3999"
    placeNonas.shortName = "Ice Cream"
    placeNonas.type = 1
    placeNonas.website = "https://www.nonasicecream.com/"
    placeNonas.yelpCategory = "Ice Cream & Frozen Yogurt"
    placeNonas.yelpId = "nonas-homemade-ice-cream-hingham"
    placeNonas.yelpPrice = "$"
    placeNonas.yelpRating = 4.3
    placeNonas.yelpReviews = 101
    placeNonas.yelpUrl = "https://www.yelp.com/biz/nonas-homemade-ice-cream-hingham?adjust_creative=oMiPYzoO1rgsBWiS9cnBrQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=oMiPYzoO1rgsBWiS9cnBrQ"
        
    placeHalabyLawGroup.address = "14 Main St"
    placeHalabyLawGroup.areaId = 0
    placeHalabyLawGroup.desc = "Lawyer"
    placeHalabyLawGroup.googleId = "ChIJERatVElh44kRG3uNnS-xn-k"
    placeHalabyLawGroup.googleRating = 4.7
    placeHalabyLawGroup.googleReviews = 19
    placeHalabyLawGroup.googleUrl = "https://maps.app.goo.gl/Un4LvghnwwoRQENt8"
    placeHalabyLawGroup.hours = "0,Closed;1,9:30AM-5PM;2,9:30AM-5PM;3,9:30AM-5PM;4,9:30AM-5PM;5,9:30AM-5PM;6,Closed"
    placeHalabyLawGroup.imageCount = 1
    placeHalabyLawGroup.likes = 0
    placeHalabyLawGroup.locationLat = 42.24209
    placeHalabyLawGroup.locationLng = -70.88876
    placeHalabyLawGroup.name = "Halaby Law Group"
    placeHalabyLawGroup.nickname = ""
    placeHalabyLawGroup.notes = "Dedicated attorneys committed to providing personalized legal services.  The attorneys and legal professionals at Halaby Law Group, P.C. are committed to delivering personalized legal services and building lasting relationships with the firm's diverse clientele, which include corporations, insurance carriers, small to mid-sized local businesses, and individuals.  Co-owners Jon and Julie Halaby opened the firm together in 2010 as a husband and wife team, after having practiced separately at other private law firms since 1995.  Since its opening, Halaby Law Group has developed a strong reputation for achieving impressive results for its clients, particularly in challenging cases where attention to detail and ongoing persistence is necessary in order to prevail.  Many of the firm's clients are referred by other attorneys in the community or former clients of the firm who know they can rely on Halaby Law Group to act as trusted advisors, skillful negotiators, and zealous advocates in and out of the courtroom. Also in this building is Rice McVaney Communications. https://www.ricemcvaney.com"
    placeHalabyLawGroup.phone = "(781) 749-0909"
    placeHalabyLawGroup.shortName = "Lawyer"
    placeHalabyLawGroup.type = 14
    placeHalabyLawGroup.website = "https://halabylegal.com/"
    placeHalabyLawGroup.yelpCategory = "General Litigation, Employment Law"
    placeHalabyLawGroup.yelpId = "halaby-law-group-hingham"
    placeHalabyLawGroup.yelpPrice = ""
    placeHalabyLawGroup.yelpRating = 5.0
    placeHalabyLawGroup.yelpReviews = 1
    placeHalabyLawGroup.yelpUrl = "https://www.yelp.com/biz/halaby-law-group-hingham?adjust_creative=oMiPYzoO1rgsBWiS9cnBrQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=oMiPYzoO1rgsBWiS9cnBrQ"
    
    placeMaggies.address = "17 Main St"
    placeMaggies.areaId = 0
    placeMaggies.desc = "Pets"
    placeMaggies.googleId = "ChIJQ4M-U0lh44kRvV6XzcHEcSc"
    placeMaggies.googleRating = 4.7
    placeMaggies.googleReviews = 26
    placeMaggies.googleUrl = "https://maps.app.goo.gl/wheJ2byg1JSZK3o97"
    placeMaggies.hours = "0,11AM-5PM;1,10AM-5PM;2,10AM-5PM;3,10AM-5PM;4,10AM-5PM;5,10AM-5PM;6,10AM-5PM"
    placeMaggies.imageCount = 1
    placeMaggies.likes = 0
    placeMaggies.locationLat = 42.2418
    placeMaggies.locationLng = -70.88901
    placeMaggies.name = "Maggie's"
    placeMaggies.nickname = ""
    placeMaggies.notes = "Maggie's Dog House was founded in 2005 by Kim Sylvester. She was watching the Today Show while getting ready for her stressful corporate job when a segment on gourmet dog treats caught her attention. Kim started to bake her own decadent treats and sell them during the holiday season in malls. This later lead to wholesaling to local pet specialty stores. While searching for more exposure in the South Shore, Kim realized that there was a gap in the Hingham area and decided to open her own shop. Maggie’s Dog House would soon feature not only their award winning treats, but also various high-end dog accessories and food."
    placeMaggies.phone = "(781) 740-7297"
    placeMaggies.shortName = "Pets"
    placeMaggies.type = 2
    placeMaggies.website = "https://www.maggiesdoghouse.com/"
    placeMaggies.yelpCategory = "Pet Stores"
    placeMaggies.yelpId = "maggies-doghouse-hingham"
    placeMaggies.yelpPrice = ""
    placeMaggies.yelpRating = 4.6
    placeMaggies.yelpReviews = 13
    placeMaggies.yelpUrl = "https://www.yelp.com/biz/maggies-doghouse-hingham?adjust_creative=oMiPYzoO1rgsBWiS9cnBrQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=oMiPYzoO1rgsBWiS9cnBrQ"
  }
}

#Preview {
  AreaDetailView(area: AreasViewModel().previewArea)
    .environmentObject(AreasViewModel())
    .environmentObject(PlacesViewModel())
}
