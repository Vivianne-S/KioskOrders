

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
            List(kioskVM.kiosks) { kiosk in
                VStack(alignment: .leading) {
                    Text(kiosk.name).font(.headline)
                    Text(kiosk.description).font(.subheadline)
                }
            }
            .navigationTitle("Kiosker")
            .toolbar {
                Button("Logga ut") {
                    authVM.signOut()
                }
            }
            .onAppear {
                kioskVM.loadKiosks()
            }
        }
    }
}
