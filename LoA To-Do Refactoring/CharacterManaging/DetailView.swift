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
        isAbyssRaidDone: false,isAbyssDungeonDone: false
    )
    
    var body: some View {
        ScrollView {
            VStack {
                //  기본 정보
                HStack{
                    VStack {
                        Spacer()
                        Text("캐릭터 이름: ")
                        Text("\(character.charName)")
                        Spacer()
                        Text("캐릭터 클래스: ")
                        Text("\(character.charClass)")
                        Spacer()
                        Text("아이템 레벨: ")
                        Text("\(character.charLevel)")
                        Spacer()
                    }
                    AsyncImage(url: URL(string: character.charImage)!) { phase in
                        switch phase {
                        case .empty:
                            // 이미지가 로드되지 않은 경우, 로딩 중 뷰 표시
                            ProgressView()
                        case .success(let image):
                            // 이미지가 로드되면 표시
                            image
                                .resizable()
                                .frame(width: 300, height: 400, alignment: .trailing)
                        case .failure:
                            // 이미지 로드 실패 시 에러 이미지 또는 기본 이미지 표시
                            Image(systemName: "photo")
                        @unknown default:
                            // 기본 이미지 표시
                            Image(systemName: "photo")
                        }
                    }
                    
                }
                
                // CharacterToDoInfo를 전부 받아서 ViewModel로 전달
                Button {
                    characterToDoInfo.charName = character.charName
                    detailViewModel.toDoInfo.charName = characterToDoInfo.charName
                    detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                } label: {
                    Text("시험용 FireStore등록 버튼")
                }
                
                if character.isChaosDungeon {
                    Button {
                        characterToDoInfo.isChaosDungeonDone.toggle()

                    } label: {
                        Text("카오스 던전")
                    }
                }
                if character.isGuardianRaid {
                    Toggle("가디언 토벌", isOn: $characterToDoInfo.isGuardianRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
            }
        }
        .navigationBarTitle("캐릭터 관리")
        .navigationBarItems(
            leading: backButton(isMainViewActive: $isMainViewActive)
        )
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
