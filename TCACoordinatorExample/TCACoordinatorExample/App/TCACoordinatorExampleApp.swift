//
//  TCACoordinatorExampleApp.swift
//  TCACoordinatorExample
//
//  Created by LS-NOTE-00106 on 6/19/24.
//

import SwiftUI

@main
struct TCACoordinatorExampleApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: AppCore.State(main: .initialState, appState: .main)) {
        AppCore()
      })
    }
  }
}
