//
//  Fire_ImpApp.swift
//  Fire-Imp
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import Firebase

@main
struct Fire_ImpApp: App {
    @State var navigationService: NavigationService = NavigationService()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(navigationService)
                .defaultAppStorage(.standard)
        }
    }
}
