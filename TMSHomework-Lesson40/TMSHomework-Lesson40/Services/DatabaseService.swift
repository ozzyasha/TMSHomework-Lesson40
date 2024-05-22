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
    
    func writeFirestore(username: String) {
        let usersRef = db.collection("users")
        
        usersRef.document("\(Auth.auth().currentUser?.uid ?? "undefined")").setData([
            "username": username,
            "e-mail": Auth.auth().currentUser?.email ?? "can't receive an email"
        ])
    }
    
    func readFirestore(completion: @escaping (String) -> ()) {
        
        Task { @MainActor in
            do {
                let snapshot = try await db.collection("users").getDocuments()
                for document in snapshot.documents {
                    if document.documentID == Auth.auth().currentUser?.uid {
                        completion("\(document.data()["username"] ?? "nil")")
                        return
                    } else {
                        let displayName = Auth.auth().currentUser?.displayName
                        completion(displayName ?? "nil")
                    }
                }
            } catch {
                completion("nil")
            }
        }
    }
}
