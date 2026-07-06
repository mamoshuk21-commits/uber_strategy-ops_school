//
//  HomeHeaderView.swift
//  Uber Task
//

import SwiftUI

/// Top-of-Home header: greeting, mocked current location, profile-type
/// switch chip, notifications, and avatar/profile entry point.
struct HomeHeaderView: View {
    let profile: UserProfile
    var onProfileTypeChange: (UserType) -> Void
    var onNotificationsTap: () -> Void
    var onAvatarTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.greeting)
                    .font(AppTypography.title)
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: AppSpacing.xxs) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11, weight: .semibold))
                    Text(profile.locationLabel)
                        .font(AppTypography.subheadline)
                        .lineLimit(1)
                }
                .foregroundStyle(AppColor.textSecondary)

                ProfileTypeChip(selected: profile.profileType, onSelect: onProfileTypeChange)
                    .padding(.top, AppSpacing.xxs)
            }

            Spacer(minLength: AppSpacing.xs)

            VStack(spacing: AppSpacing.sm) {
                IconButton(systemImage: "bell.fill", accessibilityLabel: "Notifications", action: onNotificationsTap)
                AvatarButton(name: profile.firstName, action: onAvatarTap)
            }
        }
    }
}

private struct ProfileTypeChip: View {
    let selected: UserType
    let onSelect: (UserType) -> Void

    var body: some View {
        Menu {
            ForEach(UserType.allCases) { type in
                Button {
                    onSelect(type)
                } label: {
                    if type == selected {
                        Label(type.displayName, systemImage: "checkmark")
                    } else {
                        Text(type.displayName)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selected.displayName)
                    .font(AppTypography.captionEmphasized)
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(AppColor.textPrimary)
            .padding(.horizontal, AppSpacing.xs)
            .padding(.vertical, 5)
            .background(AppColor.chipBackground, in: Capsule())
        }
        .accessibilityLabel("Profile type: \(selected.displayName)")
        .accessibilityHint("Double tap to switch account profile")
    }
}

private struct IconButton: View {
    let systemImage: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppColor.textPrimary)
                .frame(width: AppMetrics.iconButtonSize, height: AppMetrics.iconButtonSize)
                .background(AppColor.surfaceElevated, in: Circle())
                .appShadow(.card)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

private struct AvatarButton: View {
    let name: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            AvatarView(name: name)
        }
        .accessibilityLabel("Open profile for \(name)")
    }
}

#Preview {
    HomeHeaderView(
        profile: MockUser.demo,
        onProfileTypeChange: { _ in },
        onNotificationsTap: {},
        onAvatarTap: {}
    )
    .padding()
    .background(AppColor.surfaceSecondary)
}
