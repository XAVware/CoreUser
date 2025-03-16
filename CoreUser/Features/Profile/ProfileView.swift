//
//  ProfileView.swift
//  CoreUser
//
//  Created by Smetana, Ryan on 2/7/23.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @Environment(NavigationService.self) var navigationService
    @StateObject var vm: ProfileViewModel = ProfileViewModel()
    
    @State var user: User?
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var emailIsVerified = false
    
    @State var isShowingLogin: Bool = false
    
    var body: some View {
        List {
            Section("Display Name") {
                HStack {
                    TextField("Display name", text: $displayName)
                    Button("Change", action: changeDisplayNameTapped)
                } //: HStack
            } //: Section
            
            Section("Email") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        TextField("Email", text: $email)
                        Button("Change", action: changeEmailTapped)
                            .disabled(email == user?.email)
                    } //: HStack
                    
                    HStack(spacing: 6) {
                        Image(systemName: vm.user?.emailVerified == true ? "checkmark.circle.fill" : "slash.circle")
                        Text(vm.user?.emailVerified == true ? "Verified" : "Not Verified")
                    } //: HStack
                    .font(.caption2)
                    .foregroundStyle(vm.user?.emailVerified == true ? .green : .gray)
                } //: VStack
            } //: Section
        } //: List
        .onAppear {
            if let user = vm.user {
                self.displayName = user.displayName ?? ""
                self.email = user.email
            }
        }
        .navigationTitle("Profile")
        .background(.bg)
        .navigationBarTitleDisplayMode(.large)
        .onReceive(vm.$user) { newUser in
            user = newUser
        }
        .sheet(isPresented: $isShowingLogin) {
            if let user = user {
                ReauthenticationView(vm: self.vm, user: user) {
                    Task {
                        await vm.updateEmail(to: email)
                    }
                }
            } else {
                Text("Something went wrong")
            }
        }
        
        
    } //: Body
    
    
    private func changeDisplayNameTapped() {
        Task {
            await vm.updateDisplayName(to: displayName)
        }
    }
    
    private func changeEmailTapped() {
        self.isShowingLogin.toggle()
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

