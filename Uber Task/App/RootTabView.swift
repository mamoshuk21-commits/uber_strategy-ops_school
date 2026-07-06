//
//  RootTabView.swift
//  Uber Task
//

import SwiftUI

/// App root: four-tab layout (Home, Services, Activity, Account), each
/// with its own independent navigation stack so pushing a feature detail
/// from one tab doesn't affect the others.
struct RootTabView: View {
    @State private var store = MockContentStore()
    @State private var selectedTab: AppTab = .home

    @State private var homePath = NavigationPath()
    @State private var servicesPath = NavigationPath()
    @State private var activityPath = NavigationPath()
    @State private var accountPath = NavigationPath()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $homePath) {
                HomeScreenView(path: $homePath)
                    .navigationDestination(for: AppRoute.self) { route in
                        RouteDestinationView(route: route)
                    }
            }
            .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.systemImage) }
            .tag(AppTab.home)
            .accessibilityLabel(AppTab.home.title)

            ServicesTabView(path: $servicesPath)
                .tabItem { Label(AppTab.services.title, systemImage: AppTab.services.systemImage) }
                .tag(AppTab.services)
                .accessibilityLabel(AppTab.services.title)

            ActivityView(path: $activityPath)
                .tabItem { Label(AppTab.activity.title, systemImage: AppTab.activity.systemImage) }
                .tag(AppTab.activity)
                .accessibilityLabel(AppTab.activity.title)

            AccountView(path: $accountPath)
                .tabItem { Label(AppTab.account.title, systemImage: AppTab.account.systemImage) }
                .tag(AppTab.account)
                .accessibilityLabel(AppTab.account.title)
        }
        .tint(AppColor.textPrimary)
        .environment(store)
    }
}

#Preview {
    RootTabView()
}
