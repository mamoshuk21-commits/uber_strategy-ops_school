//
//  UserProfile.swift
//  Uber Task
//

import Foundation

enum MembershipStatus: String, Codable, Equatable {
    case none
    case trial
    case active

    var label: String? {
        switch self {
        case .none: nil
        case .trial: "MovePass trial"
        case .active: "MovePass member"
        }
    }
}

/// The signed-in (mock) demo user shown across the app. No real
/// authentication backs this — it is a local fixture only.
struct UserProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var firstName: String
    var locationLabel: String
    var profileType: UserType
    var membershipStatus: MembershipStatus

    var greeting: String {
        "Good \(TimeOfDay.current.rawValue), \(firstName)"
    }
}

enum TimeOfDay: String {
    case morning, afternoon, evening

    static var current: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return .morning
        case 12..<18: return .afternoon
        default: return .evening
        }
    }
}
