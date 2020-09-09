//
//  ContentView.swift
//  TestableView
//
//  Created by Hao Luo on 9/9/20.
//

import SwiftUI

struct ContentView: View {
    private let store: CounterStore = .init(initialCount: 0)
    var body: some View {
        CounterView(
            reader: .init(countPublisher: store.countPublisher),
            writer: store
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
