
//
//  OrdersViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

@MainActor
class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    deinit { listener?.remove() }

    func listenForOrders(kioskId: String) {
        listener?.remove()
        let uid = Auth.auth().currentUser?.uid ?? "-"
        print("👂 Startar orders-lyssnare kioskId=\(kioskId)  uid=\(uid)")

        listener = db.collection("orders")
            .whereField("kioskId", isEqualTo: kioskId)
            .addSnapshotListener { [weak self] snap, err in
                guard let self = self else { return }
                if let err = err {
                    print("❌ Snapshot error: \(err.localizedDescription)")
                    self.orders = []
                    return
                }

                let docs = snap?.documents ?? []
                print("📥 Snapshot \(docs.count) dokument")
                for d in docs {
                    let kid = d.get("kioskId") ?? "-"
                    let st  = d.get("status")  ?? "-"
                    print("• \(d.documentID)  kioskId=\(kid)  status=\(st)")
                }

                self.orders = docs.compactMap { try? $0.data(as: Order.self) }
                print("✅ Decodade \(self.orders.count) ordrar")
            }
    }

    func approveOrder(orderId: String, pickupTime: Date) {
        db.collection("orders").document(orderId).updateData([
            "status": "approved",
            "pickupTime": Timestamp(date: pickupTime)
        ]) { err in
            if let err = err {
                print("❌ Approve error: \(err.localizedDescription)")
            } else {
                print("✅ Order \(orderId) godkänd")
            }
        }
    }

    // Ny funktion: Markera order som redo
    func markOrderAsReady(orderId: String, readyTime: Date, completion: @escaping (Bool) -> Void) {
        db.collection("orders").document(orderId).updateData([
            "status": "ready",
            "readyAt": Timestamp(date: readyTime)
        ]) { error in
            if let error = error {
                print("❌ Error marking order as ready: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Order \(orderId) markerad som redo")
                self.sendNotificationForReadyOrder(orderId: orderId)
                completion(true)
            }
        }
    }

    // Skicka notifikation för order som blivit redo
    private func sendNotificationForReadyOrder(orderId: String) {
        // Hämta orderinformation för att få användar-ID
        db.collection("orders").document(orderId).getDocument { document, error in
            if let document = document, document.exists {
                let userId = document.get("userId") as? String ?? ""
                self.sendNotificationToUser(userId: userId, orderId: orderId)
            }
        }
    }

    private func sendNotificationToUser(userId: String, orderId: String) {
        // Hämta användarens FCM-token från Firestore
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let fcmToken = document.get("fcmToken") as? String {
                    self.sendPushNotification(to: fcmToken, orderId: orderId)
                }
            }
            
            // Skicka alltid en lokal notifikation också
            self.sendLocalNotification(orderId: orderId)
        }
    }

    private func sendLocalNotification(orderId: String) {
        let content = UNMutableNotificationContent()
        content.title = "Din order är redo!"
        content.body = "Order #\(orderId.prefix(6)) är redo för avhämtning."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: orderId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error showing notification: \(error.localizedDescription)")
            } else {
                print("✅ Local notification sent for order \(orderId)")
            }
        }
    }

    private func sendPushNotification(to token: String, orderId: String) {
        // Implementera Firebase Cloud Messaging här
        // Detta kräver ytterligare konfiguration med Cloud Functions
        print("📲 Would send push notification to token: \(token) for order: \(orderId)")
    }
}
