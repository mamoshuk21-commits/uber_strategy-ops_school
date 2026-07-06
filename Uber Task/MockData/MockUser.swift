//
//  MockUser.swift
//  Uber Task
//

import Foundation

enum MockUser {
    static let demo = UserProfile(
        id: UUID(),
        firstName: "Alex",
        locationLabel: "Kyiv, Ukraine",
        profileType: .personal,
        membershipStatus: .trial
    )
}
