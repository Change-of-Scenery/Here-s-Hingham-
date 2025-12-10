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
      GridItem(.fixed(screenHeight * (areasViewModel.visible == true ? 0.008 : 0.018))),  // title
      GridItem(.fixed(screenHeight * (areasViewModel.visible == true ? 0.0 : 0.04))),    // reviews
      GridItem(.fixed(screenHeight * 0.44))    // map
    ]
    let expandedMapRows = [
      GridItem(.fixed(screenHeight * 0.82))   // map
    ]
    let expandedDescRows = [
      GridItem(.fixed(screenHeight * 0.829))   // desc
    ]
    
    let backgroundColor = colorScheme == .dark ? Color(red: 0.01, green: 0.01,  blue: 0.0) : Color(red: 0.99, green: 0.99,  blue: 0.9)
    let width = UIScreen.main.bounds.size.width
    
    if (verticalSizeClass == .compact || horizontalSizeClass == .regular) && UIDevice.current.userInterfaceIdiom != .pad {
      expandedImageSection
    } else {
      if showExpanded == "map" {
        LazyHGrid(rows: expandedMapRows, spacing: 10) {
        }
        .frame(width: width)
        .background(backgroundColor)
      } else if showExpanded == "desc" {
        LazyHGrid(rows: expandedDescRows, spacing: 10) {
          expandedDescSection
        }
        .frame(width: width)
        .background(backgroundColor)
      } else  {
        LazyHGrid(rows: rows, spacing: 10) {
          imageSection
          titleSection
          
          if placesViewModel.visible == true {
            if placesViewModel.mapPlace.type == 6 {
              historicHouseSection
            } else {
              reviewsSection
            }
          } else {
            areaSection
          }
          descSection
        }
        .frame(width: width)
        .background(backgroundColor)
        .onChange(of: location.newPlaceAtCurrentLocation) {
          placesViewModel.visible = true
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

  private var hoursWindow: some View {
    let hours = placesViewModel.mapPlace.hours.components(separatedBy: ";")
    let cols = [GridItem(.fixed(100)), GridItem(.fixed(120))]
    
    return ZStack {
      VStack(alignment: .center) {
        Text("Hours")
          .fontWeight(.bold)
          .padding(.top, -3)
        
        ForEach(0..<7, id: \.self) { index in
          LazyVGrid(columns: cols, alignment: .leading) {
            let weekDay = String(describing: WeekDays.allCases[index])
            Text(weekDay)
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
    .frame(width: 280)
    .cornerRadius(25)
    .onTapGesture {
      showHours = false
    }
    .shadow(color: .black.opacity(0.75), radius: 4, x: 3, y: 3)
  }
  
  private var areaSection: some View {
    VStack {
    }
  }
    
  private var imageSection: some View {
       
    return TabView(selection:$tabSelection) {
      let path = placesViewModel.visible == true ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
      let imageCount = placesViewModel.visible == true ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
      let startIndex = areasViewModel.visible == true ? 1 : 0
      
      ForEach(startIndex..<imageCount, id: \.self) { index in
        if UIImage(named: "\(path)/\(index)") != nil {
          Image("\(path)/\(index)")
            .resizable()
            .scaledToFit()
            .cornerRadius(25)
        }
      }
      
      if placesViewModel.visible == true && imageCount < 10 {
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
    let place = placesViewModel.mapPlace
    var url = URL(string: "https://en.wikipedia.org/wiki/\(area.wikiName)")!
    let font = place.type == 6 ? Font.system(size: 22.0, weight: .bold, design: .serif) : Font.system(size: 22.0, weight: .bold, design: .default)
    let smallFont = place.type == 6 ? Font.system(size: 16.0, weight: .bold, design: .serif) : Font.system(size: 16.0, weight: .bold, design: .default)
    let smallTextFont = place.type == 6 ? Font.system(size: 12.0, weight: .regular, design: .serif) : Font.system(size: 12.0, weight: .regular, design: .default)
    let addressFont = place.type == 6 ? Font.system(size: 14.0, weight: .regular, design: .serif) : Font.system(size: 12.0, weight: .regular, design: .default)
    let width = UIScreen.main.bounds.size.width * 0.93
    
    if placesViewModel.visible == true {
      name = place.type == 6 && !place.name.hasSuffix("Church") ? place.name + " House" : place.name
      if place.website != "" {
        url = URL(string: place.website)!
      }
    }
    
    return VStack(alignment: .leading) {
      HStack {
        if url.absoluteString == "" {
          Text(name)
            .font(name.count > 30 ? smallFont : font)
        } else {
          Link(name, destination: url)
            .font(name.count > 30 ? smallFont : font)
            .foregroundColor(.red)
        }

        if placesViewModel.visible == true {
          Spacer()
          Text(place.desc == "" ? place.yelpCategory : place.desc)
            .font(smallTextFont)
          Text(place.yelpPrice)
            .font(smallTextFont)
        }
      }
      .padding(.bottom, 2.0)
    
      if placesViewModel.visible == true {
        HStack {
          Text(place.address)
            .font(addressFont)
          Spacer()
          if placesViewModel.mapPlace.menuUrl != "" {
            let menuUrl = URL(string: placesViewModel.mapPlace.menuUrl)!
            Link(destination: menuUrl) {
              Text("Menu")
                .font(smallTextFont)              
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
              .font(smallTextFont)
              .foregroundColor(.red)
              .frame(width: 100, alignment: .trailing)
          }
          Spacer()
          Link(destination: URL(string: "tel:" + placesViewModel.mapPlace.phone)!) {
            Text(placesViewModel.mapPlace.phone)
              .font(smallTextFont)
              .frame(width: 90, alignment: .trailing)
          }
        }
      }
    }
    .frame(width: width)
  }
  
  private var descSection: some View {
    let place = placesViewModel.mapPlace
    let desc = areasViewModel.visible == true ? area.desc : placesViewModel.mapPlace.notes
    let descText: LocalizedStringKey
    var afterImageText: LocalizedStringKey? = nil
    let textFont = place.type == 6 ? Font.system(size: 13.0, weight: .regular, design: .serif) : Font.system(size: 13.0, weight: .regular, design: .default)
    let path = placesViewModel.visible == true ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
    let width = UIScreen.main.bounds.size.width * 0.93
        
    if let tildeIndex = desc.firstIndex(of: "~") {
      descText = LocalizedStringKey(stringLiteral: String(desc[..<tildeIndex]))
      afterImageText = LocalizedStringKey(stringLiteral: String(desc[desc.index(after: tildeIndex)...]))
    } else {
      descText = LocalizedStringKey(stringLiteral: desc)
    }
    
    return HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Divider()
          .padding(.top, place.type == 6 ? 18 : 0)
          .frame(width: width)

        ScrollView {
          if desc.contains("•") {
            let bulletLines = desc.filter { $0 != "\n" } .components(separatedBy: "•")
            let bodySize = placesViewModel.mapPlace.type == 6 ? 12.0 : 14.0
            
            VStack {
              ForEach(bulletLines, id: \.self) { line in
                HStack {
                  if line[line.index(line.startIndex, offsetBy: 1, limitedBy: line.endIndex)!] != " " {
                    Image("bucketpoint")
                      .resizable()
                      .frame(width: 27, height: 21)
                      .padding(0)
                  }
                  Text(LocalizedStringKey(stringLiteral:line))
                    .font(.system(size: bodySize, weight: .regular, design: Font.Design.default))
                  Spacer()
                }
              }
            }
          } else {
            Text(descText)
              .font(textFont)
              .foregroundColor(.primary)
            
            if afterImageText != nil {
              ForEach(1..<10, id: \.self) { index in
                if UIImage(named: "\(path)/\(index)") != nil {
                  Image("\(path)/\(index)")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(2)
                    .frame(width: UIScreen.main.bounds.width * 0.95)
                    .padding(0)
                }
              }
              
              Text(afterImageText!)
                .font(textFont)
                .foregroundColor(.primary)
            }
          }
        }
      }
    }
    .frame(width: width)
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
          let path = placesViewModel.visible == true ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
          let imageCount = placesViewModel.visible == true ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
          
          ForEach(0..<imageCount, id: \.self) { index in
            if UIImage(named: "\(path)/\(index)") != nil {
              Image("\(path)/\(index)")
                .resizable()
                .scaledToFit()
                .cornerRadius(25)
            }
          }
          
          if placesViewModel.visible == true && imageCount < 10 {
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
        Text(areasViewModel.visible == true ? areasViewModel.mapArea.name : placesViewModel.mapPlace.name)
          .font(.system(size: 24))
          .fontWeight(.bold)
        
        let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: areasViewModel.visible == true ? area.desc : placesViewModel.mapPlace.notes)
        
        ScrollView {
          Text(descText)
            .font(.system(size: 16))
            .foregroundColor(.primary)        }
      }
    }
    .padding()
    .frame(width: UIScreen.main.bounds.size.width * 0.93)
  }
  
  private var historicHouseSection: some View {
    let place = placesViewModel.mapPlace
    let labelFont = Font.system(size: 14.0, weight: .semibold, design: .serif)
    let textFont = Font.system(size: 14.0, weight: .regular, design: .serif)
    let width = UIScreen.main.bounds.size.width * 0.93
    
    return VStack(alignment: .leading) {
      Divider()
        .padding(.top, 40)
        .frame(width: width)
      
      HStack {
        Text("Year built")
          .font(labelFont)
        Text(place.yearBuilt == 0 ? "" : "\(place.yearBuilt)".replacingOccurrences(of: ",", with: ""))
          .font(textFont)
        Spacer()
        Text("Style")
          .font(labelFont)
        Text(place.archStyle)
          .font(textFont)
        Spacer()
        Text("Lot size")
          .font(labelFont)
          .fontWeight(.semibold)
        Text("\(place.lotSize == 0 ? "" : String(place.lotSize) + " acre(s)")")
          .font(textFont)
      }
      .padding(.bottom, -3)
      HStack {
        Text("Square feet")
          .font(labelFont)
        Text("\(place.squareFeet == 0 ? "" : place.squareFeet.formatted())")
          .font(textFont)
        Spacer()
        Text("Estimated value")
          .font(labelFont)
          .padding(.trailing, 10)
        Text(place.estimatedValue == "unknown" ? "" : place.estimatedValue.isNumber == true ? "$\(place.estimatedValue)" : place.estimatedValue)
          .font(textFont)
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
                .font(textFont)
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
    let width = UIScreen.main.bounds.size.width * 0.93
    
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
      paddingLeading = 32.0
    } else if height == 874.0 {
      paddingLeading = 24.0
    } else {
      paddingLeading = 16.0
    }

    return VStack {
      Divider()
        .padding(4)
        .padding(.top, 5)
        .frame(width: width)
      
      if showRatingSelector == false {
        HStack {
          if placesViewModel.mapPlace.instagram != "" {
            Link(destination: URL(string: "https://www.instagram.com/\(placesViewModel.mapPlace.instagram)")!) {
              Image("Reviews/Instagram")
                .resizable()
                .scaledToFill()
                .frame(width: 20)
                .padding(.top, -2)
                .padding(.leading, 32)
                .padding(.trailing, 4)
            }

          }
          if let url = URL(string: placesViewModel.mapPlace.yelpUrl) {
            Link(destination: url) {
              Image("Reviews/Google")
                .resizable()
                .scaledToFill()
                .frame(width: logoWidth)
                .padding(.top, -4)
            }
          } else if placesViewModel.mapPlace.googleReviews > 0 {
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
          } else if placesViewModel.mapPlace.yelpReviews > 0 {
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
          }
          
          Button {
            @AppStorage("Rated:\(placesViewModel.mapPlace.id)") var rated: String = ""
            
            if rated != "" {
              message = "You've already rated this place."
              showMessage = true
            } else {
              showRatingSelector = true
            }
          } label: {
            Image("Reviews/Bucket\(placesViewModel.mapPlace.hinghamReviews)Star").resizable().scaledToFit().frame(width: 52, height: 26)
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

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
}


