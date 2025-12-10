//
//  AreaPreviewView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/30/25.
//

import SwiftUI
import MapKit

struct AreaPreviewView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var location: LocationManager = LocationManager()
  @Binding var iconResizePercent: Double
  @Binding var showPlaceDetail: Bool
  @State private var scrollViewID = UUID()
  @State private var scrolledID = CGFloat.zero
  
  let area: SchemaV1.Area
  let screenWidth = UIScreen.main.bounds.size.width
  
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 0) {
        imageSection
          .padding(.top, -10)
          .padding(.trailing, 0)
        VStack {
          HStack {
            viewDetailsButton
            directionsButton
              .padding(.leading, -10)
          }
          .padding(.leading, 12)
          if placesViewModel.mapPlace.name != "" {
            addToBucketListButton
          }
        }
      }
      .padding(10)
      .padding([.leading, .trailing], 5)
      .cornerRadius(10)
      HStack (alignment: .top) {
        titleSection
          .padding(.top, -20)
          .padding(.bottom, -5)
          .padding([.leading], 15)
          .padding([.trailing], 15)
      }
    }
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(colorScheme == .dark ? .black : .white)  // .ultraThinMaterial
        .offset(y: 40)
    )
  }
}

//struct AreaPreviewView_Previews: PreviewProvider {
//  static var previews: some View {
//    ZStack {
//      Color.green.ignoresSafeArea()
//      AreaPreviewView(iconResizePercent: 0.0, area: AreasViewModel().previewArea)
//        .padding()
//    }
//    .environmentObject(AreasViewModel())
//  }
//}

//let path = modelMode == "place" ? "\(area.shortName)/\(placesViewModel.mapPlace.name)" : "\(area.shortName)/Area"
//let imageCount = modelMode == "place" ? placesViewModel.mapPlace.imageCount : area.imageCount == 0 ? 1 : area.imageCount
//
//ForEach(0..<imageCount, id: \.self) { index in
//  if UIImage(named: "\(path)/\(index)") != nil {
//    Image("\(path)/\(index)")
//      .resizable()
//      .scaledToFit()
//      .cornerRadius(25)
//  }
//}
//

extension AreaPreviewView {
  private var imageSection: some View {
    ZStack {
      Image(getImageUrl())
        .resizable()
        .cornerRadius(10)
        .frame(width: 160, height: 128)
        .onTapGesture {
//          areasViewModel.sheetArea = area
//          areasViewModel.mapArea = area
          withAnimation(.easeInOut) {
            areasViewModel.imagePath = placesViewModel.visible == true ? "\(areasViewModel.mapArea.shortName)/\(placesViewModel.mapPlace.name)" : "\(areasViewModel.mapArea.shortName)/Area"
            areasViewModel.imageCount = placesViewModel.visible == true ? placesViewModel.mapPlace.imageCount : areasViewModel.mapArea.imageCount == 0 ? 1 : areasViewModel.mapArea.imageCount
            areasViewModel.showExpandedImage = true
            
//            let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta:  areasViewModel.zoom)
//            areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
//            areasViewModel.visible = false
          }
        }
    }
    .padding(6)
    .background(.accent.opacity(0.75))
    .cornerRadius(10)
    .shadow(color: .black.opacity(0.75), radius: 4, x: 3, y: 3)
  }
  
