//
//  CharacterSetting.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/18.
//

import Foundation

struct CharacterSetting: Codable {
    var charName: String = ""
    var charClass: String = ""
    var charLevel: String = ""
    var isGuardianRaid: Bool = false
    var isChaosDungeon: Bool = false
    var isValtanRaid: Bool = false
    var isViakissRaid: Bool = false
    var isKoukuRaid: Bool = false
    var isAbrelRaid: Bool = false
    var isIliakanRaid: Bool = false
    var isKamenRaid: Bool = false
    var isAbyssRaid: Bool = false
    var isAbyssDungeon: Bool = false
    var whatAbyssDungeon: String = ""
    
    init(data: [String: Any]) {
        if let charName = data["charName"] as? String,
           let charClass = data["charClass"] as? String,
           let charLevel = data["charLevel"] as? String,
           let isGuardianRaid = data["isGuardianRaid"] as? Bool,
           let isChaosDungeon = data["isChaosDungeon"] as? Bool,
           let isValtanRaid = data["isValtanRaid"] as? Bool,
           let isViakissRaid = data["isViakissRaid"] as? Bool,
           let isKoukuRaid = data["isKoukuRaid"] as? Bool,
           let isAbrelRaid = data["isAbrelRaid"] as? Bool,
           let isIliakanRaid = data["isIliakanRaid"] as? Bool,
           let isKamenRaid = data["isKamenRaid"] as? Bool,
           let isAbyssRaid = data["isAbyssRaid"] as? Bool,
           let isAbyssDungeon = data["isAbyssDungeon"] as? Bool,
           let whatAbyssDungeon = data["whatAbyssDungeon"] as? String
        {
            self.charName = charName
            self.charClass = charClass
            self.charLevel = charLevel
            self.isGuardianRaid = isGuardianRaid
            self.isChaosDungeon = isChaosDungeon
            self.isValtanRaid = isValtanRaid
            self.isViakissRaid = isViakissRaid
            self.isKoukuRaid = isKoukuRaid
            self.isAbrelRaid = isAbrelRaid
            self.isIliakanRaid = isIliakanRaid
            self.isKamenRaid = isKamenRaid
            self.isAbyssRaid = isAbyssRaid
            self.isAbyssDungeon = isAbyssDungeon
            self.whatAbyssDungeon = whatAbyssDungeon
        }
    }
    init(
            charName: String,
            charClass: String,
            charLevel: String,
            isGuardianRaid: Bool,
            isChaosDungeon: Bool,
            isValtanRaid: Bool,
            isViakissRaid: Bool,
            isKoukuRaid: Bool,
            isAbrelRaid: Bool,
            isIliakanRaid: Bool,
            isKamenRaid: Bool,
            isAbyssRaid: Bool,
            isAbyssDungeon: Bool,
            whatAbyssDungeon: String
        ) {
            self.charName = charName
            self.charClass = charClass
            self.charLevel = charLevel
            self.isGuardianRaid = isGuardianRaid
            self.isChaosDungeon = isChaosDungeon
            self.isValtanRaid = isValtanRaid
            self.isViakissRaid = isViakissRaid
            self.isKoukuRaid = isKoukuRaid
            self.isAbrelRaid = isAbrelRaid
            self.isIliakanRaid = isIliakanRaid
            self.isKamenRaid = isKamenRaid
            self.isAbyssRaid = isAbyssRaid
            self.isAbyssDungeon = isAbyssDungeon
            self.whatAbyssDungeon = whatAbyssDungeon
        }

}
