//
//  PlaceholderDetailView.swift
//  Uber Task
//

import SwiftUI

/// Generic, polished placeholder used for every screen that isn't built
/// out yet (feature detail, activity detail, etc). Keeping this shared
/// means new destinations can be wired up with a single call site.
struct PlaceholderDetailView: View {
    let title: String
    let subtitle: String
    var statusLabel: String = "Prototype preview"
    var ctaText: String = "Continue"
    var systemImage: String = "sparkles"
    var banner: PromoBanner? = nil
    var onCTA: () -> Void = {}
    var onBannerTap: () -> Void = {}
    var onBannerDismiss: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                if let banner {
                    PromoBannerView(banner: banner, onPrimaryAction: onBannerTap, onDismiss: onBannerDismiss)
                }

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(statusLabel.uppercased())
                        .font(AppTypography.captionEmphasized)
                        .foregroundStyle(AppColor.textSecondary)
                        .padding(.horizontal, AppSpacing.xs)
                        .padding(.vertical, 4)
                        .background(AppColor.chipBackground, in: Capsule())

                    Text(title)
                        .font(AppTypography.largeTitle)
                        .foregroundStyle(AppColor.textPrimary)

                    Text(subtitle)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.textSecondary)
                }

                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .fill(AppColor.tileBackground)
                    .frame(height: 200)
                    .overlay {
                        Image(systemName: systemImage)
                            .font(.system(size: 44, weight: .light))
                            .foregroundStyle(AppColor.textTertiary)
                    }
                    .accessibilityHidden(true)

                Spacer(minLength: AppSpacing.lg)

                Button(action: onCTA) {
                    Text(ctaText)
                        .font(AppTypography.bodyEmphasized)
                        .foregroundStyle(AppColor.textOnInvertedSurface)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppMetrics.minTapTarget + 4)
                        .background(AppColor.surfaceInverted, in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                }
                .accessibilityLabel(ctaText)
            }
            .padding(AppSpacing.screenMargin)
        }
        .background(AppColor.surfaceSecondary.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlaceholderDetailView(
            title: "Ride now",
            subtitle: "Get a ride in minutes. This screen is a prototype placeholder for the full ride booking flow.",
            systemImage: "car.fill"
        )
    }
}
