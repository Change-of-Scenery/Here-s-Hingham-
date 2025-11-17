
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
  @State private var cameraIsChanging = false
  @ObservedObject var location: LocationManager = LocationManager()
  let maxWidth: CGFloat = 475
  let maxHeight: CGFloat = 250
  @State private var showPreviewView = true
  
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
                FilterButtonView(title: "\"Bucket List\"", imageName: "bucket", type: 11)
//                FilterButtonView(title: "Update Yelp", imageName: "gear", type: 100)
//                FilterButtonView(title: "Update Google", imageName: "gear", type: 100)
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
          if areasViewModel.firstScreenVisible == false {
            Button {
              if showPlaceDetail == true {
                showPlaceDetail = false
                withAnimation(.easeInOut) {
                  areasViewModel.visible = false
                }
              } else {
                placesViewModel.visible = false
                areasViewModel.visible = true
                areasViewModel.distance = 0.0
                areasViewModel.firstScreenVisible = true
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
        if type == 11 {
          Image(imageName)
        } else {
          Image(systemName: imageName)
        }
        
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
  private var areaMapLayer: some View {
    Map(initialPosition: position) {
      ForEach(areasViewModel.areas) { area in
        Annotation(area.name, coordinate: area.coordinates) {
          AreaAnnotationView(area: area, selected: areasViewModel.mapArea == area, opacity: annotationOpacity)
            .scaleEffect(areasViewModel.mapArea == area ? 1.2 : 0.7)
            .shadow(radius: 10)
            .onTapGesture {
              showPreviewView = true
              iconResizePercent = 0.0
              areasViewModel.firstScreenVisible = false
              areasViewModel.firstScreenVisible = false
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
    var places = placesViewModel.places // .filter { $0.areaId == area.areaId || $0.areaId == 7}
        
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

    let latDeltaHalf = areasViewModel.mapCameraPosition.region!.span.latitudeDelta / 2
    let lngDeltaHalf = areasViewModel.mapCameraPosition.region!.span.longitudeDelta / 2
    let lat = areasViewModel.mapCameraPosition.region!.center.latitude
    let lng = areasViewModel.mapCameraPosition.region!.center.longitude
    
    places = places.filter { $0.locationLat > lat - latDeltaHalf && $0.locationLat < lat + latDeltaHalf && $0.locationLat > lng - lngDeltaHalf && $0.locationLng < lng + lngDeltaHalf }   
   
    return ZStack {
      MapReader { proxy in
        Map(position: $areasViewModel.mapCameraPosition) {
          if latDeltaHalf < 0.02 {
            ForEach(places) { place in
              Annotation("", coordinate: place.coordinates) {
                withAnimation(.easeInOut) {
                  PlaceAnnotationView(areaName: place.areaName, placeName: place.name, shortName: place.shortName, type: place.type, iconSize: place.iconSize, selected: place.selected, opacity: annotationOpacity, iconResizePercent: iconResizePercent, filter: areasViewModel.filter)
                    .shadow(radius: 10)
                    .onTapGesture {
                      showPreviewView = true
                      withAnimation(.easeInOut) {
                        placesViewModel.showPlace(area, place)
                        areasViewModel.visible = false
                      }
                    }
                }
              }
              .annotationTitles(.visible)
            }
          }
          
          UserAnnotation()
        }
        .ignoresSafeArea()
        .onMapCameraChange(frequency: .onEnd) { context in
          cameraIsChanging = false
        }
        .onMapCameraChange(frequency: .continuous) { context in
          let distanceDelta = areasViewModel.distance - context.camera.distance
          cameraIsChanging = true
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
            let span = MKCoordinateSpan(latitudeDelta: areasViewModel.zoom, longitudeDelta: areasViewModel.zoom)
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
//                        isLookAroundUnavailable = true
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
        if areasViewModel.mapArea == area && showPreviewView == true {
          AreaPreviewView(iconResizePercent: $iconResizePercent, showPlaceDetail: $showPlaceDetail, area: area)
            .shadow(color: .black.opacity(0.3), radius: 20)
            .padding()
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .transition(.asymmetric(insertion: .move(edge: .trailing) , removal: .move(edge: .leading)))
          Button {
            showPreviewView = false
          }
          label: {
            Image(systemName: "xmark")
          }
          .padding(.top, maxHeight - 8)
          .padding(.leading, maxWidth - (UIDevice.current.userInterfaceIdiom == .pad ? 90.0: 95.0))
        }
      }
    }
    .padding(.bottom, 40)
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
    
    let placesFound = placesViewModel.places.filter {   // $0.areaId == areaId &&
      return userLocation!.coordinate.latitude > $0.locationLat - 0.0005 &&
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

