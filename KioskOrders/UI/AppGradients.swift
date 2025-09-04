//
//  AppGradients.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-02.
//

import SwiftUI

struct AppGradients {
    static let candyPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let candyPurple = Color(red: 0.8, green: 0.5, blue: 1.0)
    static let candyYellow = Color(red: 1.0, green: 0.95, blue: 0.4)
    static let candyBlue = Color(red: 0.5, green: 0.8, blue: 1.0)
    static let candyGreen = Color(red: 0.6, green: 0.9, blue: 0.5)

    static var background: LinearGradient {
        LinearGradient(
            colors: [Color.white, candyYellow.opacity(0.2), candyPink.opacity(0.15), candyPurple.opacity(0.05)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [candyPink, candyPurple, candyBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var fabGradient: LinearGradient {
        LinearGradient(
            colors: [candyPurple, candyPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
