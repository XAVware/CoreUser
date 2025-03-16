//
//  ResetPasswordView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 9/16/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var vm: AuthViewModel
    @Binding private var email: String
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case email }
    
    init(email: Binding<String>) {
        self._email = email
    }

    var body: some View {
        VStack(spacing: 24) {
            
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
                .padding(.vertical)
            
            Spacer()
                        
            Button("Send Reset Link", action: sendLinkTapped)
                .modifier(PrimaryButtonMod())
            
            Spacer()
        } //: VStack
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Reset password")
        .tint(.accent)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "xmark") {
                    vm.changeState(to: .loginEmail)
                }
            }
        }
    }
    
    private func sendLinkTapped() {
        Task {
            await vm.continueTapped(email: email)
        }
    }
}

#Preview {
    ResetPasswordView(email: .constant(""))
        .environmentObject(AuthViewModel())
        .padding()
}
