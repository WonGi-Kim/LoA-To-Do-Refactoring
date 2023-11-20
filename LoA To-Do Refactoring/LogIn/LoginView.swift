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
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State var isShownSheet: Bool = false
    @State var isShowFullScreenCover: Bool = false
    @State var isShowingAlertWhenFailed: Bool = false
    @State var isShowingAlertWhenSuccessed: Bool = false
    
    var body: some View {
        VStack(spacing: 30){
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            Button("로그인") {
                signInFirebase()
            }
            .alert(isPresented: $loginViewModel.isShowingAlertWhenFailed) {
                Alert(
                    title: Text("실패함"),
                    message: Text("이메일 비번 확인해보셈"),
                    dismissButton: .default(Text("ㅇㅋ")) {
                        $loginViewModel.isShowingAlertWhenFailed.wrappedValue.toggle()
                    }
                )
            }
            
            GoogleSignInButton(
                scheme: .light,
                style: .wide,
                action: {
                    DispatchQueue.main.async {
                        loginViewModel.signInWithGoogle()
                    }
                }
            )
            .frame(width: 300, height: 60, alignment: .center)
            .fullScreenCover(isPresented: $loginViewModel.isShowFullScreenCover) {
                MainView()
            }
            
            Spacer()
            Button("이메일 회원가입") {
                self.isShownSheet.toggle()
            }
            .sheet(isPresented: $isShownSheet) {
                SignUpView(isShownSheet: $isShownSheet)
            }
            
            
        }
        .padding()
        
        .fullScreenCover(isPresented: $isShowFullScreenCover) {
            MainView()
        }
        
    }
    
    private func signInFirebase() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // 로그인 실패 alert 표시
                loginViewModel.isShowingAlertWhenFailed.toggle()
                
            } else {
                // FullScreenCover로 MainView 이동
                isShowFullScreenCover.toggle()
                
            }
        }
    }

}

#Preview {
    LoginView()
}
