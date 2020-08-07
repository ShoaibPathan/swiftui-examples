//
//  ContentView.swift
//  BadgeView
//
//  Created by Hao Luo on 8/6/20.
//

import SwiftUI

extension View {
    func badge(count: Int) -> some View {
        Group {
            if count == 0 {
                self
            } else {
                self.overlay(
                    ZStack {
                        Circle()
                            .fill(Color.red)
                        Text("\(count)")
                            .foregroundColor(Color.white)
                    }
                    .offset(x: 12, y: -12)
                    .frame(width: 24, height: 24)
                    , alignment: .topTrailing
                )
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        HStack(spacing: 20) {
            Text("Hello")
            .padding(10)
            .background(Color.gray)
            .badge(count: 5)
            
            Text("World")
            .padding(10)
            .background(Color.gray)
            .badge(count: 0)
            
            Rectangle()
                .fill(Color.gray)
                .frame(width: 60, height: 40)
                .badge(count: 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
