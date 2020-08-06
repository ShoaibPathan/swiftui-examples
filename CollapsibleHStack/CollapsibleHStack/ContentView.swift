//
//  ContentView.swift
//  CollapsibleHStack
//
//  Created by Hao Luo on 8/6/20.
//

import SwiftUI

struct Collapsible<Element, Content: View>: View {
    var data: [Element]
    var expanded: Bool = false
    var spacing: CGFloat? = 8
    var collapsedWidth: CGFloat = 10
    var content: (Element) -> Content

    private func content(at index: Int) -> some View {
        let showExpanded = expanded || index == self.data.endIndex - 1
        return content(data[index])
            // must set `.alignment` as `.leading` explicitly here, otherwise it defaults to `.center`
            .border(Color.green)
            .frame(width: showExpanded ? nil : collapsedWidth,alignment: .leading)
            .border(Color.blue)
    }

    var body: some View {
        HStack(spacing: expanded ? spacing : 0) {
            ForEach(data.indices) {
                self.content(at: $0)
            }
        }.border(Color.red)
    }
}

struct ContentView: View {
    let colors: [(Color, CGFloat)] = [
        (.init(white: 0.3), 100),
        (.init(white: 0.8), 60),
        (.init(white: 0.5), 40),
    ]
    @State var expanded: Bool = true
    var body: some View {
        VStack {
            HStack {
                Collapsible(data: colors, expanded: expanded) { (item: (Color, CGFloat)) in
                    Rectangle()
                        .fill(item.0)
                        .frame(width: item.1, height: item.1)
                }
            }
            Button(action: { withAnimation(.default) {
                self.expanded.toggle() } }, label: {
                    Text(self.expanded ? "Collapse" : "Expand")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
