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
                            Text(item.name).font(.headline)
                            Spacer()
                            Text("\(Int(item.price)) kr").font(.subheadline)
                        }
                    }
                    .onDelete(perform: removeItems)

                    HStack {
                        Text("Totalt").font(.headline)
                        Spacer()
                        Text("\(Int(totalPrice)) kr").font(.headline)
                    }
                }

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
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
