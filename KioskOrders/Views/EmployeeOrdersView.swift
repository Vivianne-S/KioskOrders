//
//  EmployeeOrdersView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//
import SwiftUI

struct EmployeeOrdersView: View {
    @StateObject private var ordersVM = OrdersViewModel()
    let kioskId: String
    @State private var selectedOrder: Order?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lyssnar på kioskId: \(kioskId)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)

            if ordersVM.orders.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(AppGradients.candyPurple)
                        .shimmer()
                    Text("Inga inkomna ordrar ännu")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                Spacer()
            } else {
                List {
                    // 👇 filtrerar bort "pickedUp"
                    ForEach(ordersVM.orders.filter { $0.status != "pickedUp" }) { order in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    // Ordernummer
                                    if let number = order.confirmationNumber {
                                        Text("🎟 Ordernummer: \(number)")
                                            .font(.headline)
                                            .foregroundColor(AppGradients.candyPink)
                                            .shimmer()
                                    } else {
                                        Text("Order: \(order.id?.prefix(6) ?? "okänd")")
                                            .font(.headline)
                                            .foregroundColor(AppGradients.candyPurple)
                                    }

                                    // Produkter
                                    ForEach(order.items, id: \.name) { item in
                                        Text("- \(item.quantity)x \(item.name)")
                                            .font(.subheadline)
                                    }

                                    // Status (förenklad)
                                    Text("Status: \(simplifiedStatus(order.status))")
                                        .font(.subheadline)
                                        .foregroundColor(colorForStatus(order.status))

                                    // Pickup-tid
                                    if let pickup = order.pickupTime {
                                        Text("⏰ Avhämtning: \(pickup.formatted(date: .omitted, time: .shortened))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()

                                // ✅ Knapp för upphämtning
                                if order.status == "ready" {
                                    Button {
                                        withAnimation {
                                            ordersVM.markOrderAsPickedUp(orderId: order.id ?? "") { success in
                                                if success {
                                                    print("🎉 Order markerad som upphämtad")
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(AppGradients.fabGradient)
                                            .clipShape(Circle())
                                            .shimmer()
                                    }
                                    .buttonStyle(.plain) // 👈 hindrar list-row highlight
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle()) // gör hela cellen tryckbar
                        .onTapGesture {
                            selectedOrder = order
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Inkomna ordrar")
        .onAppear {
            print("👩‍🍳 EmployeeOrdersView onAppear, kioskId=\(kioskId)")
            ordersVM.listenForOrders(kioskId: kioskId)
        }
        // 🔎 Sheet för detaljer
        .sheet(item: $selectedOrder) { order in
            OrderDetailView(order: order)
        }
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

    private func colorForStatus(_ status: String) -> Color {
        switch simplifiedStatus(status) {
        case "Påbörjad": return AppGradients.candyPurple
        case "Redo": return AppGradients.candyGreen
        case "Upphämtad": return .gray
        default: return .gray
        }
    }
}
