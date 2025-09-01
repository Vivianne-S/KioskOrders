//
//  KioskDetailView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI
import FirebaseFirestore

struct KioskDetailView: View {
    let kiosk: Kiosk
    @State private var foodItems: [FoodItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                // MARK: Kiosk Header
                ZStack {
                    LinearGradient(colors: [.pink, .purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .cornerRadius(30)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 10) {
                        Text(kiosk.name)
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                        Text(kiosk.description)
                            .font(.title3)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                // MARK: Matvaror
                Text("🍭 Matvaror")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .shadow(color: .orange.opacity(0.6), radius: 3, x: 0, y: 2)
                    .padding(.horizontal)
                
                // MARK: Loading / Error
                if isLoading {
                    ProgressView("Laddar matvaror...")
                        .padding()
                        .foregroundColor(.purple)
                } else if let error = errorMessage {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if foodItems.isEmpty {
                    Text("Ingen mat tillgänglig just nu 😢")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // MARK: Food Items
                    LazyVStack(spacing: 20) {
                        ForEach(foodItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "candybar")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow)
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                HStack {
                                    Text("Pris: \(Int(item.price)) kr")
                                    Spacer()
                                    Text("Tid: \(item.preparationTime) min")
                                }
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.orange, .pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .purple.opacity(0.6), radius: 8, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.yellow.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                
            }
            .padding(.vertical)
        }
        .navigationTitle(kiosk.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchFoodItems(for: kiosk.id ?? "")
        }
    }
    
    private func fetchFoodItems(for kioskId: String) {
        isLoading = true
        errorMessage = nil
        
        db.collection("fooditems")
            .whereField("availableAt", arrayContains: kioskId)
            .getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.foodItems = []
                    return
                }
                
                self.foodItems = documents.compactMap { doc in
                    try? doc.data(as: FoodItem.self)
                }
            }
    }
}
