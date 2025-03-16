//
//  ProfileView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/7/23.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel = ProfileViewModel()
    
    @State var user: User?
    @Environment(NavigationService.self) var navigationService
    
    var navTitleText: String {
        switch vm.currentState {
        case .viewProfile:      return "Profile"
        case .editDisplayName:  return "Edit Display Name"
        case .editEmail:        return "Edit Email"
        }
    }
    
    var body: some View {
        VStack {
            switch vm.currentState {
            case .viewProfile:
                profileView
                
            case .editDisplayName:
                EditDisplayNameView()
                    .environmentObject(vm)
                
            case .editEmail:
                EditEmailView()
                    .environmentObject(vm)
                    .padding()
            }
            Spacer()
        } //: VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg)
        .navigationTitle(navTitleText)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .toolbar() {
            if vm.currentState == .viewProfile {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationService.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    } //: Button
                    .foregroundStyle(.accent)
                    .opacity(0.8)
                }
            }
        } //: Toolbar
        .onReceive(vm.$user) { newUser in
            user = newUser
        }
        .onReceive(vm.$reauthenticationRequired) { reqReauth in
            if reqReauth == true {
                vm.currentState = .viewProfile
                navigationService.popToRoot()
                AuthService.shared.signout()
            }
        }
    } //: Body
    
    private var profileView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Display Name:")
                .font(.headline)
            
            HStack {
                
                Text(vm.user?.displayName ?? "")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    vm.changeView(to: .editDisplayName)
                } label: {
                    Image(systemName: "plus")
                    Text("Add")
                }
                .opacity(0.6)
                
            } //: HStack
                
            Divider()
            
            HStack {
                Text("Email:")
                    .font(.headline)
                
                Spacer()
                
                HStack {
                    Image(systemName: vm.user?.emailVerified == true ? "checkmark.circle.fill" : "slash.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                    
                    Text(vm.user?.emailVerified == true ? "Verified" : "Not Verified")
                        .font(.caption)
                } //: HStack
                .foregroundStyle(vm.user?.emailVerified == true ? .green : .gray)
                
            } //: HStack
            
            HStack {
                Text(verbatim: vm.user?.email ?? "")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    vm.changeView(to: .editEmail)
                } label: {
                    Text("Edit")
                        .font(.callout)
                        .fontWeight(.light)
                }
            } //: HStack
        } //: VStack
        .padding()
        .modifier(SubViewStyleMod())
        .foregroundStyle(.black)
        
    } //: Profile View
    
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

