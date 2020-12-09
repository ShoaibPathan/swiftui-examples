//
//  ContentView.swift
//  BottomSheet
//
//  Created by Hao Luo on 12/8/20.
//

import SwiftUI

struct ContentView: View {
    private let tableRows: [String] = [
        "first", "second", "third", "fourth"
    ]
    
    @State private var showSimpleTextSheet: Bool = false
    @State private var showTableSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showSimpleTextSheet.toggle()
                    }
                }, label: {
                    Text("Text sheet")
                })
                
                Button(action: {
                    withAnimation {
                        showTableSheet.toggle()
                    }
                }, label: {
                    Text("Table sheet")
                })
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BottomSheet(
                content: Text("Hello world"),
                showSheet: $showSimpleTextSheet
            )
            
            BottomSheet(
                content: ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 0){
                        ForEach(tableRows, id: \.self){ row in
                            HStack {
                                Spacer()
                                Text(row)
                                Spacer()
                            }
                        }
                    }
                }),
                showSheet: $showTableSheet
            )
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
