//
//  CharacterViewModel.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

enum CustomError: Error {
    case noDataOrResponse
    case jsonProcessingFailure
    case serverError
}

class CharacterViewModel: ObservableObject {
    @Published var characterProfiles: CharacterProfiles?
    @Published var characterImage: String = ""
    @Published var characterList: [CharacterSetting] = []
    
    //  캐릭터 최초 생성시 whatAbyssDungeon을 통해 isAbyssDungeon의 값을 설정하기 위해 생성
    @Published var newCharacter: CharacterSetting = CharacterSetting (
        charImage:"",
        charName: "", charClass: "",
        charLevel: "", isGuardianRaid: false,
        isChaosDungeon: false, isValtanRaid: false,
        isViakissRaid: false, isKoukuRaid: false,
        isAbrelRaid: false, isIliakanRaid: false,
        isKamenRaid: false, isAbyssRaid: false,
        isAbyssDungeon: false, whatAbyssDungeon: "")
    
    //  refreshable 에 사용될 캐릭터
    @Published var characterForUpdate: CharacterSetting = CharacterSetting(
        charImage:"",
        charName: "", charClass: "",
        charLevel: "", isGuardianRaid: false,
        isChaosDungeon: false, isValtanRaid: false,
        isViakissRaid: false, isKoukuRaid: false,
        isAbrelRaid: false, isIliakanRaid: false,
        isKamenRaid: false, isAbyssRaid: false,
        isAbyssDungeon: false, whatAbyssDungeon: "")
    
    //  Picker에 관련된 변수
    @Published var classArray: [String] = []
    @Published var abyssArray: [String] = []
    @Published var selectedCharacterClass: String = ""
    @Published var selectedAbyssDun: String = ""
    
    //  골드획득 컨텐츠 눌린 횟수
    @Published var goldCount: Int = 0
    
    //  UID변수
    @Published var uid: String = ""
    
    init() { //picker를 바로 사용하기 위해
        loadAbyssDun()
        loadClassNames()
    }
    
    struct ErrorResponse: Codable {
        let Code: Int
        let Description: String
    }
    
