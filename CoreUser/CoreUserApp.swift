//
//  CoreUserApp.swift
//  CoreUser
//
//  Created by Ryan Smetana on 5/21/24.
//

// TODO: Dismiss keyboard while loading

import SwiftUI
import Firebase

@main
struct CoreUserApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .defaultAppStorage(.standard)
        }
    }
}
