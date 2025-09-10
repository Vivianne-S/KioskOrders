//
//  MainOrdersView.swift
//  KioskOrders
//

import SwiftUI

struct MainOrdersView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @EnvironmentObject var kioskVM: KioskViewModel

    @State private var cartItems: [FoodItem] = []

    var body: some View {
        if authVM.isAdmin {
            // 👑 Admin-vy
            NavigationView {
                AdminDashboardView()
                    .navigationTitle("Adminpanel")
                    .navigationBarItems(trailing: Button("Logga ut") {
                        authVM.signOut()
                    })
            }
        } else if authVM.isEmployee, let kioskId = authVM.employeeKioskId {
            // 👩‍🍳 Personal-vy
            NavigationView {
                EmployeeOrdersView(kioskId: kioskId)
                    .navigationTitle("Inkomna ordrar")
                    .navigationBarItems(trailing: Button("Logga ut") {
                        authVM.signOut()
                    })
            }
        } else {
            // 🧑 Kund-vy
            TabView {
                NavigationView {
                    KioskListView()
                        .navigationTitle("Kiosker")
                        .navigationBarItems(trailing: Button("Logga ut") {
                            authVM.signOut()
                        })
                }
                .tabItem {
                    Label("Kiosker", systemImage: "cart")
                }

                NavigationView {
                    CustomerOrdersView()
                        .navigationTitle("Mina ordrar")
                        .navigationBarItems(trailing: Button("Logga ut") {
                            authVM.signOut()
                        })
                }
                .tabItem {
                    Label("Mina ordrar", systemImage: "list.bullet")
                }
            }
        }
    }
}
