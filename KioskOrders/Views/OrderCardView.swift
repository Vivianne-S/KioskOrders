//
//  OrderCardView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-10.
//

import SwiftUI

struct OrderCardView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 🎟 Ordernummer
            if let number = order.confirmationNumber {
                Text("🎟 Ordernummer: \(number)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(AppGradients.candyPink)
                    .shimmer()
            } else {
                Text("🧾 Order: \(order.id?.prefix(6) ?? "okänd")")
                    .font(.headline)
                    .foregroundColor(AppGradients.candyPurple)
            }

            // Produkter
            ForEach(order.items.indices, id: \.self) { i in
                let item = order.items[i]
                Text("- \(item.quantity)x \(item.name)")
                    .font(.subheadline)
            }

            // Status
            Text("Status: \(simplifiedStatus(order.status))")
                .font(.subheadline)
                .foregroundColor(statusColor(for: order.status))

            // Pickup-tid
            if let pickupTime = order.pickupTime {
                Text("⏰ Avhämtning: \(pickupTime.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Klar för avhämtning
            if order.status == "ready" {
                Text("🥳 Din order är redo för avhämtning!")
                    .font(.headline)
                    .foregroundColor(AppGradients.candyGreen)
                    .shimmer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
                .shadow(color: AppGradients.candyPurple.opacity(0.2),
                        radius: 6, x: 0, y: 3)
        )
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

    private func statusColor(for status: String) -> Color {
        switch simplifiedStatus(status) {
        case "Påbörjad": return AppGradients.candyPurple
        case "Redo": return AppGradients.candyGreen
        case "Upphämtad": return .gray
        default: return .gray
        }
    }
}
