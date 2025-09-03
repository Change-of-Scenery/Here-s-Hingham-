
//
//  MainView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 8/21/25.
//
import SwiftUI
import SwiftData
import MapKit
import GoogleMaps
import CoreLocation

struct MainView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.colorScheme) var colorScheme
  @State private var position = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.22127,longitude: -70.89328), span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)))
  @State private var annotationOpacity: Double = 1.0
  @State private var iconResizePercent: Double = 0.0
  @State private var paths: [String] = []
  @State private var showPlaceDetail = false
  @State private var longPressCoordinate: CLLocationCoordinate2D?
  @State private var lookAroundScene: MKLookAroundScene?
  @State private var isShowingLookAroundViewer = false
  @State private var isLookAroundUnavailable = false
  @ObservedObject var location: LocationManager = LocationManager()
  
  var body: some View {
    NavigationStack(path: $paths) {
      ZStack {
        if showPlaceDetail == true {
          AreaDetailView(area: areasViewModel.mapArea)
        } else {
          if isShowingLookAroundViewer == true {
            LookAroundPreview(initialScene: lookAroundScene, allowsNavigation: true)
              .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.33)
              .cornerRadius(12)
              .padding(.bottom, UIScreen.main.bounds.height * 0.524)
              .zIndex(1.0)
              .overlay(alignment: .topTrailing) {
                Button {
                  isShowingLookAroundViewer = false
                }
                label: {
                  Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding()
              }
              .onTapGesture { point in
                print(point)
              }
          }
          if areasViewModel.visible == true {
            areaMapLayer
          } else {
            placeMapLayer
          }
          VStack {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 10) {
                FilterButtonView(title: "All", imageName: "globe", type: 0)
                FilterButtonView(title: "Dining", imageName: "fork.knife", type: 1)
                FilterButtonView(title: "Coffee", imageName: "cup.and.saucer", type: 7)
                FilterButtonView(title: "Retail", imageName: "handbag", type: 2)
                FilterButtonView(title: "Historic", imageName: "house", type: 6)
                FilterButtonView(title: "Parks", imageName: "tree", type: 8)
                FilterButtonView(title: "Events", imageName: "calendar", type: 100)
                FilterButtonView(title: "Videos", imageName: "video", type: 100)
                FilterButtonView(title: "Update Yelp", imageName: "gear", type: 100)
                FilterButtonView(title: "Update Google", imageName: "gear", type: 100)
              }
              .padding(.horizontal)
              .padding([.leading, .trailing], 10)
            }
            .frame(height:50)
            .background(.clear)
            Spacer()
            areasPreviewStack
          }
        }
      }
      .navigationTitle("Here's Hingham")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          if areasViewModel.visible == false {
            Button {
              if showPlaceDetail == true {
                showPlaceDetail = false
              } else {
                placesViewModel.visible = false
                areasViewModel.visible = true
              }
            } label:
            {
              Image(systemName: "chevron.left")
            }
          }
        }
        ToolbarItem(placement: .principal) {
          Image("AppToolbar")
            .resizable()
            .scaledToFit()
            .frame(height: 30)
        }
        //      ToolbarItem(placement: .navigationBarLeading) {
        //        Button { areasViewModel.filter = 1 } label: { Image(systemName: "fork.knife")}.background(areasViewModel.filter == 1 ? Color.tabSelect : Color.clear)
        //      }
        //      ToolbarItem(placement: .automatic) {
        //        Button { areasViewModel.filter = 7 } label: { Image(systemName: "cup.and.saucer")}.background(areasViewModel.filter == 7 ? Color.tabSelect : Color.clear)
        //      }
        //      ToolbarItem(placement: .automatic) {
        //        Button { areasViewModel.filter = 2 } label: { Image(systemName: "handbag")}.background(areasViewModel.filter == 2 ? Color.tabSelect : Color.clear)
        //      }
        //        ToolbarItem(placement: .automatic) {
        //          Button { areasViewModel.filter = 9 } label: { Image(systemName: "scissors")}.background(areasViewModel.filter == 9 ? Color.secondary : Color.clear)
        //        }
        //        ToolbarItem(placement: .automatic) {
        //          Button { areasViewModel.filter = 3 } label: { Image(systemName: "tshirt")}.background(areasViewModel.filter == 3 ? Color.tabSelect : Color.clear)
        //        }
        //        ToolbarItem(placement: .automatic) {
        //          Button { areasViewModel.filter = 5 } label: { Image(systemName: "pill")}.background(areasViewModel.filter == 5 ? Color.tabSelect : Color.clear)
        //        }
        //      ToolbarItem(placement: .automatic) {
        //        Button { areasViewModel.filter = 6 } label: { Image(systemName: "house")}.background(areasViewModel.filter == 6 ? Color.tabSelect : Color.clear)
        //      }
        //      ToolbarItem(placement: .navigationBarTrailing) {
        //        Button { areasViewModel.filter = 8 } label: { Image(systemName: "tree")}.background(areasViewModel.filter == 8 ? Color.tabSelect : Color.clear)
        //      }
        //        ToolbarItem(placement: .topBarTrailing) {
        //          Button { areasViewModel.filter = 0 } label: { Image(systemName: "map").foregroundColor(colorScheme == .dark ? darkFColor : lightFColor) }.padding(.bottom, 10).background(areasViewModel.filter == 0 ? selectColor : unselectColor)
        //        }
        //        .sheet(item: $areasViewModel.sheetArea) { area in
        //          if area.imageCount == 0 {
        //            var imageCounter = 0
        //            while UIImage(named: ("\(area.shortName)/Area/\(imageCounter)")) != nil {
        //              imageCounter += 1
        //            }
        //            area.imageCount = imageCounter
        //          }
        //
        //          AreaDetailView(area: area)
        //        }
      }
