//
//  MockUberOne.swift
//  Uber Task
//

import Foundation

/// Editable Uber One fixtures: default membership state, mock savings, Home
/// carousel copy, and the benefits list on the subscription details screen.
enum MockUberOne {
    static var initialMembership: UberOneMembership {
        UberOneMembership(
            state: .notSubscribed,
            plan: nil,
            billingPeriod: .monthly,
            freeMonthEndDate: Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
        )
    }

    /// Defaults match the Figma details screen so the design can be reviewed
    /// as-is; adjust freely from Prototype Lab.
    static let defaultSavings = UberOneSavingsSummary(
        orderCount: 129,
        orderSavings: 818.39,
        rideCount: 356,
        rideSavings: 444.98
    )

    /// Average member savings shown on the details screen callout.
    static let averageMonthlySavings: Double = 25

    static let homeBanners: [UberOneHomeBanner] = [
        UberOneHomeBanner(
            headline: "It's free: 1 month of Uber One",
            message: "Save on delivery + rides",
            ctaText: "Join now",
            style: .goldHero
        ),
        UberOneHomeBanner(
            headline: "Save with Uber One",
            message: "Members save on average $22 per month.",
            ctaText: "Try it free",
            style: .light
        ),
    ]

    /// Benefit rows on the subscription details screen.
    static let membershipBenefits: [UberOnePlanBenefit] = [
        UberOnePlanBenefit(systemImage: "bag.fill", text: "$0 Delivery Fee on eligible food, groceries, and more"),
        UberOnePlanBenefit(systemImage: "percent", text: "Up to 10% off eligible deliveries and pickup orders"),
        UberOnePlanBenefit(systemImage: "car.fill", text: "Earn 6% Uber Cash and get top-rated drivers on eligible rides"),
        UberOnePlanBenefit(systemImage: "clock.badge.checkmark", text: "$5 credit if our Latest Arrival estimate on your order is off*"),
        UberOnePlanBenefit(systemImage: "calendar.badge.checkmark", text: "Cancel without fees or penalties"),
    ]

    static let benefitsFootnote = """
    *Benefits available only for eligible stores and rides marked with the \
    membership icon. Participating restaurants and non-grocery stores: $15 \
    minimum order to receive $0 Delivery Fee and up to 10% off. Prototype \
    data — no real charges or orders are made.
    """
}
