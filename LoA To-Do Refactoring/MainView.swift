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
import Firebase
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure() // Firebase 초기화 코드
        return true
    }
}

//  MARK: - 처음 화면
struct MainView: View {
    @State var mainViewActive = false
    @State var isSettingViewActive = false
    
    @State var characterList: [CharacterSetting] = []
    
    @ObservedObject var characterViewModel = CharacterViewModel()
    @State var encodeName: String = ""
    

    var body: some View {
        NavigationView {
            
            List() {
                ForEach(characterViewModel.characterList.indices, id: \.self) { index in
                    createCharacterCell(character: $characterViewModel.characterList[index])
                }
            }
            
            .onAppear(){
                characterViewModel.loadDataForCreateCell()
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
func createCharacterCell(character: Binding<CharacterSetting>) -> some View {
    HStack {
        Button {
            print("CharacterCell Tapped")
            print("character:", character)
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
        }.buttonStyle(PlainButtonStyle())
        
        Spacer()
        
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

// MARK: API 갱신
func callLostarkApi(characterViewModel: CharacterViewModel, character: Binding<CharacterSetting>, completion: @escaping () -> Void) {
    guard let encodeName = character.wrappedValue.charName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }

    characterViewModel.getCharacterProfiles(characterName: encodeName) { result in
        switch result {
        case .success(let data):
            // API 호출 성공 시 데이터 업데이트
            DispatchQueue.main.async {
                character.wrappedValue.charName = data.CharacterName ?? ""
                character.wrappedValue.charClass = data.CharacterClassName ?? ""
                character.wrappedValue.charLevel = data.ItemAvgLevel ?? ""
                // 데이터가 업데이트되었음을 완료 클로저를 통해 알림
                
                characterViewModel.saveDateForCreateCell(character.wrappedValue)
            }
        case .failure(let error):
            // 에러 처리
            print("API Error: \(error)")
            // 에러가 발생한 경우도 완료 클로저를 호출
        }
    }
}



struct MainView_Previews: PreviewProvider {
    //@State static var characterList: [CharacterSetting] = [] // characterList를 미리 생성
    
    static var previews: some View {
        MainView() // characterList를 MainView에 전달
    }
}

