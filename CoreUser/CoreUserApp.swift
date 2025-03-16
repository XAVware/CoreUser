//
//  CoreUserApp.swift
//  CoreUser
//
//  Created by Ryan Smetana on 5/21/24.
//

/*
 TODO: If user tries changing email to an email that already exists, don't sign the user out. Handle the error.
 TODO: Dismiss keyboard while loading
 
 Profile View:
 TODO: Display UI TaskFeedback -- Loading
 TODO: Validate Display Name format
  
 Reset password:
 TODO: Handle error if non existing email is entered. Right now its generic error.
 */


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
