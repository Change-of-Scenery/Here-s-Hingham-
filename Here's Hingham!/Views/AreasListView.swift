//
//  AreasListView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/29/25.
//

import SwiftUI
import SwiftData

struct AreasListView: View {
  
  @EnvironmentObject private var vm: AreasViewModel
  
  var body: some View {
    List {
      ForEach(vm.areas) { area in
        Button {
          vm.showNextArea(area)
        } label: {
          listRowView(area)
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.clear)
      }
    }
    .listStyle(PlainListStyle())
  }
}

#Preview {
    AreasListView()
      .environmentObject(AreasViewModel())
}

extension AreasListView {
  
  private func listRowView(_ area: SchemaV1.Area) -> some View {
    HStack {
      ZStack {
        Image("\(area.shortName)/Area")
          .resizable()
          .scaledToFill()
          .frame(width: 45, height: 45)
          .cornerRadius(10)
      }
      .padding(1)
      .background(.white)
      .cornerRadius(10)
      .shadow(color: Color.black.opacity(01), radius: 3, x:0, y:2)
      
      VStack(alignment: .leading) {
        Text("\(area.name)")
          .font(.headline)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
}
