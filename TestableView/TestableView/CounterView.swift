//
//  CounterView.swift
//  TestableView
//
//  Created by Hao Luo on 9/9/20.
//

import Combine
import SwiftUI

struct CounterView: View {
    
    private let writer: CounterWriter
    @ObservedObject private var reader: CounterReaderWrapper
    
    init(reader: CounterReaderWrapper, writer: CounterWriter) {
        self.reader = reader
        self.writer = writer
    }
    
    var counterValue: Int {
        return reader.value
    }
    
    var body: some View {
        HStack {
            Button("-") {
                self.writer.decrease()
            }
            Text("\(counterValue)")
            Button("+") {
                self.writer.increase()
            }
        }
    }
}

// MARK: - Snapshot test

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            reader: .init(countPublisher: Just(10).eraseToAnyPublisher()),
            writer: MockNoOpCounterWriter()
        )
    }
}
