//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Hao Luo on 12/8/20.
//

import SwiftUI

struct BottomSheet<Content>: View where Content: View {
    
    @Binding var showSheet: Bool
    @State private var offset : CGFloat = 0
    private let content: Content
    
    init(content: Content, showSheet: Binding<Bool>) {
        self.content = content
        self._showSheet = showSheet
    }
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            VStack(spacing: 12){
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 60, height: 4)
                
                Text("Sheet Title")
                    .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    content
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height / 3)
                .contentShape(Rectangle())
            }
            .padding(.top)
            .background(Color.white)
            .cornerRadius(45)
            .offset(y: offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
            .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
        .background(
            Color.black.opacity(showSheet ? 0.3 : 0).ignoresSafeArea()
                .onTapGesture(perform: {
                    withAnimation{showSheet.toggle()}
                })
        )
    }
    
    func onChanged(value: DragGesture.Value){
        if value.translation.height > 0 {
            offset = value.translation.height
        }
    }
    
    func onEnded(value: DragGesture.Value){
        if value.translation.height > 0 {
            withAnimation(Animation.easeIn(duration: 0.2)) {
                let height = UIScreen.main.bounds.height / 3
                if value.translation.height > height / 1.5 {
                    showSheet.toggle()
                }
                offset = 0
            }
        }
    }
}
