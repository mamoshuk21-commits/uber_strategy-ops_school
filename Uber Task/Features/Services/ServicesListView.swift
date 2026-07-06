//
//  ServicesListView.swift
//  Uber Task
//

import SwiftUI

/// Full production-style service catalog, grouped by category. Every row
/// respects the same region/user-type/experiment availability rules as
/// the Home quick-action grid.
struct ServicesListView: View {
    @Environment(MockContentStore.self) private var store
    var initialCategory: ServiceCategoryKind? = nil

    var body: some View {
        List {
            if let banner = store.banners(for: .insideServiceSection).first {
                Section {
                    PromoBannerView(banner: banner, onDismiss: { store.dismissBanner(banner) })
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, AppSpacing.xs)
                }
            }

            ForEach(categories, id: \.self) { category in
                Section(category.title) {
                    ForEach(store.features(in: category)) { feature in
                        NavigationLink(value: AppRoute.featureDetail(featureID: feature.id)) {
                            ServiceRow(feature: feature)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(initialCategory?.title ?? "All services")
        .navigationBarTitleDisplayMode(.large)
    }

    private var categories: [ServiceCategoryKind] {
        if let initialCategory {
            return [initialCategory]
        }
        return ServiceCategoryKind.allCases
    }
}

private struct ServiceRow: View {
    let feature: ServiceFeature

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: feature.systemImage)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppColor.textPrimary)
                .frame(width: 34, height: 34)
                .background(AppColor.chipBackground, in: Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(feature.title)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textPrimary)
                Text(feature.subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Spacer()

            if let badge = feature.badge {
                BadgeView(badge: badge)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        ServicesListView()
    }
    .environment(MockContentStore())
}
