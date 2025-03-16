//
//  ProfileViewModel.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/13/24.
//

import SwiftUI
import Combine

@MainActor class ProfileViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var user: User?
    
    private let userManager: UserManager
    private let alertService: AlertService
    
    init(userManager: UserManager? = nil, alertService: AlertService? = nil) {
        self.userManager = userManager ?? UserManager.shared
        self.alertService = alertService ?? AlertService.shared
        setupSubscribers()
    }
    
    func setupSubscribers() {
        userManager.$currentUser.sink { [weak self] user in
            self?.user = user
        }.store(in: &cancellables)
    }

    func updateDisplayName(to name: String) async {
        do {
            try await AuthService.shared.updateDisplayName(to: name)
            debugPrint("DEBUG: Finished updating display name.")
        } catch let error as AppError {
            alertService.pushAlert(.error, error.localizedDescription)
        } catch {
            alertService.pushAlert(.error, "Unknown: \(error)")
        }
    }
        
    func updateEmail(to email: String) async {
        do {
            try await AuthService.shared.updateEmail(to: email)
            debugPrint("DEBUG: Email verification sent. ")
        } catch let error as AppError {
            alertService.pushAlert(.error, error.localizedDescription)
        } catch {
            alertService.pushAlert(.error, "Unknown: \(error)")
        }
    }
    
    func reauthenticate(withEmail email: String, password: String) async -> Bool {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
            return true
        } catch let error as AppError {
            alertService.pushAlert(.error, error.localizedDescription)
            return false
        } catch {
            alertService.pushAlert(.error, "Unknown: \(error)")
            return false
        }
    }
}
