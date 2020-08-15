//
//  ContentView.swift
//  Calendar
//
//  Created by Hao Luo on 8/15/20.
//

import SwiftUI

/**
 - Stack alignment, spacing
 - Image resize, aspect ratio
 - ZStack
 - Preferece Key
 - View builder
 - Geometry reader
 */

// MARK: - Event Header

struct EventHeader: View {
    var body: some View {
        HStack(spacing: 15) {
            CalendarView()
            VStack(alignment: .leading) { // default alignment is .center
                Text("Event title").font(.title)
                Text("Location")
            }
            Spacer()
        }
    }
}

struct CalendarView: View {
    var body: some View {
        Image(systemName: "calendar")
            .resizable()
            .frame(width: 50, height: 50)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .foregroundColor(.white)
            .addVerifiedBadge(true)
    }
}

extension View {
    func addVerifiedBadge(_ isVerified: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            self

            if isVerified {
                Image(systemName: "checkmark.circle.fill")
                    .offset(x: 3, y: -3) // Move out of parent's bounding box a bit
            }
        }
    }
}

// MARK: - Event Info List

struct EventInfoList: View {
    var body: some View {
        HeightSyncedRow(backgroundColor: Color.secondary) {
            EventInfoBadge(
                iconName: "video.circle.fill",
                text: "Video call available"
            )
            EventInfoBadge(
                iconName: "doc.text.fill",
                text: "Files are attached longggggggggggggggggggggggggggg"
            )
            EventInfoBadge(
                iconName: "person.crop.circle.badge.plus",
                text: "Invites enabled"
            )
        }
    }
}

struct HeightSyncedRow<Content: View>: View {
    private let content: Content
    private let backgroundColor: Color
    @State private var childHeight: CGFloat?

    init(backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        HStack {
            content
                .syncingHeightIfLarger(than: $childHeight) // childHeight will be adjusted to largest value as we go through each row item
                .frame(height: childHeight)
                .background(backgroundColor)
        }
    }
}

extension View {
    func syncingHeightIfLarger(than height: Binding<CGFloat?>) -> some View {
        self.background(GeometryReader { proxy in
            Color.clear.preference(
                key: HeightPreferenceKey.self,
                value: proxy.size.height
            )
        })
        .onPreferenceChange(HeightPreferenceKey.self) {
            height.wrappedValue = max(height.wrappedValue ?? 0, $0)
            print("latest row height: \(String(describing: height.wrappedValue))")
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct EventInfoBadge: View {
    var iconName: String
    var text: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit) // make sure icons doesn't scale
                .frame(width: 25, height: 25)
            Text(text)
                .frame(maxWidth: .infinity) // Without this, longest text will get largest horizontal space. With this, parent view will distribute horizaontal space evently across children.
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
    }
}

// MARK: - Content View

struct ContentView: View {
    var body: some View {
        VStack {
            EventHeader()
            Spacer()
            EventInfoList()
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
