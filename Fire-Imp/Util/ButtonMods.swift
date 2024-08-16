//
//  RoundedButtonMod.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI

struct PrimaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 360, height: 44)
            .background(Color.accent)
            .cornerRadius(8)
            .padding()
    }
}
    
struct SecondaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 200, maxHeight: 36)
            .font(.headline)
            .controlSize(.regular)
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
    }
}

struct TertiaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderless)
            .controlSize(.regular)
    }
}
