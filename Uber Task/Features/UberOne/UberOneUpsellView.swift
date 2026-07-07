//
//  UberOneUpsellView.swift
//  Uber Task
//

import SwiftUI

/// Renewal upsell screen shown when the user taps "Renew" on the Home
/// banner before the free month ends: keep Standard Uber One or upgrade to
/// Extra Rides, Extra Eats, or All Access. Confirming opens the payment
/// confirmation sheet for the selected plan.
struct UberOneUpsellView: View {
    @Environment(MockContentStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: UberOnePlan = .allAccess
    @State private var checkoutPlan: UberOnePlan?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Renew Uber One")
                        .font(AppTypography.largeTitle)
                        .foregroundStyle(AppColor.textPrimary)
                    Text("Before you renew — pick the plan that fits you best.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.textSecondary)
                }

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    sectionLabel("Keep your current plan")
                    planCard(.standard)
                }

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    sectionLabel("Upgrade & get more")
                    planCard(.extraRides)
                    planCard(.extraEats)
                    planCard(.allAccess)
                }

                Text("Cancel anytime, no fees.")
                    .font(AppTypography.footnote)
                    .foregroundStyle(AppColor.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(AppSpacing.screenMargin)
        }
        .background(AppColor.surfacePrimary.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) { bottomActions }
        // Title lives in the content (per the design); keep the bar chrome minimal.
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $checkoutPlan) { plan in
            UberOneCheckoutSheet(mode: .renew(plan), onConfirmed: { dismiss() })
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(AppTypography.captionEmphasized)
            .foregroundStyle(AppColor.textSecondary)
            .kerning(0.8)
    }

    private func planCard(_ plan: UberOnePlan) -> some View {
        UberOnePlanOptionCard(
            plan: plan,
            isSelected: selectedPlan == plan,
            onSelect: { selectedPlan = plan }
        )
    }

    private var bottomActions: some View {
        VStack(spacing: AppSpacing.sm) {
            Button {
                checkoutPlan = selectedPlan
            } label: {
                Text("Confirm & renew")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.textOnInvertedSurface)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColor.surfaceInverted, in: Capsule())
            }
            .accessibilityLabel("Confirm and renew with \(selectedPlan.displayName)")

            Button {
                selectedPlan = .standard
                checkoutPlan = .standard
            } label: {
                Text("Keep Standard plan")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(minHeight: AppMetrics.minTapTarget)
            }
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Keep Standard plan")
        }
        .padding(.horizontal, AppSpacing.screenMargin)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColor.surfacePrimary)
    }
}

/// Selectable plan card on the upsell screen: radio, name, price, and — for
/// upgrade plans — the "Everything in Standard, plus:" benefits list.
private struct UberOnePlanOptionCard: View {
    let plan: UberOnePlan
    let isSelected: Bool
    let onSelect: () -> Void

    private var isUpgrade: Bool { plan != .standard }

    /// "+$2.99/mo more" delta shown for upgrade plans.
    private var monthlyDelta: Double { plan.monthlyPrice - UberOnePlan.standard.monthlyPrice }

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(isSelected ? AppColor.surfaceInverted : AppColor.divider)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.displayName)
                            .font(AppTypography.headline)
                            .foregroundStyle(AppColor.textPrimary)
                        Text(plan.tagline)
                            .font(AppTypography.footnote)
                            .foregroundStyle(AppColor.textSecondary)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer(minLength: AppSpacing.xs)

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(plan.monthlyPrice.uberOnePriceText)/mo")
                            .font(AppTypography.bodyEmphasized)
                            .foregroundStyle(AppColor.textPrimary)
                        if isUpgrade {
                            Text("+\(monthlyDelta.uberOnePriceText)/mo more")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColor.membershipGold)
                        }
                    }
                }

                if !plan.upsellBenefits.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Everything in Standard, plus:")
                            .font(AppTypography.subheadline.weight(.semibold))
                            .foregroundStyle(AppColor.membershipGold)

                        ForEach(plan.upsellBenefits) { benefit in
                            HStack(spacing: AppSpacing.xs) {
                                Image(systemName: benefit.systemImage)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(AppColor.membershipGold)
                                    .frame(width: 22)
                                Text(benefit.text)
                                    .font(AppTypography.subheadline)
                                    .foregroundStyle(AppColor.textPrimary)
                            }
                        }
                    }
                    .padding(.leading, 24 + AppSpacing.sm)
                }
            }
            .padding(AppSpacing.md)
            .background(
                isSelected ? AppColor.membershipGold.opacity(0.08) : AppColor.surfaceElevated,
                in: RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .strokeBorder(
                        isSelected ? AppColor.membershipGold : AppColor.divider,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .overlay(alignment: .topTrailing) {
                if plan.isBestValue {
                    Text("BEST VALUE")
                        .font(AppTypography.captionEmphasized)
                        .foregroundStyle(.black)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(AppColor.membershipRenewBackground, in: Capsule())
                        .offset(y: -12)
                        .padding(.trailing, AppSpacing.md)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private var accessibilitySummary: String {
        var parts = ["\(plan.displayName), \(plan.monthlyPrice.uberOnePriceText) per month"]
        if plan.isBestValue { parts.append("Best value") }
        if isUpgrade { parts.append(plan.tagline) }
        return parts.joined(separator: ". ")
    }
}

#Preview {
    NavigationStack {
        UberOneUpsellView()
    }
    .environment(MockContentStore())
}

#Preview("Dark") {
    NavigationStack {
        UberOneUpsellView()
    }
    .environment(MockContentStore())
    .preferredColorScheme(.dark)
}
