//
//  MainMessagesView.swift
//  FireImp
//
//  Created by Smetana, Ryan on 1/18/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(NavigationService.self) var navigationService
    
    var body: some View {
        @Bindable var navigationService = navigationService
        NavigationStack(path: $navigationService.path) {
            HomeView()
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
        .background(.bg)
        .defaultAppStorage(.standard)
    } //: Body
    
    @ViewBuilder
    func getDestination(for path: NavPath) -> some View {
        switch path {
        case .menuView: MenuView()
        case .profileView: ProfileView()
        default: Text("Oops, something went wrong. Please close the app and try again.")
        }
    }
    
}

#Preview {
    HomeView()
}
