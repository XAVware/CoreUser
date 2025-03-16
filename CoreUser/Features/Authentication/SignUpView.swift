//
//  SignUpView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding private var email: String
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @EnvironmentObject var vm: AuthViewModel
    @FocusState private var focusField: FocusText?
    enum FocusText { case email, password, confirmPassword }
    
    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        VStack(spacing: 24) {

            VStack(spacing: 16) {
                ThemeField(placeholder: "Email", boundTo: $email, iconName: "envelope")
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onTapGesture { focusField = .email }
                    .onSubmit {
                        focusField = nil
                    }
                
                ThemeField(placeholder: "Password", boundTo: $password, iconName: "lock")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .password)
                    .onTapGesture { focusField = .password }
                    .onSubmit {
                        focusField = .confirmPassword
                    }
                
                ThemeField(placeholder: "Confirm Password", boundTo: $confirmPassword, iconName: "lock")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.continue)
                    .focused($focusField, equals: .confirmPassword)
                    .onTapGesture { focusField = .confirmPassword }
                    .onSubmit { createUser() }
            } //: VStack
            .padding(.vertical)
            
            Button("Create Account", action: createUser)
                .modifier(PrimaryButtonMod())

            Spacer()
            
            Divider()
            Button("Back to sign in", action: toSignInTapped)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: 32)
                .buttonStyle(.borderless)
        } //: VStack
        .navigationTitle("Sign up")
        .tint(.accent)

    } //: Body
    
    private func createUser() {
        Task {
            await vm.continueTapped(email: email, passwordSet: [password, confirmPassword])
        }
    }
    
    private func toSignInTapped() {
        vm.changeState(to: .loginEmail)
    }
}

#Preview {
    SignUpView(email: .constant(""))
        .environmentObject(AuthViewModel())
}
