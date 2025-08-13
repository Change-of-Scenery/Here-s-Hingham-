//
//  AreaAnnotationView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/2/25.
//

import SwiftUI

struct AreaAnnotationView: View {
  var title: String
  let selected: Bool
  let opacity: Double
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    var strokeWidth = 0.75
    var font = Font.system(size: 14)
    var zIndex = -100.0
    var weight = Font.Weight.medium
    let titlePadding = 0.0
    
    if selected == true {
      font = Font.system(size: 12)
      strokeWidth = 2
      zIndex = 100.0
      weight = Font.Weight.semibold
    }
    
    return VStack(spacing: 0) {
      Image(systemName: "map.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30)
        .foregroundColor(.white.opacity(0.95))
        .padding(6)
        .background(.accent)
        .cornerRadius(36)
        .zIndex(zIndex)
        .opacity(opacity)
      Text(title)
        .font(font)
        .foregroundStyle(.primary.opacity(0.75))
        .fontWeight(weight)
        .padding(.top, titlePadding)
        .customStroke(color: colorScheme == .dark ? .clear : .white, width: strokeWidth)
        .zIndex(zIndex)
        .opacity(opacity)
    }
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    AreaAnnotationView(title: "Hingham Square", selected: false, opacity: 1.0)
  }
}
