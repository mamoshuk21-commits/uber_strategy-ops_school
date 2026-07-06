//
//  MockBanners.swift
//  Uber Task
//

import Foundation

enum MockBanners {
    private static func featureID(_ title: String) -> UUID? {
        MockServices.all.first(where: { $0.title == title })?.id
    }

    static let all: [PromoBanner] = [
        PromoBanner(
            type: .rideDiscount,
            placement: .homeTop,
            title: "Save 20% on your next ride",
            subtitle: "Applies automatically at checkout",
            systemImage: "percent",
            ctaText: "Book now",
            isDismissible: true,
            deepLinkFeatureID: featureID("Ride now"),
            availability: FeatureAvailability(variants: [.control, .promoHeavy, .travelHeavy])
        ),
        PromoBanner(
            type: .deliveryDeal,
            placement: .belowSearch,
            title: "Groceries delivered in 30 min",
            subtitle: "Order from stores near you",
            systemImage: "cart.fill",
            ctaText: "Order groceries",
            isDismissible: true,
            deepLinkFeatureID: featureID("Grocery delivery"),
            availability: FeatureAvailability(variants: [.control, .deliveryHeavy])
        ),
        PromoBanner(
            type: .information,
            placement: .insideServiceSection,
            title: "Reserve your airport ride",
            subtitle: "Flight-tracked pickup, no surprises",
            systemImage: "airplane",
            ctaText: "Reserve now",
            isDismissible: false,
            deepLinkFeatureID: featureID("Airport ride"),
            availability: FeatureAvailability(variants: [.control, .travelHeavy])
        ),
        PromoBanner(
            type: .membership,
            placement: .bottomSticky,
            title: "Try MovePass for free",
            subtitle: "Unlock member pricing on rides and delivery",
            systemImage: "sparkles",
            ctaText: "Try free",
            isDismissible: true,
            deepLinkFeatureID: featureID("MovePass")
        ),
    ]
}