//      .toolbarTitleMenu {
//        Button("Bucket Vision") {
//          // paths.append("Area Details")
//        }
//        Button("Settings") {
//          // paths.append("Place Details")
//        }
//      }
      .navigationDestination(for: String.self) { value in
        //      if value == "Area Details" {
        //        AreaView()
        //      } else if value == "Place Details" {
        //        Text(value)
        //      }
      }
      .alert(isPresented: $isLookAroundUnavailable) {
        Alert(title: Text("Look Around"), message: Text("Look around is not available in this area."), dismissButton: .default(Text("OK")))
      }
    }
  }
}

struct FilterButtonView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @EnvironmentObject private var placesViewModel: PlacesViewModel
  @Environment(\.colorScheme) var colorScheme
  let title: String
  let imageName: String
  let type: Int
  
  var body: some View {
    Button(action: {
      if title == "Events" {
        let urlString = "https://www.hinghamanchor.com/calendar/"
        if let url = URL(string: urlString) {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }
      } else if title == "Videos" {
        let urlString = "https://www.youtube.com/@HarborMedia"
        if let url = URL(string: urlString) {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }
      } else if title == "Update Yelp" {
        let dataService = DataService()
        let places = placesViewModel.places.filter { $0.areaId == 5 }
        var counter = 0
        places.forEach { place in
          if place.yelpCategory == "" && counter < 11 {
            dataService.updateYelp(name: place.name)
            counter += 1
          }
        }
      } else if title == "Update Google" {
        let dataService = DataService()
        let places = placesViewModel.places.filter { $0.areaId == 5 }
        places.forEach { place in
          dataService.updateGoogle(name: place.name)
        }
      } else if type < 100 {
        areasViewModel.filter = type
      }
    }) {
      HStack {
        Image(systemName: imageName)
        Text(title)
      }
      .padding(6)
    }
    .foregroundColor(colorScheme == .dark ? .white : .black)
    .background(areasViewModel.filter == type ? Color.tabSelect : colorScheme == .dark ? .black : .white)
    .font(.system(size: 10))
    .fontWeight(.semibold)
    .cornerRadius(10.0)
    .shadow(color: .black.opacity(0.75), radius: 2, x: 1, y: 1)
  }
}
  
