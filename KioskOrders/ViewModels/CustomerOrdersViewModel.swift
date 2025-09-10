//
//  CustomerOrdersViewModel.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-05.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CustomerOrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func listenForUserOrders() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        listener?.remove()
        listener = db.collection("orders")
            .whereField("userId", isEqualTo: uid)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Kunde inte hämta användarens ordrar: \(error.localizedDescription)")
                    return
                }
                self?.orders = snapshot?.documents.compactMap {
                    try? $0.data(as: Order.self)
                } ?? []
            }
    }
}
