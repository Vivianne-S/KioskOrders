//
//  KioskListView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI

struct KioskListView: View {
    @EnvironmentObject var kioskVM: KioskViewModel
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var cartItems: [FoodItem] = []
    @State private var showCart = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(kioskVM.kiosks) { kiosk in
                            NavigationLink(
                                destination: KioskDetailView(kiosk: kiosk, cartItems: $cartItems)
                            ) {
                                ZStack {
                                    LinearGradient(colors: [.pink, .purple, .orange],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                        .cornerRadius(25)
                                        .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 5)
                                        .shimmer()

                                    VStack(alignment: .leading, spacing: 8) {
                                        Label {
                                            Text(kiosk.name)
                                                .font(.title2)
                                                .fontWeight(.bold)
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
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .onAppear {
                        kioskVM.loadKiosks()
                    }
                }

                // 🛒 FAB för kundvagn
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showCart = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.purple, .pink],
                                                         startPoint: .topLeading,
                                                         endPoint: .bottomTrailing))
                                    .frame(width: 65, height: 65)
                                    .shadow(color: .purple.opacity(0.6), radius: 8, x: 0, y: 5)

                                Image(systemName: "cart.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)

                                // 🔴 Badge för antal varor
                                if cartItems.count > 0 {
                                    Text("\(cartItems.count)")
                                        .font(.caption2).bold()
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(Circle().fill(Color.red))
                                        .offset(x: 20, y: -20)
                                }
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }

                // NavigationLink till CartView
                NavigationLink(destination: CartView(cartItems: $cartItems), isActive: $showCart) {
                    EmptyView()
                }
            }
            .navigationTitle("🍭 Parkens Kiosker")
            .toolbar {
                Button("Logga ut") {
                    authVM.signOut()
                }
            }
        }
    }
}
