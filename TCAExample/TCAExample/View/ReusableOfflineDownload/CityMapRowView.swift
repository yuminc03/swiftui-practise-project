//
//  CityMapRowView.swift
//  TCAExample
//
//  Created by Yumin Chu on 2023/10/27.
//

import SwiftUI

import ComposableArchitecture

struct CityMapRowCore: Reducer {
  struct State: Equatable, Identifiable {
    var download: Download
    var downloadAlert: AlertState<DownloadComponent.Action.Alert>?
    var downloadMode: Mode
    var id: UUID {
      return download.id
    }
    
    var downloadComponent: DownloadComponent.State {
      get {
        DownloadComponent.State(
          alert: downloadAlert,
          id: download.id,
          mode: downloadMode,
          url: download.downloadVideoUrl
        )
      }
      set {
        self.downloadAlert = newValue.alert
        self.downloadMode = newValue.mode
      }
    }
    
    struct Download: Equatable, Identifiable {
      var blurb: String
      var downloadVideoUrl: URL
      let id: UUID
      var title: String
    }
  }
  
  enum Action {
    case downloadComponent(DownloadComponent.Action)
  }
  
  struct CityMapEnvironment {
    var downloadClient: DownloadClient
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.downloadComponent, action: /Action.downloadComponent) {
      DownloadComponent()
    }
    Reduce { state, action in
      switch action {
      case .downloadComponent(.downloadClient(.success(.response))):
        return .none
        
      case .downloadComponent(.alert(.presented(.didTapDeleteButton))):
        return .none
        
      case .downloadComponent:
        return .none
      }
    }
  }
}

struct CityMapRowView: View {
  private let store: StoreOf<CityMapRowCore>
  @ObservedObject private var viewStore: ViewStoreOf<CityMapRowCore>
  
  init(store: StoreOf<CityMapRowCore>) {
    self.store = store
    self.viewStore = .init(store, observe: { $0 })
  }
  
  var body: some View {
    HStack {
      NavigationLink {
        CityMapDetailView(store: store)
      } label: {
        HStack {
          Image(systemName: "map")
          Text(viewStore.download.title)
        }
        .layoutPriority(1)
        
        Spacer()
        
        DownloadComponentView(store: store.scope(
          state: \.downloadComponent,
          action: { .downloadComponent($0) }
        ))
        .padding(.trailing, 8)
      }
    }
  }
}

struct CityMapRowView_Previews: PreviewProvider {
  static var previews: some View {
    CitiesView_Previews.previews
  }
}

extension IdentifiedArray where ID == CityMapRowCore.State.ID, Element == CityMapRowCore.State {
  static let mocks: Self = [
    CityMapRowCore.State(
      download: CityMapRowCore.State.Download(
        blurb: """
          New York City (NYC), known colloquially as New York (NY) and officially as the City of \
          New York, is the most populous city in the United States. With an estimated 2018 \
          population of 8,398,748 distributed over about 302.6 square miles (784 km2), New York \
          is also the most densely populated major city in the United States.
          """,
        downloadVideoUrl: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")!,
        id: UUID(),
        title: "New York, NY"
      ),
      downloadMode: .notDownloaded
    ),
    CityMapRowCore.State(
      download: CityMapRowCore.State.Download(
        blurb: """
          Los Angeles, officially the City of Los Angeles and often known by its initials L.A., \
          is the largest city in the U.S. state of California. With an estimated population of \
          nearly four million people, it is the country's second most populous city (after New \
          York City) and the third most populous city in North America (after Mexico City and \
          New York City). Los Angeles is known for its Mediterranean climate, ethnic diversity, \
          Hollywood entertainment industry, and its sprawling metropolis.
          """,
        downloadVideoUrl: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")!,
        id: UUID(),
        title: "Los Angeles, LA"
      ),
      downloadMode: .notDownloaded
    ),
    CityMapRowCore.State(
      download: CityMapRowCore.State.Download(
        blurb: """
          Paris is the capital and most populous city of France, with a population of 2,148,271 \
          residents (official estimate, 1 January 2020) in an area of 105 square kilometres (41 \
          square miles). Since the 17th century, Paris has been one of Europe's major centres of \
          finance, diplomacy, commerce, fashion, science and arts.
          """,
        downloadVideoUrl: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")!,
        id: UUID(),
        title: "Paris, France"
      ),
      downloadMode: .notDownloaded
    ),
    CityMapRowCore.State(
      download: CityMapRowCore.State.Download(
        blurb: """
          Tokyo, officially Tokyo Metropolis (東京都, Tōkyō-to), is the capital of Japan and the \
          most populous of the country's 47 prefectures. Located at the head of Tokyo Bay, the \
          prefecture forms part of the Kantō region on the central Pacific coast of Japan's main \
          island, Honshu. Tokyo is the political, economic, and cultural center of Japan, and \
          houses the seat of the Emperor and the national government.
          """,
        downloadVideoUrl: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")!,
        id: UUID(),
        title: "Tokyo, Japan"
      ),
      downloadMode: .notDownloaded
    ),
    CityMapRowCore.State(
      download: CityMapRowCore.State.Download(
        blurb: """
          Buenos Aires is the capital and largest city of Argentina. The city is located on the \
          western shore of the estuary of the Río de la Plata, on the South American continent's \
          southeastern coast. "Buenos Aires" can be translated as "fair winds" or "good airs", \
          but the former was the meaning intended by the founders in the 16th century, by the \
          use of the original name "Real de Nuestra Señora Santa María del Buen Ayre", named \
          after the Madonna of Bonaria in Sardinia.
          """,
        downloadVideoUrl: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")!,
        id: UUID(),
        title: "Buenos Aires, Argentina"
      ),
      downloadMode: .notDownloaded
    ),
  ]
}