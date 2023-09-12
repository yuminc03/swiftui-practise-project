//
//  PrimaryButtonModifier.swift
//  DesignSystem
//
//  Created by Yumin Chu on 2023/09/11.
//

import SwiftUI

struct CustomButtonModifier: ViewModifier {
  let backgroundColor: Color
  let foregroundColor: Color
  let titleFont: Font
  
  func body(content: Content) -> some View {
    content
      .foregroundColor(foregroundColor)
      .font(titleFont)
      .padding(.vertical, 20)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .cornerRadius(10)
  }
}

extension View {
  func customButtonStyle(
    backgroundColor: Color,
    foregroundColor: Color = .white,
    titleFont: Font = .headline
  ) -> some View {
    modifier(CustomButtonModifier(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleFont: titleFont
    ))
  }
}
