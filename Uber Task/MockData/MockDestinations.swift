//
//  MockDestinations.swift
//  Uber Task
//

import Foundation

enum MockDestinations {
    static let saved: [Destination] = [
        Destination(kind: .home, title: "Home", subtitle: "221B Baker Street", systemImage: "house.fill"),
        Destination(kind: .work, title: "Work", subtitle: "Business Center Horizon", systemImage: "briefcase.fill"),
        Destination(kind: .airport, title: "Airport", subtitle: "Boryspil International Airport", systemImage: "airplane"),
    ]

    static let recent: [Destination] = [
        Destination(kind: .recent, title: "Central Station", subtitle: "12 min away", systemImage: "clock"),
        Destination(kind: .recent, title: "Ocean Plaza", subtitle: "Shopping mall", systemImage: "clock"),
        Destination(kind: .recent, title: "Unit City", subtitle: "Business campus", systemImage: "clock"),
        Destination(kind: .recent, title: "Office Hub", subtitle: "Coworking space", systemImage: "clock"),
    ]

    static let currentLocation = Destination(
        kind: .saved,
        title: "Current location",
        subtitle: "Using approximate location",
        systemImage: "location.fill"
    )
}
