//
//  ReauthenticationView.swift
//  MeteorMouth
//
//  Created by Ryan Smetana on 1/22/25.
//

import SwiftUI

struct ReauthenticationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ProfileViewModel
    let user: User
    @State var password: String = ""
    let onSucces: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sign in")
                    .font(.largeTitle)
                Text("Sign in to confirm its you")
                    .font(.title3)
                    .opacity(0.6)
            }
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(user.email)
                    .fontWeight(.bold)
                TextField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            HStack {
                Button("Cancel", action: cancelTapped)
                    .ignoresSafeArea(.keyboard)
                Spacer()
                Button("Login", action: loginTapped)
                    .ignoresSafeArea(.keyboard)
                    .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            Spacer()
            
        } //: VStack
        .padding()
        .background(Color.bg100)
        
    }
    
    private func loginTapped() {
        Task {
            let success = await vm.reauthenticate(withEmail: user.email, password: password)
            if success {
                onSucces()
                dismiss()
            }
        }
    }
    
    private func cancelTapped() {
        dismiss()
    }
}
