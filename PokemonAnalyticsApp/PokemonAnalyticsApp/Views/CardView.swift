//
//  CardView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 30/08/25.
//

import SwiftUI

public struct CardView<Content: View>: View {
	private let cornerRadius: CGFloat = 15
	private var internalVerticalPadding: CGFloat = 20
	private var internalHorizontalPadding: CGFloat = 11
	private let alignment: HorizontalAlignment
	private let spacing: CGFloat
	private let content: Content
	private let fillWidth: Bool
    private let fillColor: Color

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat = 8,
                internalVerticalPadding: CGFloat = 20,
                internalHorizontalPadding: CGFloat = 11,
                fillWidth: Bool = true,
                fillColor: Color = .white,
                @ViewBuilder content: () -> Content) {
		self.alignment = alignment
		self.spacing = spacing
		self.fillWidth = fillWidth
        self.internalVerticalPadding = internalVerticalPadding
        self.internalHorizontalPadding = internalHorizontalPadding
        self.fillColor = fillColor
		self.content = content()
	}

    public var body: some View {
		VStack(alignment: alignment, spacing: spacing) {
			content
				.padding(.vertical, internalVerticalPadding)
				.padding(.horizontal, internalHorizontalPadding)
		}
		.frame(maxWidth: fillWidth ? .infinity : nil)
		.background(
			RoundedRectangle(cornerRadius: cornerRadius)
				.foregroundColor(fillColor)
				.shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
		)
	}
}
