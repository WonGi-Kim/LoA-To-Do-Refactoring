//
//  DetailView.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/10/06.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var isMainViewActive: Bool
    @Binding var character: CharacterSetting
    @ObservedObject var characterViewModel = CharacterViewModel()
    @ObservedObject var detailViewModel = DetailViewViewModel()
    
    @State var characterToDoInfo : ManageToDoInfo = ManageToDoInfo(
        charName: "",
        isChaosDungeonDone: false,isGuardianRaidDone: false,
        isValtanRaidDone: false,isViakissRaidDone: false,
        isKoukuRaidDone: false,isAbrelRaidDone: false,
        isIliakanRaidDone: false,isKamenRaidDone: false,
        isAbyssRaidDone: false,isAbyssDungeonDone: false)
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: character.charImage)!) { phase in
                    switch phase {
                    case .empty:
                        // 이미지가 로드되지 않은 경우, 로딩 중 뷰 표시
                        ProgressView()
                    case .success(let image):
                        // 이미지가 로드되면 표시
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        // 이미지 로드 실패 시 에러 이미지 또는 기본 이미지 표시
                        Image(systemName: "photo")
                    @unknown default:
                        // 기본 이미지 표시
                        Image(systemName: "photo")
                    }
                }
                
                Text("캐릭터 이름: \(character.charName)")
                Text("캐릭터 클래스: \(character.charClass)")
                Text("아이템 레벨: \(character.charLevel)")
                Text("카던: \(String(character.isChaosDungeon))")
                //Text("가토: \(String((character.isGuardianRaid))")
                
                Button {
                    characterToDoInfo.charName = character.charName
                    detailViewModel.toDoInfo.charName = characterToDoInfo.charName
                    print("characterToDoInfo.charName: \(characterToDoInfo.charName)")
                    print("detailViewModel.toDoInfo.charName: \(detailViewModel.toDoInfo.charName)")
                    detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                } label: {
                    Text("시험용 FireStore등록 버튼")
                }
            }
        }
        .navigationBarTitle("캐릭터 관리")
        .navigationBarItems(
            leading: backButton(isMainViewActive: $isMainViewActive)
        )
        .onAppear {
            print("넘어온 character: \(character)")
        }
    }
       
}

struct DetailView_Previews: PreviewProvider {
    @State static var isMainViewActive = false
    @State static var character: CharacterSetting = CharacterSetting(
        charImage: "",
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
                DetailView(isMainViewActive: $isMainViewActive, character: $character)
            }
    }
}
