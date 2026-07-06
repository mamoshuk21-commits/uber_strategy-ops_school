//
//  FeatureAvailability.swift
//  Uber Task
//

import Foundation

/// Mock region targeting used to simulate rollout/experiment behavior
/// without a real backend.
enum AppRegion: String, Codable, CaseIterable, Identifiable {
    case us, eu, ukraine, india, global
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .us: "United States"
        case .eu: "European Union"
        case .ukraine: "Ukraine"
        case .india: "India"
        case .global: "Global"
        }
    }
}

/// The kind of account using the app. Reused for both the active profile
/// and per-feature targeting rules.
enum UserType: String, Codable, CaseIterable, Identifiable {
    case personal, business, family, student
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .personal: "Personal"
        case .business: "Business"
        case .family: "Family"
        case .student: "Student"
        }
    }
}

/// A/B style variant used to bias which content is emphasized on Home.
enum ExperimentVariant: String, Codable, CaseIterable, Identifiable {
    case control, promoHeavy, deliveryHeavy, travelHeavy
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .control: "Control"
        case .promoHeavy: "Promo heavy"
        case .deliveryHeavy: "Delivery heavy"
        case .travelHeavy: "Travel heavy"
        }
    }
}

/// Declares which regions, user types, and experiment variants a piece of
/// content (feature tile or banner) is eligible to appear in.
struct FeatureAvailability: Codable, Equatable, Hashable {
    var regions: Set<AppRegion>
    var userTypes: Set<UserType>
    var variants: Set<ExperimentVariant>
    var isEnabled: Bool

    init(
        regions: Set<AppRegion> = Set(AppRegion.allCases),
        userTypes: Set<UserType> = Set(UserType.allCases),
        variants: Set<ExperimentVariant> = Set(ExperimentVariant.allCases),
        isEnabled: Bool = true
    ) {
        self.regions = regions
        self.userTypes = userTypes
        self.variants = variants
        self.isEnabled = isEnabled
    }

    func isAvailable(region: AppRegion, userType: UserType, variant: ExperimentVariant) -> Bool {
        isEnabled
            && regions.contains(region)
            && userTypes.contains(userType)
            && variants.contains(variant)
    }
}
