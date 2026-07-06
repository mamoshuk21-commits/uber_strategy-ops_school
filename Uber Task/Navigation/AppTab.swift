//
//  AppTab.swift
//  Uber Task
//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case home, services, activity, account

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .services: "Services"
        case .activity: "Activity"
        case .account: "Account"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house.fill"
        case .services: "square.grid.2x2.fill"
        case .activity: "clock.arrow.circlepath"
        case .account: "person.crop.circle.fill"
        }
    }
}
