
//  EmployeeOrdersView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//

import SwiftUI

struct EmployeeOrdersView: View {
    @StateObject private var ordersVM = OrdersViewModel()
    let kioskId: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lyssnar på kioskId: \(kioskId)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)

            if ordersVM.orders.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                        Text("Inga inkomna ordrar ännu")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                Spacer()
            } else {
                List {
                    ForEach(ordersVM.orders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Order: \(order.id?.prefix(6) ?? "okänd")")
                                    .font(.headline)

                                ForEach(order.items, id: \.name) { item in
                                    Text("- \(item.quantity)x \(item.name)")
                                }

                                Text("Status: \(order.status)")
                                    .font(.subheadline)
                                    .foregroundColor(order.status == "ready" ? .green : .gray)

                                if let pickup = order.pickupTime {
                                    Text("Avhämtning: \(pickup.formatted(date: .omitted, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
        }
        .navigationTitle("Inkomna ordrar")
        .onAppear {
            print("👩‍🍳 EmployeeOrdersView onAppear, kioskId=\(kioskId)")
            ordersVM.listenForOrders(kioskId: kioskId)
        }
    }
}

