//
//  HomeScreenView.swift
//  Uber Task
//

import SwiftUI

/// The MoveLab main Home screen: header, destination search, quick
/// actions, the full-services entry point, promo banners, and
/// personalized content sections.
struct HomeScreenView: View {
    @Environment(MockContentStore.self) private var store
    @Binding var path: NavigationPath

    private var viewModel: HomeViewModel { HomeViewModel(store: store) }

    var body: some View {
        content(viewModel: viewModel)
    }

    @ViewBuilder
    private func content(viewModel: HomeViewModel) -> some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                HomeHeaderView(
                    profile: viewModel.profile,
                    onProfileTypeChange: { viewModel.setProfileType($0) },
                    onNotificationsTap: {},
                    onAvatarTap: { path.append(AppRoute.prototypeLab) }
                )

                // Uber One slot sits at the top of the feed; the renew banner
                // wins over the acquisition carousel when both could apply.
                if viewModel.showsUberOneRenewBanner {
                    UberOneRenewBanner(endDate: viewModel.uberOneFreeMonthEndDate) {
                        path.append(AppRoute.uberOneUpsell)
                    }
                } else if viewModel.showsUberOneCarousel {
                    UberOneBannerCarousel(banners: viewModel.uberOneHomeBanners) { _ in
                        path.append(AppRoute.uberOneDetails)
                    }
                }

                if let topBanner = viewModel.banners(for: .homeTop).first {
                    PromoBannerView(
                        banner: topBanner,
                        onPrimaryAction: { openDeepLink(topBanner.deepLinkFeatureID) },
                        onDismiss: topBanner.isDismissible ? { viewModel.dismissBanner(topBanner) } : nil
                    )
                }

                DestinationSearchCard(
                    currentLocation: viewModel.currentLocation,
                    savedPlaces: viewModel.savedDestinations,
                    recentDestinations: viewModel.recentDestinations,
                    onSearchTap: { path.append(AppRoute.allServices) },
                    onReserveTap: { openReserve() },
                    onDestinationTap: { _ in path.append(AppRoute.allServices) }
                )

                // Quick actions are kept directly below search (no banners in
                // between) so they stay visible on the first screen.
                QuickActionGrid(features: viewModel.quickActions) { feature in
                    path.append(AppRoute.featureDetail(featureID: feature.id))
                }

                ForEach(viewModel.banners(for: .belowSearch)) { banner in
                    PromoBannerView(
                        banner: banner,
                        onPrimaryAction: { openDeepLink(banner.deepLinkFeatureID) },
                        onDismiss: banner.isDismissible ? { viewModel.dismissBanner(banner) } : nil
                    )
                }

                AllServicesEntryCard(action: { path.append(AppRoute.allServices) })

                ForEach(viewModel.banners(for: .insideServiceSection)) { banner in
                    PromoBannerView(
                        banner: banner,
                        onPrimaryAction: { openDeepLink(banner.deepLinkFeatureID) }
                    )
                }

                ForEach(viewModel.homeSections) { section in
                    PersonalizedSectionView(section: section) { card in
                        openDeepLink(card.deepLinkFeatureID)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenMargin)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColor.surfaceSecondary.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            if let banner = viewModel.banners(for: .bottomSticky).first {
                PromoBannerView(
                    banner: banner,
                    onPrimaryAction: { openDeepLink(banner.deepLinkFeatureID) },
                    onDismiss: banner.isDismissible ? { viewModel.dismissBanner(banner) } : nil
                )
                .padding(.horizontal, AppSpacing.screenMargin)
                .padding(.bottom, AppSpacing.xs)
                .background(.ultraThinMaterial)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func openDeepLink(_ featureID: UUID?) {
        guard let featureID else { return }
        path.append(AppRoute.featureDetail(featureID: featureID))
    }

    private func openReserve() {
        guard let reserve = store.allFeatures.first(where: { $0.title == "Reserve ride" }) else { return }
        path.append(AppRoute.featureDetail(featureID: reserve.id))
    }
}

#Preview("Home") {
    NavigationStack {
        HomeScreenView(path: .constant(NavigationPath()))
    }
    .environment(MockContentStore())
}

#Preview("Home - Renew banner") {
    let store = MockContentStore()
    store.startUberOneFreeMonth(billingPeriod: .monthly)
    store.setUberOneFreeMonthEnd(daysFromNow: 5)
    return NavigationStack {
        HomeScreenView(path: .constant(NavigationPath()))
    }
    .environment(store)
}

#Preview("Home - Dark") {
    NavigationStack {
        HomeScreenView(path: .constant(NavigationPath()))
    }
    .environment(MockContentStore())
    .preferredColorScheme(.dark)
}

#Preview("Home - Large Text") {
    NavigationStack {
        HomeScreenView(path: .constant(NavigationPath()))
    }
    .environment(MockContentStore())
    .environment(\.sizeCategory, .accessibilityLarge)
}
