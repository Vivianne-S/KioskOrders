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
    @State private var activeOrder: Order?   // 👈 styr sheet

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(customerOrdersVM.orders) { order in
                        OrderCardView(order: order)
                            .onTapGesture {
                                activeOrder = order
                            }
                    }
                }
                .padding()
                .background(AppGradients.background.ignoresSafeArea())
            }
            .onAppear {
                customerOrdersVM.listenForUserOrders()
            }
            .onChange(of: customerOrdersVM.orders) { newOrders in
                // Byt logiken till förenklade statusar
                if let justStarted = newOrders.first(where: { simplifiedStatus($0.status) == "Påbörjad" }) {
                    activeOrder = justStarted
                } else if let justReady = newOrders.first(where: { simplifiedStatus($0.status) == "Redo" }) {
                    activeOrder = justReady
                } else if let picked = newOrders.first(where: { simplifiedStatus($0.status) == "Upphämtad" }) {
                    activeOrder = picked
                }
            }
            .navigationTitle("Mina ordrar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logga ut") {
                        authVM.signOut()
                    }
                }
            }
            .sheet(item: $activeOrder) { order in
                ConfirmationSheet(order: order) {
                    activeOrder = nil
                }
            }
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
}
