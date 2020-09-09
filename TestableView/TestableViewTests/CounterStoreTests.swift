//
//  CounterStore.swift
//  TestableViewTests
//
//  Created by Hao Luo on 9/9/20.
//

import Combine
import XCTest
@testable import TestableView

class CounterStoreTests: XCTestCase {
    
    func testCounterStore() throws {
        let counterStore = CounterStore(initialCount: 111)
        
        let expectation = XCTestExpectation(description: "Receive count updates")
        expectation.expectedFulfillmentCount = 2
        var allCounts: [Int] = []
        let cancellable = counterStore.countPublisher.sink { count in
            allCounts.append(count)
            expectation.fulfill()
        }
        
        counterStore.increase() // should be 112
        counterStore.decrease() // should be 111 again
        
//        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(allCounts, [111, 112, 111])
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(cancellable)
    }
}
