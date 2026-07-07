//
//  AppTypography.swift
//  Uber Task
//

import SwiftUI

/// Type scale for MoveLab. All sizes use Dynamic Type-relative text styles
/// so the app scales correctly with the user's preferred content size.
/// Display styles are bold in the default grotesque SF design — rounded
/// faces read too soft for the flat, high-contrast mobility aesthetic.
enum AppTypography {
    static let largeTitle = Font.system(.largeTitle).weight(.bold)
    static let title = Font.system(.title2).weight(.bold)
    static let sectionTitle = Font.system(.title3).weight(.bold)
    static let headline = Font.system(.headline)
    static let body = Font.system(.body)
    static let bodyEmphasized = Font.system(.body).weight(.semibold)
    static let subheadline = Font.system(.subheadline)
    static let caption = Font.system(.caption)
    static let captionEmphasized = Font.system(.caption).weight(.semibold)
    static let footnote = Font.system(.footnote)
}
