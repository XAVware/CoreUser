//
//  ProfileViewModel.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/13/24.
//

import SwiftUI
import Combine

@MainActor class ProfileViewModel: ObservableObject {
    enum ProfileState { case viewProfile, editDisplayName, editEmail }
    var cancellables = Set<AnyCancellable>()
    @Published var user: User?
    @Published var currentState: ProfileState = .viewProfile
    @Published var reauthenticationRequired = false
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        UserManager.shared.$currentUser.sink { [weak self] user in
            self?.user = user
        }.store(in: &cancellables)
    }

    func changeView(to newState: ProfileState) {
        self.currentState = newState
    }
    
    func updateDisplayName(to name: String) async throws {
        try await AuthService.shared.updateDisplayName(to: name)
        debugPrint("DEBUG: Finished updating display name.")
    }
        
    func updateEmail(to email: String) async throws {
        do {
            try await AuthService.shared.updateEmail(to: email)
            debugPrint("DEBUG: Email verification sent. ")
        } catch {
            print("Error updating email: \(error)")
        }
    }
    
    func reauthenticate(withEmail email: String, password: String) async throws -> Bool {
        try await AuthService.shared.login(withEmail: email, password: password)
        return true
    }
}
