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
    @State var userDefaultsEmail = ""
    @State var userDefaultsPassword = ""
    @State var isShownSheet: Bool = false
    @State var isShowFullScreenCover: Bool = false
    @State var isShowingAlertWhenFailed: Bool = false
    @State var isShowingAlertWhenSuccessed: Bool = false
    
    @State var userDefaultEnable: Bool = false
    
    var body: some View {
        VStack(spacing: 30){
            Spacer()
            Image("LostArk_logo")
                .resizable()
                .scaledToFit()
            Spacer()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Toggle(isOn: self.$userDefaultEnable) {
                    Text("로그인 정보 저장")
                }
                .toggleStyle(LoginViewModel.UserDefaultsCustomToggleStyle())
                Spacer()
            }
            
            HStack(spacing: 40) {
                Button("이메일 회원가입") {
                    self.isShownSheet.toggle()
                }
                .sheet(isPresented: $isShownSheet) {
                    SignUpView(isShownSheet: $isShownSheet)
                }
                .padding(10)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("이메일 로그인") {
                    loginViewModel.signInFirebase(email: email, password: password)
                    if self.userDefaultEnable {
                        loginViewModel.saveDataUserDefaults(email: email, password: password, userDefaultsEnable: userDefaultEnable)
                    } else {
                        loginViewModel.initDataUserDefaults()
                    }
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
                .padding(10)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
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
            
            Text("해당 어플은 수익을 발생하지 않으며, 어플 내의 모든 지식재산권 및 저작권은 스마일게이트 - 로스트아크에 속해져 있습니다.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        
        .fullScreenCover(isPresented: $isShowFullScreenCover) {
            MainView()
        }
        .onAppear() {
            loginViewModel.loadDataUserDefaults()
            if loginViewModel.userDefaultsEnable {
                DispatchQueue.main.async {
                    self.email = loginViewModel.userDefaultsEmail
                    self.password = loginViewModel.userDefaultsPassword
                    self.userDefaultEnable = loginViewModel.userDefaultsEnable
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
