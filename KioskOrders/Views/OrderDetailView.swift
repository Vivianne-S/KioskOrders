//
//  OrderDetailView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-08.
//

import SwiftUI

struct OrderDetailView: View {
    @State var order: Order
    @State private var pickupTime = Date()
    @Environment(\.dismiss) private var dismiss
    @StateObject private var ordersVM = OrdersViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // 🧾 Orderinformation
                infoCard

                // 📦 Produkter
                productsCard

                // Steg beroende på status
                if order.status == "pending" {
                    confirmCard
                } else if order.status == "confirmed" {
                    confirmedCard
                    readyCard
                } else if order.status == "ready" {
                    readyInfoCard
                }
            }
            .padding()
        }
        .navigationTitle("Orderdetaljer")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - UI Cards
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📋 Orderinformation")
                .font(.headline)

            Text("Order #\(order.id?.prefix(6) ?? "okänd")")
                .font(.title2).bold()

            Text("Status: \(order.status.uppercased())")
                .font(.subheadline)
                .foregroundColor(colorForStatus(order.status))

            if let createdAt = order.createdAt {
                Text("🕒 Skapad: \(createdAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private var productsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🍭 Produkter")
                .font(.headline)

            ForEach(order.items, id: \.id) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("\(item.quantity) st")
                        .bold()
                }
                Divider()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.pink.opacity(0.15))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private var confirmCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("✅ Bekräfta order")
                .font(.headline)

            DatePicker("Avhämtningstid", selection: $pickupTime, displayedComponents: .hourAndMinute)

            Button(action: confirmOrder) {
                Text("Bekräfta order")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private var confirmedCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🎟 Ordern är bekräftad")
                .font(.headline)

            if let number = order.confirmationNumber {
                Text("Ordernummer: \(number)")
                    .bold()
                    .font(.title2)
            }

            if let pickup = order.pickupTime {
                Text("Avhämtning: \(pickup.formatted(date: .omitted, time: .shortened))")
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private var readyCard: some View {
        VStack(spacing: 12) {
            Button(action: markAsReady) {
                Text("🍬 Markera som redo för avhämtning")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private var readyInfoCard: some View {
        VStack(spacing: 10) {
            Text("🥳 Ordern är klar för avhämtning!")
                .font(.headline)
                .foregroundColor(.green)

            if let number = order.confirmationNumber {
                Text("Ordernummer: \(number)").bold()
            }

            if let pickup = order.pickupTime {
                Text("Avhämtning: \(pickup.formatted(date: .omitted, time: .shortened))")
            }
        }
        .padding()
        .background(Color.green.opacity(0.15))
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    // MARK: - Helpers
    private func colorForStatus(_ status: String) -> Color {
        switch status {
        case "ready": return .green
        case "confirmed": return .blue
        default: return .orange
        }
    }

    private func confirmOrder() {
        ordersVM.confirmOrder(orderId: order.id ?? "", pickupTime: pickupTime) { success in
            if success { dismiss() }
        }
    }

    private func markAsReady() {
        ordersVM.markOrderAsReady(orderId: order.id ?? "", readyTime: Date()) { success in
            if success { dismiss() }
        }
    }
}
