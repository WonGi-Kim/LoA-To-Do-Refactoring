//
//  MainView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/16.
//


//  MainView에서 firestore에 데이터 적용
//  Api사용후 데이터 갱신을 사용하기 위해
//  DetailView에서는 Done값을 새로 작성하여 Bool값을 조정하는 부분 작성
//  수정화면에서는


import SwiftUI

//  MARK: - 처음 화면
struct MainView: View {
    @State var mainViewActive = false
    @State var isSettingViewActive = false
    
    @State var characterList: [CharacterSetting] = []
    
    var body: some View {
        NavigationView {
            
            List() {
                ForEach(characterList.indices, id: \.self) { index in
                    createCharacterCell(characterList: $characterList[index])
                }
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
func createCharacterCell(characterList: Binding<CharacterSetting>) -> some View {
    Button {
    } label: {
        HStack {
            Image(characterList.wrappedValue.charClass)
                .resizable()
                .frame(width: 50, height: 50)
            
            Spacer()
            
            VStack {
                Text(characterList.wrappedValue.charName)
                Text(characterList.wrappedValue.charLevel)
            }
            Spacer()
        }
    }
}

//  MARK: API갱신


struct MainView_Previews: PreviewProvider {
    //@State static var characterList: [CharacterSetting] = [] // characterList를 미리 생성
    
    static var previews: some View {
        MainView() // characterList를 MainView에 전달
    }
}

