//
//  ClockCloneApp.swift
//  ClockClone
//
//  Created by Yumin Chu on 2023/09/03.
//

import SwiftUI

import ComposableArchitecture

struct ClockCloneCore: Reducer {
  struct State: Equatable {
    var selectedTabIndex = 0
  }
  
  enum Action {
    case didTapTabItem(Int)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .didTapTabItem(index):
      state.selectedTabIndex = index
      return .none
    }
  }
}

@main
struct ClockCloneApp: App {
  
  private let store: StoreOf<ClockCloneCore>
  @ObservedObject var viewStore: ViewStoreOf<ClockCloneCore>
  
  init() {
    self.store = Store(initialState: ClockCloneCore.State()) {
      ClockCloneCore()
        ._printChanges()
    }
    self.viewStore = ViewStore(store, observe: { $0 })
    UITabBar.appearance().unselectedItemTintColor = UIColor(named: "gray_C7C7C7")
  }
  
  var body: some Scene {
    WindowGroup {
      tabView
    }
  }
}

struct ClockCloneApp_Previews: PreviewProvider {
  static var previews: some View {
    ClockCloneApp().tabView
  }
}

extension ClockCloneApp {
  
  var tabView: some View {
    NavigationStack {
      TabView(selection: viewStore.binding(get: \.selectedTabIndex, send: { .didTapTabItem($0) })) {
        WorldClockView()
          .tabItem {
            Image(systemName: TabItem.worldClock.imageName)
            Text(TabItem.worldClock.label)
          }
          .tag(0)
        
        AlarmView()
          .tabItem {
            Image(systemName: TabItem.alarm.imageName)
            Text(TabItem.alarm.label)
          }
          .tag(1)
        
        StopWatchView()
          .tabItem {
            Image(systemName: TabItem.stopWatch.imageName)
            Text(TabItem.stopWatch.label)
          }
          .tag(2)
        
        TimerView()
          .tabItem {
            Image(systemName: TabItem.timer.imageName)
            Text(TabItem.timer.label)
          }
          .tag(3)
      }
      .navigationTitle(viewStore.selectedTabIndex == 0 ? "세계 시계" : "")
      .toolbar(viewStore.selectedTabIndex == 0 ? .visible : .hidden, for: .navigationBar)
    }
    .tint(.orange)
  }
}
