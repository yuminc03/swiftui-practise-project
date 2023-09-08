//
//  City.swift
//  ClockClone
//
//  Created by Yumin Chu on 2023/09/04.
//

import Foundation

import ComposableArchitecture

struct City: Equatable, Identifiable {
  let id = UUID()
  let name: String
  
  static let dummy: IdentifiedArrayOf<City> = [
    .init(name: "갈라파고스 제도, 에콰도르"),
    .init(name: "그린 베이, 미국"),
    .init(name: "나폴리, 이탈리아"),
    .init(name: "네이터즈, 스위스"),
    .init(name: "누크, 그린란드"),
    .init(name: "니피곤, 캐나다"),
    .init(name: "더블린, 아일랜드"),
    .init(name: "도하, 카타르"),
    .init(name: "리우데자네이루, 브라질"),
    .init(name: "방콕, 태국")
  ]
}
