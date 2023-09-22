//
//  SettingView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/18.
//

import SwiftUI

struct SettingView: View {
    @Binding var isMainViewActive: Bool
    @Binding var characterList: [CharacterSetting]
    @State var newCharacter: CharacterSetting = CharacterSetting(
        charName: "", charClass: "",
        charLevel: "", isGuardianRaid: false,
        isChaosDungeon: false, isValtanRaid: false,
        isViakissRaid: false, isKoukuRaid: false,
        isAbrelRaid: false, isIliakanRaid: false,
        isKamenRaid: false, isAbyssRaid: false,
        isAbyssDungeon: false)
    
    var body: some View {
        
        VStack{
            charInfoInputSection(newCharacter: $newCharacter)
            Spacer()
        }
        

            .navigationBarTitle("캐릭터 생성")
            .navigationBarItems(
                leading: backButton(isMainViewActive: $isMainViewActive),
                trailing: confirmCharacterCreateButton(isMainViewActive: $isMainViewActive, newCharacter: $newCharacter, characterList: $characterList)
            )
    }
}


//  MARK: - SettingView 구성 함수
//  MARK: 이전화면 버튼
func backButton(isMainViewActive: Binding<Bool>) -> some View {
    Button {
        isMainViewActive.wrappedValue = false
        
    } label: {

    }
}

//  MARK: 캐릭터 생성 완료 버튼
func confirmCharacterCreateButton(isMainViewActive: Binding<Bool>, newCharacter: Binding<CharacterSetting>, characterList: Binding<[CharacterSetting]>) -> some View {
    return Button {
        isMainViewActive.wrappedValue = false
        let newChar = CharacterSetting(
            charName: newCharacter.wrappedValue.charName,
            charClass: newCharacter.wrappedValue.charClass,
            charLevel: newCharacter.wrappedValue.charLevel,
            isGuardianRaid: false,
            isChaosDungeon: false,
            isValtanRaid: false,
            isViakissRaid: false,
            isKoukuRaid: false,
            isAbrelRaid: false,
            isIliakanRaid: false,
            isKamenRaid: false,
            isAbyssRaid: false,
            isAbyssDungeon: false
        )
        characterList.wrappedValue.append(newChar)
        
        print("Setting에서 characterList", characterList.wrappedValue)
        print("Setting에서 characterList", characterList.wrappedValue.count)
        print("Setting에서 newCharacter.wrappedValue.charName", newCharacter.wrappedValue.charName)
        
        
    } label: {
        Text("캐릭터 생성")
            .foregroundColor(.blue)
            .font(.system(size: 17))
    }
}

//  MARK: 캐릭터 기본정보 입력(이름, 레벨, 클래스)
func charInfoInputSection(newCharacter: Binding<CharacterSetting>) -> some View {
    return VStack {
        HStack {
            Text("캐릭터 명")
            Spacer()
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
        
        HStack {
            TextField("캐릭터 이름을 입력해주세요", text: newCharacter.charName)
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
            TextField("아이템 레벨을 입력해주세요", text: newCharacter.charLevel)
                .keyboardType(.numberPad)
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
            TextField("캐릭터 클래스를 선택해주세요", text: newCharacter.charClass)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct SettingView_Previews: PreviewProvider {
    @State static var isMainViewActive = false
    @State static var characterList: [CharacterSetting] = []
    @State static var newCharacter: CharacterSetting = CharacterSetting(
        charName: "", charClass: "",
        charLevel: "", isGuardianRaid: false,
        isChaosDungeon: false, isValtanRaid: false,
        isViakissRaid: false, isKoukuRaid: false,
        isAbrelRaid: false, isIliakanRaid: false,
        isKamenRaid: false, isAbyssRaid: false,
        isAbyssDungeon: false)
    
    static var previews: some View {
        MainView()
            .sheet(isPresented: $isMainViewActive) {
                SettingView(isMainViewActive: $isMainViewActive, characterList: $characterList)
            }
    }
}

