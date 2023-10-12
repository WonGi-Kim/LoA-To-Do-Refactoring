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
        
        let cellCollection = db.collection("ManageCharacter")
        let documentRef = cellCollection.document(charName)
        
        documentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully!")
                    }
                }
            } else {
                // 해당 캐릭터 이름을 가진 문서가 존재하지 않는 경우 생성
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully!")
                    }
                }
            }
        }
    }
}
