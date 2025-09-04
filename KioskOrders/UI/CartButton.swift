//
//  CartButton.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-02.
//


//
//  CartButton.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI

struct CartButton: View {
    var count: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.purple, .pink],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing))
                    .frame(width: 65, height: 65)
                    .shadow(color: .purple.opacity(0.6), radius: 8, x: 0, y: 5)

                Image(systemName: "cart.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                if count > 0 {
                    Text("\(count)")
                        .font(.caption2).bold()
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Circle().fill(Color.red))
                        .offset(x: 20, y: -20)
                }
            }
        }
    }
}