//
//  MainMessagesView.swift
//  FireImp
//
//  Created by Smetana, Ryan on 1/18/23.
//

import SwiftUI
//import Firebase

@MainActor class HomeViewModel: ObservableObject {
    @Published var navPath: [ViewPath] = []

    func pushView(_ viewPath: ViewPath) {
        navPath.append(viewPath)
    }
}

struct HomeView: View {
    @StateObject var ENV = EnvironmentManager.shared
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        Group {
            if ENV.isOnboarding == false {
                homePage
            } else {
                LoadingView()
            }
        }
        .background(.bg)
        .defaultAppStorage(.standard)
        .sheet(isPresented: $ENV.isOnboarding) {
            OnboardingView()
        }
    } //: Body
    
    private var homePage: some View {
        NavigationStack(path: $vm.navPath) {
            VStack {
                Button {
                    vm.pushView(.menuView)
                } label: {
                    Text("Open Menu")
                }
                .buttonStyle(BorderedProminentButtonStyle())
            } //: VStack
            .navigationTitle("Home")
            .navigationDestination(for: ViewPath.self) { view in
                switch view {
                case .menuView:                     MenuView(navPath: $vm.navPath)
                case .profileView:                  ProfileView(navPath: $vm.navPath)
                default: Text("Error")
                }
            } //: Navigation Destination
        } //: Navigation Stack
    } //: Content
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
