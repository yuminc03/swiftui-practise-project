//
//  WorldClockCore.swift
//  ClockClone
//
//  Created by Yumin Chu on 2023/09/03.
//

import SwiftUI

import ComposableArchitecture

struct WorldClockCore: Reducer {
  struct State: Equatable {
    var worldClocks = WorldClockItem.dummy
  }
  @Environment(\.editMode) var editMode
  
  enum Action {
    case didTapTabItem
    case onDeleteClock(at: IndexSet)
    case onMoveClock(from: IndexSet, to: Int)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didTapTabItem:
        return .none
        
      case let .onDeleteClock(at: indexSet):
        state.worldClocks.remove(atOffsets: indexSet)
        return .none
        
      case let .onMoveClock(from: indexSet, to: index):
        state.worldClocks.move(fromOffsets: indexSet, toOffset: index)
        return .none
      }
    }
  }
}

struct WorldClockView: View {
  private let store: StoreOf<WorldClockCore>
  @ObservedObject private var viewStore: ViewStoreOf<WorldClockCore>
  
  init() {
    self.store = Store(initialState: WorldClockCore.State()) {
      WorldClockCore()
    }
    self.viewStore = ViewStore(store, observe: { $0 })
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color.black
          .ignoresSafeArea()
        if viewStore.worldClocks.isEmpty {
          Text("세계 시계 없음")
            .font(.largeTitle)
            .foregroundColor(Color("gray_424242"))
        } else {
          List {
            ForEach(0 ..< viewStore.worldClocks.count) { index in
              WorldClockRow(
                worldClockItem: viewStore.worldClocks[index],
                isFirstRow: index == 0,
                isEditMode: false
              )
            }
            .onDelete { store.send(.onDeleteClock(at: $0)) }
            .onMove { store.send(.onMoveClock(from: $0, to: $1)) }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
          .listStyle(.plain)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            print("plus button tapped")
          } label: {
            Image(systemName: "plus")
          }
        }
        if viewStore.worldClocks.isEmpty == false {
          ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
          }
        }
      }
      .foregroundColor(.orange)
      .navigationTitle("세계 시계")
    }
  }
}

struct WorldClockView_Previews: PreviewProvider {
  static var previews: some View {
    WorldClockView()
  }
}
