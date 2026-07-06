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

    init(
        userProfile: UserProfile = MockUser.demo,
        region: AppRegion = .ukraine,
        experimentVariant: ExperimentVariant = .control,
        savedDestinations: [Destination] = MockDestinations.saved,
        recentDestinations: [Destination] = MockDestinations.recent,
        currentLocation: Destination = MockDestinations.currentLocation,
        allFeatures: [ServiceFeature] = MockServices.all,
        allBanners: [PromoBanner] = MockBanners.all,
        homeSections: [HomeSection] = MockHomeSections.all
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
}
