//
//  AppShadow.swift
//  Uber Task
//

import SwiftUI

struct AppShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let card = AppShadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    static let raised = AppShadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 8)
    static let none = AppShadow(color: .clear, radius: 0, x: 0, y: 0)
}

extension View {
    func appShadow(_ shadow: AppShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
