//
//  CandyBackground.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-16.
//


//
//  CandyBackground.swift
//  KioskOrders
//

import SwiftUI

struct CandyBackground: View {
    var body: some View {
        ZStack {
            // 🌈 Grundbakgrund
            AppGradients.background.ignoresSafeArea()

            // 🌊 Ripple-effekter i flera lager
            WaterRippleView(color: AppGradients.candyBlue.opacity(0.25))
            WaterRippleView(color: AppGradients.candyPink.opacity(0.2))
            WaterRippleView(color: AppGradients.candyPurple.opacity(0.15))
        }
        .ignoresSafeArea()
    }
}