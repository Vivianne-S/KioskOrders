//
//  CandyCelebration.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-16.
//


//
//  CandyCelebration.swift
//

import SwiftUI

struct CandyCelebration: View {
    @Binding var showConfetti: Bool

    var body: some View {
        ZStack {
            CandyBackground()
            ConfettiView(trigger: $showConfetti)
        }
    }
}