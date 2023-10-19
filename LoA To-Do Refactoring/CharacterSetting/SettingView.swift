//
//  SettingView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/18.
//

import SwiftUI

struct SettingView: View {
    @Binding var isMainViewActive: Bool
    @Binding var isSettingViewActive: Bool
    @Binding var characterList: [CharacterSetting]
    @ObservedObject var characterViewModel = CharacterViewModel()
    
    
    var body: some View {
        ScrollView{
            VStack{
                charInfoInputSection(tempNewCharacter: $characterViewModel.newCharacter)
                charToDoListSelection(tempNewCharacter: $characterViewModel.newCharacter, characterViewModel: characterViewModel)
                Spacer()
            }
            
            
            .navigationBarTitle("캐릭터 생성")
            .navigationBarItems(
                leading: backButton(isMainViewActive: $isMainViewActive),
                trailing: confirmCharacterCreateButton(isMainViewActive: $isMainViewActive, tempNewCharacter: $characterViewModel.newCharacter, characterList: $characterList, isSettingViewActive: $isSettingViewActive, characterViewModel: characterViewModel)
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
//  캐릭터 이미지를 먼저 넘겨서 셀 생성
//  MARK: 이미지 호출
func callApiForImage(characterViewModel: CharacterViewModel, tempNewCharacter: Binding<CharacterSetting>, completion: @escaping () -> Void) {
    //GDC의 DispatchGroup 사용
    let group = DispatchGroup() // 그룹 생성
    
    guard let encodeName = tempNewCharacter.wrappedValue.charName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }
    
    group.enter() // 그룹 진입
    
    characterViewModel.getCharacterProfiles(characterName: encodeName) { result in
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                tempNewCharacter.wrappedValue.charImage = data.CharacterImage ?? ""
                print("###############")
                print("Queue에서 \(tempNewCharacter.wrappedValue.charImage)")
                group.leave() // 완료시 그룹에서 빠져나옴
            }
            
        case .failure(let error):
            // 에러 처리
            print("API Error: \(error)")
            group.leave() // 완료시 그룹에서 빠져나옴
        }
    }
    group.wait() // 그룹에 진입한 모든 작업이 완료될 때까지 대기
    completion() // 모든 작업이 완료되면 이후 작업 수행

}

//  MARK: 캐릭터 생성 완료 버튼
func confirmCharacterCreateButton(isMainViewActive: Binding<Bool>, tempNewCharacter: Binding<CharacterSetting>, characterList: Binding<[CharacterSetting]>,isSettingViewActive: Binding<Bool>, characterViewModel: CharacterViewModel) -> some View {
    return Button {
        isSettingViewActive.wrappedValue = false
        
        callApiForImage(characterViewModel: CharacterViewModel(), tempNewCharacter: tempNewCharacter) {
            
        }
        
        let newChar = CharacterSetting(
            charImage: tempNewCharacter.wrappedValue.charImage,
            charName: tempNewCharacter.wrappedValue.charName,
            charClass: tempNewCharacter.wrappedValue.charClass,
            charLevel: tempNewCharacter.wrappedValue.charLevel,
            isGuardianRaid: tempNewCharacter.wrappedValue.isGuardianRaid,
            isChaosDungeon: tempNewCharacter.wrappedValue.isChaosDungeon,
            isValtanRaid: tempNewCharacter.wrappedValue.isValtanRaid,
            isViakissRaid: tempNewCharacter.wrappedValue.isViakissRaid,
            isKoukuRaid: tempNewCharacter.wrappedValue.isKoukuRaid,
            isAbrelRaid: tempNewCharacter.wrappedValue.isAbrelRaid,
            isIliakanRaid: tempNewCharacter.wrappedValue.isIliakanRaid,
            isKamenRaid: tempNewCharacter.wrappedValue.isKamenRaid,
            isAbyssRaid: tempNewCharacter.wrappedValue.isAbyssRaid,
            isAbyssDungeon: tempNewCharacter.wrappedValue.isAbyssDungeon,
            whatAbyssDungeon: tempNewCharacter.wrappedValue.whatAbyssDungeon
        )
        characterList.wrappedValue.append(newChar)
        
        let characterViewModel = CharacterViewModel()
        characterViewModel.saveDateForCreateCell(newChar)
        
        print("SettingView에서 \(newChar)")
        
    } label: {
        Text("캐릭터 생성")
            .foregroundColor(.blue)
            .font(.system(size: 17))
    }
}

//  MARK: 캐릭터 기본정보 입력(이름, 레벨, 클래스)
func charInfoInputSection(tempNewCharacter: Binding<CharacterSetting>) -> some View {
    return VStack {
        HStack {
            Text("캐릭터 명")
            Spacer()
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
        
        HStack {
            TextField("캐릭터 이름을 입력해주세요", text: tempNewCharacter.charName)
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
            TextField("아이템 레벨을 입력해주세요", text: tempNewCharacter.charLevel)
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
            TextField("캐릭터 클래스를 선택해주세요", text: tempNewCharacter.charClass)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

//  MARK: charToDoListSelection
func charToDoListSelection(tempNewCharacter: Binding<CharacterSetting>, characterViewModel: CharacterViewModel) -> some View {
    
    return VStack {
        HStack {
            Text("일일 컨텐츠")
                .padding(.top,10)
            Spacer()
        }.padding(.leading,20)
        Toggle("가디언 토벌", isOn: tempNewCharacter.isGuardianRaid)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        Toggle("카오스 던전", isOn: tempNewCharacter.isChaosDungeon)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        
        HStack {
            Text("군단장 토벌")
            Spacer()
        }.padding(.leading,20)
            .padding(.top, 10)
        
        HStack {
            Toggle("발탄", isOn: tempNewCharacter.isValtanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("비아키스", isOn: tempNewCharacter.isViakissRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("쿠크세이튼", isOn: tempNewCharacter.isKoukuRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("아브렐슈드", isOn: tempNewCharacter.isAbrelRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        HStack {
            Toggle("일리아칸", isOn: tempNewCharacter.isIliakanRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
            Toggle("카멘", isOn: tempNewCharacter.isKamenRaid)
                .toggleStyle(CharacterViewModel.CommanderToggleStyle())
        }
        
        HStack {
            Text("어비스 컨텐츠")
            Spacer()
        }.padding(.leading,20)
            .padding(.top, 10)
        
        Toggle("어비스 레이드: 아르고스", isOn: tempNewCharacter.isAbyssRaid)
            .toggleStyle(CharacterViewModel.DailyToggleStyle())
        
        HStack {
            Picker("어비스 던전 선택", selection: tempNewCharacter.whatAbyssDungeon) {
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
                
                .onChange(of: characterViewModel.newCharacter.whatAbyssDungeon) { newValue in
                    characterViewModel.updateIsAbyssDungeonValue()
                }
            
                
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}



struct SettingView_Previews: PreviewProvider {
    @State static var isMainViewActive = false
    @State static var isSettingViewActive = false
    @State static var characterList: [CharacterSetting] = []
    @State static var newCharacter: CharacterSetting = CharacterSetting(
        charImage:"",
        charName: "", charClass: "",
        charLevel: "", isGuardianRaid: false,
        isChaosDungeon: false, isValtanRaid: false,
        isViakissRaid: false, isKoukuRaid: false,
        isAbrelRaid: false, isIliakanRaid: false,
        isKamenRaid: false, isAbyssRaid: false,
        isAbyssDungeon: false, whatAbyssDungeon: "")
    
    static var previews: some View {
        MainView()
            .sheet(isPresented: $isMainViewActive) {
                SettingView(isMainViewActive: $isMainViewActive, isSettingViewActive: $isSettingViewActive, characterList: $characterList)
            }
    }
}

