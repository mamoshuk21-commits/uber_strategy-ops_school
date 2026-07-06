//
//  DestinationSearchCard.swift
//  Uber Task
//

import SwiftUI

/// The primary "Where to?" entry point: search field, current location
/// row, saved places, a recent destination, and a reserve-ahead shortcut.
/// This is the core conversion point of the Home screen.
struct DestinationSearchCard: View {
    let currentLocation: Destination
    let savedPlaces: [Destination]
    let recentDestinations: [Destination]
    var onSearchTap: () -> Void
    var onReserveTap: () -> Void
    var onDestinationTap: (Destination) -> Void

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            searchField

            HStack(spacing: AppSpacing.xs) {
                ForEach(savedPlaces) { place in
                    SavedPlaceChip(destination: place, action: { onDestinationTap(place) })
                }
                Spacer(minLength: 0)
                ReserveChip(action: onReserveTap)
            }

            if let recent = recentDestinations.first {
                Divider().overlay(AppColor.divider)
                DestinationRow(destination: recent, action: { onDestinationTap(recent) })
            }
        }
        .padding(AppSpacing.sm)
        .cardBackground(shadow: .raised)
    }

    private var searchField: some View {
        Button(action: onSearchTap) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                Text("Where to?")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.textPrimary)
                Spacer()
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColor.textSecondary)
            }
            .padding(.horizontal, AppSpacing.sm)
            .frame(height: AppMetrics.searchFieldHeight)
            .background(AppColor.tileBackground, in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .accessibilityLabel("Where to? Search for a destination")
    }
}

private struct SavedPlaceChip: View {
    let destination: Destination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: destination.systemImage)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(AppColor.chipBackground, in: Circle())
                Text(destination.title)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .accessibilityLabel("\(destination.title), \(destination.subtitle)")
        .accessibilityHint("Double tap to start a trip to this place")
    }
}

private struct ReserveChip: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(AppColor.chipBackground, in: Circle())
                Text("Reserve")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .accessibilityLabel("Reserve a ride ahead of time")
    }
}

private struct DestinationRow: View {
    let destination: Destination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "clock")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColor.textSecondary)
                    .frame(width: 28, height: 28)
                    .background(AppColor.chipBackground, in: Circle())

                VStack(alignment: .leading, spacing: 1) {
                    Text(destination.title)
                        .font(AppTypography.subheadline.weight(.medium))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(destination.subtitle)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer()
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
        .accessibilityLabel("Recent destination: \(destination.title), \(destination.subtitle)")
    }
}

#Preview {
    DestinationSearchCard(
        currentLocation: MockDestinations.currentLocation,
        savedPlaces: MockDestinations.saved,
        recentDestinations: MockDestinations.recent,
        onSearchTap: {},
        onReserveTap: {},
        onDestinationTap: { _ in }
    )
    .padding()
    .background(AppColor.surfaceSecondary)
}
