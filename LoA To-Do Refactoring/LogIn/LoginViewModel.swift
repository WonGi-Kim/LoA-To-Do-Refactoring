//
//  LoginViewModel.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 11/16/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

class LoginViewModel: ObservableObject {
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var isShowingAlertWhenFailed = false
    @Published var uid: String = ""
    
    @Published var isLoginSuccessed = false
    
    @Published var isShowFullScreenCover: Bool = false
    
    func signUp() {
        Auth.auth().createUser(withEmail: self.signUpEmail, password: self.signUpPassword) {result, error in
            if let error = error {
                print("Sign Up failed: \(error.localizedDescription)")
            } else {
                print("Sign Up success")
            }
        }
    }
    
    func fetchUID() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            self.uid = uid
        } else {
            print("User Not logged in")
        }
    }
    
    func signInWithGoogle() {
        //  앱 클라이언트 아이디 가져오기
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let user = user?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let user = res?.user else { return }
                
                print(user)
                self.isShowFullScreenCover = true
            }
        }
    }
}
