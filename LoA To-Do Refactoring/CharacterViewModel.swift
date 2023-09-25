//
//  CharacterViewModel.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/23.
//

import Foundation
import SwiftUI
import Firebase

enum CustomError: Error {
    case noDataOrResponse
    case jsonProcessingFailure
    case serverError
}

class CharacterViewModel: ObservableObject {
    @Published var characterProfiles: CharacterProfiles?
    @Published var characterImage: UIImage?
    
    struct ErrorResponse: Codable {
        let Code: Int
        let Description: String
    }
    
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
}
