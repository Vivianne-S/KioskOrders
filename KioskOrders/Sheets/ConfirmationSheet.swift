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

    var body: some View {
        VStack(spacing: 20) {
            // 🎉 Header beroende på status
            switch simplifiedStatus(order.status) {
            case "Påbörjad":
                Text("🍭 Din order är påbörjad!")
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

            // 🎁 Status
            Text("Status: \(simplifiedStatus(order.status))")
                .font(.headline)
                .foregroundColor(colorForSimplifiedStatus(order.status))

            Spacer()

            // ✅ Stäng-knapp
            Button(action: onDismiss) {
                Text("OK, tack! 🍭")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppGradients.fabGradient)
                    .cornerRadius(12)
                    .shimmer()
            }
        }
        .padding()
        .background(AppGradients.background.ignoresSafeArea())
    }

    // MARK: - Helpers
    private func simplifiedStatus(_ status: String) -> String {
        switch status {
        case "pending", "approved", "confirmed":
            return "Påbörjad"
        case "ready":
            return "Redo"
        case "pickedUp":
            return "Upphämtad"
        default:
            return "Påbörjad"
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
