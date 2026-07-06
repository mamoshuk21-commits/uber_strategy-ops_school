//
//  MockHomeSections.swift
//  Uber Task
//

import Foundation

enum MockHomeSections {
    private static func featureID(_ title: String) -> UUID? {
        MockServices.all.first(where: { $0.title == title })?.id
    }

    static let all: [HomeSection] = [
        HomeSection(
            title: "Suggestions",
            cards: [
                SuggestionCard(title: "Ride now", subtitle: "8 min pickup", systemImage: "car.fill", deepLinkFeatureID: featureID("Ride now")),
                SuggestionCard(title: "Reorder favorites", subtitle: "Green Bowl", systemImage: "arrow.clockwise.circle.fill", deepLinkFeatureID: featureID("Reorder favorites")),
                SuggestionCard(title: "MovePass", subtitle: "Trial active", systemImage: "sparkles", deepLinkFeatureID: featureID("MovePass")),
            ]
        ),
        HomeSection(
            title: "Recently used",
            cards: [
                SuggestionCard(title: "Grocery delivery", subtitle: "Last order: yesterday", systemImage: "cart.fill", deepLinkFeatureID: featureID("Grocery delivery")),
                SuggestionCard(title: "Airport ride", subtitle: "2 weeks ago", systemImage: "airplane", deepLinkFeatureID: featureID("Airport ride")),
                SuggestionCard(title: "Courier / Package", subtitle: "Sent to Office Hub", systemImage: "box.truck.fill", deepLinkFeatureID: featureID("Courier / Package")),
            ]
        ),
        HomeSection(
            title: "Around you",
            cards: [
                SuggestionCard(title: "Central Station", subtitle: "12 min ride", systemImage: "mappin.and.ellipse"),
                SuggestionCard(title: "Ocean Plaza", subtitle: "18 min ride", systemImage: "mappin.and.ellipse"),
                SuggestionCard(title: "Unit City", subtitle: "9 min ride", systemImage: "mappin.and.ellipse"),
            ]
        ),
        HomeSection(
            title: "Go again",
            cards: [
                SuggestionCard(title: "Office Hub", subtitle: "Your usual weekday ride", systemImage: "car.fill", deepLinkFeatureID: featureID("Ride now")),
                SuggestionCard(title: "Noodle House", subtitle: "Reorder your last meal", systemImage: "fork.knife", deepLinkFeatureID: featureID("Food delivery")),
            ]
        ),
        HomeSection(
            title: "Travel smarter",
            cards: [
                SuggestionCard(title: "Reserve ride", subtitle: "Plan ahead, skip the wait", systemImage: "calendar.badge.clock", deepLinkFeatureID: featureID("Reserve ride")),
                SuggestionCard(title: "Intercity", subtitle: "Book a trip between cities", systemImage: "building.2.fill", deepLinkFeatureID: featureID("Intercity")),
                SuggestionCard(title: "Rental cars", subtitle: "Rent by the day", systemImage: "key.fill", deepLinkFeatureID: featureID("Rental cars")),
            ]
        ),
        HomeSection(
            title: "Food near you",
            cards: [
                SuggestionCard(title: "Green Bowl", subtitle: "Healthy bowls · 4.8", systemImage: "leaf.fill", deepLinkFeatureID: featureID("Food delivery")),
                SuggestionCard(title: "City Pizza", subtitle: "Pizza · 4.6", systemImage: "flame.fill", deepLinkFeatureID: featureID("Food delivery")),
                SuggestionCard(title: "Noodle House", subtitle: "Asian · 4.7", systemImage: "takeoutbag.and.cup.and.straw.fill", deepLinkFeatureID: featureID("Food delivery")),
                SuggestionCard(title: "Sunrise Cafe", subtitle: "Breakfast · 4.9", systemImage: "cup.and.saucer.fill", deepLinkFeatureID: featureID("Food delivery")),
            ]
        ),
        HomeSection(
            title: "More ways to use MoveLab",
            cards: [
                SuggestionCard(title: "Send a package", subtitle: "Courier delivery", systemImage: "box.truck.fill", deepLinkFeatureID: featureID("Courier / Package")),
                SuggestionCard(title: "Pet supplies", subtitle: "Food and toys", systemImage: "pawprint.fill", deepLinkFeatureID: featureID("Pet supplies")),
                SuggestionCard(title: "Flowers / gifts", subtitle: "Same-day gifting", systemImage: "gift.fill", deepLinkFeatureID: featureID("Flowers / gifts")),
            ]
        ),
    ]
}
