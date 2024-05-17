//
//  AuthService.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 12.05.24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseAuth
import GoogleSignIn

class AuthService {
    private init() { return }
    
    static let shared = AuthService()
    
    func signUpWithEmail(email: String, username: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                let email = user.email
                let username = user.displayName
                //username передать на MainVC
                completion(email ?? "Error: can't receive an e-mail")
                
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
            if error == nil {
                if let authResult = authResult {
                    //                    let ref = Database.
                }
            }
            completion(error?.localizedDescription ?? "No errors")
            //            guard authResult != nil else { return }
            //            print("Sign In Success")
        }
        //        if Auth.auth().currentUser != nil {
        //            print("Sign In Success")
        //        }
        
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
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString
            else {
                completion("Something is nil")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if error == nil {
                    if let result = result {
                        //                    let ref = Database.
                    }
                }
                
                completion(error?.localizedDescription ?? "No errors")
            }
            let email = user.profile?.email
            completion(email ?? "Error: can't receive an e-mail")
        }
    }
    
    func signUpWithGoogle() {
        
    }
    
    func getUsername() -> String {
        return Auth.auth().currentUser?.displayName ?? "No name"
    }
    
    func getUserPicture() -> URL {
        print(Auth.auth().currentUser?.photoURL ?? URL(fileURLWithPath: ""))
        return Auth.auth().currentUser?.photoURL ?? URL(fileURLWithPath: "")
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    //    func checkIfSignedIn() {
    //        if
    //    }
}
