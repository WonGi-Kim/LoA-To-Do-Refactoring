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
    @State var isSettingViewActive = false
    
    @State var characterList: [CharacterSetting] = []
    
    var body: some View {
        NavigationView {
            
            List() {
                Text("1")
                createCharacterCell(characterList: $characterList)
            }
            
            .navigationBarTitle("LoA To-Do Refact",displayMode: .inline)
            .navigationBarItems(trailing: createNewCharacterButton(isMainViewActive: $mainViewActive, characterList: $characterList))
            
            .sheet(isPresented: $isSettingViewActive) {
                SettingView(isMainViewActive: $isSettingViewActive, characterList: $characterList)
            }
        }
    }
}

//  MARK: - MainView 구성 함수
//  MARK: 캐릭터 생성 버튼
func createNewCharacterButton(isMainViewActive: Binding<Bool>, characterList: Binding<[CharacterSetting]>) -> some View {
    Button {
        isMainViewActive.wrappedValue.toggle()
        //print("main에서 characterList",characterList)
    } label: {
        Image.init(systemName: "plus")
            .foregroundColor(.white)
            .font(.title2)
    }.background(
        NavigationLink("",destination: SettingView(isMainViewActive: isMainViewActive, characterList: characterList),isActive : isMainViewActive)
            .opacity(0)
    )
}

// MARK: 캐릭터 셀 생성
func createCharacterCell(characterList: Binding<[CharacterSetting]>) -> some View {
    if let firstCharacter = characterList.wrappedValue.first {
        return HStack {
            Image(firstCharacter.charClass)
                .resizable()
                .frame(width: 50, height: 50)
            
            Spacer()
            
            VStack {
                Text(firstCharacter.charName)
                Text(firstCharacter.charLevel)
            }
            Spacer()
        }
    } else {
        // characterList가 비어있을 때 기본 이미지 표시
        return HStack {
            Image("건슬링어")
                .resizable()
                .frame(width: 50, height: 50)
            
            Spacer()
            
            VStack {
                Text("기본 캐릭")
                Text("기본 이름")
            }
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    //@State static var characterList: [CharacterSetting] = [] // characterList를 미리 생성
    
    static var previews: some View {
        MainView() // characterList를 MainView에 전달
    }
}

