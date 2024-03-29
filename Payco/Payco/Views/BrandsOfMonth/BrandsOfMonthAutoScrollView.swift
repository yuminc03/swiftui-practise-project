//
//  BrandsOfMonthAutoScrollView.swift
//  Payco
//
//  Created by Yumin Chu on 2023/08/28.
//

import SwiftUI

struct BrandsOfMonthAutoScrollView: View {
  @State private var xOffset: CGFloat = 0
  @State private var selectedIndex = 18
  private let topTitle: String
  private let bottomTitle: String
  private let rightButtonTitle: String
  private var imageNames: [BrandOfMonthItem]
  private let action: () -> Void
  
  init(
    topTitle: String,
    bottomTitle: String,
    rightButtonTitle: String,
    imageNames: [BrandOfMonthItem],
    action: @escaping () -> Void
  ) {
    self.topTitle = topTitle
    self.bottomTitle = bottomTitle
    self.rightButtonTitle = rightButtonTitle
    self.imageNames = imageNames
    self.action = action
  }
  
  var body: some View {
    VStack(spacing: 5) {
      VStack(alignment: .leading, spacing: -5) {
        HStack(alignment: .firstTextBaseline) {
          topTitleText
          Spacer()
          rightButton
        }
        bottomTitleText
      }
      .padding(.horizontal, 20)
      contentsView
    }
    .padding(.vertical, 30)
    .roundedGrayBackground(padding: 0)
  }
}

struct BrandsOfMonthAutoScrollView_Previews: PreviewProvider {
  static var previews: some View {
    BrandsOfMonthAutoScrollView(
      topTitle: "이달의 브랜드",
      bottomTitle: "최대 15% 적립",
      rightButtonTitle: "보러가기",
      imageNames: BrandOfMonthItem.dummy + BrandOfMonthItem.dummy + BrandOfMonthItem.dummy
    ) {
      print("Action")
    }
    .previewLayout(.sizeThatFits)
  }
}

extension BrandsOfMonthAutoScrollView {
  
  var topTitleText: some View {
    Text(topTitle)
      .foregroundColor(.black)
      .font(.title3)
      .fontWeight(.bold)
  }
  
  var bottomTitleText: some View {
    Text(bottomTitle)
      .foregroundColor(.red)
      .font(.title3)
      .fontWeight(.bold)
  }
  
  var rightButton: some View {
    Button(rightButtonTitle) {
      action()
    }
    .font(.footnote)
    .foregroundColor(.black)
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .background(Color("gray_D8D8D8"))
    .cornerRadius(8)
  }
  
  var contentsView: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .center, spacing: 10) {
          ForEach(0 ..< imageNames.count, id: \.self) { index in
            VStack(spacing: 2) {
              if index % 8 == 0 {
                BlackComment(type: .new)
              } else if index % 10 == 0 {
                BlackComment(type: .hot)
              } else {
                BlackComment(type: .none)
              }
              Image(systemName: imageNames[index].imageName)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(35)
                .foregroundColor(imageNames[index].imageColor)
                .id(index)
            }
          }
        }
        .offset(x: xOffset, y: 0)
      }
      .scrollDisabled(true)
      .onAppear {
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
          xOffset = -960
        }
      }
      .gesture(
        DragGesture()
          .onEnded { value in
            if value.translation.width < 0 {
              if selectedIndex < imageNames.count - 4 {
                selectedIndex += 3
                withAnimation {
                  proxy.scrollTo(selectedIndex, anchor: .bottom)
                }
              } else {
                selectedIndex = 18
                proxy.scrollTo(selectedIndex, anchor: .bottom)
              }
            } else {
              if selectedIndex > 0 {
                selectedIndex -= 5
                withAnimation {
                  proxy.scrollTo(selectedIndex, anchor: .bottom)
                }
              } else {
                selectedIndex = 18
                proxy.scrollTo(selectedIndex, anchor: .bottom)
              }
            }
          }
      )
    }
  }
}
