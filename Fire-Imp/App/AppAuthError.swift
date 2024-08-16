//
//  AppAuthError.swift
//  FireImp
//
//  Created by Ryan Smetana on 12/24/23.
//

import Foundation

enum AppAuthError: Error {
    case accountExistsWithDifferentCredential
    case credentialAlreadyInUse
    case emailAlreadyInUse
    case invalidCredential
    case invalidEmail
    case invalidFirstName
    case invalidPassword
    case invalidPasswordLength
    case invalidPhoneNumber
    case networkError
    case nullUser
    case otherError(Error) // If a different error is thrown, pass it's localized description to the enum.
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
        case .accountExistsWithDifferentCredential: "Account exists with different credentials"
        case .credentialAlreadyInUse:               "Credential already in use"
        case .emailAlreadyInUse:                    "An account already exists with this email."
        case .invalidCredential:                    "Invalid credentials"
        case .invalidEmail:                         "Please enter a valid email."
        case .invalidFirstName:                     "Please enter a valid first name."
        case .invalidPassword:                      "Password was incorrect."
        case .invalidPasswordLength:                "Please make sure password is longer than 7 characters."
        case .invalidPhoneNumber:                   "Invalid phone number"
        case .networkError:                         "There was an issue with your connection. Please try again."
        case .nullUser:                             "Null user"
        case .otherError(let err):                  "AppAuthError.. An unknown error was thrown: \(err.localizedDescription)"
        case .passwordsDoNotMatch:                  "Passwords do not match."
        case .reauthenticationRequired:             "Reauthentication required for this action."
        case .rejectedCredential:                   "Rejected credentials"
        case .userDisabled:                         "User disabled"
        case .userNotFound:                         "User not found"
        case .weakPassword:                         "Weak password"
            
        case .nullUserAfterSignIn:                  "Auth user returned null after successful sign in."
        }
    }
}
