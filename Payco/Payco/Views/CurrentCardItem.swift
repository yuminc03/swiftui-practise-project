//
//  CurrentCardItem.swift
//  Payco
//
//  Created by Yumin Chu on 2023/08/28.
//

import SwiftUI

struct CurrentCardItem: View {
  @State private var animationValue: CGFloat = 0
  private let cardItem: CardItem
  private let buttonAction: () -> Void
  
  init(cardItem: CardItem, buttonAction: @escaping () -> Void) {
    self.cardItem = cardItem
    self.buttonAction = buttonAction
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 20) {
        paycoPointText
        cardPoint
        Spacer()
        bankInfoText
      }
      Spacer()
      VStack(spacing: 0) {
        cardImage
        manageCardButton
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 30)
    .frame(height: 220)
    .background {
      RoundedRectangle(cornerRadius: 20)
        .fill(
          LinearGradient(
            colors: [.orange, .pink],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
    }
  }
}

struct CurrentCardItem_Previews: PreviewProvider {
  static var previews: some View {
    CurrentCardItem(cardItem: CardItem.dummy) {
      print("action")
    }
    .previewLayout(.sizeThatFits)
  }
}

extension CurrentCardItem {
  
  var paycoPointText: some View {
    Text(cardItem.topLeadingTitle)
      .font(.title3)
      .fontWeight(.semibold)
      .foregroundColor(.white)
  }
  
  var cardPoint: some View {
    HStack(spacing: 10) {
      Text("\(cardItem.point) P")
        .font(.largeTitle)
      Image(systemName: "chevron.right")
        .font(.title3)
    }
    .fontWeight(.semibold)
    .foregroundColor(.white)
  }
  
  var bankInfoText: some View {
    Text("\(cardItem.bankName) (\(cardItem.accountNumber))")
      .underline(color: .white)
      .foregroundColor(.white)
      .font(.body)
      .fontWeight(.light)
  }
  
  var cardImage: some View {
    Image("card")
      .resizable()
      .scaledToFit()
      .frame(height: 150)
      .offset(x: -10, y: -30)
      .rotation3DEffect(
        .degrees(-animationValue),
        axis: (x: -animationValue, y: animationValue, z: animationValue)
      )
      .onAppear {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
          animationValue = 15
        }
      }
  }
  
  var manageCardButton: some View {
    Button(cardItem.buttonTitle) {
      buttonAction()
    }
    .foregroundColor(.white)
    .padding()
    .background(Color.white.opacity(0.2))
    .cornerRadius(15)
    .offset(x: 10, y: -20)
  }
}
