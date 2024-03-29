//
//  LongLivingEffectsTests.swift
//  TCAExampleTests
//
//  Created by Yumin Chu on 2023/11/23.
//

import XCTest

import ComposableArchitecture

@testable import TCAExample

@MainActor
final class LongLivingEffectsTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testReducer() async {
    let (screenshots, takeScreenshot) = AsyncStream.makeStream(of: Void.self)
    let store = TestStore(initialState: LonglivingEffectsCore.State()) {
      LonglivingEffectsCore()
    } withDependencies: {
      $0.screenshots = { screenshots }
    }

    let task = await store.send(.task)
    takeScreenshot.yield()
    await store.receive(.didTaskScreenshot) {
      $0.screenShotCount = 1
    }
    await task.cancel()
    takeScreenshot.yield()
  }
}
