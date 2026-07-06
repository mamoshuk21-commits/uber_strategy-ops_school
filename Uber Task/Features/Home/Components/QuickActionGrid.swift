//
//  QuickActionGrid.swift
//  Uber Task
//

import SwiftUI

/// Dense grid of the top-level services (Ride, Food, Grocery, ...).
/// This is the primary above-the-fold action surface on Home.
struct QuickActionGrid: View {
    let features: [ServiceFeature]
    let onSelect: (ServiceFeature) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.gridSpacing),
        GridItem(.flexible(), spacing: AppSpacing.gridSpacing),
        GridItem(.flexible(), spacing: AppSpacing.gridSpacing),
        GridItem(.flexible(), spacing: AppSpacing.gridSpacing),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.gridSpacing) {
            ForEach(features) { feature in
                QuickActionTile(feature: feature, action: { onSelect(feature) })
            }
        }
    }
}

struct QuickActionTile: View {
    let feature: ServiceFeature
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: feature.systemImage)
                        .font(.system(size: AppMetrics.quickActionIconSize, weight: .medium))
                        .foregroundStyle(AppColor.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)

                    if let badge = feature.badge {
                        Circle()
                            .fill(badgeColor(for: badge))
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
                Text(feature.title)
                    .font(AppTypography.caption.weight(.medium))
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, AppSpacing.xs)
            .frame(height: AppMetrics.quickActionTileHeight)
            .frame(maxWidth: .infinity)
            .background(AppColor.tileBackground, in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Double tap to open \(feature.title)")
    }

    private var accessibilityLabel: String {
        if let badge = feature.badge {
            return "\(feature.title), \(badge.label)"
        }
        return feature.title
    }

    private func badgeColor(for badge: ServiceBadge) -> Color {
        switch badge {
        case .promo: AppColor.accentPromo
        case .new: AppColor.success
        case .popular: AppColor.textPrimary
        case .scheduled: .blue
        case .business: .purple
        }
    }
}

#Preview {
    QuickActionGrid(features: Array(MockServices.all.filter(\.isQuickAction).prefix(8)), onSelect: { _ in })
        .padding()
        .background(AppColor.surfaceSecondary)
}
