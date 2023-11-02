//
//  WeatherClient.swift
//  Search
//
//  Created by Yumin Chu on 2023/11/02.
//

import Foundation
import XCTestDynamicOverlay

import ComposableArchitecture

struct WeatherClient {
  let forecast: @Sendable (GeocodingSearch.Result) async throws -> Forecast
  let search: @Sendable (String) async throws -> GeocodingSearch
}

extension DependencyValues {
  var weatherClient: WeatherClient {
    get { self[WeatherClient.self] }
    set { self[WeatherClient.self] = newValue }
  }
}

extension WeatherClient: TestDependencyKey {
  static let previewValue = Self(
    forecast: { _ in .mock },
    search: { _ in .mock }
  )
  static let testValue = Self(
    forecast: unimplemented("\(Self.self).forecast"),
    search: unimplemented("\(Self.self).search")
  )
}

extension WeatherClient: DependencyKey {
  static let liveValue = WeatherClient { result in
    var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
    components.queryItems = [
      URLQueryItem(name: "latitude", value: "\(result.latitude)"),
      URLQueryItem(name: "longitude", value: "\(result.longitude)"),
      URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
      URLQueryItem(name: "timezone", value: TimeZone.autoupdatingCurrent.identifier)
    ]
    let (data, _) = try await URLSession.shared.data(from: components.url!)
    return try jsonDecoder.decode(Forecast.self, from: data)
  } search: { query in
    var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
    components.queryItems = [URLQueryItem(name: "name", value: query)]
    let (data, _) = try await URLSession.shared.data(from: components.url!)
    return try jsonDecoder.decode(GeocodingSearch.self, from: data)
  }
}

private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.dateFormat = "yyyy-MM-dd"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  decoder.dateDecodingStrategy = .formatted(formatter)
  return decoder
}()

struct GeocodingSearch: Decodable, Equatable, Sendable {
  let results: [Result]
  
  struct Result: Decodable, Equatable, Identifiable, Sendable {
    let country: String
    let latitude: Double
    let longitude: Double
    let id: Int
    let name: String
    let admin1: String?
  }
}

struct Forecast: Decodable, Equatable, Sendable {
  let daily: Daily
  let dailyUnits: DailyUnits
  
  struct Daily: Decodable, Equatable, Sendable {
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let time: [Date]
  }
  
  struct DailyUnits: Decodable, Equatable, Sendable {
    let temperatureMax: String
    let temperatureMin: String
  }
}

extension Forecast {
  private enum CodingKeys: String, CodingKey {
    case daily
    case dailyUnits = "daily_units"
  }
}

extension Forecast.Daily {
  private enum CodingKeys: String, CodingKey {
    case temperatureMax = "temperature_2m_max"
    case temperatureMin = "temperature_2m_min"
    case time
  }
}

extension Forecast.DailyUnits {
  private enum CodingKeys: String, CodingKey {
    case temperatureMax = "temperature_2m_man"
    case temperatureMin = "temperature_2m_min"
  }
}

extension GeocodingSearch {
  static let mock = Self(
    results: [
      GeocodingSearch.Result(
        country: "United States",
        latitude: 40.6782,
        longitude: -73.9442,
        id: 1,
        name: "Brooklyn",
        admin1: nil
      ),
      GeocodingSearch.Result(
        country: "United States",
        latitude: 34.0522,
        longitude: -118.2437,
        id: 2,
        name: "Los Angeles",
        admin1: nil
      ),
      GeocodingSearch.Result(
        country: "United States",
        latitude: 37.7749,
        longitude: -122.4194,
        id: 3,
        name: "San Francisco",
        admin1: nil
      )
    ]
  )
}

extension Forecast {
  static let mock = Self(
    daily: Daily(
      temperatureMax: [90, 70, 100],
      temperatureMin: [70, 50, 80],
      time: [0, 86_400, 172_800].map(Date.init(timeIntervalSince1970:))
    ),
    dailyUnits: DailyUnits(temperatureMax: "°F", temperatureMin: "°F")
  )
}
