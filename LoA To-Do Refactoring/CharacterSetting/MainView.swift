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

// MainView.swift

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure() // Firebase 초기화 코드
        return true
    }
}

struct MainView: View {
    //  뷰의 이동을 위한 변수
    @State var mainViewActive = false
    @State var isSettingViewActive = false
    @State var isDetailViewActive = false
    
    //  characterViewModel 내부의 characterList[index]를 받아 DetailView에 하나의 캐릭터만 넘기기 위한 변수
    @State var selectedCharacter: CharacterSetting = CharacterSetting(
        charImage: "", charName: "",
        charClass: "", charLevel: "",
        isGuardianRaid: false, isChaosDungeon: false,
        isValtanRaid: false, isViakissRaid: false,
        isKoukuRaid: false, isAbrelRaid: false,
        isIliakanRaid: false, isKamenRaid: false,
        isAbyssRaid: false, isAbyssDungeon: false,
        whatAbyssDungeon: "")
    
    //  DetailView로 넘길 ToDoInfo 데이터
    @State var characterToDoInfo : ManageToDoInfo = ManageToDoInfo(
        charName: "",
        isChaosDungeonDone: false,isGuardianRaidDone: false,
        isValtanRaidDone: false,isViakissRaidDone: false,
        isKoukuRaidDone: false,isAbrelRaidDone: false,
        isIliakanRaidDone: false,isKamenRaidDone: false,
        isAbyssRaidDone: false,isAbyssDungeonDone: false
        )
    
    //  캐릭터 최초 생성시에 필요한 characterList
    @State var characterList: [CharacterSetting] = []
    
    //  EditView에서 넘어오는 데이터를 MainView에서 반영하기 위해서 (Firebase관리 부분에서 addSnapshotListener 추가
    @StateObject var characterViewModel = CharacterViewModel()
    
    //  Api호출을 위한 변수
    @State var encodeName: String = ""
    

    var body: some View {
        NavigationView {
            List() {
                ForEach(characterViewModel.characterList.indices, id: \.self) { index in
                    createCharacterCell(isMainViewActive: $mainViewActive, 
                                        character: $characterViewModel.characterList[index],
                                        isDetailViewActive: $isDetailViewActive,
                                        selectedCharacter: $selectedCharacter,
                                        characterToDoInfo: $characterToDoInfo
                    )
                }
                .onDelete(perform: characterViewModel.removeCells)  //List 삭제
            }
            .onAppear(){    // MainView로드 시 characterList의 데이터는 사라지기 때문에 Firebase에서 데이터 로드
                characterViewModel.loadDataForCreateCell()
            }
            .navigationBarTitle("LoA To-Do Refact",displayMode: .inline)
            .navigationBarItems(trailing: createNewCharacterButton(isMainViewActive: $mainViewActive, 
                                                                   characterList: $characterList,
                                                                   isSettingViewActive:$isSettingViewActive))
            .refreshable {
                characterViewModel.loadDataForCreateCell()
            }
        }
    }
}

//  MARK: 캐릭터 생성 버튼
func createNewCharacterButton(isMainViewActive: Binding<Bool>, characterList: Binding<[CharacterSetting]>,isSettingViewActive: Binding<Bool>) -> some View {
    Button {
        isSettingViewActive.wrappedValue.toggle()
    } label: {
        Image.init(systemName: "plus")
            .foregroundColor(.white)
            .font(.title2)
    }
    .background(
        NavigationLink("",destination: SettingView(
            isMainViewActive: isMainViewActive,
            isSettingViewActive: isSettingViewActive,
            characterList: characterList),isActive : isSettingViewActive)
            .opacity(0)
    )
}

//  MARK: List에 characterSetting의 값을 가진 Cell생성 및 DetailView로 이동하는 버튼 생성
func createCharacterCell(isMainViewActive: Binding<Bool>, character: Binding<CharacterSetting>, isDetailViewActive: Binding<Bool>, selectedCharacter: Binding<CharacterSetting>, characterToDoInfo: Binding<ManageToDoInfo>) -> some View {
    HStack {
        Button {
            isDetailViewActive.wrappedValue.toggle()
            selectedCharacter.wrappedValue = character.wrappedValue
        } label: {
            HStack {
                Image(character.wrappedValue.charClass)
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Spacer()
                
                VStack {
                    Text(character.wrappedValue.charName)
                    Text(character.wrappedValue.charLevel)
                }
                Spacer()
                
            }
            .background(
                NavigationLink("", destination: DetailView(
                    isMainViewActive: isMainViewActive, isDetailViewActive: isDetailViewActive,
                    character: selectedCharacter,
                    characterToDoInfo: characterToDoInfo), isActive: isDetailViewActive)
                .opacity(0)
            )
        }.buttonStyle(PlainButtonStyle())
        
        
        Button {
            callLostarkApi(characterViewModel: CharacterViewModel(), character: character) {
                // API 호출이 완료된 후에 UI 업데이트 코드를 작성
                print("API complete")
            }
            print("callLostarkApi Tapped")
        } label: {
            Image.init(systemName: "arrow.clockwise")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}

func callLostarkApi(characterViewModel: CharacterViewModel, character: Binding<CharacterSetting>, completion: @escaping () -> Void) {
    guard let encodeName = character.wrappedValue.charName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }

    characterViewModel.getCharacterProfiles(characterName: encodeName) { result in
        switch result {
        case .success(let data):
            // API 호출 성공 시 데이터 업데이트
            DispatchQueue.main.async {
                character.wrappedValue.charImage = data.CharacterImage ?? ""
                character.wrappedValue.charName = data.CharacterName ?? ""
                character.wrappedValue.charClass = data.CharacterClassName ?? ""
                character.wrappedValue.charLevel = data.ItemAvgLevel ?? ""
                
                characterViewModel.saveDateForCreateCell(character.wrappedValue)
            }
        case .failure(let error):
            // 에러 처리
            print("API Error: \(error)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
