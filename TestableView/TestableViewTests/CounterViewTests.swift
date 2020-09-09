//
//  TestableViewTests.swift
//  TestableViewTests
//
//  Created by Hao Luo on 9/9/20.
//

import Combine
import XCTest
@testable import TestableView

class CounterViewTests: XCTestCase {
    
    func testCounterViewRespectReaderValue() throws {
        let mockCountSubject = CurrentValueSubject<Int, Never>(111)
        let counterView: CounterView = .init(
            reader: .init(countPublisher: mockCountSubject.eraseToAnyPublisher()),
            writer: MockNoOpCounterWriter()
        )
        XCTAssertEqual(counterView.counterValue, 111)
        
        mockCountSubject.send(222)
        XCTAssertEqual(counterView.counterValue, 222)
    }
}
