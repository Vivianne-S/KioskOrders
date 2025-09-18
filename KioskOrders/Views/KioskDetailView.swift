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
    @State private var showCart = false
    
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
                
                // 🛒 Flytande kundvagns-knapp
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
                // ✅ Skicka in hela kiosken istället för bara id
                viewModel.fetchFoodItems(for: kiosk)
            }
            // Öppna varukorgen som sheet, med säkert kioskId
            .sheet(isPresented: $showCart) {
                CartView(
                    cartItems: $cartItems,
                    kioskId: (kiosk.id ?? kiosk.name.lowercased())
                )
            }
            // liten kundvagn i navbar
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
        VStack(spacing: 8) { // 🔹 mindre spacing
            // 🌈 Kioskens namn
            Text(kiosk.name)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [AppGradients.candyPink, AppGradients.candyPurple],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                .multilineTextAlignment(.center)
            
            // 📖 Beskrivning
            if !kiosk.description.isEmpty {
                Text(kiosk.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
            }
            
            // 🔹 Extra info-rad
            HStack(spacing: 14) { // 🔹 tajtare spacing
                Label(kiosk.category.capitalized, systemImage: "tag.fill")
                    .font(.subheadline.bold())
                    .foregroundColor(Color.orange) // tydligare än blekgul
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                
                Label("\(kiosk.waitTime) min väntetid", systemImage: "clock.fill")
                    .font(.subheadline.bold())
                    .foregroundColor(AppGradients.candyGreen)
            }
            
            // 🔴🟢 Status-pill
            Text(kiosk.isActive ? "🟢 Öppen" : "🔴 Stängd")
                .font(.footnote.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(kiosk.isActive
                              ? AppGradients.candyGreen.opacity(0.2)
                              : Color.red.opacity(0.2))
                )
                .foregroundColor(kiosk.isActive ? AppGradients.candyGreen : .red)
        }
        .padding(.bottom, 6)
    }
    
    // MARK: - Section Title
    private var sectionTitle: some View {
        HStack {
            Text("🍭 Godis & Snacks")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [AppGradients.candyPurple, AppGradients.candyBlue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppGradients.candyPink.opacity(0.25))
                    .frame(width: 30, height: 30)
                Image(systemName: "heart.fill")
                    .foregroundColor(AppGradients.candyPink)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal)
    }
}

