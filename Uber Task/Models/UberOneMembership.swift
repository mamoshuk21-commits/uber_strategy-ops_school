//
//  UberOneMembership.swift
//  Uber Task
//

import Foundation

/// Lifecycle phase of the demo user's Uber One membership.
enum UberOneMembershipState: String, Codable, CaseIterable, Identifiable {
    case notSubscribed
    case freeMonth
    case paidActive
    case expired

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .notSubscribed: "Not subscribed"
        case .freeMonth: "Free month active"
        case .paidActive: "Paid subscription"
        case .expired: "Expired / cancelled"
        }
    }

    /// Member benefits (and the Account savings section) apply in these phases.
    var isMember: Bool {
        self == .freeMonth || self == .paidActive
    }
}

enum UberOneBillingPeriod: String, Codable, CaseIterable, Identifiable {
    case monthly
    case yearly

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .monthly: "Monthly"
        case .yearly: "Yearly"
        }
    }
}

/// The four plans offered on the renewal upsell screen. `standard` is also
/// the plan every user gets when starting the free month.
enum UberOnePlan: String, Codable, CaseIterable, Identifiable {
    case standard
    case extraRides
    case extraEats
    case allAccess

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .standard: "Standard Uber One"
        case .extraRides: "Extra Rides"
        case .extraEats: "Extra Eats"
        case .allAccess: "All Access"
        }
    }

    var tagline: String {
        switch self {
        case .standard: "Your current benefits: $0 delivery, up to 10% off, 6% Uber Cash on rides."
        case .extraRides: "Premium rides, upgraded"
        case .extraEats: "More savings on delivery"
        case .allAccess: "Rides + Eats, everything included"
        }
    }

    var systemImage: String {
        switch self {
        case .standard: "star"
        case .extraRides: "car.fill"
        case .extraEats: "bag.fill"
        case .allAccess: "crown.fill"
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .standard: 9.99
        case .extraRides: 13.98
        case .extraEats: 13.98
        case .allAccess: 17.98
        }
    }

    var yearlyPrice: Double {
        switch self {
        case .standard: 96
        case .extraRides: 168
        case .extraEats: 168
        case .allAccess: 216
        }
    }

    /// What a year on the annual plan saves compared to 12 monthly charges.
    var yearlySavingsVsMonthly: Double {
        monthlyPrice * 12 - yearlyPrice
    }

    var isBestValue: Bool { self == .allAccess }

    /// Extra benefits shown on the upsell screen ("Everything in Standard,
    /// plus:"). Standard shows only its `tagline`.
    var upsellBenefits: [UberOnePlanBenefit] {
        switch self {
        case .standard:
            []
        case .extraRides:
            [
                UberOnePlanBenefit(systemImage: "car.fill", text: "Comfort rides instead of Standard"),
                UberOnePlanBenefit(systemImage: "briefcase.fill", text: "Business instead of Comfort"),
                UberOnePlanBenefit(systemImage: "pawprint.fill", text: "Pet-friendly rides at no extra charge"),
                UberOnePlanBenefit(systemImage: "xmark.circle", text: "3 free ride cancellations / month"),
                UberOnePlanBenefit(systemImage: "clock", text: "20% off for long wait times"),
            ]
        case .extraEats:
            [
                UberOnePlanBenefit(systemImage: "bag.fill", text: "$0 Delivery Fee on orders over $50"),
                UberOnePlanBenefit(systemImage: "percent", text: "10% off orders over $70"),
                UberOnePlanBenefit(systemImage: "gift.fill", text: "Exclusive member-only offers"),
            ]
        case .allAccess:
            [
                UberOnePlanBenefit(systemImage: "car.fill", text: "Everything in Extra Rides"),
                UberOnePlanBenefit(systemImage: "fork.knife", text: "Everything in Extra Eats"),
                UberOnePlanBenefit(systemImage: "crown.fill", text: "One membership, maximum value"),
            ]
        }
    }

    func price(for period: UberOneBillingPeriod) -> Double {
        switch period {
        case .monthly: monthlyPrice
        case .yearly: yearlyPrice
        }
    }
}

extension Double {
    /// Fixed en_US currency formatting ("$9.99") so mock Uber One prices
    /// always match the design regardless of the device locale.
    var uberOnePriceText: String {
        formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
    }

    /// Same as `uberOnePriceText` but without cents ("$25").
    var uberOneWholePriceText: String {
        formatted(
            .currency(code: "USD")
                .locale(Locale(identifier: "en_US"))
                .precision(.fractionLength(0))
        )
    }
}

/// One benefit row (icon + text) used on the details and upsell screens.
struct UberOnePlanBenefit: Identifiable, Codable, Equatable, Hashable {
    var id: String { text }
    var systemImage: String
    var text: String
}

/// Mocked "how much Uber One saved you" numbers shown in Account and on the
/// membership details screen. Editable from Prototype Lab.
struct UberOneSavingsSummary: Codable, Equatable {
    var orderCount: Int
    var orderSavings: Double
    var rideCount: Int
    var rideSavings: Double

    var total: Double { orderSavings + rideSavings }
}

/// The whole Uber One membership state for the demo user. Kept as one value
/// so Prototype Lab can set any combination directly.
struct UberOneMembership: Codable, Equatable {
    var state: UberOneMembershipState
    var plan: UberOnePlan?
    var billingPeriod: UberOneBillingPeriod
    var freeMonthEndDate: Date
}

/// Prototype-only override so the Product Owner can force the renew banner
/// on/off regardless of the 7-day business rule.
enum UberOneRenewBannerMode: String, CaseIterable, Identifiable {
    case automatic
    case always
    case hidden

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .automatic: "Automatic (7-day rule)"
        case .always: "Always visible"
        case .hidden: "Hidden"
        }
    }
}

/// One slide of the Home acquisition carousel.
struct UberOneHomeBanner: Identifiable, Codable, Equatable {
    enum Style: String, Codable {
        /// Gold background, white text (Figma hero slide).
        case goldHero
        /// Regular elevated card with gold accents.
        case light
    }

    let id: UUID
    var headline: String
    var message: String
    var ctaText: String
    var style: Style

    init(id: UUID = UUID(), headline: String, message: String, ctaText: String, style: Style) {
        self.id = id
        self.headline = headline
        self.message = message
        self.ctaText = ctaText
        self.style = style
    }
}
