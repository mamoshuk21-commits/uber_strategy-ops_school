//
//  PrototypeLabView.swift
//  Uber Task
//

import SwiftUI

/// Internal Product Owner tooling: switch region/profile/experiment
/// variant, and toggle banner or feature visibility, all without a
/// backend. Reachable from Account → Prototype Tools, or by tapping the
/// Home avatar.
struct PrototypeLabView: View {
    @Environment(MockContentStore.self) private var store

    var body: some View {
        @Bindable var store = store

        List {
            Section("Prototype Lab") {
                Text("Internal testing tools. Not visible to end users in production.")
                    .font(AppTypography.footnote)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Section("Targeting context") {
                Picker("Region", selection: $store.region) {
                    ForEach(AppRegion.allCases) { region in
                        Text(region.displayName).tag(region)
                    }
                }
                Picker("Profile type", selection: $store.userProfile.profileType) {
                    ForEach(UserType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                Picker("Experiment variant", selection: $store.experimentVariant) {
                    ForEach(ExperimentVariant.allCases) { variant in
                        Text(variant.displayName).tag(variant)
                    }
                }
            }

            Section("Banners") {
                ForEach(store.allBanners) { banner in
                    Toggle(isOn: bannerBinding(banner)) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(banner.title)
                                .font(AppTypography.subheadline.weight(.medium))
                            Text(banner.placement.rawValue)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                }
                Button("Reset dismissed banners") {
                    store.resetDismissedBanners()
                }
            }

            Section("Service availability") {
                ForEach(ServiceCategoryKind.allCases) { category in
                    DisclosureGroup(category.title) {
                        ForEach(store.allFeatures.filter { $0.category == category }) { feature in
                            Toggle(isOn: featureBinding(feature)) {
                                Text(feature.title)
                                    .font(AppTypography.subheadline)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Prototype Lab")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bannerBinding(_ banner: PromoBanner) -> Binding<Bool> {
        Binding(
            get: { !store.dismissedBannerIDs.contains(banner.id) },
            set: { isOn in
                if isOn {
                    store.dismissedBannerIDs.remove(banner.id)
                } else {
                    store.dismissedBannerIDs.insert(banner.id)
                }
            }
        )
    }

    private func featureBinding(_ feature: ServiceFeature) -> Binding<Bool> {
        Binding(
            get: { !store.disabledFeatureIDs.contains(feature.id) },
            set: { isOn in store.setFeature(feature, enabled: isOn) }
        )
    }
}

#Preview {
    NavigationStack {
        PrototypeLabView()
    }
    .environment(MockContentStore())
}
