//
//  SignUpView.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding private var email: String
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @EnvironmentObject var vm: AuthViewClusterModel
    @FocusState private var focusField: FocusText?
    enum FocusText { case email, password, confirmPassword }
    
    init(email: Binding<String>) {
        self._email = email
    }
    
    private func createUser() {
        TaskManager.shared.startLoading()
        Task {
            try await vm.createUser(withEmail: email, password: password)
            TaskManager.shared.stopLoading()
        }
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
            
            Button {
                createUser()
            } label: {
                Text("Create Account")
                    .modifier(PrimaryButtonMod())
            }

            Spacer()
            
            Divider()
            
            Button {
                vm.currentState = .loginEmail
            } label: {
                Text("Back to sign in")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: 32)
            }
            .buttonStyle(.borderless)
        } //: VStack
        .navigationTitle("Sign up")
        .tint(.accent)

    } //: Body
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(email: .constant(""))
            .environmentObject(AuthViewClusterModel())
            .padding()
    }
}
