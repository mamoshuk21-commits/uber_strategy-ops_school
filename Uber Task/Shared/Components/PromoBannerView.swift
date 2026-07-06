//
//  PromoBannerView.swift
//  Uber Task
//

import SwiftUI

/// Reusable, data-driven banner card. Any screen can render a
/// `PromoBanner` by placement using this view — the visual style adapts
/// to `banner.type` while layout stays identical everywhere.
struct PromoBannerView: View {
    let banner: PromoBanner
    var onPrimaryAction: () -> Void = {}
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: banner.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 44, height: 44)
                .background(iconColor.opacity(0.14), in: RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(banner.title)
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                Text(banner.subtitle)
                    .font(AppTypography.footnote)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: AppSpacing.xs)

            if let ctaText = banner.ctaText {
                Text(ctaText)
                    .font(AppTypography.captionEmphasized)
                    .foregroundStyle(AppColor.textOnInvertedSurface)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(AppColor.surfaceInverted, in: Capsule())
            }

            if banner.isDismissible, let onDismiss {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(width: 22, height: 22)
                        .background(AppColor.chipBackground, in: Circle())
                }
                .accessibilityLabel("Dismiss \(banner.title)")
            }
        }
        .padding(AppSpacing.sm)
        .cardBackground()
        .contentShape(Rectangle())
        .onTapGesture(perform: onPrimaryAction)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(banner.title). \(banner.subtitle)")
        .accessibilityHint(banner.ctaText.map { "Double tap to \($0.lowercased())" } ?? "")
        .accessibilityAddTraits(.isButton)
    }

    private var iconColor: Color {
        switch banner.type {
        case .promo, .rideDiscount: AppColor.accentPromo
        case .deliveryDeal: AppColor.accentDelivery
        case .membership: Color.purple
        case .warning: AppColor.warning
        case .information, .experiment: AppColor.textPrimary
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        ForEach(MockBanners.all) { banner in
            PromoBannerView(banner: banner, onDismiss: {})
        }
    }
    .padding()
    .background(AppColor.surfaceSecondary)
}
