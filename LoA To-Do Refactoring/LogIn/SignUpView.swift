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
    @State var checkEmail: String = ""
    @State var checkPassword: String = ""

    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading) {
                HStack {
                    Text("이메일")
                        .font(.headline)
                    Spacer()
                    
                    Button {
                        DispatchQueue.main.async {
                            checkEmail = loginViewModel.signUpEmail
                            print("checkEmail: \(checkEmail)")
                            loginViewModel.checkSignUpEmail(checkEmail: $checkEmail.wrappedValue)
                        }
                        print("Button tapped")
                    } label: {
                        Text("중복 확인")
                            .font(.subheadline)
                    }
                    .alert(isPresented: $loginViewModel.isFailedCheckEmail) {
                        Alert(
                            title: Text("이미 사용중인 이메일"),
                            message: Text("다른걸로 다시 시도 ㄱㄱ"),
                            dismissButton: .default(Text("ok")) {
                                $loginViewModel.isFailedCheckEmail.wrappedValue = false
                            }
                        )
                    }
                    .disabled(loginViewModel.signUpEmail.isEmpty)
                    .opacity(loginViewModel.signUpEmail.isEmpty ? 0.3 : 1.0)
                    .padding(.trailing,10)
                    .foregroundColor(.blue)
                    
                }
                TextField("이메일을 입력하세요.", text: $loginViewModel.signUpEmail)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .border(.green, width: loginViewModel.isSucessedCheckEmail ? 1 : 0)
            }
            
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(.headline)
                SecureField("비밀번호를 입력하세요.(6자리 이상)", text: $loginViewModel.signUpPassword)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    .border(loginViewModel.signUpPassword.count < 6 ? (loginViewModel.signUpPassword.isEmpty ? Color.clear : .red) : .green , width: 1)
            }
            
            VStack(alignment: .leading) {
                Text("비밀번호 확인")
                    .font(.headline)
                SecureField("비밀번호를 입력하세요.", text: $loginViewModel.confirmPassword)
                    .padding()
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    .border(loginViewModel.signUpPassword == loginViewModel.confirmPassword ? (loginViewModel.confirmPassword.isEmpty ? Color.clear : .green) : (loginViewModel.confirmPassword.isEmpty ? Color.clear : .red), width: 1)
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
                 $loginViewModel.signUpPassword.wrappedValue != $loginViewModel.confirmPassword.wrappedValue ||
                 !$loginViewModel.canUseEmail.wrappedValue ||
                 $loginViewModel.signUpPassword.wrappedValue.count < 6)
            )

            .opacity(
                (($loginViewModel.signUpEmail.wrappedValue.isEmpty ||
                  $loginViewModel.signUpPassword.wrappedValue.isEmpty ||
                  $loginViewModel.confirmPassword.wrappedValue.isEmpty ||
                  $loginViewModel.signUpPassword.wrappedValue != $loginViewModel.confirmPassword.wrappedValue ||
                  !$loginViewModel.canUseEmail.wrappedValue ||
                  $loginViewModel.signUpPassword.wrappedValue.count < 6) ? 0.3 : 1.0)
            )

        }
        .onDisappear() {
            $loginViewModel.isSucessedCheckEmail.wrappedValue = false
        }
    }
}
