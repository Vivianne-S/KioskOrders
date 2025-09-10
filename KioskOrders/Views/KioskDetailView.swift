//
//  KioskDetailView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import SwiftUI

struct KioskDetailView: View {
    let kiosk: Kiosk
    @Binding var cartItems: [FoodItem]

    @StateObject private var viewModel = KioskDetailViewModel()
    @State private var wobble = false
    @State private var showCart = false    // 👈 lägg till

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 25) {
                        // Header
                        headerView

                        // Title
                        sectionTitle

                        // States
                        if viewModel.isLoading {
                            ProgressView("Loading treats...")
                                .tint(AppGradients.candyPink)
                                .scaleEffect(1.8)
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text("❌ \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else if viewModel.foodItems.isEmpty {
                            Text("No treats available right now")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // Items
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.foodItems) { item in
                                    CandyItemCard(item: item, isPressed: viewModel.pressedItemId == item.id)
                                        .scaleEffect(viewModel.pressedItemId == item.id ? 0.95 : 1.0)
                                        .opacity(item.isAvailable ? 1.0 : 0.6)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.pressedItemId)
                                        .onTapGesture {
                                            viewModel.handleTap(on: item, cartItems: &cartItems)
                                        }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 30)
                        }
                    }
                    .padding(.vertical)
                }
                .background(AppGradients.background.ignoresSafeArea())

                // 🛒 Flytande kundvagns-knapp även här
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CartButton(count: cartItems.count) {
                            showCart = true
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Hämta varor för denna kiosk
                viewModel.fetchFoodItems(for: kiosk.id ?? "")
            }
            // Öppna varukorgen som sheet, med säkert kioskId
            .sheet(isPresented: $showCart) {
                CartView(
                    cartItems: $cartItems,
                    kioskId: (kiosk.id ?? kiosk.name.lowercased())
                )
            }
            // (valfritt) liten kundvagn i navbar också
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCart = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "cart.fill")
                            if cartItems.count > 0 {
                                Text("\(cartItems.count)")
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 12) {
            Text(kiosk.name)
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: AppGradients.candyPurple.opacity(0.6), radius: 6, x: 0, y: 3)
                .padding(.top, 5)
                .multilineTextAlignment(.center)

            Text(kiosk.description)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Section Title
    private var sectionTitle: some View {
        HStack {
            Text("🍭 Candies & Treats")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppGradients.candyPurple)
            Spacer()
            Image(systemName: "heart.fill")
                .foregroundColor(AppGradients.candyPink)
                .scaleEffect(1.2)
        }
        .padding(.horizontal)
    }
}
