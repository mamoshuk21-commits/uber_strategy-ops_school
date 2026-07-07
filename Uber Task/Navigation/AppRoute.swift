//
//  AppRoute.swift
//  Uber Task
//

import Foundation

/// Push destinations shared across tabs. Kept as lightweight value
/// identifiers (not full models) so it stays `Hashable` and cheap to
/// carry in a `NavigationPath`.
enum AppRoute: Hashable {
    case featureDetail(featureID: UUID)
    case allServices
    case servicesCategory(ServiceCategoryKind)
    case prototypeLab
    case uberOneDetails
    case uberOneUpsell
}
