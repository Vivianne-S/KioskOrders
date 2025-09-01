//
//  KioskViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import Foundation

class KioskViewModel: ObservableObject {
    @Published var kiosks: [Kiosk] = []
    @Published var isLoading = false
    
    func loadKiosks() {
        isLoading = true
        Task {
            do {
                let kiosks = try await FirebaseService.shared.fetchKiosks()
                DispatchQueue.main.async {
                    self.kiosks = kiosks
                    self.isLoading = false
                }
            } catch {
                print("Error loading kiosks: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}