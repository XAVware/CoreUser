//
//  ContentView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI

struct RootView: View {
    @StateObject var vm = UserManager.shared
    @StateObject var session = TaskManager.shared
    @StateObject var alertService = AlertService.shared
    
    var body: some View {
        Group {
            if vm.isOnboarding == false {
                HomeView()
            } else {
                OnboardingView()
            }
        } //: ZStack
        .background(Color.bg100)
        .fullScreenCover(isPresented: .init(
            get: { vm.currentUser == nil },
            set: { _ in }
        )) {
            AuthView()
                .overlay(session.isLoading ? LoadingView() : nil)
                .overlay(
                    Group {
                        if let alert = alertService.currentAlert {
                            AlertView(alert: alert)
                        }
                    }
                    , alignment: .top)
        }
    } //: Body
}

#Preview {
    RootView()
}
