//
//  AuthService.swift
//  CoreUser
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
    private func authError(_ error: Error) -> AppError {
        let nsError = error as NSError        
        return switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:                    
            AppError.emailAlreadyInUse
        case AuthErrorCode.invalidEmail.rawValue:                         
            AppError.invalidEmail
        case AuthErrorCode.wrongPassword.rawValue:                        
            AppError.invalidPassword
        case AuthErrorCode.tooManyRequests.rawValue:                      
            AppError.networkError
        case AuthErrorCode.networkError.rawValue:                         
            AppError.networkError
        case AuthErrorCode.weakPassword.rawValue:                         
            AppError.weakPassword
        case AuthErrorCode.invalidCredential.rawValue:                    
            AppError.invalidCredential
        case AuthErrorCode.userDisabled.rawValue:                         
            AppError.userDisabled
        case AuthErrorCode.userNotFound.rawValue:                         
            AppError.userNotFound
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue: 
            AppError.accountExistsWithDifferentCredential
        case AuthErrorCode.credentialAlreadyInUse.rawValue:               
            AppError.credentialAlreadyInUse
        case AuthErrorCode.invalidPhoneNumber.rawValue:                   
            AppError.invalidPhoneNumber
        case AuthErrorCode.nullUser.rawValue:                             
            AppError.nullUser
        case AuthErrorCode.rejectedCredential.rawValue:                   
            AppError.rejectedCredential
        case AuthErrorCode.requiresRecentLogin.rawValue:                  
            AppError.reauthenticationRequired
        default:                                    
            AppError.otherError(error)
        }
    }
}
