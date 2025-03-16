//
//  EditEmailView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/12/24.
//

import SwiftUI

struct EditEmailView: View {
    @EnvironmentObject var vm: ProfileViewModel
    
    enum FocusText { case email }
    @FocusState private var focusField: FocusText?
    
    @State private var email: String = ""
    
    var body: some View {
        VStack(spacing: 16) {  
            
            ThemeField(placeholder: "Email", boundTo: $email, iconName: "envelope")
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.return)
                .focused($focusField, equals: .email)
                .onSubmit { focusField = nil }
                .onTapGesture { focusField = .email }
            
            Spacer()
            
            Button {
                Task {
                    await vm.updateEmail(to: email)
                }
            } label: {
                Text("Save")
                    .modifier(PrimaryButtonMod())
            }
            
            Button {
//                vm.changeView(to: .viewProfile)
            } label: {
                Text("Cancel")
                    .underline()
            }
            .foregroundStyle(.black)
        } //: VStack
        .navigationTitle("Email")
    } //: Body
}

#Preview {
    EditEmailView()
        .environmentObject(ProfileViewModel())
        .padding()
}
