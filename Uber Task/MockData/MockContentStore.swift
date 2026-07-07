//
//  MockContentStore.swift
//  Uber Task
//

import Foundation
import Observation

/// Single in-memory source of truth for all prototype content:
/// the mock user, catalog, banners, and the feature-flag context
/// (region / user type / experiment variant) that Prototype Lab can
/// mutate at runtime. No networking or persistence is involved.
@Observable
final class MockContentStore {
    var userProfile: UserProfile
    var region: AppRegion
    var experimentVariant: ExperimentVariant

    let savedDestinations: [Destination]
    let recentDestinations: [Destination]
    let currentLocation: Destination

    let allFeatures: [ServiceFeature]
    let allBanners: [PromoBanner]
    let homeSections: [HomeSection]

    var dismissedBannerIDs: Set<UUID> = []
    var disabledFeatureIDs: Set<UUID> = []

    var uberOneMembership: UberOneMembership
    var uberOneSavings: UberOneSavingsSummary
    var uberOneRenewBannerMode: UberOneRenewBannerMode = .automatic
    let uberOneHomeBanners: [UberOneHomeBanner]

    init(
        userProfile: UserProfile = MockUser.demo,
        region: AppRegion = .ukraine,
        experimentVariant: ExperimentVariant = .control,
        savedDestinations: [Destination] = MockDestinations.saved,
        recentDestinations: [Destination] = MockDestinations.recent,
        currentLocation: Destination = MockDestinations.currentLocation,
        allFeatures: [ServiceFeature] = MockServices.all,
        allBanners: [PromoBanner] = MockBanners.all,
        homeSections: [HomeSection] = MockHomeSections.all,
        uberOneMembership: UberOneMembership = MockUberOne.initialMembership,
        uberOneSavings: UberOneSavingsSummary = MockUberOne.defaultSavings,
        uberOneHomeBanners: [UberOneHomeBanner] = MockUberOne.homeBanners
    ) {
        self.userProfile = userProfile
        self.region = region
        self.experimentVariant = experimentVariant
        self.savedDestinations = savedDestinations
        self.recentDestinations = recentDestinations
        self.currentLocation = currentLocation
        self.allFeatures = allFeatures
        self.allBanners = allBanners
        self.homeSections = homeSections
        self.uberOneMembership = uberOneMembership
        self.uberOneSavings = uberOneSavings
        self.uberOneHomeBanners = uberOneHomeBanners
    }

    var userType: UserType { userProfile.profileType }

    // MARK: - Features

    func isVisible(_ feature: ServiceFeature) -> Bool {
        !disabledFeatureIDs.contains(feature.id)
            && feature.availability.isAvailable(region: region, userType: userType, variant: experimentVariant)
    }

    var visibleFeatures: [ServiceFeature] {
        allFeatures.filter(isVisible)
    }

    /// Home quick-action tiles, in the fixed product order.
    var quickActions: [ServiceFeature] {
        let candidates = visibleFeatures.filter(\.isQuickAction)
        return MockServices.quickActionTitleOrder.compactMap { title in
            candidates.first(where: { $0.title == title })
        }
    }

    func features(in category: ServiceCategoryKind) -> [ServiceFeature] {
        visibleFeatures.filter { $0.category == category }
    }

    func feature(withID id: UUID?) -> ServiceFeature? {
        guard let id else { return nil }
        return allFeatures.first(where: { $0.id == id })
    }

    func setFeature(_ feature: ServiceFeature, enabled: Bool) {
        if enabled {
            disabledFeatureIDs.remove(feature.id)
        } else {
            disabledFeatureIDs.insert(feature.id)
        }
    }

    // MARK: - Banners

    func banners(for placement: BannerPlacement) -> [PromoBanner] {
        allBanners.filter { banner in
            banner.placement == placement
                && !dismissedBannerIDs.contains(banner.id)
                && banner.availability.isAvailable(region: region, userType: userType, variant: experimentVariant)
        }
    }

    func dismissBanner(_ banner: PromoBanner) {
        dismissedBannerIDs.insert(banner.id)
    }

    func resetDismissedBanners() {
        dismissedBannerIDs.removeAll()
    }

    // MARK: - Uber One

    /// Whole calendar days from today until the free month ends (negative
    /// once the end date is in the past).
    var uberOneDaysUntilFreeMonthEnds: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: .now)
        let end = calendar.startOfDay(for: uberOneMembership.freeMonthEndDate)
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }

    /// Home shows the acquisition carousel only while the user has no
    /// active membership.
    var showsUberOneAcquisitionCarousel: Bool {
        !uberOneMembership.state.isMember
    }

    /// Business rule: renew banner appears within 7 days of the free month
    /// ending. Prototype Lab can force it on or off via `uberOneRenewBannerMode`.
    var showsUberOneRenewBanner: Bool {
        switch uberOneRenewBannerMode {
        case .always: true
        case .hidden: false
        case .automatic:
            uberOneMembership.state == .freeMonth
                && (0...7).contains(uberOneDaysUntilFreeMonthEnds)
        }
    }

    /// Status line shown in the Account tab profile card.
    var uberOneStatusLabel: String? {
        switch uberOneMembership.state {
        case .notSubscribed, .expired: nil
        case .freeMonth: "Uber One — free month"
        case .paidActive: "Uber One member"
        }
    }

    func startUberOneFreeMonth(billingPeriod: UberOneBillingPeriod) {
        uberOneMembership = UberOneMembership(
            state: .freeMonth,
            plan: .standard,
            billingPeriod: billingPeriod,
            freeMonthEndDate: Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
        )
    }

    func activateUberOnePlan(_ plan: UberOnePlan, billingPeriod: UberOneBillingPeriod) {
        uberOneMembership.state = .paidActive
        uberOneMembership.plan = plan
        uberOneMembership.billingPeriod = billingPeriod
    }

    func setUberOneFreeMonthEnd(daysFromNow: Int) {
        uberOneMembership.freeMonthEndDate =
            Calendar.current.date(byAdding: .day, value: daysFromNow, to: .now) ?? .now
    }

    func resetUberOne() {
        uberOneMembership = MockUberOne.initialMembership
        uberOneSavings = MockUberOne.defaultSavings
        uberOneRenewBannerMode = .automatic
    }
}
