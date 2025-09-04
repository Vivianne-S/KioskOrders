//
//  ShimmerModifier.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var shimmer = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [.white.opacity(0.3), .white.opacity(0.0), .white.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .mask(content)
                .rotationEffect(.degrees(20))
                .offset(x: shimmer ? 300 : -300)
            )
            .onAppear {
                withAnimation(.linear(duration:   5).repeatForever(autoreverses: false)) {
                    shimmer.toggle()
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}
