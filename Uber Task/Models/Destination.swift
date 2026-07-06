//
//  Destination.swift
//  Uber Task
//

import Foundation

enum DestinationKind: String, Codable {
    case home, work, airport, recent, saved
}

/// A saved place, recent trip, or search suggestion shown in the
/// destination search module.
struct Destination: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var kind: DestinationKind
    var title: String
    var subtitle: String
    var systemImage: String

    init(
        id: UUID = UUID(),
        kind: DestinationKind,
        title: String,
        subtitle: String,
        systemImage: String
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }
}
