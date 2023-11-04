//
//  DetailViewViewModel.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/10/12.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class DetailViewViewModel: ObservableObject {
    @Published var toDoInfo: ManageToDoInfo = ManageToDoInfo()
    @Published var characterToDoInfo : ManageToDoInfo = ManageToDoInfo(
        charName: "",
        isChaosDungeonDone: false,isGuardianRaidDone: false,
        isValtanRaidDone: false,isViakissRaidDone: false,
        isKoukuRaidDone: false,isAbrelRaidDone: false,
        isIliakanRaidDone: false,isKamenRaidDone: false,
        isAbyssRaidDone: false,isAbyssDungeonDone: false,
        whatAbyssDungeon: ""
    )
    
    let db = Firestore.firestore()
    
    func saveDataForManageToDoInfo(_ toDoInfo : ManageToDoInfo) {
        let charName = toDoInfo.charName
        
        let dataToUpdateAndSave: [String: Any] = [
            "charName": toDoInfo.charName ?? "",
            "chaosDungeon": toDoInfo.isChaosDungeonDone,
            "guardianRaid": toDoInfo.isGuardianRaidDone,
            "valtanRaid": toDoInfo.isValtanRaidDone,
            "viakissRaid": toDoInfo.isViakissRaidDone,
            "koukuRaid": toDoInfo.isKoukuRaidDone,
            "abrelRaid": toDoInfo.isAbrelRaidDone,
            "iliakanRaid": toDoInfo.isIliakanRaidDone,
            "kamenRaid": toDoInfo.isKamenRaidDone,
            "abyssRaid": toDoInfo.isAbyssRaidDone,
            "abyssDungeon": toDoInfo.isAbyssDungeonDone,
            "whatAbyssDungeon": toDoInfo.whatAbyssDungeon
        ]
        
        let charCollection = db.collection("ManageCharacter")
        let documentRef = charCollection.document(charName)
        
        documentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document for ManageCharacter updated successfully!")
                    }
                }
            } else {
                // 해당 캐릭터 이름을 가진 문서가 존재하지 않는 경우 생성
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document for ManageCharacter added successfully!")
                    }
                }
            }
        }
    }
    
    func loadDataFromFireStore(_ charName : String, completion : @escaping (Result<ManageToDoInfo, Error>) -> Void ) {
        let manageCharacterCollection = db.collection("ManageCharacter")
        
        let characterID = charName ?? ""
        manageCharacterCollection.document(characterID).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            guard let document = snapshot else {
                print("Document does not exist")
                return
            }
            if document.exists {
                if let data = document.data() {
                    self.characterToDoInfo.charName = data["charName"] as? String ?? ""
                    self.characterToDoInfo.isChaosDungeonDone = data["chaosDungeon"] as? Bool ?? false
                    self.characterToDoInfo.isGuardianRaidDone = data["guardianRaid"] as? Bool ?? false
                    self.characterToDoInfo.isValtanRaidDone = data["valtanRaid"] as? Bool ?? false
                    self.characterToDoInfo.isViakissRaidDone = data["viakissRaid"] as? Bool ?? false
                    self.characterToDoInfo.isKoukuRaidDone = data["koukuRaid"] as? Bool ?? false
                    self.characterToDoInfo.isAbrelRaidDone = data["abrelRaid"] as? Bool ?? false
                    self.characterToDoInfo.isIliakanRaidDone = data["iliakanRaid"] as? Bool ?? false
                    self.characterToDoInfo.isKamenRaidDone = data["kamenRaid"] as? Bool ?? false
                    self.characterToDoInfo.isAbyssRaidDone = data["abyssRaid"] as? Bool ?? false
                    self.characterToDoInfo.isAbyssDungeonDone = data["abyssDungeon"] as? Bool ?? false
                    self.characterToDoInfo.whatAbyssDungeon = data["whatAbyssDungeon"] as? String ?? "--선택안함--"
                    
                    //  업데이트된 characterToDoInfo 저장
                    self.saveDataForManageToDoInfo(self.characterToDoInfo)
                    
                    print("Document load success!")
                    completion(.success(self.characterToDoInfo))
                }
            } else {
                print("Document does not exist")
                let error = NSError(domain: "Document Not Founded", code: 404, userInfo: nil)
                completion(.failure(error))
            }
        }
        
    }
    
    //  MARK: - Init characterToDoInfo
    func initToDoInfo(character: CharacterSetting) {
        let characterName = character.charName ?? ""
        
        let manageCharacterCollection = db.collection("ManageCharacter")
        let documentRef = manageCharacterCollection.document(characterName)
        
        let dataToInit: [String: Any] = [
            "charName": character.charName ?? "",
            "chaosDungeon": false,
            "guardianRaid": false,
            "valtanRaid": false,
            "viakissRaid": false,
            "koukuRaid": false,
            "abrelRaid": false,
            "iliakanRaid": false,
            "kamenRaid": false,
            "abyssRaid": false,
            "abyssDungeon": false,
            "whatAbyssDungeon": character.whatAbyssDungeon ?? ""
        ]
        
        documentRef.updateData(dataToInit) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully!")
            }
        }
    }
    
    //  MARK: - CharacterInfoView
    func characterInfoView(label: String, value: String) -> some View {
        VStack{
            Text(label)
                .font(.system(size: 14))
            Text(value)
        }
        .padding(5)
        .frame(width: 80,height: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        
    }
    
    
    //MARK: - Contents Toggle
    
    struct ContentsToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                Spacer()
                configuration.label
                    .font(.title2)
                    .opacity(configuration.isOn ? 0.2 : 1)
                Spacer()
                Text(configuration.isOn ? "완료" : "미완")
                    .font(.title2)
                    .opacity(configuration.isOn ? 0.2 : 1)
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.gray.opacity(configuration.isOn ? 0.2 : 0.9))
            )
            .frame(width:400 ,height: 60)
                
        }
    }
    
}
