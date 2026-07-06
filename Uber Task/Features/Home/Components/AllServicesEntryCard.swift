//
//  AllServicesEntryCard.swift
//  Uber Task
//

import SwiftUI

/// Entry point from Home into the full production-style services
/// catalog (`ServicesListView`), grouped by category.
struct AllServicesEntryCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.textOnInvertedSurface)
                    .frame(width: 44, height: 44)
                    .background(AppColor.surfaceInverted, in: RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text("All services")
                        .font(AppTypography.bodyEmphasized)
                        .foregroundStyle(AppColor.textPrimary)
                    Text("Browse every ride and delivery option")
                        .font(AppTypography.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColor.textTertiary)
            }
            .padding(AppSpacing.sm)
            .cardBackground()
        }
        .accessibilityLabel("All services")
        .accessibilityHint("Double tap to browse the full service catalog")
    }
}

#Preview {
    AllServicesEntryCard(action: {})
        .padding()
        .background(AppColor.surfaceSecondary)
}
