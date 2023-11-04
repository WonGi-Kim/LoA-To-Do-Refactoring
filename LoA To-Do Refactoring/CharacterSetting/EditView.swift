//
//  EditView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 10/30/23.
//

import SwiftUI

struct EditView: View { //  SettingView 재활용
    @Binding var isDetailViewActive: Bool
    @Binding var isEditViewActive: Bool
    @Binding var character: CharacterSetting
    
    @ObservedObject var characterViewModel = CharacterViewModel()
    @ObservedObject var detailViewModel = DetailViewViewModel()
    
    var body: some View {
        ScrollView{
            VStack {
                editInfoInputSection(character: $character)
                editToDoListSelection(character: $character, characterViewModel: characterViewModel)
            }
        }
        
        .navigationTitle("캐릭터 수정")
        .navigationBarItems(
            leading: backButtonToDetailView(isDetailViewActive: $isDetailViewActive)
        )
        .onDisappear() {
            detailViewModel.initToDoInfo(character: character)
        }
    }
    
}

//  MARK: 이전화면 버튼
//  데이터는 DetailView에서 Binding되었기에 따로 전달할 필요 없이 DetailView에 반영
func backButtonToDetailView(isDetailViewActive: Binding<Bool>) -> some View {
    Button {
        isDetailViewActive.wrappedValue = false
        
    } label: {

    }
}

//  MARK: 캐릭터 기본정보 입력(이름, 레벨, 클래스)
func editInfoInputSection(character: Binding<CharacterSetting>) -> some View {
    return VStack {
        HStack {
            Text("캐릭터 명")
            Spacer()
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
        
        HStack {
            TextField("캐릭터 이름을 입력해주세요", text: character.charName)
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
            TextField("아이템 레벨을 입력해주세요", text: character.charLevel)
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
            TextField("캐릭터 클래스를 선택해주세요", text: character.charClass)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

//  MARK: charToDoListSelection
func editToDoListSelection(character: Binding<CharacterSetting>, characterViewModel: CharacterViewModel) -> some View {
    
    return VStack {
        HStack {
            Text("일일 컨텐츠")
                .padding(.top,10)
            Spacer()
        }.padding(.leading,20)
        Toggle("가디언 토벌", isOn: character.isGuardianRaid)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        Toggle("카오스 던전", isOn: character.isChaosDungeon)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        
        HStack {
            Text("군단장 토벌")
            Spacer()
        }.padding(.leading,20)
            .padding(.top, 10)
        
        HStack {
            Toggle("발탄", isOn: character.isValtanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("비아키스", isOn: character.isViakissRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("쿠크세이튼", isOn: character.isKoukuRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("아브렐슈드", isOn: character.isAbrelRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("일리아칸", isOn: character.isIliakanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("카멘", isOn: character.isKamenRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        
        HStack {
            Text("어비스 컨텐츠")
            Spacer()
        }.padding(.leading,20)
            .padding(.top, 10)
        
        Toggle("어비스 레이드: 아르고스", isOn: character.isAbyssRaid)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        
        HStack {
            Picker("어비스 던전 선택", selection: character.whatAbyssDungeon) {
                ForEach(characterViewModel.abyssArray, id: \.self) { dungeon in
                        Text(dungeon)
                        .foregroundColor(.white)
                    
                    }
                }
            .frame(width: 350, height: 25)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: character.wrappedValue.whatAbyssDungeon) { newValue in
                    if character.whatAbyssDungeon.wrappedValue == "--선택안함--" {
                        character.isAbyssDungeon.wrappedValue = false
                    } else {
                        character.isAbyssDungeon.wrappedValue = true
                    }
                }
                
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

/**
#Preview {
    @State var isDetailViewActive = false
    @State var isEditViewActive = false
    EditView(isDetailViewActive: $isDetailViewActive, isEditViewActive: $isEditViewActive)
}
*/
