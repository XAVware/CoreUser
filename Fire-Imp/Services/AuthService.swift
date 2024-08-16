//
//  AuthService.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import Foundation
import FirebaseAuth

class AuthService {
    @Published var user: User?
    static let shared = AuthService()
    
    init() {
        refreshUser()
    }
    
    @MainActor func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = try await CloudDataService.handleLogin(authUser: result.user)
        } catch {
            UIFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
        }
        UIFeedbackService.shared.stopLoading()
    }
    
    
    @MainActor func createUser(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let newUser = User(uid: result.user.uid,
                               email: result.user.email ?? "ERR",
                               displayName: result.user.displayName,
                               dateCreated: result.user.metadata.creationDate ?? Date())
            
            try await CloudDataService.createUserDoc(newUser: newUser)
            self.user = newUser
            try await result.user.sendEmailVerification()
            
            debugPrint(">>> User successfully saved to Firebase")
        } catch {
            UIFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
        }
        UIFeedbackService.shared.stopLoading()
    }
    
    
    func refreshUser() {
        if let authUser = Auth.auth().currentUser {
            self.user = User(uid: authUser.uid,
                             email: authUser.email ?? "ERR",
                             displayName: authUser.displayName,
                             dateCreated: authUser.metadata.creationDate ?? Date(),
                             emailVerified: authUser.isEmailVerified)
        } else {
            self.user = nil
        }
    }
    
    @MainActor func sendResetPasswordLink(toEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            UIFeedbackService.shared.showAlert(.success, "Email sent. Please check your inbox.")
        } catch {
            UIFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
        }
        UIFeedbackService.shared.stopLoading()
    }
    
    @MainActor func updateEmail(to email: String) async throws {
        guard let authUser = Auth.auth().currentUser else { return }
        
        do {
            try await authUser.sendEmailVerification(beforeUpdatingEmail: email)
            UIFeedbackService.shared.showAlert(.success, "Email sent. Please check your inbox.")
            signout()
        } catch {
            UIFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
            print(">>> Other reauth error: \(authError(error).localizedDescription)")
        }
        
        UIFeedbackService.shared.stopLoading()
    }
    
    @MainActor func updateDisplayName(to name: String) async throws {
        guard let authUser = Auth.auth().currentUser else { return }
        do {
            let changeRequest = authUser.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            try await CloudDataService.updateDisplayName(uid: authUser.uid, newName: name)
        } catch {
            UIFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
        }
        refreshUser()
        UIFeedbackService.shared.stopLoading()
    }
    
//    @MainActor
//    func reauthenticateWithEmail(email: String, password: String) async throws {
//        guard let currentUser = Auth.auth().currentUser else { return }
//        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//        
//        do {
//            debugPrint("DEBUG: Attempting to reauthenticate...")
//            try await currentUser.reauthenticate(with: credential)
//            debugPrint("DEBUG: Reauthentication successful.")
//        } catch {
//            TaskFeedbackService.shared.showAlert(.error, authError(error).localizedDescription)
//        }
//    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.refreshUser()
        } catch {
            print(">>> Error signing out: \(error)")
        }
    }
    
}

// MARK: - Auth Error
extension AuthService {
    private func authError(_ origError: Error) -> AppAuthError {
        if let error = origError as? AuthErrorCode {
            return switch error.code {
            case .emailAlreadyInUse:                    AppAuthError.emailAlreadyInUse
            case .invalidEmail:                         AppAuthError.invalidEmail
            case .wrongPassword:                        AppAuthError.invalidPassword
            case .tooManyRequests:                      AppAuthError.networkError
            case .networkError:                         AppAuthError.networkError
            case .weakPassword:                         AppAuthError.weakPassword
            case .invalidCredential:                    AppAuthError.invalidCredential
            case .userDisabled:                         AppAuthError.userDisabled
            case .userNotFound:                         AppAuthError.userNotFound
            case .accountExistsWithDifferentCredential: AppAuthError.accountExistsWithDifferentCredential
            case .credentialAlreadyInUse:               AppAuthError.credentialAlreadyInUse
            case .invalidPhoneNumber:                   AppAuthError.invalidPhoneNumber
            case .nullUser:                             AppAuthError.nullUser
            case .rejectedCredential:                   AppAuthError.rejectedCredential
            case .requiresRecentLogin:                  AppAuthError.reauthenticationRequired
            default:                                    AppAuthError.otherError(origError)
            }
        } else {
            return AppAuthError.otherError(origError)
        }
    }
}
