//
//  ProfileViewModel.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/13/24.
//

import SwiftUI
import Combine

// TODO: Display UI TaskFeedback -- Loading
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
        AuthService.shared.$user.sink { [weak self] user in
            self?.user = user
        }.store(in: &cancellables)
    }

    func changeView(to newState: ProfileState) {
        self.currentState = newState
    }
    
    func updateDisplayName(to name: String) async throws {
        UIFeedbackService.shared.startLoading()
        try await AuthService.shared.updateDisplayName(to: name)
        debugPrint("DEBUG: Finished updating display name.")
        changeView(to: .viewProfile)
    }
        
    func updateEmail(to email: String) async throws {
        UIFeedbackService.shared.startLoading()
        try await AuthService.shared.updateEmail(to: email)
        debugPrint("DEBUG: Email verification sent. Requiring reauthentication...")
        reauthenticationRequired = true
    }
}
