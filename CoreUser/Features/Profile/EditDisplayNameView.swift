//
//  EditDisplayNameView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/12/24.
//

import SwiftUI

struct EditDisplayNameView: View {
    @EnvironmentObject var vm: ProfileViewModel
    enum FocusText { case displayName }
    @FocusState private var focusField: FocusText?
    
    @State private var displayName: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            ThemeField(placeholder: "Display Name", boundTo: $displayName, iconName: "person.fill")
                .autocorrectionDisabled()
                .scrollDismissesKeyboard(.interactively)
                .textInputAutocapitalization(.words)
                .submitLabel(.return)
                .focused($focusField, equals: .displayName)
                .onSubmit { focusField = nil }
                .onTapGesture { focusField = .displayName }
            
            
            Spacer()
            
            Button {
                Task {
                    await vm.updateDisplayName(to: displayName)
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .modifier(PrimaryButtonMod())
            
            Button {
//                vm.changeView(to: .viewProfile)
            } label: {
                Text("Cancel")
                    .underline()
            }
            .foregroundStyle(.black)
            .padding(.vertical)
        } //: VStack
        .foregroundStyle(.black)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Display name")
    }
}

#Preview {
    EditDisplayNameView()
        .environmentObject(ProfileViewModel())
}
