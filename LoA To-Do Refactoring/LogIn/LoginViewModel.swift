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

class LoginViewModel: ObservableObject {
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var isShowingAlertWhenFailed = false
    @Published var uid: String = ""
    
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
    
}
