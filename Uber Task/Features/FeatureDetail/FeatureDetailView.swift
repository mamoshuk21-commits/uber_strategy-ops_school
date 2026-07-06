//
//  FeatureDetailView.swift
//  Uber Task
//

import SwiftUI

/// Destination every service tile/row navigates to. Wraps
/// `PlaceholderDetailView` with the tapped feature's content, and shows
/// any banner that deep-links to this specific feature.
struct FeatureDetailView: View {
    let featureID: UUID

    @Environment(MockContentStore.self) private var store

    private var feature: ServiceFeature? {
        store.feature(withID: featureID)
    }

    private var linkedBanner: PromoBanner? {
        store.allBanners.first { $0.deepLinkFeatureID == featureID }
    }

    var body: some View {
        if let feature {
            PlaceholderDetailView(
                title: feature.title,
                subtitle: feature.subtitle + " This screen is a prototype placeholder — the full flow isn't built yet.",
                statusLabel: feature.badge?.label ?? "Prototype preview",
                ctaText: "Continue with \(feature.title)",
                systemImage: feature.systemImage,
                banner: linkedBanner,
                onBannerDismiss: linkedBanner.map { banner in { store.dismissBanner(banner) } }
            )
        } else {
            PlaceholderDetailView(
                title: "Unavailable",
                subtitle: "This service isn't available right now.",
                systemImage: "questionmark.circle"
            )
        }
    }
}
