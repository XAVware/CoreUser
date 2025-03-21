//
//  UserDocumentKey.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/20/25.
//

import Foundation

/// Keys corresponding to Firestore User document fields
enum UserDocumentKey: String, Hashable {
    case email = "email"
    case emailVerified = "emailVerified"
    case displayName = "displayName"
    
    case phoneNumber = "phoneNumber"
    case phoneVerified = "phoneVerified"
}
