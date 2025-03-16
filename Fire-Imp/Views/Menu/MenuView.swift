//
//  MenuView.swift
//  FireImp
//
//  Created by Ryan Smetana on 11/10/23.
//

import SwiftUI
import FirebaseAuth

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

struct MenuView: View {
    @StateObject private var vm: MenuViewModel = MenuViewModel()
    @Environment(NavigationService.self) var navigationService
    
    var body: some View {
        List {
            ForEach(vm.sections) { section in
                Section(section.title) {
                    ForEach(section.items) { item in
                        Button(item.title, systemImage: item.icon) {
                            if let destination = item.destination {
                                navigationService.push(destination)
                            }
                        }
                    }
                }
            } //: ForEach
            
            Section {
                Button("Sign Out", systemImage: "rectangle.portrait.and.arrow.right") {
                    AuthService.shared.signout()
                    UserManager.shared.signOutUser()
                    navigationService.popToRoot()
                }
            }
        } //: List
        .navigationTitle("Menu")
    } //: Body
    
}

#Preview {
    NavigationStack {
        MenuView()
            .environment(NavigationService())
    }
}
