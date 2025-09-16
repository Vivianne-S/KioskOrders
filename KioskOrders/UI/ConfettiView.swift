//
//  ConfettiView.swift
//  KioskOrders
//
//  Created by Vivianne Sonnerborg on 2025-09-16.
//

import SwiftUI

struct ConfettiView: View {
    @Binding var trigger: Bool
    @State private var particles: [ConfettiParticleData] = []

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ConfettiParticle(data: particle)
            }
        }
        .allowsHitTesting(false)
        .onChange(of: trigger) {
            if trigger {
                spawnConfetti(count: 60) // 🎉 antal partiklar
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    particles.removeAll()
                    trigger = false
                }
            }
        }
    }

    // MARK: - Helpers
    private func spawnConfetti(count: Int) {
        for _ in 0..<count {
            let shape = ConfettiShape.allCases.randomElement()!
            let color = CandyTheme.colors.randomElement()!
            let size = CGFloat.random(in: 8...18)
            particles.append(
                ConfettiParticleData(
                    shape: shape,
                    color: color,
                    size: size,
                    id: UUID()
                )
            )
        }
    }
}

// MARK: - Data Model
private struct ConfettiParticleData: Identifiable {
    let shape: ConfettiShape
    let color: Color
    let size: CGFloat
    let id: UUID
}

private enum ConfettiShape: CaseIterable {
    case circle, star, square, triangle
}

// MARK: - Particle View
private struct ConfettiParticle: View {
    let data: ConfettiParticleData

    @State private var xOffset: CGFloat = .random(in: -150...150)
    @State private var yOffset: CGFloat = -600
    @State private var angle: Double = .random(in: 0...360)

    var body: some View {
        shapeView
            .frame(width: data.size, height: data.size)
            .rotationEffect(.degrees(angle))
            .offset(x: xOffset, y: yOffset)
            .opacity(0.9)
            .onAppear {
                withAnimation(.easeIn(duration: .random(in: 2.5...4))) {
                    yOffset = 600
                }
                withAnimation(.linear(duration: .random(in: 2...4))) {
                    xOffset += .random(in: -120...120)
                    angle += .random(in: 720...1440)
                }
            }
    }

    // MARK: - Shape Builder (returnerar AnyView)
    private var shapeView: some View {
        switch data.shape {
        case .circle:
            return AnyView(Circle().fill(data.color))
        case .star:
            return AnyView(StarShape(points: 5).fill(data.color))
        case .square:
            return AnyView(Rectangle().fill(data.color))
        case .triangle:
            return AnyView(TriangleShape().fill(data.color))
        }
    }
}

// MARK: - Custom Shapes
private struct StarShape: Shape {
    let points: Int
    func path(in rect: CGRect) -> Path {
        guard points >= 2 else { return Path() }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        var angle: CGFloat = -.pi / 2
        let step = .pi * 2 / CGFloat(points * 2)

        let radius = min(rect.width, rect.height) / 2
        var firstPoint = true

        for i in 0..<points * 2 {
            let r = i % 2 == 0 ? radius : radius / 2
            let x = center.x + r * cos(angle)
            let y = center.y + r * sin(angle)
            if firstPoint {
                path.move(to: CGPoint(x: x, y: y))
                firstPoint = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            angle += step
        }
        path.closeSubpath()
        return path
    }
}

private struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
