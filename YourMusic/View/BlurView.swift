//
//  BlurView.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