  func getImageUrl() -> String {
    var imageUrl = ""
    
    if areasViewModel.previewImageUrl == "" {
      if areasViewModel.visible || placesViewModel.mapPlace.name == "" {
        imageUrl = area.shortName + "/Area/1"
      } else {
        imageUrl = area.shortName + "/" + placesViewModel.mapPlace.name + "/0"
        if UIImage(named: imageUrl) != nil {
          return imageUrl
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Liberty")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Liberty")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Square")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Square")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Lincoln")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Lincoln")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Crow Point")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Crow Point")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Turkey Hill")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Turkey Hill")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Glad Tidings")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Glad Tidings")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "East")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "East")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Center")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Center")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Fort Hill")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Fort Hill")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Shipyard")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Shipyard")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "Harbor")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "Harbor")
        } else if UIImage(named: imageUrl.replacingOccurrences(of: area.shortName, with: "World's End")) != nil {
          return imageUrl.replacingOccurrences(of: area.shortName, with: "World's End")
        }
      }
    } else {
      imageUrl = areasViewModel.previewImageUrl
    }
    
    return imageUrl
  }
  
  private var titleSection: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let textHeight = 180.0
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold
    let bodySize = placesViewModel.mapPlace.type == 6 ? 12.0 : 14.0
    var name = areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.name : placesViewModel.mapPlace.name
    name += name.hasSuffix("Historic") ? " District" : ""
    let address = areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? "" : placesViewModel.mapPlace.address
    
    return VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(name)
          .font(.system(.title2, design: design, weight: weight))
          .foregroundColor(.primary)
          .scaledToFill()
          .minimumScaleFactor(0.5)
          .lineLimit(1)
          .onChange(of: placesViewModel.mapPlace) {
            scrollViewID = UUID()
          }
        Spacer()
        Text(address)
          .font(.system(.footnote, design: design, weight: .regular))
      }
      
