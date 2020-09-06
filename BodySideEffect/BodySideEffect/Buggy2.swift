//
//  Correct2.swift
//  BodySideEffect
//
//  Created by Hao Luo on 9/6/20.
//

import Combine
import SwiftUI

/**
 This impl fixes the issue in Buggy1 by injecting child view's view store from parent view so its lifecycle maintains the same as parent view
 and won't be re-constructed every time.
 
 But another issue introduced here is storing child view's view store in parent view as `ObservedObject` - so parent view will get refreshed
 even when only child view's view store is updated - which shou;dn't alert parent view at all. This probably seems OK at first, but could introduce
 surprising behaviors if there are  side-effects conducted within `body` (eg. create subscription, network request, etc.)
 
 The fix is to change `ObservedObject` to a simple `let` for child view store in parent view, so that parent view won't be refreshed when
 child view store gets updated cause it isn't really observing it.
 
 Probably a general rule of thumb here is to always have a single `ObservedObject` per `View` ?
 */

// MARK: - Parent View

final class ParentViewStore2: ObservableObject {
    @Published private(set) var receiveCallCount: Int = 0
    
    func receiveCallFromChild() {
        receiveCallCount += 1
    }
}

struct ParentView2: View {
    @ObservedObject private var viewStore: ParentViewStore2
    @ObservedObject private var childViewStore: ChildViewStore2 // Fix: change `ObservedObject var` to `let`
    
    init(viewStore: ParentViewStore2) {
        self.viewStore = viewStore
        self.childViewStore = .init(parentViewStore: viewStore)
    }
    
    var body: some View {
        print("parent view refreshed!")
        return VStack {
            ChildView2(viewStore: childViewStore)
            Text("Receive call from child the \(viewStore.receiveCallCount) time 📳")
        }
    }
}

// Mark: - Child View

final class ChildViewStore2: ObservableObject {
    @Published private(set) var callCount: Int = 0
    private let parentViewStore: ParentViewStore2
    
    @Published private(set) var secretStuffCount: Int = 0
    
    init(parentViewStore: ParentViewStore2) {
        self.parentViewStore = parentViewStore
    }
    
    func callParent() {
        callCount += 1
        parentViewStore.receiveCallFromChild()
    }
    
    func secretStuffHideFromParent() {
        secretStuffCount += 1
    }
}

struct ChildView2: View {
    @ObservedObject private var viewStore: ChildViewStore2
    
    init(viewStore: ChildViewStore2) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        print("Child view refreshed!")
        return VStack {
            HStack {
                Button("☎️") {
                    viewStore.callParent()
                }
                Text("Call parents the \(viewStore.callCount) time")
            }
            HStack {
                Button("🤫") {
                    viewStore.secretStuffHideFromParent()
                }
                Text("Do secret stuff the \(viewStore.secretStuffCount) time")
            }
        }
    }
}
