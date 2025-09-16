//
//  ConfirmationSheet.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-09.
//

import SwiftUI

struct ConfirmationSheet: View {
    let order: Order
    let onDismiss: () -> Void
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // 🌊 Candy ripple bakgrund
            WaterRippleView(color: AppGradients.candyPink.opacity(0.15))
            WaterRippleView(color: AppGradients.candyBlue.opacity(0.1))

            VStack(spacing: 24) {
                // 🎉 Header beroende på status
                switch simplifiedStatus(order.status) {
                case "Påbörjad":
                    Text("🍭 Din order har påbörjats!")
                        .font(.title)
                        .bold()
                        .foregroundColor(AppGradients.candyPink)
                        .shimmer()
                case "Redo":
                    Text("🥳 Din order är redo!")
                        .font(.title)
                        .bold()
                        .foregroundColor(AppGradients.candyGreen)
                        .shimmer()
                        .onAppear { showConfetti = true }
                case "Upphämtad":
                    Text("✅ Ordern är upphämtad")
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray)
                        .shimmer()
                default:
                    EmptyView()
                }

                // 🎟 Ordernummer
                if let number = order.confirmationNumber {
                    Text("🎟 Ordernummer: \(number)")
                        .font(.title2)
                        .foregroundColor(AppGradients.candyPurple)
                        .shimmer()
                }

                // 🏪 Kiosk-info
                Text("📍 Hämta i kiosk: \(order.kioskId.capitalized)")
                    .font(.headline)
                    .foregroundColor(AppGradients.candyBlue)

                // ⏰ Avhämtningstid
                if let pickupTime = order.pickupTime {
                    Text("⏰ Avhämtning: \(pickupTime.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // 🎁 Status-text
                Text("Status: \(simplifiedStatus(order.status))")
                    .font(.headline)
                    .foregroundColor(colorForSimplifiedStatus(order.status))

                Spacer()

                // ✅ Stäng-knapp
                Button(action: onDismiss) {
                    Text("OK, tack! 🍬")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppGradients.fabGradient)
                        .cornerRadius(14)
                        .shimmer()
                }
            }
            .padding()
        }
        .background(AppGradients.background.ignoresSafeArea())
        .overlay(ConfettiView(trigger: $showConfetti))
    }

    // MARK: - Helpers
    private func simplifiedStatus(_ status: String) -> String {
        switch status {
        case "pending", "approved", "confirmed": return "Påbörjad"
        case "ready": return "Redo"
        case "pickedUp": return "Upphämtad"
        default: return "Påbörjad"
        }
    }

    private func colorForSimplifiedStatus(_ status: String) -> Color {
        switch simplifiedStatus(status) {
        case "Påbörjad": return AppGradients.candyPurple
        case "Redo": return AppGradients.candyGreen
        case "Upphämtad": return .gray
        default: return .gray
        }
    }
}
