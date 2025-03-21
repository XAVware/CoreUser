//
//  ThemeButtonStyle.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/20/25.
//

import SwiftUI

struct ThemeButtonStyle: ButtonStyle {
    enum Prominence { case primary, secondary }
    @State var prominence: Prominence
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .frame(maxWidth: maxWidth)
            .foregroundStyle(foregroundStyle)
            .font(font)
            .fontDesign(.rounded)
            .background(
                Color.accentColor.gradient
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
    
    private var maxWidth: CGFloat {
        switch prominence {
        case .primary:      return 420
        case .secondary:    return 240
        }
    }
    
    private var foregroundStyle: Color {
        switch prominence {
        case .primary:      return Color.textDark
        case .secondary:    return Color.textDark.opacity(0.8)
        }
    }
    
    private var font: Font {
        switch prominence {
        case .primary:      return .title3
        case .secondary:    return .headline
        }
    }
}
