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
    //  SignUP sheet에 사용되는 변수
    @Published var signUpEmail: String = ""
    @Published var signUpPassword: String = ""
    @Published var confirmPassword: String = ""
    
    //  SignUP sheet에서 뷰의 구성에 따른 alert과 border color 설정
    @Published var isShowingAlertWhenFailed = false
    @Published var canUseEmail: Bool = false
    @Published var isFailedCheckEmail: Bool = false
    @Published var isSucessedCheckEmail: Bool = false
    
    //  SignUP Email을 받는 변수
    @Published var checkEmail: String = ""
    
    //  SignUP password의 규칙을 만족하기 위한 변수
    @Published var checkPassword: String = ""
    @Published var canUsePassword: Bool = false
    
    
    //  fetchUID를 위한 변수
    @Published var uid: String = ""
    
    //  Google로그인 후 MainView를 위한 변수
    @Published var isShowFullScreenCover: Bool = false
    
    //  UserDefaults구현 변수
    @Published var email = ""
    @Published var password = ""
    @Published var userDefaultsEmail = ""
    @Published var userDefaultsPassword = ""
    @Published var userDefaultsEnable: Bool = false
    
    //  MARK: signUpView
    func signUp() {
        Auth.auth().createUser(withEmail: self.signUpEmail, password: self.signUpPassword) {result, error in
            if let error = error {
                print("Sign Up failed: \(error.localizedDescription)")
            } else {
                print("Sign Up success")
            }
        }
    }
    
    func checkSignUpEmail(checkEmail: String) {
        Auth.auth().fetchSignInMethods(forEmail: checkEmail) { signInMethods, error in
            if let error = error as NSError? {
                print("Error checking email existence: \(error.localizedDescription)")
                return
            }

            guard let signInMethods = signInMethods else {
                // 에러 발생 시 처리
                print("Error checking email existence. signInMethods is nil.")
                DispatchQueue.main.async {
                    print("Email is not in use.")
                    self.canUseEmail = true
                    print("self.checkAlreadyExistEmail : \(self.canUseEmail)")
                    self.isSucessedCheckEmail = true    // border의 값 변경
                }
                return
            }

            DispatchQueue.main.async {
                print("Fetched signInMethods: \(signInMethods)")
                
                if signInMethods != nil {
                    // 이미 가입된 이메일이라면 처리
                    print("Email is already in use.")
                    self.canUseEmail = false //
                    self.isFailedCheckEmail = true //   alert을 위한 처리
                    /**
                     // 중복이 아니라면 사용자 생성
                     print("Email is not in use.")
                     self.checkAlreadyExistEmail = true
                    */
                }

                print("self.checkAlreadyExistEmail : \(self.canUseEmail)")
            }
        }
    }
    
    /**
     추후 FIrebase SDK혹은 이메일 열거 정책이 변경되어 오류가 발생할 경우
     if else문에 중복코드를 수정해야 함
     */
    
    func checkSingUpPassword() {
        let checkUpPassword = self.signUpPassword
        if checkUpPassword.count < 6 {  //  Firebase 패스워드의 유효성 규칙인 6
            print("Password is too short")
            self.canUsePassword = false
        } else {
            print("password can use")
            self.canUsePassword = true
        }
    }
    
    //  MARK: LoginView
    func signInFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // 로그인 실패 alert 표시
                self.isShowingAlertWhenFailed.toggle()
                let errorCode = (error as NSError).code
                print(errorCode)
                
            } else {
                // FullScreenCover로 MainView 이동
                self.isShowFullScreenCover.toggle()
                
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
    
    
    //  MARK: - UserDefaults 구현
    func saveDataUserDefaults(email: String, password: String, userDefaultsEnable: Bool) {
        UserDefaults.standard.set(email, forKey: "userDefaultsEmail")
        UserDefaults.standard.set(password, forKey: "userDefaultsPassword")
        UserDefaults.standard.set(userDefaultsEnable, forKey: "userDefaultsEnable")
    }
    
    func loadDataUserDefaults() {
        self.userDefaultsEmail = UserDefaults.standard.string(forKey: "userDefaultsEmail") ?? ""
        self.userDefaultsPassword = UserDefaults.standard.string(forKey: "userDefaultsPassword") ?? ""
        self.userDefaultsEnable = UserDefaults.standard.bool(forKey: "userDefaultsEnable")
    }
    
    func initDataUserDefaults() {
        UserDefaults.standard.set("", forKey: "userDefaultsEmail")
        UserDefaults.standard.set("", forKey: "userDefaultsPassword")
        UserDefaults.standard.set(false, forKey: "userDefaultsEnable")
    }
    
    struct UserDefaultsCustomToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 40, height: 20)
                    .foregroundColor(configuration.isOn ? .green : .red)
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: (40 / 2) - 4, height: 40 / 2 - 6)
                    .padding(4)
                    .foregroundColor(.white)
                    .onTapGesture {
                        withAnimation {
                            configuration.$isOn.wrappedValue.toggle()
                        }
                    }
            }
        }
    }
}
