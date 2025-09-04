//
//  CartView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-02.
//

import SwiftUI

struct CartView: View {
    // MARK: - Bindings
    @Binding var cartItems: [FoodItem]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // MARK: - Empty Cart
                if cartItems.isEmpty {
                    ZStack {
                        AppGradients.background
                            .ignoresSafeArea()
                        
                        // MARK: Decorative Circles
                        Circle()
                            .fill(AppGradients.candyYellow.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .offset(x: -50, y: -100)
                        
                        Circle()
                            .fill(AppGradients.candyGreen.opacity(0.15))
                            .frame(width: 60, height: 60)
                            .offset(x: 70, y: 80)
                        
                        VStack(spacing: 20) {
                            Image(systemName: "cart")
                                .font(.system(size: 60))
                                .foregroundColor(AppGradients.candyPink)
                            Text("Your cart is empty")
                                .font(.title2)
                                .foregroundColor(AppGradients.candyPurple)
                        }
                        .padding()
                    }
                    Spacer()
                    
                // MARK: - Cart Items
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(cartItems) { item in
                                
                                // MARK: - Single Cart Item Row
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [AppGradients.candyYellow, AppGradients.candyPink],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "cart.fill")
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(Int(item.price)) kr • \(item.preparationTime) min")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
                                            cartItems.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(AppGradients.cardGradient)
                                .cornerRadius(20)
                                .shadow(color: AppGradients.candyPurple.opacity(0.4), radius: 5, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    // MARK: - Total Price
                    HStack {
                        Text("Total:")
                            .font(.title2).bold()
                        Spacer()
                        let total = cartItems.reduce(0) { $0 + $1.price }
                        Text("\(Int(total)) kr")
                            .font(.title2).bold()
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Checkout Button
                    Button(action: {
                        print("✅ Order placed")
                        cartItems.removeAll()
                    }) {
                        Text("Checkout Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppGradients.fabGradient)
                            .cornerRadius(25)
                            .shadow(color: AppGradients.candyPurple.opacity(0.4), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            // MARK: - Navigation
            .navigationTitle("🛒 Your Cart")
        }
    }
}
