//
//  UberOneRenewBanner.swift
//  Uber Task
//

import SwiftUI

/// Gold Home banner shown within 7 days of the free month ending:
/// "Your membership ends on <date>" with a Renew action that opens the
/// renewal upsell screen. Text stays black because the background is a
/// fixed gold in both appearances.
struct UberOneRenewBanner: View {
    let endDate: Date
    let onRenew: () -> Void

    var body: some View {
        Button(action: onRenew) {
            HStack(spacing: AppSpacing.sm) {
                Text("Your membership ends on \(endDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: AppSpacing.xs)

                Text("Renew")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(.black)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.xs)
                    .background(.white.opacity(0.55), in: Capsule())
            }
            .padding(AppSpacing.md)
            .background(
                AppColor.membershipRenewBackground,
                in: RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Your Uber One membership ends on \(endDate.formatted(date: .long, time: .omitted))")
        .accessibilityHint("Double tap to renew your membership")
    }
}

#Preview {
    UberOneRenewBanner(endDate: .now.addingTimeInterval(5 * 86_400), onRenew: {})
        .padding()
        .background(AppColor.surfaceSecondary)
}
