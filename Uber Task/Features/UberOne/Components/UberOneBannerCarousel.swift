//
//  UberOneBannerCarousel.swift
//  Uber Task
//

import SwiftUI

/// Home acquisition carousel: paged Uber One promo slides shown while the
/// demo user has no active membership. Tapping any slide opens the
/// subscription details screen.
struct UberOneBannerCarousel: View {
    let banners: [UberOneHomeBanner]
    let onTap: (UberOneHomeBanner) -> Void

    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(banners.enumerated()), id: \.element.id) { index, banner in
                UberOneHomeBannerCard(banner: banner, onTap: { onTap(banner) })
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 168)
        .overlay(alignment: .bottom) {
            if banners.count > 1 {
                pageDots
                    .padding(.bottom, AppSpacing.sm)
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(banners.indices, id: \.self) { index in
                Circle()
                    .fill(dotColor(isActive: index == selectedIndex))
                    .frame(width: 6, height: 6)
            }
        }
        .accessibilityHidden(true)
    }

    private func dotColor(isActive: Bool) -> Color {
        let base: Color = banners.indices.contains(selectedIndex)
            && banners[selectedIndex].style == .goldHero ? .white : AppColor.textPrimary
        return base.opacity(isActive ? 0.95 : 0.35)
    }
}

/// One slide of the carousel. `goldHero` renders white-on-gold; `light`
/// renders as a gold-outlined white card, both per the reference design.
struct UberOneHomeBannerCard: View {
    let banner: UberOneHomeBanner
    let onTap: () -> Void

    private var isHero: Bool { banner.style == .goldHero }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: AppSpacing.sm) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(banner.headline)
                        .font(AppTypography.title)
                        .foregroundStyle(isHero ? .white : AppColor.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

                    Text(banner.message)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(isHero ? .white.opacity(0.9) : AppColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: AppSpacing.xs)

                    HStack(spacing: AppSpacing.xxs) {
                        Text(banner.ctaText)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(isHero ? .black : AppColor.textOnInvertedSurface)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.xs + 2)
                    .background(isHero ? Color.white : AppColor.surfaceInverted, in: Capsule())
                }

                // Reserve the right side for the photo panel on the hero slide.
                Spacer(minLength: isHero ? 132 : AppSpacing.xs)

                if !isHero {
                    Image("UberOneRingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 84, height: 84)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, AppSpacing.md + AppSpacing.xxs)
            .padding(.top, AppSpacing.md + AppSpacing.xxs)
            .padding(.bottom, AppSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 168)
            .background(isHero ? AppColor.membershipHeroBackground : AppColor.surfaceElevated)
            .overlay(alignment: .trailing) {
                if isHero {
                    Image("UberOneHeroPhoto")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 168)
                        .clipped()
                        .accessibilityHidden(true)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .overlay {
                // The light slide carries a thin gold outline in the design.
                if !isHero {
                    RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                        .strokeBorder(AppColor.membershipGold.opacity(0.6), lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(banner.headline). \(banner.message)")
        .accessibilityHint("Double tap to open Uber One details")
    }
}

#Preview {
    UberOneBannerCarousel(banners: MockUberOne.homeBanners, onTap: { _ in })
        .padding()
        .background(AppColor.surfaceSecondary)
}

#Preview("Hero slide") {
    UberOneHomeBannerCard(banner: MockUberOne.homeBanners[1], onTap: {})
        .padding()
        .background(AppColor.surfaceSecondary)
}

#Preview("Dark") {
    UberOneBannerCarousel(banners: MockUberOne.homeBanners, onTap: { _ in })
        .padding()
        .background(AppColor.surfaceSecondary)
        .preferredColorScheme(.dark)
}
