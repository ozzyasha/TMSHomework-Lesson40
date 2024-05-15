//
//  AuthService.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 12.05.24.
//

import Foundation
import FirebaseAnalytics
import FirebaseAuth

class AuthService {
    private init() { return }
    
    static let shared = AuthService()
    
    func signUpWithEmail(email: String, username: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                let email = user.email
                let username = user.displayName
                completion(email ?? "Error: can't receive an e-mail")
                
            } else {
                completion(error?.localizedDescription ?? "No errors")
            }
        }
        signInWithEmail(email: email, password: password) { errorText in
            print(errorText)
        }
        
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error?.localizedDescription ?? "No errors")
            guard authResult != nil else { return }
//            print("Sign In Success")
        }
        if Auth.auth().currentUser != nil {
            print("Sign In Success")
        }
    }

}
