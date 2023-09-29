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
    @State var newCharacter: CharacterSetting = CharacterSetting (
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
            charToDoListSelection(newCharacter: $newCharacter)
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
            isGuardianRaid: newCharacter.wrappedValue.isGuardianRaid,
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

//  MARK: charToDoListSelection
func charToDoListSelection(newCharacter: Binding<CharacterSetting>) -> some View {
    return VStack {
        Button {
            Toggle("가디언 토벌", isOn: newCharacter.isGuardianRaid)
                .toggleStyle(CheckmarkToggleStyle())
        } label: {
            Image("리퍼")
                .resizable()
                .frame(width: 10, height: 10)
        }
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.title2)
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
                .resizable()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .frame(width: 410 ,height: 100)
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

