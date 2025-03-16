//
//  AuthService.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthService {
    @Published private(set) var user: FirebaseAuth.User?
    static let shared = AuthService()
    
    private let alertService: AlertService
    
    init() {
        self.alertService = AlertService.shared
        self.user = Auth.auth().currentUser
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
        } catch {
            throw authError(error)
        }
    }
    
    func createUser(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            try await result.user.sendEmailVerification()
        } catch {
            throw authError(error)
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            alertService.pushAlert(.success, "Email sent. Please check your inbox.")
        }  catch {
            throw authError(error)
        }
    }
    
    func updateEmail(to email: String) async throws {
        guard let authUser = Auth.auth().currentUser else { return }
        
        do {
            try await authUser.sendEmailVerification(beforeUpdatingEmail: email)
            alertService.pushAlert(.success, "Verification email sent. Click the link in the email to verify.")
        } catch {
            throw authError(error)
        }
    }
    
    func updateDisplayName(to name: String) async throws {
        guard let authUser = Auth.auth().currentUser else { return }
        do {
            let changeRequest = authUser.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            self.user = authUser
        } catch {
            throw authError(error)
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
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
