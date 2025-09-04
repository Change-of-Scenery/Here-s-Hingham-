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
  
  var label = "How many stars?"
  var maximumRating: Double = 5.0
  
  var offImage: Image?
  var starImage = Image("Reviews/StarRater")
  var halfStarImage = Image("Reviews/HalfStarRater")
  let start = 1.0
  
  var offColor = Color.gray
  var onColor = Color.yellow
  
  var body: some View {
    HStack {
      if label.isEmpty == false {
        Text(label)
          .font(.system(size: 12))
      }
      
      ForEach(Array(stride(from: 1.0, through: maximumRating, by: 1.0)), id: \.self) { number in
        Button {
          rating = number
        } label: {
          number > rating ? Image("Reviews/GrayStarRater") : number.truncatingRemainder(dividingBy: 1.0) == 0 ? Image("Reviews/StarRater") : Image("Reviews/GrayHalfStarRater")
        }
        .padding(-2)
      }
      Spacer()
      Button {
        if rating > 0 {
          place.hinghamReviews += 1
          place.hinghamRatings += place.hinghamRatings == "" ? String(rating) : ";" + String(rating)
          place.updateHinghamRating()
          let defaults = UserDefaults.standard
          let db = Firestore.firestore()
          let placeRef = db.collection("HinghamPlace").document(place.documentID)
          placeRef.updateData(["hinghamRatings" : place.hinghamRatings, "hinghamReviews" : place.hinghamReviews])
          defaults.set("true", forKey: "Rated:\(place.documentID)")
        }
        showRatingSelector = false
      } label: {
        Text("Rate")
          .foregroundStyle(.white)
          .font(.system(size: 13, weight: .bold))
      }
      .buttonStyle(.borderedProminent)
      .tint(.red)
      .padding(.top, 1)
      Button {
        showRatingSelector = false
      } label: {
        Image(systemName: "x.square.fill")
          .font(.system(size: 32))
          .tint(.red)
          .cornerRadius(25)
      }
    }
    .frame(width: UIScreen.main.bounds.size.width * 0.93, height: 11)
    .padding(.bottom, 5)
  }
  
  func image(for number: Double) -> Image {
    if number > rating {
      offImage ?? starImage
    } else {
      starImage
    }
  }
}



