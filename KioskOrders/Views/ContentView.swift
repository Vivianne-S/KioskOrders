//
//  ContentView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel

    var body: some View {
        if authVM.isAuthenticated {
            // ✅ Inloggad → gå till rätt vy (kund eller employee)
            MainOrdersView()
        } else {
            // ❌ Inte inloggad → visa login
            LoginView()
        }
    }
}
