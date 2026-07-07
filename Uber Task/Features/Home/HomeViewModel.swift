//
//  HomeViewModel.swift
//  Uber Task
//

import Foundation

/// Presentation logic for the Home screen. Reads from `MockContentStore`
/// so the view stays declarative — filtering, ordering, and lookups live
/// here instead of in the view body.
///
/// A plain struct: it holds no state of its own, so it's cheap to build
/// inside `body`. Observation comes from the `@Observable` store the
/// accessors read through.
struct HomeViewModel {
    private let store: MockContentStore

    init(store: MockContentStore) {
        self.store = store
    }

    var profile: UserProfile { store.userProfile }
    var savedDestinations: [Destination] { store.savedDestinations }
    var recentDestinations: [Destination] { store.recentDestinations }
    var currentLocation: Destination { store.currentLocation }
    var quickActions: [ServiceFeature] { store.quickActions }
    var homeSections: [HomeSection] { store.homeSections }

    var showsUberOneCarousel: Bool { store.showsUberOneAcquisitionCarousel }
    var showsUberOneRenewBanner: Bool { store.showsUberOneRenewBanner }
    var uberOneHomeBanners: [UberOneHomeBanner] { store.uberOneHomeBanners }
    var uberOneFreeMonthEndDate: Date { store.uberOneMembership.freeMonthEndDate }

    func banners(for placement: BannerPlacement) -> [PromoBanner] {
        store.banners(for: placement)
    }

    func dismissBanner(_ banner: PromoBanner) {
        store.dismissBanner(banner)
    }

    func feature(withID id: UUID?) -> ServiceFeature? {
        store.feature(withID: id)
    }

    func setProfileType(_ type: UserType) {
        store.userProfile.profileType = type
    }
}
