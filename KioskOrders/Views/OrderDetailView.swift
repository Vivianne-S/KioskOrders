//
//  OrderDetailView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-08.
//




// Ny OrderDetailView för att markera ordrar som redo
struct OrderDetailView: View {
    @State var order: Order
    @State private var readyTime = Date()
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var ordersVM = OrdersViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Orderinformation")) {
                Text("Order #\(order.id?.prefix(6) ?? "okänd")")
                Text("Status: \(order.status.uppercased())")
                    .foregroundColor(order.status == "ready" ? .green : .orange)
                Text("Skapad: \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")
            }
            
            Section(header: Text("Produkter")) {
                ForEach(order.items, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) st")
                    }
                }
            }
            
            if order.status != "ready" {
                Section(header: Text("Markera som redo")) {
                    DatePicker("Redo kl:", selection: $readyTime, displayedComponents: .hourAndMinute)
                    
                    Button(action: markAsReady) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Markera som redo för avhämtning")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.green)
                }
            } else if let readyAt = order.readyAt {
                Section(header: Text("Redo för avhämtning")) {
                    Text("Ordern är markerad som redo")
                    Text("Redo sedan: \(readyAt.formatted(date: .omitted, time: .shortened))")
                }
            }
        }
        .navigationTitle("Orderdetaljer")
    }
    
    func markAsReady() {
        ordersVM.markOrderAsReady(orderId: order.id ?? "", readyTime: readyTime) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}