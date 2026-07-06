//
//  PromoBanner.swift
//  Uber Task
//

import Foundation

enum BannerType: String, Codable {
    case promo, information, warning, experiment, membership, deliveryDeal, rideDiscount
}

enum BannerPlacement: String, Codable, CaseIterable, Identifiable {
    case homeTop
    case belowSearch
    case insideServiceSection
    case bottomSticky

    var id: String { rawValue }
}

/// A reusable, data-driven promo/announcement card. Banners are placed by
/// `placement` and can appear on Home today and other screens later.
struct PromoBanner: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var type: BannerType
    var placement: BannerPlacement
    var title: String
    var subtitle: String
    var systemImage: String
    var ctaText: String?
    var isDismissible: Bool
    /// Identifier of a `ServiceFeature` this banner should deep link to, if any.
    var deepLinkFeatureID: UUID?
    var availability: FeatureAvailability

    init(
        id: UUID = UUID(),
        type: BannerType,
        placement: BannerPlacement,
        title: String,
        subtitle: String,
        systemImage: String,
        ctaText: String? = nil,
        isDismissible: Bool = false,
        deepLinkFeatureID: UUID? = nil,
        availability: FeatureAvailability = FeatureAvailability()
    ) {
        self.id = id
        self.type = type
        self.placement = placement
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.ctaText = ctaText
        self.isDismissible = isDismissible
        self.deepLinkFeatureID = deepLinkFeatureID
        self.availability = availability
    }
}
