//
//  AppColor.swift
//  Uber Task
//

import SwiftUI

/// Semantic color tokens for the MoveLab design system.
/// Views should reference these instead of hard-coded colors so the
/// palette can be retuned in one place.
enum AppColor {
    static let surfacePrimary = Color(uiColor: .systemBackground)
    static let surfaceSecondary = Color(uiColor: .secondarySystemBackground)
    static let surfaceElevated = Color(uiColor: .systemBackground)
    static let surfaceInverted = Color(uiColor: .label)

    static let textPrimary = Color(uiColor: .label)
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let textTertiary = Color(uiColor: .tertiaryLabel)
    /// Pairs with `surfaceInverted` (black in light mode, white in dark
    /// mode) so text/icons on inverted-surface pills stay readable in
    /// both appearances.
    static let textOnInvertedSurface = Color(uiColor: .systemBackground)

    static let accentPrimary = Color("AccentPrimary", bundle: nil, fallback: .black)
    static let accentDelivery = Color("AccentDelivery", bundle: nil, fallback: .green)
    static let accentPromo = Color("AccentPromo", bundle: nil, fallback: .orange)

    static let success = Color(uiColor: .systemGreen)
    static let warning = Color(uiColor: .systemOrange)
    static let danger = Color(uiColor: .systemRed)
    static let divider = Color(uiColor: .separator)

    static let tileBackground = Color(uiColor: .secondarySystemBackground)
    static let chipBackground = Color(uiColor: .tertiarySystemBackground)
}

private extension Color {
    /// Uses a named asset color when available, otherwise falls back to a
    /// system color so the app compiles even before assets are added.
    init(_ name: String, bundle: Bundle?, fallback: Color) {
        if UIColor(named: name, in: bundle, compatibleWith: nil) != nil {
            self = Color(name, bundle: bundle)
        } else {
            self = fallback
        }
    }
}
