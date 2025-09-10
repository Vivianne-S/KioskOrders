//
//  CustomerOrdersView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-05.
//

import SwiftUI
import FirebaseAuth

struct CustomerOrdersView: View {
    @StateObject private var customerOrdersVM = CustomerOrdersViewModel()
    @EnvironmentObject var authVM: AuthenticationViewModel

    var body: some View {
        NavigationView {
            List(customerOrdersVM.orders) { order in
                VStack(alignment: .leading, spacing: 6) {
                    Text("🧾 Order: \(order.id ?? "")")
                        .font(.headline)

                    ForEach(order.items, id: \.name) { item in
                        Text("- \(item.quantity)x \(item.name)")
                    }

                    Text("Status: \(order.status)")
                        .font(.subheadline)
                        .foregroundColor(order.status == "pending" ? .orange :
                                         order.status == "approved" ? .blue :
                                         .green)

                    if let pickupTime = order.pickupTime {
                        Text("⏰ Hämtas: \(pickupTime.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
            .onAppear {
                customerOrdersVM.listenForUserOrders()
            }
            .navigationTitle("Mina ordrar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logga ut") {
                        authVM.signOut()
                    }
                }
            }
        }
    }
}
