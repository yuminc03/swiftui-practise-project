//
//  RootView.swift
//  TCAExample
//
//  Created by Yumin Chu on 2023/10/10.
//

import SwiftUI

import ComposableArchitecture

struct RootView: View {
  @State var isNavigationStackCaseStudyPresented = false
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          NavigationLink {
            CounterDemoView()
          } label: {
            Text("Basics - Counter")
          }
          
          NavigationLink {
            TwoCountersView()
          } label: {
            Text("Combining reducers - Two Counters")
          }
          
          NavigationLink {
            BindingBasicsView()
          } label: {
            Text("Bindings - Binding Basics")
          }
          
          NavigationLink {
            BindingFormView()
          } label: {
            Text("Form binding - Binding form")
          }
          
          NavigationLink {
            OptionalBasicsView()
          } label: {
            Text("Optional state - Toggle counter state")
          }

          NavigationLink {
            SharedStateView()
          } label: {
            Text("Shared state - Two States")
          }
          
          NavigationLink {
            AlertAndConfirmationDialogView()
          } label: {
              Text("Alerts and Confirmation Dialogs - Increase & Decrease count")
          }
          
          NavigationLink {
            FocusDemoView()
          } label: {
            Text("Focus State - Focused TextField")
          }
          
          NavigationLink {
            AnimationsView()
          } label: {
            Text("Animation - Spring Ball")
          }
        } header: {
          Text("Getting started")
        }
        
        Section {
          NavigationLink {
            EffectBasicsView()
          } label: {
            Text("Basics - Number Fact")
          }
          
          NavigationLink {
            EffectsCancellationView()
          } label: {
            Text("Cancellation - Stepper Number Fact")
          }
          
          NavigationLink {
            LongLivingEffectsView()
          } label: {
            Text("Long-living effects - Screenshot")
          }
          
          NavigationLink {
            RefreshableView()
          } label: {
            Text("Refreshable - Refresh Counter")
          }
          
          NavigationLink {
            TimersView()
          } label: {
            Text("Timers - Rainbow Alalog Clock")
          }
          
          NavigationLink {
            WebSocketView()
          } label: {
            Text("Web socket - Send Message")
          }
        } header: {
          Text("Effects")
        }

        Section {
          Button("Stack") {
            isNavigationStackCaseStudyPresented = true
          }
          .buttonStyle(.plain)
          
          NavigationLink {
            NavigateAndLoadView()
          } label: {
            Text("Navigate and load data")
          }
          
          NavigationLink {
            NavigateAndLoadListView()
          } label: {
            Text("Lists: Navigate and load data")
          }
          
          NavigationLink {
            PresentAndLoadView()
          } label: {
            Text("Sheets: Present and load data")
          }
          
          NavigationLink {
            LoadThenPresentView()
          } label: {
            Text("Sheets: Load data then present")
          }
          
          NavigationLink {
            MultipleDestinationsView()
          } label: {
            Text("Multiple destinations")
          }
        } header: {
          Text("Stack")
        }
        
        Section {
          NavigationLink {
            EpisodesView()
          } label: {
            Text("Reusable favoriting component - Click Heart")
          }
          
          NavigationLink {
            CitiesView()
          } label: {
            Text("Reusable offline download component - Map Data")
          }
          
          NavigationLink {
            NestedView(store: .init(initialState: .mock) {
              NestedCore()
            })
          } label: {
            Text("Recursive state and actions - Custom NavigationTitle")
          }
        } header: {
          Text("Higher-order reducers")
        }
      }
      .navigationTitle("SwiftUI TCA")
      .sheet(isPresented: $isNavigationStackCaseStudyPresented) {
        NavigationDemoView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
