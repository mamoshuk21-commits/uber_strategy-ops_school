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

            Section("Uber One membership") {
                Picker("State", selection: $store.uberOneMembership.state) {
                    ForEach(UberOneMembershipState.allCases) { state in
                        Text(state.displayName).tag(state)
                    }
                }
                Picker("Plan", selection: $store.uberOneMembership.plan) {
                    Text("None").tag(UberOnePlan?.none)
                    ForEach(UberOnePlan.allCases) { plan in
                        Text(plan.displayName).tag(UberOnePlan?.some(plan))
                    }
                }
                Picker("Billing period", selection: $store.uberOneMembership.billingPeriod) {
                    ForEach(UberOneBillingPeriod.allCases) { period in
                        Text(period.displayName).tag(period)
                    }
                }
                DatePicker(
                    "Free month ends",
                    selection: $store.uberOneMembership.freeMonthEndDate,
                    displayedComponents: .date
                )
                LabeledContent("Days until end", value: "\(store.uberOneDaysUntilFreeMonthEnds)")
                Picker("Renew banner", selection: $store.uberOneRenewBannerMode) {
                    ForEach(UberOneRenewBannerMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            }

            Section("Uber One savings (Account tab)") {
                Stepper(
                    "\(store.uberOneSavings.orderCount) orders",
                    value: $store.uberOneSavings.orderCount,
                    in: 0...999
                )
                LabeledContent("Order savings") {
                    TextField(
                        "Order savings",
                        value: $store.uberOneSavings.orderSavings,
                        format: .currency(code: "USD")
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
                Stepper(
                    "\(store.uberOneSavings.rideCount) rides",
                    value: $store.uberOneSavings.rideCount,
                    in: 0...999
                )
                LabeledContent("Ride savings") {
                    TextField(
                        "Ride savings",
                        value: $store.uberOneSavings.rideSavings,
                        format: .currency(code: "USD")
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
                LabeledContent(
                    "Total shown",
                    value: store.uberOneSavings.total.formatted(.currency(code: "USD"))
                )
            }

            Section("Uber One scenarios") {
                Button("New user — no subscription") {
                    store.resetUberOne()
                }
                Button("Free month just started") {
                    store.startUberOneFreeMonth(billingPeriod: .monthly)
                }
                Button("Free month ending in 5 days") {
                    store.startUberOneFreeMonth(billingPeriod: .monthly)
                    store.setUberOneFreeMonthEnd(daysFromNow: 5)
                }
                Button("Paid — All Access, yearly") {
                    store.activateUberOnePlan(.allAccess, billingPeriod: .yearly)
                }
                Button("Expired membership") {
                    store.uberOneMembership.state = .expired
                    store.setUberOneFreeMonthEnd(daysFromNow: -3)
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
