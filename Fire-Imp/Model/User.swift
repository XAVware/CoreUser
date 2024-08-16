//
//  User.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Codable {
    let uid: String
    var email: String
    var displayName: String?
    let dateCreated: Date
    var emailVerified: Bool = false
    var finishedOnboarding: Bool = false
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
