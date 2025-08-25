//
//  AreaDetailView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI
import MapKit
import CoreLocation
import AVKit

struct AreaDetailView: View {
  
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.colorScheme) var colorScheme
  @State var imageCount:Int = 10
  @State var notes = ""
  @State var modelMode = "place"
  @State var showExpanded = ""
  @State var showRatingSelector = false
  @State var showHours = false
  @State var mapPosition = CGPoint(x: 10, y: 10)
  @State var placeBrewedAwakenings = SchemaV1.Place()
  @State var placeNonas = SchemaV1.Place()
  @State var placeHalabyLawGroup = SchemaV1.Place()
  @State var placeHinghamHistoricalSociety = SchemaV1.Place()
  @State var placeMaggies = SchemaV1.Place()
  @State var selectedRating = 0.0
  @State private var showMessage = false
  @State private var message = ""
  @State private var tabSelection = 0
  @State private var updatingLocation = false
  @State private var annotationOpacity: Double = 1.0
  @ObservedObject var location: LocationManager = LocationManager()
   
  let area: SchemaV1.Area
                        
  var body: some View {
    let screenHeight = UIScreen.main.bounds.size.height
    
    let rows = [
      GridItem(.fixed(screenHeight * 0.3)),   // image
      GridItem(.fixed(screenHeight * (modelMode == "area" ? 0.008 : 0.018))),  // title
      GridItem(.fixed(screenHeight * (modelMode == "area" ? 0.0 : 0.04))),    // reviews
//      GridItem(.fixed(modelMode == "area" ? 125 : 80)), // desc
      GridItem(.fixed(screenHeight * 0.44))    // map
    ]
    let expandedMapRows = [
      GridItem(.fixed(screenHeight * 0.82))   // map
    ]
    let expandedDescRows = [
      GridItem(.fixed(screenHeight * 0.829))   // desc
    ]
    
    let backgroundColor = colorScheme == .dark ? Color(red: 0.01, green: 0.01,  blue: 0.0) : Color(red: 0.99, green: 0.99,  blue: 0.9)

    if verticalSizeClass == .compact || horizontalSizeClass == .regular {
      expandedImageSection
    } else {
      if showExpanded == "map" {
        LazyHGrid(rows: expandedMapRows, spacing: 10) {
//          mapLayer
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .background(backgroundColor)
      } else if showExpanded == "desc" {
        LazyHGrid(rows: expandedDescRows, spacing: 10) {
          expandedDescSection
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .background(backgroundColor)
      } else  {
        LazyHGrid(rows: rows, spacing: 10) {
          imageSection
          titleSection
          
          if modelMode == "place" {
            if placesViewModel.mapPlace.type == 6 {
              historicHouseSection
            } else {
              reviewsSection
            }
          } else {
            areaSection
          }
          descSection
//          mapLayer
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .background(backgroundColor)
        .onChange(of: location.newPlaceAtCurrentLocation) {
          modelMode = "place"
          placesViewModel.showPlace(areasViewModel.mapArea, location.newPlaceAtCurrentLocation!)
          if showExpanded == "map" {
            areasViewModel.zoomIn(0.0007)
          }
          showExpanded = ""
        }
        .onChange(of: placesViewModel.mapPlace.name) {
          notes = placesViewModel.mapPlace.notes
        }
        .onChange(of: areasViewModel.mapArea.name) {
          notes = areasViewModel.mapArea.desc
        }
        .overlay {
          if showHours == true {
            if placesViewModel.mapPlace.hours != "" {
              hoursWindow
            }
          }
        }
      }
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

    return HStack {
//      Button {
//        if showExpanded == "map" {
//          let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
//          areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
//          showExpanded = ""
//        } else if showExpanded == "desc" {
//          showExpanded = ""
////        } else if modelMode == "place" {
////          tabSelection = 0
////          withAnimation(.easeInOut) {
////            modelMode = "area"
////          }
//        } else if showExpanded == "image" {
//          rotateBack()
//        } else {
//          let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
//          areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
//          areasViewModel.sheetArea = nil
//        }
//        showRatingSelector = false
//      } label: {
//        Image(systemName: "x.square.fill")
//          .font(.system(size: 20))
//          .tint(.primary)
//      }
//      Spacer()
//      Button {
//        if showExpanded == "image" {
//          rotateBack()
//        } else {
//          if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            showExpanded = "image"
//            AppDelegate.orientationForImage = true
//            scene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
//          }
//        }
//      } label: {
//        Image(systemName: "photo")
//          .font(.system(size: 20))
//          .tint(.primary)
//      }
//      Spacer()
//      Button {
//        if showExpanded == "desc" {
//          showExpanded = ""
//        } else {
//          if showExpanded == "image" {
//            rotateBack()
//          }
//          withAnimation(.easeInOut) {
//            self.showExpanded = "desc"
//          }
//        }
//      } label: {
//        Image(systemName: "text.page")
//          .font(.system(size: 20))
//          .tint(.primary)
//      }
////      Spacer()
////      Button {
////        if showExpanded == "map" {
////          showExpanded = ""
////        } else {
////          if showExpanded == "image" {
////            rotateBack()
////          }
////          areasViewModel.zoomOut()
////          self.showExpanded = "map"
////        }
////      } label: {
////        Image(systemName: "map")
////          .font(.system(size: 20))
////          .tint(.primary)
////      }
//      Spacer()
//      Menu {
////        Button("Update Google Data", action: {
////          let dataService = DataService()
////          dataService.updateGoogle()
////        })
////        
////        Button("Update Yelp Data", action: {
////          let dataService = DataService()
////          dataService.updateYelp()
////        })
//        
//        Toggle("Show Here", isOn: $updatingLocation)
//          .toggleStyle(CustomToggleButton())
//          .onChange(of: updatingLocation) {
//            location.areaId = area.areaId
//            if updatingLocation == true {
//              location.placesViewModel = placesViewModel
//              location.startUpdating()
//            } else {
//              location.stopUpdating()
//            }
//          }
//        } label: {
//          Image(systemName: "ellipsis.circle")
//            .font(.system(size: 20))
//            .tint(.primary)
//        }
    }
  }
  
  func rotateBack() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      scene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
      AppDelegate.orientationForImage = false
      showExpanded = ""
    }
  }
  
  private var hoursWindow: some View {
    let hours = placesViewModel.mapPlace.hours.components(separatedBy: ";")
    let cols = [GridItem(.fixed(100)), GridItem(.fixed(120))]
    
    return ZStack {
      VStack(alignment: .center) {
        Text("Hours")
          .fontWeight(.bold)
        
        ForEach(0..<7, id: \.self) { index in
          LazyVGrid(columns: cols, alignment: .leading) {
            let weekDay = WeekDays.allCases[index]
            Text("\(weekDay)")
              .font(.system(size: 13))
              .foregroundColor(.primary)
            Text(hours[index].components(separatedBy: ",")[1])
              .font(.system(size: 13))
              .foregroundColor(.primary)
          }
          .padding([.top, .bottom], -3)
        }
      }
      .padding()
    }
    .background(.white)
    .border(.red, width: 2)
    .frame(width: 280)
    .cornerRadius(25)
    .onTapGesture {
      showHours = false
    }
    .overlay(
        RoundedRectangle(cornerRadius: 25)   // Specify the desired corner radius
            .stroke(Color.red, lineWidth: 3) // Set the border color and width
    )
  }
  
  private var areaSection: some View {
    VStack {
    }
  }
    
  private var imageSection: some View {
       
    return TabView(selection:$tabSelection) {
      let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
      let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
      
      ForEach(0..<imageCount, id: \.self) { index in
        if UIImage(named: "\(path)/\(index)") != nil {
          Image("\(path)/\(index)")
            .resizable()
            .scaledToFit()
            .cornerRadius(25)
        }
      }
      
      if modelMode == "place" && imageCount < 10 {
        ForEach(10..<15, id: \.self) { index in
          if UIImage(named: "\(path)/\(index)") != nil {
            ZStack(alignment: .bottomLeading) {
              Image("\(path)/\(index)")
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(25)
            }
          }
        }
      }
    }
    .tabViewStyle(PageTabViewStyle())
    .padding(.top, -15)
    .padding(.bottom, 10)
  }
  
  private var titleSection: some View {
    var name = area.name
    var url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)")!
    
    if modelMode == "place" {
      name = placesViewModel.mapPlace.type == 6 ? placesViewModel.mapPlace.name + " House" : placesViewModel.mapPlace.name
      if placesViewModel.mapPlace.website != "" {
        url = URL(string: placesViewModel.mapPlace.website)!
      }
    }
    
    return VStack(alignment: .leading) {
      HStack {
        if url.absoluteString == "" {
          Text(name)
            .font(name.count > 20 ? .headline : .title2)
            .fontWeight(.bold)
        } else {
          Link(name, destination: url)
            .font(name.count > 20 ? .headline : .title2)
            .foregroundColor(.red)
            .fontWeight(.bold)
        }

        if modelMode == "place" {
          Spacer()
          Text(placesViewModel.mapPlace.desc == "" ? placesViewModel.mapPlace.yelpCategory : placesViewModel.mapPlace.desc)
            .font(.system(size: 12))
          Text(placesViewModel.mapPlace.yelpPrice)
            .font(.system(size: 12))
        }
      }
      .padding(.bottom, modelMode == "place" ? 0.25 : 0.0)
    
      if modelMode == "place" {
        HStack {
          Text(placesViewModel.mapPlace.address)
            .font(.system(size: 12))
          Spacer()
          if placesViewModel.mapPlace.menuUrl != "" {
            let menuUrl = URL(string: placesViewModel.mapPlace.menuUrl)!
            Link(destination: menuUrl) {
              Text("Menu")
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundColor(.red)
                .frame(width: 37)
            }
            Spacer()
          }
          Button {
            showHours = true
          } label: {
            Text(getHoursOpen(hours: placesViewModel.mapPlace.hours))
              .font(.system(size: 12))
              .foregroundColor(.red)
              .frame(width: 100, alignment: .trailing)
          }
          Spacer()
          Link(destination: URL(string: "tel:" + placesViewModel.mapPlace.phone)!) {
            Text(placesViewModel.mapPlace.phone)
              .font(.system(size: 12))
              .frame(width: 90, alignment: .trailing)
          }
        }
      }
    }
    .frame(width: UIScreen.main.bounds.width * 0.93)
  }
  
  private var descSection: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Divider()
          .padding(.top, 6)
        
        let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
        
        ScrollView {
          Text(descText)
            .font(.system(size: 13))
            .foregroundColor(.primary)
        }
      }
    }
    .frame(width: UIScreen.main.bounds.size.width * 0.93)
  }
  
  private var foundLocation: some View {
    ZStack {
      Text("Found the place!")
    }
  }
  
  private var expandedImageSection: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        TabView(selection:$tabSelection) {
          let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
          let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
          
          ForEach(0..<imageCount, id: \.self) { index in
            if UIImage(named: "\(path)/\(index)") != nil {
              Image("\(path)/\(index)")
                .resizable()
                .scaledToFit()
                .cornerRadius(25)
            }
          }
          
          if modelMode == "place" && imageCount < 10 {
            ForEach(10..<15, id: \.self) { index in
              if UIImage(named: "\(path)/\(index)") != nil {
                ZStack(alignment: .bottomLeading) {
                  Image("\(path)/\(index)")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(25)
                }
              }
            }
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.top, -15)
      }
    }
    .padding()
    .frame(width: UIScreen.main.bounds.size.width * 0.93)
  }
  
  private var expandedDescSection: some View {
// Markdown: "*Italics*", "**Bold**", "~Strikethrough~", "`Code`", "[Link](https://apple.com)"
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(modelMode == "area" ? areasViewModel.mapArea.name : placesViewModel.mapPlace.name)
          .font(.system(size: 24))
          .fontWeight(.bold)
        
        let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: modelMode == "area" ? area.desc : placesViewModel.mapPlace.notes)
        
        ScrollView {
          Text(descText)
            .font(.system(size: 16))
            .foregroundColor(.primary)
        }
      }
    }
    .padding()
    .frame(width: UIScreen.main.bounds.size.width * 0.93)
  }
  
  private var historicHouseSection: some View {
    VStack(alignment: .leading) {
      Divider()
        .padding(.top, 20)
      HStack {
        Text("Year built")
          .font(.system(size: 12))
          .fontWeight(.semibold)
        Text("\(placesViewModel.mapPlace.yearBuilt)".replacingOccurrences(of: ",", with: ""))
          .font(.system(size: 12))
        Spacer()
        Text("Style")
          .font(.system(size: 12))
          .fontWeight(.semibold)
        Text(placesViewModel.mapPlace.archStyle)
          .font(.system(size: 12))
        Spacer()
        Text("Lot size")
          .font(.system(size: 12))
          .fontWeight(.semibold)
        Text("\(placesViewModel.mapPlace.lotSize == 0 ? "unknown" : String(placesViewModel.mapPlace.lotSize) + " acre(s)")")
          .font(.system(size: 12))
      }
      .padding(.bottom, -3)
      HStack {
        Text("Square feet")
          .font(.system(size: 12))
          .fontWeight(.semibold)
          Text("\(placesViewModel.mapPlace.squareFeet == 0 ? "unknown" : String(placesViewModel.mapPlace.squareFeet))")
          .font(.system(size: 12))
        Spacer()
        Text("Estimated value")
          .font(.system(size: 12))
          .fontWeight(.semibold)
          .padding(.trailing, 10)
          Text("\(placesViewModel.mapPlace.estimatedValue == "unknown" ? "unknown" : "$" + placesViewModel.mapPlace.estimatedValue)")
          .font(.system(size: 12))
        Spacer()
        let logoWidth = UIScreen.main.bounds.size.height < 900 ? 48.0 : 64.0
        if let url = URL(string: placesViewModel.mapPlace.website) {
          if placesViewModel.mapPlace.website.contains("zillow") {
            Link(destination: url) {
              Image("Reviews/Zillow")
                .resizable()
                .scaledToFill()
                .frame(width: logoWidth)
            }
          } else {
            Link(destination: url) {
              Text("Website")
                .font(.system(size: 12))
                .padding(.top, 3)
            }
          }
        } else {
          Image("Reviews/Zillow")
            .resizable()
            .scaledToFill()
            .frame(width: logoWidth)
        }
      }
      .padding(.bottom, 20)
    }
    .padding(.top, 15)
  }
  
  private var reviewsSection: some View {
    let height = UIScreen.main.bounds.size.height
    let starPadding = height < 900 ? height < 850 ? -1.5 : -1.5 : -1.5
    
    let halfStar = Image("Reviews/HalfStar")
      .resizable()
      .scaledToFill()
      .frame(width: 4, height: 8)
      .padding(starPadding)
    let star = Image("Reviews/Star")
      .resizable()
      .scaledToFill()
      .frame(width: 4, height: 8)
      .padding(starPadding)

    let logoWidth = height < 900 ? 48.0 : 56.0
    var paddingLeading = 0.0
    
    if height == 956.0 {
      paddingLeading = 40.0
    } else if height == 874.0 {
      paddingLeading = 24.0
    } else {
      paddingLeading = 34.0
    }

    return VStack {
      Divider()
        .padding(4)
        .padding(.top, 5)
      
      if showRatingSelector == false {
        HStack {
          if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
            Link(destination: url) {
              Image("Reviews/Google")
                .resizable()
                .scaledToFill()
                .frame(width: logoWidth)
                .padding(.top, -4)
                .padding(.leading, paddingLeading)
            }
          } else {
            Image("Reviews/Google")
              .resizable()
              .scaledToFill()
              .frame(width: logoWidth)
              .padding(.top, -6)
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
            Text("(\(String(gReviews)))")
              .font(.system(size: 12))
              .frame(width: 50)
              .padding(.leading, -11)
          } else {
            Text("No reviews")
              .font(.system(size: 12))
              .padding(.leading, 5)
          }
          
          if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
            Link(destination: url) {
              Image("Reviews/Yelp")
                .resizable()
                .scaledToFill()
                .frame(width: logoWidth)
                .padding(.bottom, 5)
                .padding(.leading, -8)
            }
          } else {
            Image("Reviews/Yelp")
              .resizable()
              .scaledToFill()
              .frame(width: logoWidth)
              .padding(.bottom, 5)
              .padding(.leading, -8)
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
            Text("(\(String(yReviews)))")
              .font(.system(size: 12))
              .frame(width: 50)
              .padding(.leading, -12)
          } else {
            Text("No reviews")
              .font(.system(size: 12))
              .padding(.leading, 5)
          }
          
          Button {
            let defaults = UserDefaults.standard
            if let _ = defaults.string(forKey: "Rated:\(placesViewModel.mapPlace.documentID)") {
              message = "You've already rated this place."
              showMessage = true
            } else {
              showRatingSelector = true
            }
          } label: {
            Image("Reviews/Bucket\(placesViewModel.mapPlace.hinghamRating)Star").resizable().scaledToFit().frame(width: 52, height: 26)
              .padding(.top, -3)
          }
          .padding(.leading, -20)
          
          Text("(\(placesViewModel.mapPlace.hinghamReviews))")
            .font(.system(size: 12))
            .padding(.leading, -22)
            .frame(width: 10)
          
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 11)
        .padding(.leading, -40)
        
      } else {
        HStack {
          RatingsView(place: $placesViewModel.mapPlace, showRatingSelector: $showRatingSelector)
        }
      }
    }
  }
  
  private var messageLayer: some View {
    Text(message == "" ? location.message : message)
      .padding(2)
      .background(.blue)
      .foregroundColor(.white)
      .cornerRadius(10)
      .transition(.opacity)
      .font(.system(size: 16).weight(.bold))
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
          showMessage = false
          message = ""
          location.showMessage = false
          location.message = ""
        }
      }
  }
  
  private var mapLayer: some View {
    var places = placesViewModel.places.filter { $0.areaId == area.areaId }

    if places.count == 0 {
      loadPreviewPlaces()
      places.append(placeBrewedAwakenings)
      places.append(placeNonas)
      places.append(placeHalabyLawGroup)
      places.append(placeMaggies)
    }
    
    let screenSize = UIScreen.main.bounds.size
    
    return Map(position: $areasViewModel.mapCameraPosition, interactionModes: [.pan, .zoom]) {
      ForEach(places) { place in
        Annotation("", coordinate: place.coordinates) {
          withAnimation(.easeInOut) {
            PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, iconSize: place.iconSize, selected: place.selected, opacity: annotationOpacity, iconResizePercent: 0.0, filter: areasViewModel.filter)
              .shadow(radius: 10)
              .onTapGesture {
                withAnimation(.easeInOut) {
                  modelMode = "place"
                  placesViewModel.showPlace(area, place)
                  if showExpanded == "map" {
                    areasViewModel.zoomIn(0.0007)
                  }
                  showExpanded = ""
                }
              }
          }
        }
        .annotationTitles(.visible)
      }
      
      UserAnnotation()
    }
    .onMapCameraChange(frequency: .continuous) { context in
      areasViewModel.centerCoordinate = context.region.center

      if areasViewModel.mapCameraPosition.region == nil {
        areasViewModel.mapCameraPosition = MapCameraPosition.region(context.region)
      }
    }
    .background(.white)
    .frame(width: screenSize.width * 0.93, height: showExpanded == "map" ? screenSize.height * 0.83 : screenSize.height * 0.33)
    .cornerRadius(25)
    .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
    .mapControls {
      Button {
        let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
        areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.userLocation?.coordinate.latitude ?? 0.0, longitude: location.userLocation?.coordinate.longitude ?? 0.0), span: span))
      } label: {
        Image(systemName: "location.fill")
      }
    }
    .overlay {
      ZStack {
        VStack {
          HStack {
            Spacer(minLength: 0)
            Button {
              areasViewModel.showArea(area)
            } label: {
              Image(systemName: "return")
                .padding([.top, .trailing], 10)
                .foregroundColor(.black)
            }
          }
          Spacer(minLength: 0)
        }
      }
    }
  }
  
  enum WeekDays: CaseIterable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
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
  let hinghamSquare: SchemaV1.Area = SchemaV1.Area(areaId: 0, centerCoordinateLat: 42.24225, centerCoordinateLng: -70.88927, desc: "The Square is the old, quaint downtown of Hingham. Among the church steeples, you'll find boutiques, salons, restaurants, and a shoe repair shop. The Old Ship church, built by the Puritans in 1681, is the oldest wooden church in America still in use as a place of worship. The large yellow historic building on Main Street is affectionately called the \"Old Derby.\" It was the original location of Derby Academy, founded in 1784 and is the first coed school in America. The school still operates today on a larger campus on Burditt Street.", iconCoordinateLat: 42.24059, iconCoordinateLng: -70.88741, name: "Hingham Square", shortName: "Square", tilt: 0, zoom: 0.0007)
  
  
  AreaDetailView(area: hinghamSquare)
    .environmentObject(AreasViewModel())
    .environmentObject(PlacesViewModel())

}

struct CustomToggleButton: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                configuration.label
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}

class SoundManager{
    static let instance = SoundManager()
    
    var player:AVAudioPlayer?
    
    func playSound(_ resource:String){
      guard let url = Bundle.main.url(forResource: resource, withExtension: ".aifc") else {return}
      do {
        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
      } catch let error{
        print("Error: \(error.localizedDescription)")
      }
    }
}

