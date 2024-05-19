//
//  DatabaseService.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 17.05.24.
//

import Foundation
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseDatabaseInternal
import FirebaseAuth

class DatabaseService {
    private init() { return }
    static let shared = DatabaseService()
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func writeFirestore(username: String) {
        let usersRef = db.collection("users")
        
        usersRef.document("\(user?.uid ?? "undefided")").setData([
            "username": username,
            "e-mail": user?.email ?? "can't receive an email"
        ])
    }
    
    func readFirestore(completion: @escaping (String) -> ()) {
        
        Task { @MainActor in
            do {
                let snapshot = try await db.collection("users").getDocuments()
                for document in snapshot.documents {
                    let user = Auth.auth().currentUser
                    if document.documentID == user?.uid {
                        completion("\(document.data()["username"] ?? "usernameError")")
                    }
                }
            } catch {
                completion("\(error)")
            }
        }
    }
}
