//
//  CandyItemCard.swift
//  KioskOrders
//

import SwiftUI

struct CandyItemCard: View {
    let item: FoodItem
    let isPressed: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🔹 Översta raden (ikon + namn + sold out)
            HStack {
                Circle()
                    .fill(LinearGradient(colors: [AppGradients.candyYellow, AppGradients.candyPink],
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .frame(width: 40, height: 40)
                
                Group {
                    if item.category?.lowercased() == "candy" { Image(systemName: "heart.fill") }
                    else if item.category?.lowercased() == "icecream" { Image(systemName: "snowflake") }
                    else if item.category?.lowercased() == "drinks" { Image(systemName: "cup.and.saucer.fill") }
                    else { Image(systemName: "star.fill") }
                }
                .font(.system(size: 18))
                .foregroundColor(.white)
                
                Text(item.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                if !item.isAvailable {
                    Text("Sold Out")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                }
            }
            
            // 🔹 Beskrivning
            Text(item.description ?? "")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
            
            // 🔹 Pris + Tillagningstid
            HStack(spacing: 20) {
                Label("\(Int(item.price)) kr", systemImage: "tag.fill")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                Spacer()
                Label("\(item.preparationTime) min", systemImage: "clock.fill")
                    .font(.system(size: 14, design: .rounded))
            }
            .foregroundColor(.white.opacity(0.9))
        }
        .padding(20)
        .background(
            ZStack {
                AppGradients.cardGradient
                Circle()
                    .fill(AppGradients.candyYellow.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .offset(x: -30, y: -20)
                Circle()
                    .fill(AppGradients.candyGreen.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .offset(x: 40, y: 30)
            }
        )
        .cornerRadius(25)
        .shadow(color: AppGradients.candyPurple.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal, 15)
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}
