//
//  UberOneAccountSavingsRow.swift
//  Uber Task
//

import SwiftUI

/// Account tab row shown while a membership (free month or paid) is active:
/// current plan/status plus the mock total saved with Uber One.
struct UberOneAccountSavingsRow: View {
    let membership: UberOneMembership
    let savings: UberOneSavingsSummary

    private var statusText: String {
        switch membership.state {
        case .freeMonth:
            "Free month · ends \(membership.freeMonthEndDate.formatted(date: .abbreviated, time: .omitted))"
        case .paidActive:
            "\((membership.plan ?? .standard).displayName) · \(membership.billingPeriod.displayName)"
        case .notSubscribed, .expired:
            "Not subscribed"
        }
    }

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "circle.circle")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppColor.membershipGold)
                .frame(width: 36, height: 36)
                .background(AppColor.membershipGold.opacity(0.12), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Uber One")
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColor.textPrimary)
                Text(statusText)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                Text("You've saved \(savings.total.uberOnePriceText)")
                    .font(AppTypography.captionEmphasized)
                    .foregroundStyle(AppColor.membershipGold)
            }
        }
        .padding(.vertical, AppSpacing.xxs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Uber One. \(statusText). You've saved \(savings.total.uberOnePriceText)")
    }
}

#Preview {
    List {
        UberOneAccountSavingsRow(
            membership: UberOneMembership(
                state: .freeMonth,
                plan: .standard,
                billingPeriod: .monthly,
                freeMonthEndDate: .now.addingTimeInterval(20 * 86_400)
            ),
            savings: MockUberOne.defaultSavings
        )
    }
}
