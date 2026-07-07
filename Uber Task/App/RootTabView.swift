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
            Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: .home) {
                NavigationStack(path: $homePath) {
                    HomeScreenView(path: $homePath)
                        .navigationDestination(for: AppRoute.self) { route in
                            RouteDestinationView(route: route)
                        }
                }
            }

            Tab(AppTab.services.title, systemImage: AppTab.services.systemImage, value: .services) {
                ServicesTabView(path: $servicesPath)
            }

            Tab(AppTab.activity.title, systemImage: AppTab.activity.systemImage, value: .activity) {
                ActivityView(path: $activityPath)
            }

            Tab(AppTab.account.title, systemImage: AppTab.account.systemImage, value: .account) {
                AccountView(path: $accountPath)
            }
        }
        .tint(AppColor.textPrimary)
        .environment(store)
    }
}

#Preview {
    RootTabView()
}
