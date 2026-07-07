//
//  UberOneDetailsView.swift
//  Uber Task
//

import SwiftUI

/// Uber One subscription details screen. Reached from the Home carousel and
/// the Account tab. Non-members see the benefits pitch and "Join Uber One";
/// members see their status and the mock savings summary instead.
struct UberOneDetailsView: View {
    @Environment(MockContentStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showsJoinSheet = false

    private var membership: UberOneMembership { store.uberOneMembership }
    private var isMember: Bool { membership.state.isMember }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                header

                if isMember {
                    UberOneSavingsCard(savings: store.uberOneSavings)
                }

                benefitsList

                if !isMember {
                    averageSavingsCallout
                }

                Text(MockUberOne.benefitsFootnote)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textTertiary)
            }
            .padding(AppSpacing.screenMargin)
        }
        .background(AppColor.surfacePrimary.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            if !isMember {
                joinButton
                    .padding(.horizontal, AppSpacing.screenMargin)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColor.surfacePrimary)
            }
        }
        // Title lives in the content (per the design); keep the bar chrome minimal.
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showsJoinSheet) {
            UberOneCheckoutSheet(mode: .join, onConfirmed: { dismiss() })
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Text("Uber One")
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColor.textPrimary)

            switch membership.state {
            case .notSubscribed, .expired:
                HStack(spacing: AppSpacing.xs) {
                    Text("\(UberOnePlan.standard.monthlyPrice.uberOnePriceText)/mo")
                        .strikethrough()
                        .foregroundStyle(AppColor.textSecondary)
                    Text("1 month free")
                        .foregroundStyle(AppColor.membershipGold)
                        .fontWeight(.semibold)
                }
                .font(AppTypography.body)
            case .freeMonth:
                Text("Free month · ends \(membership.freeMonthEndDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.membershipGold)
            case .paidActive:
                Text("\((membership.plan ?? .standard).displayName) · \(membership.billingPeriod.displayName)")
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.membershipGold)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var benefitsList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            ForEach(MockUberOne.membershipBenefits) { benefit in
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Image(systemName: benefit.systemImage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColor.membershipGold)
                        .frame(width: 32, height: 32)
                        .background(AppColor.membershipGold.opacity(0.12), in: Circle())
                        .accessibilityHidden(true)

                    Text(benefit.text)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var averageSavingsCallout: some View {
        VStack(spacing: AppSpacing.xs) {
            Image("UberOneRingLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)
            Text("Save \(MockUberOne.averageMonthlySavings.uberOneWholePriceText) every month")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppColor.membershipGold)
            Text("That's how much people save on average from member pricing, cash back, and promos in your country")
                .font(AppTypography.footnote)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .accessibilityElement(children: .combine)
    }

    private var joinButton: some View {
        Button {
            showsJoinSheet = true
        } label: {
            Text("Join Uber One")
                .font(AppTypography.bodyEmphasized)
                .foregroundStyle(AppColor.textOnInvertedSurface)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppColor.surfaceInverted, in: Capsule())
        }
        .accessibilityLabel("Join Uber One")
        .accessibilityHint("Opens plan selection with one month free")
    }
}

/// "Money saved" summary card (total + orders/rides breakdown), matching the
/// membership details design. Reused by previews and the details screen.
struct UberOneSavingsCard: View {
    let savings: UberOneSavingsSummary

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text("Money saved")
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColor.textPrimary)
                Spacer()
                Text(savings.total.uberOnePriceText)
                    .font(AppTypography.title)
                    .foregroundStyle(AppColor.membershipGold)
            }
            savingsRow(label: "\(savings.orderCount) orders", amount: savings.orderSavings)
            savingsRow(label: "\(savings.rideCount) rides", amount: savings.rideSavings)
        }
        .padding(AppSpacing.md)
        .background(AppColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Money saved with Uber One: \(savings.total.uberOnePriceText). "
                + "\(savings.orderCount) orders, \(savings.rideCount) rides"
        )
    }

    private func savingsRow(label: String, amount: Double) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            Text(amount.uberOnePriceText)
                .foregroundStyle(AppColor.textSecondary)
        }
        .font(AppTypography.subheadline)
    }
}

#Preview("Not subscribed") {
    NavigationStack {
        UberOneDetailsView()
    }
    .environment(MockContentStore())
}

#Preview("Free month") {
    let store = MockContentStore()
    store.startUberOneFreeMonth(billingPeriod: .monthly)
    return NavigationStack {
        UberOneDetailsView()
    }
    .environment(store)
}

#Preview("Dark") {
    NavigationStack {
        UberOneDetailsView()
    }
    .environment(MockContentStore())
    .preferredColorScheme(.dark)
}
