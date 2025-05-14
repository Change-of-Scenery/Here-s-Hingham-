//
//  AreaPreviewView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/30/25.
//

import SwiftUI

struct AreaPreviewView: View {
  @EnvironmentObject private var areasViewModel: AreasViewModel
  let area: SchemaV1.Area
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 0) {
      VStack(alignment: .leading, spacing: 16) {
        imageSection
        titleSection
      }
      .frame(width: nil, height: 225)
      VStack {
        learnMoreButton
        nextButton
      }
      .frame(width: nil, height: 225)
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(.ultraThinMaterial)
        .offset(y: 65)
    )
    .cornerRadius(10)
  }
}

struct AreaPreviewView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.green.ignoresSafeArea()
      AreaPreviewView(area: AreasViewModel().areas.first!)
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
    }
    .padding(6)
    .background(.white)
    .cornerRadius(10)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(area.name)
        .font(.title2)
        .fontWeight(.bold)
        .scaledToFill()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      
      Text(area.desc)
        .font(.custom("System", size: 14))
        .truncationMode(.tail)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding([.trailing], 10)
  }
  
  private var learnMoreButton: some View {
    Button {
      areasViewModel.sheetArea = area
    } label: {
      Text("Learn more")
        .font(.headline)
        .frame(width: 125, height: 35)
    }
    .buttonStyle(.borderedProminent)
  }
  
  private var nextButton: some View {
    Button {
      areasViewModel.nextButtonPressed()
    } label: {
      Text("Next")
        .font(.headline)
        .frame(width: 125, height: 35)
    }
    .buttonStyle(.bordered)
  }
}

#Preview {
  AreaPreviewView(area: AreasViewModel().areas.first!)
}
