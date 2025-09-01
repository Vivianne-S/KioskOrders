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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(kioskVM.kiosks) { kiosk in
                        NavigationLink(destination: KioskDetailView(kiosk: kiosk)) {
                            ZStack {
                                LinearGradient(
                                    colors: [.pink, .purple, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .cornerRadius(25)
                                .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 5)

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "cart.fill")
                                            .resizable()
                                            .frame(width: 35, height: 30)
                                            .foregroundColor(.yellow)
                                        Text(kiosk.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }

                                    Text(kiosk.description)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))

                                    HStack {
                                        Text("⏱ \(kiosk.waitTime) min väntetid")
                                        Spacer()
                                        Text("Kategori: \(kiosk.category.capitalized)")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("🍭 Kiosker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Logga ut") {
                    authVM.signOut()
                }
                .foregroundColor(.pink)
            }
            .onAppear {
                kioskVM.loadKiosks()
            }
        }
    }
}
