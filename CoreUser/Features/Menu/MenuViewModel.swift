//
//  MenuViewModel.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/16/25.
//

import SwiftUI

@MainActor final class MenuViewModel: ObservableObject {
    @Published var remindersOn: Bool = true
    @Published var soundOn: Bool = true
    @Published var hapticsOn: Bool = true
    @Published var accLabelsOn: Bool = true
    
    @Published var sections: [MenuSection] = [
        MenuSection(title: "Account", items: [
            MenuItem(title: "Profile", icon: "person.circle", destination: .profileView),
            MenuItem(title: "Settings", icon: "gear", destination: .settings)
        ])
    ]
}
