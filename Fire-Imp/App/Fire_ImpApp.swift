//
//  Fire_ImpApp.swift
//  Fire-Imp
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import Firebase

@main
struct FireImpApp: App {
    
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
