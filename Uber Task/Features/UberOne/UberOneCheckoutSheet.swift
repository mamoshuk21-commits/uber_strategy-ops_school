//
//  UberOneCheckoutSheet.swift
//  Uber Task
//

import SwiftUI

/// Bottom sheet used for both Uber One checkout moments:
/// - `.join`: the "Join Uber One" modal (monthly/yearly, "1 month free",
///   "Try for free") that starts the free month.
/// - `.renew(plan)`: the payment confirmation modal on the renewal upsell
///   flow — content and price adapt to the selected plan.
///
/// No real payment happens: confirming only mutates `MockContentStore`.
struct UberOneCheckoutSheet: View {
    enum Mode {
        case join
        case renew(UberOnePlan)

        var plan: UberOnePlan {
            switch self {
            case .join: .standard
            case .renew(let plan): plan
            }
        }

        var isJoin: Bool {
            if case .join = self { return true }
            return false
        }
    }

    let mode: Mode
    var onConfirmed: () -> Void = {}

    @Environment(MockContentStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPeriod: UberOneBillingPeriod

    init(mode: Mode, onConfirmed: @escaping () -> Void = {}) {
        self.mode = mode
        self.onConfirmed = onConfirmed
        // Figma defaults: join preselects monthly, renewal preselects annual.
        _selectedPeriod = State(initialValue: mode.isJoin ? .monthly : .yearly)
    }

    private var plan: UberOnePlan { mode.plan }

    private var title: String {
        switch mode {
        case .join: "Join Uber One"
        case .renew(.standard): "Standard Uber One"
        case .renew(let plan): "Upgrade to \(plan.displayName)"
        }
    }

    private var ctaText: String {
        switch mode {
        case .join: "Try for free"
        case .renew(.standard): "Confirm plan"
        case .renew: "Confirm upgrade"
        }
    }

    /// Free month: billing begins when the trial ends; joining now starts a
    /// one-month trial first.
    private var billingStartDate: Date {
        switch mode {
        case .join:
            Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
        case .renew:
            store.uberOneMembership.state == .freeMonth
                ? store.uberOneMembership.freeMonthEndDate
                : .now
        }
    }

    private var selectedPriceText: String {
        let price = plan.price(for: selectedPeriod).uberOnePriceText
        return selectedPeriod == .monthly ? "\(price)/mo" : "\(price)/yr"
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(AppSpacing.md)
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    billingOption(for: .monthly)
                    billingOption(for: .yearly)
                    billingSummary
                    paymentMethodRow
                }
                .padding(AppSpacing.md)
            }

