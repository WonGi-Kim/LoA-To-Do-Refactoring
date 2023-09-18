//
//  MainView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/16.
//

import SwiftUI

//  MARK: - 처음 화면
struct MainView: View {
    @State var mainViewActive = false
    
    var body: some View {
        NavigationView {
            
            List() {
                Text("1")
            }
            
            .navigationBarTitle("LoA To-Do Refact",displayMode: .inline)
            .navigationBarItems(trailing: createNewCharacterButton(isMainViewActive: $mainViewActive))
        }
    }
}

//  MARK: - MainView 구성 함수
//  MARK: 캐릭터 생성 버튼
func createNewCharacterButton(isMainViewActive: Binding<Bool>) -> some View {
    Button {
        isMainViewActive.wrappedValue.toggle()
    } label: {
        Image.init(systemName: "plus")
            .foregroundColor(.white)
            .font(.title2)
    }.background(
        NavigationLink("",destination: SettingView(isMainViewActive: isMainViewActive),isActive : isMainViewActive)
            .opacity(0)
    )
}

//  MARK: - SettingView
struct SettingView: View {
    @Binding var isMainViewActive: Bool
    
    @State var charName: String = ""
    @State var charClass: String = ""
    @State var charLevel: String = ""
    
    var body: some View {
        
        @Environment(\.presentationMode) var presentationMode
        
        VStack{
            HStack {
                Text("캐릭터 명")
                Spacer()
            }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            
            HStack {
                TextField("캐릭터 이름을 입력해주세요", text: $charName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            HStack {
                Text("아이템 레벨")
                Spacer()
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
            
            HStack {
                TextField("아이템 레벨을 입력해주세요", text: $charLevel)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            HStack {
                Text("캐릭터 클래스")
                Spacer()
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
            
            HStack {
                TextField("캐릭터 클래스를 선택해주세요", text: $charClass)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Spacer()
        }
        
        
            .navigationBarTitle("캐릭터 생성")
            .navigationBarItems(
                leading: backButton(presentationMode),
                trailing: confirmCharacterCreateButton(isMainViewActive: $isMainViewActive)
            )
    }
}


//  MARK: - SettingView 구성 함수
//  MARK: 이전화면 버튼
func backButton(_ presentationMode: Binding<PresentationMode>) -> some View {
    Button {
        presentationMode.wrappedValue.dismiss()
    } label: {

    }
}

//  MARK: 캐릭터 생성 완료 버튼
func confirmCharacterCreateButton(isMainViewActive: Binding<Bool>) -> some View {
    return Button {
        isMainViewActive.wrappedValue = false
    } label: {
        Text("캐릭터 생성")
            .foregroundColor(.blue)
            .font(.system(size: 17))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
