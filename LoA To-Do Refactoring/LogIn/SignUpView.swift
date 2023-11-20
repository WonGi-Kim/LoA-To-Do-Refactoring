//
//  SignUpView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 11/16/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct SignUpView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @State var isShowingAlert : Bool = false
    @Binding var isShownSheet : Bool
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading) {
                Text("이메일")
                    .font(.headline)
                TextField("이메일을 입력하세요.", text: $loginViewModel.signUpEmail)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(.headline)
                SecureField("비밀번호를 입력하세요.", text: $loginViewModel.signUpPassword)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
            }
            
            VStack(alignment: .leading) {
                Text("비밀번호 확인")
                    .font(.headline)
                SecureField("비밀번호를 입력하세요.", text: $loginViewModel.confirmPassword)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    .border(.red, width: loginViewModel.confirmPassword != loginViewModel.signUpPassword ? 1 : 0)
            }
            
            Button {
                isShowingAlert = true
                loginViewModel.signUp()
            } label: {
                Text("회원 가입")
                    .frame(width: 100, height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert("회원 가입", isPresented: $isShowingAlert) {
                        Button {
                            isShownSheet = false
                        } label: {
                            Text("OK")
                        }
                    } message: {
                        Text("회원가입이 완료되었습니다.")
                    }
                    .padding()
            }
            .disabled(
                ($loginViewModel.signUpEmail.wrappedValue.isEmpty ||
                 $loginViewModel.signUpPassword.wrappedValue.isEmpty ||
                 $loginViewModel.confirmPassword.wrappedValue.isEmpty ||
                 $loginViewModel.signUpPassword.wrappedValue != $loginViewModel.confirmPassword.wrappedValue)
            )

            .opacity(
                (($loginViewModel.signUpEmail.wrappedValue.isEmpty ||
                  $loginViewModel.signUpPassword.wrappedValue.isEmpty ||
                  $loginViewModel.confirmPassword.wrappedValue.isEmpty ||
                  $loginViewModel.signUpPassword.wrappedValue != $loginViewModel.confirmPassword.wrappedValue) ? 0.3 : 1.0)
            )
        }
    }
}
