//
//  SectionHeaderView.swift
//  Uber Task
//

import SwiftUI

/// Standard section title row used above every horizontally scrolling or
/// grouped content section on Home and Services.
struct SectionHeaderView: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.textSecondary)
                    .accessibilityLabel("\(actionTitle) \(title)")
            }
        }
    }
}

#Preview {
    SectionHeaderView(title: "Suggestions", actionTitle: "See all", action: {})
        .padding()
}
