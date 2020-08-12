//
//  ContentView.swift
//  ObservableObject
//
//  Created by Hao Luo on 8/11/20.
//

import Combine
import SwiftUI

final class ComposedCountStore: ObservableObject {
    @Published private(set) var avocadoCount: Int = 0
    @Published private(set) var peachCount: Int = 0
    
    func increaseAvocado() {
        self.avocadoCount += 1
    }
    
    func increasePeach() {
        self.peachCount += 1
    }
}

final class PeachCountStore: ObservableObject, Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    @Published private(set) var peachCount: Int = 0
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        peachCount = input
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
    }
}


struct ContentView: View {
    @ObservedObject private var countStore: ComposedCountStore
    @ObservedObject private var peachCountStore: PeachCountStore
    
    init() {
        self.countStore = .init()
        self.peachCountStore = .init()
        self.countStore.$peachCount.subscribe(self.peachCountStore)
    }
    
    var body: some View {
        print("Refreshing content view")
        return HStack {
            VStack {
                AvocadoView(composedCountStore: self.countStore)
                Button("Increase 🥑") {
                    self.countStore.increaseAvocado()
                }
            }
            
            VStack {
                PeachView(peachCountStore: self.peachCountStore)
                Button("Increase 🍑") {
                    self.countStore.increasePeach()
                }
            }
        }
    }
}

// AvocadoView will be refreshed when either 🥑 or 🍑 is increased
private struct AvocadoView: View {
    @ObservedObject private var composedCountStore: ComposedCountStore
    
    init(composedCountStore: ComposedCountStore) {
        self.composedCountStore = composedCountStore
    }
    
    var body: some View {
        print("Refreshing 🥑 view")
        return Text(String(repeating: "🥑", count: composedCountStore.avocadoCount))
    }
}

// PeachView will be refreshed *only* when 🍑 is increased
private struct PeachView: View {
    @ObservedObject private var peachCountStore: PeachCountStore

    init(peachCountStore: PeachCountStore) {
        self.peachCountStore = peachCountStore
    }
    
    var body: some View {
        print("Refreshing 🍑 view")
        return Text(String(repeating: "🍑", count: peachCountStore.peachCount))
    }
}

