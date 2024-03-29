//
//  CounterWithFactFeature.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/08/12.
//

import Foundation

import ComposableArchitecture

struct CounterFeature: Reducer {
    enum CancelID {
        case timer
    }
    
    struct State: Equatable {
        var count = 0
        var isLoading = false
        var factString: String?
        var isTimerRunning = false
    }
    
    enum Action: Equatable {
        case didTapDecrementButton
        case didTapIncrementButton
        case didTapFactButton
        case factResponse(String)
        case didTapTimerButton
        case timerTick
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapDecrementButton:
            state.count -= 1
            state.factString = nil
            return .none
            
        case .didTapIncrementButton:
            state.count += 1
            state.factString = nil
            return .none
            
        case .didTapFactButton:
            state.factString = nil
            state.isLoading = true
            return .run { [count = state.count] send in
                try await send(.factResponse(numberFact.fetch(count)))
            }
            
        case let .factResponse(fact):
            state.factString = fact
            state.isLoading = false
            return .none
            
        case .didTapTimerButton:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }
        
        case .timerTick:
            state.count += 1
            state.factString = nil
            return .none
        }
    }
}
