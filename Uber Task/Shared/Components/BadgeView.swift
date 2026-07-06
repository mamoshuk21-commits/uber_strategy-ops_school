//
//  BadgeView.swift
//  Uber Task
//

import SwiftUI

/// Small colored pill used to flag promo/new/popular/scheduled/business
/// items across the catalog.
struct BadgeView: View {
    let badge: ServiceBadge

    var body: some View {
        Text(badge.label)
            .font(AppTypography.captionEmphasized)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, AppSpacing.xs)
            .padding(.vertical, 3)
            .background(backgroundColor, in: Capsule())
            .accessibilityLabel("\(badge.label) badge")
    }

    private var backgroundColor: Color {
        switch badge {
        case .promo: AppColor.accentPromo.opacity(0.16)
        case .new: AppColor.success.opacity(0.16)
        case .popular: AppColor.accentPrimary.opacity(0.12)
        case .scheduled: Color.blue.opacity(0.14)
        case .business: Color.purple.opacity(0.14)
        }
    }

    private var foregroundColor: Color {
        switch badge {
        case .promo: AppColor.accentPromo
        case .new: AppColor.success
        case .popular: AppColor.textPrimary
        case .scheduled: Color.blue
        case .business: Color.purple
        }
    }
}

#Preview {
    HStack {
        BadgeView(badge: .promo)
        BadgeView(badge: .new)
        BadgeView(badge: .popular)
        BadgeView(badge: .scheduled)
        BadgeView(badge: .business)
    }
    .padding()
}
