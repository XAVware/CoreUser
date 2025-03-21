//
//  SubViewStyleMod.swift
//  CoreUser
//
//  Created by Ryan Smetana on 1/3/24.
//

import SwiftUI

struct SubViewStyleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 1)
            )
    }
}

struct EmailFieldMod: ViewModifier {
    @State var submitLabel: SubmitLabel = .next
    func body(content: Content) -> some View {
        content
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .submitLabel(submitLabel)
    }
}
