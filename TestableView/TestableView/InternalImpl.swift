//
//  InternalImpl.swift
//  TestableView
//
//  Created by Hao Luo on 9/9/20.
//

import Combine

final class CounterStore: CounterReader, CounterWriter {
    private var countSubject: CurrentValueSubject<Int, Never>
    
    init(initialCount: Int) {
        self.countSubject = .init(initialCount)
    }
    
    // MARK: - CounterReader
    
    var countPublisher: AnyPublisher<Int, Never> {
        return countSubject.eraseToAnyPublisher()
    }
    
    // MARK: - CounterWriter
    
    func increase() {
        countSubject.send(countSubject.value + 1)
    }
    
    func decrease() {
        countSubject.send(countSubject.value - 1)
    }
}
