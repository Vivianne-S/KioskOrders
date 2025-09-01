//
//  KioskOrdersApp.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//

import SwiftUI
import FirebaseCore

@main
struct KioskOrdersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthenticationViewModel()
    @StateObject private var kioskVM = KioskViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environmentObject(kioskVM) 
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        print("✅ Firebase konfigurerad!")
        return true
    }
}
