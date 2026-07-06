//
//  AppSpacing.swift
//  Uber Task
//

import CoreGraphics

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32

    /// Outer horizontal margin used on every screen.
    static let screenMargin: CGFloat = 16
    /// Standard spacing between grid tiles / cards.
    static let gridSpacing: CGFloat = 12
}

enum AppRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let pill: CGFloat = 999
}

enum AppMetrics {
    static let searchFieldHeight: CGFloat = 60
    static let quickActionTileHeight: CGFloat = 96
    static let quickActionIconSize: CGFloat = 26
    static let savedPlaceRowHeight: CGFloat = 52
    static let avatarSize: CGFloat = 40
    static let iconButtonSize: CGFloat = 40
    static let bannerHeight: CGFloat = 108
    static let suggestionCardWidth: CGFloat = 148
    static let suggestionCardHeight: CGFloat = 132
    static let minTapTarget: CGFloat = 44
}
