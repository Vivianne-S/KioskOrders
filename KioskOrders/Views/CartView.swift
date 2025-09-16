//
//  CartView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-02.
//

import SwiftUI

struct CartView: View {
    @Binding var cartItems: [FoodItem]
    let kioskId: String

    @StateObject private var orderVM = OrderPlacementViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var showConfirmation = false
    @State private var showError = false
    @State private var errorText = "Kunde inte skicka order"

    var totalPrice: Double { cartItems.reduce(0) { $0 + $1.price } }

    var body: some View {
        VStack {
            if cartItems.isEmpty {
                Text("🛒 Din varukorg är tom")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(cartItems) { item in
                        HStack {
                            // 📦 Namn
                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            // 💰 Pris
                            Text("\(Int(item.price)) kr")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                            // 🗑️ Ta bort-knapp
                            Button {
                                if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        cartItems.remove(at: index)
                                    }
                                }
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red.opacity(0.85))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .background(
                            LinearGradient(colors: [AppGradients.candyPink, AppGradients.candyPurple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .cornerRadius(12)
                        .shadow(color: AppGradients.candyPurple.opacity(0.4), radius: 6, x: 0, y: 3)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }

                    // ➕ Totalt-rad
                    HStack {
                        Text("Totalt")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(totalPrice)) kr")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [AppGradients.candyBlue, AppGradients.candyPurple],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .cornerRadius(12)
                    .shadow(color: AppGradients.candyBlue.opacity(0.4), radius: 6, x: 0, y: 3)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden) // gör hela listbakgrunden transparent

                // ✅ Skicka beställning-knapp
                Button {
                    Task {
                        // ✅ Fallback för kioskId om prop är tomt
                        let fallback = cartItems.first?.availableAt.first ?? ""
                        let finalKioskId = kioskId.isEmpty ? fallback : kioskId

                        print("🧾 Försöker skicka order. kioskId='\(finalKioskId)', items=\(cartItems.map{$0.name})")

                        guard !finalKioskId.isEmpty else {
                            errorText = "Saknar kioskId (välj kiosk innan du beställer)."
                            showError = true
                            return
                        }

                        let result = await orderVM.placeOrder(kioskId: finalKioskId, items: cartItems)
                        switch result {
                        case .success:
                            cartItems.removeAll()
                            showConfirmation = true
                        case .failure(let err):
                            errorText = err            // ⬅️ visa riktig feltext
                            showError = true
                        }
                    }
                } label: {
                    Text("✅ Skicka beställning")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppGradients.fabGradient)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 6)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Varukorg")
        .alert("🎉 Din order är skickad!", isPresented: $showConfirmation) {
            Button("OK") { dismiss() }
        }
        .alert("Kunde inte skicka order", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorText)
        }
    }

    private func removeItems(at offsets: IndexSet) { cartItems.remove(atOffsets: offsets) }
}
