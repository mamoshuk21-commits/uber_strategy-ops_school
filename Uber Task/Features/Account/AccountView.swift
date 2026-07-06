//
//  AccountView.swift
//  Uber Task
//

import SwiftUI

/// Placeholder Account tab: mock profile summary, saved places, mocked
/// payment/settings rows, and the internal Prototype Tools entry point.
struct AccountView: View {
    @Binding var path: NavigationPath
    @Environment(MockContentStore.self) private var store

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    HStack(spacing: AppSpacing.sm) {
                        AvatarView(name: store.userProfile.firstName, size: 56)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(store.userProfile.firstName)
                                .font(AppTypography.headline)
                            Text(store.userProfile.locationLabel)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColor.textSecondary)
                            if let membership = store.userProfile.membershipStatus.label {
                                Text(membership)
                                    .font(AppTypography.captionEmphasized)
                                    .foregroundStyle(AppColor.accentPromo)
                            }
                        }
                    }
                    .padding(.vertical, AppSpacing.xxs)
                    .accessibilityElement(children: .combine)
                }

                Section("Places & payments") {
                    NavigationLink(value: AppRoute.servicesCategory(.accountAndPlatform)) {
                        Label("Saved places", systemImage: "mappin.and.ellipse")
                    }
                    Label("Wallet (mock)", systemImage: "wallet.pass.fill")
                    Label("Payment methods (mock)", systemImage: "creditcard.fill")
                }

                Section("Support & preferences") {
                    Label("Safety center", systemImage: "shield.fill")
                    Label("Help", systemImage: "questionmark.circle.fill")
                    Label("Settings (mock)", systemImage: "gearshape.fill")
                }

                Section("Internal") {
                    NavigationLink(value: AppRoute.prototypeLab) {
                        Label("Prototype Tools", systemImage: "wrench.and.screwdriver.fill")
                    }
                    .accessibilityHint("Internal tools for the product owner to test flags and banners")
                }
            }
            .navigationTitle("Account")
            .navigationDestination(for: AppRoute.self) { route in
                RouteDestinationView(route: route)
            }
        }
    }
}

#Preview {
    AccountView(path: .constant(NavigationPath()))
        .environment(MockContentStore())
}
