//
//  CardBackground.swift
//  Uber Task
//

import SwiftUI

/// Shared white rounded-card treatment so cards stay visually consistent
/// without repeating modifiers at every call site.
struct CardBackground: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.lg
    var shadow: AppShadow = .card

    func body(content: Content) -> some View {
        content
            .background(AppColor.surfaceElevated, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .appShadow(shadow)
    }
}

extension View {
    func cardBackground(cornerRadius: CGFloat = AppRadius.lg, shadow: AppShadow = .card) -> some View {
        modifier(CardBackground(cornerRadius: cornerRadius, shadow: shadow))
    }
}
