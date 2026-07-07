//
//  RouteDestinationView.swift
//  Uber Task
//

import SwiftUI

/// Resolves an `AppRoute` value to its destination view. Registered once
/// per tab's `NavigationStack` via `.navigationDestination(for:)`.
struct RouteDestinationView: View {
    let route: AppRoute

    var body: some View {
        switch route {
        case .featureDetail(let featureID):
            FeatureDetailView(featureID: featureID)
        case .allServices:
            ServicesListView()
        case .servicesCategory(let category):
            ServicesListView(initialCategory: category)
        case .prototypeLab:
            PrototypeLabView()
        case .uberOneDetails:
            UberOneDetailsView()
        case .uberOneUpsell:
            UberOneUpsellView()
        }
    }
}
