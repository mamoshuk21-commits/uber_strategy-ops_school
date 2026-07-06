//
//  ActivityView.swift
//  Uber Task
//

import SwiftUI

private struct ActivityItem: Identifiable {
    enum Kind { case ride, order }
    let id = UUID()
    let kind: Kind
    let title: String
    let subtitle: String
    let price: String
    let date: String
    let systemImage: String
}

/// Placeholder Activity tab: past rides and orders, grouped with a
/// segmented filter. Detail rows open the generic feature-detail
/// placeholder for now.
struct ActivityView: View {
    @Binding var path: NavigationPath
    @Environment(MockContentStore.self) private var store
    @State private var filter: ActivityItem.Kind = .ride

    private let items: [ActivityItem] = [
        ActivityItem(kind: .ride, title: "Ride to Central Station", subtitle: "Economy · Alex Morgan", price: "$8.40", date: "Today, 8:12 AM", systemImage: "car.fill"),
        ActivityItem(kind: .ride, title: "Ride to Boryspil International Airport", subtitle: "Premium · Sam Lee", price: "$26.90", date: "Jul 1", systemImage: "airplane"),
        ActivityItem(kind: .order, title: "Green Bowl", subtitle: "Food delivery · 3 items", price: "$21.50", date: "Jun 30", systemImage: "fork.knife"),
        ActivityItem(kind: .ride, title: "Ride to Unit City", subtitle: "Comfort · Taylor Kim", price: "$11.20", date: "Jun 28", systemImage: "car.side.fill"),
        ActivityItem(kind: .order, title: "City Pizza", subtitle: "Group order · 5 items", price: "$34.00", date: "Jun 26", systemImage: "takeoutbag.and.cup.and.straw.fill"),
    ]

    private var filteredItems: [ActivityItem] {
        items.filter { $0.kind == filter }
    }

    private func relatedFeatureID(for item: ActivityItem) -> UUID? {
        let title = item.kind == .ride ? "Ride now" : "Food delivery"
        return store.allFeatures.first(where: { $0.title == title })?.id
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    Picker("Filter", selection: $filter) {
                        Text("Rides").tag(ActivityItem.Kind.ride)
                        Text("Orders").tag(ActivityItem.Kind.order)
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Filter activity by rides or orders")

                    if let banner = store.banners(for: .homeTop).first {
                        PromoBannerView(banner: banner)
                    }

                    VStack(spacing: AppSpacing.sm) {
                        ForEach(filteredItems) { item in
                            if let featureID = relatedFeatureID(for: item) {
                                NavigationLink(value: AppRoute.featureDetail(featureID: featureID)) {
                                    ActivityRow(item: item)
                                }
                            } else {
                                ActivityRow(item: item)
                            }
                        }
                    }
                }
                .padding(AppSpacing.screenMargin)
            }
            .background(AppColor.surfaceSecondary.ignoresSafeArea())
            .navigationTitle("Activity")
            .navigationDestination(for: AppRoute.self) { route in
                RouteDestinationView(route: route)
            }
        }
    }
}

private struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: item.systemImage)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppColor.textPrimary)
                .frame(width: 40, height: 40)
                .background(AppColor.chipBackground, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(1)
                Text("\(item.subtitle) · \(item.date)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(1)
            }
            Spacer()
            Text(item.price)
                .font(AppTypography.subheadline.weight(.semibold))
                .foregroundStyle(AppColor.textPrimary)
        }
        .padding(AppSpacing.sm)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title), \(item.subtitle), \(item.date), \(item.price)")
    }
}

#Preview {
    ActivityView(path: .constant(NavigationPath()))
        .environment(MockContentStore())
}
