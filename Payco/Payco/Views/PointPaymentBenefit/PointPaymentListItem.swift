//
//  PointPaymentListItem.swift
//  Payco
//
//  Created by Yumin Chu on 2023/08/27.
//

import SwiftUI

struct PointPaymentListItem: View {
  
  let topTitle: String
  let bottomTitle: String
  let imageName: String
  
  var body: some View {
    HStack(spacing: 20) {
      Image(imageName)
        .resizable()
        .frame(width: 60, height: 60)
        .clipShape(Circle())
      VStack(alignment: .leading, spacing: 3) {
        Text(topTitle)
          .font(.subheadline)
        Text(bottomTitle)
          .font(.title2)
          .bold()
      }
      Spacer()
      Image(systemName: "chevron.right")
        .font(.body)
        .foregroundColor(.gray)
    }
  }
}

struct PointPaymentListItem_Previews: PreviewProvider {
  static var previews: some View {
    PointPaymentListItem(
      topTitle: "네이처컬렉션 결제 시",
      bottomTitle: "5,000원 즉시 할인",
      imageName: "swift"
    )
      .previewLayout(.sizeThatFits)
  }
}
