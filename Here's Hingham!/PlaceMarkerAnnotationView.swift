//
//  PlaceMarkerAnnotationView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 4/21/25.
//

import MapKit

class PlaceMarkerAnnotationView: MKMarkerAnnotationView {
  var placeName = "Joe's Place"
  var placeAddress = "Main St"
  var googlePlaceId = ""
 
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
  }
  override var annotation: MKAnnotation? {
      willSet {
        titleVisibility = .visible
        displayPriority = .required
      }
  }
}
