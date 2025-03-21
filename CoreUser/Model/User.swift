//
//  User.swift
//  CoreUser
//
//  Created by Ryan Smetana on 2/27/24.
//

import Foundation

struct User: Codable {
    let uid: String
    var email: String
    var displayName: String?
    let dateCreated: Date
    var emailVerified: Bool = false
    var finishedOnboarding: Bool = false
    
    var phoneNumber: String?
    var phoneVerified: Bool = false
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
