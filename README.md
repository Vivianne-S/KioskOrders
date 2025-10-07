# KioskOrders

A modern iOS application for managing kiosk orders in amusement parks, cafés, or similar environments.  
Developed with **SwiftUI**, **Firebase Firestore**, and an **MVVM architecture**.

---

## Overview

**KioskOrders** provides a digital ordering platform where customers can browse and order from multiple kiosks within a park.  
Employees log in to the app to view and manage incoming orders for their assigned kiosk in real time.

The goal is to simplify the communication between customers and staff, replacing manual order handling with a smooth, digital experience.

---

## Features

### For Customers
- Browse available kiosks in the park.  
- View menus, product details, and prices.  
- Add items to a cart and place an order.  
- Receive confirmation when the order has been sent.

### For Employees
- Log in with a dedicated employee account.  
- View only the orders assigned to their kiosk.  
- See new orders in real time via Firestore listeners.  
- Approve orders and set pickup times.

---

## Technical Overview

| Layer | Technology |
|-------|-------------|
| **Frontend** | SwiftUI, MVVM |
| **Backend** | Firebase Firestore & Firebase Authentication |
| **Realtime Updates** | Firestore SnapshotListeners |
| **Data Models** | Codable structs for `Kiosk`, `FoodItem`, `Order`, and `OrderItem` |
| **Design** | Minimal and responsive SwiftUI layout |

---

## Project Structure

KioskOrders/
├── Models/
│   ├── Kiosk.swift
│   ├── FoodItem.swift
│   ├── Order.swift
├── ViewModels/
│   ├── AuthenticationViewModel.swift
│   ├── OrdersViewModel.swift
│   ├── KioskViewModel.swift
│   ├── OrderPlacementViewModel.swift
├── Views/
│   ├── LoginView.swift
│   ├── KioskListView.swift
│   ├── KioskDetailView.swift
│   ├── EmployeeOrdersView.swift
│   ├── CartView.swift
│   ├── Components/
│       ├── CartButton.swift
│       ├── CandyItemCard.swift
│       ├── KioskCardView.swift
├── Services/
│   ├── FirebaseService.swift
│   └── AppGradients.swift
└── Assets/


---

## Firestore Security Rules

- Customers can only read and update their own orders.  
- Employees can only view and manage orders for their assigned kiosk.  
- Administrators have full access to all documents.

---

## Installation

1. Clone the repository:
2. ```bash
    git clone https://github.com/Vivianne-S/KioskOrders.git

3. open KioskOrders.xcodeproj
4. pod install

	5.	Add your GoogleService-Info.plist file from Firebase to the project.
	6.	Run the application in the simulator or on a physical device.

Test Accounts:
Customer
test@test.se
123456
-

Employee
em@ans.se
123456
Glassbaren

Admin
admin@kioskorders.com
123456
All
