//
//  RootView.swift
//  DesignSystem
//
//  Created by Yumin Chu on 2023/09/10.
//

import SwiftUI

enum PopupItem {
  case treatmentAlert
  case changeConfirm
  case descriptionAlert
  
  enum PopupType {
    case alert
    case confirm
  }
  
  var title: String {
    switch self {
    case .treatmentAlert:
      return "진료안내"
      
    case .changeConfirm:
      return "안내"
      
    case .descriptionAlert:
      return "배송선택"
    }
  }
  
  var contents: String {
    switch self {
    case .treatmentAlert:
      return "설정중이던 진료조건을 임시저장할까요?"
      
    case .changeConfirm:
      return "진료과목을 변경하시면 선생님을\n다시 선택하고 예약을 진행하셔야 합니다\n그래도 변경하시겠습니까?"
      
    case .descriptionAlert:
      return "약 수령방법을\n당일배송으로 선택하시겠습니까?"
    }
  }
  
  var description: String {
    switch self {
    case .treatmentAlert:
      return ""
      
    case .changeConfirm:
      return ""
      
    case .descriptionAlert:
      return "약 3시간 이내 배송"
    }
  }
  
  var primaryButtonTitle: String {
    switch self {
    case .treatmentAlert:
      return "취소"
      
    case .changeConfirm:
      return "확인"
      
    case .descriptionAlert:
      return "취소"
    }
  }
  
  var secondaryButtonTitle: String {
    switch self {
    case .treatmentAlert:
      return "확인"
      
    case .changeConfirm:
      return ""
      
    case .descriptionAlert:
      return "확인"
    }
  }
  
  var popupType: PopupType {
    switch self {
    case .treatmentAlert:
      return .alert
      
    case .changeConfirm:
      return .confirm
      
    case .descriptionAlert:
      return .alert
    }
  }
}

struct RootView: View {
  /// Alert Item으로 개선!
  @State var alertItem: PopupItem?
  @State private var sampleText = ""
  
  var body: some View {
    VStack(spacing: 20) {
      VStack(spacing: 10) {
        PrimaryButton {
          
        }
        HStack(spacing: 10) {
          PrimaryButton {
            
          }
          PrimaryButton {
            
          }
          .disabled(sampleText.isEmpty)
        }
        PrimaryButton {
          
        }
      }
      .padding(.bottom, 50)
      showPopupButton(title: "Alert 보이기") {
        alertItem = .treatmentAlert
      }
      showPopupButton(title: "Confirm 보이기") {
        alertItem = .changeConfirm
      }
      showPopupButton(title: "추가 설명이 있는 Alert 보이기") {
        alertItem = .descriptionAlert
      }
    }
    .padding(.horizontal, 20)
    .customAlert(item: $alertItem) {
      alertItem = nil
    } secondaryButtonAction: {
      alertItem = nil
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}

extension RootView {
  
  private func showPopupButton(
    title: String,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .customButtonStyle(backgroundColor: Color("green_07D329"))
        .foregroundColor(.white)
    }
  }
}
