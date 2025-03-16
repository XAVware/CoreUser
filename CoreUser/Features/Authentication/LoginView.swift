//
//  LoginView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 9/16/23.
//

import SwiftUI


struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: AuthViewClusterModel
    
    @Binding private var email: String
    @State private var password = ""
    @State private var showPassword = false
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case email, password }
        
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
                    Button {
                        vm.currentState = .forgotPassword
                    } label: {
                        Text("Forgot Password?")
                            .padding(.horizontal)
                    }
                } //: HStack
                .padding(.vertical, 8)
                
            } //: VStack
            .padding(.vertical)
            
            Button {
                Task {
                    try await vm.login(withEmail: email, password: password)
                }
            } label: {
                Text("Log In")
                    .modifier(PrimaryButtonMod())
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                vm.currentState = .signUpEmail
            } label: {
                Text("Create an account")
                    .ignoresSafeArea(.keyboard)
            }
        } //: VStack
        .padding()
        .navigationTitle("Sign in")
        .tint(.accent)
        // If you want to making logging in optional:
//        .toolbar(content: {
//            ToolbarItem(placement: .topBarLeading) {
//                Button("", systemImage: "xmark") {
//                    dismiss()
//                }
//            }
//        })
    } //: Body
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(email: .constant(""))
            .environmentObject(AuthViewClusterModel())
            .padding()
    }
}
