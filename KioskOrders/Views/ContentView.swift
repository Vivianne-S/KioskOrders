//
//  ContentView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//



import SwiftUI


struct ContentView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                KioskListView() // 👈 Visa listan när man är inloggad
            } else {
                LoginView() // 👈 Annars logga in
            }
        }
    }
}


//import SwiftUI

//struct ContentView: View {
  //  var body: some View {
    //    TestView() // ← Använd TestView temporärt
    //}
//}
