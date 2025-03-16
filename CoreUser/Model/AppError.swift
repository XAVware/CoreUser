//
//  AppError.swift
//  CoreUser
//
//  Created by Ryan Smetana on 12/24/23.
//

import Foundation

enum AppError: Error {
    case accountExistsWithDifferentCredential
    case credentialAlreadyInUse
    case emailAlreadyInUse
    case emailChangeNeedsVerification
    case errorSigningOut
    case invalidCredential
    case invalidEmail
    case invalidFirstName
    case invalidPassword
    case invalidPasswordLength
    case invalidPhoneNumber
    case missingPassword
    case networkError
    case nullUser
    case otherError(any Error) // If a different error is thrown, pass it's localized description to the enum.
    case passwordsDoNotMatch
    case reauthenticationRequired
    case rejectedCredential
    case userDisabled
    case userNotFound
    case weakPassword
    
    // Custom errors not directly related to FIRAuthErrors provided by Firebase
    case nullUserAfterSignIn
    
    var localizedDescription: String {
        switch self {
        case .accountExistsWithDifferentCredential: return "Account exists with different credentials"
        case .credentialAlreadyInUse:               return "Credential already in use"
        case .emailAlreadyInUse:                    return "An account already exists with this email."
        case .emailChangeNeedsVerification:         return "Email change needs verification"
        case .errorSigningOut:                       return "There was an issue signing you out"
        case .invalidCredential:                    return "Invalid credentials"
        case .invalidEmail:                         return "Please enter a valid email."
        case .invalidFirstName:                     return "Please enter a valid first name."
        case .invalidPassword:                      return "Password was incorrect."
        case .invalidPasswordLength:                return "Please make sure password is longer than 7 characters."
        case .invalidPhoneNumber:                   return "Invalid phone number"
        case .missingPassword:                      return "Please enter a password"
        case .networkError:                         return "There was an issue with your connection. Please try again."
        case .nullUser:                             return "Null user"
        case .otherError(let err):                  return "AppAuthError.. An unknown error was thrown: \(err.localizedDescription)"
        case .passwordsDoNotMatch:                  return "Passwords do not match."
        case .reauthenticationRequired:             return "Reauthentication required for this action."
        case .rejectedCredential:                   return "Rejected credentials"
        case .userDisabled:                         return "User disabled"
        case .userNotFound:                         return "User not found"
        case .weakPassword:                         return "Weak password"
        case .nullUserAfterSignIn:                  return "Auth user returned null after successful sign in."
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
