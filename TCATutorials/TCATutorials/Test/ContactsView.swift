//
//  ContactsView.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 2023/08/21.
//

import SwiftUI

import ComposableArchitecture

struct ContactsView: View {
    
    private let store: StoreOf<ContactsReducer>
    @ObservedObject private var viewStore: ViewStoreOf<ContactsReducer>
    
    init() {
        self.store = Store(initialState: ContactsReducer.State(
            contacts: [
                Contact(id: UUID(), name: "Kaila"),
                Contact(id: UUID(), name: "Emily"),
                Contact(id: UUID(), name: "Lonalia")
            ]
        )) {
            ContactsReducer()
        }
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            List {
                ForEach(viewStore.state.contacts) { contact in
                    NavigationLink(state: ContactDetailPageReducer.State(contact: contact)) {
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button {
                                viewStore.send(.didTapDeleteButton(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.didTapAddButton)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } destination: { store in
            ContactDetailPageView(store: store)
        }
        .sheet(
            store: store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /ContactsReducer.Destination.State.addContact,
            action: ContactsReducer.Destination.Action.addContact
        ) { addStore in
            NavigationStack {
                ContactView(store: addStore)
            }
        }
        .alert(
            store: store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /ContactsReducer.Destination.State.alert,
            action: ContactsReducer.Destination.Action.alert
        )
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
