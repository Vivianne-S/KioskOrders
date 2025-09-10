//
//  EditFoodItemSheet.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-10.
//

import SwiftUI
import Foundation

struct EditFoodItemSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var item: FoodItem
    var onSave: (FoodItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Namn") {
                    TextField("Produktnamn", text: $item.name)
                }
                Section("Pris") {
                    TextField("Pris", value: $item.price, formatter: NumberFormatter.decimal)
                        .keyboardType(.decimalPad)
                }
                Section("Tillagningstid") {
                    TextField("Tid (minuter)", value: $item.preparationTime, formatter: NumberFormatter.integer)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Redigera vara")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Spara") {
                        onSave(item)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Formatter helpers
extension NumberFormatter {
    static var decimal: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }
    static var integer: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .none
        return f
    }
}
