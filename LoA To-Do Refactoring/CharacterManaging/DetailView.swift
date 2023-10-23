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
                        detailViewModel.characterInfoView(label: "닉네임: ", value: character.charName)
                        Spacer()
                        detailViewModel.characterInfoView(label: "클래스: ", value: character.charClass)
                        Spacer()
                        detailViewModel.characterInfoView(label: "아이템 레벨: ", value: character.charLevel)
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
                    
                }.padding(.bottom,20)
                
                // 일일 컨텐츠
                if character.isChaosDungeon == false && character.isGuardianRaid == false {
                    VStack {
                        HStack{
                            Text("일일 컨텐츠")
                                .padding(.leading,10)
                            Spacer()
                        }
                        Text("There is not choiced Daily Contents..!!")
                    }
                } else {
                    HStack {
                        Text("일일 컨텐츠")
                            .padding(.leading,10)
                        Spacer()
                    }
                }
                if character.isChaosDungeon {
                    Toggle("카오스 던전", isOn: $characterToDoInfo.isChaosDungeonDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isChaosDungeonDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                            print(characterToDoInfo.isChaosDungeonDone)
                        }
                }
                if character.isGuardianRaid {
                    Toggle("가디언 토벌", isOn: $characterToDoInfo.isGuardianRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isGuardianRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                
                // 군단장 레이드
                if character.isValtanRaid == false && character.isViakissRaid == false && character.isKoukuRaid == false &&
                    character.isAbrelRaid == false && character.isIliakanRaid == false && character.isKamenRaid == false {
                    VStack {
                        HStack{
                            Text("군단장 레이드")
                                .padding(.leading,10)
                            Spacer()
                        }
                        Text("There is not choiced Commender Raid Contents..!!")
                    }
                } else {
                    HStack {
                        Text("군단장 레이드")
                            .padding(.leading,10)
                        Spacer()
                    }
                }
                if character.isValtanRaid {
                    Toggle("군단장 발탄 ", isOn: $characterToDoInfo.isValtanRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isValtanRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isViakissRaid {
                    Toggle("군단장 비아키스", isOn: $characterToDoInfo.isViakissRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isViakissRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isKoukuRaid {
                    Toggle("군단장 쿠크세이튼", isOn: $characterToDoInfo.isKoukuRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isKoukuRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isAbrelRaid {
                    Toggle("군단장 아브렐슈드", isOn: $characterToDoInfo.isAbrelRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isAbrelRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isIliakanRaid {
                    Toggle("군단장 일리아칸", isOn: $characterToDoInfo.isIliakanRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isIliakanRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isKamenRaid {
                    Toggle("군단장 카멘", isOn: $characterToDoInfo.isKamenRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isKamenRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                
                //  어비스 컨텐츠
                if character.isAbyssDungeon == false && character.isAbyssRaid == false {
                    VStack {
                        HStack{
                            Text("어비스 컨텐츠")
                                .padding(.leading,10)
                            Spacer()
                        }
                        Text("There is not choiced Abyss Contents..!!")
                    }
                } else {
                    HStack {
                        Text("어비스 컨텐츠")
                            .padding(.leading,10)
                        Spacer()
                    }
                }
                if character.isAbyssRaid {
                    Toggle("어비스 레이드: 아르고스 ", isOn: $characterToDoInfo.isAbyssRaidDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isAbyssRaidDone.toggle()
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
                if character.isAbyssDungeon {
                    Toggle("어비스 던전:\(character.whatAbyssDungeon) ", isOn: $characterToDoInfo.isAbyssDungeonDone)
                        .toggleStyle(DetailViewViewModel.ContentsToggleStyle())
                        .onTapGesture {
                            characterToDoInfo.isAbyssDungeonDone.toggle()
                            characterToDoInfo.whatAbyssDungeon = character.whatAbyssDungeon
                            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
                        }
                }
            }
        }
        
        
        
        .navigationBarTitle("캐릭터 관리")
        .navigationBarItems(
            leading: backButton(isMainViewActive: $isMainViewActive)
        )
        .onAppear {
            // CharacterToDoInfo를 전부 받아서 ViewModel로 전달
            characterToDoInfo.charName = character.charName
            detailViewModel.saveDataForManageToDoInfo(characterToDoInfo)
        }
        .refreshable {
            characterViewModel.characterForUpdate = character
            characterViewModel.updateCharacter {
                character = characterViewModel.characterForUpdate
            }
            
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
