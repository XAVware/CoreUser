//
//  UserManager.swift
//  CoreUser
//
//  Created by Ryan Smetana on 1/27/25.
//

import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class UserManager: ObservableObject {
    @Published private(set) var currentUser: User?
    private var authUser: FirebaseAuth.User?
    @Published private(set) var isOnboarding: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private let cloudService: CloudDataService
    static let shared = UserManager()
    
    private init() {
        self.authService = AuthService.shared
        self.cloudService = CloudDataService.shared
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        let publisher = authService
        publisher.$user
            .receive(on: RunLoop.main)
            .assign(to: \.authUser, on: self)
            .store(in: &cancellables)
        
        publisher.$user.sink (receiveValue: { authUser in
            self.setCurrentUser(authUser: authUser)
            self.syncUser()
        }).store(in: &cancellables)
    }
    
    func setCurrentUser(_ user: User) {
        self.currentUser = user
    }
    
    func signOutUser() {
        self.currentUser = nil
    }
    
    func setCurrentUser(authUser: FirebaseAuth.User?) {
        if let authUser = authUser {
            let user = User(uid: authUser.uid,
                            email: authUser.email ?? "ERR",
                            displayName: authUser.displayName,
                            dateCreated: authUser.metadata.creationDate ?? Date(),
                            emailVerified: authUser.isEmailVerified )
            self.currentUser = user
            
        } else {
            self.authUser = nil
            self.currentUser = nil
        }
    }
    
    func syncUser() {
        guard let localUser = self.currentUser else { return }
        Task {
            do {
                try await cloudService.syncUser(localUser: localUser)
            } catch {
                print("Error syncing user: \(error)")
                return
            }
        }
    }
    
    func setDisplayName(_ name: String) {
        self.currentUser?.displayName = name
        
    }
    
    func getCurrentUser() -> User? {
        return self.currentUser
    }
    
    func finishOnboarding() {
        self.isOnboarding = false
    }
}
