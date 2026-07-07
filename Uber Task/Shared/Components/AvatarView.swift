//
//  AvatarView.swift
//  Uber Task
//

import SwiftUI

/// Circular initials avatar used as the profile entry point in the Home
/// header and Account screen.
struct AvatarView: View {
    let name: String
    var size: CGFloat = AppMetrics.avatarSize

    private var initials: String {
        String(name.prefix(1)).uppercased()
    }

    var body: some View {
        Circle()
            .fill(AppColor.surfaceInverted)
            .frame(width: size, height: size)
            .overlay {
                Text(initials)
                    .font(.system(size: size * 0.42, weight: .semibold))
                    .foregroundStyle(AppColor.textOnInvertedSurface)
            }
    }
}

#Preview {
    AvatarView(name: "Alex")
}
