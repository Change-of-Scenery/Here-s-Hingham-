//
//  AreaAnnotationView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI

struct PlaceAnnotationView: View {
  let areaName: String
  let placeName: String
  let shortName: String
  let type: Int
  let iconSize: CGFloat
  let selected: Bool
  let opacity: Double
  @Environment(\.colorScheme) var colorScheme

  // let accentColor = Color("AccentColor")
  
  var body: some View {
//    var size = 64.0
    var name = shortName
    var font = Font.system(size: 8)
    var strokeWidth = 0.75
    var zIndex = 0.0
    let titlePadding = 0.0
    
//    if (shortName == "Bank" && placeName != "Eastern Bank") || placeName == "Hawkes Fearing" || shortName == "Library" {
//      size = 156.0
//      titlePadding = -30.0
//    } else if shortName == "Church" {
//      size = 121.0
//    } else if shortName == "Old Derby" || shortName == "Paint"  || shortName == "Tree" {
//      size = 110.0
//    } else if placeName == "La Petite Maison" || placeName == "Square Cafe" || shortName == "Lawyer" {
//      size = 86.0
//    } else if type == 6 {
//      size = 72.0
//    }
    
    if selected == true {
      name = placeName
      font = Font.system(size: 9)
      strokeWidth = 2.5
      zIndex = 100.0
    }
    
    return ZStack {
      VStack(spacing: 0) {
        Image("\(areaName)/\(placeName)/icon")
          .resizable()
          .scaledToFit()
          .frame(width: iconSize, height: iconSize)
          .zIndex(zIndex)
          .opacity(opacity)
        
        Text(name)
          .font(font)
          .customStroke(color: colorScheme == .dark ? .clear : .white, width: strokeWidth)
          .padding(.top, titlePadding)
          .opacity(opacity)
      }
      .zIndex(zIndex)
    }
  }
}

struct StrokeModifier: ViewModifier {
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue

    func body(content: Content) -> some View {
        content
            .padding(strokeSize)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask(outline(context: content))
            )
    }

    private func outline(context: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
              if let text = context.resolveSymbol(id: 0) {
                layer.draw(text, at: CGPoint(x: size.width / 2, y: size.height / 2))
              }
            }
        } symbols: {
            context.tag(0).blur(radius: strokeSize)
        }
    }
}

extension View {
    func customStroke(color: Color, width: CGFloat) -> some View {
        self.modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    PlaceAnnotationView(areaName: "Square", placeName: "The Snug", shortName: "Pub", type: 2, iconSize: 64.0, selected: false, opacity: 1.0)
  }
}
