//
//  AreaPreviewView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/30/25.
//

import SwiftUI

struct AreaPreviewView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  @Environment(\.colorScheme) var colorScheme
  let area: SchemaV1.Area
  
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

extension AreaPreviewView {
  private var imageSection: some View {
    ZStack {
      Image(area.shortName + "/Area/0")
        .resizable()
        .scaledToFill()
        .frame(width: 100, height: 100)
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
      Text(area.name)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.primary)
        .scaledToFill()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      
      Text(area.desc)
        .font(.system(size: 14))
        .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding([.trailing], 10)
  }
  
  private var learnMoreButton: some View {
    Button {
      areasViewModel.sheetArea = area
      areasViewModel.mapArea = area
    } label: {
      Text("Learn more")
        .font(.headline)
        .frame(width: 100, height: 35)
        .foregroundColor(.white)
    }
    .buttonStyle(.borderedProminent)
    .background(.accent)
    .cornerRadius(10.0)
    .padding()
    .padding(.top, 28)
  }
  
  private var nextButton: some View {
    HStack {
      Button {
        areasViewModel.nextButtonPressed()
      } label: {
        Text("Next")
          .font(.headline)
          .frame(width: 50, height: 35)
      }
      .buttonStyle(.bordered)
      .padding(.top, 43)
    }
  }
}

#Preview {
  AreaPreviewView(area: AreasViewModel().areas.first!)
}