extension MainView {
  
  private var header: some View {
    HStack {
      Button(action: areasViewModel.toggleAreasList) {
        Text(areasViewModel.mapArea.name)
          .font(.title2)
          .fontWeight(.black)
          .foregroundColor(.primary)
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .animation(.none, value: areasViewModel.mapArea)
          .overlay(alignment: .leading) {
            Image(systemName: "arrow.down")
              .font(.headline)
              .foregroundColor(.primary)
              .padding()
              .rotationEffect(Angle(degrees: areasViewModel.showAreasList ? 180 : 0))
          }
      }
      
      if areasViewModel.showAreasList {
        AreasListView()
      }
      
    }
    .background(.thickMaterial)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
  }
  
  private var areaMapLayer: some View {
    Map(initialPosition: position) {
      ForEach(areasViewModel.areas) { area in
        Annotation(area.name, coordinate: area.coordinates) {
          AreaAnnotationView(area: area, selected: areasViewModel.mapArea == area, opacity: annotationOpacity)
            .scaleEffect(areasViewModel.mapArea == area ? 1.2 : 0.7)
            .shadow(radius: 10)
            .onTapGesture {
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
            }
        }
        .annotationTitles(.hidden)
      }
    }
    .ignoresSafeArea()
    .onMapCameraChange(frequency: .continuous, {
      annotationOpacity = 0.3
    })
    .onMapCameraChange(frequency: .onEnd) { context in
      annotationOpacity = 1.0
    }
  }
  
  private var placeMapLayer: some View {
    let area = areasViewModel.mapArea
    var places = placesViewModel.places.filter { $0.areaId == area.areaId }
    
    if areasViewModel.filter > 0 {
      if areasViewModel.filter == 2 {
        let includedTypes = [2, 3, 5, 9]
        places = places.filter { item in
          includedTypes.contains(item.type)
        }
      } else {
        places = places.filter { $0.type == areasViewModel.filter }
      }
    }
      
    return ZStack {
      MapReader { proxy in
        Map(position: $areasViewModel.mapCameraPosition) {
          ForEach(places) { place in
            Annotation("", coordinate: place.coordinates) {
              withAnimation(.easeInOut) {
                PlaceAnnotationView(areaName: area.shortName, placeName: place.name, shortName: place.shortName, type: place.type, iconSize: place.iconSize, selected: place.selected, opacity: annotationOpacity, iconResizePercent: iconResizePercent, filter: areasViewModel.filter)
                  .shadow(radius: 10)
                  .onTapGesture {
                    withAnimation(.easeInOut) {
                      placesViewModel.showPlace(area, place)
                      //                  areasViewModel.zoomIn(area.zoom)
                    }
                  }
              }
            }
            .annotationTitles(.visible)
          }
          
          UserAnnotation()
        }
        .ignoresSafeArea()
        .onMapCameraChange(frequency: .continuous) { context in
          let distanceDelta = areasViewModel.distance - context.camera.distance
          
          if areasViewModel.distance == 0.0 {
            iconResizePercent = 0.0
            areasViewModel.distance = context.camera.distance
          } else if areasViewModel.distance != context.camera.distance && abs(distanceDelta) > 20 {
            let saveAreaId:Int = areasViewModel.mapArea.areaId
            areasViewModel.mapArea.areaId = -1
            iconResizePercent = areasViewModel.distance / context.camera.distance
            areasViewModel.mapArea.areaId = saveAreaId
          }
          
          areasViewModel.centerCoordinate = context.region.center
          
          if areasViewModel.mapCameraPosition.region == nil {
            areasViewModel.mapCameraPosition = MapCameraPosition.region(context.region)
          }
        }
        .background(.white)
        .mapStyle(.standard(pointsOfInterest: .including([.airport, .amusementPark, .evCharger, .fireStation, .library, .nationalPark, .park, .parking, .police, .restroom, .university, .publicTransport])))
        .mapControls {
          Button {
            let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
            areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.userLocation?.coordinate.latitude ?? 0.0, longitude: location.userLocation?.coordinate.longitude ?? 0.0), span: span))
          } label: {
            Image(systemName: "location.fill")
          }
        }
        .simultaneousGesture (
          DragGesture(minimumDistance: 0.0)
            .onChanged { value in
              let location = value.startLocation
              if let pinLocation = proxy.convert(location, from: .local) {
                  longPressCoordinate = pinLocation
              }
            }
            .simultaneously(with: LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                  if let coordinate = longPressCoordinate {
                    let request = MKLookAroundSceneRequest(coordinate: coordinate)
                    request.getSceneWithCompletionHandler { scene, error in
                      if let error = error {
                          print("Error fetching Look Around scene: \(error.localizedDescription)")
                          return
                      }
                      if let scene {
                        lookAroundScene = scene
                        isShowingLookAroundViewer = true
                        print("Successfully fetched Look Around scene for coordinate: \(coordinate)")
                      } else {
                        isLookAroundUnavailable = true
                      }
                    }
                  }
                }
            )
        )
      }
      
