//
//  PersonalizedSectionView.swift
//  Uber Task
//

import SwiftUI

/// A named horizontally-scrolling row of suggestion cards
/// (e.g. "Suggestions", "Go again", "Food near you").
struct PersonalizedSectionView: View {
    let section: HomeSection
    let onSelect: (SuggestionCard) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeaderView(title: section.title)

            ScrollView(.horizontal) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(section.cards) { card in
                        SuggestionCardView(card: card, action: { onSelect(card) })
                    }
                }
                .padding(.horizontal, 1) // keeps shadows from clipping at scroll edges
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct SuggestionCardView: View {
    let card: SuggestionCard
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Image(systemName: card.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(AppColor.chipBackground, in: Circle())

                Spacer(minLength: 0)

                Text(card.title)
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(1)
                Text(card.subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(1)
            }
            .padding(AppSpacing.sm)
            .frame(width: AppMetrics.suggestionCardWidth, height: AppMetrics.suggestionCardHeight, alignment: .leading)
            .cardBackground()
        }
        .accessibilityLabel("\(card.title), \(card.subtitle)")
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            ForEach(MockHomeSections.all) { section in
                PersonalizedSectionView(section: section, onSelect: { _ in })
            }
        }
        .padding()
    }
    .background(AppColor.surfaceSecondary)
}
