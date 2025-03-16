//
//  MainMessagesView.swift
//  CoreUser
//
//  Created by Smetana, Ryan on 1/18/23.
//

import SwiftUI

struct HomeView: View {
    @State var navigationService: NavigationService = NavigationService()
    
    var body: some View {
        NavigationStack(path: $navigationService.path) {
            Text("Home")
                .navigationDestination(for: NavPath.self, destination: { getDestination(for: $0) })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Menu", systemImage: "line.horizontal.3") {
                            navigationService.push(.menuView)
                        }
                        .buttonStyle(.borderless)
                        .labelStyle(.iconOnly)
                    }
                }
                .navigationTitle("Home")
        } //: Navigation Stack
        .background(.bg100)
        .environment(navigationService)
    } //: Body
    
    @ViewBuilder
    func getDestination(for path: NavPath) -> some View {
        switch path {
        case .menuView: MenuView()
        case .profileView: ProfileView()
        case .settings: SettingsView()
        default: Text("Oops, something went wrong. Please close the app and try again.")
        }
    }
    
}

#Preview {
    HomeView()
}
