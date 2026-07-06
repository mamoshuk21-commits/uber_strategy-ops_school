//
//  ServiceFeature.swift
//  Uber Task
//

import Foundation

enum ServiceBadge: String, Codable {
    case promo, new, popular, scheduled, business

    var label: String {
        switch self {
        case .promo: "Promo"
        case .new: "New"
        case .popular: "Popular"
        case .scheduled: "Scheduled"
        case .business: "Business"
        }
    }
}

enum ServiceCategoryKind: String, Codable, CaseIterable, Identifiable {
    case rideAndMobility
    case deliveryAndCommerce
    case accountAndPlatform

    var id: String { rawValue }

    var title: String {
        switch self {
        case .rideAndMobility: "Ride & mobility"
        case .deliveryAndCommerce: "Delivery & commerce"
        case .accountAndPlatform: "Account & platform"
        }
    }
}

/// A single tappable service in the quick-action grid or the full
/// services catalog. Every feature can be filtered by `availability`
/// so Prototype Lab can simulate rollout rules without a backend.
struct ServiceFeature: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var systemImage: String
    var category: ServiceCategoryKind
    var badge: ServiceBadge?
    var isQuickAction: Bool
    var availability: FeatureAvailability

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        systemImage: String,
        category: ServiceCategoryKind,
        badge: ServiceBadge? = nil,
        isQuickAction: Bool = false,
        availability: FeatureAvailability = FeatureAvailability()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.category = category
        self.badge = badge
        self.isQuickAction = isQuickAction
        self.availability = availability
    }
}