            confirmButton
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
        }
        .background(AppColor.surfacePrimary)
        .presentationDetents([.fraction(0.8), .large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack(spacing: AppSpacing.xs) {
            if !mode.isJoin {
                Image(systemName: plan.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.membershipGold)
                    .accessibilityHidden(true)
            }
            Text(title)
                .font(AppTypography.title)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: 32, height: 32)
                    .background(AppColor.chipBackground, in: Circle())
            }
            .accessibilityLabel("Close")
        }
    }

    private func billingOption(for period: UberOneBillingPeriod) -> some View {
        let isSelected = selectedPeriod == period
        return Button {
            selectedPeriod = period
        } label: {
            HStack(alignment: .top, spacing: AppSpacing.sm) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    // Only claim savings when the annual price actually beats
                    // 12 monthly payments for this plan.
                    if period == .yearly, plan.yearlySavingsVsMonthly > 0 {
                        Text("BEST VALUE")
                            .font(AppTypography.captionEmphasized)
                            .foregroundStyle(.black)
                            .padding(.horizontal, AppSpacing.xs)
                            .padding(.vertical, 3)
                            .background(AppColor.membershipRenewBackground, in: Capsule())
                    }

                    Text(period == .monthly ? "Monthly plan" : "Annual plan")
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColor.textPrimary)

                    if mode.isJoin {
                        Text("1 month free")
                            .font(AppTypography.subheadline.weight(.semibold))
                            .foregroundStyle(AppColor.membershipGold)
                    }

                    Text(priceText(for: period))
                        .font(AppTypography.subheadline)
                        .foregroundStyle(AppColor.textSecondary)

                    if period == .yearly, plan.yearlySavingsVsMonthly > 0 {
                        HStack(spacing: AppSpacing.xxs) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 12, weight: .semibold))
                            Text(yearlySavingsText)
                        }
                        .font(AppTypography.footnote.weight(.semibold))
                        .foregroundStyle(AppColor.membershipGold)
                        .padding(.top, AppSpacing.xxs)
                    }
                }

                Spacer(minLength: AppSpacing.xs)

                radioIndicator(isSelected: isSelected)
            }
            .padding(AppSpacing.md)
            .background(
                isSelected ? AppColor.membershipGold.opacity(0.08) : AppColor.surfaceElevated,
                in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .strokeBorder(
                        isSelected ? AppColor.membershipGold : AppColor.divider,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(period.displayName) plan, \(priceText(for: period))")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private func priceText(for period: UberOneBillingPeriod) -> String {
        switch period {
        case .monthly:
            return "\(plan.monthlyPrice.uberOnePriceText)/mo"
        case .yearly:
            let yearly = plan.yearlyPrice.uberOnePriceText
            if mode.isJoin {
                let perMonth = (plan.yearlyPrice / 12).uberOnePriceText
                return "\(perMonth)/mo (billed at \(yearly)/yr)"
            }
            return "\(yearly)/yr"
        }
    }

    private var yearlySavingsText: String {
        let savings = plan.yearlySavingsVsMonthly.uberOnePriceText
        return mode.isJoin
            ? "Save an extra \(savings) each year compared to a monthly plan"
            : "Save \(savings) a year vs monthly"
    }

    private func radioIndicator(isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                Circle()
                    .fill(AppColor.surfaceInverted)
                Circle()
                    .fill(AppColor.textOnInvertedSurface)
                    .frame(width: 8, height: 8)
            } else {
                Circle()
                    .strokeBorder(AppColor.divider, lineWidth: 1.5)
            }
        }
        .frame(width: 24, height: 24)
        .accessibilityHidden(true)
    }

    private var billingSummary: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Billing starts \(billingStartDate.formatted(date: .abbreviated, time: .omitted)) for \(selectedPriceText).")
                .font(AppTypography.subheadline.weight(.semibold))
            Text("Cancel without fees or penalties.")
                .font(AppTypography.subheadline.weight(.semibold))
            Text(legalCopy)
                .font(AppTypography.footnote)
                .foregroundStyle(AppColor.textSecondary)
        }
        .foregroundStyle(AppColor.textPrimary)
    }

    private var legalCopy: String {
        let action = mode.isJoin ? "joining" : "upgrading"
        let charge = plan.price(for: selectedPeriod).uberOnePriceText
        let cadence = selectedPeriod == .monthly ? "monthly" : "annually"
        return "By \(action), you authorize a mock charge of \(charge) on any payment method "
            + "on your account, and \(cadence) thereafter, based on the terms, until you cancel. "
            + "To avoid charges cancel up to 48 hours before the renewal date in the app. "
            + "View terms and conditions. Prototype only — no real payment is made."
    }

    /// Visual-only mock: real payment methods are out of scope for the prototype.
    private var paymentMethodRow: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "creditcard")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppColor.textSecondary)
            Text("Add Payment Method")
                .font(AppTypography.bodyEmphasized)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColor.textTertiary)
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Add payment method. Mock row, not functional in this prototype")
    }

    private var confirmButton: some View {
        Button {
            switch mode {
            case .join:
                store.startUberOneFreeMonth(billingPeriod: selectedPeriod)
            case .renew(let plan):
                store.activateUberOnePlan(plan, billingPeriod: selectedPeriod)
            }
            dismiss()
            onConfirmed()
        } label: {
            Text(ctaText)
                .font(AppTypography.bodyEmphasized)
                .foregroundStyle(AppColor.textOnInvertedSurface)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppColor.surfaceInverted, in: Capsule())
        }
        .accessibilityLabel(ctaText)
        .accessibilityHint(mode.isJoin ? "Starts your free month" : "Confirms the selected plan")
    }
}

#Preview("Join") {
    Color.clear.sheet(isPresented: .constant(true)) {
        UberOneCheckoutSheet(mode: .join)
    }
    .environment(MockContentStore())
}

#Preview("Renew — Extra Rides") {
    Color.clear.sheet(isPresented: .constant(true)) {
        UberOneCheckoutSheet(mode: .renew(.extraRides))
    }
    .environment(MockContentStore())
}
