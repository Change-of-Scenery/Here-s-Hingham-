//
//  RatingsView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 7/3/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct RatingsView: View {
  @Binding var place: SchemaV1.Place
  @Binding var showRatingSelector: Bool
  @State var rating: Double = 0.0
  
  var label = "How many stars for"
  var maximumRating: Double = 5.0
  
  var offImage: Image?
  var starImage = Image("Reviews/Star")
  var halfStarImage = Image("Reviews/HalfStar")
  let start = 1.0
  
  var offColor = Color.gray
  var onColor = Color.yellow
  
  var body: some View {
    HStack {
      if label.isEmpty == false {
        Text("\(label) \(place.name)?")
          .font(.system(size: 13))
      }
      
      ForEach(Array(stride(from: 1.0, through: maximumRating, by: 1.0)), id: \.self) { number in
        Button {
          rating = number
        } label: {
          number > rating ? Image("Reviews/GrayStar") : number.truncatingRemainder(dividingBy: 1.0) == 0 ? Image("Reviews/Star") : Image("Reviews/GrayHalfStar")
        }
        .padding(.top, -2)
      }
      Spacer()
      Button {
        place.hinghamReviews += 1
        place.hinghamRatings += place.hinghamRatings == "" ? String(rating) : ";" + String(rating)
        place.updateHinghamRating()
        showRatingSelector = false
        let defaults = UserDefaults.standard
        let db = Firestore.firestore()
        let placeRef = db.collection("HinghamPlace").document(place.documentID)
        placeRef.updateData(["hinghamRatings" : place.hinghamRatings, "hinghamReviews" : place.hinghamReviews])
        defaults.set("true", forKey: "Rated:\(place.documentID)")
      } label: {
        Text("Rate")
          .foregroundStyle(.white)
          .font(.system(size: 13, weight: .bold))
      }
      .buttonStyle(.borderedProminent)
      .tint(.red)
      .padding(.top, -2)
    }
    .padding(.top, -3)
  }
  
  func image(for number: Double) -> Image {
    if number > rating {
      offImage ?? starImage
    } else {
      starImage
    }
  }
}



