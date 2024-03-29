//
//  WebSocketClient.swift
//  TCAExample
//
//  Created by Yumin Chu on 2023/10/25.
//

import Foundation

import ComposableArchitecture

struct WebSocketClient {
  struct ID: Hashable, @unchecked Sendable {
    let rawValue: AnyHashable
    
    init<RawValue: Hashable & Sendable>(_ rawValue: RawValue) {
      self.rawValue = rawValue
    }
    
    init() {
      struct RawValue: Hashable, Sendable { }
      self.rawValue = RawValue()
    }
  }
  
  enum Action: Equatable {
    case didOpen(protocol: String?)
    case didClose(code: URLSessionWebSocketTask.CloseCode, reason: Data?)
  }
  
  enum Message: Equatable {
    struct Unknown: Error { }
    
    case data(Data)
    case string(String)
    
    init(_ message: URLSessionWebSocketTask.Message) throws {
      switch message {
      case let .data(data):
        self = .data(data)
        
      case let .string(string):
        self = .string(string)
        
      @unknown default:
        throw Unknown()
      }
    }
  }
  
  var open: @Sendable (ID, URL, [String]) async -> AsyncStream<Action>
  var receive: @Sendable (ID) async throws -> AsyncStream<TaskResult<Message>>
  var send: @Sendable(ID, URLSessionWebSocketTask.Message) async throws -> Void
  var sendPing: @Sendable (ID) async throws -> Void
}

extension WebSocketClient: DependencyKey {
  static var liveValue: Self {
    return Self(
      open: {
        await WebSocketActor.shared.open(id: $0, url: $1, protocols: $2)
      }
    ) {
      try await WebSocketActor.shared.receive(id: $0)
    } send: {
      try await WebSocketActor.shared.send(id: $0, message: $1)
    } sendPing: {
      try await WebSocketActor.shared.sendPing(id: $0)
    }
    
    final actor WebSocketActor: GlobalActor {
      typealias Dependencies = (socket: URLSessionWebSocketTask, delegate: Delegate)
      static let shared = WebSocketActor()
      var dependencies: [ID: Dependencies] = [:]
      
      final class Delegate: NSObject, URLSessionWebSocketDelegate {
        var continuation: AsyncStream<Action>.Continuation?
        
        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
          continuation?.yield(.didOpen(protocol: `protocol`))
        }
        
        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
          continuation?.yield(.didClose(code: closeCode, reason: reason))
          continuation?.finish()
        }
      }
      
      func open(id: ID, url: URL, protocols: [String]) -> AsyncStream<Action> {
        let delegate = Delegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let socket = session.webSocketTask(with: url, protocols: protocols)
        defer { socket.resume() }
        
        var continuation: AsyncStream<Action>.Continuation!
        let stream = AsyncStream<Action> {
          $0.onTermination = { _ in
            socket.cancel()
            Task {
              await self.removeDependencies(id: id)
            }
          }
          continuation = $0
        }
        
        delegate.continuation = continuation
        dependencies[id] = (socket, delegate)
        return stream
      }
      
      func close(id: ID, with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) async throws {
        defer { dependencies[id] = nil }
        try socket(id: id).cancel(with: closeCode, reason: reason)
      }
      
      func receive(id: ID) throws -> AsyncStream<TaskResult<Message>> {
        let socket = try socket(id: id)
        return AsyncStream { continuation in
          let task = Task {
            while !Task.isCancelled {
              continuation.yield(await TaskResult { try await Message(socket.receive()) })
            }
            continuation.finish()
          }
          continuation.onTermination = { _ in task.cancel() }
        }
      }
      
      func send(id: ID, message: URLSessionWebSocketTask.Message) async throws {
        try await socket(id: id).send(message)
      }
      
      func sendPing(id: ID) async throws {
        let socket = try socket(id: id)
        return try await withCheckedThrowingContinuation { continuation in
          socket.sendPing { error in
            if let error {
              continuation.resume(throwing: error)
            } else {
              continuation.resume()
            }
          }
        }
      }
      
      private func socket(id: ID) throws -> URLSessionWebSocketTask {
        guard let dependencies = dependencies[id]?.socket else {
          struct Closed: Error { }
          throw Closed()
        }
        
        return dependencies
      }
      
      private func removeDependencies(id: ID) {
        dependencies[id] = nil
      }
    }
  }
  
  static let testValue = Self(
    open: unimplemented("\(Self.self).open", placeholder: AsyncStream.never),
    receive: unimplemented("\(Self.self).receive"),
    send: unimplemented("\(Self.self).send"),
    sendPing: unimplemented("\(Self.self).sendPing")
  )
}

extension DependencyValues {
  var webSocket: WebSocketClient {
    get { self[WebSocketClient.self] }
    set { self[WebSocketClient.self] = newValue }
  }
}
