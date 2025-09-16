//
//  WaterRippleView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-16.
//


import SwiftUI

struct WaterRippleView: View {
    @State private var ripple = false
    var color: Color = CandyTheme.candyPink.opacity(0.2)

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: ripple ? 600 : 200, height: ripple ? 600 : 200)
            .blur(radius: 80)
            .scaleEffect(ripple ? 1.5 : 0.8)
            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: ripple)
            .onAppear { ripple = true }
            .allowsHitTesting(false)
    }
}