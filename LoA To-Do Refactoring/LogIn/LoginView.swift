//
//  LoginView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 11/16/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack(spacing: 30){
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("로그인") {
                signInFirebase()
            }
            
            Button("구글 로그인") {
                
            }
            
            Button("이메일 회원가입") {
                
            }
            
            
        }
        .padding()
    }
    
    private func signInFirebase() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("로그인 실패! 이메일이나 패스워드 확인하셈")
            } else {
                MainView()
            }
        }
    }
}

#Preview {
    LoginView()
}
