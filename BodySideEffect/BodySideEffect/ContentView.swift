//
//  ContentView.swift
//  BodySideEffect
//
//  Created by Hao Luo on 9/6/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ParentView2(viewStore: .init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
