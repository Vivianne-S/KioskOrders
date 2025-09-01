//
//  TestView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-01.
//


import SwiftUI
import FirebaseFirestore
import FirebaseCore

struct TestView: View {
    @State private var isConnected = false
    @State private var errorMessage: String?
    @State private var testKioskAdded = false
    
    var body: some View {
        VStack(spacing: 20) {
            if isConnected {
                Text("✅ Ansluten till Firebase")
                    .foregroundColor(.green)
                    .font(.headline)
                
                if testKioskAdded {
                    Text("✅ Testkiosk tillagd i Firestore")
                        .foregroundColor(.green)
                }
            } else if let error = errorMessage {
                Text("❌ Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Testar Firebase-anslutning...")
            }
            
            Button("Testa Firebase Connection") {
                testFirebaseConnection()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Testa Firestore") {
                testFirestore()
            }
            .buttonStyle(.bordered)
            .disabled(!isConnected)
        }
        .padding()
        .onAppear {
            testFirebaseConnection()
        }
    }
    
    private func testFirebaseConnection() {
        // Testa att Firebase är konfigurerat
        if FirebaseApp.app() != nil {
            isConnected = true
            errorMessage = nil
            print("✅ Firebase är konfigurerat")
        } else {
            errorMessage = "Firebase är inte konfigurerat"
        }
    }
    
    private func testFirestore() {
        let db = Firestore.firestore()
        
        // Skapa en testkiosk
        let testKiosk: [String: Any] = [
            "name": "TestKiosk",
            "description": "Detta är en testkiosk",
            "category": "test",
            "isActive": true,
            "waitTime": 5,
            "testTimestamp": Date()
        ]
        
        // Lägg till i Firestore
        db.collection("kiosks").document("test_kiosk").setData(testKiosk) { error in
            if let error = error {
                self.errorMessage = "Firestore error: \(error.localizedDescription)"
                print("❌ Firestore error: \(error)")
            } else {
                self.testKioskAdded = true
                print("✅ Testkiosk tillagd i Firestore")
                
                // Ta bort testkiosken efter 5 sekunder
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    db.collection("kiosks").document("test_kiosk").delete()
                    print("🧹 Testkiosk borttagen")
                }
            }
        }
    }
}