    //  MARK: - API 호출
    func getCharacterProfiles(characterName: String, completion: @escaping (Result<CharacterProfiles, Error>) -> Void) {
        let baseURLString = "https://developer-lostark.game.onstove.com/armories/characters/\(characterName)/profiles"

        if let url = URL(string: baseURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // 헤더 설정
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAyOTM2NDEifQ.C0xcwnZTK3MwikcL9Q9zAu4wHZnKxNJgo2f3zVnR27e2gXiVvqnLVEUvj2Ns2Mj3-XNKj9F0ume1pU_EZhGFQWz6KBnHmj3dOeROn28cC21wWBWrrwnaO8ANoE5rVhBzfBaIzb_QsXTBhCEM5lPStnjbE8fVS4ihRZTOi0LLTZfgpVe0Z3zYOL5MOfDXksr2vRgMeH00USOKBeU--bgwU-hwcadcuuYngoGLOsX0zKhow8Hxdecrd4d2_svM_Wd7ju1URsL9ne88LKOemHh_VxrDzQzzGByDlPc95q3-ceBSiT0b_ICWb7leMOMkURAhsoK5J3gV4k7SaEKmdVbmcw", forHTTPHeaderField: "Authorization")

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    // 네트워크 에러 처리
                    completion(.failure(error))
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    // 데이터나 응답이 없을 경우 처리
                    completion(.failure(CustomError.noDataOrResponse))
                    return
                }

                if (200..<300).contains(response.statusCode) {
                    // JSON 데이터를 "null"을 "nil"로 대체하여 전처리
                    if let processedData = self.preprocessJSONData(data) {
                        let decoder = JSONDecoder()
                        do {
                            let characterProfiles = try decoder.decode(CharacterProfiles.self, from: processedData)
                            completion(.success(characterProfiles))
                        } catch {
                            // 디코딩 에러 처리
                            print("Decoding Error:", error)
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(CustomError.jsonProcessingFailure))
                    }
                } else {
                    // 서버 에러 처리
                    print("Server Error:", response.statusCode)
                    if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        print("Error Message:", errorMessage)
                    }
                    completion(.failure(CustomError.serverError))
                }
            }
            dataTask.resume()
        }
    }
    
    // "null"을 "nil"로 대체하여 JSON 데이터를 전처리
    func preprocessJSONData(_ data: Data) -> Data? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            if var processedObject = preprocessJSONObject(jsonObject) {
                return try JSONSerialization.data(withJSONObject: processedObject)
            } else {
                return nil
            }
        } catch {
            print("JSON Preprocessing Error:", error)
            return nil
        }
    }

    // JSON 오브젝트를 재귀적으로 탐색하며 "null"을 "nil"로 대체
    func preprocessJSONObject(_ jsonObject: Any) -> Any? {
        if let array = jsonObject as? [Any] {
            return array.map { preprocessJSONObject($0) ?? NSNull() }
        } else if let dictionary = jsonObject as? [String: Any] {
            var processedDictionary = [String: Any]()
            dictionary.forEach { key, value in
                if let processedValue = preprocessJSONObject(value) {
                    processedDictionary[key] = processedValue
                }
            }
            return processedDictionary
        } else if jsonObject is NSNull {
            return nil
        } else {
            return jsonObject
        }
    }
    
    //  MARK: - characterUpdate
    //  DetailView에서 캐릭터를 갱신할 때 사용
    func updateCharacter(uid: String ,completion: @escaping() -> Void) {
        guard let encodeName = characterForUpdate.charName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        getCharacterProfiles(characterName: encodeName) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.characterForUpdate.charImage = data.CharacterImage ?? ""
                    self.characterForUpdate.charName = data.CharacterName ?? ""
                    self.characterForUpdate.charClass = data.CharacterClassName ?? ""
                    self.characterForUpdate.charLevel = data.ItemAvgLevel ?? ""
                            
                    self.saveDateForCreateCell(self.characterForUpdate, uid: uid)
                    completion() // 완료 콜백 호출
                }
            case .failure(let error):
                // 에러 처리
                print("API Error: \(error)")
            }
        }
    }
    
    //  MARK: - FireStore연동
    //  MARK: Cell 생성을 위한 저장
    let db = Firestore.firestore()
    
    func saveDateForCreateCell(_ characterList: CharacterSetting, uid: String) {
        let charName = characterList.charName
        
        let dataToUpdateAndSave: [String: Any] = [
            "charImage": characterList.charImage ?? "",
            "charName": characterList.charName ?? "",
            "charClass": characterList.charClass ?? "",
            "charLevel": characterList.charLevel ?? "",
            "isGuardianRaid": characterList.isGuardianRaid,
            "isChaosDungeon": characterList.isChaosDungeon,
            "isValtanRaid": characterList.isValtanRaid,
            "isViakissRaid": characterList.isViakissRaid,
            "isKoukuRaid": characterList.isKoukuRaid,
            "isAbrelRaid": characterList.isAbrelRaid,
            "isIliakanRaid": characterList.isIliakanRaid,
            "isKamenRaid": characterList.isKamenRaid,
            "isAbyssRaid": characterList.isAbyssRaid,
            "isAbyssDungeon": characterList.isAbyssDungeon,
            "whatAbyssDungeon": characterList.whatAbyssDungeon ?? ""
        ]
        
        let uidCollection = db.collection("UID").document(uid).collection("Cell")
        let documentRef = uidCollection.document(charName)
        /**
        let cellCollection = db.collection("Cells")
        let documentRef = cellCollection.document(charName)
         */
        documentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document for Cells updated successfully!")
                    }
                }
            } else {
                // 해당 캐릭터 이름을 가진 문서가 존재하지 않는 경우 생성
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document for Cells added successfully!")
                    }
                }
            }
        }
    }
    
    // MARK: Cell Data 가져오기
    func loadDataForCreateCell(uid: String) {
        let cellCollection = db.collection("UID").document(uid).collection("Cell")
        
        cellCollection.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            var characterList: [CharacterSetting] = []
            
            for document in documents {
                if let characterData = document.data() as? [String: Any] {
                    let character = CharacterSetting(data: characterData)
                    characterList.append(character)
                }
            }
            
            self.characterList = characterList
        }
    }
    
    //MARK: 리스트 삭제
    func removeCells(at offsets: IndexSet) {
        for index in offsets {
            let characterToRemove = characterList[index]
            removeCellsForFirestore(characterToRemove, uid: self.uid)
            removeManageCharacterInFireStore(characterToRemove, uid: self.uid)
        }
        
        characterList.remove(atOffsets: offsets)
    }
    
    func removeCellsForFirestore(_ character: CharacterSetting, uid: String) {

        let charName = character.charName
        
        let cellCollection = db.collection("UID").document(uid).collection("Cell")
        let documentRef = cellCollection.document(charName)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document in Cells deleted successfully!")
            }
        }
    }
    
    func removeManageCharacterInFireStore(_ character: CharacterSetting, uid: String) {
        let charName = character.charName
        
        let manageCharacterCollection = db.collection("UID").document(uid).collection("ManageCharacter")
        let documentRef = manageCharacterCollection.document(charName)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document in ManageCharacter deleted successfully!")
            }
        }
    }

    //MARK: - Toggle 스타일
    struct DailyToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    configuration.label
                        .font(.title2)
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Spacer()
                }
                .frame(width: geometry.size.width)
            }
            .frame(height: 40)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
    
    struct CommanderToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    configuration.label
                        .font(.title2)
                        .fixedSize()
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Spacer()
                }
                .frame(width: (geometry.size.width))
            }
            .frame(height: 30)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
    
    //MARK: - Plist Control
    func loadClassNames() {
        if let plistPath = Bundle.main.path(forResource: "CharacterClass", ofType: "plist"),
              let charClassData = FileManager.default.contents(atPath: plistPath),
              let charClassArray = try? PropertyListSerialization.propertyList(from: charClassData, format: nil) as? [[String: Any]] {
                    classArray = charClassArray.compactMap { $0["className"] as? String}
                    selectedCharacterClass = classArray.first ?? ""
              }
        
    }
    
    func loadAbyssDun() {
        if let plistPath = Bundle.main.path(forResource: "AbyssList", ofType: "plist"),
           let abyssDunData = FileManager.default.contents(atPath: plistPath),
           let abyssDunArray = try? PropertyListSerialization.propertyList(from: abyssDunData, format: nil) as? [[String: Any]] {
                abyssArray = abyssDunArray.compactMap { $0["dunName"] as? String }
                selectedAbyssDun = abyssArray.first ?? ""
            }
    }
    
    func updateIsAbyssDungeonValue() {
        if newCharacter.whatAbyssDungeon == "--선택안함--" {
            newCharacter.isAbyssDungeon = false
        } else {
            newCharacter.isAbyssDungeon = true
        }
    }
    
    
    
}
