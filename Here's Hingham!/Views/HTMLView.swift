//
//  HTMLView.swift
//  Here's Hingham!
//
//  Created by Cameron Conway on 5/9/25.
//

import SwiftUI

struct HTMLView: UIViewRepresentable {
  var attributedString: NSAttributedString
  
  public var textView = UITextView()
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIView(context: Context) -> UITextView {
//    textView.layer.borderWidth = 0.3
//    textView.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
//    textView.textContainerInset = UIEdgeInsets(top: 5, left: 2, bottom: 2, right: 2)
    textView.backgroundColor = .clear
    textView.isEditable = false
    textView.delegate = context.coordinator

    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    textView.attributedText = attributedString
  }
  
}

class Coordinator: NSObject, UITextViewDelegate {
       
    func textViewDidChangeSelection(_ textView: UITextView) {
       // selectedRange = textView.selectedRange
    }
}

extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return nil }
    do {
      return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
        return nil
    }
  }
  
  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
  
  func CGFloatValue() -> CGFloat? {
    guard let doubleValue = Double(self) else {
      return nil
    }
    
    return CGFloat(doubleValue / 255)
  }
}

