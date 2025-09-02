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
  let iconResizePercent: Double
  let filter: Int
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    var name = filter > 0 ? placeName : shortName
    let design = type == 6 ? Font.Design.serif : Font.Design.default
    var size = 8.0
    var strokeWidth = 0.75
    var zIndex = 0.0
    let titlePadding = 0.0
    var newIconSize = 0.0
    
    if selected == true {
      size = 9.0
      name = placeName
      strokeWidth = 2.5
      zIndex = 100.0
    }
    
//    if iconSize == 224 {
//      
//    } else {
      newIconSize = iconResizePercent != 0 ? iconSize * iconResizePercent : iconSize
//    }
    
    return ZStack {
      VStack(spacing: 0) {
        Image("\(areaName)/\(placeName)/icon")
          .resizable()
          .scaledToFit()
          .frame(width: newIconSize, height: newIconSize)
          .zIndex(zIndex)
          .opacity(opacity)
        
        Text(name)
          .font(.system(size: size, weight: .regular, design: design))
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
    PlaceAnnotationView(areaName: "Square", placeName: "The Snug", shortName: "Pub", type: 2, iconSize: 64.0, selected: false, opacity: 1.0, iconResizePercent: 0.0, filter: 0)
  }
}
