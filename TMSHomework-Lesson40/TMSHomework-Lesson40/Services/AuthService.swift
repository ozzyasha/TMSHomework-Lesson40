//
//  AuthService.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 12.05.24.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseAuth
import GoogleSignIn

class AuthService {
    private init() { return }
    
    static let shared = AuthService()
    
    func signUpWithEmail(email: String, username: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if (authResult?.user) != nil {
                DatabaseService.shared.writeFirestore(username: username)
            } else {
                completion(error?.localizedDescription ?? "No errors")
            }
        }
        Analytics.logEvent("SignUpEvent", parameters: ["key" : "value"])
        
        signInWithEmail(email: email, password: password) { errorText in
            completion(errorText)
        }
        
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                completion(error?.localizedDescription ?? "No errors")
                return
            }
        }
        
        Analytics.logEvent("SignInEvent", parameters: ["key" : "value"])
    }
    
    func signInWithGoogle(vc: UIViewController, completion: @escaping (String) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else {
                completion(error?.localizedDescription ?? "No errors")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion("Something is nil")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    completion(error?.localizedDescription ?? "No errors")
                    return
                }
            }
        }
    }
    
    func getUsername(completion: @escaping (String) -> ()) {
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            DatabaseService.shared.readFirestore() { data in
                completion(data)
            }
            return
        }
        
        DatabaseService.shared.readFirestore() { data in
            if data != "nil" {
                completion(data)
            } else {
                DatabaseService.shared.writeFirestore(username: displayName)
                DatabaseService.shared.readFirestore() { data in
                    completion(data)
                }
            }
        }
        
    }
    
    func getUserPicture() -> URL {
        return Auth.auth().currentUser?.photoURL ?? URL(fileURLWithPath: "")
    }
    
    func signOut(completion: @escaping (String) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            completion("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
}
