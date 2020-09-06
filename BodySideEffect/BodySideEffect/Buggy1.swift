//
//  Buggy1.swift
//  BodySideEffect
//
//  Created by Hao Luo on 9/6/20.
//

import Combine
import SwiftUI

/**
 The bug shows as the child view always renders count as 0, which seems never updated.
 This is because whenever parent view gets refreshed via `body`, the child view gets re-constructed as well -
 and during which the child view's view store is re-constructed, which leads to `callCount` always to be the initial value 0.
 */

// MARK: - Parent View

final class ParentViewStore1: ObservableObject {
    @Published private(set) var receiveCallCount: Int = 0
    
    func receiveCallFromChild() {
        receiveCallCount += 1
    }
}

struct ParentView1: View {
    @ObservedObject private var viewStore: ParentViewStore1
    
    init(viewStore: ParentViewStore1) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        VStack {
            ChildView1(viewStore: .init(parentViewStore: viewStore))
            Text("Receive call from child the \(viewStore.receiveCallCount) time 📳")
        }
    }
}

// Mark: - Child View

final class ChildViewStore1: ObservableObject {
    @Published private(set) var callCount: Int = 0
    private let parentViewStore: ParentViewStore1
    
    init(parentViewStore: ParentViewStore1) {
        self.parentViewStore = parentViewStore
    }
    
    func callParent() {
        callCount += 1
        parentViewStore.receiveCallFromChild()
    }
}

struct ChildView1: View {
    @ObservedObject private var viewStore: ChildViewStore1
    
    init(viewStore: ChildViewStore1) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        HStack {
            Button("☎️") {
                viewStore.callParent()
            }
            Text("Call parents the \(viewStore.callCount) time")
        }
    }
}
