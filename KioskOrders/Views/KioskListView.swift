//
//  KioskListView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI

struct KioskListView: View {
    @EnvironmentObject var kioskVM: KioskViewModel
    @EnvironmentObject var authVM: AuthenticationViewModel

    @State private var cartItems: [FoodItem] = []
    @State private var showCart = false
    @State private var selectedKioskId: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(kioskVM.kiosks) { kiosk in
                            NavigationLink {
                                KioskDetailView(kiosk: kiosk, cartItems: $cartItems)
                                    .onAppear {
                                        // Sätt vald kiosk & rensa korg om man byter kiosk
                                        let thisId = kiosk.id ?? kiosk.name.lowercased()
                                        if let first = cartItems.first,
                                           let firstAvail = first.availableAt.first,
                                           firstAvail != thisId {
                                            cartItems.removeAll()
                                        }
                                        selectedKioskId = thisId
                                    }
                            } label: {
                                KioskCardView(kiosk: kiosk)   // ✅ rätt namn
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }

                // 🛒 Flytande kundvagnsknapp
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CartButton(count: cartItems.count) {
                            // ✅ Sätt kioskId från första varan om det inte är satt ännu
                            if selectedKioskId == nil {
                                selectedKioskId = cartItems.first?.availableAt.first
                            }
                            showCart = true
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("🍭 Parkens Kiosker")
            .onAppear { kioskVM.loadKiosks() }
            .sheet(isPresented: $showCart) {
                CartView(cartItems: $cartItems, kioskId: selectedKioskId ?? "")
            }
        }
    }
}

// MARK: - Kiosk-kortet
struct KioskCardView: View {
    let kiosk: Kiosk

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.pink, .purple, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(25)
            .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 5)
            .shimmer() // lämna kvar bara om du har din shimmer-modifier

            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text(kiosk.name)
                        .font(.title2).fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } icon: {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 22, height: 20)
                        .foregroundColor(.yellow)
                }

                Text(kiosk.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
}
