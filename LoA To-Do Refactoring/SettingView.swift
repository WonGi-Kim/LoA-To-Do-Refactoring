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
    @ObservedObject private var characterViewModel = CharacterViewModel()
    
    
    var body: some View {
        ScrollView{
            VStack{
                charInfoInputSection(newCharacter: $characterViewModel.newCharacter)
                charToDoListSelection(newCharacter: $characterViewModel.newCharacter)
                Spacer()
            }
            
            
            .navigationBarTitle("캐릭터 생성")
            .navigationBarItems(
                leading: backButton(isMainViewActive: $isMainViewActive),
                trailing: confirmCharacterCreateButton(isMainViewActive: $isMainViewActive, newCharacter: $characterViewModel.newCharacter, characterList: $characterList)
            )
        }
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
            isGuardianRaid: newCharacter.wrappedValue.isGuardianRaid,
            isChaosDungeon: newCharacter.wrappedValue.isChaosDungeon,
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
        
        let characterViewModel = CharacterViewModel()
        characterViewModel.saveDateForCreateCell(newChar)

        
        
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
                .keyboardType(.decimalPad)
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

//  MARK: charToDoListSelection
func charToDoListSelection(newCharacter: Binding<CharacterSetting>) -> some View {
    return VStack {
        HStack {
            Text("일일 컨텐츠")
                .font(.title3)
                .padding(.top,10)
            Spacer()
        }.padding(.leading,20)
        Toggle("가디언 토벌", isOn: newCharacter.isGuardianRaid)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        Toggle("카오스 던전", isOn: newCharacter.isChaosDungeon)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        
        HStack {
            Text("군단장 토벌")
                .font(.title3)
            Spacer()
        }.padding(.leading,20)
            .padding(.top, 10)
        
        HStack {
            Toggle("발탄", isOn: newCharacter.isValtanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("비아키스", isOn: newCharacter.isViakissRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("쿠크세이튼", isOn: newCharacter.isKoukuRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("아브렐슈드", isOn: newCharacter.isAbrelRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("일리아칸", isOn: newCharacter.isIliakanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("카멘", isOn: newCharacter.isKamenRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        
        Spacer()
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

