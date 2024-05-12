//
//  HeaderView.swift
//  YourTube
//
//  Created by Thanabardi on 27/3/2567 BE.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    
    @Environment(\.presentationMode) private var
    presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text(title).font(.headline)
                .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(edges: .top)
        .frame(height: 50)
        .background(Color(UIColor.systemGray6))
        .overlay(alignment: .bottom) {
            Divider().background(Color(UIColor.systemGray5))
        }
        .overlay(alignment: .leading) {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.primary)
                        .contentShape(.rect)
                })
            .bold()
            .padding(.leading, 15)
            .foregroundColor(.primary)
        }
        
        .toolbar(.hidden)
    }
}

#Preview {
    HeaderView(title: "Preview")
}
