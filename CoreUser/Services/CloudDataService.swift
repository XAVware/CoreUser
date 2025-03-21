//
//  UserService.swift
//  CoreUser
//
//  Created by Ryan Smetana on 2/27/24.
//

import FirebaseFirestore

@MainActor
final class CloudDataService {
    private let userCollection = Firestore.firestore().collection("users")
    
    static let shared = CloudDataService()
    private let db = Firestore.firestore()
    
    func createUserDoc(newUser: User) async throws {
        try userCollection.document(newUser.uid).setData(from: newUser)
    }

    func updateUserData(localUser: User) async throws {
        let data: [UserDocumentKey: Any] = [
            UserDocumentKey.email: localUser.email,
            UserDocumentKey.emailVerified: localUser.emailVerified,
            UserDocumentKey.displayName: localUser.displayName ?? ""
        ]
        let sendableData = Dictionary(uniqueKeysWithValues: data.map { ($0.key.rawValue, $0.value) })
        await MainActor.run {
            userCollection.document(localUser.uid).updateData(sendableData)
        }
    }
    
    func syncUser(localUser: User) async throws {
        do {
            let dbUser = try await userCollection.document(localUser.uid).getDocument(as: User.self)
            if localUser.email != dbUser.email || localUser.emailVerified != dbUser.emailVerified || localUser.displayName != dbUser.displayName {
                debugPrint(">>> Database document out of sync. Updating now...")
                try await updateUserData(localUser: localUser)
            }
        } catch let DecodingError.valueNotFound(_, context) where context.codingPath.isEmpty {
            print("User document not found in Firestore. Creating new document...")
            try await createUserDoc(newUser: localUser)
            debugPrint("DEBUG: User document created successfully in Firestore.")
        } catch {
            print("Unexpected error: \(error)")
            throw error
        }
    }
}

