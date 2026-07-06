//
//  ServicesTabView.swift
//  Uber Task
//

import SwiftUI

/// Tab-root wrapper that gives the Services tab its own navigation
/// stack, reusing `ServicesListView` as the shared catalog content.
struct ServicesTabView: View {
    @Binding var path: NavigationPath

    var body: some View {
        NavigationStack(path: $path) {
            ServicesListView()
                .navigationDestination(for: AppRoute.self) { route in
                    RouteDestinationView(route: route)
                }
        }
    }
}

#Preview {
    ServicesTabView(path: .constant(NavigationPath()))
        .environment(MockContentStore())
}
