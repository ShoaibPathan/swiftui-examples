//
//  PublicAPI.swift
//  TestableView
//
//  Created by Hao Luo on 9/9/20.
//

import Combine

// MARK: - Read Operations

protocol CounterReader {
    var countPublisher: AnyPublisher<Int, Never> { get }
}

final class CounterReaderWrapper: ObservableObject {
    @Published private(set) var value: Int = 0
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(countPublisher: AnyPublisher<Int, Never>) {
        countPublisher.sink { count in
            self.value = count
        }.store(in: &cancellables)
    }
}

// MARK: - Write Operations

protocol CounterWriter {
    func increase()
    func decrease()
}
