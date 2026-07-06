//
//  HomeSection.swift
//  Uber Task
//

import Foundation

/// A single card inside a personalized horizontal-scrolling Home section
/// (e.g. "Go again", "Around you").
struct SuggestionCard: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var systemImage: String
    var deepLinkFeatureID: UUID?

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        systemImage: String,
        deepLinkFeatureID: UUID? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.deepLinkFeatureID = deepLinkFeatureID
    }
}

/// A named, horizontally-scrolling personalized row on Home
/// (e.g. "Suggestions", "Recently used").
struct HomeSection: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var cards: [SuggestionCard]

    init(id: UUID = UUID(), title: String, cards: [SuggestionCard]) {
        self.id = id
        self.title = title
        self.cards = cards
    }
}
