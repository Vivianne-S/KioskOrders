//
//  OrderDetailView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-08.
//

import SwiftUI

struct OrderDetailView: View {
    @State var order: Order
    @State private var readyTime = Date()
    @Environment(\.dismiss) private var dismiss
    @StateObject private var ordersVM = OrdersViewModel()

    var body: some View {
        Form {
            // 🧾 Orderinformation
            Section(header: Text("Orderinformation")) {
                Text("Order #\(order.id?.prefix(6) ?? "okänd")")
                Text("Status: \(order.status.uppercased())")
                    .foregroundColor(order.status == "ready" ? .green : .orange)

                if let createdAt = order.createdAt {
                    Text("Skapad: \(createdAt.formatted(date: .abbreviated, time: .shortened))")
                } else {
                    Text("Skapad: okänd")
                }
            }

            // 📦 Produkter
            Section(header: Text("Produkter")) {
                ForEach(order.items, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) st")
                    }
                }
            }

            // ✅ Markera som redo
            if order.status != "ready" {
                Section(header: Text("Markera som redo")) {
                    DatePicker("Redo kl:", selection: $readyTime, displayedComponents: .hourAndMinute)

                    Button(action: markAsReady) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Markera som redo för avhämtning")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.green)
                }
            }
            // 📅 Visa pickupTime om den är satt
            else if let readyAt = order.pickupTime {
                Section(header: Text("Redo för avhämtning")) {
                    Text("Ordern är markerad som redo")
                    Text("Redo sedan: \(readyAt.formatted(date: .omitted, time: .shortened))")
                }
            }
        }
        .navigationTitle("Orderdetaljer")
    }

    private func markAsReady() {
        ordersVM.markOrderAsReady(orderId: order.id ?? "", readyTime: readyTime) { success in
            if success {
                dismiss()
            }
        }
    }
}
