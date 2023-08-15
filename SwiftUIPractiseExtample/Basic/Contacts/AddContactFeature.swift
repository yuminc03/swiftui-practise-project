//
//  AddContactFeature.swift
//  ContactsTCATutorials
//
//  Created by Yumin Chu on 2023/08/13.
//

import Foundation

import ComposableArchitecture

struct AddContactFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case didTapCancelButton
        case didTapSaveButton
        case setName(String)
        case delegate(Delegate)
    }
    
    enum Delegate: Equatable {
//        case cancel
        case saveContact(Contact)
    }
    @Dependency(\.dismiss) var dismiss
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapCancelButton:
            return .run { _ in
                await dismiss()
            }
            
        case .didTapSaveButton:
            return .run { [contact = state.contact] send in
                await send(.delegate(.saveContact(contact)))
                await dismiss()
            }
            
        case let .setName(name):
            state.contact.name = name
            return .none
            
        case .delegate:
            return .none
        }
    }
}
