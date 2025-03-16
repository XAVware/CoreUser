//
//  ResetPasswordView.swift
//  FireImp
//
//  Created by Ryan Smetana on 9/16/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var vm: AuthViewClusterModel
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
                        
            Button {
                TaskManager.shared.startLoading()
                Task {
                    try await vm.sendResetPasswordEmail(to: email)
                    TaskManager.shared.stopLoading()
                }
            } label: {
                Text("Send Reset Link")
                    .modifier(PrimaryButtonMod())
            }
            
            Spacer()
        } //: VStack
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Reset password")
        .tint(.accent)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "xmark") {
                    vm.currentState = .loginEmail
                }
            }
        })
    }
}


struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(email: .constant(""))
            .environmentObject(AuthViewClusterModel())
            .padding()
    }
}
