//
//  LoginView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 9/16/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: AuthViewModel
    
    @Binding private var email: String
    @State private var password = ""
    @State private var showPassword = false
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case email, password }
        
    @State var loginRequired: Bool = false
    
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
                    .onSubmit { focusField = nil }
                
                ThemeField(placeholder: "Password", boundTo: $password, iconName: "lock")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.continue)
                    .focused($focusField, equals: .password)
                    .onTapGesture { focusField = .password }
                    .onSubmit { focusField = nil }
                
                HStack {
                    Spacer()
                    Button("Forgot Password?", action: forgotPasswordTapped)
                        .padding(.horizontal)
                } //: HStack
                .padding(.vertical, 8)
                
            } //: VStack
            .padding(.vertical)
            
            Button("Log In", action: loginTapped)
                .modifier(PrimaryButtonMod())
                .padding(.vertical)
                .ignoresSafeArea(.keyboard)
            
            Spacer()
            
            Divider()
            
            Button("Create an account", action: createAccountTapped)
                .ignoresSafeArea(.keyboard)
        } //: VStack
        .padding()
        .navigationTitle("Sign in")
        .tint(.accent)
        .toolbar { toolbarContent }
    } //: Body
    
    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        if loginRequired {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "xmark") {
                    dismiss()
                }
            }
        }
    }
    
    private func loginTapped() {
        Task {
            await vm.continueTapped(email: email, passwordSet: [password])
        }
    }
    
    private func createAccountTapped() {
        vm.changeState(to: .signUpEmail)
    }
    
    private func forgotPasswordTapped() {
        vm.changeState(to: .forgotPassword)
    }
}

#Preview {
    LoginView(email: .constant(""))
        .environmentObject(AuthViewModel())
        .padding()
}
