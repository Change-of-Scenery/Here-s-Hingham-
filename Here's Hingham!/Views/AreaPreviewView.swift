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
  let area: SchemaV1.Area
  let screenWidth = UIScreen.main.bounds.size.width
  
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 0) {
        imageSection
        learnMoreButton
        nextButton
      }
      .padding(10)
      .padding([.leading, .trailing], 10)
      .cornerRadius(10)
      HStack (alignment: .top) {
        titleSection
          .padding(.top, -10)
          .padding(.bottom, 15)
          .padding([.leading], 20)
          .padding([.trailing], 15)
          .frame(height: 100)
      }
    }
    .frame(height: 200)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(colorScheme == .dark ? Color(red: 0.12, green: 0.0,  blue: 0.0) : Color(red: 0.99, green: 0.99,  blue: 0.9))  // .ultraThinMaterial
        .offset(y: 22)
    )
  }
}

struct AreaPreviewView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.green.ignoresSafeArea()
      AreaPreviewView(area: AreasViewModel().previewArea)
        .padding()
    }
    .environmentObject(AreasViewModel())
  }
}

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
      Image(areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.shortName + "/Area/0" : "\(area.shortName)/\(placesViewModel.mapPlace.name)/0")
        .resizable()
        .scaledToFill()
        .frame(width: UIScreen.main.bounds.size.height < 900 ? 100.0 : 140)
        .cornerRadius(10)
        .onTapGesture {
          areasViewModel.sheetArea = area
          areasViewModel.mapArea = area
        }
    }
    .padding(6)
    .background(.accent.opacity(0.75))
    .cornerRadius(10)
    .shadow(color: .black.opacity(0.75), radius: 4, x: 3, y: 3)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.name : placesViewModel.mapPlace.name)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.primary)
        .scaledToFill()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      
      Text(areasViewModel.visible == true || placesViewModel.mapPlace.name == "" ? area.desc : placesViewModel.mapPlace.notes)
        .font(.system(size: 14))
        .foregroundColor(.primary)
    }
    .frame(width: screenWidth * 0.9, height: 100)
    .padding(.trailing, 10)
    .padding(.top, screenWidth < 360 ? -5 : 10)
  }
  
  private var learnMoreButton: some View {
    Button {
//      areasViewModel.sheetArea = area
//      areasViewModel.mapArea = area
      withAnimation(.easeInOut) {
        let span = MKCoordinateSpan(latitudeDelta: area.zoom, longitudeDelta:  area.zoom)
        areasViewModel.mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: area.centerCoordinates, span: span))
        areasViewModel.visible = false
      }
    } label: {
      Text(areasViewModel.visible == true ? "Take me there!" : "Show Details")
        .font(.headline)
        .frame(width: screenWidth < 360 ? 90 : 120, height: 35)
        .foregroundColor(.white)
    }
    .buttonStyle(.borderedProminent)
    .background(.accent)
    .cornerRadius(10.0)
    .padding([.leading, .trailing], screenWidth < 360 ? 7 : 25)
    .padding(.top, UIScreen.main.bounds.size.height < 900 ? 32.0 : 42.0)
  }
  
  private var nextButton: some View {
    HStack {
      Button {
        areasViewModel.nextButtonPressed()
      } label: {
        Text("Next")
          .font(.headline)
          .frame(width: screenWidth < 360 ? 40 : 50, height: 35)
      }
      .buttonStyle(.bordered)
      .padding(.top, UIScreen.main.bounds.size.height < 900 ? 32.0 : 42.0)
    }
  }
}

#Preview {
  AreaPreviewView(area: AreasViewModel().areas.first!)
}
