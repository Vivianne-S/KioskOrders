//
//  CandyTheme.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-16.
//


import SwiftUI

enum CandyTheme {
    static let candyPink = Color.pink
    static let candyPurple = Color.purple
    static let candyBlue = Color.blue
    static let candyGreen = Color.green
    static let candyYellow = Color.yellow

    static let colors: [Color] = [
        candyPink, candyPurple, candyBlue, candyGreen, candyYellow
    ]

    static let cardGradient = LinearGradient(
        colors: [candyPink, candyPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let background = LinearGradient(
        colors: [candyPink.opacity(0.5), candyBlue.opacity(0.5)],
        startPoint: .top,
        endPoint: .bottom
    )
}