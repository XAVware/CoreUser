//
//  UserService.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import Firebase

class CloudDataService {
    
    enum UserDocumentKey: String, Hashable {
        case email = "email"
        case emailVerified = "emailVerified"
        case displayname = "displayName"
    }
    
    private static let userCollection = Firestore.firestore().collection("users")
    
    static let shared = CloudDataService()
    
    static func createUserDoc(newUser: User) async throws {
        try userCollection.document(newUser.uid).setData(from: newUser)
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let user = try await userCollection.document(uid).getDocument(as: User.self)
        return user
    }
    
    static func updateDisplayName(uid: String, newName: String) async throws {
        try await userCollection.document(uid).updateData([
            "displayName": newName
        ])
    }
    
    static func updateEmail(uid: String, newEmail: String) async throws {
        try await userCollection.document(uid).updateData([
            "email": newEmail
        ])
    }
    
    static func updateUserData(uid: String, data: [UserDocumentKey : Any]) async throws {
        try await userCollection.document(uid).updateData(data)
    }
    
    // displayName does not need to be checked or updated here because the database is immediately updated when the user changes it.
    static func handleLogin(authUser: FirebaseAuth.User) async throws -> User {
        let localUser = User(uid: authUser.uid,
                             email: authUser.email ?? "Err",
                             displayName: authUser.displayName,
                             dateCreated: authUser.metadata.creationDate ?? Date(),
                             emailVerified: authUser.isEmailVerified)
        
        let dbUser = try await fetchUser(withUid: localUser.uid)
        
        
        if localUser.email != dbUser.email || localUser.emailVerified != dbUser.emailVerified {
            debugPrint(">>> Database document out of sync. Updating now...")
            let updatedData: [AnyHashable: Any] = [UserDocumentKey.email : localUser.email,
                                                   UserDocumentKey.emailVerified : localUser.emailVerified]
            try await userCollection.document(localUser.uid).updateData(updatedData)
//            try await userCollection.document(localUser.uid).updateData([
//                "email": localUser.email,
//                "emailVerified": localUser.emailVerified
//            ])
            debugPrint("DEBUG: Finished updating user in Database.")
        }
        debugPrint("DEBUG: Returning user to AuthService.")
        return localUser
    }
}