//      Color.clear
//        .contentShape(Rectangle())
//        .gesture(
//          LongPressGesture(minimumDuration: 0.5)
//            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
//            .onEnded { value in
//                switch value {
//                case .first(true): // Long press began
//                    print("Long press started")
//                case .second(true, let dragValue): // Long press ended with drag
//                  // longPressCoordinate = CLLocationCoordinate2D(latitude: dragValue!. .location.coordinate.latitude, longitude: dragValue!.location.coordinate.latitude)
//                default:
//                    break
//                }
//            }
//        )
    }
  }
   
  private var appBanner: some View {
    Image("AppBanner")
  }
  
  private var areasPreviewStack: some View {
    ZStack {
      ForEach(areasViewModel.areas) { area in
        if areasViewModel.mapArea == area {
          AreaPreviewView(iconResizePercent: $iconResizePercent, showPlaceDetail: $showPlaceDetail, area: area)
            .shadow(color: .black.opacity(0.3), radius: 20)
            .padding()
            .transition(.asymmetric(insertion: .move(edge: .trailing) , removal: .move(edge: .leading)))
        }
      }
    }
  }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  private let manager = CLLocationManager()
  @Published var userLocation: CLLocation?
  @Published var message: String = ""
  @Published var showMessage = false
  @Published var newPlaceAtCurrentLocation: SchemaV1.Place?
  @Published var placesViewModel: PlacesViewModel = PlacesViewModel()
  @Published var areaId = 0
  
  func startUpdating() {
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
  }
  
  func stopUpdating() {
    manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    userLocation = locations.last
    
    let placesFound = placesViewModel.places.filter {
      return $0.areaId == areaId &&
      userLocation!.coordinate.latitude > $0.locationLat - 0.0005 &&
      userLocation!.coordinate.latitude < $0.locationLat + 0.0005 &&
      userLocation!.coordinate.longitude > $0.locationLng - 0.0005 &&
      userLocation!.coordinate.longitude < $0.locationLng + 0.0005
    }
    
    let placeCount = placesFound.count
    
    if placeCount > 0 {
      var closestPlace = placesFound[0]
      placesFound.forEach { place in
        if closestPlace.name != place.name {
          if abs(userLocation!.coordinate.latitude - place.locationLat) <= abs(userLocation!.coordinate.latitude - closestPlace.locationLat) &&
              abs(userLocation!.coordinate.longitude - place.locationLng) <= abs(userLocation!.coordinate.longitude - closestPlace.locationLng)
          {
            closestPlace = place
          }
        }
      }
      
      newPlaceAtCurrentLocation = closestPlace
    }
  }
}

class IconImage: ObservableObject {
  @Published var name: String
  
  init(_name: String) {
    name = _name
  }
}