//      if area.name == "World's End" {
//        HStack {
//            Text("Get a")
//            .italic()
//            .font(.system(size: 18))
//            .fontWeight(.bold)
//            .padding(.top, 12)
//          
//            Image("handle")
//                .resizable()
//                .frame(width: 60, height: 45)
//                .padding(.bottom, 6)
//          
//            Text("on World's End!")
//            .italic()
//            .font(.system(size: 18))
//            .fontWeight(.bold)
//            .padding(.top, 12)
//        }
//      }
      
      Divider()
      
      let descText: LocalizedStringKey = LocalizedStringKey(stringLiteral: areasViewModel.visible == true || placesViewModel.mapPlace.name == ""  ? area.desc : placesViewModel.mapPlace.notes)
      
      ScrollView(.vertical, showsIndicators: true) {
        if placesViewModel.mapPlace.name == "" && area.desc.contains("•") || placesViewModel.mapPlace.notes.contains("•") {
          let notes = placesViewModel.mapPlace.name == "" ? area.desc : placesViewModel.mapPlace.notes
          let bulletLines = notes.filter { $0 != "\n" } .components(separatedBy: "•")
          
          VStack {
            ForEach(Array(bulletLines.enumerated()), id: \.offset) { index, line in
              HStack {
                if line[line.index(line.startIndex, offsetBy: 1, limitedBy: line.endIndex)!] != " " {
                  Image("bucketpoint")
                    .resizable()
                    .frame(width: 27, height: 21)
                    .padding(0)
                }
                Text(LocalizedStringKey(stringLiteral:line))
                  .font(.system(size: bodySize, weight: .regular, design: Font.Design.default))
                  .id(index)
                Spacer()
              }
            }
          }
          .background(GeometryReader {
            Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
          })
          .onPreferenceChange(ViewOffsetKey.self) {
            setBucketPointImage(offset: $0)
          }
        } else {
          Text(descText)
            .font(.system(size: bodySize, weight: .regular, design: design))
            .foregroundColor(.primary)
        }
      }
      .coordinateSpace(name: "scroll")
    }
    .frame(width: 380, height: textHeight)
    .padding(.trailing, 10)
    .padding(.top, screenWidth < 360 ? -5 : 10)
    .padding(.bottom, -20)
  }
  
  private func setBucketPointImage(offset: CGFloat) {
//    print("offset:\(offset)")
    withAnimation(.easeInOut) {
      if area.name == "World's End" && placesViewModel.mapPlace.name != "Iron Horse Statue" {
        let dir = "World's End/Area/"
        if offset < 37.0 {
          areasViewModel.previewImageUrl = "\(dir)1"
        } else if offset < 80.0 {
          areasViewModel.previewImageUrl = "\(dir)FourDrumlins"
        } else if offset < 123.0 {
          areasViewModel.previewImageUrl = "\(dir)RedwoodSequoia"
        } else if offset < 166.0 {
          areasViewModel.previewImageUrl = "\(dir)LandBridges"
        } else if offset < 209.0 {
          areasViewModel.previewImageUrl = "\(dir)WampanoagNipmuc"
        } else if offset < 287.0 {
          areasViewModel.previewImageUrl = "\(dir)AbrahamMartin"
        } else if offset < 346.0 {
          areasViewModel.previewImageUrl = "\(dir)StoneWallCarriagePath"
        } else if offset < 421.0 {
          areasViewModel.previewImageUrl = "\(dir)TwoTrunks"
        } else if offset < 466.0 {
          areasViewModel.previewImageUrl = "\(dir)TreeBoundary"
        } else if offset < 524.0 {
          areasViewModel.previewImageUrl = "\(dir)450acres"
        } else if offset < 583.0 {
          areasViewModel.previewImageUrl = "\(dir)SarahLanglee"
        } else if offset < 638.0 {
          areasViewModel.previewImageUrl = "\(dir)HayCart"
        } else if offset < 684.0 {
          areasViewModel.previewImageUrl = "\(dir)StoneColumns"
        } else if offset < 729.0 {
          areasViewModel.previewImageUrl = "\(dir)MapleOak"
        } else if offset < 838.0 {
          areasViewModel.previewImageUrl = "\(dir)FrederickLawOlmsted"
        } else if offset < 958.0 {
          areasViewModel.previewImageUrl = "\(dir)CurvingTreeLined"
        } else if offset < 1002.0 {
          areasViewModel.previewImageUrl = "\(dir)Swales"
        } else if offset < 1064.0 {
          areasViewModel.previewImageUrl = "\(dir)UnitedNations"
        } else if offset < 1138.0 {
          areasViewModel.previewImageUrl = "\(dir)PlymouthNuclearPowerPlant"
        } else if offset < 1200.0 {
          areasViewModel.previewImageUrl = "\(dir)CharlesEliot"
        } else if offset < 1276.0 {
          areasViewModel.previewImageUrl = "\(dir)NameOriginUnknown"
//        } else if offset < 525.0 {
//          previewImage = "\(dir)GentlemanFarmer"
        }
      } else if placesViewModel.mapPlace.name == "Iron Horse Statue" {
        let dir = "Harbor/Iron Horse Statue/"
        if offset < 37.0 {
          areasViewModel.previewImageUrl = "\(dir)0"
        } else if offset < 99.0 {
          areasViewModel.previewImageUrl = "\(dir)TheoAliceRugglesKitson"
        } else if offset < 148.0 {
          areasViewModel.previewImageUrl = "\(dir)Spartacus"
        } else if offset < 177.0 {
          areasViewModel.previewImageUrl = "\(dir)LaurelWreath"
        } else if offset < 224.0 {
          areasViewModel.previewImageUrl = "\(dir)TorchRobeSword"
        } else if offset < 268.0 {
          areasViewModel.previewImageUrl = "\(dir)BareFoot"
        } else if offset < 296.0 {
          areasViewModel.previewImageUrl = "\(dir)BareFootAndShoe"
        } else if offset < 327.0 {
          areasViewModel.previewImageUrl = "\(dir)FootTooWide"
        }
      }
    }
  }
  
  private var viewDetailsButton: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold

    return Button {
      if areasViewModel.visible == false {
        if areasViewModel.mapArea != area {
          areasViewModel.mapArea = area
        }
        placesViewModel.showPlace(area, placesViewModel.mapPlace)
        areasViewModel.visible = placesViewModel.mapPlace.name == ""
        showPlaceDetail = true
      } else {
        iconResizePercent = 0.0
        if (area.areaId == areasViewModel.mapArea.areaId) {
          withAnimation(.easeInOut) {
            areasViewModel.distance = 0.0
            areasViewModel.setFilterZoomDistance(filter: areasViewModel.filter, areaId: area.areaId)
            let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta: areasViewModel.zoom)
            areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
            areasViewModel.visible = false
          }
        } else {
          areasViewModel.mapArea = area
          placesViewModel.mapPlace = SchemaV1.Place()
          areasViewModel.showArea(area)
        }
        
        areasViewModel.firstScreenVisible = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
          withAnimation(.easeInOut) {
            areasViewModel.showPreviewView = false
          }
        }
      }
    } label: {
      Text("Details")
        .font(.system(.headline, design: design, weight: weight))
        .frame(width: screenWidth < 360 ? 40 : 70, height: 25)
        .foregroundColor(.white)
    }
    .buttonStyle(.borderedProminent)
    .cornerRadius(10.0)
    .padding([.trailing], screenWidth < 360 ? 18 : 26)
    .padding(.top, UIScreen.main.bounds.size.height < 800 ? 32.0 : 42.0)
  }
  
  private var directionsButton: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.semibold : Font.Weight.bold

    return HStack {
      Button {
        location.startUpdating()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
          if let userLocation = location.userLocation {
            var targetLat = area.centerCoordinateLat
            var targetLng = area.centerCoordinateLng
            
            if placesViewModel.mapPlace.name != "" {
              targetLat = placesViewModel.mapPlace.locationLat
              targetLng = placesViewModel.mapPlace.locationLng
            }
            
            let urlString = "http://maps.apple.com/?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(targetLat),\(targetLng)"
            if let url = URL(string: urlString) {
              if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
            }
          }
        }
      } label: {
        Text("Directions")
          .font(.system(.subheadline, design: design, weight: weight))
          .frame(width: screenWidth < 360 ? 60 : 80, height: 25)
      }
      .buttonStyle(.bordered)
      .padding(.top, UIScreen.main.bounds.size.height < 800 ? 32.0 : 42.0)
      .padding(.trailing, 16)
      .frame(width: 75.0)
    }
    .padding(.leading, 5)
  }
  
  private var addToBucketListButton: some View {
    let design = placesViewModel.mapPlace.type == 6 ? Font.Design.serif : Font.Design.default
    let weight = placesViewModel.mapPlace.type == 6 ? Font.Weight.bold : Font.Weight.bold
    let documentID = placesViewModel.mapPlace.documentID
    
    return Button {
      @AppStorage("BucketList") var bucketList: String = ""
      var bucketListArray = bucketList.components(separatedBy: ",")
      
      if bucketListArray.count > 0 {
          if !bucketListArray.contains(documentID) {
            bucketListArray.append(documentID)
            areasViewModel.addToBucketlistCaption = "Added to Bucket List"
            areasViewModel.addToBucketlistImage = "bucketlistAdded"
          }
      } else {
        bucketListArray.append(documentID)
        areasViewModel.addToBucketlistCaption = "Added to Bucket List"
        areasViewModel.addToBucketlistImage = "bucketlistAdded"
      }
      
      bucketList = bucketListArray.joined(separator: ",")
    } label: {
      ZStack {
        HStack {
          Image(areasViewModel.addToBucketlistImage)
            .resizable()
            .scaledToFit()
            .frame(width: 38, height: 38)
            .padding(.leading, -8)
          Text(areasViewModel.addToBucketlistCaption)
            .font(.system(size: 13, weight: weight, design: design))
            .frame(width: screenWidth < 360 ? 100 : 136)
            .padding(.leading, -8)
        }
      }
      .frame(width: 180, height: 26)
    }
    .buttonStyle(.bordered)
    .padding(.leading, 17)
  }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

import SwiftUI

//#Preview {
//  AreaPreviewView(area: AreasViewModel().areas.first!)
//}
