//
//  MockImpl.swift
//  TestableView
//
//  Created by Hao Luo on 9/9/20.
//

import Combine

final class MockNoOpCounterWriter: CounterWriter {
    func increase() {}
    func decrease() {}
}
