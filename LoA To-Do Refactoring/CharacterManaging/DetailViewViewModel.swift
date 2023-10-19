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
        isAbyssRaidDone: false,isAbyssDungeonDone: false
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
            "abyssDungeon": toDoInfo.isAbyssDungeonDone
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
    
    func loadDataFromFireStore() {
        let manageCharacterCollection = db.collection("ManageCharacter")
        
        let characterID = characterToDoInfo.charName ?? ""
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
                    
                }
            }
        }
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
